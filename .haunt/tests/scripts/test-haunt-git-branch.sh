#!/usr/bin/env bash
#
# test-haunt-git-branch.sh - Tests for haunt-git branch commands
#
# Tests all branch management commands in haunt-git.sh:
# - branch-current: Get current branch name
# - branch-list: List all branches with REQ associations
# - branch-create: Create feature branches
# - branch-for-req: Find branch for requirement
# - branch-delete: Safely delete merged branches

set -e
set -u
set -o pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script locations
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
HAUNT_GIT="$PROJECT_ROOT/Haunt/scripts/haunt-git.sh"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# ============================================================================
# TEST UTILITIES
# ============================================================================

# Print test result
test_result() {
    local test_name="$1"
    local status="$2"
    local message="${3:-}"

    TESTS_RUN=$((TESTS_RUN + 1))

    if [[ "$status" == "PASS" ]]; then
        echo -e "${GREEN}✓${NC} $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} $test_name"
        if [[ -n "$message" ]]; then
            echo -e "  ${RED}Error: $message${NC}"
        fi
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# Assert command succeeds
assert_success() {
    local test_name="$1"
    local command="$2"

    if eval "$command" &>/dev/null; then
        test_result "$test_name" "PASS"
        return 0
    else
        test_result "$test_name" "FAIL" "Command failed: $command"
        return 1
    fi
}

# Assert command fails
assert_failure() {
    local test_name="$1"
    local command="$2"

    if ! eval "$command" &>/dev/null; then
        test_result "$test_name" "PASS"
        return 0
    else
        test_result "$test_name" "FAIL" "Command should have failed: $command"
        return 1
    fi
}

# Assert JSON output contains field
assert_json_field() {
    local test_name="$1"
    local command="$2"
    local field="$3"
    local expected="${4:-}"

    local output
    output=$(eval "$command" 2>&1)

    if ! echo "$output" | grep -q "\"$field\""; then
        test_result "$test_name" "FAIL" "JSON missing field: $field"
        return 1
    fi

    if [[ -n "$expected" ]]; then
        if echo "$output" | grep -q "\"$field\": \"$expected\"" || echo "$output" | grep -q "\"$field\": $expected"; then
            test_result "$test_name" "PASS"
            return 0
        else
            test_result "$test_name" "FAIL" "Field $field expected: $expected"
            return 1
        fi
    else
        test_result "$test_name" "PASS"
        return 0
    fi
}

# ============================================================================
# SETUP AND TEARDOWN
# ============================================================================

# Setup test environment
setup() {
    echo -e "${YELLOW}Setting up test environment...${NC}"

    # Verify we're in a git repo
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo -e "${RED}Error: Not in a git repository${NC}"
        exit 1
    fi

    # Store original branch
    ORIGINAL_BRANCH=$(git rev-parse --abbrev-ref HEAD)

    # Ensure we're on main for tests
    if [[ "$ORIGINAL_BRANCH" != "main" ]]; then
        git checkout main &>/dev/null || {
            echo -e "${RED}Error: Could not checkout main branch${NC}"
            exit 1
        }
    fi

    # Clean up any test branches from previous runs
    git branch | grep "feature/REQ-888-" | xargs -r git branch -D &>/dev/null || true
    git branch | grep "feature/REQ-777-" | xargs -r git branch -D &>/dev/null || true
}

# Cleanup test environment
teardown() {
    echo -e "${YELLOW}Cleaning up test environment...${NC}"

    # Return to original branch
    if [[ -n "${ORIGINAL_BRANCH:-}" ]]; then
        git checkout "$ORIGINAL_BRANCH" &>/dev/null || true
    fi

    # Clean up test branches
    git branch | grep "feature/REQ-888-" | xargs -r git branch -D &>/dev/null || true
    git branch | grep "feature/REQ-777-" | xargs -r git branch -D &>/dev/null || true
}

# ============================================================================
# TESTS: branch-current
# ============================================================================

test_branch_current() {
    echo -e "\n${YELLOW}Testing branch-current...${NC}"

    assert_success "branch-current returns success" \
        "bash '$HAUNT_GIT' branch-current"

    assert_json_field "branch-current has 'branch' field" \
        "bash '$HAUNT_GIT' branch-current" \
        "branch"

    assert_json_field "branch-current has 'is_detached' field" \
        "bash '$HAUNT_GIT' branch-current" \
        "is_detached"

    assert_json_field "branch-current returns 'main'" \
        "bash '$HAUNT_GIT' branch-current" \
        "branch" \
        "main"
}

# ============================================================================
# TESTS: branch-list
# ============================================================================

test_branch_list() {
    echo -e "\n${YELLOW}Testing branch-list...${NC}"

    assert_success "branch-list returns success" \
        "bash '$HAUNT_GIT' branch-list"

    assert_json_field "branch-list has 'count' field" \
        "bash '$HAUNT_GIT' branch-list" \
        "count"

    assert_json_field "branch-list has 'branches' field" \
        "bash '$HAUNT_GIT' branch-list" \
        "branches"

    # Verify main branch is listed
    assert_json_field "branch-list includes main" \
        "bash '$HAUNT_GIT' branch-list" \
        "name" \
        "main"
}

# ============================================================================
# TESTS: branch-create
# ============================================================================

test_branch_create() {
    echo -e "\n${YELLOW}Testing branch-create...${NC}"

    # Test valid branch creation
    assert_success "branch-create with valid REQ-ID and title" \
        "bash '$HAUNT_GIT' branch-create REQ-888 'Test Feature'"

    assert_json_field "branch-create returns created branch name" \
        "bash '$HAUNT_GIT' branch-current" \
        "branch" \
        "feature/REQ-888-test-feature"

    # Return to main for next tests
    git checkout main &>/dev/null

    # Test slug generation with special characters
    assert_success "branch-create with special characters" \
        "bash '$HAUNT_GIT' branch-create REQ-888 'Add OAuth! & Login (Beta)'"

    local slug_output
    slug_output=$(bash "$HAUNT_GIT" branch-current)
    # Note: ampersand becomes double hyphen which is expected behavior
    if echo "$slug_output" | grep -q "feature/REQ-888-add-oauth"; then
        test_result "branch-create generates clean slug" "PASS"
    else
        test_result "branch-create generates clean slug" "FAIL" "Expected slug without special chars"
    fi

    git checkout main &>/dev/null
    git branch | grep "feature/REQ-888-add-oauth" | xargs -r git branch -D &>/dev/null || true

    # Test slug truncation (over 30 chars)
    assert_success "branch-create with long title" \
        "bash '$HAUNT_GIT' branch-create REQ-888 'This is a very long feature title that should be truncated'"

    local long_slug
    long_slug=$(bash "$HAUNT_GIT" branch-current | grep -o 'feature/REQ-888-[^"]*' | sed 's/feature\/REQ-888-//')
    if [[ ${#long_slug} -le 30 ]]; then
        test_result "branch-create truncates slug to 30 chars" "PASS"
    else
        test_result "branch-create truncates slug to 30 chars" "FAIL" "Slug is ${#long_slug} chars"
    fi

    git checkout main &>/dev/null

    # Test invalid REQ-ID format
    assert_failure "branch-create with invalid REQ-ID" \
        "bash '$HAUNT_GIT' branch-create INVALID-123 'Test'"

    assert_failure "branch-create with missing title" \
        "bash '$HAUNT_GIT' branch-create REQ-888"

    # Test duplicate branch creation
    bash "$HAUNT_GIT" branch-create REQ-777 "Duplicate Test" &>/dev/null
    git checkout main &>/dev/null
    assert_failure "branch-create with existing branch" \
        "bash '$HAUNT_GIT' branch-create REQ-777 'Duplicate Test'"
}

# ============================================================================
# TESTS: branch-for-req
# ============================================================================

test_branch_for_req() {
    echo -e "\n${YELLOW}Testing branch-for-req...${NC}"

    # Create test branch
    bash "$HAUNT_GIT" branch-create REQ-888 "Test Feature" &>/dev/null
    git checkout main &>/dev/null

    # Test finding existing branch
    assert_json_field "branch-for-req finds existing branch" \
        "bash '$HAUNT_GIT' branch-for-req REQ-888" \
        "found" \
        "true"

    assert_json_field "branch-for-req returns correct branch name" \
        "bash '$HAUNT_GIT' branch-for-req REQ-888" \
        "branch" \
        "feature/REQ-888-test-feature"

    # Test non-existent branch
    assert_json_field "branch-for-req with non-existent REQ" \
        "bash '$HAUNT_GIT' branch-for-req REQ-999" \
        "found" \
        "false"

    # Test invalid REQ-ID format
    assert_failure "branch-for-req with invalid REQ-ID" \
        "bash '$HAUNT_GIT' branch-for-req INVALID"
}

# ============================================================================
# TESTS: branch-delete
# ============================================================================

test_branch_delete() {
    echo -e "\n${YELLOW}Testing branch-delete...${NC}"

    # Create and merge a branch
    bash "$HAUNT_GIT" branch-create REQ-888 "Delete Test" &>/dev/null
    git checkout main &>/dev/null
    git merge --no-ff --no-edit feature/REQ-888-delete-test &>/dev/null

    # Test deleting merged branch
    assert_success "branch-delete removes merged branch" \
        "bash '$HAUNT_GIT' branch-delete feature/REQ-888-delete-test"

    assert_json_field "branch-delete returns deleted=true" \
        "bash '$HAUNT_GIT' branch-delete feature/REQ-888-delete-test" \
        "deleted" \
        "true" || true  # Might already be deleted

    # Test deleting non-existent branch
    assert_failure "branch-delete with non-existent branch" \
        "bash '$HAUNT_GIT' branch-delete feature/REQ-999-nonexistent"

    # Test deleting current branch
    bash "$HAUNT_GIT" branch-create REQ-888 "Current Test" &>/dev/null
    assert_failure "branch-delete cannot delete current branch" \
        "bash '$HAUNT_GIT' branch-delete feature/REQ-888-current-test"
    git checkout main &>/dev/null

    # Test deleting protected branch
    assert_failure "branch-delete cannot delete main" \
        "bash '$HAUNT_GIT' branch-delete main"

    # Test deleting unmerged branch without force
    bash "$HAUNT_GIT" branch-create REQ-888 "Unmerged Test" &>/dev/null
    git checkout main &>/dev/null
    assert_failure "branch-delete fails on unmerged branch" \
        "bash '$HAUNT_GIT' branch-delete feature/REQ-888-unmerged-test"

    # Force delete for cleanup
    git branch -D feature/REQ-888-unmerged-test &>/dev/null || true
}

# ============================================================================
# MAIN TEST RUNNER
# ============================================================================

main() {
    echo -e "${YELLOW}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║  Haunt Git Branch Commands Test Suite                   ║${NC}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════════════════╝${NC}"

    setup

    # Run all test suites
    test_branch_current
    test_branch_list
    test_branch_create
    test_branch_for_req
    test_branch_delete

    teardown

    # Print summary
    echo -e "\n${YELLOW}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║  Test Summary                                            ║${NC}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════════════════╝${NC}"
    echo -e "Tests run:    $TESTS_RUN"
    echo -e "${GREEN}Tests passed: $TESTS_PASSED${NC}"
    if [[ $TESTS_FAILED -gt 0 ]]; then
        echo -e "${RED}Tests failed: $TESTS_FAILED${NC}"
        exit 1
    else
        echo -e "${GREEN}All tests passed!${NC}"
        exit 0
    fi
}

main "$@"
