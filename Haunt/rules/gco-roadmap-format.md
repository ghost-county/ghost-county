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

**Files:**
- `path/to/file.ext` (create | modify)

**Effort:** XS | S | M | SPLIT
**Complexity:** SIMPLE | MODERATE | COMPLEX | UNKNOWN
**Agent:** [Agent type]
**Completion:** [Testable criteria]
**Blocked by:** [REQ-XXX or "None"]
```

## Status Icons

| Icon | Meaning |
|------|---------|
| ⚪ | Not Started |
| 🟡 | In Progress |
| 🟢 | Complete |
| 🔴 | Blocked |

## Sizing (One Sitting Rule)

| Size | Time | Files | Lines |
|------|------|-------|-------|
| XS | 30min-1hr | 1-2 | <50 |
| S | 1-2hr | 2-4 | 50-150 |
| M | 2-4hr | 4-8 | 150-300 |
| SPLIT | >4hr | >8 | >300 (decompose) |

## When to Invoke Full Skill

For batch organization, dependency management, Active Work section management, and archiving workflows:

**Invoke:** `gco-roadmap-format` skill

## Non-Negotiable

- NEVER skip required fields
- NEVER allow SPLIT-sized work (decompose first)
- NEVER exceed 500 lines in roadmap.md (archive)
