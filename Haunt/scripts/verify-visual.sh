#!/usr/bin/env bash
#
# verify-visual.sh - Visual verification for frontend requirements
#
# Usage: verify-visual.sh REQ-XXX <url>
#
# Example: verify-visual.sh REQ-123 http://localhost:3000/settings
#
# Returns:
#   0 - Visual verification confirmed
#   1 - Verification skipped or failed
#
# Output:
#   Screenshot saved to .haunt/progress/{REQ}-screenshot.png
#   Evidence file created at .haunt/progress/{REQ}-visual-verified.txt

set -e
set -o pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ $# -ne 2 ]; then
    echo "Usage: $0 REQ-XXX <url>"
    echo ""
    echo "Example: $0 REQ-123 http://localhost:3000/settings"
    exit 1
fi

REQ_ID="$1"
URL="$2"

# Find project directory
find_project_dir() {
    local dir="$PWD"
    while [ "$dir" != "/" ]; do
        if [ -d "$dir/.haunt" ]; then
            echo "$dir"
            return 0
        fi
        dir=$(dirname "$dir")
    done
    echo "$PWD"
}

PROJECT_DIR=$(find_project_dir)
EVIDENCE_DIR="$PROJECT_DIR/.haunt/progress"
SCREENSHOT_FILE="$EVIDENCE_DIR/${REQ_ID}-screenshot.png"
EVIDENCE_FILE="$EVIDENCE_DIR/${REQ_ID}-visual-verified.txt"

mkdir -p "$EVIDENCE_DIR"

echo "========================================="
echo "Visual Verification for $REQ_ID"
echo "========================================="
echo ""
echo "URL: $URL"
echo ""

# Take screenshot using Playwright
echo "Taking screenshot..."
if npx playwright screenshot "$URL" "$SCREENSHOT_FILE" 2>/dev/null; then
    echo -e "${GREEN}✓ Screenshot saved: $SCREENSHOT_FILE${NC}"
else
    echo -e "${YELLOW}⚠ Playwright screenshot failed. Trying alternative...${NC}"
    # Fallback: Try using Playwright script
    npx playwright test --reporter=list -g "screenshot" 2>/dev/null || true
fi

# Check if screenshot exists
if [ ! -f "$SCREENSHOT_FILE" ]; then
    echo ""
    echo -e "${RED}✗ No screenshot created${NC}"
    echo ""
    echo "Manual verification required:"
    echo "1. Open $URL in browser"
    echo "2. Take screenshot manually"
    echo "3. Save to: $SCREENSHOT_FILE"
    echo "4. Re-run this script or create evidence manually"
    exit 1
fi

echo ""
echo "Screenshot preview: $SCREENSHOT_FILE"
echo ""
echo -e "${YELLOW}Visual Verification Required:${NC}"
echo "Please confirm the screenshot shows correct styling."
echo ""
read -p "Does the visual appearance look correct? [y/N] " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Create evidence file
    cat > "$EVIDENCE_FILE" << EOF
Visual Verification Evidence for $REQ_ID
==========================================
URL Verified: $URL
Timestamp: $(date -Iseconds)
Screenshot: $SCREENSHOT_FILE
Result: PASS (User confirmed visual appearance correct)

This file was created by verify-visual.sh and is used by the
completion-gate hook to verify visual appearance before allowing
a frontend requirement to be marked complete (🟢).

File is valid for 1 hour from creation time.
EOF

    echo ""
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}✅ VISUAL VERIFICATION PASSED${NC}"
    echo -e "${GREEN}Evidence created: $EVIDENCE_FILE${NC}"
    echo -e "${GREEN}=========================================${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}=========================================${NC}"
    echo -e "${RED}❌ VISUAL VERIFICATION FAILED${NC}"
    echo -e "${RED}User indicated visual appearance is not correct${NC}"
    echo -e "${RED}=========================================${NC}"
    echo ""
    echo "Fix the styling issues and re-run verification."
    exit 1
fi
