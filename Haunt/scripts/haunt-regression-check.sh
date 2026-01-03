#!/bin/bash
#
# haunt-regression-check.sh - Compare current metrics against baseline
#
# This script compares current metrics (from haunt-metrics.sh) against
# a stored baseline to detect regressions in agent performance.
#
# Usage:
#   haunt-regression-check [--baseline=<file>] [--format=json|text]
#
# Examples:
#   haunt-regression-check                                  # Use default baseline
#   haunt-regression-check --baseline=custom-baseline.json  # Custom baseline
#   haunt-regression-check --format=json                    # JSON output

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DEFAULT_BASELINE="$PROJECT_ROOT/.haunt/metrics/instruction-count-baseline.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default options
BASELINE_FILE="$DEFAULT_BASELINE"
FORMAT="text"

# Helper functions
info() {
    if [ "$FORMAT" != "json" ]; then
        echo -e "${BLUE}ℹ${NC} $1"
    fi
}

success() {
    if [ "$FORMAT" != "json" ]; then
        echo -e "${GREEN}✅${NC} $1"
    fi
}

error() {
    echo -e "${RED}❌${NC} $1" >&2
}

warning() {
    if [ "$FORMAT" != "json" ]; then
        echo -e "${YELLOW}⚠${NC} $1"
    fi
}

section() {
    if [ "$FORMAT" != "json" ]; then
        echo -e "\n${CYAN}═══${NC} $1 ${CYAN}═══${NC}"
    fi
}

# Parse command-line arguments
parse_args() {
    for arg in "$@"; do
        case $arg in
            --baseline=*)
                BASELINE_FILE="${arg#*=}"
                ;;
            --format=*)
                FORMAT="${arg#*=}"
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                error "Unknown argument: $arg"
                show_help
                exit 1
                ;;
        esac
    done
}

show_help() {
    cat << 'EOF'
haunt-regression-check - Compare current metrics against baseline

Usage:
  haunt-regression-check [OPTIONS]

Options:
  --baseline=<file>      Path to baseline JSON file (default: .haunt/metrics/instruction-count-baseline.json)
  --format=json|text     Output format (default: text)
  --help, -h             Show this help message

Metrics Compared:
  1. Rule Count          - Number of rule files
  2. Total Lines         - Sum of all rule lines
  3. Instruction Count   - Count of imperative instructions
  4. Context Overhead    - Total context consumption (if available)

Threshold Levels:
  - OK:       Within baseline targets
  - WARNING:  Exceeds warning threshold
  - CRITICAL: Exceeds critical threshold

Examples:
  haunt-regression-check                                  # Use default baseline
  haunt-regression-check --baseline=custom-baseline.json  # Custom baseline
  haunt-regression-check --format=json                    # JSON output

Exit Codes:
  0 - All metrics within thresholds (OK)
  1 - One or more warnings detected
  2 - One or more critical regressions detected
  3 - Error running checks (missing baseline, etc.)
EOF
}

# Validate environment
validate_environment() {
    if [ ! -f "$BASELINE_FILE" ]; then
        error "Baseline file not found: $BASELINE_FILE"
        exit 3
    fi

    # Check if jq is available for JSON parsing
    if ! command -v jq &> /dev/null; then
        error "jq is required for JSON parsing but not installed"
        error "Install with: brew install jq (macOS) or apt-get install jq (Linux)"
        exit 3
    fi

    # Check if haunt-metrics.sh exists
    if [ ! -f "$SCRIPT_DIR/haunt-metrics.sh" ]; then
        error "haunt-metrics.sh not found: $SCRIPT_DIR/haunt-metrics.sh"
        exit 3
    fi
}

# Load baseline from JSON file
load_baseline() {
    local baseline_json=$(cat "$BASELINE_FILE")

    # Extract baseline values
    BASELINE_RULE_COUNT=$(echo "$baseline_json" | jq -r '.rule_count // 0')
    BASELINE_TOTAL_LINES=$(echo "$baseline_json" | jq -r '.total_lines // 0')
    BASELINE_INSTRUCTION_COUNT=$(echo "$baseline_json" | jq -r '.instruction_count // 0')

    # Extract thresholds
    RULE_COUNT_WARNING=$(echo "$baseline_json" | jq -r '.regression_thresholds.rule_count.warning // 0')
    RULE_COUNT_CRITICAL=$(echo "$baseline_json" | jq -r '.regression_thresholds.rule_count.critical // 0')

    TOTAL_LINES_WARNING=$(echo "$baseline_json" | jq -r '.regression_thresholds.total_lines.warning // 0')
    TOTAL_LINES_CRITICAL=$(echo "$baseline_json" | jq -r '.regression_thresholds.total_lines.critical // 0')

    INSTRUCTION_COUNT_WARNING=$(echo "$baseline_json" | jq -r '.regression_thresholds.instruction_count.warning // 0')
    INSTRUCTION_COUNT_CRITICAL=$(echo "$baseline_json" | jq -r '.regression_thresholds.instruction_count.critical // 0')

    # Extract baseline date
    BASELINE_DATE=$(echo "$baseline_json" | jq -r '.measured_at // "unknown"')
}

# Count effective lines in file (excluding blank and comment lines)
count_effective_lines() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo "0"
        return
    fi
    grep -v '^\s*$' "$file" | grep -v '^\s*#' | wc -l | tr -d ' '
}

# Count imperative instructions in file
count_instructions() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo "0"
        return
    fi

    # Count lines starting with imperative verbs (after trimming whitespace)
    # Common instruction patterns: MUST, NEVER, ALWAYS, DO NOT, Should, Must, etc.
    grep -iE '^\s*(MUST|NEVER|ALWAYS|DO NOT|SHOULD|SHALL|CANNOT|REQUIRED|MANDATORY|FORBIDDEN|PROHIBITED)' "$file" | wc -l | tr -d ' '
}

# Collect current metrics
collect_current_metrics() {
    local rules_dir="$PROJECT_ROOT/Haunt/rules"

    CURRENT_RULE_COUNT=0
    CURRENT_TOTAL_LINES=0
    CURRENT_INSTRUCTION_COUNT=0

    if [ -d "$rules_dir" ]; then
        for rule_file in "$rules_dir"/*.md; do
            if [ -f "$rule_file" ]; then
                ((CURRENT_RULE_COUNT++))

                local lines=$(count_effective_lines "$rule_file")
                CURRENT_TOTAL_LINES=$((CURRENT_TOTAL_LINES + lines))

                local instructions=$(count_instructions "$rule_file")
                CURRENT_INSTRUCTION_COUNT=$((CURRENT_INSTRUCTION_COUNT + instructions))
            fi
        done
    fi

    CURRENT_DATE=$(date +%Y-%m-%d)
}

# Compare metric against thresholds
# Returns: OK, WARNING, CRITICAL
check_threshold() {
    local current="$1"
    local baseline="$2"
    local warning="$3"
    local critical="$4"

    # If current <= baseline, it's OK (no regression)
    if [ "$current" -le "$baseline" ]; then
        echo "OK"
        return 0
    fi

    # If current > critical threshold, it's CRITICAL
    if [ "$current" -ge "$critical" ]; then
        echo "CRITICAL"
        return 2
    fi

    # If current > warning threshold, it's WARNING
    if [ "$current" -ge "$warning" ]; then
        echo "WARNING"
        return 1
    fi

    # Otherwise OK (between baseline and warning)
    echo "OK"
    return 0
}

# Format metric comparison for text output
format_comparison() {
    local metric_name="$1"
    local current="$2"
    local baseline="$3"
    local status="$4"
    local warning="$5"
    local critical="$6"

    local status_icon=""
    local status_color=""

    case "$status" in
        OK)
            status_icon="✅"
            status_color="${GREEN}"
            ;;
        WARNING)
            status_icon="⚠️ "
            status_color="${YELLOW}"
            ;;
        CRITICAL)
            status_icon="🚨"
            status_color="${RED}"
            ;;
    esac

    # Calculate delta
    local delta=$((current - baseline))
    local delta_str=""
    if [ $delta -gt 0 ]; then
        delta_str=" (+$delta)"
    elif [ $delta -lt 0 ]; then
        delta_str=" ($delta)"
    fi

    echo -e "  ${status_icon} ${metric_name}:"
    echo -e "      Current:   ${status_color}${current}${NC}${delta_str}"
    echo -e "      Baseline:  ${baseline}"
    echo -e "      Thresholds: ⚠️ ${warning}, 🚨 ${critical}"
    echo -e "      Status:    ${status_color}${status}${NC}"
}

# Perform regression check
perform_regression_check() {
    local overall_status="OK"
    local exit_code=0

    # Check rule count
    local rule_count_status=$(check_threshold "$CURRENT_RULE_COUNT" "$BASELINE_RULE_COUNT" "$RULE_COUNT_WARNING" "$RULE_COUNT_CRITICAL")

    # Check total lines
    local total_lines_status=$(check_threshold "$CURRENT_TOTAL_LINES" "$BASELINE_TOTAL_LINES" "$TOTAL_LINES_WARNING" "$TOTAL_LINES_CRITICAL")

    # Check instruction count
    local instruction_count_status=$(check_threshold "$CURRENT_INSTRUCTION_COUNT" "$BASELINE_INSTRUCTION_COUNT" "$INSTRUCTION_COUNT_WARNING" "$INSTRUCTION_COUNT_CRITICAL")

    # Determine overall status (worst of all checks)
    for status in "$rule_count_status" "$total_lines_status" "$instruction_count_status"; do
        if [ "$status" = "CRITICAL" ]; then
            overall_status="CRITICAL"
            exit_code=2
        elif [ "$status" = "WARNING" ] && [ "$overall_status" != "CRITICAL" ]; then
            overall_status="WARNING"
            exit_code=1
        fi
    done

    if [ "$FORMAT" = "json" ]; then
        # JSON output
        cat << JSON
{
  "regression_check": {
    "baseline_date": "$BASELINE_DATE",
    "current_date": "$CURRENT_DATE",
    "overall_status": "$overall_status",
    "metrics": {
      "rule_count": {
        "current": $CURRENT_RULE_COUNT,
        "baseline": $BASELINE_RULE_COUNT,
        "delta": $((CURRENT_RULE_COUNT - BASELINE_RULE_COUNT)),
        "warning_threshold": $RULE_COUNT_WARNING,
        "critical_threshold": $RULE_COUNT_CRITICAL,
        "status": "$rule_count_status"
      },
      "total_lines": {
        "current": $CURRENT_TOTAL_LINES,
        "baseline": $BASELINE_TOTAL_LINES,
        "delta": $((CURRENT_TOTAL_LINES - BASELINE_TOTAL_LINES)),
        "warning_threshold": $TOTAL_LINES_WARNING,
        "critical_threshold": $TOTAL_LINES_CRITICAL,
        "status": "$total_lines_status"
      },
      "instruction_count": {
        "current": $CURRENT_INSTRUCTION_COUNT,
        "baseline": $BASELINE_INSTRUCTION_COUNT,
        "delta": $((CURRENT_INSTRUCTION_COUNT - BASELINE_INSTRUCTION_COUNT)),
        "warning_threshold": $INSTRUCTION_COUNT_WARNING,
        "critical_threshold": $INSTRUCTION_COUNT_CRITICAL,
        "status": "$instruction_count_status"
      }
    }
  }
}
JSON
    else
        # Text output
        section "Regression Check Results"
        echo ""
        echo "  Baseline Date:  $BASELINE_DATE"
        echo "  Current Date:   $CURRENT_DATE"
        echo ""

        format_comparison "Rule Count" "$CURRENT_RULE_COUNT" "$BASELINE_RULE_COUNT" "$rule_count_status" "$RULE_COUNT_WARNING" "$RULE_COUNT_CRITICAL"
        echo ""

        format_comparison "Total Lines" "$CURRENT_TOTAL_LINES" "$BASELINE_TOTAL_LINES" "$total_lines_status" "$TOTAL_LINES_WARNING" "$TOTAL_LINES_CRITICAL"
        echo ""

        format_comparison "Instruction Count" "$CURRENT_INSTRUCTION_COUNT" "$BASELINE_INSTRUCTION_COUNT" "$instruction_count_status" "$INSTRUCTION_COUNT_WARNING" "$INSTRUCTION_COUNT_CRITICAL"
        echo ""

        section "Overall Status"
        echo ""

        case "$overall_status" in
            OK)
                success "All metrics within thresholds"
                ;;
            WARNING)
                warning "One or more metrics exceed warning thresholds"
                ;;
            CRITICAL)
                error "One or more metrics exceed critical thresholds"
                ;;
        esac

        echo ""
    fi

    return $exit_code
}

# Main execution
main() {
    parse_args "$@"
    validate_environment

    if [ "$FORMAT" = "text" ]; then
        echo ""
        echo "═══════════════════════════════════════════"
        echo "  Haunt Regression Check"
        echo "═══════════════════════════════════════════"
        echo ""
        info "Baseline: $BASELINE_FILE"
    fi

    # Load baseline
    load_baseline

    # Collect current metrics
    collect_current_metrics

    # Perform regression check
    perform_regression_check
    exit_code=$?

    if [ "$FORMAT" = "text" ]; then
        echo ""
    fi

    exit $exit_code
}

main "$@"
