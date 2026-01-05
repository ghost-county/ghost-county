# Git Push

Commit all changes and push to remote.

## Usage

```bash
/git-push
/git-push "Custom commit message"
```

## Workflow

**Step 1: Gather Context (parallel)**

Run these commands simultaneously:
- `git status` - See all changes
- `git diff --stat` - See what changed
- `git log --oneline -5` - Recent commit style

**Step 2: Stage Changes**

```bash
git add -A
```

**Step 3: Commit**

Draft a concise commit message based on the changes. If user provided a message in args, use that instead.

Follow the repository's commit style from Step 1.

```bash
git commit -m "$(cat <<'EOF'
[Commit message here]

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

**Step 4: Push**

```bash
git push
```

If no upstream is set:
```bash
git push -u origin HEAD
```

## Rules

- NEVER force push to main/master
- NEVER skip hooks unless user explicitly requests
- NEVER commit .env files or secrets
- If nothing to commit, say so and stop
- If push fails due to diverged branches, ask user before proceeding

## Output

Report:
1. What was committed (brief summary)
2. Commit hash
3. Push status (success/failure)
