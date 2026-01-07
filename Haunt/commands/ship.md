# Ship (Create PR and Merge)

Complete the commit-PR-merge-banish cycle for feature branch work.

## Usage

```bash
/ship                 # Ship current feature branch
/ship --draft         # Create draft PR
/ship --no-pr         # Merge directly without PR (fast path)
```

## Arguments: $ARGUMENTS

### Prerequisites Check

Before proceeding, verify:

1. **On feature branch**: Must be on `feature/REQ-XXX-*` branch
2. **Tests passing**: Run `bash Haunt/scripts/haunt-run.sh test`
3. **Changes committed**: No uncommitted changes
4. **REQ exists in roadmap**: Requirement must be in `.haunt/plans/roadmap.md`

**If any check fails, STOP and report the issue.**

### Parse Arguments

```python
import sys

args = "$ARGUMENTS".strip()
is_draft = "--draft" in args
no_pr = "--no-pr" in args

# Remove flags for any remaining args
args = args.replace("--draft", "").replace("--no-pr", "").strip()
```

### Step 1: Verify Current Branch

```bash
# Get current branch
current_branch=$(git branch --show-current)

# Verify it's a feature branch
if [[ ! "$current_branch" =~ ^feature/REQ-[0-9]+-.*$ ]]; then
    echo "ERROR: Not on a feature branch (current: $current_branch)"
    echo "Expected format: feature/REQ-XXX-slug"
    echo ""
    echo "To create a feature branch:"
    echo "  git checkout -b feature/REQ-XXX-your-feature-name"
    exit 1
fi

# Extract REQ-XXX from branch name
req_id=$(echo "$current_branch" | grep -oE 'REQ-[0-9]+')

echo "📦 Shipping $req_id from branch $current_branch"
```

### Step 2: Run Tests

```bash
echo ""
echo "🧪 Running tests..."
if ! bash Haunt/scripts/haunt-run.sh test; then
    echo ""
    echo "❌ Tests failed. Cannot ship."
    echo "Fix failing tests before shipping."
    exit 1
fi

echo "✅ Tests pass"
```

### Step 3: Check for Uncommitted Changes

```bash
echo ""
echo "🔍 Checking for uncommitted changes..."

if [[ -n $(git status --porcelain) ]]; then
    echo ""
    echo "⚠️ Uncommitted changes detected:"
    git status --short
    echo ""
    echo "Options:"
    echo "  1. git add -A && git commit -m \"[${req_id}] Final changes before ship\""
    echo "  2. git stash (if changes are experimental)"
    exit 1
fi

echo "✅ Working directory clean"
```

### Step 4: Extract Requirement Data from Roadmap

```bash
echo ""
echo "📋 Extracting requirement data..."

# Use grep to extract requirement section
req_data=$(grep -A 30 "^#####.*$req_id:" .haunt/plans/roadmap.md)

if [[ -z "$req_data" ]]; then
    echo "❌ $req_id not found in roadmap"
    exit 1
fi

# Extract title (remove status icon and REQ-XXX prefix)
title=$(echo "$req_data" | grep "^#####" | sed 's/^#####.*REQ-[0-9]*: //')

# Extract type (Enhancement, Bug Fix, etc.)
type=$(echo "$req_data" | grep "^\*\*Type:\*\*" | sed 's/^\*\*Type:\*\* //')

# Extract effort (XS, S, M)
effort=$(echo "$req_data" | grep "^\*\*Effort:\*\*" | sed 's/^\*\*Effort:\*\* //')

# Extract agent (Dev-Backend, Dev-Frontend, Dev-Infrastructure)
agent=$(echo "$req_data" | grep "^\*\*Agent:\*\*" | sed 's/^\*\*Agent:\*\* //')

echo "✅ Found: $req_id: $title"
echo "   Type: $type | Effort: $effort | Agent: $agent"
```

### Step 5A: Fast Path (--no-pr)

If `--no-pr` flag is present, skip PR creation and merge directly:

```bash
if [[ "$no_pr" == "true" ]]; then
    echo ""
    echo "⚡ Fast path: Merging directly to main..."

    # Checkout main
    git checkout main || exit 1

    # Merge feature branch (squash)
    git merge --squash "$current_branch" || {
        echo "❌ Merge conflict. Resolve and try again."
        exit 1
    }

    # Commit with proper format
    git commit -m "$req_id: $title

Type: $type
Effort: $effort
Agent: $agent

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>" || exit 1

    # Push to remote
    git push origin main || exit 1

    # Delete feature branch
    git branch -D "$current_branch"
    git push origin --delete "$current_branch" 2>/dev/null || true

    echo "✅ Merged to main and deleted feature branch"

    # Skip to Step 6 (Banish)
    goto_step_6
fi
```

### Step 5B: PR Creation Path

```bash
echo ""
echo "📝 Generating PR body..."

# Generate PR body using roadmap data
pr_body=$(cat <<EOF
## $req_id: $title

**Type:** $type
**Effort:** $effort
**Agent:** $agent

### Changes

$(echo "$req_data" | sed -n '/^\*\*Tasks:\*\*/,/^\*\*Files:\*\*/p' | grep '^ *- \[x\]' | sed 's/^ *- \[x\] /- /')

### Files Modified

$(echo "$req_data" | sed -n '/^\*\*Files:\*\*/,/^\*\*Effort:\*\*/p' | grep '^ *- `' | sed 's/^ *//')

### Completion Criteria

$(echo "$req_data" | sed -n '/^\*\*Completion:\*\*/p' | sed 's/^\*\*Completion:\*\* //')

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
EOF
)

# Create PR title
pr_title="$req_id: $title"

echo "✅ PR body generated"
```

### Step 5C: Create PR

```bash
echo ""
if [[ "$is_draft" == "true" ]]; then
    echo "📝 Creating draft PR..."
    gh pr create --title "$pr_title" --body "$pr_body" --draft || {
        echo "❌ Failed to create draft PR"
        exit 1
    }
    pr_url=$(gh pr view --json url -q .url)
    echo "✅ Draft PR created: $pr_url"
else
    echo "📝 Creating PR..."
    gh pr create --title "$pr_title" --body "$pr_body" --base main || {
        echo "❌ Failed to create PR"
        echo ""
        echo "Common issues:"
        echo "  - gh CLI not authenticated: gh auth login"
        echo "  - Remote branch not pushed: git push -u origin $current_branch"
        exit 1
    }

    pr_url=$(gh pr view --json url -q .url)
    pr_number=$(gh pr view --json number -q .number)

    echo "✅ PR created: $pr_url"

    # Update roadmap with Branch and PR fields
    echo ""
    echo "📝 Updating roadmap with branch/PR info..."

    # Add Branch field if not present
    if ! grep -q "^\*\*Branch:\*\*" <<< "$req_data"; then
        sed -i '' "/^#####.*$req_id:/,/^#####/{
            /^\*\*Blocked by:\*\*/a\\
**Branch:** $current_branch\\
**PR:** #$pr_number (auto-merge enabled)
        }" .haunt/plans/roadmap.md
    fi

    echo "✅ Roadmap updated with branch/PR info"

    # Enable auto-merge if repository supports it
    echo ""
    echo "🔄 Enabling auto-merge..."

    if gh pr merge --auto --squash --delete-branch 2>/dev/null; then
        echo "✅ Auto-merge enabled (will merge when checks pass)"
    else
        echo "⚠️ Auto-merge not available (manual merge required)"
        echo "   Repository may not have auto-merge enabled in settings"
    fi
fi
```

### Step 6: Post-Ship Cleanup

```bash
echo ""
echo "🧹 Checking out main and pulling latest..."

# Checkout main
git checkout main || exit 1

# Pull latest (in case PR already merged)
git pull origin main || exit 1

echo "✅ Main branch updated"
```

### Step 7: Trigger Banish

```bash
echo ""
echo "⚰️ Banishing $req_id..."

# Call /banish for this requirement
/banish "$req_id"
```

### Success Report

```bash
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚢 Ship complete!"
echo ""
echo "   Requirement: $req_id"
echo "   Branch: $current_branch"
if [[ "$no_pr" == "true" ]]; then
    echo "   Merged: Directly to main (fast path)"
else
    echo "   PR: $pr_url"
    if [[ "$is_draft" == "true" ]]; then
        echo "   Status: Draft PR created"
    else
        echo "   Status: PR created with auto-merge enabled"
    fi
fi
echo "   Archived: Sent to .haunt/completed/"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
```

## Error Handling

| Error Condition | Message | Action |
|----------------|---------|--------|
| Not on feature branch | "Not on a feature branch (current: {branch})" | Exit with instructions to create feature branch |
| Tests failing | "Tests failed. Cannot ship." | Exit with instruction to fix tests |
| Uncommitted changes | "Uncommitted changes detected" | Exit with commit/stash options |
| REQ not in roadmap | "{REQ-XXX} not found in roadmap" | Exit |
| gh CLI not authenticated | "Failed to create PR" | Exit with `gh auth login` instruction |
| Merge conflict | "Merge conflict. Resolve and try again." | Exit (manual resolution needed) |

## Ghost County Flavor

Success messages use themed language:
- "📦 Shipping REQ-XXX from branch {name}"
- "🚢 Ship complete! The spirit has crossed over."
- "⚰️ Banishing complete. The haunting is resolved."

## See Also

- `/banish` - Archive completed requirements
- `/seance --summon` - Create feature branches and spawn agents
- `Haunt/docs/git-integration-research.md` - Full PR workflow specification
- `.claude/rules/gco-commit-conventions.md` - Commit message format
