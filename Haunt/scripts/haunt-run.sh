#!/usr/bin/env bash
#
# haunt-run - Structured Build/Test Execution Wrapper
#
# Purpose: Execute test, build, or lint commands with framework auto-detection
#          and return structured JSON results for consistent parsing.
#
# Usage:
#   haunt-run test [--raw]
#   haunt-run build [--raw]
#   haunt-run lint [--raw]
#
# Output: JSON with consistent schema regardless of underlying tool
# {
#   "success": true,
#   "framework": "pytest",
#   "passed": 12,
#   "failed": 0,
#   "skipped": 1,
#   "errors": 0,
#   "duration_seconds": 4.2,
#   "failures": [],
#   "coverage_percent": 85.2
# }

set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

# ============================================================================
# CONFIGURATION
# ============================================================================

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly WORK_DIR="$(pwd)"

# Temporary file for capturing raw output
readonly TEMP_OUTPUT="/tmp/haunt-run-$$.log"

# Raw mode (passthrough original output)
RAW_MODE=false

# ============================================================================
# FRAMEWORK DETECTION
# ============================================================================

detect_test_framework() {
    # Python: pytest
    if [[ -f "pyproject.toml" ]] || [[ -f "pytest.ini" ]] || [[ -d "tests/" ]]; then
        if command -v pytest &> /dev/null; then
            echo "pytest"
            return 0
        fi
    fi

    # Node: npm test
    if [[ -f "package.json" ]]; then
        if command -v npm &> /dev/null; then
            echo "npm"
            return 0
        fi
    fi

    # Go: go test
    if [[ -f "go.mod" ]] || ls *.go &> /dev/null; then
        if command -v go &> /dev/null; then
            echo "go"
            return 0
        fi
    fi

    echo "unknown"
    return 1
}

detect_build_framework() {
    # Node: npm build
    if [[ -f "package.json" ]]; then
        if grep -q '"build"' package.json 2>/dev/null; then
            echo "npm"
            return 0
        fi
    fi

    # Go: go build
    if [[ -f "go.mod" ]] || ls *.go &> /dev/null; then
        echo "go"
        return 0
    fi

    # Make: Makefile
    if [[ -f "Makefile" ]] || [[ -f "makefile" ]]; then
        echo "make"
        return 0
    fi

    echo "unknown"
    return 1
}

detect_lint_framework() {
    # Python: ruff
    if [[ -f "pyproject.toml" ]] && grep -q "ruff" pyproject.toml 2>/dev/null; then
        if command -v ruff &> /dev/null; then
            echo "ruff"
            return 0
        fi
    fi

    # Node: eslint
    if [[ -f "package.json" ]] && grep -q "eslint" package.json 2>/dev/null; then
        if command -v npx &> /dev/null; then
            echo "eslint"
            return 0
        fi
    fi

    # Go: golangci-lint
    if [[ -f "go.mod" ]]; then
        if command -v golangci-lint &> /dev/null; then
            echo "golangci-lint"
            return 0
        fi
    fi

    echo "unknown"
    return 1
}

# ============================================================================
# TEST PARSERS
# ============================================================================

parse_pytest_output() {
    local output_file="$1"
    local exit_code="$2"

    # Extract test counts from pytest output
    # Example: "5 passed, 1 failed, 2 skipped in 4.2s"
    local passed=0
    local failed=0
    local skipped=0
    local errors=0
    local duration=0.0
    local coverage=0.0

    # Parse summary line
    if grep -q "passed" "$output_file"; then
        passed=$(grep -oE '[0-9]+ passed' "$output_file" | grep -oE '[0-9]+' | head -1 || echo "0")
    fi

    if grep -q "failed" "$output_file"; then
        failed=$(grep -oE '[0-9]+ failed' "$output_file" | grep -oE '[0-9]+' | head -1 || echo "0")
    fi

    if grep -q "skipped" "$output_file"; then
        skipped=$(grep -oE '[0-9]+ skipped' "$output_file" | grep -oE '[0-9]+' | head -1 || echo "0")
    fi

    if grep -q "error" "$output_file"; then
        errors=$(grep -oE '[0-9]+ error' "$output_file" | grep -oE '[0-9]+' | head -1 || echo "0")
    fi

    # Parse duration
    if grep -qE 'in [0-9]+\.[0-9]+s' "$output_file"; then
        duration=$(grep -oE 'in [0-9]+\.[0-9]+s' "$output_file" | grep -oE '[0-9]+\.[0-9]+' | head -1 || echo "0.0")
    fi

    # Parse coverage percentage (if present)
    if grep -q "TOTAL" "$output_file"; then
        coverage=$(grep "TOTAL" "$output_file" | awk '{print $NF}' | tr -d '%' || echo "0.0")
    fi

    # Extract failure details
    local failures="[]"
    if [[ $failed -gt 0 ]]; then
        # Extract FAILED test names
        failures=$(grep "FAILED" "$output_file" | sed 's/FAILED //' | jq -R -s -c 'split("\n") | map(select(length > 0))')
    fi

    # Determine success
    local success="false"
    if [[ $exit_code -eq 0 ]] && [[ $failed -eq 0 ]] && [[ $errors -eq 0 ]]; then
        success="true"
    fi

    # Output JSON
    cat <<EOF
{
  "success": $success,
  "framework": "pytest",
  "passed": $passed,
  "failed": $failed,
  "skipped": $skipped,
  "errors": $errors,
  "duration_seconds": $duration,
  "failures": $failures,
  "coverage_percent": $coverage
}
EOF
}

parse_npm_test_output() {
    local output_file="$1"
    local exit_code="$2"

    local passed=0
    local failed=0
    local skipped=0
    local errors=0
    local duration=0.0

    # Parse Jest/Vitest output
    # Example: "Tests: 1 failed, 5 passed, 6 total"
    if grep -q "Tests:" "$output_file"; then
        if grep -q "passed" "$output_file"; then
            passed=$(grep -oE '[0-9]+ passed' "$output_file" | grep -oE '[0-9]+' | head -1 || echo "0")
        fi

        if grep -q "failed" "$output_file"; then
            failed=$(grep -oE '[0-9]+ failed' "$output_file" | grep -oE '[0-9]+' | head -1 || echo "0")
        fi

        if grep -q "skipped" "$output_file"; then
            skipped=$(grep -oE '[0-9]+ skipped' "$output_file" | grep -oE '[0-9]+' | head -1 || echo "0")
        fi
    fi

    # Parse duration (Jest: "Time: 4.2s")
    if grep -qE 'Time:.*[0-9]+\.[0-9]+s' "$output_file"; then
        duration=$(grep -oE 'Time:.*[0-9]+\.[0-9]+s' "$output_file" | grep -oE '[0-9]+\.[0-9]+' | head -1 || echo "0.0")
    fi

    # Extract failure details
    local failures="[]"
    if [[ $failed -gt 0 ]]; then
        failures=$(grep "FAIL" "$output_file" | jq -R -s -c 'split("\n") | map(select(length > 0))')
    fi

    local success="false"
    if [[ $exit_code -eq 0 ]] && [[ $failed -eq 0 ]]; then
        success="true"
    fi

    cat <<EOF
{
  "success": $success,
  "framework": "npm",
  "passed": $passed,
  "failed": $failed,
  "skipped": $skipped,
  "errors": $errors,
  "duration_seconds": $duration,
  "failures": $failures,
  "coverage_percent": 0.0
}
EOF
}

parse_go_test_output() {
    local output_file="$1"
    local exit_code="$2"

    local passed=0
    local failed=0
    local skipped=0
    local errors=0
    local duration=0.0

    # Count PASS and FAIL lines
    passed=$(grep -c "^PASS" "$output_file" || echo "0")
    failed=$(grep -c "^FAIL" "$output_file" || echo "0")
    skipped=$(grep -c "^SKIP" "$output_file" || echo "0")

    # Extract failures
    local failures="[]"
    if [[ $failed -gt 0 ]]; then
        failures=$(grep "^FAIL" "$output_file" | jq -R -s -c 'split("\n") | map(select(length > 0))')
    fi

    local success="false"
    if [[ $exit_code -eq 0 ]] && [[ $failed -eq 0 ]]; then
        success="true"
    fi

    cat <<EOF
{
  "success": $success,
  "framework": "go",
  "passed": $passed,
  "failed": $failed,
  "skipped": $skipped,
  "errors": $errors,
  "duration_seconds": $duration,
  "failures": $failures,
  "coverage_percent": 0.0
}
EOF
}

# ============================================================================
# BUILD PARSERS
# ============================================================================

parse_npm_build_output() {
    local output_file="$1"
    local exit_code="$2"

    local success="false"
    if [[ $exit_code -eq 0 ]]; then
        success="true"
    fi

    local errors=0
    if grep -q "error" "$output_file"; then
        errors=$(grep -c "error" "$output_file" || echo "0")
    fi

    cat <<EOF
{
  "success": $success,
  "framework": "npm",
  "errors": $errors,
  "exit_code": $exit_code
}
EOF
}

parse_go_build_output() {
    local output_file="$1"
    local exit_code="$2"

    local success="false"
    if [[ $exit_code -eq 0 ]]; then
        success="true"
    fi

    local errors=0
    if [[ -s "$output_file" ]]; then
        # Go build errors go to stderr, count lines
        errors=$(wc -l < "$output_file" | tr -d ' ')
    fi

    cat <<EOF
{
  "success": $success,
  "framework": "go",
  "errors": $errors,
  "exit_code": $exit_code
}
EOF
}

parse_make_build_output() {
    local output_file="$1"
    local exit_code="$2"

    local success="false"
    if [[ $exit_code -eq 0 ]]; then
        success="true"
    fi

    local errors=0
    if grep -q "error" "$output_file"; then
        errors=$(grep -c "error" "$output_file" || echo "0")
    fi

    cat <<EOF
{
  "success": $success,
  "framework": "make",
  "errors": $errors,
  "exit_code": $exit_code
}
EOF
}

# ============================================================================
# LINT PARSERS
# ============================================================================

parse_ruff_output() {
    local output_file="$1"
    local exit_code="$2"

    local success="false"
    if [[ $exit_code -eq 0 ]]; then
        success="true"
    fi

    local issues=0
    # Ruff outputs one line per issue
    if [[ -s "$output_file" ]]; then
        issues=$(grep -c "^" "$output_file" || echo "0")
    fi

    cat <<EOF
{
  "success": $success,
  "framework": "ruff",
  "issues": $issues,
  "exit_code": $exit_code
}
EOF
}

parse_eslint_output() {
    local output_file="$1"
    local exit_code="$2"

    local success="false"
    if [[ $exit_code -eq 0 ]]; then
        success="true"
    fi

    local issues=0
    if grep -q "problem" "$output_file"; then
        issues=$(grep -oE '[0-9]+ problems?' "$output_file" | grep -oE '[0-9]+' | head -1 || echo "0")
    fi

    cat <<EOF
{
  "success": $success,
  "framework": "eslint",
  "issues": $issues,
  "exit_code": $exit_code
}
EOF
}

parse_golangci_lint_output() {
    local output_file="$1"
    local exit_code="$2"

    local success="false"
    if [[ $exit_code -eq 0 ]]; then
        success="true"
    fi

    local issues=0
    if [[ -s "$output_file" ]]; then
        issues=$(grep -c "^" "$output_file" || echo "0")
    fi

    cat <<EOF
{
  "success": $success,
  "framework": "golangci-lint",
  "issues": $issues,
  "exit_code": $exit_code
}
EOF
}

# ============================================================================
# COMMAND EXECUTION
# ============================================================================

run_test() {
    local framework
    framework=$(detect_test_framework)

    if [[ "$framework" == "unknown" ]]; then
        cat <<EOF
{
  "success": false,
  "framework": "unknown",
  "error": "Could not detect test framework (pytest, npm, or go)"
}
EOF
        return 1
    fi

    local exit_code=0

    case "$framework" in
        pytest)
            pytest --tb=short -v 2>&1 | tee "$TEMP_OUTPUT" || exit_code=$?
            if [[ "$RAW_MODE" == false ]]; then
                parse_pytest_output "$TEMP_OUTPUT" "$exit_code"
            fi
            ;;
        npm)
            npm test 2>&1 | tee "$TEMP_OUTPUT" || exit_code=$?
            if [[ "$RAW_MODE" == false ]]; then
                parse_npm_test_output "$TEMP_OUTPUT" "$exit_code"
            fi
            ;;
        go)
            go test ./... -v 2>&1 | tee "$TEMP_OUTPUT" || exit_code=$?
            if [[ "$RAW_MODE" == false ]]; then
                parse_go_test_output "$TEMP_OUTPUT" "$exit_code"
            fi
            ;;
    esac

    return $exit_code
}

run_build() {
    local framework
    framework=$(detect_build_framework)

    if [[ "$framework" == "unknown" ]]; then
        cat <<EOF
{
  "success": false,
  "framework": "unknown",
  "error": "Could not detect build framework (npm, go, or make)"
}
EOF
        return 1
    fi

    local exit_code=0

    case "$framework" in
        npm)
            npm run build 2>&1 | tee "$TEMP_OUTPUT" || exit_code=$?
            if [[ "$RAW_MODE" == false ]]; then
                parse_npm_build_output "$TEMP_OUTPUT" "$exit_code"
            fi
            ;;
        go)
            go build ./... 2>&1 | tee "$TEMP_OUTPUT" || exit_code=$?
            if [[ "$RAW_MODE" == false ]]; then
                parse_go_build_output "$TEMP_OUTPUT" "$exit_code"
            fi
            ;;
        make)
            make 2>&1 | tee "$TEMP_OUTPUT" || exit_code=$?
            if [[ "$RAW_MODE" == false ]]; then
                parse_make_build_output "$TEMP_OUTPUT" "$exit_code"
            fi
            ;;
    esac

    return $exit_code
}

run_lint() {
    local framework
    framework=$(detect_lint_framework)

    if [[ "$framework" == "unknown" ]]; then
        cat <<EOF
{
  "success": false,
  "framework": "unknown",
  "error": "Could not detect lint framework (ruff, eslint, or golangci-lint)"
}
EOF
        return 1
    fi

    local exit_code=0

    case "$framework" in
        ruff)
            ruff check . 2>&1 | tee "$TEMP_OUTPUT" || exit_code=$?
            if [[ "$RAW_MODE" == false ]]; then
                parse_ruff_output "$TEMP_OUTPUT" "$exit_code"
            fi
            ;;
        eslint)
            npx eslint . 2>&1 | tee "$TEMP_OUTPUT" || exit_code=$?
            if [[ "$RAW_MODE" == false ]]; then
                parse_eslint_output "$TEMP_OUTPUT" "$exit_code"
            fi
            ;;
        golangci-lint)
            golangci-lint run 2>&1 | tee "$TEMP_OUTPUT" || exit_code=$?
            if [[ "$RAW_MODE" == false ]]; then
                parse_golangci_lint_output "$TEMP_OUTPUT" "$exit_code"
            fi
            ;;
    esac

    return $exit_code
}

# ============================================================================
# ERROR HANDLING
# ============================================================================

cleanup() {
    rm -f "$TEMP_OUTPUT"
}

trap cleanup EXIT

# ============================================================================
# MAIN
# ============================================================================

usage() {
    cat <<EOF
Usage: haunt-run <command> [options]

Commands:
  test     Run tests with auto-detected framework (pytest, npm, go)
  build    Run build with auto-detected framework (npm, go, make)
  lint     Run linter with auto-detected framework (ruff, eslint, golangci-lint)

Options:
  --raw    Pass through original output without JSON parsing

Examples:
  haunt-run test              # Auto-detect and run tests, output JSON
  haunt-run test --raw        # Run tests, show original output
  haunt-run build             # Auto-detect and run build
  haunt-run lint              # Auto-detect and run linter

Output Format (non-raw):
  {
    "success": true,
    "framework": "pytest",
    "passed": 12,
    "failed": 0,
    "skipped": 1,
    "errors": 0,
    "duration_seconds": 4.2,
    "failures": [],
    "coverage_percent": 85.2
  }
EOF
}

main() {
    # Parse flags
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --raw)
                RAW_MODE=true
                shift
                ;;
            test|build|lint)
                local command="$1"
                shift
                break
                ;;
            --help|-h)
                usage
                exit 0
                ;;
            *)
                echo "Unknown option: $1" >&2
                usage
                exit 1
                ;;
        esac
    done

    # Execute command
    case "${command:-}" in
        test)
            run_test
            ;;
        build)
            run_build
            ;;
        lint)
            run_lint
            ;;
        "")
            echo "Error: No command specified" >&2
            usage
            exit 1
            ;;
        *)
            echo "Error: Unknown command: $command" >&2
            usage
            exit 1
            ;;
    esac
}

main "$@"
