# Exorcism (Uninstall Haunt)

Cast out the Haunt framework from your system. Choose between partial exorcism (global artifacts only) or full exorcism (global + project artifacts).

## Usage

```
/exorcism                  # Interactive mode with safety prompts
/exorcism --partial        # Remove ~/.claude artifacts only
/exorcism --full           # Remove ~/.claude AND .haunt artifacts
/exorcism --backup         # Create backup before deletion
/exorcism --force          # Skip confirmation prompts (dangerous!)
```

## Safety Features

Before performing any exorcism, the ritual will:

1. **Display what will be removed** - Show all files/directories to be deleted
2. **Check for uncommitted work** - Warn if `.haunt/plans/roadmap.md` has changes or in-progress items
3. **Offer backup** - Create `~/haunt-backup-YYYY-MM-DD-HHMMSS.tar.gz` before deletion
4. **Require confirmation** - Explicit "yes" required to proceed (unless --force)

## Exorcism Modes

### Partial Exorcism (Default Safe Mode)

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

### Full Exorcism (Complete Removal)

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

⚠️ **WARNING:** Full exorcism deletes your roadmap, progress reports, and archived work. Backup first!

## Interactive Workflow

When you invoke `/exorcism` without arguments, you'll be guided through:

### Step 1: Uncommitted Work Check

```
👻 Checking for restless spirits...

⚠️ WARNING: Uncommitted work detected in .haunt/plans/roadmap.md
⚠️ WARNING: 3 requirements marked 🟡 In Progress:
   - REQ-123: Feature implementation
   - REQ-125: Bug fix
   - REQ-127: Documentation update

🔮 Recommendation: Finish or commit your work before exorcising.

Continue anyway? (yes/no): _
```

### Step 2: Choose Exorcism Mode

```
👻 How deep shall the exorcism go?

[1] Partial Exorcism - Remove ~/.claude/gco-* artifacts only
    Preserves: .haunt/ directory with your roadmap and progress

[2] Full Exorcism - Remove ~/.claude/gco-* AND .haunt/ directory
    ⚠️ Destroys: All planning, progress, and archived work

Choice (1/2): _
```

### Step 3: Preview Deletion

```
👻 The following will be banished:

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
    - gco-exorcism.md
    - haunt.md
    - haunt-update.md
    - ritual.md
    - seance.md
    - haunting.md
    - hauntings.md
    - spirits.md
    - summon.md
    - divine.md
    - banish.md
    - coven.md
    - curse.md
    - exorcise.md
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
🔮 Create backup before exorcism?

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

Type 'EXORCISE' to proceed: _
```

### Step 6: Execution

```
👻 Beginning the exorcism ritual...

🔮 Creating backup: ~/haunt-backup-2025-12-13-143022.tar.gz
✓ Backup created (2.4 MB)

🌫️ Banishing global agents (5 files)...
✓ Removed ~/.claude/agents/gco-dev-backend.md
✓ Removed ~/.claude/agents/gco-dev-frontend.md
✓ Removed ~/.claude/agents/gco-dev-infrastructure.md
✓ Removed ~/.claude/agents/gco-research-analyst.md
✓ Removed ~/.claude/agents/gco-project-manager.md

🌫️ Banishing global rules (8 files)...
✓ Removed ~/.claude/rules/gco-*.md (8 files)

🌫️ Banishing global skills (17 directories)...
✓ Removed ~/.claude/skills/gco-*/ (17 directories)

🌫️ Banishing global commands (20 files)...
✓ Removed ~/.claude/commands/*.md (20 files)

[Full mode only]
🌫️ Banishing project artifacts (.haunt/)...
✓ Removed .haunt/ directory

👻 The exorcism is complete. Ghost County has been banished.

Backup saved to: ~/haunt-backup-2025-12-13-143022.tar.gz
```

## Implementation via Script

The actual deletion logic is implemented in `Haunt/scripts/exorcism.sh`:

```bash
bash Haunt/scripts/exorcism.sh [--partial|--full] [--backup] [--force]
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

- **Script not found**: If `exorcism.sh` doesn't exist, provide manual removal instructions
- **Permission denied**: Suggest using `chmod +x` or running with `bash`
- **Backup failed**: Offer to continue without backup or abort
- **Partial deletion failure**: Report what succeeded and what failed

## Ghost County Flavor

When reporting success:
- "The spirits have departed. Ghost County is no more."
- "The exorcism is complete. The veil has closed."
- "Your repository walks in daylight once more."

When reporting errors:
- "The spirits resist! Permission denied: [file]"
- "The ritual falters - backup creation failed."
- "Some spirits linger... [list of files that couldn't be removed]"

## See Also

- `/haunt-update` - Update Haunt to latest version without full reinstall
- `/banish` - Archive completed work (different from exorcism)
- `setup-haunt.sh` - Reinstall Haunt after exorcism
