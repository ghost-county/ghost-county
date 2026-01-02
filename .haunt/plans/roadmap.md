# Haunt Framework Roadmap

> Single source of truth for project work items. See `.haunt/completed/roadmap-archive.md` for completed/archived work.

---

## Current Focus

**Active Work:**
- None (all current work complete!)

**Recently Archived (2025-12-31):**
- 🟢 REQ-287-290: /cleanse Command (interactive, flags, backup, safety features)
- 🟢 REQ-286: Documentation Update (WHITE-PAPER.md + README.md refreshed for v2.0)
- 🟢 REQ-282: Skill Token Optimization - gco-orchestrator refactored (1,773→326 lines, 5 reference files)
- 🟢 REQ-279-281: Agent Iteration & Verification (Ralph Wiggum-inspired improvements)
- 🟢 REQ-275-278: Deterministic Wrapper Scripts (haunt-lessons, haunt-story, haunt-read, haunt-archive)

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

## Backlog: Skill Token Optimization (>600 lines)

> Threshold: Focus on skills >600 lines. Skills 500-600 have marginal ROI.
> Pattern: Use REQ-282 as template (reference index + consultation gates).

### ⚪ REQ-283: Refactor gco-requirements-analysis Skill

**Type:** Enhancement
**Reported:** 2025-12-31
**Source:** Skill refactoring analysis

**Description:**
gco-requirements-analysis is 824 lines (65% over 500-line limit). This is a core PM workflow skill used in every séance. High token cost per invocation.

**Tasks:**

- [ ] Analyze skill structure and identify natural domain splits
- [ ] Create `references/` directory
- [ ] Extract detailed rubric examples to reference file
- [ ] Extract JTBD/Kano/RICE implementation details to reference file
- [ ] Slim SKILL.md to ~400 lines with overview + reference index
- [ ] Add consultation gates (Pattern 1 + Pattern 5)
- [ ] Test PM workflow still functions correctly

**Files:**

- `Haunt/skills/gco-requirements-analysis/SKILL.md` (modify)
- `Haunt/skills/gco-requirements-analysis/references/*.md` (create)

**Effort:** M (2-4 hours)
**Complexity:** MODERATE
**Agent:** Dev-Infrastructure
**Completion:**

- SKILL.md under 500 lines
- Reference files created with appropriate content
- Consultation gates implemented
- PM workflow functions correctly

**Blocked by:** None

---

### ⚪ REQ-284: Refactor gco-code-patterns Skill

**Type:** Enhancement
**Reported:** 2025-12-31
**Source:** Skill refactoring analysis

**Description:**
gco-code-patterns is 658 lines (32% over limit). Used by code reviewer agent for anti-pattern detection.

**Tasks:**

- [ ] Analyze skill structure
- [ ] Create `references/` directory
- [ ] Extract pattern examples to reference files (by language or category)
- [ ] Slim SKILL.md to ~400 lines
- [ ] Add consultation gates
- [ ] Test code review workflow

**Files:**

- `Haunt/skills/gco-code-patterns/SKILL.md` (modify)
- `Haunt/skills/gco-code-patterns/references/*.md` (create)

**Effort:** S (1-2 hours)
**Complexity:** SIMPLE
**Agent:** Dev-Infrastructure
**Completion:**

- SKILL.md under 500 lines
- Pattern examples in reference files
- Code review workflow functions correctly

**Blocked by:** None

---

### ⚪ REQ-285: Refactor gco-task-decomposition Skill

**Type:** Enhancement
**Reported:** 2025-12-31
**Source:** Skill refactoring analysis

**Description:**
gco-task-decomposition is 600 lines (exactly at threshold). Used for breaking SPLIT-sized requirements into atomic tasks.

**Tasks:**

- [ ] Analyze skill structure
- [ ] Create `references/` directory
- [ ] Extract decomposition examples to reference file
- [ ] Extract DAG visualization guidance to reference file
- [ ] Slim SKILL.md to ~400 lines
- [ ] Add consultation gates

**Files:**

- `Haunt/skills/gco-task-decomposition/SKILL.md` (modify)
- `Haunt/skills/gco-task-decomposition/references/*.md` (create)

**Effort:** S (1-2 hours)
**Complexity:** SIMPLE
**Agent:** Dev-Infrastructure
**Completion:**

- SKILL.md under 500 lines
- Decomposition examples in reference files
- Task decomposition workflow functions correctly

**Blocked by:** None

---
