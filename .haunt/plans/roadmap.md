# Haunt Framework Roadmap

> Single source of truth for project work items. See `.haunt/completed/roadmap-archive.md` for completed/archived work.

---

## Current Focus

**Active Work:**
- None (all current work complete!)

**Recently Archived (2026-01-02):**
- 🟢 REQ-307: Model Selection (Opus for planning/research, Sonnet for implementation)
- 🟢 REQ-297-306: Env Secrets Wrapper (1Password integration, shell + Python)
- 🟢 REQ-283-285: Skill Token Optimization (requirements-analysis, code-patterns, task-decomposition)

---

## Backlog: Workflow Enforcement

### 🟡 REQ-308: Seance Workflow State Enforcement

**Type:** Enhancement
**Reported:** 2026-01-02
**Source:** User pain point - orchestrator drifts from planning to implementation mid-seance

**Description:** Implement state file + spawn-time context injection to prevent orchestrator from breaking out of seance workflow phases. Currently, after 15+ conversation turns, instruction degradation causes the model to skip the roadmap creation and user approval gates, jumping directly to implementation.

**Tasks:**

- [x] Create `.haunt/state/` directory initialization in seance startup
- [x] Implement phase state file (`.haunt/state/current-phase.txt`) with SCRYING/SUMMONING/BANISHING values
- [x] Add phase context injection to PM spawn prompts ("You are in SCRYING phase...")
- [x] Add phase context injection to dev agent spawn prompts ("You are in SUMMONING phase...")
- [x] Add phase transition validation before spawning dev agents (check user approval)
- [x] Update gco-orchestrator skill with phase declaration pattern
- [x] Add violation self-check before Edit/Write tool calls
- [ ] Test with 5 trial seances across different modes

**Files:**

- `Haunt/skills/gco-orchestrator/SKILL.md` (modify - add phase management section)
- `Haunt/skills/gco-orchestrator/references/mode-workflows.md` (modify - add phase transitions)
- `Haunt/commands/seance.md` (modify - initialize state file)

**Effort:** M
**Complexity:** MODERATE
**Agent:** Dev-Infrastructure
**Completion:** Seance workflows complete all 3 phases without orchestrator doing direct implementation. User approval gate is never skipped. State file correctly tracks phase transitions.
**Blocked by:** None

**Research:** See `.haunt/docs/research/workflow-enforcement-analysis.md` for root cause analysis and implementation spec.

---

## Backlog: Visual Documentation

⚪ REQ-228: Create Séance Workflow Infographic (Agent: Dev-Infrastructure, S)
⚪ REQ-229: Create Agent Coordination Diagram (Agent: Dev-Infrastructure, S)
⚪ REQ-230: Create Session Startup Protocol Diagram (Agent: Dev-Infrastructure, S)

---

## Backlog: CLI Improvements

⚪ REQ-231: Implement /haunt status --batch Command (Agent: Dev-Infrastructure, M)
⚪ REQ-232: Add Effort Estimation to Batch Status (Agent: Dev-Infrastructure, S, blocked by REQ-231)

---

## Backlog: GitHub Integration

⚪ REQ-205: GitHub Issues Integration (Research-Analyst → Dev-Infrastructure)
⚪ REQ-206: Create /bind Command (Dev-Infrastructure)

---
