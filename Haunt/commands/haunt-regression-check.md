# haunt-regression-check - Detect Agent Performance Regressions

## Purpose

Compare current metrics against a stored baseline to detect regressions in agent performance, instruction overhead, and context bloat.

## Usage

```bash
haunt-regression-check [OPTIONS]
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `--baseline=<file>` | Path to baseline JSON file | `.haunt/metrics/instruction-count-baseline.json` |
| `--format=json\|text` | Output format | `text` |
| `--help`, `-h` | Show help message | - |

## Metrics Compared

The script compares current metrics against baseline thresholds:

1. **Rule Count** - Number of rule files in `Haunt/rules/`
2. **Total Lines** - Sum of all effective rule lines (excluding blanks and comments)
3. **Instruction Count** - Count of imperative instructions (MUST, NEVER, ALWAYS, etc.)
4. **Context Overhead** - Total context consumption (if available in baseline)

## Threshold Levels

Each metric has two threshold levels defined in the baseline:

| Level | Meaning | Exit Code |
|-------|---------|-----------|
| **OK** | Metric within baseline target | 0 |
| **WARNING** ⚠️ | Metric exceeds warning threshold | 1 |
| **CRITICAL** 🚨 | Metric exceeds critical threshold | 2 |

**Example Thresholds** (from instruction-count-baseline.json):

```json
{
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

## Examples

### Default Usage (Text Output)

```bash
$ haunt-regression-check

═══════════════════════════════════════════
  Haunt Regression Check
═══════════════════════════════════════════

ℹ Baseline: .haunt/metrics/instruction-count-baseline.json

═══ Regression Check Results ═══

  Baseline Date:  2026-01-03
  Current Date:   2026-01-03

  ✅ Rule Count:
      Current:   6
      Baseline:  6
      Thresholds: ⚠️ 8, 🚨 10
      Status:    OK

  ✅ Total Lines:
      Current:   244
      Baseline:  244
      Thresholds: ⚠️ 300, 🚨 400
      Status:    OK

  ✅ Instruction Count:
      Current:   65
      Baseline:  65
      Thresholds: ⚠️ 80, 🚨 100
      Status:    OK

═══ Overall Status ═══

✅ All metrics within thresholds
```

### Custom Baseline

```bash
$ haunt-regression-check --baseline=.haunt/metrics/baseline-2026-01-01.json
```

### JSON Output (for CI/CD)

```bash
$ haunt-regression-check --format=json
```

**Output:**

```json
{
  "regression_check": {
    "baseline_date": "2026-01-03",
    "current_date": "2026-01-03",
    "overall_status": "OK",
    "metrics": {
      "rule_count": {
        "current": 6,
        "baseline": 6,
        "delta": 0,
        "warning_threshold": 8,
        "critical_threshold": 10,
        "status": "OK"
      },
      "total_lines": {
        "current": 244,
        "baseline": 244,
        "delta": 0,
        "warning_threshold": 300,
        "critical_threshold": 400,
        "status": "OK"
      },
      "instruction_count": {
        "current": 65,
        "baseline": 65,
        "delta": 0,
        "warning_threshold": 80,
        "critical_threshold": 100,
        "status": "OK"
      }
    }
  }
}
```

### Warning Example

```bash
$ haunt-regression-check

═══ Regression Check Results ═══

  ⚠️  Instruction Count:
      Current:   85 (+20)
      Baseline:  65
      Thresholds: ⚠️ 80, 🚨 100
      Status:    WARNING

═══ Overall Status ═══

⚠ One or more metrics exceed warning thresholds

# Exit code: 1
```

### Critical Regression Example

```bash
$ haunt-regression-check

═══ Regression Check Results ═══

  🚨 Instruction Count:
      Current:   105 (+40)
      Baseline:  65
      Thresholds: ⚠️ 80, 🚨 100
      Status:    CRITICAL

═══ Overall Status ═══

❌ One or more metrics exceed critical thresholds

# Exit code: 2
```

## Exit Codes

| Code | Meaning | Use Case |
|------|---------|----------|
| 0 | All metrics OK | Safe to proceed |
| 1 | Warning detected | Review before merging |
| 2 | Critical regression | Block merge, investigate |
| 3 | Error running check | Fix environment (missing baseline, jq, etc.) |

## CI/CD Integration

Use in GitHub Actions to prevent context bloat merges:

```yaml
- name: Check for regressions
  run: |
    bash Haunt/scripts/haunt-regression-check.sh
  # Exits with code 2 if critical regression detected
```

## Baseline Management

### Creating a Baseline

Baselines are created manually after optimization work (e.g., REQ-330):

```bash
# Collect current metrics
$ haunt-metrics --context --format=json > .haunt/metrics/instruction-count-baseline.json

# Edit to add regression thresholds
$ nano .haunt/metrics/instruction-count-baseline.json
```

### Updating a Baseline

Only update baselines after **intentional, reviewed optimizations**:

1. Complete optimization work (e.g., domain standards conversion)
2. Verify metrics improved with `haunt-metrics --context`
3. Run regression check against old baseline
4. If metrics improved, create new baseline
5. Document in commit message what changed

**NEVER** update baseline to "make warnings go away" - that defeats the purpose of regression detection.

## Workflow Integration

### Weekly Refactor Ritual

Phase 0: Metrics Review
```bash
# Check for regressions
haunt-regression-check

# If warnings/criticals, investigate before proceeding
```

### Pre-Commit Hook

Add to `.git/hooks/pre-commit`:

```bash
#!/bin/bash
# Prevent commits that introduce critical regressions
if ! bash Haunt/scripts/haunt-regression-check.sh; then
    exit_code=$?
    if [ $exit_code -eq 2 ]; then
        echo "❌ Critical regression detected. Fix before committing."
        exit 1
    fi
fi
```

### PR Review Checklist

Before approving PRs that modify rules:

```bash
# Verify no regressions
$ haunt-regression-check

# If OK, approve
# If WARNING, request explanation
# If CRITICAL, request changes
```

## Dependencies

### Required

- **jq** - JSON parsing
  - macOS: `brew install jq`
  - Linux: `apt-get install jq`

### Optional

- **haunt-metrics.sh** - For collecting current metrics (not required if only checking)

## See Also

- **haunt-metrics** - Collect current metrics
- **gco-weekly-refactor** - Weekly refactor ritual
- **REQ-312** - Context overhead metric implementation
- **REQ-313** - This command's implementation
- **REQ-314** - Baseline metrics storage system
