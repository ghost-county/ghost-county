# Haunt Status (Framework Overview)

Display the current status of the Haunt framework - active work, agent assignments, recent completions, and available spirits.

**Alias**: `/haunt status`

## Usage

```bash
/haunt status          # Show current framework status
/haunt status --batch  # Show batch completion progress
```

## Show Framework Status

Read and present the current state from `.haunt/plans/roadmap.md`:

### Status Report Format

**The spirits report from the realm...**

#### 1. Current Focus
- Display the "Current Focus:" section goal
- Show the active batch/phase name

#### 2. Active Hauntings (🟡 In Progress)
For each 🟡 requirement:
```
🟡 REQ-XXX: [Title]
   Agent: [Agent type]
   Effort: [S/M]
   Blocked by: [Dependencies or "None"]
```

#### 3. Recently Manifested (🟢 Complete)
For each 🟢 in "Recently Completed" section:
```
🟢 REQ-XXX: [Title]
   Completed: [Date if present]
   Agent: [Agent type]
```

#### 4. Available Spirits
List all agent types available for summoning:
```
The following spirits await your call:
- gco-dev (Backend, Frontend, Infrastructure modes)
- gco-project-manager (Roadmap coordination)
- gco-research (Investigation and analysis)
- gco-code-reviewer (Code quality)
- gco-release-manager (Merge and deploy)
```

### Quick Actions

After viewing status:
- `/summon <agent> <task>` - Summon a specific spirit for work
- `/seance` - Begin orchestrated workflow
- `/haunting` - View full roadmap overview
- `/banish --all-complete` - Archive completed work

### Ghost County Theming

Use mystical language for status reports:

**Opening:**
"The spirits gather in the ethereal realm to report..."
"From beyond the veil, the hauntings reveal themselves..."

**Active Work:**
"Current hauntings in progress..."
"Spirits actively manifesting..."

**Completions:**
"Recently banished to the archives..."
"Spirits that have completed their task..."

**No Active Work:**
"The realm is quiet. No active hauntings detected."
"All spirits rest. Awaiting new summons."

Read the roadmap and present the framework status.

---

## Show Batch Progress (`--batch`)

Display batch-level completion status with blocking requirements highlighted.

### Batch Status Format

**The spirits whisper of progress across the batches...**

For each batch in roadmap:
```
## Batch: [Batch Name]
Progress: [X/Y Complete] ([Z%])
Status: [COMPLETE | IN PROGRESS | BLOCKED | NOT STARTED]

Requirements:
  ✅ REQ-XXX: [Title] (Agent: [Type])
  🟡 REQ-XXX: [Title] (Agent: [Type]) - IN PROGRESS
  ⚪ REQ-XXX: [Title] (Agent: [Type]) - WAITING
  🔴 REQ-XXX: [Title] (Agent: [Type]) - BLOCKED BY: REQ-YYY
```

### Batch Status Logic

Parse roadmap for each batch (## Batch: *):

1. **Count requirements by status:**
   - Total items: All REQ-XXX in batch
   - Complete (🟢): Count complete items
   - In Progress (🟡): Count active items
   - Not Started (⚪): Count waiting items
   - Blocked (🔴): Count blocked items

2. **Calculate completion percentage:**
   - Percentage = (Complete / Total) × 100
   - Round to nearest whole number

3. **Determine batch status:**
   - COMPLETE: All items 🟢
   - BLOCKED: Any item 🔴
   - IN PROGRESS: Some items 🟡 or 🟢, no blockers
   - NOT STARTED: All items ⚪

4. **Identify critical path:**
   - Highlight 🔴 blocked items
   - Extract "Blocked by:" field from requirement
   - Suggest unblocking actions if possible

### Display Format

**Opening:**
```
The spirits report on the progress of each batch...

[Batch Count] batches detected in the roadmap
Overall Progress: [X/Y Total] requirements complete ([Z%])
```

**Per-Batch Summary:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Batch 1: Foundation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Progress: 2/3 Complete (67%)
Status: 🔴 BLOCKED

  ✅ REQ-001: Database schema (Agent: Dev-Backend)
  ✅ REQ-002: React app structure (Agent: Dev-Frontend)
  🔴 REQ-003: CI/CD pipeline (Agent: Dev-Infrastructure)
     ⚠️  BLOCKED BY: Infrastructure access required

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Batch 2: Features
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Progress: 0/2 Complete (0%)
Status: ⚪ NOT STARTED

  ⚪ REQ-004: Task CRUD API (Agent: Dev-Backend)
     ⚠️  BLOCKED BY: REQ-001, REQ-003
  ⚪ REQ-005: Task list UI (Agent: Dev-Frontend)
     ⚠️  BLOCKED BY: REQ-002, REQ-004
```

**Closing:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Critical Path:
  🔴 REQ-003 blocks REQ-004, REQ-005
  → Action: Resolve infrastructure access to unblock Batch 1

Next Steps:
  - Focus on unblocking REQ-003 to activate Batch 2
  - 3 requirements waiting on blocker resolution
```

### Implementation Notes

**Roadmap Parsing:**
1. Read `.haunt/plans/roadmap.md`
2. Identify batch headers with regex: `^## Batch: (.+)$`
3. Extract requirements within each batch until next `##` header
4. Parse status icons: ⚪ 🟡 🟢 🔴 from `### [icon] REQ-XXX:`
5. Extract "Blocked by:" field from requirement body
6. Extract "Agent:" field from requirement body

**Status Icon Colors (if terminal supports):**
- 🟢 Complete: Green text
- 🟡 In Progress: Yellow text
- ⚪ Not Started: White/default text
- 🔴 Blocked: Red text

**Blocker Detection:**
1. Find all requirements with "Blocked by:" field not "None"
2. Parse blocker REQ-XXX IDs
3. Cross-reference to show dependency chains
4. Identify root blockers (items blocking others but not blocked themselves)

### Ghost County Theming

**Opening phrases:**
- "The spirits convene to share the state of each batch..."
- "From across the ethereal batches, progress emerges..."
- "The roadmap reveals its secrets batch by batch..."

**Batch status descriptions:**
- COMPLETE: "All spirits have completed their hauntings"
- BLOCKED: "Dark forces obstruct the path forward"
- IN PROGRESS: "Spirits actively manifesting..."
- NOT STARTED: "Awaiting the summoning call"

**Closing:**
- "The critical path beckons..."
- "Focus your efforts on the key blockers..."
