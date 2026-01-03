# haunt-baseline - Baseline Metrics Management

Manage metric baselines for regression testing. Baselines capture known-good metrics at specific points in time and provide thresholds for detecting regressions.

## Usage

```bash
haunt-baseline create <description> [--calibrated]
haunt-baseline list [--format=json|text]
haunt-baseline show <baseline-name>
haunt-baseline set-active <baseline-name>
```

## Commands

### create

Create a new baseline from current metrics.

```bash
haunt-baseline create "Post-refactor baseline"
haunt-baseline create "Stable v2.0 baseline" --calibrated
```

**Options:**
- `--calibrated` - Mark baseline as calibrated (passed 1-week stability test)

**Behavior:**
1. Collects current metrics (rule count, lines, instructions)
2. Calculates regression thresholds (warning: +23%, critical: +54%)
3. Saves to `.haunt/metrics/baselines/baseline-YYYY-MM-DD.json`
4. If uncalibrated, warns to wait 1 week before setting active

### list

List all available baselines.

```bash
haunt-baseline list
haunt-baseline list --format=json
```

**Options:**
- `--format=json|text` - Output format (default: text)

**Output columns (text format):**
- NAME - Baseline filename without extension
- DATE - Measured date
- CALIBRATED - Whether baseline passed 1-week stability test
- ACTIVE - Whether this is the currently active baseline
- DESCRIPTION - User-provided description

### show

Display details of a specific baseline.

```bash
haunt-baseline show baseline-2026-01-03
```

**Output:**
- Metadata (date, description, calibration status)
- Current metrics (rule count, lines, instructions)
- Regression thresholds (warning and critical levels)
- Per-file breakdown

### set-active

Set a baseline as the active one for regression checks.

```bash
haunt-baseline set-active baseline-2026-01-03
```

**Behavior:**
1. Verifies baseline exists
2. Warns if baseline is not calibrated
3. Prompts for confirmation if uncalibrated
4. Creates symlink at `.haunt/metrics/instruction-count-baseline.json`
5. All regression checks will now use this baseline

## Workflow

### 1. Create Initial Baseline

After completing a refactor or optimization:

```bash
haunt-baseline create "Post-efficiency-overhaul baseline"
```

### 2. Calibration Period (1 Week)

Monitor stability with daily regression checks:

```bash
# Daily check during calibration
bash Haunt/scripts/haunt-regression-check.sh
```

If all checks pass for 1 week, baseline is stable.

### 3. Mark as Calibrated

Recreate baseline with `--calibrated` flag:

```bash
haunt-baseline create "Stable v2.0 baseline" --calibrated
```

Or manually edit JSON and set `"calibrated": true`.

### 4. Set as Active

```bash
haunt-baseline set-active baseline-2026-01-03
```

### 5. Ongoing Regression Monitoring

Active baseline is now used by `haunt-regression-check.sh`:

```bash
bash Haunt/scripts/haunt-regression-check.sh
```

## Baseline Storage

**Directory structure:**

```
.haunt/metrics/
├── baselines/                           # All historical baselines
│   ├── baseline-2026-01-03.json
│   ├── baseline-2026-01-10.json
│   └── baseline-2026-01-17.json
└── instruction-count-baseline.json      # Symlink to active baseline
```

**Baseline JSON format:**

```json
{
  "measured_at": "2026-01-03",
  "description": "Post-refactor baseline",
  "calibrated": false,
  "rule_count": 6,
  "total_lines": 244,
  "instruction_count": 65,
  "files": {
    "gco-orchestration.md": {
      "lines": 42,
      "instructions": 12
    }
  },
  "regression_thresholds": {
    "rule_count": {
      "warning": 8,
      "critical": 10
    },
    "total_lines": {
      "warning": 300,
      "critical": 400
    },
    "instruction_count": {
      "warning": 80,
      "critical": 100
    }
  }
}
```

## Regression Thresholds

Thresholds are automatically calculated when creating a baseline:

- **Warning threshold:** Baseline + 23%
- **Critical threshold:** Baseline + 54%

**Rationale:**
- 23% = 1.5 standard deviations (typical variation)
- 54% = 2 standard deviations (significant regression)

**Example:**
- Baseline instruction count: 65
- Warning threshold: 80 (65 + 23%)
- Critical threshold: 100 (65 + 54%)

## Calibration

**Why calibrate?**

Baselines should be stable over time. A calibrated baseline has been verified stable for at least 1 week, ensuring:
- No unexpected regressions during normal work
- Thresholds are appropriate for typical variation
- Baseline represents sustainable state, not temporary optimum

**Calibration process:**

1. **Create uncalibrated baseline:**
   ```bash
   haunt-baseline create "Initial baseline"
   ```

2. **Monitor for 1 week:**
   ```bash
   # Run daily regression checks
   bash Haunt/scripts/haunt-regression-check.sh
   ```

3. **If stable, mark calibrated:**
   - Option A: Recreate with `--calibrated`
   - Option B: Manually edit JSON and set `"calibrated": true`

4. **Set as active:**
   ```bash
   haunt-baseline set-active baseline-2026-01-10
   ```

**Red flags during calibration:**
- Frequent threshold violations
- Metrics trending upward consistently
- Unexpected file changes

If calibration fails, investigate root cause before creating new baseline.

## Examples

### Create baseline after refactor

```bash
# After completing efficiency work
haunt-baseline create "Post-efficiency-overhaul"

# Output:
# ✅ Baseline created: baseline-2026-01-03
#
#   File:         .haunt/metrics/baselines/baseline-2026-01-03.json
#   Rule Count:   6
#   Total Lines:  244
#   Instructions: 65
#   Calibrated:   false
#
# ⚠ Baseline not calibrated - wait 1 week before setting as active
```

### List all baselines

```bash
haunt-baseline list

# Output:
# ═══ Available Baselines ═══
#
# NAME                      DATE         CALIBRATED ACTIVE     DESCRIPTION
# ----                      ----         ---------- ------     -----------
# baseline-2026-01-03       2026-01-03   No         Yes        Post-efficiency-overhaul
# baseline-2026-01-10       2026-01-10   Yes        No         Stable v2.0 baseline
```

### Show baseline details

```bash
haunt-baseline show baseline-2026-01-03

# Output:
# ═══ Baseline Details: baseline-2026-01-03 ═══
#
#   Date:        2026-01-03
#   Description: Post-efficiency-overhaul
#   Calibrated:  false
#
#   Metrics:
#     Rule Count:       6
#     Total Lines:      244
#     Instruction Count: 65
#
#   Regression Thresholds:
#     Rule Count:       ⚠️  8, 🚨 10
#     Total Lines:      ⚠️  300, 🚨 400
#     Instruction Count: ⚠️  80, 🚨 100
```

### Set active baseline

```bash
haunt-baseline set-active baseline-2026-01-10

# Output:
# ✅ Active baseline set: baseline-2026-01-10
#
#   Regression checks will now use this baseline
#   Run: bash Haunt/scripts/haunt-regression-check.sh
```

## Integration

### With haunt-regression-check

`haunt-regression-check.sh` automatically uses the active baseline:

```bash
# Uses active baseline by default
bash Haunt/scripts/haunt-regression-check.sh

# Or specify custom baseline
bash Haunt/scripts/haunt-regression-check.sh --baseline=.haunt/metrics/baselines/baseline-2026-01-03.json
```

### With CI/CD

Add regression check to GitHub Actions workflow:

```yaml
- name: Check for metric regressions
  run: |
    bash Haunt/scripts/haunt-regression-check.sh
    if [ $? -eq 2 ]; then
      echo "CRITICAL: Metric regression detected"
      exit 1
    fi
```

### With Weekly Refactor

Integrate baseline creation into weekly refactor workflow:

```bash
# After completing weekly refactor
haunt-baseline create "Weekly refactor - Week of $(date +%Y-%m-%d)"

# Monitor for 1 week, then calibrate and set active if stable
```

## Troubleshooting

### Baseline file not found

**Error:** `Baseline not found: baseline-2026-01-03`

**Solution:** Verify baseline exists:
```bash
ls .haunt/metrics/baselines/
```

### No baselines available

**Warning:** `No baselines found`

**Solution:** Create first baseline:
```bash
haunt-baseline create "Initial baseline"
```

### Symlink broken

**Error:** Active baseline symlink points to deleted file

**Solution:** Set new active baseline:
```bash
haunt-baseline list
haunt-baseline set-active <existing-baseline-name>
```

### jq not installed

**Error:** `jq is required for JSON parsing but not installed`

**Solution:** Install jq:
```bash
# macOS
brew install jq

# Linux
apt-get install jq
```

## See Also

- `haunt-regression-check` - Compare current metrics against baseline
- `haunt-metrics` - Collect current metrics
- `.haunt/metrics/baselines/` - Baseline storage directory
