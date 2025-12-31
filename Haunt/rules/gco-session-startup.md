# Session Startup Protocol

## Assignment Lookup (Steps 1-4)

When starting a session or looking for work, follow this sequence IN ORDER:

### Step 1: Check for Direct Assignment

Did the user explicitly assign you work in their message?
- "Implement REQ-109"
- "Fix the authentication bug"
- "You are a Dev-Infrastructure agent. Implement REQ-109."

**YES** → Proceed immediately
**NO** → Continue to Step 2

### Step 2: Check Active Work Section

Read CLAUDE.md Active Work section (already in context):
- Items with "Agent:" field matching your agent type
- Status 🟡 In Progress assigned to you

**If found:** Proceed with that work
**If empty/no match:** Continue to Step 3

### Step 3: Check Roadmap (Use Structured Wrapper)

**WRONG:**
```bash
Read(.haunt/plans/roadmap.md)  # Reads 1,647 lines
```

**RIGHT (Structured JSON):**
```bash
# Find your agent type's assignments (returns JSON):
bash Haunt/scripts/haunt-roadmap.sh list --agent=Dev-Backend

# Find unstarted items (returns JSON):
bash Haunt/scripts/haunt-roadmap.sh list --status=⚪

# Extract specific requirement (returns JSON):
bash Haunt/scripts/haunt-roadmap.sh get REQ-XXX
```

**ALTERNATIVE (Direct grep if wrapper unavailable):**
```bash
# Find your agent type's assignments:
grep -B 5 "Agent: Dev-Backend" .haunt/plans/roadmap.md

# Extract specific requirement:
grep -A 30 "REQ-XXX" .haunt/plans/roadmap.md
```

**If found:** Update status to 🟡, proceed with work
**If nothing found:** Continue to Step 4

### Step 4: Ask Project Manager

Only reach this step if Steps 1-3 found nothing.
**Then:** STOP and ask "No assignment found. What should I work on?"

## Targeted File Access

**Principle:** Use grep/head instead of full file reads when you only need specific info.

| Scenario | Full Read | Targeted Read | Savings |
|----------|-----------|---------------|---------|
| Find assignment in roadmap | 1,647 lines | 30 lines | 98% |
| Check REQ status | 1,647 lines | 30 lines | 98% |
| Get config values | 84 lines | 5 lines | 94% |

**When to use full Read():**
- File is small (<100 lines)
- Need complete overview (new file, major refactor)
- Need to understand entire structure

## Assignment Identification

Before starting work, you MUST be able to answer:
- What requirement am I working on? (REQ-XXX)
- What are the completion criteria?
- Are there any blockers?

## Non-Negotiable

- NEVER ask PM for work if assignment exists in Steps 1-3
- NEVER skip steps in the sequence
- NEVER start work without identifying REQ-XXX
- NEVER read full roadmap when targeted grep works
