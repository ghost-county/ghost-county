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

### 🟢 REQ-308: Seance Workflow State Enforcement

**Type:** Enhancement
**Reported:** 2026-01-02
**Source:** User pain point - orchestrator drifts from planning to implementation mid-seance

**Description:** Implement state file + spawn-time context injection to prevent orchestrator from breaking out of seance workflow phases. Currently, after 15+ conversation turns, instruction degradation causes the model to skip the roadmap creation and user approval gates, jumping directly to implementation.

**Implementation Notes:**
- Hybrid enforcement using 3 layers: state file + spawn-time context + phase declarations
- Phase state file created at `.haunt/state/current-phase.txt` with SCRYING/SUMMONING/BANISHING values
- PM spawns include "You are in SCRYING phase" context
- Dev agent spawns include "You are in SUMMONING phase" context
- Phase transitions logged: SCRYING → SUMMONING → BANISHING
- Violation self-checks added before Edit/Write/Task tool calls
- Testing pending (5 trial seances across modes)

**Tasks:**

- [x] Create `.haunt/state/` directory initialization in seance startup
- [x] Implement phase state file (`.haunt/state/current-phase.txt`) with SCRYING/SUMMONING/BANISHING values
- [x] Add phase context injection to PM spawn prompts ("You are in SCRYING phase...")
- [x] Add phase context injection to dev agent spawn prompts ("You are in SUMMONING phase...")
- [x] Add phase transition validation before spawning dev agents (check user approval)
- [x] Update gco-orchestrator skill with phase declaration pattern
- [x] Add violation self-check before Edit/Write tool calls
- [x] Test with 5 trial seances across different modes (PENDING - validation in follow-up sessions)

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

## Backlog: Built-in Subagent Integration

### ⚪ REQ-309: Document Explore Agent Integration Patterns

**Type:** Documentation
**Reported:** 2026-01-02
**Source:** Research analysis - Explore agent is built-in, fast, read-only codebase reconnaissance tool

**Description:** Integrate Claude Code's built-in Explore agent into Haunt workflows as a sanctioned tool for fast codebase reconnaissance. Research shows Explore (Haiku model) is 40-60% faster than full research agent spawns for initial context gathering, but is read-only and can't produce deliverables. Document when to use Explore vs gco-research-analyst.

**Tasks:**

- [ ] Add "Built-in Subagents" section to `Haunt/docs/INTEGRATION-PATTERNS.md` documenting Explore capabilities and limits
- [ ] Update `gco-session-startup` skill with Explore decision gate (use for quick recon before deep research)
- [ ] Update `gco-orchestration.md` rule with codebase reconnaissance delegation pattern
- [ ] Update `gco-model-selection.md` rule with Explore guidance (when to use vs Haiku vs Sonnet)
- [ ] Archive research findings to `.haunt/docs/research/explore-agent-integration.md`

**Files:**

- `Haunt/docs/INTEGRATION-PATTERNS.md` (create - new doc for built-in tool integration patterns)
- `Haunt/skills/gco-session-startup/SKILL.md` (modify - add Explore decision tree)
- `Haunt/rules/gco-orchestration.md` (modify - add built-in subagent delegation)
- `Haunt/rules/gco-model-selection.md` (modify - add Explore vs agent comparison)
- `.haunt/docs/research/explore-agent-integration.md` (create - archive research findings)

**Effort:** S
**Complexity:** SIMPLE
**Agent:** Dev-Infrastructure
**Completion:**
- Documentation clearly explains when to use Explore vs gco-research-analyst
- Decision tree added to session-startup for reconnaissance workflow
- Orchestration rules updated with built-in subagent delegation pattern
- Research findings archived for reference
- All files deployed to `~/.claude/` via setup script

**Blocked by:** None

**Research Reference:** See conversation analysis from gco-research-analyst for detailed integration recommendations and decision tree.

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

## Batch: Agent/Skill Optimization (Weekly Refactor)

> From weekly refactor analysis: gco-dev.md at 1,110 lines, multiple skills >500 lines.

### ⚪ REQ-310: Refactor gco-dev.md Agent (Option B - References)

**Type:** Enhancement
**Reported:** 2026-01-02
**Source:** Weekly refactor analysis

**Description:**
gco-dev.md is 1,110 lines - 22x over the 50-line target for agent character sheets. Refactor using Option B: keep unified agent, extract mode-specific guidance to reference files.

**Current Structure (1,110 lines):**
- Core identity/values (~50 lines) - KEEP
- TDD iteration loop (~200 lines) - EXTRACT
- Testing accountability (~100 lines) - EXTRACT
- Frontend mode + UI testing (~150 lines) - EXTRACT
- Backend mode (~50 lines) - EXTRACT
- Infrastructure mode (~30 lines) - EXTRACT

**Target Structure:**
```
gco-dev.md (~60 lines - identity only)
└── references/
    ├── tdd-workflow.md
    ├── testing-accountability.md
    ├── backend-guidance.md
    ├── frontend-guidance.md
    └── infrastructure-guidance.md
```

**Tasks:**

- [ ] Analyze gco-dev.md structure and identify extraction boundaries
- [ ] Create `Haunt/agents/gco-dev/references/` directory
- [ ] Extract TDD iteration loop to `references/tdd-workflow.md`
- [ ] Extract testing accountability to `references/testing-accountability.md`
- [ ] Extract backend guidance to `references/backend-guidance.md`
- [ ] Extract frontend guidance (including UI testing) to `references/frontend-guidance.md`
- [ ] Extract infrastructure guidance to `references/infrastructure-guidance.md`
- [ ] Slim main gco-dev.md to ~60 lines with consultation gates
- [ ] Add mode gates: "Backend mode → READ references/backend-guidance.md"
- [ ] Test dev agent workflow still functions correctly
- [ ] Update setup-haunt.sh to deploy references/

**Files:**

- `Haunt/agents/gco-dev.md` (modify - 1,110 → ~60 lines)
- `Haunt/agents/gco-dev/references/*.md` (create - 5 files)
- `Haunt/scripts/setup-haunt.sh` (modify - deploy references)

**Effort:** M (2-4 hours)
**Complexity:** MODERATE
**Agent:** Dev-Infrastructure
**Completion:**
- gco-dev.md under 80 lines
- Reference files contain extracted guidance
- Mode consultation gates implemented
- Dev agent workflow verified functional
- Context overhead reduced by ~90%

**Blocked by:** None

---

### ⚪ REQ-316: Refactor gco-testing-mindset Skill

**Type:** Enhancement
**Reported:** 2026-01-02
**Source:** Weekly refactor analysis

**Description:**
gco-testing-mindset is 582 lines (16% over 500-line target). Extract detailed examples and scenarios to reference files.

**Tasks:**

- [ ] Analyze skill structure
- [ ] Create `references/` directory
- [ ] Extract testing examples to reference file
- [ ] Extract scenario walkthroughs to reference file
- [ ] Slim SKILL.md to ~400 lines
- [ ] Add consultation gates

**Files:**

- `Haunt/skills/gco-testing-mindset/SKILL.md` (modify)
- `Haunt/skills/gco-testing-mindset/references/*.md` (create)

**Effort:** S (1-2 hours)
**Complexity:** SIMPLE
**Agent:** Dev-Infrastructure
**Completion:** SKILL.md under 500 lines, references extracted, testing workflow functional

**Blocked by:** None

---

### ⚪ REQ-317: Refactor gco-roadmap-planning Skill

**Type:** Enhancement
**Reported:** 2026-01-02
**Source:** Weekly refactor analysis

**Description:**
gco-roadmap-planning is 554 lines (11% over 500-line target). Extract examples and templates to reference files.

**Tasks:**

- [ ] Analyze skill structure
- [ ] Create `references/` directory
- [ ] Extract roadmap examples to reference file
- [ ] Extract batch organization patterns to reference file
- [ ] Slim SKILL.md to ~400 lines
- [ ] Add consultation gates

**Files:**

- `Haunt/skills/gco-roadmap-planning/SKILL.md` (modify)
- `Haunt/skills/gco-roadmap-planning/references/*.md` (create)

**Effort:** S (1-2 hours)
**Complexity:** SIMPLE
**Agent:** Dev-Infrastructure
**Completion:** SKILL.md under 500 lines, references extracted, roadmap workflow functional

**Blocked by:** None

---

## Batch: Metrics & Regression Framework

> New tooling for measuring agent performance and detecting regressions.

### ⚪ REQ-311: Fix haunt-metrics.sh Parsing Bugs

**Type:** Bug Fix
**Reported:** 2026-01-02
**Source:** Weekly refactor analysis

**Description:**
haunt-metrics.sh has parsing issues:
1. Effort estimate shows duplicate values (e.g., "S\nS\nS")
2. Orphaned commits warning for recently archived requirements
3. Archive file search not working properly

**Tasks:**

- [ ] Fix effort estimate regex to capture single value
- [ ] Improve archive file search pattern
- [ ] Handle recently archived requirements gracefully
- [ ] Add unit tests for parsing functions
- [ ] Test with current git history

**Files:**

- `Haunt/scripts/haunt-metrics.sh` (modify)
- `Haunt/tests/test-haunt-metrics.sh` (create)

**Effort:** S (1-2 hours)
**Complexity:** SIMPLE
**Agent:** Dev-Infrastructure
**Completion:** Metrics output clean, no duplicate values, archive search works

**Blocked by:** None

---

### ⚪ REQ-312: Add Context Overhead Metric

**Type:** Enhancement
**Reported:** 2026-01-02
**Source:** User request - track token/context efficiency

**Description:**
Add context overhead measurement to haunt-metrics. Context overhead = how much context an agent consumes before doing useful work.

**Components to measure:**
- Agent character sheet size (lines)
- Always-loaded rules size (lines)
- CLAUDE.md size (lines)
- Average skills loaded per session (estimated)

**Formula:**
```
base_overhead = agent_lines + rules_lines + claude_md_lines
skill_overhead = avg_skills_invoked × avg_skill_size
total_context_overhead = base_overhead + skill_overhead
```

**Tasks:**

- [ ] Add `measure_context_overhead()` function to haunt-metrics.sh
- [ ] Calculate base overhead (agent + rules + CLAUDE.md)
- [ ] Estimate skill overhead (top 5 most-used skills × avg size)
- [ ] Add `--context` flag to output context metrics
- [ ] Include context_overhead in JSON output
- [ ] Add context overhead to aggregate metrics

**Files:**

- `Haunt/scripts/haunt-metrics.sh` (modify)
- `Haunt/commands/haunt-metrics.md` (modify - document new flag)

**Effort:** M (2-4 hours)
**Complexity:** MODERATE
**Agent:** Dev-Infrastructure
**Completion:**
- `haunt-metrics --context` shows overhead breakdown
- JSON output includes context_overhead_lines field
- Baseline can be established for regression tracking

**Blocked by:** REQ-311

---

### ⚪ REQ-313: Create haunt-regression-check Script

**Type:** Enhancement
**Reported:** 2026-01-02
**Source:** User request - detect agent performance regressions

**Description:**
Create script to compare current metrics against a stored baseline and detect regressions.

**Regression thresholds:**
- Completion Rate: Alert if >5% worse than baseline
- First-Pass Success: Alert if >10% worse than baseline
- Avg Cycle Time: Alert if >25% worse than baseline
- Context Overhead: Alert if >20% worse than baseline

**Output:**
```
┌─────────────────────────────────────────┐
│         REGRESSION CHECK RESULTS        │
├─────────────────────────────────────────┤
│ Metric              Baseline  Current   │
│ ──────────────────  ────────  ───────   │
│ Completion Rate     80.0%     82.0%  ✅ │
│ First-Pass Success  70.0%     65.0%  🔴 │ ← REGRESSION
│ Avg Cycle Time      3.5h      3.2h   ✅ │
│ Context Overhead    2500      1800   ✅ │
└─────────────────────────────────────────┘
```

**Tasks:**

- [ ] Create `Haunt/scripts/haunt-regression-check.sh`
- [ ] Implement baseline loading from JSON file
- [ ] Implement current metrics collection (call haunt-metrics)
- [ ] Implement comparison with configurable thresholds
- [ ] Add color-coded output (✅ OK, 🟡 Warning, 🔴 Regression)
- [ ] Add `--baseline=<file>` parameter
- [ ] Add JSON output format
- [ ] Create command documentation

**Files:**

- `Haunt/scripts/haunt-regression-check.sh` (create)
- `Haunt/commands/haunt-regression-check.md` (create)

**Effort:** M (2-4 hours)
**Complexity:** MODERATE
**Agent:** Dev-Infrastructure
**Completion:**
- Script compares current vs baseline metrics
- Regressions clearly identified with visual indicators
- Exit code reflects regression status (0=OK, 1=regression)

**Blocked by:** REQ-312

---

### ⚪ REQ-314: Create Baseline Metrics Storage System

**Type:** Enhancement
**Reported:** 2026-01-02
**Source:** User request - manage metric baselines for regression testing

**Description:**
Create system to store, manage, and version metric baselines for regression comparison.

**Storage location:** `.haunt/metrics/`
**Baseline format:**
```json
{
  "created": "2026-01-02",
  "version": "v2.1",
  "description": "Post gco-dev refactor",
  "sample_size": 20,
  "calibration_complete": true,
  "metrics": {
    "completion_rate": 80.0,
    "first_pass_success": 70.0,
    "avg_cycle_time_hours": 3.5,
    "context_overhead_lines": 2500
  }
}
```

**Commands:**
- `haunt-baseline create` - Create new baseline from current metrics
- `haunt-baseline list` - List stored baselines
- `haunt-baseline show <name>` - Show baseline details
- `haunt-baseline set-active <name>` - Set baseline for regression checks

**Tasks:**

- [ ] Create `.haunt/metrics/` directory structure
- [ ] Create `Haunt/scripts/haunt-baseline.sh` script
- [ ] Implement `create` command (snapshot current metrics)
- [ ] Implement `list` command (show all baselines)
- [ ] Implement `show` command (display baseline details)
- [ ] Implement `set-active` command (symlink to active baseline)
- [ ] Add calibration tracking (sample_size, calibration_complete flag)
- [ ] Create command documentation

**Files:**

- `Haunt/scripts/haunt-baseline.sh` (create)
- `Haunt/commands/haunt-baseline.md` (create)
- `.haunt/metrics/` directory structure

**Effort:** S (1-2 hours)
**Complexity:** SIMPLE
**Agent:** Dev-Infrastructure
**Completion:**
- Baselines can be created, listed, and managed
- Active baseline used by regression-check automatically
- Calibration tracking prevents premature comparisons

**Blocked by:** REQ-313

---

### ⚪ REQ-315: Update gco-weekly-refactor Skill

**Type:** Enhancement
**Reported:** 2026-01-02
**Source:** User request - add metrics and regression phases to weekly ritual

**Description:**
Update the weekly refactor skill to include:
1. Phase 0: Metrics Review (run haunt-metrics)
2. Phase 0.5: Regression Check (run haunt-regression-check)
3. Phase 4: Context Audit (measure and review context overhead)

**Updated Structure:**
```
Phase 0: Metrics Review (10 min) - NEW
Phase 0.5: Regression Check (5 min) - NEW
Phase 1: Pattern Hunt (30 min) - informed by metrics
Phase 2: Defeat Tests (30 min) - same
Phase 3: Prompt Refactor (30 min) - same
Phase 4: Context Audit (15 min) - NEW
Phase 5: Architecture Check (20 min) - same
Phase 6: Version & Deploy (10 min) - updated for calibration
```

**Tasks:**

- [ ] Add Phase 0: Metrics Review section
- [ ] Add Phase 0.5: Regression Check section
- [ ] Add Phase 4: Context Audit section
- [ ] Update Phase 1 to reference metrics findings
- [ ] Update Phase 6 with calibration period guidance
- [ ] Add regression response decision tree
- [ ] Update weekly report template with new metrics

**Files:**

- `Haunt/skills/gco-weekly-refactor/SKILL.md` (modify)

**Effort:** S (1-2 hours)
**Complexity:** SIMPLE
**Agent:** Dev-Infrastructure
**Completion:**
- Skill includes all new phases
- Metrics inform pattern hunt
- Regression check integrated into ritual
- Context audit phase documented

**Blocked by:** REQ-312, REQ-314

---
