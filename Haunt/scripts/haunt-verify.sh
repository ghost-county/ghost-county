#!/usr/bin/env bash
#
# haunt-verify.sh - Completion Verification Script
#
# Purpose: Programmatically verify requirement completion criteria before
#          marking requirements 🟢 Complete. Returns JSON with pass/fail
#          for each verification criterion.
#
# Usage:
#   haunt-verify REQ-XXX [agent-type]
#   haunt-verify REQ-XXX frontend
#   haunt-verify REQ-XXX backend
#   haunt-verify REQ-XXX infrastructure
#
# Output: JSON with verification results
# {
#   "success": true,
#   "requirement": "REQ-XXX",
#   "summary": "5/5 criteria passed",
#   "criteria": [
#     {"name": "tasks_complete", "status": "PASS", "evidence": "10/10 tasks checked"},
#     {"name": "files_exist", "status": "PASS", "evidence": "All 3 files exist"},
#     {"name": "tests_pass", "status": "PASS", "evidence": "23/23 tests passed"},
#     {"name": "coverage", "status": "PASS", "evidence": "87% coverage"},
#     {"name": "lint", "status": "PASS", "evidence": "0 errors"}
#   ]
# }

set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

# ============================================================================
# CONFIGURATION
# ============================================================================

readonly SCRIPT_NAME="haunt-verify"
readonly VERSION="1.0.0"

# Paths
readonly DEFAULT_ROADMAP=".haunt/plans/roadmap.md"
readonly HAUNT_ROADMAP_CMD="bash Haunt/scripts/haunt-roadmap.sh"
readonly HAUNT_RUN_CMD="bash Haunt/scripts/haunt-run.sh"

# ============================================================================
# ERROR HANDLING
# ============================================================================

error() {
    cat <<EOF
{
  "success": false,
  "error": "$1"
}
EOF
    exit "${2:-1}"
}

# ============================================================================
# ROADMAP UTILITIES
# ============================================================================

find_roadmap() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/$DEFAULT_ROADMAP" ]]; then
            echo "$dir/$DEFAULT_ROADMAP"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    error "Roadmap not found: $DEFAULT_ROADMAP (searched up from $PWD)" 2
}

get_requirement() {
    local req_id="$1"
    local roadmap_file
    roadmap_file=$(find_roadmap)

    # Extract requirement block using grep (fallback if haunt-roadmap unavailable)
    local start_line
    start_line=$(grep -n "^### [⚪🟡🟢🔴] $req_id:" "$roadmap_file" | cut -d: -f1 | head -1)

    if [[ -z "$start_line" ]]; then
        return 1
    fi

    # Extract block until next ### or ---
    local end_line
    end_line=$(tail -n +$((start_line + 1)) "$roadmap_file" | grep -n "^###\|^---" | head -1 | cut -d: -f1)

    if [[ -n "$end_line" ]]; then
        end_line=$((start_line + end_line - 1))
    else
        end_line=$(wc -l < "$roadmap_file" | tr -d ' ')
    fi

    sed -n "${start_line},${end_line}p" "$roadmap_file"
}

# ============================================================================
# VERIFICATION CRITERIA
# ============================================================================

verify_tasks_complete() {
    local req_block="$1"

    # Count total tasks and checked tasks
    local total_tasks
    total_tasks=$(echo "$req_block" | grep -c "^- \[" 2>/dev/null || echo "0")
    total_tasks=$(echo "$total_tasks" | tr -d '\n\r ')

    local checked_tasks
    checked_tasks=$(echo "$req_block" | grep -c "^- \[x\]" 2>/dev/null || echo "0")
    checked_tasks=$(echo "$checked_tasks" | tr -d '\n\r ')

    # Handle case where grep -c returns 0
    [[ -z "$total_tasks" ]] && total_tasks=0
    [[ -z "$checked_tasks" ]] && checked_tasks=0

    local status="PASS"
    if [[ $total_tasks -eq 0 ]]; then
        status="SKIP"
        echo "SKIP|No tasks defined in requirement"
        return 0
    fi

    if (( checked_tasks < total_tasks )); then
        status="FAIL"
        local remaining=$((total_tasks - checked_tasks))
        echo "FAIL|${checked_tasks}/${total_tasks} tasks checked (${remaining} remaining)"
        return 1
    fi

    echo "PASS|${checked_tasks}/${total_tasks} tasks checked"
}

verify_files_exist() {
    local req_block="$1"

    # Extract files from **Files:** section
    local files=()
    local in_files_section=false
    while IFS= read -r line; do
        if [[ "$line" =~ ^\*\*Files:\*\*$ ]]; then
            in_files_section=true
            continue
        fi

        # Exit section if we hit another ** field
        if [[ "$in_files_section" == true ]] && [[ "$line" =~ ^\*\* ]]; then
            break
        fi

        # Extract file paths (format: - `path/to/file` (action))
        if [[ "$in_files_section" == true ]] && [[ "$line" =~ ^-\ \`([^\`]+)\` ]]; then
            local file_path="${BASH_REMATCH[1]}"
            files+=("$file_path")
        fi
    done <<< "$req_block"

    if [[ ${#files[@]} -eq 0 ]]; then
        echo "SKIP|No files listed in requirement"
        return 0
    fi

    # Check if each file exists
    local missing_files=()
    for file in "${files[@]}"; do
        if [[ ! -e "$file" ]]; then
            missing_files+=("$file")
        fi
    done

    if [[ ${#missing_files[@]} -gt 0 ]]; then
        local missing_list=$(IFS=, ; echo "${missing_files[*]}")
        echo "FAIL|${#missing_files[@]}/${#files[@]} files missing: $missing_list"
        return 1
    fi

    echo "PASS|All ${#files[@]} files exist"
}

verify_tests_pass() {
    local agent_type="${1:-unknown}"

    # Detect test framework and run tests via haunt-run
    if ! command -v bash &> /dev/null; then
        echo "SKIP|bash not available"
        return 0
    fi

    # Check if haunt-run.sh exists
    if [[ ! -f "Haunt/scripts/haunt-run.sh" ]]; then
        echo "SKIP|haunt-run.sh not found"
        return 0
    fi

    # Run tests and capture JSON output
    local test_output
    test_output=$($HAUNT_RUN_CMD test 2>&1)
    local exit_code=$?

    # Parse JSON output
    local success
    success=$(echo "$test_output" | grep -o '"success": *[^,}]*' | cut -d: -f2 | tr -d ' "' || echo "false")

    if [[ "$success" != "true" ]]; then
        # Extract failure info
        local failed
        failed=$(echo "$test_output" | grep -o '"failed": *[0-9]*' | cut -d: -f2 | tr -d ' ' || echo "unknown")

        local framework
        framework=$(echo "$test_output" | grep -o '"framework": *"[^"]*"' | cut -d'"' -f4 || echo "unknown")

        echo "FAIL|Tests failed: $failed failures ($framework)"
        return 1
    fi

    # Extract pass count
    local passed
    passed=$(echo "$test_output" | grep -o '"passed": *[0-9]*' | cut -d: -f2 | tr -d ' ' || echo "0")

    local framework
    framework=$(echo "$test_output" | grep -o '"framework": *"[^"]*"' | cut -d'"' -f4 || echo "unknown")

    echo "PASS|${passed} tests passed ($framework)"
}

verify_coverage() {
    # Check if haunt-run.sh exists
    if [[ ! -f "Haunt/scripts/haunt-run.sh" ]]; then
        echo "SKIP|haunt-run.sh not found"
        return 0
    fi

    # Run tests with coverage and capture JSON output
    local test_output
    test_output=$($HAUNT_RUN_CMD test 2>&1)

    # Parse coverage from JSON
    local coverage
    coverage=$(echo "$test_output" | grep -o '"coverage_percent": *[0-9.]*' | cut -d: -f2 | tr -d ' ' || echo "0.0")

    if [[ "$coverage" == "0.0" ]]; then
        echo "SKIP|No coverage data available"
        return 0
    fi

    # Check if coverage meets threshold (80% minimum for new code)
    local threshold=80
    if (( $(echo "$coverage < $threshold" | bc -l) )); then
        echo "FAIL|Coverage ${coverage}% below ${threshold}% threshold"
        return 1
    fi

    echo "PASS|${coverage}% coverage"
}

verify_lint() {
    # Check if haunt-run.sh exists
    if [[ ! -f "Haunt/scripts/haunt-run.sh" ]]; then
        echo "SKIP|haunt-run.sh not found"
        return 0
    fi

    # Run lint and capture JSON output
    local lint_output
    lint_output=$($HAUNT_RUN_CMD lint 2>&1)
    local exit_code=$?

    # Check if lint framework detected
    if echo "$lint_output" | grep -q '"framework": "unknown"'; then
        echo "SKIP|No linter configured"
        return 0
    fi

    # Parse JSON output
    local success
    success=$(echo "$lint_output" | grep -o '"success": *[^,}]*' | cut -d: -f2 | tr -d ' "' || echo "false")

    if [[ "$success" != "true" ]]; then
        # Extract issue count
        local issues
        issues=$(echo "$lint_output" | grep -o '"issues": *[0-9]*' | cut -d: -f2 | tr -d ' ' || echo "unknown")

        local framework
        framework=$(echo "$lint_output" | grep -o '"framework": *"[^"]*"' | cut -d'"' -f4 || echo "unknown")

        echo "FAIL|${issues} lint errors ($framework)"
        return 1
    fi

    local framework
    framework=$(echo "$lint_output" | grep -o '"framework": *"[^"]*"' | cut -d'"' -f4 || echo "unknown")

    echo "PASS|0 lint errors ($framework)"
}

# ============================================================================
# JSON OUTPUT
# ============================================================================

escape_json() {
    local input="$1"
    # Escape backslashes first
    input="${input//\\/\\\\}"
    # Escape double quotes
    input="${input//\"/\\\"}"
    # Escape newlines
    input="${input//$'\n'/\\n}"
    # Escape tabs
    input="${input//$'\t'/\\t}"
    echo "$input"
}

build_criterion_json() {
    local name="$1"
    local status="$2"
    local evidence="$3"

    evidence=$(escape_json "$evidence")

    cat <<EOF
    {
      "name": "$name",
      "status": "$status",
      "evidence": "$evidence"
    }
EOF
}

# ============================================================================
# MAIN VERIFICATION
# ============================================================================

run_verification() {
    local req_id="$1"
    local agent_type="${2:-unknown}"

    # Validate REQ-XXX format
    if [[ ! "$req_id" =~ ^REQ-[0-9]+$ ]]; then
        error "Invalid requirement ID format: $req_id (expected REQ-XXX)"
    fi

    # Get requirement block
    local req_block
    req_block=$(get_requirement "$req_id")
    if [[ -z "$req_block" ]]; then
        error "Requirement $req_id not found in roadmap"
    fi

    # Run all verification criteria
    local criteria=()
    local passed=0
    local total=0

    # 1. Tasks complete
    local result
    result=$(verify_tasks_complete "$req_block")
    local status="${result%%|*}"
    local evidence="${result#*|}"

    if [[ "$status" != "SKIP" ]]; then
        criteria+=("$(build_criterion_json "tasks_complete" "$status" "$evidence")")
        total=$((total + 1))
        [[ "$status" == "PASS" ]] && passed=$((passed + 1))
    fi

    # 2. Files exist
    result=$(verify_files_exist "$req_block")
    status="${result%%|*}"
    evidence="${result#*|}"

    if [[ "$status" != "SKIP" ]]; then
        criteria+=("$(build_criterion_json "files_exist" "$status" "$evidence")")
        total=$((total + 1))
        [[ "$status" == "PASS" ]] && passed=$((passed + 1))
    fi

    # 3. Tests pass
    result=$(verify_tests_pass "$agent_type")
    status="${result%%|*}"
    evidence="${result#*|}"

    if [[ "$status" != "SKIP" ]]; then
        criteria+=("$(build_criterion_json "tests_pass" "$status" "$evidence")")
        total=$((total + 1))
        [[ "$status" == "PASS" ]] && passed=$((passed + 1))
    fi

    # 4. Coverage threshold
    result=$(verify_coverage)
    status="${result%%|*}"
    evidence="${result#*|}"

    if [[ "$status" != "SKIP" ]]; then
        criteria+=("$(build_criterion_json "coverage" "$status" "$evidence")")
        total=$((total + 1))
        [[ "$status" == "PASS" ]] && passed=$((passed + 1))
    fi

    # 5. Lint passes
    result=$(verify_lint)
    status="${result%%|*}"
    evidence="${result#*|}"

    if [[ "$status" != "SKIP" ]]; then
        criteria+=("$(build_criterion_json "lint" "$status" "$evidence")")
        total=$((total + 1))
        [[ "$status" == "PASS" ]] && passed=$((passed + 1))
    fi

    # Determine overall success
    local overall_success="false"
    if [[ $passed -eq $total ]] && [[ $total -gt 0 ]]; then
        overall_success="true"
    fi

    # Build JSON output
    local criteria_json=""
    if [[ ${#criteria[@]} -gt 0 ]]; then
        criteria_json=$(IFS=,; echo "${criteria[*]}")
    fi

    cat <<EOF
{
  "success": $overall_success,
  "requirement": "$req_id",
  "summary": "${passed}/${total} criteria passed",
  "criteria": [
$criteria_json
  ]
}
EOF
}

# ============================================================================
# HELP TEXT
# ============================================================================

show_help() {
    cat <<EOF
$SCRIPT_NAME - Completion Verification Script

USAGE:
    $SCRIPT_NAME <REQ-XXX> [agent-type]

ARGUMENTS:
    REQ-XXX        Requirement ID to verify
    agent-type     Optional: frontend, backend, infrastructure (for agent-specific checks)

VERIFICATION CRITERIA:
    1. tasks_complete    All task checkboxes marked [x]
    2. files_exist       All files listed in **Files:** section exist
    3. tests_pass        Test suite passes (via haunt-run test)
    4. coverage          Coverage meets 80% threshold (if available)
    5. lint              Linter passes with 0 errors (if available)

EXAMPLES:
    # Verify requirement completion
    $SCRIPT_NAME REQ-280

    # Verify with agent type context
    $SCRIPT_NAME REQ-280 frontend
    $SCRIPT_NAME REQ-280 backend

OUTPUT FORMAT:
    {
      "success": true,
      "requirement": "REQ-280",
      "summary": "5/5 criteria passed",
      "criteria": [
        {"name": "tasks_complete", "status": "PASS", "evidence": "10/10 tasks checked"},
        {"name": "files_exist", "status": "PASS", "evidence": "All 3 files exist"},
        {"name": "tests_pass", "status": "PASS", "evidence": "23/23 tests passed"},
        {"name": "coverage", "status": "PASS", "evidence": "87% coverage"},
        {"name": "lint", "status": "PASS", "evidence": "0 errors"}
      ]
    }

STATUS VALUES:
    PASS    Criterion met
    FAIL    Criterion not met (blocks 🟢 completion)
    SKIP    Criterion not applicable (doesn't block completion)

VERSION:
    $VERSION
EOF
}

# ============================================================================
# MAIN DISPATCH
# ============================================================================

main() {
    if [[ $# -eq 0 ]] || [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        show_help
        exit 0
    fi

    if [[ "$1" == "--version" ]] || [[ "$1" == "-v" ]]; then
        echo "$SCRIPT_NAME version $VERSION"
        exit 0
    fi

    local req_id="$1"
    local agent_type="${2:-unknown}"

    run_verification "$req_id" "$agent_type"
}

main "$@"
