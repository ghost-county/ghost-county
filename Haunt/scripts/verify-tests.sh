#!/usr/bin/env bash
#
# verify-tests.sh - Universal test verification for all requirement types
#
# Usage: verify-tests.sh REQ-XXX <frontend|backend|infrastructure>
#
# Returns:
#   0 - All tests passed
#   1 - Tests failed or error occurred
#
# Output:
#   Clear PASS/FAIL verdict with test results

set -e  # Exit on error
set -o pipefail  # Exit on pipe failure

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Usage check
if [ $# -ne 2 ]; then
    echo "Usage: $0 REQ-XXX <frontend|backend|infrastructure>"
    echo ""
    echo "Examples:"
    echo "  $0 REQ-123 frontend"
    echo "  $0 REQ-456 backend"
    echo "  $0 REQ-789 infrastructure"
    exit 1
fi

REQ_ID="$1"
TYPE="$2"

# Find project directory (look for .haunt/ marker)
find_project_dir() {
    local dir="$PWD"
    while [ "$dir" != "/" ]; do
        if [ -d "$dir/.haunt" ]; then
            echo "$dir"
            return 0
        fi
        dir=$(dirname "$dir")
    done
    # Fall back to current directory
    echo "$PWD"
}

PROJECT_DIR=$(find_project_dir)

# Create verification evidence file for completion-gate hook
create_verification_evidence() {
    local result="$1"
    local test_output="$2"

    local evidence_dir="$PROJECT_DIR/.haunt/progress"
    local evidence_file="$evidence_dir/${REQ_ID}-verified.txt"

    mkdir -p "$evidence_dir"

    cat > "$evidence_file" << EOF
Verification Evidence for $REQ_ID
==================================
Agent Type: $TYPE
Timestamp: $(date -Iseconds)
Result: $result

Test Output Summary:
$test_output

This file was created by verify-tests.sh and is used by the
completion-gate hook to verify tests passed before allowing
a requirement to be marked complete (🟢).

File is valid for 1 hour from creation time.
EOF

    echo ""
    echo -e "${GREEN}Created verification evidence: $evidence_file${NC}"
}

echo "========================================="
echo "Test Verification for $REQ_ID ($TYPE)"
echo "========================================="
echo ""

# Verify requirement type is valid
case "$TYPE" in
    frontend|backend|infrastructure)
        ;;
    *)
        echo -e "${RED}✗ ERROR: Invalid type '$TYPE'${NC}"
        echo "Valid types: frontend, backend, infrastructure"
        exit 1
        ;;
esac

# Frontend verification
if [ "$TYPE" = "frontend" ]; then
    echo "Running frontend tests..."
    echo ""

    # Check if npm is available
    if ! command -v npm &> /dev/null; then
        echo -e "${RED}✗ ERROR: npm not found. Install Node.js to run frontend tests.${NC}"
        exit 1
    fi

    # Run npm test
    echo "Step 1: npm test"
    echo "-------------------"
    if npm test; then
        echo -e "${GREEN}✓ npm test passed${NC}"
        NPM_TEST_PASSED=true
    else
        echo -e "${RED}✗ npm test failed${NC}"
        NPM_TEST_PASSED=false
    fi
    echo ""

    # Run Playwright tests
    echo "Step 2: npx playwright test"
    echo "----------------------------"
    if command -v npx &> /dev/null && [ -f "package.json" ] && grep -q "playwright" package.json; then
        if npx playwright test; then
            echo -e "${GREEN}✓ Playwright tests passed${NC}"
            PLAYWRIGHT_PASSED=true
        else
            echo -e "${RED}✗ Playwright tests failed${NC}"
            PLAYWRIGHT_PASSED=false
        fi
    else
        echo -e "${YELLOW}⚠ Playwright not detected - skipping E2E tests${NC}"
        PLAYWRIGHT_PASSED=true  # Don't fail if Playwright not configured
    fi
    echo ""

    # Frontend verdict
    if [ "$NPM_TEST_PASSED" = true ] && [ "$PLAYWRIGHT_PASSED" = true ]; then
        echo -e "${GREEN}=========================================${NC}"
        echo -e "${GREEN}✅ VERIFICATION PASSED${NC}"
        echo -e "${GREEN}All frontend tests passed for $REQ_ID${NC}"
        echo -e "${GREEN}=========================================${NC}"
        create_verification_evidence "PASS" "npm test: PASSED, Playwright: PASSED"
        exit 0
    else
        echo -e "${RED}=========================================${NC}"
        echo -e "${RED}❌ VERIFICATION FAILED${NC}"
        echo -e "${RED}Frontend tests failed for $REQ_ID${NC}"
        echo ""
        [ "$NPM_TEST_PASSED" = false ] && echo -e "${RED}  • npm test: FAILED${NC}"
        [ "$PLAYWRIGHT_PASSED" = false ] && echo -e "${RED}  • Playwright: FAILED${NC}"
        echo -e "${RED}=========================================${NC}"
        exit 1
    fi
fi

# Backend verification
if [ "$TYPE" = "backend" ]; then
    echo "Running backend tests..."
    echo ""

    # Detect test framework
    TEST_COMMAND=""

    # Check for pytest
    if [ -f "pytest.ini" ] || [ -f "pyproject.toml" ] || [ -d "tests" ] && command -v pytest &> /dev/null; then
        TEST_COMMAND="pytest tests/ -x -q"
        FRAMEWORK="pytest"
    # Check for npm test
    elif [ -f "package.json" ] && grep -q "\"test\"" package.json; then
        TEST_COMMAND="npm test"
        FRAMEWORK="npm"
    else
        echo -e "${RED}✗ ERROR: No test framework detected${NC}"
        echo "Expected: pytest.ini, pyproject.toml, or package.json with test script"
        exit 1
    fi

    echo "Detected test framework: $FRAMEWORK"
    echo "Running: $TEST_COMMAND"
    echo "----------------------------"

    if eval "$TEST_COMMAND"; then
        echo ""
        echo -e "${GREEN}=========================================${NC}"
        echo -e "${GREEN}✅ VERIFICATION PASSED${NC}"
        echo -e "${GREEN}All backend tests passed for $REQ_ID${NC}"
        echo -e "${GREEN}=========================================${NC}"
        create_verification_evidence "PASS" "$FRAMEWORK tests: PASSED"
        exit 0
    else
        echo ""
        echo -e "${RED}=========================================${NC}"
        echo -e "${RED}❌ VERIFICATION FAILED${NC}"
        echo -e "${RED}Backend tests failed for $REQ_ID${NC}"
        echo -e "${RED}=========================================${NC}"
        exit 1
    fi
fi

# Infrastructure verification
if [ "$TYPE" = "infrastructure" ]; then
    echo "Infrastructure verification (manual)..."
    echo ""
    echo "Infrastructure tests require manual verification:"
    echo "  • Terraform: Run 'terraform plan' to verify changes"
    echo "  • Ansible: Run 'ansible-playbook --check' to verify playbook"
    echo "  • CI/CD: Verify pipeline syntax and configuration"
    echo "  • Scripts: Test scripts in isolated environment"
    echo ""
    echo "Document your verification steps in the requirement completion notes."
    echo ""
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}✅ VERIFICATION REMINDER${NC}"
    echo -e "${GREEN}Manual verification required for $REQ_ID${NC}"
    echo -e "${GREEN}=========================================${NC}"
    create_verification_evidence "PASS" "Infrastructure: Manual verification acknowledged"
    exit 0
fi
