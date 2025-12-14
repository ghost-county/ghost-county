# Cleanse (Uninstall Haunt)

Cleanse the Haunt framework from your system. Choose between partial cleansing (global artifacts only) or full cleansing (global + project artifacts).

## Usage

```
/cleanse                  # Interactive mode with safety prompts
/cleanse --partial        # Remove ~/.claude artifacts only
/cleanse --full           # Remove ~/.claude AND .haunt artifacts
/cleanse --backup         # Create backup before deletion
/cleanse --force          # Skip confirmation prompts (dangerous!)
```

## Safety Features

Before performing any cleansing, the ritual will:

1. **Display what will be removed** - Show all files/directories to be deleted
2. **Check for uncommitted work** - Warn if `.haunt/plans/roadmap.md` has changes or in-progress items
3. **Offer backup** - Create `~/haunt-backup-YYYY-MM-DD-HHMMSS.tar.gz` before deletion
4. **Require confirmation** - Explicit "yes" required to proceed (unless --force)

## Cleansing Modes

### Partial Cleanse (Default Safe Mode)

Removes **global** Ghost County artifacts from `~/.claude/`:

```
~/.claude/agents/gco-*.md
~/.claude/rules/gco-*.md
~/.claude/skills/gco-*/
~/.claude/commands/gco-*.md
```

**Preserves:**
- Project-specific `.haunt/` directory (roadmap, progress, completed work)
- `Haunt/` source directory (your cloned repo)
- Non-GCO agents/rules/skills/commands (if any exist)

**Use when:** You want to remove the framework but keep your project planning artifacts.

### Full Cleanse (Complete Removal)

Removes **both** global `~/.claude/` AND project `.haunt/` artifacts:

```
~/.claude/agents/gco-*.md
~/.claude/rules/gco-*.md
~/.claude/skills/gco-*/
~/.claude/commands/gco-*.md
.haunt/                    # ⚠️ ALL planning, progress, completed work
```

**Preserves:**
- `Haunt/` source directory (your cloned repo)
- Non-GCO agents/rules/skills/commands

**Use when:** Starting fresh or completely removing Ghost County from this project.

⚠️ **WARNING:** Full cleanse deletes your roadmap, progress reports, and archived work. Backup first!

## Interactive Workflow

When you invoke `/cleanse` without arguments, you'll be guided through:

### Step 1: Uncommitted Work Check

```
👻 Checking for restless spirits...

⚠️ WARNING: Uncommitted work detected in .haunt/plans/roadmap.md
⚠️ WARNING: 3 requirements marked 🟡 In Progress:
   - REQ-123: Feature implementation
   - REQ-125: Bug fix
   - REQ-127: Documentation update

🔮 Recommendation: Finish or commit your work before cleansing.

Continue anyway? (yes/no): _
```

### Step 2: Choose Cleansing Mode

```
👻 How thorough shall the cleansing be?

[1] Partial Cleanse - Remove ~/.claude/gco-* artifacts only
    Preserves: .haunt/ directory with your roadmap and progress

[2] Full Cleanse - Remove ~/.claude/gco-* AND .haunt/ directory
    ⚠️ Destroys: All planning, progress, and archived work

Choice (1/2): _
```

### Step 3: Preview Deletion

```
👻 The following will be cleansed:

Global Artifacts (~/.claude/):
  Agents (5):
    - gco-dev-backend.md
    - gco-dev-frontend.md
    - gco-dev-infrastructure.md
    - gco-research-analyst.md
    - gco-project-manager.md

  Rules (8):
    - gco-session-startup.md
    - gco-commit-conventions.md
    - gco-file-conventions.md
    - gco-roadmap-format.md
    - gco-status-updates.md
    - gco-assignment-lookup.md
    - gco-completion-checklist.md
    - gco-framework-changes.md

  Skills (17):
    - gco-session-startup/
    - gco-commit-conventions/
    - gco-roadmap-workflow/
    - gco-tdd-workflow/
    - gco-code-patterns/
    - gco-feature-contracts/
    - gco-context7-usage/
    - gco-pattern-defeat/
    - gco-seance/
    - gco-coven-mode/
    - gco-witching-hour/
    - gco-issue-to-roadmap/
    - gco-file-permissions/
    - gco-nats-connectivity/
    - gco-agent-memory-persistence/
    - gco-pattern-detection/
    - gco-memory-consolidation/

  Commands (18):
    - gco-summon.md
    - gco-ritual.md
    - gco-summon-all.md
    - gco-haunt.md
    - gco-cleanse.md
    - haunt.md
    - haunt-update.md
    - seance.md
    - haunting.md
    - banish.md
    - coven.md
    - seer.md
    - exorcism.md
    - apparition.md
    - witching-hour.md

[Full mode only]
Project Artifacts (.haunt/):
  - .haunt/plans/roadmap.md
  - .haunt/plans/*.md
  - .haunt/completed/
  - .haunt/progress/
  - .haunt/tests/
  - .haunt/docs/
```

### Step 4: Backup Offer

```
🔮 Create backup before cleansing?

A backup will be saved to:
  ~/haunt-backup-2025-12-13-143022.tar.gz

This includes all files that will be deleted.

Create backup? (yes/no): _
```

### Step 5: Final Confirmation

```
⚠️ FINAL WARNING ⚠️

This will permanently delete the files listed above.
This action CANNOT be undone (unless you created a backup).

Type 'CLEANSE' to proceed: _
```

### Step 6: Execution

```
👻 Beginning the cleansing ritual...

🔮 Creating backup: ~/haunt-backup-2025-12-13-143022.tar.gz
✓ Backup created (2.4 MB)

🌫️ Cleansing global agents (5 files)...
✓ Removed ~/.claude/agents/gco-dev-backend.md
✓ Removed ~/.claude/agents/gco-dev-frontend.md
✓ Removed ~/.claude/agents/gco-dev-infrastructure.md
✓ Removed ~/.claude/agents/gco-research-analyst.md
✓ Removed ~/.claude/agents/gco-project-manager.md

🌫️ Cleansing global rules (8 files)...
✓ Removed ~/.claude/rules/gco-*.md (8 files)

🌫️ Cleansing global skills (17 directories)...
✓ Removed ~/.claude/skills/gco-*/ (17 directories)

🌫️ Cleansing global commands (20 files)...
✓ Removed ~/.claude/commands/*.md (20 files)

[Full mode only]
🌫️ Cleansing project artifacts (.haunt/)...
✓ Removed .haunt/ directory

👻 The cleansing is complete. Ghost County has been purified.

Backup saved to: ~/haunt-backup-2025-12-13-143022.tar.gz
```

## Implementation via Script

The actual deletion logic is implemented in `Haunt/scripts/cleanse.sh`:

```bash
bash Haunt/scripts/cleanse.sh [--partial|--full] [--backup] [--force]
```

## Restore from Backup

If you created a backup and want to restore:

```bash
# Extract to see contents
tar -tzf ~/haunt-backup-2025-12-13-143022.tar.gz

# Restore (be careful - this will overwrite!)
cd ~
tar -xzf ~/haunt-backup-2025-12-13-143022.tar.gz
```

## Error Handling

- **Script not found**: If `cleanse.sh` doesn't exist, provide manual removal instructions
- **Permission denied**: Suggest using `chmod +x` or running with `bash`
- **Backup failed**: Offer to continue without backup or abort
- **Partial deletion failure**: Report what succeeded and what failed

## Ghost County Flavor

When reporting success:
- "The spirits have been cleansed. Ghost County shines anew."
- "The cleansing is complete. The veil has been purified."
- "Your repository walks in clarity once more."

When reporting errors:
- "The spirits resist! Permission denied: [file]"
- "The ritual falters - backup creation failed."
- "Some remnants linger... [list of files that couldn't be removed]"

## See Also

- `/haunt-update` - Update Haunt to latest version without full reinstall
- `/banish` - Archive completed work (different from cleansing)
- `setup-haunt.sh` - Reinstall Haunt after cleansing
