# Session Startup Protocol

## 5-Step Assignment Lookup

When starting a session, check IN ORDER:

1. **Direct Assignment** - User explicitly assigned work in message → Proceed immediately
2. **Active Work** - CLAUDE.md lists work for your agent type → Proceed with that work
3. **Roadmap** - Use `bash Haunt/scripts/haunt-roadmap.sh list --agent=YourType` → Update to 🟡, proceed
4. **Branch Check** - Verify current branch matches assigned work → Prompt to checkout if mismatch
5. **Ask PM** - No assignment found in 1-3 → STOP and ask "No assignment found. What should I work on?"

## Targeted File Access

Use grep/scripts instead of full file reads:

```bash
# Find assignment (JSON output):
bash Haunt/scripts/haunt-roadmap.sh list --agent=Dev-Backend

# Extract specific requirement:
bash Haunt/scripts/haunt-roadmap.sh get REQ-XXX

# Or direct grep:
grep -A 30 "REQ-XXX" .haunt/plans/roadmap.md
```

**Savings:** 98% token reduction (30 lines vs 1,647 lines)

## Branch-Aware Workflow

After identifying assignment (steps 1-3), verify branch matches assigned work:

```bash
# Get current branch
bash Haunt/scripts/haunt-git.sh branch-current

# If assignment is REQ-XXX, find associated branch
bash Haunt/scripts/haunt-git.sh branch-for-req REQ-XXX
```

### Branch Verification Rules

**If on feature/REQ-XXX branch:**
- Extract REQ from branch name
- Verify it matches assigned requirement
- If mismatch → Ask user to clarify which work to proceed with

**If on main branch:**
- Check if assigned REQ has associated feature branch
- If branch exists → Prompt: "Found branch feature/REQ-XXX-{slug} for this work. Checkout? [yes/no]"
- If user confirms → `git checkout feature/REQ-XXX-{slug}`
- If no branch exists → Continue on main (branch may be created later)

**If on unrelated feature branch:**
- Prompt: "Currently on {current-branch} but assigned {REQ-XXX}. Switch to correct branch? [yes/no]"
- If branch for REQ-XXX exists → Offer to checkout
- If no branch exists → Offer to create one or continue on main

## When to Invoke Full Skill

For complex scenarios (broken tests, multi-session features, story files, batch loading, Explore reconnaissance):

**Invoke:** `gco-session-startup` skill

## Non-Negotiable

- NEVER skip steps in the 4-step sequence
- NEVER read full roadmap when grep works
- NEVER start work without identifying REQ-XXX
