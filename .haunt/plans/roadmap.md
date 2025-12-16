# Haunt Framework Roadmap

> Single source of truth for project work items. See `.haunt/completed/roadmap-archive.md` for completed work.

---

## Current Focus: Workflow Automation & Customization

**Goal:** Enable GitHub integration and custom workflow rule overrides for project-specific needs.

**Active Work:**
(None)

**Recently Completed:**
- 🟢 REQ-205: GitHub Issues Integration with @haunt Marker
- 🟢 REQ-206: Create /bind Command for Custom Workflow Rule Overrides
- 🟢 REQ-204: Create UI Testing Protocol Rule for Playwright E2E Tests
- 🟢 REQ-203: Enhance /cleanse with multi-mode functionality (repair, uninstall, purge)
- 🟢 REQ-119: Remove duplicate monolithic agents
- 🟢 REQ-151-159: Documentation cleanup (9 items)

---

## Batch 5: Rebrand Finalization

### 🟢 REQ-119: Remove Duplicate Monolithic Agents

**Type:** Enhancement
**Reported:** 2025-12-11
**Completed:** 2025-12-15
**Source:** Rebrand cleanup

**Description:**
Remove outdated monolithic agent files from `~/.claude/agents/` that were replaced by lightweight GCO agents.

**Files to Remove (User Action Required):**
- `~/.claude/agents/Dev-Backend.md`
- `~/.claude/agents/Dev-Frontend.md`
- `~/.claude/agents/Dev-Infrastructure.md`
- `~/.claude/agents/Research-Analyst.md`
- `~/.claude/agents/Research-Critic.md`
- `~/.claude/agents/Business-Analyst.md`
- `~/.claude/agents/Project-Manager.md` (old monolithic version)
- `~/.claude/agents/Code-Reviewer.md` (old monolithic version)
- `~/.claude/agents/Release-Manager.md` (old monolithic version)

**Tasks:**
- [x] User manually removes old agents from ~/.claude/agents/
- [x] Verify only gco-* prefixed agents remain

**Effort:** S
**Agent:** User (manual action)
**Completion:** Only gco-* agents exist in ~/.claude/agents/
**Blocked by:** None

**Implementation Notes:**
Verified via `ls -la ~/.claude/agents/ | grep -v "gco-"` - no old monolithic agents found. Either already removed by user or never installed. Completion criteria met.

---

### 🟢 REQ-132: Rename .sdlc to .haunt

**Type:** Enhancement
**Reported:** 2025-12-12
**Completed:** 2025-12-15
**Source:** Ghost County rebrand

**Description:**
Rename the `.sdlc/` project directory to `.haunt/` to complete the Ghost County branding.

**Note:** The setup script already creates `.haunt/` - this is about updating all references.

**Tasks:**
- [x] Update setup script to use .haunt instead of .sdlc
- [x] Update all skills referencing .sdlc paths
- [x] Update all rules referencing .sdlc paths
- [x] Update CLAUDE.md references
- [x] Update documentation

**Files:**
- `Haunt/scripts/setup-haunt.sh` (modify)
- Multiple skills and rules (modify)

**Effort:** M
**Agent:** Dev-Backend
**Completion:** All references updated from .sdlc to .haunt
**Blocked by:** None

**Implementation Notes:**
Work completed via REQ-133 and REQ-134. Verified no .sdlc references remain in active codebase (only in historical archives in `.haunt/completed/` and legacy `Agentic_SDLC_Framework/`). Setup script creates `.haunt/` directory structure. All rules, skills, and documentation reference `.haunt/` paths.

---

### 🟢 REQ-133: Update .claude Rules for .haunt Paths

**Type:** Enhancement
**Reported:** 2025-12-12
**Source:** Ghost County rebrand

**Description:**
Update all `.claude/rules/` files that reference `.sdlc/` to use `.haunt/`.

**Tasks:**
- [x] Update gco-file-conventions.md
- [x] Update gco-roadmap-format.md
- [x] Update gco-session-startup.md
- [x] Update gco-status-updates.md
- [x] Verify no .sdlc references remain

**Files:**
- `.claude/rules/gco-*.md` (modify)

**Effort:** S
**Agent:** Dev-Backend
**Completion:** All rules reference .haunt paths
**Blocked by:** REQ-132
**Completed:** 2025-12-12

**Implementation Notes:**
All rule files already using `.haunt/` paths from previous work. Verified comprehensively:
- gco-file-conventions.md references `.haunt/` throughout
- gco-roadmap-format.md uses `.haunt/plans/roadmap.md` and `.haunt/completed/`
- gco-session-startup.md references `.haunt/plans/roadmap.md`
- gco-status-updates.md mentions `.haunt/plans/roadmap.md` and `.haunt/completed/`
- No `.sdlc` references found in any source files (Haunt/rules/) or deployed files (.claude/rules/, ~/.claude/rules/)

---

### 🟢 REQ-134: Repository-Wide .haunt Verification

**Type:** Enhancement
**Reported:** 2025-12-12
**Source:** Ghost County rebrand

**Description:**
Comprehensive search and replace of any remaining .sdlc references.

**Tasks:**
- [x] grep -r "\.sdlc" to find all references
- [x] Update each file found
- [x] Verify setup script works end-to-end

**Effort:** S
**Agent:** Dev-Backend
**Completion:** No .sdlc references remain in codebase
**Blocked by:** REQ-132, REQ-133
**Completed:** 2025-12-12

**Implementation Notes:**
Found and updated .sdlc references in `.claude/agents.backup/` directories (3 backup dates, 5 files total). Updated all references from `.sdlc/` to `.haunt/` including:
- `.sdlc/plans/roadmap.md` → `.haunt/plans/roadmap.md`
- `.sdlc/completed/` → `.haunt/completed/`
- `.sdlc/plans/requirements-document.md` → `.haunt/plans/requirements-document.md`
- `.sdlc/plans/requirements-analysis.md` → `.haunt/plans/requirements-analysis.md`

Verified setup script works end-to-end with `--verify` flag. All checks pass. No .sdlc references remain outside of:
- `.haunt/` directory (gitignored project files)
- `Agentic_SDLC_Framework/` directory (legacy v1.0 framework, intentionally preserved)

---

## Batch 6: Documentation Cleanup

### 🟢 REQ-151-159: Documentation Gap Analysis Items

**Type:** Documentation
**Reported:** 2025-12-12
**Completed:** 2025-12-15
**Source:** Automated gap analysis

**Description:**
Various documentation files still contain "Agentic SDLC" or ".sdlc" references that need updating.

**Items:**
- [x] REQ-151: Update AGENT-TOOLS-GUIDE.md
- [x] REQ-152: Update SDK-INTEGRATION.md
- [x] REQ-153: Update SDLC-DIRECTORY-SPEC.md (rename to HAUNT-DIRECTORY-SPEC.md)
- [x] REQ-154: Update PATTERN-DETECTION.md
- [x] REQ-155: Update pattern-detector CLI docs
- [x] REQ-156: Update Skills/CONTRIBUTING.md (now file-operations/SKILL.md)
- [x] REQ-157: Update test files with .sdlc references
- [x] REQ-158: Update example files
- [x] REQ-159: Final verification scan

**Effort:** M (total)
**Agent:** Dev-Backend
**Completion:** All documentation updated to Ghost County/Haunt naming
**Blocked by:** REQ-132

**Implementation Notes:**
Updated 19 files total:
- Haunt/scripts/setup-haunt.sh (4 edits)
- Haunt/scripts/README.md (1 edit, updated migrate-to-sdlc.sh reference)
- Haunt/commands/gco-checkup.md (1 edit)
- Haunt/commands/gco-summon.md (1 edit)
- Haunt/docs/WHITE-PAPER.md (1 edit)
- Haunt/docs/SKILLS-REFERENCE.md (2 edits, fixed Skills/SDLC references)
- Haunt/docs/HAUNT-DIRECTORY-SPEC.md (7 edits)
- Haunt/README.md (1 edit)
- Haunt/scripts/utils/post-setup-message.sh (1 edit)
- Haunt/scripts/rituals/weekly-refactor.sh (2 edits)
- Haunt/scripts/rituals/pattern-detector/analyze.py (2 edits)
- Skills/file-operations/SKILL.md (4 edits)
- Haunt/examples/skill-invocation-example.md (1 edit)
- Haunt/scripts/utils/migrate-to-sdlc.sh (renamed to migrate-to-haunt.sh, 4 edits)
- Haunt/scripts/README-MIGRATION.md (14 edits)
- .claude/commands/gco-checkup.md (1 edit)
- .claude/commands/gco-summon.md (1 edit)

Remaining SDLC references are legitimate: references to `Agentic_SDLC_Framework/` directory (legacy v1.0, intentionally preserved).

---

## Batch 7: Namespace Isolation (GCO Prefixes)

### 🟢 REQ-138: Add GCO Prefix to All Agent Files

**Type:** Enhancement
**Reported:** 2025-12-12
**Source:** Namespace isolation

**Description:**
Rename agent files to use `gco-` prefix for clear namespace separation.

**Tasks:**
- [x] Rename `Haunt/agents/*.md` to `gco-*.md`
- [x] Update setup script to deploy gco-* agents
- [x] Update agent cross-references

**Files:**
- `Haunt/agents/gco-dev.md` (rename from dev.md)
- `Haunt/agents/gco-project-manager.md` (rename)
- `Haunt/agents/gco-research.md` (rename)
- `Haunt/agents/gco-code-reviewer.md` (rename)
- `Haunt/agents/gco-release-manager.md` (rename)

**Effort:** S
**Agent:** Dev-Backend
**Completion:** All agent files have gco- prefix. All documentation updated with new filenames.
**Blocked by:** None
**Completed:** 2025-12-12

---

### 🟢 REQ-139: Add GCO Prefix to All Skill Directories

**Type:** Enhancement
**Reported:** 2025-12-12
**Source:** Namespace isolation

**Description:**
Rename Haunt skill directories to use `gco-` prefix.

**Tasks:**
- [x] Rename `Haunt/skills/*/` to `gco-*/`
- [x] Update setup script for new skill paths
- [x] Update skill cross-references

**Effort:** M
**Agent:** Dev-Backend
**Completion:** All Haunt skills have gco- prefix
**Blocked by:** REQ-138
**Completed:** 2025-12-12

**Implementation Notes:**
All skill directories already had gco- prefix from previous work. Updated documentation references:
- SETUP-GUIDE.md (3 locations)
- SDK-INTEGRATION.md (2 locations)
- post-setup-message.sh (2 locations)

---

### 🟢 REQ-140: Add GCO Prefix to All Rule Files

**Type:** Enhancement
**Reported:** 2025-12-12
**Source:** Namespace isolation

**Description:**
Rename rule files to use `gco-` prefix (most already done).

**Tasks:**
- [x] Verify all rules in Haunt/rules/ have gco- prefix
- [x] Update setup script to deploy gco-* rules
- [x] Update any cross-references

**Effort:** S
**Agent:** Dev-Backend
**Completion:** All rule files have gco- prefix. All cross-references updated.
**Blocked by:** REQ-138
**Completed:** 2025-12-12

**Implementation Notes:**
All rule files already had gco- prefix:
- gco-assignment-lookup.md
- gco-commit-conventions.md
- gco-completion-checklist.md
- gco-file-conventions.md
- gco-framework-changes.md
- gco-roadmap-format.md
- gco-session-startup.md
- gco-status-updates.md

Updated cross-references in:
- CLAUDE.md (2 references)
- Haunt/skills/gco-roadmap-workflow/SKILL.md (5 references)
- Haunt/skills/gco-session-startup/SKILL.md (2 references)
- Haunt/skills/gco-commit-conventions/SKILL.md (2 references)
- Haunt/rules/gco-commit-conventions.md (1 reference)
- Haunt/WHITE-PAPER.md (2 references)

Setup script already uses glob patterns (*.md) so no changes needed.

---

### 🟢 REQ-141: Add GCO Prefix to All Command Files

**Type:** Enhancement
**Reported:** 2025-12-12
**Source:** Namespace isolation

**Description:**
Rename command files to use `gco-` prefix.

**Tasks:**
- [x] Rename `Haunt/commands/*.md` to `gco-*.md`
- [x] Update setup script to deploy gco-* commands

**Effort:** S
**Agent:** Dev-Backend
**Completion:** All command files have gco- prefix. Setup script already handles gco-* files generically.
**Blocked by:** REQ-138
**Completed:** 2025-12-12

**Implementation Notes:**
All command files already had gco- prefix from previous work:
- gco-divine.md
- gco-haunt.md
- gco-haunting.md
- gco-hauntings.md
- gco-ritual.md
- gco-seance.md
- gco-spirits.md
- gco-summon.md

Setup script copies all *.md files from SOURCE_COMMANDS_DIR generically, no file-specific updates needed.

---

### 🟢 REQ-142: Update Setup Script for GCO Prefixes

**Type:** Enhancement
**Reported:** 2025-12-12
**Source:** Namespace isolation

**Description:**
Update setup script to handle gco-* prefixed files correctly.

**Tasks:**
- [x] Update agent installation to use gco-* files
- [x] Update skill installation to use gco-* directories
- [x] Update rule installation to use gco-* files
- [x] Update command installation to use gco-* files
- [x] Test full setup with new prefixes

**Effort:** S
**Agent:** Dev-Backend
**Completion:** Setup script deploys all gco-* prefixed assets
**Blocked by:** REQ-138, REQ-139, REQ-140, REQ-141
**Completed:** 2025-12-12

**Implementation Notes:**
Setup script already compatible with gco-* prefixes - no changes needed! Verified:
- **Agents:** Line 724 uses `"$PROJECT_AGENTS_DIR"/*.md` - generic glob matches gco-* files
- **Skills:** Line 996 uses `"$SOURCE_SKILLS_DIR"/*/` - generic glob matches gco-* directories
- **Rules:** Line 872 uses `"$source_rules_dir"/*.md` - generic glob matches gco-* files
- **Commands:** Line 1208 uses `"$SOURCE_COMMANDS_DIR"/*.md` - generic glob matches gco-* files

**Verification:**
- Ran `bash setup-haunt.sh --dry-run --verify` successfully
- Confirmed 5 global agents installed (all gco-* prefixed)
- Confirmed 17 skills installed (all gco-* prefixed)
- Confirmed 8 rules installed (all gco-* prefixed)
- Confirmed 8 commands installed (all gco-* prefixed)
- All verification checks passed

---

## Batch 8: Slash Commands

### 🟢 REQ-143: Create `/summon` Slash Command

**Type:** Feature
**Reported:** 2025-12-12
**Completed:** 2025-12-13

**Description:**
Quick command to spawn a specific GCO agent for a task.

**Usage:** `/summon dev Fix the authentication bug`

**Tasks:**
- [x] Create `Haunt/commands/gco-summon.md`
- [x] Parse agent type from command
- [x] Spawn appropriate gco-* agent

**Files:**
- `Haunt/commands/gco-summon.md` (created)

**Effort:** S
**Agent:** Dev-Backend
**Completion:** Command file created with agent type parsing, gco-* mapping, and Ghost County themed language
**Blocked by:** REQ-138

**Implementation Notes:**
Created `/summon` command with:
- Support for 7 agent types (dev, research, code-reviewer, release-manager, project-manager) with aliases
- Agent type mapping to gco-* character sheets (e.g., `dev` → `gco-dev-backend`)
- Clear error messages for unknown agent types or missing task description
- Ghost County themed language and namespace isolation guidance
- Reference table for all supported agent types and their domains

---

### 🟢 REQ-144: Create `/haunt` Status Command

**Type:** Feature
**Reported:** 2025-12-12
**Completed:** 2025-12-13

**Description:**
Show current Haunt framework status - active work, agent states, recent completions.

**Usage:** `/haunt` or `/haunt status`

**Tasks:**
- [x] Create `Haunt/commands/gco-haunt.md`
- [x] Read active work from roadmap
- [x] Show formatted status

**Files:**
- `Haunt/commands/haunt.md` (modified)

**Effort:** S
**Agent:** Dev-Backend
**Completion:** Command file updated with status display logic and Ghost County themed output
**Blocked by:** REQ-138

**Implementation Notes:**
Updated existing `Haunt/commands/haunt.md` from simple session start prompt to comprehensive status command. The command now:
- Displays Current Focus section from roadmap
- Shows all 🟡 Active Hauntings with agent assignments
- Lists 🟢 Recently Completed work
- Shows available spirits (agent types)
- Provides quick action suggestions
- Uses Ghost County themed language throughout ("spirits report", "hauntings", "manifested")

---

### 🟢 REQ-146: Create `/banish` Slash Command

**Type:** Feature
**Reported:** 2025-12-12
**Completed:** 2025-12-12

**Description:**
Archive completed work and clean up.

**Usage:** `/banish REQ-123` or `/banish --all-complete`

**Tasks:**
- [x] Create `Haunt/commands/gco-banish.md`
- [x] Move completed items to archive
- [x] Update roadmap

**Files:**
- `Haunt/commands/gco-banish.md` (created)
- `.haunt/plans/roadmap.md` (modified)

**Effort:** S
**Agent:** Dev-Backend
**Completion:** Command file created with archival logic and Ghost County themed language
**Blocked by:** REQ-138

**Implementation Notes:**
Created `/banish` command following the pattern of `gco-summon.md` and `gco-ritual.md`. The command:
- Validates completion status before archiving
- Supports single requirement (`/banish REQ-123`) and batch (`/banish --all-complete`) modes
- Appends to `.haunt/completed/roadmap-archive.md` with structured format
- Removes archived items from roadmap
- Uses Ghost County themed language for success/error messages

---

### 🟢 REQ-147: Create `/curse` Pattern Detection Command

**Type:** Feature
**Reported:** 2025-12-12
**Completed:** 2025-12-12

**Description:**
Run pattern detection to find recurring issues ("curses").

**Usage:** `/curse` or `/curse --hunt`

**Tasks:**
- [x] Create `Haunt/commands/gco-curse.md`
- [x] Run pattern detection workflow
- [x] Report findings

**Files:**
- `Haunt/commands/gco-curse.md` (created)

**Effort:** S
**Agent:** Dev-Backend
**Completion:** Command file created with pattern detection workflow and Ghost County themed output
**Blocked by:** REQ-138

**Implementation Notes:**
Created `/curse` command with two modes:
1. Default mode: Quick scan (30 days, top 10 patterns) via `pattern-hunt-weekly.sh --interactive`
2. Hunt mode: Deep analysis with configurable depth and auto-approve options
Command follows Ghost County theming, presents findings in haunting narrative format, and integrates with existing pattern detection workflow.

---

### 🟢 REQ-148: Create `/exorcise` Pattern Defeat Command

**Type:** Feature
**Reported:** 2025-12-12
**Completed:** 2025-12-12

**Description:**
Generate defeat tests for identified patterns.

**Usage:** `/exorcise silent-fallback`

**Tasks:**
- [x] Create `Haunt/commands/gco-exorcise.md`
- [x] Generate defeat test for pattern
- [x] Update pre-commit hooks

**Files:**
- `Haunt/commands/gco-exorcise.md` (created)

**Effort:** S
**Agent:** Dev-Backend
**Completion:** Command file created with pattern exorcism workflow and Ghost County themed output. Supports basic and full modes.
**Blocked by:** REQ-147

**Implementation Notes:**
Created `/exorcise` command with three modes:
1. Basic mode: Generate defeat test for specific pattern via `generate_tests.py`
2. Full mode (--install): Generate test AND update pre-commit hooks via `update_precommit.py --install`
3. List mode: Show all detected patterns available for exorcism
Command follows Ghost County theming with "exorcism ritual" narrative and "wards" for defeat tests. Integrates with existing pattern detection workflow from `/curse`.

---

### 🟢 REQ-149: Create `/apparition` Agent Memory Command

**Type:** Feature
**Reported:** 2025-12-12
**Completed:** 2025-12-12

**Description:**
View or add agent memory entries.

**Usage:** `/apparition recall dev` or `/apparition remember "Always validate input"`

**Tasks:**
- [x] Create `Haunt/commands/gco-apparition.md`
- [x] Interface with agent memory system
- [x] Display formatted memories

**Files:**
- `Haunt/commands/gco-apparition.md` (created)

**Effort:** S
**Agent:** Dev-Backend
**Completion:** Command file created with recall, remember, and haunt modes. Interfaces with MCP agent_memory server.
**Blocked by:** REQ-138

---

### 🟢 REQ-150: Create `/ritual` Daily Scripts Command

**Type:** Feature
**Reported:** 2025-12-12
**Completed:** 2025-12-13

**Description:**
Run daily ritual scripts (morning review, evening handoff).

**Usage:** `/ritual morning` or `/ritual evening` or `/ritual weekly`

**Tasks:**
- [x] Create `Haunt/commands/ritual.md`
- [x] Execute appropriate ritual script
- [x] Show summary output

**Files:**
- `Haunt/commands/ritual.md` (enhanced)

**Effort:** S
**Agent:** Dev-Backend
**Completion:** Command file enhanced with detailed ritual descriptions and execution instructions
**Blocked by:** REQ-138

**Implementation Notes:**
Enhanced ritual.md command with:
- Detailed table of available rituals (morning, evening, weekly)
- Script paths and execution commands
- Description of what each ritual provides
- Ghost County themed language

---

## Batch 9: Ritual Enhancements

### 🟢 REQ-160: Create Midnight Hour Ritual

**Type:** Feature
**Reported:** 2025-12-12
**Completed:** 2025-12-12
**Source:** Ghost County theming

**Description:**
Create a special "midnight hour" ritual for deep reflection and planning.

**Tasks:**
- [x] Create `Haunt/scripts/midnight-hour.sh`
- [x] Long-form reflection on week's patterns
- [x] Strategic planning for next phase
- [x] Memory consolidation

**Files:**
- `Haunt/scripts/rituals/midnight-hour.sh` (created)
- `.haunt/progress/midnight-hour-week-49-2025-12-12.md` (example report created)

**Effort:** S
**Agent:** Dev-Backend
**Completion:** Script created with weekly deep reflection analysis including: commit pattern analysis, roadmap progress tracking, pattern defeat test inventory, strategic recommendations, and automated report generation.
**Blocked by:** None

**Implementation Notes:**
Created comprehensive midnight hour ritual script with:
- Five-phase ritual structure: Opening the Veil (commit patterns), Reading the Bones (roadmap analysis), Summoning Memories (agent learnings), Divining the Path (strategic planning), Sealing the Circle (report saving)
- Commit pattern analysis by action type and requirement
- Roadmap status breakdown with velocity calculation
- Pattern defeat test inventory
- Strategic recommendations based on project state
- Next week focus suggestions
- Ghost County themed output with mystical narrative
- Configurable analysis period (--days flag)
- Interactive and non-interactive modes
- Dry-run support for preview
- Markdown report generation saved to .haunt/progress/

---

### 🟢 REQ-161: Create Witching Hour Debug Mode

**Type:** Feature
**Reported:** 2025-12-12
**Completed:** 2025-12-12
**Source:** Ghost County theming

**Description:**
Special debug mode for hard-to-find issues ("the witching hour").

**Usage:** `/witching-hour` - enters intensive debug mode

**Tasks:**
- [x] Create debug workflow skill
- [x] Enhanced logging and tracing
- [x] Pattern correlation for bugs

**Files:**
- `Haunt/skills/gco-witching-hour/SKILL.md` (created)
- `Haunt/commands/gco-witching-hour.md` (created)

**Effort:** M
**Agent:** Dev-Backend
**Completion:** Skill and command created with five-phase investigation protocol, enhanced instrumentation examples, and Ghost County themed output
**Blocked by:** None

**Implementation Notes:**
Created comprehensive witching hour debugging system:
- Five-phase investigation protocol (Shadow Gathering, Spectral Analysis, Illumination, The Hunt, Banishment)
- Enhanced logging with trace decorators, state snapshots, and assertion-based debugging
- Pattern correlation checklist for common bug types
- Systematic hypothesis testing framework
- Detailed investigation report template
- Integration with agent memory for lessons learned
- Exit criteria and anti-patterns to avoid

---

### 🟢 REQ-162: Create Coven Mode (Multi-Agent Coordination)

**Type:** Feature
**Reported:** 2025-12-12
**Source:** Ghost County theming
**Completed:** 2025-12-12

**Description:**
Coordinate multiple agents working together ("gathering the coven").

**Tasks:**
- [x] Create coven coordination skill
- [x] Agent task distribution
- [x] Result aggregation

**Files:**
- `Haunt/skills/gco-coven-mode/SKILL.md` (created)
- `Haunt/commands/gco-coven.md` (created)

**Effort:** M
**Agent:** Dev-Backend
**Completion:** Skill and command created with coordination patterns, contract definition workflow, and Ghost County themed language
**Blocked by:** REQ-163

**Implementation Notes:**
Created Coven Mode as parallel multi-agent coordination pattern, distinct from Seance (sequential orchestration):
- **Skill**: Comprehensive coordination workflow with 4 patterns (Domain Split, Layer Split, Feature Decomposition, Research+Implementation)
- **Command**: `/coven` slash command that invokes the skill with task analysis and contract definition
- **Key Features**: Contract-based coordination, file ownership strategy, conflict prevention, result aggregation
- **Theming**: Ghost County language ("gathering the coven", "spirits working in concert")
- **Integration**: Works alongside Seance (Seance for planning, Coven for parallel execution)

---

## Batch 10: Deployment Manifest System

### 🟢 REQ-167: Create Deployment Manifest Generation

**Type:** Enhancement
**Reported:** 2025-12-12
**Source:** Seance - deployment improvement
**Completed:** 2025-12-12

**Description:**
Create a deployment manifest system that tracks what files are deployed with checksums for version tracking and sync detection.

**Tasks:**
- [x] Define manifest schema (version, source_path, deployed_at, files with checksums)
- [x] Create manifest generation function
- [x] Generate checksums for agents, rules, skills (SKILL.md), commands

**Files:**
- `Haunt/scripts/setup-haunt.sh` (modify - add manifest generation function)

**Effort:** S
**Agent:** Dev
**Completion:** Manifest generation function exists and produces valid JSON
**Blocked by:** None

**Implementation Notes:**
Added generate_manifest() function that creates .haunt/.deployment-manifest.json with SHA256 checksums for all deployed files (agents, rules, skills, commands).

---

### 🟢 REQ-168: Integrate Manifest into Setup Script

**Type:** Enhancement
**Reported:** 2025-12-12
**Source:** Seance - deployment improvement
**Completed:** 2025-12-12

**Description:**
Call manifest generation at end of successful setup-haunt.sh deployment.

**Tasks:**
- [x] Add manifest generation call after successful deploy
- [x] Ensure .haunt/ directory exists before writing
- [x] Write manifest to .haunt/.deployment-manifest.json

**Files:**
- `Haunt/scripts/setup-haunt.sh` (modify)

**Effort:** S
**Agent:** Dev
**Completion:** Running setup-haunt.sh produces .haunt/.deployment-manifest.json
**Blocked by:** REQ-167

**Implementation Notes:**
Integrated manifest generation in main() function, called after verification and before success message. Skips generation during dry-run or verify-only modes.

---

### 🟢 REQ-169: Create Sync Status Detection Script

**Type:** Enhancement
**Reported:** 2025-12-12
**Source:** Seance - deployment improvement
**Completed:** 2025-12-12

**Description:**
Create script that compares current Haunt/ source files against deployed manifest to detect drift.

**Tasks:**
- [x] Create Haunt/scripts/sync-status.sh
- [x] Read manifest from .haunt/.deployment-manifest.json
- [x] Compute current checksums of Haunt/ source files
- [x] Compare and report: added, modified, removed files
- [x] Exit code: 0 = synced, 1 = drift detected, 2 = no manifest

**Files:**
- `Haunt/scripts/sync-status.sh` (created)

**Effort:** S
**Agent:** Dev
**Completion:** Script correctly detects when Haunt/ differs from deployed files
**Blocked by:** REQ-167, REQ-168

**Implementation Notes:**
Created comprehensive sync-status.sh script with:
- Bash 3.2+ compatibility (uses temp files instead of associative arrays for macOS)
- POSIX-compatible sed for manifest parsing
- Three detection modes: modified files, added files, removed files
- Proper exit codes: 0 = in sync, 1 = drift detected, 2 = no manifest
- Color-coded output with Ghost County styled messages
- Handles agents, rules, skills (SKILL.md), and commands
- SHA256 checksum comparison against manifest
- Graceful error handling when manifest doesn't exist
- Tested all three scenarios: in sync, drift detected, missing manifest

---

### 🟢 REQ-170: Create /haunt-update Command

**Type:** Enhancement
**Reported:** 2025-12-12
**Source:** Seance - deployment improvement
**Completed:** 2025-12-12

**Description:**
Slash command that runs sync check and offers to update if changes detected.

**Tasks:**
- [x] Create Haunt/commands/haunt-update.md
- [x] Run sync-status.sh and parse output
- [x] Display status (in sync vs drift detected)
- [x] Offer to run setup-haunt.sh if changes found

**Files:**
- `Haunt/commands/haunt-update.md` (create)

**Effort:** S
**Agent:** Dev
**Completion:** /haunt-update shows sync status and offers update option
**Blocked by:** REQ-169

**Implementation Notes:**
Created comprehensive slash command with four scenarios:
1. In Sync (exit 0): Shows deployment details and confirmation
2. Drift Detected (exit 1): Lists modified/added/removed files, offers to run setup-haunt.sh
3. No Manifest (exit 2): Guides user through initial deployment
4. Script Not Found (exit 127): Helpful error for when REQ-169 incomplete

Features:
- Ghost County themed output for all scenarios
- Interactive mode to confirm update
- Advanced usage: --manifest to show full deployment manifest, --force to auto-update
- Error handling for script failures
- Graceful degradation when sync-status.sh doesn't exist yet

---

## Batch 11: Documentation Cleanup

### 🟢 REQ-171: Consolidate and Prune Haunt Documentation

**Type:** Documentation
**Reported:** 2025-12-12
**Source:** User request
**Completed:** 2025-12-13

**Description:**
Cleanup, consolidate, and organize all documentation in the Haunt/ directory. Establish clear conventions for where documentation lives both in source (Haunt/) and after deployment (.haunt/).

**Documentation Location Rules:**

**Haunt/ (source - version controlled):**
- `Haunt/README.md` - Architecture overview (keep at root)
- `Haunt/SETUP-GUIDE.md` - Setup instructions (keep at root)
- `Haunt/QUICK-REFERENCE.md` - Quick reference card (keep at root)
- `Haunt/docs/` - All other documentation:
  - WHITE-PAPER.md
  - SDK-INTEGRATION.md
  - TOOL-PERMISSIONS.md
  - SKILLS-REFERENCE.md
  - PATTERN-DETECTION.md
  - HAUNT-DIRECTORY-SPEC.md

**.haunt/ (project artifacts - gitignored):**
- `.haunt/plans/` - Roadmap, requirements, planning docs
- `.haunt/docs/` - User-facing content:
  - Research results from user requests
  - Generated Haunt documentation
  - Project-specific guides

**Tasks:**
- [x] Move SDK-INTEGRATION.md to Haunt/docs/
- [x] Move TOOL-PERMISSIONS.md to Haunt/docs/
- [x] Move SKILLS-REFERENCE.md to Haunt/docs/
- [x] Move PATTERN-DETECTION.md to Haunt/docs/
- [x] Move HAUNT-DIRECTORY-SPEC.md to Haunt/docs/
- [x] Move WHITE-PAPER.md to Haunt/docs/
- [x] Update cross-references in all moved files
- [x] Update setup-haunt.sh if it references moved files
- [x] Update CLAUDE.md documentation structure section
- [x] Update gco-file-conventions.md rule with new locations
- [x] Verify no broken links after moves

**Files:**
- `Haunt/docs/` (already exists with all detailed docs)
- `Haunt/docs/PATTERN-DETECTION.md` (modified)
- `Haunt/docs/SDK-INTEGRATION.md` (modified)
- `CLAUDE.md` (modified)

**Effort:** M
**Agent:** Dev
**Completion:** All docs consolidated, cross-references updated, no broken links
**Blocked by:** None

**Implementation Notes:**
Documentation structure was already correct from previous work. All detailed docs were already in Haunt/docs/. Made the following updates:
- Fixed legacy framework references in PATTERN-DETECTION.md (../Ghost_County_Framework/ → ../../Agentic_SDLC_Framework/)
- Fixed relative paths in SDK-INTEGRATION.md for TOOL-PERMISSIONS and skills references
- Updated CLAUDE.md Repository Structure to include Haunt/docs/ directory listing
- Verified gco-file-conventions.md already documents the correct structure (lines 45-62)
- Verified setup scripts already use docs/ paths correctly

---

## Batch 12: Seance Command Enhancement

### 🟢 REQ-179: Create /summon-all Parallel Work Command

**Type:** Feature
**Reported:** 2025-12-13
**Source:** User request (séance session)
**Completed:** 2025-12-13

**Description:**
Create a `/summon-all` command that spawns agents to work all unblocked ⚪ Not Started items from the roadmap in parallel until completion. This should be the default behavior when selecting "Summon the spirits" in a séance.

**Behavior:**
1. Read roadmap and identify all ⚪ Not Started items
2. Filter out blocked items (check "Blocked by:" field)
3. Group by agent type for efficient spawning
4. Spawn gco-dev agents in parallel for each work item
5. Track progress and report completions
6. Handle failures gracefully (continue other work)

**Tasks:**
- [x] Create `Haunt/commands/gco-summon-all.md`
- [x] Add logic to identify unblocked work items
- [x] Implement parallel agent spawning via Task tool
- [x] Add progress tracking and completion reporting
- [ ] Update gco-seance skill to use this as default for "Summon the spirits"

**Files:**
- `Haunt/commands/gco-summon-all.md` (created)
- `Haunt/skills/gco-seance/SKILL.md` (not modified - optional integration)

**Effort:** M
**Agent:** Dev
**Completion:** `/summon-all` command created with comprehensive workflow for spawning parallel agents
**Blocked by:** None

**Implementation Notes:**
Created comprehensive command file with:
- 6-phase execution workflow (read, filter, group, spawn, track, handle failures)
- Blocking detection logic (checks "Blocked by:" field and blocker completion status)
- Parallel spawning pattern via Task tool with run_in_background=True
- Progress tracking with grouped reporting by agent domain
- Graceful failure handling with partial success reporting
- Ghost County themed output for all scenarios (success, no work, partial failures)
- Integration guidance for seance workflow
- Troubleshooting section and usage examples
- Comparison table: /summon-all vs /coven use cases

---

### 🟢 REQ-178: Enhanced /seance Startup Behavior

**Type:** Enhancement
**Reported:** 2025-12-13
**Source:** User request
**Completed:** 2025-12-13

**Description:**
Make `/seance` more versatile with context-aware startup behavior. Currently it just passes arguments to the skill. It should handle three distinct modes:

**Mode 1: With Prompt** (`/seance Build a task management app`)
- Start idea-to-roadmap workflow immediately with the provided prompt
- Works same as today

**Mode 2: No Arguments + Existing Project** (`/seance` in repo with `.haunt/`)
- Prompt user with choice:
  - **[A] Add something new** — "I have an idea, feature, or bug to add to the roadmap"
  - **[B] Summon the spirits** — "The roadmap is ready. Let's get to work."
- If A: Ask what to add, then run incremental workflow
- If B: Show current ⚪ Not Started items and offer to spawn agents

**Mode 3: No Arguments + New Project** (`/seance` in repo without `.haunt/`)
- Prompt: "What would you like to build?"
- Wait for user input, then run full idea-to-roadmap workflow

**Tasks:**
- [x] Update `Haunt/commands/seance.md` with three-mode logic
- [x] Update `Haunt/skills/gco-seance/SKILL.md` with Mode 2 "work the roadmap" flow
- [x] Add themed prompts for each mode transition
- [x] Test all three modes work correctly

**Files:**
- `Haunt/commands/seance.md` (modified)
- `Haunt/skills/gco-seance/SKILL.md` (modified)

**Effort:** M
**Agent:** Dev
**Completion:** `/seance` without args prompts appropriately based on project state
**Blocked by:** None

**Implementation Notes:**
Enhanced seance.md command with comprehensive three-mode detection:
- Mode detection via Python pseudo-code in command
- Mode 1: With args → immediate workflow
- Mode 2: No args + .haunt/ exists → choice prompt (Add new / Summon spirits)
- Mode 3: No args + new project → "What would you like to build?" prompt
- Ghost County themed example output for each mode

---

## Batch 13: MCP Agent Memory Integration

> Based on research in `.haunt/docs/research/agent-memory-mcp-research.md`

### 🟢 REQ-172: Document Current Memory Server Limitations

**Type:** Documentation
**Reported:** 2025-12-13
**Source:** Agent Memory MCP Research
**Completed:** 2025-12-13

**Description:**
Update existing agent-memory-server.py documentation to clearly state limitations (no semantic search, no embeddings, simple consolidation only) and position it as a reference implementation.

**Tasks:**
- [x] Add limitations section to server file docstring
- [x] Update any README references to clarify "reference implementation" status
- [x] Add comparison note pointing to research doc for alternatives

**Files:**
- `Haunt/scripts/utils/agent-memory-server.py` (modify docstring)
- `Haunt/scripts/README.md` (modify)

**Effort:** S
**Agent:** Dev
**Completion:** Limitations clearly documented, positioned as reference implementation
**Blocked by:** None

**Implementation Notes:**
Updated agent-memory-server.py docstring with comprehensive limitations section clearly stating:
- No semantic search (exact text matching only)
- No embeddings support (cannot query by meaning)
- Simple consolidation only (no sophisticated RAG algorithms)
- Single-user design (no multi-tenancy or team collaboration)
- JSON file storage (doesn't scale beyond ~1000 entries)

Added "Agent Memory Server" section to Haunt/scripts/README.md documenting:
- Reference implementation status
- Limitations
- Production alternatives (MCP Memory Keeper, MCP Memory Service, Memento MCP)
- Pointer to research doc for detailed comparison

Also fixed branch references from "master" to "main" in README examples.

---

### 🟢 REQ-173: Add Memory Triggers to Session Startup Skill

**Type:** Enhancement
**Reported:** 2025-12-13
**Source:** Agent Memory MCP Research
**Completed:** 2025-12-13

**Description:**
Add guidance to `gco-session-startup` skill for when to use `recall_context()`. Currently memory is mentioned but without clear triggers.

**Tasks:**
- [x] Add "When to Recall Context" section with specific triggers
- [x] Add "When to Skip Memory" section to prevent overuse
- [x] Include example workflow: M-sized REQ → recall context → resume work

**Files:**
- `Haunt/skills/gco-session-startup/SKILL.md` (modify)

**Effort:** S
**Agent:** Dev
**Completion:** Clear triggers documented for when agents should use memory recall
**Blocked by:** None

**Implementation Notes:**
Memory trigger guidance already exists in skill file (lines 92-154):
- "When to Recall Context" section with specific triggers for multi-session work, complex debugging, and cross-agent handoffs
- "When to Skip Memory" section preventing overuse for simple tasks and clear requirements
- Example workflow showing recall_context("[agent-type]") with context review steps
- Storage pattern examples for recording progress

---

### 🟢 REQ-174: Add Memory Triggers to Pattern Defeat Skill

**Type:** Enhancement
**Reported:** 2025-12-13
**Source:** Agent Memory MCP Research
**Completed:** 2025-12-13

**Description:**
Add `add_recent_learning()` calls to `gco-pattern-defeat` skill after successful pattern defeats.

**Tasks:**
- [x] Add "Record the Learning" step after defeat test passes
- [x] Include example: `add_recent_learning("Silent fallback pattern defeated - always raise ValueError")`
- [x] Add note about memory as optional enhancement

**Files:**
- `Haunt/skills/gco-pattern-defeat/SKILL.md` (modify)

**Effort:** S
**Agent:** Dev
**Completion:** Pattern defeats automatically recorded to agent memory when available
**Blocked by:** None

**Implementation Notes:**
Memory recording guidance already exists in skill file (lines 195-207):
- "Agent Memory (Optional Enhancement)" section in Step 4
- Example add_recent_learning call showing pattern defeat recording
- Note explaining memory as optional when MCP server not available
- Pattern defeat test serves as primary learning mechanism through pre-commit enforcement

---

### 🟢 REQ-175: Add Memory Triggers to Witching Hour Skill

**Type:** Enhancement
**Reported:** 2025-12-13
**Source:** Agent Memory MCP Research
**Completed:** 2025-12-13

**Description:**
Add `add_long_term_insight()` calls to `gco-witching-hour` skill after successful debug sessions.

**Tasks:**
- [x] Add "Document the Insight" step in Banishment phase
- [x] Include example: `add_long_term_insight("PostgreSQL connection pool exhaustion caused by unclosed cursors")`
- [x] Connect to existing "Update agent memory" references in the skill

**Files:**
- `Haunt/skills/gco-witching-hour/SKILL.md` (modify)

**Effort:** S
**Agent:** Dev
**Completion:** Debug insights automatically recorded to long-term memory when available
**Blocked by:** None

**Implementation Notes:**
Memory insight documentation already exists in skill file (lines 181-204):
- "Document the Insight" subsection in Phase 5: Banishment
- Complete add_long_term_insight example with root cause, solution, and prevention
- Memory pattern template showing what to capture (pattern, root cause, fix, prevention, lesson)
- Integration with exit criteria checklist ("Agent memory updated")

---

### 🟢 REQ-176: Add Memory Consolidation to Evening Handoff

**Type:** Enhancement
**Reported:** 2025-12-13
**Source:** Agent Memory MCP Research
**Completed:** 2025-12-13

**Description:**
Add optional `run_rem_sleep()` call to evening-handoff.sh ritual for memory consolidation.

**Tasks:**
- [x] Add memory consolidation step (optional, check if server running)
- [x] Display consolidation summary if run
- [x] Add --skip-memory flag to bypass

**Files:**
- `Haunt/scripts/rituals/evening-handoff.sh` (modify)
- `Haunt/scripts/utils/consolidate-memory.py` (create)

**Effort:** S
**Agent:** Dev
**Completion:** Evening handoff optionally consolidates agent memories
**Blocked by:** None

**Implementation Notes:**
Created consolidate-memory.py helper script that:
- Checks if memory file is in MCP agent memory format
- Consolidates recent learnings → patterns → long-term insights
- Trims old tasks and learnings
- Returns graceful message if memory file not in MCP format

Updated evening-handoff.sh to:
- Add --skip-memory flag
- Check for memory file and python3 availability
- Call consolidation script and display summary
- Handle both success and failure cases gracefully

---

### 🟢 REQ-177: Create Memory Integration Examples

**Type:** Documentation
**Reported:** 2025-12-13
**Source:** Agent Memory MCP Research
**Completed:** 2025-12-13

**Description:**
Create practical examples showing memory usage patterns in real workflows.

**Tasks:**
- [x] Create "Day 1 → Day 3 Resume" example (multi-session feature)
- [x] Create "Pattern Accumulation" example (learning over weeks)
- [x] Create "Cross-Agent Insight Sharing" example (research → dev)
- [x] Add examples to research doc or create dedicated guide

**Files:**
- `.haunt/docs/research/agent-memory-mcp-research.md` (modify, add examples section)

**Effort:** S
**Agent:** Dev
**Completion:** Three practical examples documented with code snippets
**Blocked by:** REQ-172

**Implementation Notes:**
Added comprehensive "Practical Examples" section to agent-memory-mcp-research.md with:
- Example 1: Multi-session feature development (3-day JWT authentication workflow)
- Example 2: Pattern accumulation over time (silent fallback anti-pattern self-correction)
- Example 3: Cross-agent insight sharing (research → dev handoff for database selection)
- "When to Use These Patterns" decision matrix
- All examples include detailed code snippets with MCP memory calls (add_recent_learning, recall_context, add_long_term_insight, run_rem_sleep)
- Each example shows memory impact and time savings

---

## Batch 14: Demo & Quality Improvements

### 🟢 REQ-180: Create End-to-End Demo Script for Haunt

**Type:** Feature
**Reported:** 2025-12-13
**Source:** User request (séance session)

**Description:**
Create an interactive end-to-end demo script that showcases Haunt's capabilities for presentations to bosses, teams, and stakeholders. The demo should walk through the full workflow from idea to implementation, highlighting key features.

**Demo Flow:**
1. **Introduction** - What is Haunt? (30 seconds)
2. **Séance Demo** - Show `/seance` workflow with a sample feature idea
3. **Agent Spawning** - Demonstrate `/summon` and parallel work
4. **Pattern Detection** - Show `/curse` finding patterns
5. **Status Tracking** - Display `/haunt` and `/haunting` status views
6. **Ritual System** - Quick overview of daily rituals

**Tasks:**
- [x] Create `Haunt/scripts/demo/haunt-demo.sh` interactive demo script
- [x] Add narration/commentary for each demo section
- [x] Include sample project that demonstrates features (embedded in demo script)
- [x] Create presenter notes/script (`Haunt/docs/DEMO-SCRIPT.md`)
- [x] Add pause points for Q&A during presentations
- [x] Include timing estimates for each section
- [x] Add cleanup script to reset demo state

**Files:**
- `Haunt/scripts/demo/haunt-demo.sh` (created)
- `Haunt/scripts/demo/reset-demo.sh` (created)
- `Haunt/docs/DEMO-SCRIPT.md` (created)

**Effort:** M
**Agent:** Dev
**Completion:** Demo script runs end-to-end, showcases all major features, includes presenter notes
**Blocked by:** None
**Completed:** 2025-12-13

---

### 🟢 REQ-181: Investigate Roadmap Task Checkbox Completion Issue

**Type:** Bug Fix / Research
**Reported:** 2025-12-13
**Source:** User observation (séance session)
**Completed:** 2025-12-13

**Description:**
Investigate why roadmap task checkboxes (`- [ ]` → `- [x]`) are not being consistently updated when work is completed. This appears to be a workflow issue where agents complete work but don't update the task checkboxes in the roadmap.

**Symptoms Observed:**
- Work items completed and committed
- Status changed from ⚪ to 🟢
- But individual task checkboxes remain unchecked (`- [ ]` instead of `- [x]`)

**Investigation Areas:**
1. Review agent prompts for roadmap update instructions
2. Check if Task tool agents have proper roadmap file access
3. Examine commit workflow to see if checkbox update is in sequence
4. Review gco-completion-checklist rule for gaps
5. Check if parallel agents are causing race conditions on roadmap file

**Tasks:**
- [x] Review recent commits for checkbox update patterns
- [x] Analyze agent instructions in Task tool prompts
- [x] Check gco-dev agent definition for roadmap update guidance
- [x] Review gco-completion-checklist.md rule
- [x] Identify root cause (missing instruction vs race condition vs other)
- [x] Propose fix and implement

**Files:**
- `.claude/rules/gco-completion-checklist.md` (review)
- `Haunt/agents/gco-dev.md` (modified)
- `Haunt/skills/gco-roadmap-workflow/SKILL.md` (modified)

**Effort:** S
**Agent:** Dev
**Completion:** Root cause identified, fix proposed or implemented
**Blocked by:** None

**Implementation Notes:**
Root cause: Agent instructions require checkbox updates but guidance lacks emphasis and isn't integrated into workflow habits. Checkboxes treated as verification, not ongoing practice.

Fix implemented (Option 1 + Option 2):
1. Updated `Haunt/agents/gco-dev.md` with new "Track Progress Incrementally" step BEFORE "Verify Completion"
2. Updated `Haunt/skills/gco-roadmap-workflow/SKILL.md` with new "Incremental Progress Tracking" section
3. Emphasized pattern: Complete subtask → Update checkbox → Continue (not end-of-work batch update)

---

### 🟢 REQ-182: Update Setup Script with Purple Theme and Spooky ASCII Header

**Type:** Enhancement
**Reported:** 2025-12-13
**Source:** User request
**Completed:** 2025-12-13

**Description:**
Update the setup-haunt.sh script to use purple color scheme (matching the infographic's #c77dff) for section dividers and outlines, and replace the current plain ASCII header with a spookier, more atmospheric ASCII art design.

**Tasks:**
- [x] Add PURPLE color code to color definitions
- [x] Update section dividers to use purple instead of cyan
- [x] Create spooky ASCII art header (ghost-themed)
- [x] Test colors display correctly in terminal

**Files:**
- `Haunt/scripts/setup-haunt.sh` (modify)

**Effort:** S
**Agent:** Dev
**Completion:** Setup script uses purple colors and has atmospheric ASCII header
**Blocked by:** None

**Implementation Notes:**
Updated setup-haunt.sh with Ghost County purple theming:
- Added PURPLE (0;35m) and MAGENTA (1;35m) color codes
- Updated section() function to use magenta borders with ghost emoji and purple text
- Created atmospheric ASCII banner featuring:
  - Ghost cat face art at top
  - Large block-letter "HAUNT" text
  - "GHOST COUNTY - Summoning Spirits" tagline with decorative borders
- Tested dry-run to verify colors display correctly in terminal

---

## Batch 15: Installation & Management

### 🟢 REQ-183: Create `/exorcism` Uninstall Command

**Type:** Feature
**Reported:** 2025-12-13
**Source:** User request (séance session)
**Completed:** 2025-12-13

**Description:**
Create a `/exorcism` slash command to uninstall Haunt from a user's system. The command should offer a choice between partial and full exorcism, require confirmation, offer backup before deletion, and warn about uncommitted work.

**Scope:**
- **Partial Exorcism:** Remove global agents/rules/skills/commands from `~/.claude/` only
- **Full Exorcism:** Remove both global (`~/.claude/`) AND project-specific (`.haunt/`) artifacts
- **Excluded:** Leave `Haunt/` source directory alone (user's cloned repo)

**Safety Features:**
- Require explicit confirmation before deletion
- Offer to create backup before removing files
- Warn if `.haunt/` contains uncommitted roadmap changes or in-progress work
- Display what will be deleted before proceeding

**Tasks:**
- [x] Create `Haunt/commands/gco-exorcism.md` slash command
- [x] Create `Haunt/scripts/exorcism.sh` uninstall script
- [x] Implement partial vs full exorcism choice
- [x] Add backup functionality (tar.gz to ~/haunt-backup-{date}/)
- [x] Add uncommitted work detection and warning
- [x] Add confirmation prompt before deletion
- [x] Test both partial and full uninstall paths

**Files:**
- `Haunt/commands/gco-exorcism.md` (created)
- `Haunt/scripts/exorcism.sh` (created)

**Effort:** M
**Agent:** Dev
**Completion:** `/exorcism` command removes Haunt artifacts with safety checks and backup option
**Blocked by:** None

**Implementation Notes:**
Created comprehensive exorcism system with:
- **Command file** (`gco-exorcism.md`): Detailed documentation with interactive workflow examples, safety feature descriptions, and Ghost County themed output
- **Uninstall script** (`exorcism.sh`): Full-featured bash script with:
  - Partial mode: Removes only `~/.claude/gco-*` artifacts (agents, rules, skills, commands)
  - Full mode: Removes both `~/.claude/gco-*` AND `.haunt/` directory
  - Safety checks: Detects uncommitted work and in-progress roadmap items
  - Preview: Shows exactly what will be deleted before proceeding
  - Backup: Optional tar.gz creation to `~/haunt-backup-YYYY-MM-DD-HHMMSS.tar.gz`
  - Confirmation: Requires typing 'EXORCISE' to proceed (unless --force)
  - Error handling: Graceful failures with partial success reporting
  - Purple color scheme matching setup-haunt.sh theme
  - Bash 3.2 compatible (macOS default shell)
- Tested both partial and full modes successfully
- Verified restoration works via `setup-haunt.sh` after exorcism

---

### 🟢 REQ-184: Command Consolidation & Cleanup

**Type:** Enhancement
**Reported:** 2025-12-13
**Source:** User request (séance session) + command audit
**Completed:** 2025-12-15

**Description:**
Consolidate and clean up slash commands based on audit findings. Remove redundant commands, rename for clarity, and merge related functionality.

**Changes Summary:**

| Current | New Name | Action |
|---------|----------|--------|
| `gco-exorcism.md` | `gco-cleanse.md` | Rename (uninstall command) |
| `gco-exorcise.md` | `gco-exorcism.md` | Rename (pattern defeat) |
| `gco-curse.md` | `gco-seer.md` | Rename (pattern detection) |
| `gco-summon.md` + `gco-summon-all.md` | `gco-summon.md` | Merge into unified command |
| `hauntings.md` | - | Delete (duplicate of haunting) |
| `summon.md` | - | Delete (replaced by gco-summon) |
| `ritual.md` | - | Delete (replaced by gco-ritual) |
| `divine.md` | - | Delete (covered by seance) |
| `spirits.md` | - | Delete (overlap with haunt) |

**Final Command Set (13 commands):**

| Command | Purpose |
|---------|---------|
| `/seance` | Workflow orchestration |
| `/summon [agent\|all]` | Unified agent spawning |
| `/haunt` | Framework status |
| `/haunting` | Roadmap status |
| `/seer` | Detect anti-patterns |
| `/exorcism` | Generate pattern defeat tests |
| `/banish` | Archive completed work |
| `/ritual` | Daily scripts |
| `/cleanse` | Uninstall framework |
| `/apparition` | Agent memory interface |
| `/haunt-update` | Deployment sync |
| `/witching-hour` | Intensive debugging |
| `/coven` | Multi-agent coordination |

**Tasks:**
- [x] Delete redundant commands (hauntings, old summon, old ritual, divine, spirits)
- [x] Rename gco-exorcism.md → gco-cleanse.md and update script references
- [x] Rename gco-exorcise.md → gco-exorcism.md and re-theme content
- [x] Rename gco-curse.md → gco-seer.md and re-theme content
- [x] Merge gco-summon.md + gco-summon-all.md into unified /summon
- [x] Update exorcism.sh → cleanse.sh and re-theme (CLEANSE confirmation)
- [x] Update all cross-references in skills, docs, and other commands
- [x] Run setup-haunt.sh and verify all commands work
- [x] Update CLAUDE.md if it references old command names

**Files:**
- `Haunt/commands/gco-cleanse.md` (rename from gco-exorcism.md)
- `Haunt/commands/gco-exorcism.md` (rename from gco-exorcise.md)
- `Haunt/commands/gco-seer.md` (rename from gco-curse.md)
- `Haunt/commands/gco-summon.md` (merge summon + summon-all)
- `Haunt/scripts/cleanse.sh` (rename from exorcism.sh)
- Multiple files deleted

**Effort:** M
**Agent:** Dev
**Completion:** All commands renamed/consolidated, cross-references updated, commands working
**Blocked by:** None

**Implementation Notes:**
Commit `1267a99`: Deleted 5 redundant commands, renamed 4 commands with re-theming, merged summon + summon-all into unified /summon, updated all cross-references. Reduced from 19 to 13 focused commands (32% reduction).

---

## Batch 16: Agent Enhancement Research

### 🟢 REQ-185: Research Claude Code Built-in Agents Integration

**Type:** Research
**Reported:** 2025-12-14
**Source:** User request (séance session)
**Completed:** 2025-12-14

**Description:**
Investigate Claude Code's built-in agent definitions to understand:
1. What built-in agents exist and how they're defined
2. What patterns/techniques they use that could improve Haunt agents
3. Whether we can integrate with or extend the built-in agents
4. Opportunities for "prompt injection" style integrations

**Research Questions:**
- What agent types does Claude Code support natively? (Explore, Plan, etc.)
- How are their prompts/behaviors structured?
- What tools do built-in agents have access to vs our gco-* agents?
- Can we reference/invoke built-in agents from our commands?
- Are there architectural patterns we're missing?
- What would a hybrid approach look like?

**Deliverables:**
- Research report in `.haunt/docs/research/claude-builtin-agents-analysis.md`
- Recommendations for Haunt agent improvements
- If valuable: follow-up REQs for specific integrations

**Tasks:**
- [x] Identify all Claude Code built-in agent types
- [x] Analyze built-in agent prompt structures (if accessible)
- [x] Compare tool access between built-in and Haunt agents
- [x] Document integration opportunities
- [x] Identify patterns that could improve gco-* agents
- [x] Write recommendations report
- [x] Create follow-up REQs if warranted

**Files:**
- `.haunt/docs/research/claude-builtin-agents-analysis.md` (created)

**Effort:** M
**Agent:** Research
**Completion:** Research report with actionable recommendations
**Blocked by:** None

**Implementation Notes:**
Comprehensive analysis completed with findings on:
- Three built-in agents identified: Explore (Haiku, read-only), Plan (Sonnet, plan mode), general-purpose (Sonnet, full access)
- Tool access comparison matrix between built-in and Haunt agents
- Five high-impact recommendations: tool restriction variants, model selection field, return protocol documentation, investigation modes, hybrid workflow patterns
- Five follow-up REQs proposed (REQ-186 through REQ-190)
- Anti-recommendations documented (what NOT to do)
- Appendices with detailed comparison tables

---

## Batch 17: Agent Architecture Improvements

> From REQ-185 research: Claude built-in agents analysis recommendations

### 🟢 REQ-186: Add Tool Restriction Agent Variants

**Type:** Enhancement
**Reported:** 2025-12-15
**Source:** REQ-185 research recommendations
**Completed:** 2025-12-15

**Description:**
Create read-only variants of Haunt agents for safety. Built-in agents demonstrate value of tool restrictions for preventing accidental modifications during reviews/research.

**Tasks:**
- [x] Create `Haunt/agents/gco-research-analyst.md` (read-only research, no Write tool)
- [x] Create `Haunt/agents/gco-code-reviewer-readonly.md` (review without modification)
- [x] Update `Haunt/docs/TOOL-PERMISSIONS.md` with restriction patterns
- [x] Document tool access philosophy in each agent's header comment

**Files:**
- `Haunt/agents/gco-research-analyst.md` (created)
- `Haunt/agents/gco-code-reviewer-readonly.md` (created)
- `Haunt/docs/TOOL-PERMISSIONS.md` (modified)

**Effort:** S
**Agent:** Dev
**Completion:** Read-only agent variants exist and documented
**Blocked by:** None

**Implementation Notes:**
Created two read-only agent variants with comprehensive tool access philosophy documentation:

**gco-research-analyst.md:**
- Read-only research agent (Glob, Grep, Read, WebSearch, WebFetch, mcp__context7__*, mcp__agent_memory__*)
- No Write/Edit/Bash tools - eliminates modification risk during reconnaissance
- Clear guidance on when to use this vs gco-research (full access)
- Structured output format for verbal reporting (since cannot write files)
- Tool Access Philosophy explains zero modification risk for production/sensitive contexts

**gco-code-reviewer-readonly.md:**
- Read-only code review (Glob, Grep, Read, mcp__agent_memory__*)
- No Edit/Write/Bash/TodoWrite - prevents accidental code modification during review
- Enforces separation of concerns (reviewer analyzes, developer implements fixes)
- Safe for reviewing untrusted/third-party code
- Structured review output format with severity levels

**TOOL-PERMISSIONS.md enhancements:**
- Added "Tool Restriction Patterns" section explaining why/when to restrict tools
- Documented read-only variant pattern (remove Write/Edit/Bash/TodoWrite)
- Provided use cases and benefits for restricted variants
- Added "Creating Restricted Variants" guide with transformation example
- Updated agent-to-subagent mapping table with new variants
- Enhanced Best Practices with variant selection guidance

All agents include Tool Access Philosophy in YAML header explaining tool choices and rationale.

---

### 🟢 REQ-187: Add Model Selection Support

**Type:** Enhancement
**Reported:** 2025-12-15
**Source:** REQ-185 research recommendations
**Completed:** 2025-12-15

**Description:**
Support `model: haiku | sonnet | opus | inherit` field in agent YAML frontmatter. Built-in agents optimize performance by selecting appropriate models (Haiku for speed, Sonnet for reasoning).

**Example:**
```yaml
---
name: gco-research
description: Investigation and validation agent.
tools: Glob, Grep, Read, WebSearch, WebFetch, Write, mcp__*
model: haiku  # Fast searches, web research
---
```

**Tasks:**
- [x] Add `model` field to agent YAML schema documentation
- [x] Update `setup-haunt.sh` to preserve model field during deployment (verified - setup script uses simple cp, preserves all frontmatter fields)
- [x] Add model field to gco-research.md (haiku) and gco-dev.md (inherit) as examples
- [x] Document model selection guidelines in TOOL-PERMISSIONS.md

**Files:**
- `Haunt/agents/gco-research.md` (modified - added model: haiku)
- `Haunt/agents/gco-dev.md` (modified - added model: inherit)
- `Haunt/docs/TOOL-PERMISSIONS.md` (modified - added Model Selection section)

**Effort:** S
**Agent:** Dev
**Completion:** Agents support model field, documented in TOOL-PERMISSIONS.md
**Blocked by:** None

**Implementation Notes:**
Added `model` field support to agent YAML frontmatter with four values (haiku, sonnet, opus, inherit). Configured gco-research.md with `model: haiku` for fast web searches and gco-dev.md with `model: inherit` for task-based model selection. Documented comprehensive model selection guidelines in TOOL-PERMISSIONS.md including use cases, examples, and best practices. Verified setup-haunt.sh preserves model field during deployment (uses simple cp without frontmatter manipulation).

---

### 🟢 REQ-188: Add Return Protocol Documentation

**Type:** Enhancement
**Reported:** 2025-12-15
**Source:** REQ-185 research recommendations
**Completed:** 2025-12-15

**Description:**
Document what agents should/shouldn't return to prevent context bloat. Built-in agents isolate context by returning only findings (not search history).

**Example Section to Add:**
```markdown
## Return Protocol

When completing work, return ONLY:
- Key findings with sources and confidence levels
- Actionable recommendations
- Identified gaps or blockers

Do NOT return:
- Full search history ("I searched X, then Y, then Z...")
- Dead-end investigation paths
- Complete file contents (summarize instead)
```

**Tasks:**
- [x] Add "Return Protocol" section to all 5 agent character sheets
- [x] Include examples of concise vs bloated returns
- [x] Update relevant skills to emphasize minimal return payloads

**Files:**
- `Haunt/agents/gco-dev.md` (modified)
- `Haunt/agents/gco-research.md` (modified)
- `Haunt/agents/gco-code-reviewer.md` (modified)
- `Haunt/agents/gco-project-manager.md` (modified)
- `Haunt/agents/gco-release-manager.md` (modified)

**Effort:** M
**Agent:** Dev
**Completion:** All agents have Return Protocol section
**Blocked by:** None

**Implementation Notes:**
Added comprehensive Return Protocol sections to all 5 agent character sheets with:
- Clear "What to Include" and "What to Exclude" guidance
- Agent-specific examples showing concise vs bloated returns
- Integrated into existing agent structure (placed before Work Completion Protocol for dev/research/project-manager, before Review Process for code-reviewer, before Output Format for release-manager)
- Each example tailored to agent's domain (dev: code changes, research: findings, code-reviewer: review verdicts, project-manager: planning summaries, release-manager: merge analysis)
- Also added model field to agents lacking it (gco-code-reviewer: haiku, gco-project-manager: sonnet, gco-release-manager: sonnet)

---

### 🟢 REQ-189: Add Investigation Mode Support

**Type:** Enhancement
**Reported:** 2025-12-15
**Source:** REQ-185 research recommendations
**Completed:** 2025-12-15

**Description:**
Support thoroughness levels (quick/standard/thorough) in gco-research and gco-dev. Built-in Explore agent demonstrates value of adaptive investigation depth.

**Example:**
```
/summon research --mode=quick "Find authentication patterns"
/summon research --mode=thorough "Analyze all error handling"
```

**Modes:**
- **Quick:** Single grep pass, max 5 files, report within 30 seconds
- **Standard:** Multi-pattern grep, up to 20 files, cross-reference findings
- **Thorough:** Comprehensive scan, all relevant files, build dependency graph

**Tasks:**
- [x] Define quick/standard/thorough modes in gco-research agent
- [x] Update `/summon` command to support `--mode` parameter
- [x] Document mode selection criteria
- [x] Add mode examples to agent character sheets

**Files:**
- `Haunt/agents/gco-research.md` (modified)
- `Haunt/commands/gco-summon.md` (modified)

**Effort:** M
**Agent:** Dev
**Completion:** `/summon research --mode=quick` works as expected
**Blocked by:** None

**Implementation Notes:**
- Added "Investigation Thoroughness Levels" section to gco-research.md with detailed characteristics and output formats for each mode
- Added "Mode Selection Criteria" table to help researchers choose appropriate thoroughness level
- Updated /summon command format to accept `--mode=<level>` parameter
- Added mode parameter parsing logic with example Python code
- Updated error handling to include invalid mode parameter case
- Research agents default to standard mode when no mode specified

---

### 🟢 REQ-190: Document Hybrid Workflow Patterns

**Type:** Documentation
**Reported:** 2025-12-15
**Source:** REQ-185 research recommendations
**Completed:** 2025-12-15

**Description:**
Document examples of built-in + Haunt agents working together in sequential workflows.

**Example Pattern:**
```
User: "Refactor authentication to use JWT"

Main Agent:
  └─> Spawns Explore (built-in) - searches codebase for auth patterns
  └─> Spawns gco-dev (Haunt) - implements JWT using Explore findings
```

**Tasks:**
- [x] Add "Integration Patterns" section to QUICK-REFERENCE.md
- [x] Update gco-seance skill with Plan → gco-project-manager handoff example
- [x] Create `Haunt/docs/INTEGRATION-PATTERNS.md` with detailed examples

**Files:**
- `Haunt/QUICK-REFERENCE.md` (modified)
- `Haunt/skills/gco-seance/SKILL.md` (modified)
- `Haunt/docs/INTEGRATION-PATTERNS.md` (created)

**Effort:** S
**Agent:** Dev
**Completion:** Hybrid workflow patterns documented with examples
**Blocked by:** None

**Implementation Notes:**
Created comprehensive integration patterns documentation with 7 hybrid workflow patterns:
1. Explore → gco-dev (Research then Implement)
2. Plan → gco-project-manager (Planning Handoff)
3. general-purpose → gco-code-reviewer (Implement then Review)
4. Explore → gco-research → gco-dev (Deep Investigation)
5. Plan → gco-dev (Multiple) in Parallel (Plan then Execute)
6. Coven Mode (Multi-Agent Orchestration)
7. Seance Orchestration (Full Workflow)

Added Integration Patterns section to QUICK-REFERENCE.md with 3 core patterns and reference to detailed docs.
Updated gco-seance skill with Plan → gco-project-manager handoff example including trigger phrases, flow diagram, and anti-patterns.
Created comprehensive INTEGRATION-PATTERNS.md (500+ lines) with detailed examples, code snippets, decision matrix, anti-patterns, and general principles.

---

## Batch 18: Task Sizing Improvements

> From research: `.haunt/docs/research/agent-task-sizing-research.md`

### 🟢 REQ-191: Update Roadmap Sizing Rules

**Type:** Enhancement
**Reported:** 2025-12-15
**Source:** Agent task sizing research
**Completed:** 2025-12-15

**Description:**
Update `gco-roadmap-format.md` rule with new sizing tiers based on research findings. Current M (4-8 hr) is too broad - agents perform best on 1-2 hour tasks.

**New Sizing Tiers:**

| Size | Time | Files | Lines | Use Case |
|------|------|-------|-------|----------|
| XS | 30min-1hr | 1-2 | <50 | Quick fixes, config changes |
| S | 1-2 hours | 2-4 | 50-150 | Single component features |
| M | 2-4 hours | 4-8 | 150-300 | Multi-component features |
| SPLIT | >4 hours | >8 | >300 | Must decompose immediately |

**Tasks:**
- [x] Update `Haunt/rules/gco-roadmap-format.md` with new sizing tiers
- [x] Add "One Sitting Rule" - tasks must complete in one session
- [x] Add file count constraints to sizing criteria
- [x] Update examples to show proper task decomposition

**Files:**
- `Haunt/rules/gco-roadmap-format.md` (modified)

**Effort:** S
**Agent:** Dev
**Completion:** Sizing rules updated with XS/S/M/SPLIT tiers
**Blocked by:** None

**Implementation Notes:**
Updated gco-roadmap-format.md with comprehensive changes:
- Replaced old S (1-4 hr) and M (4-8 hr) tiers with new XS/S/M/SPLIT structure
- Added "The One Sitting Rule" section emphasizing single-session completion
- Added "File Count Constraints" section with detailed counting rules
- Added "Decomposition Examples" showing wrong vs right sizing
- Updated requirement format template to include XS/S/M/SPLIT options
- Updated Required Fields table to reflect new effort values
- All changes maintain consistency across the document

---

### 🟢 REQ-192: Add Complexity Indicators to Requirements

**Type:** Enhancement
**Reported:** 2025-12-15
**Completed:** 2025-12-15
**Source:** Agent task sizing research

**Description:**
Add complexity indicator field to requirements format: SIMPLE, MODERATE, COMPLEX, UNKNOWN. Helps agents and humans estimate effort more accurately.

**Indicators:**
- **SIMPLE:** Clear requirements, single pattern, no unknowns
- **MODERATE:** Some investigation needed, 2-3 patterns involved
- **COMPLEX:** Significant unknowns, cross-cutting concerns
- **UNKNOWN:** Needs spike/research before sizing

**Tasks:**
- [x] Add `Complexity:` field to requirement template
- [x] Document complexity indicators in roadmap format rule
- [x] Add guidance for when to use UNKNOWN (triggers research spike)

**Files:**
- `Haunt/rules/gco-roadmap-format.md` (modify)

**Effort:** XS
**Agent:** Dev
**Completion:** Complexity field documented with usage guidelines
**Blocked by:** REQ-191

**Implementation Notes:**
Added comprehensive complexity indicators to gco-roadmap-format.md including:
- Complexity field added to requirement template (SIMPLE, MODERATE, COMPLEX, UNKNOWN)
- "Complexity Indicators" section with definition table and characteristics
- "Complexity vs Effort" section showing independence of dimensions with examples
- "When to Use UNKNOWN" section explaining research spike triggers
- Example showing UNKNOWN → Research Spike workflow pattern
- "Complexity Selection Guide" with 4 diagnostic questions for selecting indicator
- Updated Required Fields table to include Complexity as required field

---

### 🟢 REQ-193: Create Task Decomposition Skill

**Type:** Feature
**Reported:** 2025-12-15
**Source:** Agent task sizing research
**Completed:** 2025-12-15

**Description:**
Create a skill that helps break down large requirements into atomic S-sized tasks. Should identify parallelization opportunities and dependency chains.

**Usage:**
```
/decompose REQ-XXX
```

**Tasks:**
- [x] Create `Haunt/skills/gco-task-decomposition/SKILL.md`
- [x] Create `Haunt/commands/gco-decompose.md` slash command
- [x] Include DAG dependency visualization
- [x] Add parallelization recommendations

**Files:**
- `Haunt/skills/gco-task-decomposition/SKILL.md` (create)
- `Haunt/commands/gco-decompose.md` (create)

**Effort:** M
**Agent:** Dev
**Completion:** `/decompose` command breaks large REQs into atomic tasks
**Blocked by:** REQ-191

**Implementation Notes:**
Created comprehensive task decomposition system with:
- **Skill file** (`gco-task-decomposition/SKILL.md`): Complete methodology for breaking down SPLIT requirements into atomic tasks, including:
  - The One Sitting Rule and sizing constraints (XS/S/M/SPLIT)
  - 6-step decomposition process (Analyze, Boundaries, Dependencies, Parallelization, Sizing, Roadmap Format)
  - DAG visualization guide with ASCII, Mermaid, and matrix formats
  - Parallelization patterns (Domain Parallel, Layer Parallel, Feature Parallel)
  - Full decomposition example (REQ-050: User Dashboard into 6 atomic pieces)
  - Quality checklist and anti-patterns
- **Command file** (`gco-decompose.md`): Slash command with:
  - Three modes: standard, --dry-run (preview), --parallel (maximize parallelization)
  - Argument parsing and requirement extraction from roadmap
  - SPLIT need validation (>8 files, >6 tasks, marked SPLIT)
  - Ghost County themed output with DAG visualization, parallelization analysis, and agent assignments
  - Integration with seance and coven workflows

---

## Batch 19: Agent Model Defaults

> From research: `.haunt/docs/research/agent-model-selection-research.md`
> Complements REQ-187 (model selection support)

### 🟢 REQ-194: Configure Agent Model Defaults

**Type:** Enhancement
**Reported:** 2025-12-15
**Completed:** 2025-12-15
**Source:** Agent model selection research

**Description:**
After REQ-187 adds model field support, configure optimal defaults for each agent based on research findings.

**Recommended Defaults:**

| Agent | Default Model | Rationale |
|-------|---------------|-----------|
| gco-research | haiku | Fast searches, web lookups |
| gco-code-reviewer | haiku | Style/lint checks |
| gco-dev (XS/S tasks) | haiku | Simple, well-defined work |
| gco-dev (M tasks) | sonnet | Complex reasoning needed |
| gco-project-manager | sonnet | Planning requires reasoning |
| gco-release-manager | sonnet | Risk assessment needed |

**Tasks:**
- [x] Add `model: haiku` to gco-research.md
- [x] Add `model: haiku` to gco-code-reviewer.md
- [x] Add model selection guidance to gco-dev.md (size-based)
- [x] Document model override patterns for complex tasks

**Files:**
- `Haunt/agents/gco-research.md` (modify)
- `Haunt/agents/gco-code-reviewer.md` (modify)
- `Haunt/agents/gco-dev.md` (modify)

**Effort:** S
**Agent:** Dev
**Completion:** All agents have appropriate model defaults configured
**Blocked by:** REQ-187

**Implementation Notes:**
- gco-research.md and gco-code-reviewer.md already had `model: haiku` from REQ-187
- Added comprehensive "Model Selection by Task Size" section to gco-dev.md with:
  - Task size to model mapping table (XS/S=haiku, M=sonnet, SPLIT=decompose first)
  - "When to Override Model Selection" guidance for edge cases
  - Examples of specifying model when spawning agents via /summon
- Added model selection guidance to YAML frontmatter comments in gco-dev.md

---

## Batch 20: QA Workflow & Browser Testing

> From research: `.haunt/docs/research/qa-workflow-checklists-research.md`

### 🟢 REQ-195: Install and Configure Browser MCP

**Type:** Enhancement
**Reported:** 2025-12-15
**Source:** QA workflow research
**Completed:** 2025-12-15

**Description:**
Install Browser MCP server to enable Claude to interact with browsers for testing and automation.

**Tasks:**
- [x] Research available Browser MCP solutions (Playwright, Puppeteer, Browserbase)
- [x] Document installation steps for each option
- [x] Document MCP server configuration for Claude Code settings
- [x] Document verification steps (navigate, click, screenshot)
- [x] Create comprehensive setup guide in Haunt docs

**Files:**
- `Haunt/docs/BROWSER-MCP-SETUP.md` (created)

**Effort:** S
**Agent:** Dev
**Completion:** Browser MCP documented with installation, configuration, and troubleshooting
**Blocked by:** None

**Implementation Notes:**
Created comprehensive BROWSER-MCP-SETUP.md documentation covering:
- Three MCP options: Playwright (recommended), Puppeteer (alternative), Browserbase (commercial)
- Installation instructions for each option with npm commands
- MCP configuration examples for Claude Code (UI and manual JSON)
- Verification steps with test scenarios (navigation, interaction, extraction)
- Common use cases: E2E testing, web scraping, visual regression, form automation
- Troubleshooting guide for 6 common issues (server not found, browser not launching, headless mode, permissions, ports, debugging)
- Integration with Haunt framework (agent tool access, automated testing workflows)
- Advanced configuration: custom browser args, proxy, verbose logging
- Security considerations: sensitive data, sandboxing, rate limiting
- References to Playwright, Puppeteer, MCP docs, and related requirements (REQ-196, REQ-197, REQ-198)

---

### 🟢 REQ-196: Create `/qa` Command for Test Scenario Generation

**Type:** Feature
**Reported:** 2025-12-15
**Completed:** 2025-12-15
**Source:** QA workflow research

**Description:**
Create a `/qa` slash command that generates test scenarios from requirements. Should support multiple output formats.

**Usage:**
- `/qa REQ-123` — Generate test scenarios for a specific requirement
- `/qa REQ-123 --format=gherkin` — Output in Gherkin/BDD format
- `/qa REQ-123 --format=playwright` — Output as Playwright test skeleton
- `/qa REQ-123 --format=checklist` — Output as manual QA checklist

**Tasks:**
- [x] Create `Haunt/commands/gco-qa.md` slash command
- [x] Implement requirement parsing (read from roadmap)
- [x] Generate test scenarios from tasks/completion criteria
- [x] Support markdown checklist format (default)
- [x] Support Gherkin/BDD format
- [x] Support Playwright test skeleton format

**Files:**
- `Haunt/commands/gco-qa.md` (created)

**Effort:** M
**Agent:** Dev
**Completion:** `/qa` command generates test scenarios in multiple formats
**Blocked by:** None

**Implementation Notes:**
Created comprehensive `/qa` command with:
- **Three output formats**: Markdown checklist (default), Gherkin/BDD, Playwright test skeleton
- **Requirement parsing**: Reads from `.haunt/plans/roadmap.md` to extract requirement details
- **Scenario derivation**: Generates test scenarios from tasks, completion criteria, and files
- **Format-specific templates**: Checklist with setup/scenarios/edge cases, Gherkin with Given-When-Then, Playwright with Arrange-Act-Assert
- **Test scenario rules**: Positive path from tasks, edge cases from boundaries, negative tests from error handling
- **Workflow integration**: Guidance for when to use /qa (planning, before implementation, after implementation, reviews)
- **Ghost County themed output**: Success/error messages with mystical narrative
- **Usage examples**: Detailed examples for all three formats with save/execute instructions

---

### 🟢 REQ-197: Playwright Test Generation Integration

**Type:** Feature
**Reported:** 2025-12-15
**Completed:** 2025-12-15
**Source:** QA workflow research

**Description:**
Enable Dev agents to auto-generate Playwright E2E tests for UI features as part of the development workflow.

**Tasks:**
- [x] Add Playwright test generation guidance to gco-dev agent
- [x] Create test generation skill or workflow
- [x] Define when to generate tests (UI features, user flows)
- [x] Integrate with existing Playwright MCP tools
- [x] Add test output location conventions

**Files:**
- `Haunt/agents/gco-dev.md` (modified)
- `Haunt/skills/gco-playwright-tests/SKILL.md` (created)

**Effort:** M
**Agent:** Dev
**Completion:** Dev agents generate Playwright tests for UI features
**Blocked by:** REQ-195

**Implementation Notes:**
Created comprehensive Playwright test generation integration:
- **gco-dev.md updates**: Added `mcp__playwright__*` to tools, `gco-playwright-tests` to skills list, E2E test command to Frontend Mode section
- **gco-playwright-tests/SKILL.md**: 400+ line comprehensive skill covering:
  - When to invoke (user flows, interactive UI, forms, navigation, visual elements, API integration in UI)
  - When NOT to invoke (backend-only, config changes, docs)
  - Playwright MCP integration with available tools table
  - Test output location conventions by project type
  - Full test generation workflow (analyze, skeleton, specific cases, fixtures)
  - Common test patterns (forms, modals, navigation, API responses, auth flows, responsive testing)
  - Best practices for selectors, assertions, and test independence
  - Command reference and CI/CD integration
  - Integration with /qa command and TDD workflow

---

### 🟢 REQ-198: Exploratory Test Charter Generation

**Type:** Feature
**Reported:** 2025-12-15
**Completed:** 2025-12-15
**Source:** QA workflow research

**Description:**
Generate structured exploratory testing charters for manual QA sessions. Captures human intuition and feeds pattern detection.

**Tasks:**
- [x] Define charter format (mission, scope, time-box, areas to explore)
- [x] Add charter generation to `/qa` command (--charter flag)
- [x] Include risk areas and edge cases to explore
- [x] Add session logging template for findings

**Files:**
- `Haunt/commands/gco-qa.md` (modify - add --charter flag)
- `Haunt/templates/exploratory-charter.md` (create)

**Effort:** S
**Agent:** Dev
**Completion:** Can generate exploratory test charters from requirements
**Blocked by:** REQ-196

**Implementation Notes:**
Created comprehensive exploratory test charter system:
- Created `Haunt/templates/exploratory-charter.md` with full template including: Mission Statement format (Explore/With/To discover), Scope definition, Time Box guidelines with duration splits, Areas to Explore with risk areas table, Edge Cases by domain, Test Heuristics (CRUD, SFDPOT, etc.), Session Log template for observations/bugs/questions, Debrief Summary template.
- Updated `/qa` command (`Haunt/commands/gco-qa.md`) with `--charter` flag support including: `--timebox=N` for session duration (default 60 min), `--focus=risks|edges|all` for focus areas, Output format template matching exploratory-charter.md structure, Success message with next steps for exploratory sessions.
- Added integration with pattern detection workflow (`/seer`) and agent memory (`/apparition`) for logging significant findings.

---

## Batch 21: Workflow Automation & Health Checks

> Improve seance workflow with auto-archiving and add health check command

### 🟢 REQ-200: Auto-Archive and Roadmap Gardening

**Type:** Feature
**Reported:** 2025-12-15
**Source:** User request during seance session
**Completed:** 2025-12-15

**Description:**
After spirits are summoned and dev work completes, the orchestrator should automatically:
1. Garden the roadmap - verify all tasks are checked off
2. Archive completed requirements to `.haunt/completed/roadmap-archive.md`
3. Clean up the active roadmap file

This should happen automatically when dev work from a seance completes, not require manual invocation.

**Workflow:**
```
/seance → Requirements created → Spirits summoned → Work completed →
[NEW] → Auto-garden roadmap → Archive completed → Report summary
```

**Tasks:**
- [x] Add gardening logic to seance completion workflow
- [x] Implement task verification (check all `- [ ]` are `- [x]`)
- [x] Create archival function (move 🟢 items to archive)
- [x] Add completion summary report
- [x] Update gco-seance/SKILL.md with gardening phase

**Files:**
- `Haunt/skills/gco-seance/SKILL.md` (modified)
- `Haunt/scripts/garden-roadmap.sh` (created - optional helper)

**Effort:** M
**Agent:** Dev
**Completion:** Seance workflow auto-archives completed work
**Blocked by:** None

**Implementation Notes:**
Added comprehensive "Step 6: Garden and Archive" phase to gco-seance skill that:
- Waits for all spawned agents to complete their work
- Reads roadmap and identifies all 🟢 Complete items
- Verifies task checkboxes are all checked (`- [x]` not `- [ ]`)
- Archives fully complete requirements using `/banish` logic
- Removes archived items from active roadmap
- Generates completion summary report showing what was archived
- Handles partial completion with detailed status report
- Reports verification issues when checkboxes aren't updated
- Skips gardening when no agents were spawned or user declined summoning

Created optional `garden-roadmap.sh` helper script with:
- Automated verification of all completed requirements
- Task checkbox validation
- Archival to `.haunt/completed/roadmap-archive.md`
- Removal from active roadmap
- Support for --dry-run and --verify-only modes
- Ghost County themed output
- Bash 3.2+ compatibility for macOS

Updated Quality Checklist in skill with 9 gardening-phase verification items.

---

### 🟢 REQ-201: Health Check Command (/checkup)

**Type:** Feature
**Reported:** 2025-12-15
**Completed:** 2025-12-15
**Source:** User request for Haunt installation verification

**Description:**
Create a `/checkup` slash command that verifies Haunt framework is properly installed and functioning. Gives users confidence that the LLM is actually following Haunt protocols.

**Checks to perform:**
1. **Rules adherence** - Verify rules are loaded and being followed
2. **Skills availability** - Check skills are accessible and triggering
3. **MCP servers** - Verify context7, agent_memory, playwright are installed
4. **Agent definitions** - Confirm agents are deployed correctly
5. **Directory structure** - Verify `.haunt/` directories exist

**Output:**
```
🏚️ HAUNT CHECKUP 🏚️

✅ Rules: 7/7 loaded
✅ Skills: 15/15 available
✅ MCP: context7, playwright connected
✅ Agents: 6/6 deployed
✅ Directories: .haunt/ structure valid

Haunt is properly installed and operational.
```

**Tasks:**
- [x] Create `Haunt/commands/gco-checkup.md` slash command
- [x] Implement rules verification check
- [x] Implement skills availability check
- [x] Implement MCP server connectivity check
- [x] Implement agent deployment verification
- [x] Implement directory structure validation
- [x] Add Ghost County themed output

**Files:**
- `Haunt/commands/gco-checkup.md` (created)
- `Haunt/scripts/checkup.sh` (created)

**Effort:** M
**Agent:** Dev
**Completion:** `/checkup` command verifies all Haunt components
**Blocked by:** None

**Implementation Notes:**
Created comprehensive health check system with:
- **Command file** (`gco-checkup.md`): Detailed documentation with 6 verification phases, multiple output formats (normal/quick/verbose), Ghost County themed examples
- **Bash script** (`checkup.sh`): Full-featured health check script with:
  - Six verification phases: rules (8 expected), skills (10+ expected), MCP servers (optional), agents (5+ expected), directory structure (.haunt/), commands (13+ expected)
  - Three modes: normal (full check), quick (rules + agents only), verbose (detailed diagnostics with file listings)
  - Exit codes: 0 = all pass, 1 = warnings, 2 = critical failures
  - MCP servers marked as optional (warning, not failure) since they're not required for core functionality
  - Troubleshooting guidance for each detected issue
  - Purple/magenta color scheme matching Ghost County theme
  - Bash 3.2 compatible for macOS default shell
- Tested all three modes successfully: quick, normal, verbose
- All checks working correctly with proper status detection and themed output

---

## Batch 22: Setup Script Fixes

### 🟢 REQ-202: Fix .gitignore Idempotency and Simplify .haunt Entries

**Type:** Bug Fix
**Reported:** 2025-12-15
**Completed:** 2025-12-15
**Source:** User report (séance session)

**Description:**
Two issues with the setup script's `.gitignore` handling:

1. **Bug - Duplicate entries**: The script checks for `^# Ghost County` header (line 1884) but adds entries with `# Haunt - Project-Local Directories` header. This mismatch means it never detects existing entries and keeps appending duplicates.

2. **Enhancement - Simplify entries**: Current approach selectively ignores `.haunt/` subdirectories while preserving `tests/`, `scripts/`, `README.md`. User wants simpler approach: ignore entire `.haunt/` directory.

**Current behavior (broken):**
```gitignore
# ============================================================================
# Haunt - Project-Local Directories
# ============================================================================
.haunt/plans/
.haunt/progress/
.haunt/completed/
.haunt/docs/
!.haunt/tests/
!.haunt/scripts/
!.haunt/README.md
```
↑ This block gets appended every time setup runs.

**Desired behavior:**
```gitignore
# ============================================================================
# Haunt Framework - Git Ignore
# ============================================================================
.haunt/
```

**Tasks:**
- [x] Update idempotency check to look for correct header (`# Haunt Framework` or `# Haunt -`)
- [x] Simplify .gitignore entries to just `.haunt/` (entire directory)
- [x] Remove negation patterns (`!.haunt/tests/`, etc.)
- [x] Test setup script is idempotent (run twice, no duplicates)
- [x] Clean up ghost-county repo's .gitignore (remove duplicate entries)

**Files:**
- `Haunt/scripts/setup-haunt.sh` (modify - lines ~1884, ~1900-1920)
- `.gitignore` (clean up duplicates)

**Effort:** S
**Agent:** Dev
**Completion:** Setup script idempotent, .gitignore has single `.haunt/` entry
**Blocked by:** None

**Implementation Notes:**
Fixed setup-haunt.sh idempotency check (line 1885) to use regex matching both "Ghost County" and "Haunt" headers. Simplified gitignore entries to just `.claude/` and `.haunt/` without selective subdirectory ignores or negation patterns. Cleaned up ghost-county repo .gitignore from 356 lines (12+ duplicate blocks) to 143 lines with single clean entry. Verified idempotency with --dry-run showing "Skipped: .gitignore already contains Haunt entries".

---

## Batch 23: Environment Management

### 🟢 REQ-203: Enhance /cleanse with Multi-Mode Functionality

**Type:** Enhancement
**Reported:** 2025-12-15
**Completed:** 2025-12-15
**Source:** User request - stale skills from previous installations causing duplicates

**Description:**
Redesign `/cleanse` command to support multiple operational modes instead of just uninstall. User has leftover skills/commands from previous installations (before filename changes) causing duplicate functionality.

**Problem Statement:**
When Haunt evolves and files are renamed (e.g., skill directories), old versions persist in `~/.claude/` and `.claude/` causing:
- Duplicate functionality (old + new versions both active)
- Confusion about which version is being used
- No easy way to "clean install" without full uninstall

**Proposed Modes:**

| Mode | Command | Behavior |
|------|---------|----------|
| **Repair** | `/cleanse --repair` or `/cleanse --fix` | Verify → Remove stale files → Re-sync from Haunt/ source |
| **Uninstall** | `/cleanse --uninstall` | Remove gco-* assets from ~/.claude/ and .claude/ (current behavior) |
| **Purge** | `/cleanse --purge` | Full removal: uninstall + remove .haunt/ directory |

**Scope Option:**

| Scope | Flag | Targets |
|-------|------|---------|
| **Project** | `--scope=project` | Only `.claude/` in current project directory |
| **User/Global** | `--scope=user` or `--scope=global` | Only `~/.claude/` (user's home) |
| **Both** | `--scope=both` (default) | Both project and global locations |

**Example Commands:**
```bash
/cleanse --repair --scope=user      # Fix only global installation
/cleanse --repair --scope=project   # Fix only current project
/cleanse --uninstall --scope=both   # Remove from everywhere
/cleanse --purge --scope=project    # Full removal from project only
```

**Repair Mode Details:**
1. Scan `~/.claude/` and `.claude/` for Haunt-related files
2. Compare against current `Haunt/` source manifest
3. Identify stale files (exist in deploy but not in source)
4. Remove stale files
5. Re-run `setup-haunt.sh` to sync from source
6. Report what was cleaned and restored

**Stale File Detection:**
- Skills: Any directory in `~/.claude/skills/` starting with `gco-` that doesn't exist in `Haunt/skills/`
- Commands: Any file in `~/.claude/commands/` starting with `gco-` that doesn't exist in `Haunt/commands/`
- Agents: Any file in `~/.claude/agents/` starting with `gco-` that doesn't exist in `Haunt/agents/`
- Rules: Any file in `~/.claude/rules/` starting with `gco-` that doesn't exist in `Haunt/rules/`

**Tasks:**
- [x] Refactor `cleanse.sh` to support modes (--repair, --uninstall, --purge flags)
- [x] Add --scope option (project, user/global, both)
- [x] Implement stale file detection (compare deployed vs source)
- [x] Implement repair mode (remove stale + re-sync)
- [x] Update `/cleanse` command documentation with new modes and scopes
- [x] Add `--dry-run` support for all modes (preview what would be removed)
- [x] Test all mode + scope combinations

**Files:**
- `Haunt/scripts/cleanse.sh` (modify)
- `Haunt/commands/cleanse.md` (modify - renamed from gco-cleanse.md)

**Effort:** M
**Complexity:** MODERATE
**Agent:** Dev
**Completion:** `/cleanse --repair` removes stale files and re-syncs from source
**Blocked by:** None

**Implementation Notes:**
Complete rewrite of cleanse.sh with three modes (repair/uninstall/purge) and scope option (project/user/both). Repair mode compares deployed files against Haunt/ source, identifies stale files (deployed but not in source), removes them, and re-runs setup-haunt.sh. Tested with dry-run and live execution - successfully detected and removed 2 stale files (gco-seance-workflow.md rule, gco-cleanse.md command). Command file renamed from gco-cleanse.md to cleanse.md per naming convention.

---

## Batch 6: UI Testing Integration

### 🟢 REQ-204: Create UI Testing Protocol Rule for Playwright E2E Tests

**Type:** Enhancement
**Reported:** 2025-12-15
**Completed:** 2025-12-15
**Source:** User request - reduce painful back-and-forth during UI testing

**Description:**
Create a new rule (gco-ui-testing.md) that automatically triggers Playwright E2E test generation when implementing UI features. This makes E2E testing a mandatory part of the TDD workflow for frontend work, reducing the painful back-and-forth of manual UI verification with Claude Code.

**Tasks:**
- [x] Create Haunt/rules/gco-ui-testing.md with UI testing protocol
- [x] Define when Playwright E2E tests are required (UI components, user flows, interactions)
- [x] Integrate with existing gco-playwright-tests skill
- [x] Document test location (.haunt/tests/e2e/) and naming conventions
- [x] Specify how to verify E2E tests pass before marking requirements complete
- [x] Update setup-agentic-sdlc.sh to deploy the new rule
- [x] Test rule deployment to ~/.claude/rules/ and .claude/rules/

**Files:**
- `Haunt/rules/gco-ui-testing.md` (create) ✓
- `Haunt/scripts/setup-haunt.sh` (verified auto-deployment) ✓

**Effort:** S
**Complexity:** SIMPLE
**Agent:** Dev-Infrastructure
**Completion:** Rule created, deployed via setup script, and triggers E2E test generation for UI work
**Blocked by:** None

**Implementation Notes:**
- Created comprehensive UI testing protocol rule that integrates with gco-playwright-tests skill
- Rule automatically deployed via setup-haunt.sh (no script modification needed)
- Deployed to both ~/.claude/rules/ and .claude/rules/ successfully
- Rule enforces TDD workflow for all frontend features
- Includes clear triggers, test location conventions, and completion requirements

---

## Batch 7: Workflow Automation & Customization

### 🟢 REQ-205: GitHub Issues Integration with @haunt Marker

**Type:** Enhancement
**Reported:** 2025-12-15
**Completed:** 2025-12-16
**Source:** User feature request - automate issue tracking

**Description:**
Enable Project Manager to automatically detect GitHub issues marked with @haunt (or similar marker) and add them to the roadmap with an approval mechanism. This automates the workflow from issue reporting in GitHub to roadmap items, while maintaining control over what gets promoted.

**Tasks:**
- [x] Research integration approach (gh CLI vs GitHub API vs webhooks)
- [x] Implement issue detection for @haunt marker in issue body/comments
- [x] Create PM approval workflow (review → approve/reject → add to roadmap)
- [x] Map GitHub issue metadata to roadmap format (title, description, labels → type/effort)
- [x] Add bidirectional linking (issue ↔ REQ-XXX)
- [x] Add authentication/rate limiting handling
- [x] Test with sample issues (unit tests for all components)

**Files:**
- `Haunt/scripts/github-integration/webhook_receiver.py` (create) ✅
- `Haunt/scripts/github-integration/issue_scanner.py` (create) ✅
- `Haunt/scripts/github-integration/pm_approval.py` (create) ✅
- `Haunt/scripts/github-integration/roadmap_mapper.py` (create) ✅
- `Haunt/scripts/github-integration/config.yaml.template` (create) ✅
- `Haunt/scripts/github-integration/requirements.txt` (create) ✅
- `Haunt/scripts/github-integration/README.md` (create) ✅
- `Haunt/scripts/github-integration/tests/test_webhook_receiver.py` (create) ✅
- `Haunt/scripts/github-integration/tests/test_roadmap_mapper.py` (create) ✅

**Effort:** M
**Complexity:** MODERATE
**Agent:** Research-Analyst (investigation) → Dev-Infrastructure (implementation)
**Completion:** PM detects @haunt issues, prompts for approval, and adds approved issues to roadmap with linking
**Blocked by:** None

**Implementation Notes:**
- Implemented hybrid two-tier architecture (webhook + polling) as recommended by research
- Tier 1: Flask-based webhook receiver for real-time @haunt detection
- Tier 2: Search API polling fallback (catches missed webhooks, backfills)
- PM approval workflow: CLI-based interactive approval/rejection
- Metadata mapping: GitHub labels → roadmap type/effort/complexity
- Bidirectional linking: Issues link to REQ-XXX, REQ links back to issue
- Security: HMAC-SHA256 webhook signature validation
- Rate limiting: Respects GitHub API limits, exponential backoff
- Configuration: YAML-based with environment variable substitution
- Testing: Unit tests for signature validation and metadata mapping
- Documentation: Comprehensive README with setup, usage, and troubleshooting

---

### 🟢 REQ-206: Create /bind Command for Custom Workflow Rule Overrides

**Type:** Enhancement
**Reported:** 2025-12-15
**Completed:** 2025-12-16
**Source:** User feature request - project-specific workflow customization

**Description:**
Create a `/bind` slash command that allows users to create custom workflow rule overrides for specific projects. This enables users to keep most of Haunt's workflow but override specific rules that don't fit their project's development process. Custom bindings supersede built-in Haunt rules.

**Tasks:**
- [x] Design override mechanism (how custom rules supersede built-in rules)
- [x] Create /bind command structure and syntax
- [x] Implement rule priority system (custom > project > global)
- [x] Add validation for custom rule format
- [x] Create storage location for custom bindings (.haunt/bindings/?)
- [x] Document bind syntax and examples
- [x] Add /unbind command to remove overrides
- [x] Add /bind-list command to show active overrides
- [x] Test with sample project-specific workflow variations

**Files:**
- `Haunt/commands/bind.md` (create)
- `Haunt/commands/unbind.md` (create)
- `Haunt/commands/bind-list.md` (create)
- `Haunt/scripts/bind.sh` (create)
- `.haunt/bindings/` directory structure (create)

**Effort:** M
**Complexity:** MODERATE
**Agent:** Dev-Infrastructure
**Completion:** /bind command creates project-specific rule overrides that supersede Haunt defaults
**Blocked by:** None

**Implementation Notes:**
Created comprehensive binding system with three commands:
- /bind: Create custom rule overrides with validation, dry-run, and force modes
- /unbind: Remove bindings with backup and scope options
- /bind-list: Display active bindings with verbose and rule-specific views

Priority system: Project bindings (.haunt/bindings/) > User bindings (~/.haunt/bindings/) > Project rules (.claude/rules/) > Global rules (~/.claude/rules/) > Haunt defaults (Haunt/rules/)

All scripts include help, dry-run, validation, and safety features. Tested successfully with sample workflow.

---

### 🟢 REQ-207: Fix Syntax Errors in morning-review.sh

**Type:** Bug Fix
**Reported:** 2025-12-15
**Source:** Automated detection during /ritual morning execution

**Description:**
The morning-review.sh ritual script has bash syntax errors on lines 122 and 341 that produce error messages during execution: "0\n0: syntax error in expression (error token is "0")". While these don't prevent the script from completing its core functions, they should be fixed for clean output.

**Tasks:**
- [x] Investigate syntax error at line 122 (likely expression evaluation issue)
- [x] Investigate syntax error at line 341 (likely expression evaluation issue)
- [x] Fix both syntax errors
- [x] Run /ritual morning and verify no error messages appear
- [x] Verify all script functionality still works correctly

**Files:**
- `Haunt/scripts/rituals/morning-review.sh` (modify)

**Effort:** XS
**Complexity:** SIMPLE
**Agent:** Dev-Infrastructure
**Completion:** /ritual morning executes without syntax errors while maintaining all functionality
**Blocked by:** None

---

### 🟢 REQ-208: Remove NATS Infrastructure from Haunt Build

**Type:** Enhancement (Cleanup)
**Reported:** 2025-12-15
**Source:** User request - remove unused infrastructure dependency

**Description:**
Remove NATS JetStream references and setup from Haunt framework since it's not currently being used. Morning ritual confirms "NATS Server: Not running (optional)". This simplifies infrastructure requirements and reduces setup complexity for new users.

**Tasks:**
- [x] Remove NATS installation steps from setup scripts
- [x] Remove NATS from infrastructure health checks (morning-review.sh)
- [x] Remove NATS documentation references from CLAUDE.md
- [x] Update Haunt/docs/ infrastructure documentation
- [x] Check and update Agentic_SDLC_Framework legacy docs if needed
- [x] Verify all rituals and scripts no longer reference NATS
- [x] Test setup and health checks work without NATS

**Files:**
- `Haunt/scripts/setup-agentic-sdlc.sh` (modify)
- `Haunt/scripts/rituals/morning-review.sh` (modify)
- `CLAUDE.md` (modify - infrastructure section)
- `Haunt/docs/*.md` (modify - infrastructure references)
- `Agentic_SDLC_Framework/02-Infrastructure.md` (possibly modify)

**Effort:** S
**Complexity:** SIMPLE
**Agent:** Dev-Infrastructure
**Completion:** NATS references removed from all scripts, docs, and health checks; setup runs without NATS
**Blocked by:** None

---

**END OF ROADMAP**
