# Haunt Framework Roadmap

> Single source of truth for project work items. See `.haunt/completed/` for archived work.

---

## Current Focus

**Status:** REQ-372 complete. Ready for archival.

**Completed:** REQ-372 - E2E Test Reminder for UI Work

---

## Active Work

### {🟢} REQ-372: Add E2E Test Reminder for UI Work Completion

**Type:** Enhancement
**Reported:** 2026-01-05
**Completed:** 2026-01-05
**Source:** Process failure analysis - Batch 7 hierarchical subtasks shipped without E2E tests
**Description:** Agents implementing UI features are not consistently creating E2E tests before marking work complete. The `gco-ui-testing` skill is opt-in (agents must remember to invoke it), and there's no verification between "agent marks 🟢" and "code commits". Need enforcement mechanism to remind/block agents.

**Root Cause:**
1. `gco-ui-testing` is a skill (opt-in), not a rule (auto-loaded)
2. Mode gates in agent character sheets are advisory, not enforced
3. Pre-commit hooks only fire at commit time, not when agents mark tasks complete

**Tasks:**
- [x] Create slim rule `gco-ui-testing-reminder.md` that auto-loads for all agents
- [x] Rule triggers when: agent is in Frontend Mode AND marking work 🟢
- [x] Rule reminds: "UI work requires E2E tests. Have you run `npx playwright test`?"
- [x] Deploy to ~/.claude/rules/ (rules auto-load, no agent modification needed)

**Files:**
- `Haunt/rules/gco-ui-testing-reminder.md` (created)

**Effort:** S
**Complexity:** SIMPLE
**Agent:** Dev-Infrastructure
**Completion:** ✓ Rule deployed to `~/.claude/rules/gco-ui-testing-reminder.md`
**Blocked by:** None

---

## Summary

| Status | Count | Requirements |
|--------|-------|--------------|
| 🟢 Complete (Archived) | 56 | See `.haunt/completed/2026-01/` |
| 🟢 Complete (Ready to Archive) | 1 | REQ-372 |
| ⚪ Not Started | 0 | - |
| 🟡 In Progress | 0 | - |

---

## Recent Archives

- **2026-01-05:** Damage Control Hooks (7 requirements) → `damage-control-hooks.md`
- **2026-01-05:** Secrets Management Core (6 requirements) → `secrets-management-batch1.md`
- **2026-01-05:** Skill Compression Séance (15 requirements) → `skill-compression-seance.md`
- **2026-01-03:** Various batches (28 requirements) → See `2026-01/`
