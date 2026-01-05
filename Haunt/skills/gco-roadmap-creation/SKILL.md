---
name: gco-roadmap-creation
description: Transform requirements into roadmap items. Phase 3 of idea-to-roadmap workflow.
---

# Roadmap Creation

**Inputs:** requirements-document.md, requirements-analysis.md
**Output:** `.haunt/plans/roadmap.md` (append)

## Step 1: Check Existing Roadmap

- Note highest REQ number (continue from there)
- Identify in-progress work (don't conflict)
- Map existing dependencies

## Step 2: Break Down L/XL Items

**Rule:** All roadmap items must be S (1-4 hrs) or M (4-8 hrs).

| Original | Break Into |
|----------|------------|
| L (1-2 wks) | 3-5 M or 5-8 S |
| XL (2+ wks) | Multiple L first, then break those |

**Breakdown by:** Layer (DB→Backend→API→Frontend), Feature slice, Component, Risk

## Step 3: Map Dependencies

| New REQ | Depends On | Blocks |
|---------|------------|--------|
| REQ-050 | None | REQ-051 |
| REQ-051 | REQ-050 | REQ-053 |

## Step 4: Organize Batches

**Same batch (parallel):** No dependencies, different files, different agents
**Separate batches:** Has blockers, same file, must verify first

## Step 5: Assign Agents

| Agent | Assign When |
|-------|-------------|
| Dev-Backend | APIs, services, database |
| Dev-Frontend | UI, components, client state |
| Dev-Infrastructure | IaC, CI/CD, deployment |
| Research | Spikes, unknowns, evaluations |

## Step 6: Write Completion Criteria

**Bad:** "Works correctly", "User can login"
**Good:** "POST /api/register returns 201 with user object"

## Roadmap Item Template

```markdown
⚪ REQ-XXX: [Action-oriented title]
   Tasks:
   - [ ] [Specific task 1]
   - [ ] [Specific task 2]
   Files: path/to/file.py, path/to/file2.py
   Effort: S | M
   Agent: Dev-Backend | Dev-Frontend | Dev-Infrastructure
   Completion: [Specific, testable criteria]
   Blocked by: REQ-XXX | None
```

## Status Icons

| Icon | Meaning |
|------|---------|
| ⚪ | Not Started |
| 🟡 | In Progress |
| 🟢 | Complete |
| 🔴 | Blocked |

## Anti-Patterns

| Anti-Pattern | Fix |
|--------------|-----|
| L/XL in roadmap | Break down further |
| Missing "Blocked by" | Always state or "None" |
| Vague paths ("backend files") | Specific: `src/api/auth.py` |
| Untestable completion | Specific outcome, not "works" |

## Quality Checklist

- [ ] All items S or M
- [ ] REQ numbers continue sequence
- [ ] Dependencies mapped
- [ ] Batches organized
- [ ] Agents assigned
- [ ] Completion criteria testable
