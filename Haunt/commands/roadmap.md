# Roadmap Management

Manage roadmap sharding and batch organization for improved token efficiency.

## Usage

```bash
/roadmap shard                    # Split roadmap into batch-specific files
/roadmap shard --active "Batch 1" # Shard and mark specific batch as active
/roadmap unshard                  # Merge all batch files back to monolithic roadmap
/roadmap activate "Batch Name"    # Activate a different batch (move to main roadmap)
```

## Sharding Overview

**Problem:** Large roadmaps (>500 lines, 10+ requirements) consume excessive tokens when loaded for each assignment lookup.

**Solution:** Split roadmap into batch-specific files in `.haunt/plans/batches/`, keeping only the active batch in main `roadmap.md`.

**Token Savings:** 60-80% reduction for large projects (BMAD achieved 31,667 → 8,333 tokens).

---

## Shard Command (`/roadmap shard`)

Split the monolithic roadmap into batch-specific files.

### Sharding Logic

1. **Read roadmap**: Parse `.haunt/plans/roadmap.md`
2. **Identify batches**: Extract all `## Batch: [Name]` headers
3. **Extract requirements**: Group all requirements under each batch header until next `##` or EOF
4. **Create batch files**: Write to `.haunt/plans/batches/batch-N-[slug].md`
5. **Generate overview**: Create lightweight `roadmap.md` with overview + active batch only
6. **Create directory**: Ensure `.haunt/plans/batches/` exists

### Batch File Format

Each batch file should follow this structure:

```markdown
# Batch: [Batch Name]

> Sharded from roadmap on YYYY-MM-DD
> Contains requirements from original Batch [N]

**Status:** Active / Archived
**Requirements:** X total (Y complete, Z in progress, W not started)
**Estimated Effort:** XX hours remaining

**Goal:** [Batch goal from original roadmap]

---

## Requirements

### 🟡 REQ-001: [Requirement Title]

[Full requirement content with all fields...]

---

### ⚪ REQ-002: [Requirement Title]

[Full requirement content with all fields...]
```

### Overview Roadmap Format

After sharding, main `roadmap.md` should contain:

```markdown
# Haunt Framework Roadmap

> Roadmap is **sharded** for token efficiency. Full batches in `.haunt/plans/batches/`.

---

## Sharding Info

**Status:** Sharded on YYYY-MM-DD
**Active Batch:** [Batch Name]
**Total Batches:** X
**Load Location:** `.haunt/plans/batches/`

---

## Current Focus: [Active Batch Name]

**Goal:** [Active batch goal]

**Active Work:**
- 🟡 REQ-XXX: [Title] (from active batch)

**Recently Completed:**
- 🟢 REQ-XXX: [Title] (from active batch)

---

## Active Batch: [Batch Name]

[Full content of active batch with all requirements]

---

## Other Batches (See .haunt/plans/batches/)

### Batch: Command Improvements
- **File:** `batches/batch-1-command-improvements.md`
- **Progress:** 5/5 Complete (100%)
- **Status:** 🟢 COMPLETE

### Batch: Setup Improvements
- **File:** `batches/batch-2-setup-improvements.md`
- **Progress:** 2/3 Complete (67%)
- **Status:** 🟡 IN PROGRESS

### Batch: BMAD Enhancements - Phase 1
- **File:** `batches/batch-3-bmad-phase-1.md`
- **Progress:** 0/5 Complete (0%)
- **Status:** ⚪ NOT STARTED

Use `/roadmap activate "Batch Name"` to load a different batch.
```

### Implementation Steps

1. **Parse roadmap structure**
   - Identify header (everything before first `## Batch:`)
   - Extract each batch section (from `## Batch:` to next `##` or EOF)
   - Parse batch name from header: `## Batch: [Name]`

2. **Count requirements per batch**
   - Count total REQ-XXX items
   - Count by status (🟢 🟡 ⚪ 🔴)
   - Sum effort for incomplete items (⚪ + 🟡)

3. **Create batch files**
   - Create `.haunt/plans/batches/` directory if missing
   - Generate filename: `batch-N-[slug].md` where slug is lowercase-hyphenated batch name
   - Write batch content with metadata header
   - Store batch count and batch names in memory

4. **Generate overview roadmap**
   - Keep original header and metadata
   - Add "Sharding Info" section
   - Include full active batch content
   - Summarize other batches with links

5. **Determine active batch**
   - If `--active "Batch Name"` flag provided, use that batch
   - Otherwise, use first batch with 🟡 In Progress items
   - If no in-progress items, use first batch with ⚪ Not Started items
   - If all complete, use last batch

6. **Write files**
   - Write each batch file to `.haunt/plans/batches/batch-N-[slug].md`
   - Overwrite main `.haunt/plans/roadmap.md` with overview

### Success Output

```
The spirits shard the roadmap across the ethereal realm...

📊 Sharding Summary:
   Batches detected: 6
   Requirements total: 42
   Active batch: "BMAD Enhancements - Phase 3"

📂 Batch Files Created:
   ✅ batches/batch-1-command-improvements.md (5 requirements, 🟢 COMPLETE)
   ✅ batches/batch-2-setup-improvements.md (3 requirements, 🟡 IN PROGRESS)
   ✅ batches/batch-3-bmad-phase-1.md (5 requirements, 🟢 COMPLETE)
   ✅ batches/batch-4-bmad-phase-2.md (7 requirements, 🟡 IN PROGRESS)
   ✅ batches/batch-5-bmad-phase-3.md (3 requirements, ⚪ NOT STARTED)
   ✅ batches/batch-6-future-work.md (19 requirements, ⚪ NOT STARTED)

📋 Overview Roadmap:
   ✅ roadmap.md updated (300 lines → reduced from 850 lines)
   🎯 Active batch loaded: "BMAD Enhancements - Phase 3"

💾 Token Savings:
   Before: ~2,550 tokens (850 lines)
   After: ~900 tokens (300 lines)
   Reduction: 65% (~1,650 tokens saved per request)

The roadmap is sharded. Access inactive batches via .haunt/plans/batches/
```

### Error Handling

- **No batches found**: "No batch headers (## Batch:) found in roadmap. Cannot shard."
- **Already sharded**: "Roadmap is already sharded (sharding info detected). Use `/roadmap unshard` first."
- **Missing roadmap**: "Roadmap file not found at .haunt/plans/roadmap.md"
- **Empty batch**: "Batch '[Name]' contains no requirements. Skipping."
- **Invalid active batch**: "Batch '[Name]' not found. Available batches: [list]"

---

## Unshard Command (`/roadmap unshard`)

Merge all batch files back into a single monolithic roadmap.

### Unsharding Logic

1. **Read overview roadmap**: Parse current `.haunt/plans/roadmap.md`
2. **Verify sharding**: Check for "Sharding Info" section or "Other Batches" section
3. **Find batch files**: List all `.haunt/plans/batches/batch-*.md` files
4. **Read each batch**: Load content from each batch file
5. **Merge content**: Reconstruct monolithic roadmap with all batches
6. **Write roadmap**: Overwrite `.haunt/plans/roadmap.md` with full content
7. **Keep batch files**: Do NOT delete batch files (backup/reference)

### Merged Roadmap Format

```markdown
# Haunt Framework Roadmap

> Single source of truth for project work items. See `.haunt/completed/roadmap-archive.md` for completed work.

---

## Current Focus: [Active Batch Name]

**Goal:** [Goal from active batch]

**Active Work:**
- 🟡 REQ-XXX: [Title]

**Recently Completed:**
- 🟢 REQ-XXX: [Title]

---

## Batch: Command Improvements

[Full batch content...]

---

## Batch: Setup Improvements

[Full batch content...]

---

[... all other batches in original order ...]
```

### Implementation Steps

1. **Detect sharded state**
   - Read `.haunt/plans/roadmap.md`
   - Check for "Sharding Info" section or "Other Batches" heading
   - If not sharded, error and exit

2. **Read batch files**
   - List files in `.haunt/plans/batches/` matching `batch-*.md`
   - Sort by batch number (batch-1, batch-2, etc.)
   - Read each file content

3. **Extract batch content**
   - Skip metadata header (lines before first `##`)
   - Extract "## Requirements" section and all following content
   - Reconstruct as `## Batch: [Name]` section

4. **Build merged roadmap**
   - Start with original header (from overview roadmap)
   - Add Current Focus section (from overview)
   - Append each batch in order
   - Remove "Sharding Info" section
   - Remove "Other Batches" summary section

5. **Write monolithic roadmap**
   - Overwrite `.haunt/plans/roadmap.md`
   - Keep batch files for reference (don't delete)

### Success Output

```
The spirits reunite the sharded realm...

📂 Batch Files Found:
   ✅ batch-1-command-improvements.md (5 requirements)
   ✅ batch-2-setup-improvements.md (3 requirements)
   ✅ batch-3-bmad-phase-1.md (5 requirements)
   ✅ batch-4-bmad-phase-2.md (7 requirements)
   ✅ batch-5-bmad-phase-3.md (3 requirements)
   ✅ batch-6-future-work.md (19 requirements)

📋 Merged Roadmap:
   ✅ roadmap.md rebuilt (850 lines, 6 batches)
   📦 All requirements restored

🗂️  Batch files preserved in .haunt/plans/batches/ (for reference)

The roadmap is whole again. All batches visible in roadmap.md
```

### Error Handling

- **Not sharded**: "Roadmap is not sharded (no sharding info detected). Nothing to unshard."
- **Missing batch files**: "Batch files directory not found at .haunt/plans/batches/"
- **Empty batches dir**: "No batch files found in .haunt/plans/batches/"
- **Parse error**: "Failed to parse batch file: [filename]. Skipping."

---

## Activate Command (`/roadmap activate "Batch Name"`)

Switch the active batch in a sharded roadmap.

### Activation Logic

1. **Verify sharded state**: Roadmap must be sharded
2. **Find batch file**: Locate `batches/batch-N-[slug].md` matching batch name
3. **Read batch content**: Load full batch content from file
4. **Update overview roadmap**: Replace "Active Batch" section with new batch
5. **Update "Sharding Info"**: Change "Active Batch:" field to new batch name
6. **Report change**: Display old batch → new batch transition

### Implementation Steps

1. **Validate sharding**
   - Read `.haunt/plans/roadmap.md`
   - Verify "Sharding Info" section exists
   - If not sharded, error and exit

2. **Find matching batch**
   - Extract batch name from command args
   - Search "Other Batches" section for matching name
   - Find corresponding file path
   - If not found, list available batches and error

3. **Read new batch**
   - Read content from `batches/batch-N-[slug].md`
   - Extract requirements section
   - Parse batch goal/metadata

4. **Update overview roadmap**
   - Replace "Active Batch:" field in "Sharding Info"
   - Replace entire "## Active Batch:" section with new batch content
   - Update "Current Focus:" section with new batch goal
   - Rewrite overview list to reflect status change

5. **Write updated roadmap**
   - Overwrite `.haunt/plans/roadmap.md`
   - Keep all batch files unchanged

### Success Output

```
The spirits shift focus to a new haunting...

🔄 Activating Batch:
   Previous: "BMAD Enhancements - Phase 2"
   New: "BMAD Enhancements - Phase 3"

📂 Loading Batch File:
   ✅ batches/batch-5-bmad-phase-3.md (3 requirements)

📋 Roadmap Updated:
   ✅ Active batch replaced in roadmap.md
   🎯 Current Focus: "BMAD Enhancements - Phase 3"
   ⚪ 3 requirements now visible in main roadmap

The realm refocuses. New batch activated.
```

### Error Handling

- **Not sharded**: "Roadmap is not sharded. Cannot activate batch. Use `/roadmap shard` first."
- **Batch not found**: "Batch '[Name]' not found. Available batches: [list]"
- **Missing batch file**: "Batch file not found: batches/batch-N-[slug].md"
- **Parse error**: "Failed to read batch file: [filename]"
- **Already active**: "Batch '[Name]' is already active. No change needed."

---

## Ghost County Theming

**Opening phrases:**
- "The spirits prepare to shard the roadmap..."
- "Merging the ethereal fragments..."
- "Shifting focus across the batches..."

**Success messages:**
- "The roadmap is sharded. Token efficiency achieved."
- "The realm is whole once more. All batches reunited."
- "The active batch shifts. New hauntings come into view."

**Error messages:**
- "The roadmap resists sharding - no batches detected."
- "The fragments cannot be found. Batches missing from the ethereal realm."
- "The requested batch eludes us. Check the available hauntings."

---

## When to Use Sharding

**Shard when:**
- Roadmap exceeds 500 lines
- 10+ requirements across multiple batches
- Token usage becomes noticeable (>2,000 tokens per request)
- Multiple agents working on different batches simultaneously

**Keep monolithic when:**
- Roadmap under 300 lines
- Fewer than 8 requirements
- Single batch in progress
- Early project phase with high churn

**Activate different batch when:**
- Completing current batch and moving to next phase
- Switching team focus between batches
- Reviewing historical batches for context
- Debugging requirements in inactive batches

---

## Implementation Notes

This command integrates with existing Haunt workflow:

- **Session startup** (REQ-221): Assignment lookup loads only active batch when sharded
- **Batch archival** (REQ-222): Completed batches auto-archived, next batch activated
- **PM coordination**: PM can shard/unshard at project milestones
- **Backward compatibility**: Unshard restores monolithic format for tools expecting it

Sharding is **optional** and **reversible**. The roadmap remains functional in both sharded and monolithic forms.
