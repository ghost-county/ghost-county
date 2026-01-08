# Roadmap Format (Slim Reference)

## Requirement Template

```markdown
### {🟡} REQ-XXX: [Action-oriented title]

**Type:** Enhancement | Bug Fix | Documentation | Research
**Reported:** YYYY-MM-DD
**Source:** [Origin]
**Description:** [What needs to be done]

**Tasks:**
- [ ] Specific task 1
- [ ] Specific task 2
- [ ] Specific task 3 (2-4 tasks recommended)

**Files:**
- `path/to/file.ext` (create | modify)

**Effort:** XS | S | M | SPLIT
**Complexity:** SIMPLE | MODERATE | COMPLEX | UNKNOWN
**Agent:** [Agent type]
**Completion:** [Testable criteria]
**Blocked by:** [REQ-XXX or "None"]
**Branch:** [feature/REQ-XXX-description] (optional)
**PR:** [#123 (status)] (optional)
```

## Status Icons

| Icon | Meaning |
|------|---------|
| ⚪ | Not Started |
| 🟡 | In Progress |
| 🟢 | Complete |
| 🔴 | Blocked |

## Optional Workflow Fields

### Branch Field
Track feature branch name when using branch-based workflow:

**Format:** `**Branch:** feature/REQ-XXX-description`

**Examples:**
- `**Branch:** feature/REQ-042-dark-mode`
- `**Branch:** fix/REQ-089-login-redirect`
- `**Branch:** docs/REQ-123-api-guide`

**When to add:** When creating feature branch for requirement work

### PR Field
Track pull request number and status:

**Format:** `**PR:** #123 (status)`

**Examples:**
- `**PR:** #456 (draft)`
- `**PR:** #457 (ready for review)`
- `**PR:** #458 (approved)`
- `**PR:** #459 (auto-merge enabled)`

**When to add:** When pull request created via `/ship` command

**Notes:**
- Both fields are **optional** - requirements without branches/PRs remain valid
- Existing requirements do NOT need these fields added retroactively
- Useful for tracking workflow state without leaving roadmap context

## Task Limits

**Recommended:** 2-4 tasks per requirement

**Rationale:**
- Forces atomic, completable units of work
- Each task should be completable in one commit
- Natural context boundaries prevent scope creep
- Requirements with >4 tasks likely need decomposition

**Validation:** haunt-roadmap.sh warns when >4 tasks detected

## Sizing (One Sitting Rule)

| Size | Time | Files | Lines | Tasks |
|------|------|-------|-------|-------|
| XS | 30min-1hr | 1-2 | <50 | 2-3 |
| S | 1-2hr | 2-4 | 50-150 | 2-4 |
| M | 2-4hr | 4-8 | 150-300 | 3-4 |
| SPLIT | >4hr | >8 | >300 (decompose) | >4 (decompose) |

## When to Invoke Full Skill

For batch organization, dependency management, Active Work section management, and archiving workflows:

**Invoke:** `gco-roadmap-format` skill

## Non-Negotiable

- NEVER skip required fields
- NEVER allow SPLIT-sized work (decompose first)
- NEVER exceed 500 lines in roadmap.md (archive)
- NEVER exceed 4 tasks per requirement (triggers SPLIT warning)
