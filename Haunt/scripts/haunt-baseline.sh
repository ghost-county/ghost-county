#!/bin/bash
#
# haunt-baseline.sh - Manage metric baselines for regression testing
#
# This script creates, manages, and versions metric baselines used by
# haunt-regression-check.sh to detect performance regressions.
#
# Usage:
#   haunt-baseline create "description" [--calibrated]
#   haunt-baseline list [--format=json|text]
#   haunt-baseline show <baseline-name>
#   haunt-baseline set-active <baseline-name>
#
# Examples:
#   haunt-baseline create "Post-refactor baseline"
#   haunt-baseline list
#   haunt-baseline show baseline-2026-01-03
#   haunt-baseline set-active baseline-2026-01-03

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
METRICS_DIR="$PROJECT_ROOT/.haunt/metrics"
BASELINES_DIR="$METRICS_DIR/baselines"
ACTIVE_BASELINE="$METRICS_DIR/instruction-count-baseline.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper functions
info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

success() {
    echo -e "${GREEN}✅${NC} $1"
}

error() {
    echo -e "${RED}❌${NC} $1" >&2
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

section() {
    echo -e "\n${CYAN}═══${NC} $1 ${CYAN}═══${NC}"
}

# Show help message
show_help() {
    cat << 'EOF'
haunt-baseline - Manage metric baselines for regression testing

Usage:
  haunt-baseline create <description> [--calibrated]
  haunt-baseline list [--format=json|text]
  haunt-baseline show <baseline-name>
  haunt-baseline set-active <baseline-name>

Commands:
  create      Create new baseline from current metrics
  list        List all available baselines
  show        Display details of a specific baseline
  set-active  Set a baseline as the active one for regression checks

Options (create):
  --calibrated    Mark baseline as calibrated (passed 1-week stability test)

Options (list):
  --format=json|text    Output format (default: text)

Examples:
  # Create new baseline
  haunt-baseline create "Post-refactor baseline"

  # Create calibrated baseline (after 1-week stability)
  haunt-baseline create "Stable v2.0 baseline" --calibrated

  # List all baselines
  haunt-baseline list

  # Show specific baseline
  haunt-baseline show baseline-2026-01-03

  # Set active baseline
  haunt-baseline set-active baseline-2026-01-03

Baseline Storage:
  - Baselines stored in: .haunt/metrics/baselines/
  - Active baseline: .haunt/metrics/instruction-count-baseline.json (symlink)
  - Naming: baseline-YYYY-MM-DD.json

Calibration:
  Baselines should be calibrated over 1 week before setting as active:
  1. Create baseline: haunt-baseline create "description"
  2. Wait 1 week, verify stability with regression checks
  3. If stable, mark calibrated: Use --calibrated on creation or manually edit JSON
  4. Set as active: haunt-baseline set-active <name>
EOF
}

# Validate environment
validate_environment() {
    # Ensure directories exist
    mkdir -p "$BASELINES_DIR"

    # Check if jq is available
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
    grep -iE '^\s*(MUST|NEVER|ALWAYS|DO NOT|SHOULD|SHALL|CANNOT|REQUIRED|MANDATORY|FORBIDDEN|PROHIBITED)' "$file" | wc -l | tr -d ' '
}

# Collect current metrics
collect_metrics() {
    local rules_dir="$PROJECT_ROOT/Haunt/rules"

    local rule_count=0
    local total_lines=0
    local instruction_count=0
    local files_json="{"

    if [ -d "$rules_dir" ]; then
        local first=true
        for rule_file in "$rules_dir"/*.md; do
            if [ -f "$rule_file" ]; then
                ((rule_count++))

                local lines=$(count_effective_lines "$rule_file")
                total_lines=$((total_lines + lines))

                local instructions=$(count_instructions "$rule_file")
                instruction_count=$((instruction_count + instructions))

                # Add file entry to JSON
                local basename=$(basename "$rule_file")
                if [ "$first" = true ]; then
                    first=false
                else
                    files_json="${files_json},"
                fi
                files_json="${files_json}\"${basename}\":{\"lines\":${lines},\"instructions\":${instructions}}"
            fi
        done
    fi

    files_json="${files_json}}"

    echo "$rule_count|$total_lines|$instruction_count|$files_json"
}

# Create new baseline
cmd_create() {
    local description="$1"
    local calibrated=false

    if [ -z "$description" ]; then
        error "Description is required"
        echo ""
        echo "Usage: haunt-baseline create <description> [--calibrated]"
        exit 1
    fi

    # Check for --calibrated flag
    for arg in "$@"; do
        if [ "$arg" = "--calibrated" ]; then
            calibrated=true
        fi
    done

    section "Creating New Baseline"
    echo ""

    # Collect current metrics
    info "Collecting current metrics..."
    local metrics=$(collect_metrics)
    local rule_count=$(echo "$metrics" | cut -d'|' -f1)
    local total_lines=$(echo "$metrics" | cut -d'|' -f2)
    local instruction_count=$(echo "$metrics" | cut -d'|' -f3)
    local files_json=$(echo "$metrics" | cut -d'|' -f4)

    # Generate baseline filename
    local date=$(date +%Y-%m-%d)
    local baseline_name="baseline-${date}"
    local baseline_file="$BASELINES_DIR/${baseline_name}.json"

    # Check if baseline already exists for today
    if [ -f "$baseline_file" ]; then
        # Add time suffix if baseline already exists
        local timestamp=$(date +%H%M%S)
        baseline_name="baseline-${date}-${timestamp}"
        baseline_file="$BASELINES_DIR/${baseline_name}.json"
    fi

    # Calculate regression thresholds
    # Warning: 23% increase from baseline
    # Critical: 54% increase from baseline
    local rule_warning=$((rule_count + (rule_count * 23 / 100)))
    local rule_critical=$((rule_count + (rule_count * 54 / 100)))

    local lines_warning=$((total_lines + (total_lines * 23 / 100)))
    local lines_critical=$((total_lines + (total_lines * 54 / 100)))

    local inst_warning=$((instruction_count + (instruction_count * 23 / 100)))
    local inst_critical=$((instruction_count + (instruction_count * 54 / 100)))

    # Create baseline JSON
    cat > "$baseline_file" << JSON
{
  "measured_at": "$date",
  "description": "$description",
  "calibrated": $calibrated,
  "rule_count": $rule_count,
  "total_lines": $total_lines,
  "instruction_count": $instruction_count,
  "files": $files_json,
  "regression_thresholds": {
    "rule_count": {
      "warning": $rule_warning,
      "critical": $rule_critical
    },
    "total_lines": {
      "warning": $lines_warning,
      "critical": $lines_critical
    },
    "instruction_count": {
      "warning": $inst_warning,
      "critical": $inst_critical
    }
  }
}
JSON

    success "Baseline created: $baseline_name"
    echo ""
    echo "  File:         $baseline_file"
    echo "  Rule Count:   $rule_count"
    echo "  Total Lines:  $total_lines"
    echo "  Instructions: $instruction_count"
    echo "  Calibrated:   $calibrated"
    echo ""

    if [ "$calibrated" = false ]; then
        warning "Baseline not calibrated - wait 1 week before setting as active"
        echo ""
        echo "  Calibration checklist:"
        echo "    1. Run regression checks daily for 1 week"
        echo "    2. Verify no unexpected threshold violations"
        echo "    3. Recreate with --calibrated flag if stable"
        echo "    4. Set as active: haunt-baseline set-active $baseline_name"
    else
        info "Baseline calibrated - ready to set as active"
        echo ""
        echo "  Set as active: haunt-baseline set-active $baseline_name"
    fi

    echo ""
}

# List all baselines
cmd_list() {
    local format="text"

    # Parse format option
    for arg in "$@"; do
        case $arg in
            --format=*)
                format="${arg#*=}"
                ;;
        esac
    done

    # Check if baselines directory exists and has files
    if [ ! -d "$BASELINES_DIR" ] || [ -z "$(ls -A "$BASELINES_DIR" 2>/dev/null)" ]; then
        if [ "$format" = "json" ]; then
            echo '{"baselines":[]}'
        else
            warning "No baselines found"
            echo ""
            echo "Create a baseline with: haunt-baseline create \"description\""
        fi
        return 0
    fi

    # Get active baseline name (if symlink exists)
    local active_name=""
    if [ -L "$ACTIVE_BASELINE" ]; then
        active_name=$(basename "$(readlink "$ACTIVE_BASELINE")" .json)
    fi

    if [ "$format" = "json" ]; then
        # JSON output
        echo '{"baselines":['
        local first=true
        for baseline in "$BASELINES_DIR"/*.json; do
            if [ -f "$baseline" ]; then
                local name=$(basename "$baseline" .json)
                local is_active=false
                if [ "$name" = "$active_name" ]; then
                    is_active=true
                fi

                local date=$(jq -r '.measured_at // "unknown"' "$baseline")
                local desc=$(jq -r '.description // "No description"' "$baseline")
                local calibrated=$(jq -r '.calibrated // false' "$baseline")
                local rule_count=$(jq -r '.rule_count // 0' "$baseline")
                local total_lines=$(jq -r '.total_lines // 0' "$baseline")
                local inst_count=$(jq -r '.instruction_count // 0' "$baseline")

                if [ "$first" = true ]; then
                    first=false
                else
                    echo ","
                fi

                cat << JSON_ENTRY
  {
    "name": "$name",
    "date": "$date",
    "description": "$desc",
    "calibrated": $calibrated,
    "active": $is_active,
    "metrics": {
      "rule_count": $rule_count,
      "total_lines": $total_lines,
      "instruction_count": $inst_count
    }
  }
JSON_ENTRY
            fi
        done
        echo ']}'
    else
        # Text output
        section "Available Baselines"
        echo ""

        printf "%-25s %-12s %-10s %-10s %s\n" "NAME" "DATE" "CALIBRATED" "ACTIVE" "DESCRIPTION"
        printf "%-25s %-12s %-10s %-10s %s\n" "----" "----" "----------" "------" "-----------"

        for baseline in "$BASELINES_DIR"/*.json; do
            if [ -f "$baseline" ]; then
                local name=$(basename "$baseline" .json)
                local date=$(jq -r '.measured_at // "unknown"' "$baseline")
                local desc=$(jq -r '.description // "No description"' "$baseline")
                local calibrated=$(jq -r '.calibrated // false' "$baseline")

                local is_active="No"
                if [ "$name" = "$active_name" ]; then
                    is_active="Yes"
                fi

                local cal_display="No"
                if [ "$calibrated" = "true" ]; then
                    cal_display="Yes"
                fi

                printf "%-25s %-12s %-10s %-10s %s\n" "$name" "$date" "$cal_display" "$is_active" "$desc"
            fi
        done

        echo ""

        if [ -n "$active_name" ]; then
            info "Active baseline: $active_name"
        else
            warning "No active baseline set"
        fi

        echo ""
    fi
}

# Show baseline details
cmd_show() {
    local baseline_name="$1"

    if [ -z "$baseline_name" ]; then
        error "Baseline name is required"
        echo ""
        echo "Usage: haunt-baseline show <baseline-name>"
        exit 1
    fi

    local baseline_file="$BASELINES_DIR/${baseline_name}.json"

    if [ ! -f "$baseline_file" ]; then
        error "Baseline not found: $baseline_name"
        exit 1
    fi

    section "Baseline Details: $baseline_name"
    echo ""

    # Extract metadata
    local date=$(jq -r '.measured_at // "unknown"' "$baseline_file")
    local desc=$(jq -r '.description // "No description"' "$baseline_file")
    local calibrated=$(jq -r '.calibrated // false' "$baseline_file")

    # Extract metrics
    local rule_count=$(jq -r '.rule_count // 0' "$baseline_file")
    local total_lines=$(jq -r '.total_lines // 0' "$baseline_file")
    local inst_count=$(jq -r '.instruction_count // 0' "$baseline_file")

    # Extract thresholds
    local rule_warn=$(jq -r '.regression_thresholds.rule_count.warning // 0' "$baseline_file")
    local rule_crit=$(jq -r '.regression_thresholds.rule_count.critical // 0' "$baseline_file")
    local lines_warn=$(jq -r '.regression_thresholds.total_lines.warning // 0' "$baseline_file")
    local lines_crit=$(jq -r '.regression_thresholds.total_lines.critical // 0' "$baseline_file")
    local inst_warn=$(jq -r '.regression_thresholds.instruction_count.warning // 0' "$baseline_file")
    local inst_crit=$(jq -r '.regression_thresholds.instruction_count.critical // 0' "$baseline_file")

    # Display metadata
    echo "  Date:        $date"
    echo "  Description: $desc"
    echo "  Calibrated:  $calibrated"
    echo ""

    # Display metrics
    echo "  Metrics:"
    echo "    Rule Count:       $rule_count"
    echo "    Total Lines:      $total_lines"
    echo "    Instruction Count: $inst_count"
    echo ""

    # Display thresholds
    echo "  Regression Thresholds:"
    echo "    Rule Count:       ⚠️  $rule_warn, 🚨 $rule_crit"
    echo "    Total Lines:      ⚠️  $lines_warn, 🚨 $lines_crit"
    echo "    Instruction Count: ⚠️  $inst_warn, 🚨 $inst_crit"
    echo ""

    # Display file breakdown
    echo "  File Breakdown:"
    jq -r '.files | to_entries[] | "    \(.key): \(.value.lines) lines, \(.value.instructions) instructions"' "$baseline_file"
    echo ""
}

# Set active baseline
cmd_set_active() {
    local baseline_name="$1"

    if [ -z "$baseline_name" ]; then
        error "Baseline name is required"
        echo ""
        echo "Usage: haunt-baseline set-active <baseline-name>"
        exit 1
    fi

    local baseline_file="$BASELINES_DIR/${baseline_name}.json"

    if [ ! -f "$baseline_file" ]; then
        error "Baseline not found: $baseline_name"
        exit 1
    fi

    # Check if baseline is calibrated
    local calibrated=$(jq -r '.calibrated // false' "$baseline_file")

    if [ "$calibrated" = "false" ]; then
        warning "Baseline is not calibrated"
        echo ""
        echo "  It is recommended to calibrate baselines over 1 week before setting as active."
        echo ""
        read -p "  Set as active anyway? [y/N] " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            info "Cancelled"
            exit 0
        fi
    fi

    # Remove existing symlink if it exists
    if [ -L "$ACTIVE_BASELINE" ] || [ -f "$ACTIVE_BASELINE" ]; then
        rm -f "$ACTIVE_BASELINE"
    fi

    # Create symlink to new active baseline
    ln -s "$baseline_file" "$ACTIVE_BASELINE"

    success "Active baseline set: $baseline_name"
    echo ""
    echo "  Regression checks will now use this baseline"
    echo "  Run: bash Haunt/scripts/haunt-regression-check.sh"
    echo ""
}

# Main command dispatcher
main() {
    if [ $# -eq 0 ]; then
        error "No command specified"
        echo ""
        show_help
        exit 1
    fi

    local command="$1"
    shift

    validate_environment

    case "$command" in
        create)
            cmd_create "$@"
            ;;
        list)
            cmd_list "$@"
            ;;
        show)
            cmd_show "$@"
            ;;
        set-active)
            cmd_set_active "$@"
            ;;
        --help|-h|help)
            show_help
            ;;
        *)
            error "Unknown command: $command"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

main "$@"
