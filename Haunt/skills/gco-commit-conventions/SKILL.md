---
name: gco-commit-conventions
description: Advanced commit scenarios - WIP tracking, multi-requirement commits, breaking changes, and special git operations. Invoke for complex commit scenarios beyond basic format.
---

# Commit Conventions - Advanced Scenarios

> **Note:** For basic commit format, see `.claude/rules/gco-commit-conventions.md`

## Work-in-Progress Commits

**Format:**
```
[REQ-XXX] Action: Brief description

What was done:
- Completed change 1
- Completed change 2

Next steps:
- What remains

Status: IN_PROGRESS | BLOCKED

🤖 Generated with Claude Code
```

**Rules:** Use Status only when incomplete. "Next steps" required for IN_PROGRESS/BLOCKED. WIP commits must still pass tests.

## Multi-Requirement Commits

**Format:**
```
[REQ-XXX, REQ-YYY] Action: Brief description

What was done:
- REQ-XXX: Change for first requirement
- REQ-YYY: Change for second requirement

🤖 Generated with Claude Code
```

**Rules:** Only when changes are TRULY interdependent. Max 2-3 requirements. Update roadmap for ALL requirements. Don't batch unrelated changes.

## Breaking Changes

**Format:**
```
[REQ-XXX] BREAKING: Brief description

What was done:
- Changed API/interface detail
- Updated dependent code

BREAKING CHANGE:
Previous: <what used to work>
New: <what works now>
Migration: <how to update>

🤖 Generated with Claude Code
```

**Rules:** Use BREAKING: prefix. Document migration. Update ALL dependent code in same commit. Notify team.

## Special Commits

| Type | Format |
|------|--------|
| **Merge** | `Merge branch 'feature/REQ-XXX' into main` (auto) + structured body |
| **Release** | `[RELEASE] v1.2.0: Description` + list of included REQ-XXX |
| **Skip CI** | `[REQ-XXX] Docs: Description [skip ci]` (docs-only, end of line) |

## Git Operations

**Undo before push:** `git reset --soft HEAD~1` (keep changes) or `git reset --hard HEAD~1` (discard)
**Undo after push:** `git revert HEAD` (safe)
**Amend hook changes:** `git add -u && git commit --amend --no-edit` (only if not pushed)

**Non-Negotiable:** Never force push to main/master. Never amend pushed commits. Communicate before destructive operations.
