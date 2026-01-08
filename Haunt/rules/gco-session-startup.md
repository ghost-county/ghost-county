# Session Startup Protocol

## 6-Step Assignment Lookup

When starting a session, check IN ORDER:

1. **Session Handoff** - Check `.haunt/state/continue-here.md` for explicit resume point → If exists and recent, resume from there
2. **Direct Assignment** - User explicitly assigned work in message → Proceed immediately
3. **Active Work** - CLAUDE.md lists work for your agent type → Proceed with that work
4. **Roadmap** - Use `bash Haunt/scripts/haunt-roadmap.sh list --agent=YourType` → Update to 🟡, proceed
5. **Branch Check** - Verify current branch matches assigned work → Prompt to checkout if mismatch
6. **Ask PM** - No assignment found in 1-4 → STOP and ask "No assignment found. What should I work on?"

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

## Session Handoff File

### When to Check

**On every session startup**, check `.haunt/state/continue-here.md`:

```bash
# Check if handoff file exists and is recent
ls -la .haunt/state/continue-here.md
```

**If file exists and was updated within last 24 hours:**
- Read handoff file for explicit resume point
- Verify requirement matches your agent assignment
- Resume from documented position
- Clear/archive handoff file after resuming

**If file is stale (>24 hours old):**
- Ignore it (treat as outdated)
- Follow normal assignment lookup (steps 2-6)
- Consider archiving old handoff

### When to Generate

**Auto-generate continue-here.md when ALL conditions are met:**
1. Session is ending (user signals wrap-up or timeout approaching)
2. Work is incomplete (status is 🟡 In Progress or 🔴 Blocked)
3. Tasks remain unchecked (at least one `- [ ]` in requirement)
4. Resumption context would be valuable (multi-session work expected)

**DO NOT generate when:**
- Work is complete (status 🟢)
- All tasks checked off
- Single-session work (XS requirements)
- Handing off to different agent type (not resuming same work)

### What to Include

**Required fields:**
- Requirement ID and title
- Current status (🟡 or 🔴)
- Completed vs remaining tasks
- Exact next step (< 5 min action)
- Files being modified
- Uncommitted changes (yes/no)

**Recommended fields:**
- Decisions made (why X over Y)
- What was tried and failed
- Known blockers/gotchas
- Mental context (where you were in the code)
- Test status (passing/failing)

**Template location:** `.haunt/state/continue-here.md`

### Example Generation Workflow

```markdown
# Session ending with incomplete work
Agent detects: REQ-042 is 🟡, 2 of 4 tasks complete

# Auto-generate handoff
1. Copy template from .haunt/state/continue-here.md
2. Fill in requirement details
3. Document progress and next step
4. Note any blockers or decisions
5. Save with timestamp
6. Inform user: "Session handoff saved to .haunt/state/continue-here.md"
```

## When to Invoke Full Skill

For complex scenarios (broken tests, multi-session features, story files, batch loading, Explore reconnaissance):

**Invoke:** `gco-session-startup` skill

## Non-Negotiable

- NEVER skip steps in the 6-step sequence
- NEVER read full roadmap when grep works
- NEVER start work without identifying REQ-XXX
- ALWAYS check for continue-here.md on session startup
- ALWAYS generate continue-here.md when ending with incomplete work
