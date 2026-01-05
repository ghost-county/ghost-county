# Haunt Framework Roadmap

> Single source of truth for project work items. See `.haunt/completed/` for archived work.

---

## Current Focus

**Status:** All requirements complete. Roadmap clear.

**Recently Archived (2026-01-03):**
- See `.haunt/completed/2026-01/seance-2026-01-03-batch2.md` for 17 requirements
- Batches: CLI Improvements, Metrics & Regression, Haunt Efficiency, Framework Evolution
- Key achievements:
  - UOCS (Universal Output Capture System) implemented
  - Agent character sheets minimized (56% reduction, 813 lines saved)
  - Skills consolidated (76% reduction, 959 lines saved)
  - Instruction overhead reduced 79% (306 → 65)
  - Notification hooks added for work completion

**Previously Archived:**
- See `.haunt/completed/2026-01/seance-2026-01-03.md` for 11 earlier requirements

---

## Summary

| Status | Count | Requirements |
|--------|-------|--------------|
| 🟢 Complete (Archived) | 28 | See `.haunt/completed/2026-01/` |
| 🟢 Complete (Not Archived) | 9 | REQ-350, REQ-352-355, REQ-359-364 |
| ⚪ Not Started | 6 | REQ-351, REQ-355-358 |

---

## Batch 0: Safety Net (MUST COMPLETE FIRST)

Theme: Create backups and reversion plan before any compression work.

### 🟢 REQ-362: Backup all compression targets

**Type:** Infrastructure
**Description:** Create timestamped backups of all skills being compressed before any modifications.

**Tasks:**
- [x] Create backup directory: `.haunt/backups/skill-compression-2026-01-05/`
- [x] Copy all 9 target skills to backup directory
- [x] Copy 3 agent files being modified to backup directory
- [x] Verify backup integrity (file counts, line counts)
- [x] Create manifest.md with original line counts

**Files to backup:**
```
# Technical skills (Batch 1)
Haunt/skills/gco-python-standards/SKILL.md (688 lines)
Haunt/skills/gco-react-standards/SKILL.md (595 lines)
Haunt/skills/gco-commit-conventions/SKILL.md (333 lines)
Haunt/skills/gco-code-patterns/SKILL.md (211 lines)
Haunt/skills/gco-playwright-tests/SKILL.md (438 lines)
Haunt/skills/gco-code-quality/SKILL.md (139 lines)

# Workflow skills (Batch 2)
Haunt/skills/gco-orchestrator/SKILL.md (403 lines)
Haunt/skills/gco-requirements-development/SKILL.md (272 lines)
Haunt/skills/gco-roadmap-creation/SKILL.md (316 lines)

# Agents (Batch 3)
Haunt/agents/gco-dev.md
Haunt/agents/gco-project-manager.md
Haunt/agents/gco-research.md
```

**Files:**
- `.haunt/backups/skill-compression-2026-01-04/` (create directory)
- `.haunt/backups/skill-compression-2026-01-04/manifest.md` (create)

**Effort:** XS
**Agent:** Dev-Infrastructure
**Completion:** All 12 files backed up, manifest shows line counts
**Blocked by:** None

---

### 🟢 REQ-363: Create reversion plan documentation

**Type:** Documentation
**Description:** Document quick reversion procedures if compression causes framework issues.

**Tasks:**
- [x] Create reversion plan document
- [x] Include quick commands for single and full revert
- [x] Document symptoms that indicate reversion needed
- [x] Add to .haunt/docs/

**Files:**
- `.haunt/docs/REVERSION-PLAN.md` (create)

**Effort:** XS
**Agent:** Dev-Infrastructure
**Completion:** Document exists with copy-paste commands
**Blocked by:** REQ-362

---

### 🟢 REQ-364: Save draft targets as reference

**Type:** Documentation
**Description:** Save the compressed draft versions as reference targets for implementation.

**Tasks:**
- [x] Create drafts directory
- [x] Save gco-orchestrator draft (~110 lines)
- [x] Save gco-requirements-development draft (~75 lines)
- [x] Save gco-roadmap-creation draft (~90 lines)
- [x] Save gco-python-standards draft (~75 lines from earlier analysis)

**Files:**
- `.haunt/docs/compression-drafts/` (create directory)
- `.haunt/docs/compression-drafts/gco-orchestrator-draft.md` (create)
- `.haunt/docs/compression-drafts/gco-requirements-development-draft.md` (create)
- `.haunt/docs/compression-drafts/gco-roadmap-creation-draft.md` (create)
- `.haunt/docs/compression-drafts/gco-python-standards-draft.md` (create)

**Effort:** S
**Agent:** Dev-Infrastructure
**Completion:** 4 draft files saved as implementation targets
**Blocked by:** None

---

## Batch 1: Skill Compression (Technical Skills)

Theme: Apply CTO-Claude.md style - values/constraints/conventions over tutorials.

### 🟢 REQ-350: Compress gco-python-standards skill

**Type:** Enhancement
**Description:** Rewrite gco-python-standards from 688 lines to ~75 lines using bullet/table format. Remove tutorials, keep anti-patterns + conventions + commands.

**Tasks:**
- [x] Remove detailed code examples (keep 1 max per concept)
- [x] Convert prose to bullet points
- [x] Consolidate redundant sections (Quick Reference duplicates tables)
- [x] Remove pyproject.toml full config (agent can generate)
- [x] Keep: anti-pattern table, PEP 8 table, pytest essentials, completion checklist

**Files:**
- `Haunt/skills/gco-python-standards/SKILL.md` (modify)

**Effort:** S
**Agent:** Dev-Infrastructure
**Completion:** Skill < 100 lines, all tables preserved, no prose blocks > 2 lines (75 lines, 89% reduction)
**Blocked by:** REQ-362, REQ-364

---

### 🟢 REQ-351: Compress gco-react-standards skill

**Type:** Enhancement
**Description:** Rewrite gco-react-standards from 595 lines to ~75 lines. Same pattern as Python compression.

**Tasks:**
- [x] Remove hook tutorials (models know React)
- [x] Convert prose to bullets
- [x] Keep: component patterns table, testing essentials, completion checklist
- [x] Remove detailed examples, keep one-liners

**Files:**
- `Haunt/skills/gco-react-standards/SKILL.md` (modify)

**Effort:** S
**Agent:** Dev-Infrastructure
**Completion:** Skill < 100 lines, no prose blocks > 2 lines (137 lines, 77% reduction)
**Blocked by:** REQ-362, REQ-364

---

### 🟢 REQ-352: Compress gco-commit-conventions skill

**Type:** Enhancement
**Description:** Rewrite from 333 lines to ~60 lines. Commit format is convention, not tutorial.

**Tasks:**
- [x] Keep: format template, type prefixes table, scope examples
- [x] Remove: detailed scenarios (agent can reason)
- [x] Convert examples to single-line patterns

**Files:**
- `Haunt/skills/gco-commit-conventions/SKILL.md` (modify)

**Effort:** S
**Agent:** Dev-Infrastructure
**Completion:** Skill < 80 lines (achieved 79 lines)
**Blocked by:** REQ-362, REQ-364

---

### 🟢 REQ-353: Compress gco-code-patterns skill

**Type:** Enhancement
**Description:** Rewrite from 211 lines to ~50 lines. Anti-patterns work as tables, not prose.

**Tasks:**
- [x] Convert all anti-patterns to table rows (Pattern | Problem | Fix)
- [x] Remove code examples (one-liner in Fix column suffices)
- [x] Keep severity ratings

**Files:**
- `Haunt/skills/gco-code-patterns/SKILL.md` (modify)

**Effort:** XS
**Agent:** Dev-Infrastructure
**Completion:** Skill < 60 lines, anti-patterns in single table
**Blocked by:** REQ-362, REQ-364

---

### 🟢 REQ-354: Compress gco-playwright-tests skill

**Type:** Enhancement
**Description:** Rewrite from 438 lines to ~80 lines. Testing patterns, not Playwright tutorial.

**Tasks:**
- [x] Remove API documentation (Context7 handles this)
- [x] Keep: selector patterns table, test structure template, completion checklist
- [x] Convert examples to minimal patterns

**Files:**
- `Haunt/skills/gco-playwright-tests/SKILL.md` (modify)

**Effort:** S
**Agent:** Dev-Infrastructure
**Completion:** Skill < 100 lines (114 lines achieved - 74% reduction)
**Blocked by:** REQ-362, REQ-364

---

### 🟢 REQ-355: Compress gco-code-quality skill

**Type:** Enhancement
**Description:** Rewrite from 139 lines to ~40 lines.

**Tasks:**
- [x] Analyzed overlap with gco-code-patterns (complementary, not redundant)
- [x] Compressed to 48 lines using table format
- [x] Converted 4-pass protocol to table
- [x] Added pass requirements by size table
- [x] Moved examples to references
- [x] Retained consultation gates

**Decision:** Compressed independently (not merged). code-patterns = detection, code-quality = iterative refinement.

**Result:** 139 → 48 lines (65% reduction)

**Files:**
- `Haunt/skills/gco-code-quality/SKILL.md` (modify)

**Effort:** XS
**Agent:** Dev-Infrastructure
**Completion:** Skill < 50 lines or merged
**Blocked by:** REQ-353, REQ-362, REQ-364

---

## Batch 2: Skill Compression (Workflow Skills)

Theme: Even workflow skills have tutorial prose. Convert to bullet gates.

### 🟢 REQ-356: Compress gco-orchestrator skill

**Type:** Enhancement
**Description:** Rewrite from 403 lines to ~110 lines. Delegation gates stay, examples go.

**Reference:** See `.haunt/docs/compression-drafts/gco-orchestrator-draft.md` for target format.

**Tasks:**
- [x] Use draft target as implementation guide
- [x] Keep: delegation gate table, mode table, state management rules
- [x] Remove: repeated examples (3+ showing same concept)
- [x] Remove: Quick Start Guide (redundant with mode table)
- [x] Consolidate "See also" to single reference index

**Files:**
- `Haunt/skills/gco-orchestrator/SKILL.md` (modify)

**Effort:** M
**Agent:** Dev-Infrastructure
**Completion:** Skill < 120 lines, all gates preserved, matches draft structure (achieved 95 lines, 76% reduction)
**Blocked by:** REQ-362, REQ-364

---

### 🟢 REQ-357: Compress gco-requirements-development skill

**Type:** Enhancement
**Description:** Rewrite from 272 lines to ~75 lines.

**Reference:** See `.haunt/docs/compression-drafts/gco-requirements-development-draft.md` for target format.

**Tasks:**
- [x] Use draft target as implementation guide
- [x] Keep: 14-dimension rubric table, requirement template
- [x] Remove: full document template (agent can generate)
- [x] Remove: RFC 2119 section (models know this)
- [x] Convert quality checklist to inline bullets

**Files:**
- `Haunt/skills/gco-requirements-development/SKILL.md` (modify)

**Effort:** S
**Agent:** Dev-Infrastructure
**Completion:** Skill < 90 lines, matches draft structure
**Blocked by:** REQ-362, REQ-364

---

### 🟢 REQ-358: Compress gco-roadmap-creation skill

**Type:** Enhancement
**Description:** Rewrite from 316 lines to ~90 lines.

**Reference:** See `.haunt/docs/compression-drafts/gco-roadmap-creation-draft.md` for target format.

**Tasks:**
- [x] Use draft target as implementation guide
- [x] Keep: roadmap item template, status icons, agent assignment table
- [x] Remove: common patterns section (Feature/Bug/Refactor examples)
- [x] Convert anti-patterns to table

**Files:**
- `Haunt/skills/gco-roadmap-creation/SKILL.md` (modify)

**Effort:** S
**Agent:** Dev-Infrastructure
**Completion:** Skill < 100 lines, matches draft structure
**Blocked by:** REQ-362, REQ-364

---

## Batch 3: New Global Rules

Theme: Promote key principles to always-loaded rules.

### 🟢 REQ-359: Add anti-glazing rule

**Type:** Enhancement
**Description:** Create global rule for communication style (from CTO-Claude.md).

**Content:**
```markdown
# Communication Style

- NEVER start messages with "Great", "Certainly", "Sure", "Of course"
- Shortest complete answer wins
- Don't explain unless asked
- Focus on outcomes, not process
```

**Tasks:**
- [x] Create rule file
- [x] Deploy to ~/.claude/rules/

**Files:**
- `Haunt/rules/gco-communication.md` (create)

**Effort:** XS
**Agent:** Dev-Infrastructure
**Completion:** Rule exists and deployed
**Blocked by:** None

---

### 🟢 REQ-360: Add decision framework rule

**Type:** Enhancement
**Description:** Create global rule for engineering decisions (from CTO-Claude.md).

**Content:**
```markdown
# Decision Framework

1. Will users notice? No → defer
2. Can we validate cheaper? Manual first
3. Is this reversible? Prefer undoable
4. YAGNI - don't build for scale you don't have
```

**Tasks:**
- [x] Create rule file
- [x] Deploy to ~/.claude/rules/

**Files:**
- `Haunt/rules/gco-decisions.md` (create)

**Effort:** XS
**Agent:** Dev-Infrastructure
**Completion:** Rule exists and deployed
**Blocked by:** None

---

### 🟢 REQ-361: Add response patterns to agents

**Type:** Enhancement
**Description:** Add CTO-style response pattern templates to agent character sheets.

**Content to add:**
```markdown
## Response Patterns
- Scope creep: "Out of scope for REQ-XXX. Log as new requirement?"
- Perfection paralysis: "Works now. Optimize when [metric] hit."
- Architecture debates: "Minimal for now. Revisit at [trigger]."
```

**Tasks:**
- [x] Add to gco-dev.md
- [x] Add to gco-project-manager.md
- [x] Add to gco-research.md

**Files:**
- `Haunt/agents/gco-dev.md` (modify)
- `Haunt/agents/gco-project-manager.md` (modify)
- `Haunt/agents/gco-research.md` (modify)

**Effort:** S
**Agent:** Dev-Infrastructure
**Completion:** All 3 agents have Response Patterns section
**Blocked by:** None

---

## Summary

| Batch | Count | Theme |
|-------|-------|-------|
| 0: Safety Net | 3 | Backups + reversion plan (FIRST) |
| 1: Technical Skills | 6 | Compress tutorials to bullets |
| 2: Workflow Skills | 3 | Remove redundant examples |
| 3: New Rules | 3 | Promote principles to always-on |

**Total:** 15 requirements
**Estimated savings:** ~5,000+ lines across skills

**Dependency Chain:**
```
REQ-362 (backup) ──┬──► REQ-363 (reversion plan)
                   │
REQ-364 (drafts) ──┴──► All Batch 1 & 2 requirements
```

**Rollback:** If compression causes issues, see `.haunt/docs/REVERSION-PLAN.md`
