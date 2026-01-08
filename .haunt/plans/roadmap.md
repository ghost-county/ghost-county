# Monorepo Roadmap

> Single source of truth for all project work items. See `.haunt/completed/` for archived work.

---

## Current Focus

**Batch:** Context Rot Improvements (4 requirements)
**Status:** Not Started

| REQ | Title | Effort | Blocked By |
|-----|-------|--------|------------|
| REQ-412 | Add SESSION.md state tracking file | S | None |
| REQ-413 | Enforce 2-4 task limit per requirement | S | None |
| REQ-414 | Add decisions.md log | XS | None |
| REQ-415 | Add continue-here.md auto-generation | XS | None |

---

## Cross-Project Work

*Requirements affecting multiple projects go here.*

---

## Haunt Framework

*Haunt agent framework and SDLC tooling.*

### Batch: Context Rot Improvements

### 🟢 REQ-412: Add SESSION.md state tracking file

**Type:** Enhancement
**Reported:** 2026-01-08
**Source:** GSD Comparison Research
**Description:** Create a session-level state file to track current focus, resume points, and pending decisions. Solves the "where was I?" problem for session handoff.

**Tasks:**
- [x] Create `.haunt/state/` directory structure
- [x] Create SESSION.md template with fields: current REQ, resume point, pending decisions, last updated
- [x] Add session state auto-generation to haunt-roadmap.sh when status changes to 🟡

**Files:**
- `.haunt/state/SESSION.md` (create)
- `Haunt/scripts/haunt-roadmap.sh` (modify)

**Effort:** S
**Complexity:** MODERATE
**Agent:** gco-dev-infrastructure
**Completion:** SESSION.md template exists and is auto-updated when requirement status changes to in-progress
**Blocked by:** None

---

### 🟢 REQ-413: Enforce 2-4 task limit per requirement

**Type:** Enhancement
**Reported:** 2026-01-08
**Source:** GSD Comparison Research
**Description:** Add task count enforcement to prevent requirements from having too many tasks. Requirements with >4 tasks should trigger SPLIT warning.

**Tasks:**
- [x] Update gco-roadmap-format.md rule to document 2-4 task limit
- [x] Add task count validation to haunt-roadmap.sh (warn if >4 tasks)
- [x] Update roadmap format template to show 2-4 task guidance

**Files:**
- `Haunt/rules/gco-roadmap-format.md` (modify)
- `Haunt/scripts/haunt-roadmap.sh` (modify)

**Effort:** S
**Complexity:** SIMPLE
**Agent:** gco-dev-infrastructure
**Completion:** haunt-roadmap.sh warns when a requirement has more than 4 tasks; rules document the 2-4 limit
**Blocked by:** None

---

### 🟢 REQ-414: Add decisions.md log

**Type:** Enhancement
**Reported:** 2026-01-08
**Source:** GSD Comparison Research
**Description:** Create a simple append-only decision log to persist architectural and design decisions with rationale. Prevents re-litigating settled decisions.

**Tasks:**
- [x] Create `.haunt/docs/decisions.md` template with columns: Date, REQ, Decision, Rationale, Status
- [x] Add documentation for when to log decisions (architecture, trade-offs, non-obvious choices)

**Files:**
- `.haunt/docs/decisions.md` (create)

**Effort:** XS
**Complexity:** SIMPLE
**Agent:** gco-dev-infrastructure
**Completion:** decisions.md file exists with table header and usage guidance at top
**Blocked by:** None

---

### 🟢 REQ-415: Add continue-here.md auto-generation

**Type:** Enhancement
**Reported:** 2026-01-08
**Source:** GSD Comparison Research
**Description:** Generate an explicit handoff file when session ends with incomplete work. Contains requirement, last task, next step, modified files, and uncommitted changes.

**Tasks:**
- [x] Create `.haunt/state/continue-here.md` template
- [x] Add auto-generation logic to session completion workflow
- [x] Document continue-here.md in gco-session-startup rule for auto-read on startup

**Files:**
- `.haunt/state/continue-here.md` (created - comprehensive template with all recommended fields)
- `Haunt/rules/gco-session-startup.md` (modified - added session handoff section with when to check/generate)

**Effort:** XS
**Complexity:** SIMPLE
**Agent:** gco-dev-infrastructure
**Completion:** continue-here.md template exists and session-startup rule documents checking it on session start
**Blocked by:** None

---

### Batch: Ralph Wiggum Dev Integration

### 🟢 REQ-408: Create /ralph-req command definition

**Type:** Enhancement
**Reported:** 2026-01-07
**Source:** Plan: Ralph Wiggum Integration
**Description:** Create the command definition file for /ralph-req that starts persistent dev work on a requirement using the Ralph Wiggum iteration loop.

**Tasks:**
- [x] Create `Haunt/commands/ralph-req.md` with YAML frontmatter
- [x] Define usage syntax: `/ralph-req REQ-XXX [--max-iterations N]`
- [x] Document workflow steps (read requirement, extract criteria, initialize loop)
- [x] Document completion promise protocol (`<promise>ALL_CRITERIA_VERIFIED</promise>`)

**Files:**
- `Haunt/commands/ralph-req.md` (created - 317 lines)

**Effort:** XS
**Complexity:** SIMPLE
**Agent:** gco-dev-infrastructure
**Completion:** Command file exists with proper YAML frontmatter, usage syntax, and workflow documentation
**Blocked by:** None
**Completed:** 2026-01-07

---

### 🟢 REQ-409: Create ralph-req.sh script

**Type:** Enhancement
**Reported:** 2026-01-07
**Source:** Plan: Ralph Wiggum Integration
**Description:** Create the bash script that extracts requirement from roadmap, validates size (XS/S/M), and invokes the Ralph loop with derived prompt and completion promise.

**Tasks:**
- [x] Create `Haunt/scripts/ralph-req.sh` with shebang and execute permissions
- [x] Implement requirement extraction from `.haunt/plans/roadmap.md`
- [x] Implement size validation (XS/S/M, error on SPLIT)
- [x] Set max iterations based on size (30 for XS, 50 for S, 75 for M)
- [x] Extract completion criteria from requirement
- [x] Build prompt with TDD workflow and completion rules
- [x] Include `<blocked>REASON</blocked>` exit protocol in prompt

**Files:**
- `Haunt/scripts/ralph-req.sh` (created - 345 lines)

**Effort:** S
**Complexity:** MODERATE
**Agent:** gco-dev-infrastructure
**Completion:** Script executes, validates size correctly, and outputs proper prompt for Ralph loop invocation
**Blocked by:** REQ-408
**Completed:** 2026-01-07

---

### 🟢 REQ-410: Add Ralph loop awareness to dev agent

**Type:** Enhancement
**Reported:** 2026-01-07
**Source:** Plan: Ralph Wiggum Integration
**Description:** Add a section to the dev agent character sheet describing behavior when running in a Ralph loop, including promise protocol, blocked protocol, and iteration awareness.

**Tasks:**
- [x] Add "Ralph Loop Mode" section to `Haunt/agents/gco-dev.md`
- [x] Document promise protocol (only output when TRUE)
- [x] Document blocked protocol (`<blocked>REASON</blocked>` for genuine blocks)
- [x] Document iteration awareness (check git log and file state)
- [x] Add gco-ralph-dev to skills list

**Files:**
- `Haunt/agents/gco-dev.md` (modified)

**Effort:** XS
**Complexity:** SIMPLE
**Agent:** gco-dev-infrastructure
**Completion:** Dev agent file contains Ralph Loop Mode section with all four protocol elements documented
**Blocked by:** None
**Completed:** 2026-01-07

---

### 🟢 REQ-411: Create gco-ralph-dev skill

**Type:** Enhancement
**Reported:** 2026-01-07
**Source:** Plan: Ralph Wiggum Integration
**Description:** Create detailed skill reference for Ralph loop dev work, covering when to use loops, completion criteria mapping, smart exit patterns, and iteration best practices.

**Tasks:**
- [x] Create `Haunt/skills/gco-ralph-dev/SKILL.md` directory and file
- [x] Document when to use Ralph loops for dev work (XS/S only)
- [x] Document completion criteria to promise mapping
- [x] Document smart exit vs blocked signaling
- [x] Document iteration best practices (check previous work, avoid loops)

**Files:**
- `Haunt/skills/gco-ralph-dev/SKILL.md` (created - 581 lines)

**Effort:** S
**Complexity:** MODERATE
**Agent:** gco-dev-infrastructure
**Completion:** Skill file exists with all four documentation sections, follows YAML frontmatter format
**Blocked by:** REQ-410
**Completed:** 2026-01-07

---

## TrueSight

*ADHD productivity dashboard.*

---

## Familiar

*Personal command center and knowledge management.*

---

## Summary

| Project | ⚪ | 🟡 | 🟢 |
|---------|---|---|---|
| Cross-Project | 0 | 0 | 0 |
| Haunt | 0 | 0 | 8 |
| TrueSight | 0 | 0 | 0 |
| Familiar | 0 | 0 | 0 |
| **Total** | 0 | 0 | 8 |

**Archived:** 76 requirements → See `.haunt/completed/`

---

## Recent Archives

- **2026-01-07:** Git Workflow Integration (7 requirements) → `roadmap-archive.md`
- **2026-01-06:** Mandatory Solution Critique (4 requirements) → `mandatory-solution-critique.md`
- **2026-01-06:** Haunt Manifest System (1 requirement) → `roadmap-archive.md`
- **2026-01-05:** Repository Cleanup Batch (8 requirements) → `repo-cleanup-batch.md`
- **2026-01-05:** Damage Control Hooks (7 requirements) → `damage-control-hooks.md`
- **2026-01-05:** Secrets Management Core (6 requirements) → `secrets-management-batch1.md`
- **2026-01-05:** Skill Compression Seance (15 requirements) → `skill-compression-seance.md`
- **2026-01-03:** Various batches (28 requirements) → See `2026-01/`
