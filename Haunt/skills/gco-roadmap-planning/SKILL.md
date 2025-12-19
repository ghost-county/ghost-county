---
name: gco-roadmap-planning
description: Structured roadmap format for coordinating agent teams with batches, dependencies, and status tracking. Use when creating roadmaps, planning sprints, organizing work batches, or tracking multi-agent progress. Triggers on "create roadmap", "plan sprint", "organize work", "batch planning", "dependency mapping", or work coordination requests.
---

# Roadmap Planning

Structure and manage work for agent teams.

## Roadmap Format

```markdown
# Project Roadmap

**Last Updated:** [Date]
**Current Focus:** [Batch name]

---

## Batch 1: [Name]

🟡 REQ-001: [Title]
   Tasks:
   - [x] Completed task
   - [ ] Pending task
   Files: path/to/files
   Effort: S
   Agent: [Name]
   Completion: [Criteria]

⚪ REQ-002: [Title]
   Tasks:
   - [ ] Task 1
   - [ ] Task 2
   Files: path/to/files
   Effort: M
   Agent: [Name]
   Completion: [Criteria]
   Blocked by: None

---

## Batch 2: [Name]

⚪ REQ-010: [Title]
   ...
   Blocked by: REQ-001, REQ-002
```

## Status Icons

| Icon | Meaning | When to Use |
|------|---------|-------------|
| ⚪ | Not Started | Work not begun |
| 🟡 | In Progress | Agent actively working |
| 🟢 | Complete | All criteria met, archived |
| 🔴 | Blocked | Cannot proceed, dependency unmet |

## Batch Organization Rules

### What Goes in Same Batch
- Requirements with **no dependencies** between them
- Work that can run **in parallel**
- Items assigned to **different agents**

### What Goes in Separate Batches
- Anything with `Blocked by:` pointing to another item
- Sequential work (API before UI)
- Same-file modifications

### Example: Good Batching

```markdown
## Batch 1: Foundation (Parallel OK)
⚪ REQ-001: Database schema (Dev-Infrastructure)
⚪ REQ-002: Config management (Dev-Infrastructure)
⚪ REQ-003: Logging setup (Dev-Infrastructure)

## Batch 2: Core Backend (Depends on Batch 1)
⚪ REQ-010: User model (Dev-Backend) - Blocked by: REQ-001
⚪ REQ-011: Auth service (Dev-Backend) - Blocked by: REQ-001

## Batch 3: API Layer (Depends on Batch 2)
⚪ REQ-020: User endpoints (Dev-Backend) - Blocked by: REQ-010
⚪ REQ-021: Auth endpoints (Dev-Backend) - Blocked by: REQ-011

## Batch 4: Frontend (Depends on Batch 3)
⚪ REQ-030: Login page (Dev-Frontend) - Blocked by: REQ-021
⚪ REQ-031: User profile (Dev-Frontend) - Blocked by: REQ-020
```

## Priority Order

Within same batch, sequence by:

1. **Infrastructure** first (affects everything)
2. **Backend** second (APIs that frontend needs)
3. **Frontend** last (depends on backend)
4. **Same layer**: smaller (S) before larger (M)

## Archiving Completed Work

When requirement is done:

1. Change status to 🟢
2. Add completion date
3. Move to `.haunt/completed/roadmap-archive.md`
4. Keep active roadmap clean

### Archive Format

```markdown
# Roadmap Archive

## 2024-12

### REQ-001: Database schema
- Completed: 2024-12-05
- Agent: Dev-Infrastructure
- Tasks: 3/3
- Notes: Added index on email column for performance
```

## Dispatch Protocol

When assigning work:

```markdown
## Assignment: REQ-XXX

**Agent:** [Name]
**Branch:** feature/REQ-XXX
**Goal:** [One sentence]

### Tasks
1. [ ] First task
2. [ ] Second task

### Files to Modify
- `src/path/to/file.py`
- `tests/path/to/test.py`

### Constraints
- Must maintain backward compatibility
- Use existing patterns from src/utils/

### Completion Criteria
- [ ] All tasks checked
- [ ] Tests passing
- [ ] Code reviewed
```

## Progress Tracking

### Daily Check
```bash
# Count by status
grep -c "⚪" .haunt/plans/roadmap.md  # Not started
grep -c "🟡" .haunt/plans/roadmap.md  # In progress
grep -c "🟢" .haunt/plans/roadmap.md  # Complete
grep -c "🔴" .haunt/plans/roadmap.md  # Blocked
```

### Velocity Metrics
| Metric | How to Calculate |
|--------|-----------------|
| Phases/day | Completed items ÷ days |
| Avg time/phase | Total hours ÷ completed items |
| Block rate | Blocked items ÷ total items |

## Dependency Visualization

For complex projects, create dependency graph:

```
REQ-001 (DB Schema)
    │
    ├──► REQ-010 (User Model)
    │        │
    │        └──► REQ-020 (User API)
    │                 │
    │                 └──► REQ-030 (User UI)
    │
    └──► REQ-011 (Auth Service)
             │
             └──► REQ-021 (Auth API)
                      │
                      └──► REQ-031 (Login UI)
```

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| Everything in Batch 1 | No parallelization | Split by dependencies |
| Missing `Blocked by` | Hidden dependencies | Always state or "None" |
| Stale roadmap | Trust erosion | Update daily |
| No archive | Lost history | Archive completed items |
| Vague completion | Endless "in progress" | Testable criteria |

---

## Roadmap Sharding (Performance Optimization)

**Purpose:** Reduce token usage by splitting large roadmaps into batch-specific files, loading only active context.

**Token Savings:** 60-80% reduction for projects with 10+ requirements (based on BMAD framework analysis).

### When to Shard

**Shard when:**
- Roadmap exceeds 500 lines
- 10+ requirements across multiple batches
- Token usage noticeable (>2,000 tokens per request)
- Multiple agents working on different batches

**Keep monolithic when:**
- Roadmap under 300 lines
- Fewer than 8 requirements
- Single batch in progress
- Early project phase with high churn

### Shard Operation

**Command:** `/roadmap shard` or `/roadmap shard --active "Batch Name"`

**Implementation Steps:**

1. **Parse Roadmap Structure**
   ```python
   # Regex patterns for parsing
   batch_header = r'^## Batch: (.+)$'
   requirement_header = r'^### ([⚪🟡🟢🔴]) (REQ-\d+): (.+)$'

   # Structure
   roadmap = {
       'header': '',        # Everything before first ## Batch
       'batches': [
           {
               'name': 'Batch Name',
               'goal': 'Batch goal from description',
               'requirements': [...],
               'status_counts': {'⚪': 0, '🟡': 0, '🟢': 0, '🔴': 0},
               'estimated_effort': 0.0
           }
       ]
   }
   ```

2. **Extract Batches**
   - Read `.haunt/plans/roadmap.md`
   - Identify header (everything before first `## Batch:`)
   - Split content by `## Batch:` headers
   - For each batch:
     - Extract batch name from header
     - Extract all requirements until next `##` or EOF
     - Parse requirement status, effort, agent
     - Calculate batch metrics

3. **Generate Batch Files**
   ```markdown
   # Batch: [Name]

   > Sharded from roadmap on YYYY-MM-DD
   > Contains requirements from original Batch [N]

   **Status:** [Active / Archived]
   **Requirements:** X total (Y complete, Z in progress, W not started)
   **Estimated Effort:** XX hours remaining

   **Goal:** [Batch goal from original roadmap]

   ---

   ## Requirements

   ### 🟡 REQ-001: [Title]

   [Full requirement content...]

   ---

   ### ⚪ REQ-002: [Title]

   [Full requirement content...]
   ```

4. **Create Overview Roadmap**
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
   ```

5. **Determine Active Batch**
   - If `--active "Batch Name"` provided, use that
   - Else, use first batch with 🟡 In Progress items
   - Else, use first batch with ⚪ Not Started items
   - Else (all complete), use last batch

6. **Write Files**
   - Create `.haunt/plans/batches/` directory if missing
   - Write each batch to `batch-N-[slug].md`
   - Overwrite `roadmap.md` with overview

### Unshard Operation

**Command:** `/roadmap unshard`

**Implementation Steps:**

1. **Verify Sharded State**
   - Read `.haunt/plans/roadmap.md`
   - Check for "Sharding Info" section or "Other Batches" heading
   - If not sharded, error: "Roadmap is not sharded"

2. **Read Batch Files**
   - List files: `ls .haunt/plans/batches/batch-*.md`
   - Sort by batch number (batch-1, batch-2, ...)
   - Read each file content

3. **Extract Batch Content**
   - Skip metadata header (lines before first `##`)
   - Extract `## Requirements` section and all following content
   - Reconstruct as `## Batch: [Name]` section

4. **Build Merged Roadmap**
   - Start with original header (from overview roadmap)
   - Add "Current Focus" section (from overview)
   - Append each batch in order
   - Remove "Sharding Info" section
   - Remove "Other Batches" summary

5. **Write Monolithic Roadmap**
   - Overwrite `.haunt/plans/roadmap.md`
   - Keep batch files for reference (don't delete)

### Activate Operation

**Command:** `/roadmap activate "Batch Name"`

**Implementation Steps:**

1. **Validate Sharded State**
   - Read `.haunt/plans/roadmap.md`
   - Verify "Sharding Info" section exists
   - If not sharded, error: "Roadmap is not sharded"

2. **Find Matching Batch**
   - Extract batch name from command args
   - Search "Other Batches" section for matching name
   - Find corresponding file path
   - If not found, list available batches and error

3. **Read New Batch**
   - Read content from `batches/batch-N-[slug].md`
   - Extract requirements section
   - Parse batch goal/metadata

4. **Update Overview Roadmap**
   - Replace "Active Batch:" field in "Sharding Info"
   - Replace entire "## Active Batch:" section with new batch
   - Update "Current Focus:" section with new batch goal
   - Update batch status in "Other Batches" overview

5. **Write Updated Roadmap**
   - Overwrite `.haunt/plans/roadmap.md`
   - Keep all batch files unchanged

### Batch File Naming Convention

**Pattern:** `batch-N-[slug].md`

Where:
- `N` = Batch number (1, 2, 3, ...)
- `[slug]` = Lowercase, hyphenated batch name

**Examples:**
- `batch-1-command-improvements.md`
- `batch-2-setup-improvements.md`
- `batch-3-bmad-phase-1.md`
- `batch-4-bmad-phase-2.md`

**Slug generation:**
```python
def generate_slug(batch_name: str) -> str:
    """Convert batch name to filename slug."""
    # Remove special chars, lowercase, replace spaces with hyphens
    slug = batch_name.lower()
    slug = re.sub(r'[^a-z0-9\s-]', '', slug)  # Remove non-alphanumeric
    slug = re.sub(r'\s+', '-', slug)          # Spaces to hyphens
    slug = re.sub(r'-+', '-', slug)           # Collapse multiple hyphens
    slug = slug.strip('-')                    # Remove leading/trailing
    return slug

# Examples:
# "Command Improvements" → "command-improvements"
# "BMAD Enhancements - Phase 1" → "bmad-enhancements-phase-1"
# "Setup & Config" → "setup-config"
```

### Effort Estimation in Batch Files

**Effort Mapping:**
- XS = 0.5 hours
- S = 2 hours
- M = 6 hours
- SPLIT = N/A (skip in calculations)

**Calculation Logic:**
```python
def calculate_batch_effort(requirements: list) -> float:
    """Sum effort for incomplete requirements."""
    effort_map = {'XS': 0.5, 'S': 2, 'M': 6}
    total_hours = 0.0

    for req in requirements:
        # Only count ⚪ Not Started and 🟡 In Progress
        if req['status'] in ['⚪', '🟡']:
            effort = req.get('effort', 'S')  # Default to S if missing
            if effort in effort_map:
                total_hours += effort_map[effort]

    return total_hours
```

**Display Format:**
```markdown
**Estimated Effort:** 12.5 hours remaining

Requirements:
  ✅ REQ-001: [Title] (Agent: Dev) [S: 2hr]
  🟡 REQ-002: [Title] (Agent: Dev) [M: 6hr]
  ⚪ REQ-003: [Title] (Agent: Research) [XS: 0.5hr]
```

### Sharding Detection

**How to detect if roadmap is sharded:**

1. Check for "Sharding Info" section
2. Check for "Other Batches" heading
3. Check if `.haunt/plans/batches/` directory exists

**Code example:**
```python
def is_roadmap_sharded(roadmap_content: str) -> bool:
    """Detect if roadmap is sharded."""
    return (
        '## Sharding Info' in roadmap_content or
        '## Other Batches' in roadmap_content or
        os.path.exists('.haunt/plans/batches/')
    )
```

### Token Savings Calculation

**Before sharding (monolithic roadmap):**
- 850 lines × ~3 tokens/line = ~2,550 tokens
- Loaded on every assignment lookup

**After sharding (overview + active batch):**
- Overview: 50 lines × ~3 tokens/line = ~150 tokens
- Active batch: 100 lines × ~3 tokens/line = ~300 tokens
- Total: ~450 tokens per request

**Savings:**
- Absolute: 2,550 - 450 = 2,100 tokens saved
- Percentage: (2,100 / 2,550) × 100 = 82% reduction

**For large projects (50+ requirements):**
- Before: ~5,000+ tokens
- After: ~500 tokens
- Savings: 90%+ reduction

### Integration with Session Startup

**REQ-221 (future work):** Update assignment lookup to load active batch only.

**Current behavior (pre-sharding):**
```python
# Read full roadmap
roadmap = read_file('.haunt/plans/roadmap.md')
assignment = find_assignment(roadmap, agent_type)
```

**Future behavior (post-sharding aware):**
```python
# Check if sharded
roadmap = read_file('.haunt/plans/roadmap.md')

if is_sharded(roadmap):
    # Load only active batch
    active_batch = extract_active_batch(roadmap)
    assignment = find_assignment(active_batch, agent_type)
else:
    # Use full roadmap (backward compatible)
    assignment = find_assignment(roadmap, agent_type)
```

### Backward Compatibility

**Sharding is optional and reversible:**
- Roadmap works in both sharded and monolithic forms
- `/roadmap unshard` restores original format
- Batch files preserved as backup/reference
- No breaking changes to existing workflows

**Migration path:**
1. Start with monolithic roadmap (current state)
2. Shard when roadmap exceeds 500 lines
3. Unshard if needed (debugging, refactoring)
4. Re-shard when cleanup complete
