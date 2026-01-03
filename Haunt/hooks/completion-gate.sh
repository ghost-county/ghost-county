#!/bin/bash
# Completion Gate Hook
# Blocks: Marking requirements complete (🟢) without test verification
#
# This hook ensures requirements can only be marked complete when tests have
# been verified by running verify-tests.sh, which creates evidence files.

set -euo pipefail

# Global disable check
if [[ "${HAUNT_HOOKS_DISABLED:-0}" == "1" ]]; then
    exit 0
fi

# Read hook input from stdin
INPUT=$(cat)

# Extract file path and new content from tool input
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')
NEW_STRING=$(echo "$INPUT" | jq -r '.tool_input.new_string // ""')

# Only check edits to roadmap files
if [[ "$FILE_PATH" != *"roadmap.md"* ]]; then
    exit 0
fi

# Check if the edit is changing status to complete (🟢)
if [[ "$NEW_STRING" != *"🟢"* ]]; then
    exit 0  # Not marking complete, allow
fi

# Extract REQ number being marked complete
REQ_MATCH=$(echo "$NEW_STRING" | grep -oE 'REQ-[0-9]+' | head -1 || true)

if [[ -z "$REQ_MATCH" ]]; then
    exit 0  # Can't determine REQ number, allow (defensive)
fi

# Find project directory
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(echo "$INPUT" | jq -r '.cwd')}"

# Check for test verification evidence file
VERIFY_FILE="$PROJECT_DIR/.haunt/progress/${REQ_MATCH}-verified.txt"

if [[ ! -f "$VERIFY_FILE" ]]; then
    echo "Completion gate: Cannot mark $REQ_MATCH complete without test verification." >&2
    echo "" >&2
    echo "To fix:" >&2
    echo "1. Run: bash Haunt/scripts/verify-tests.sh $REQ_MATCH <frontend|backend|infrastructure>" >&2
    echo "2. This creates: $VERIFY_FILE" >&2
    echo "3. Then retry marking the requirement complete" >&2
    echo "" >&2
    echo "This ensures all requirements have passing tests before completion." >&2
    echo "See: gco-completion-checklist rule for full requirements." >&2
    exit 2  # Blocking error
fi

# Check verification is recent (within last hour = 3600 seconds)
# This prevents using stale verification from previous sessions
CURRENT_TIME=$(date +%s)

# Get file modification time (macOS vs Linux compatible)
if [[ "$(uname)" == "Darwin" ]]; then
    FILE_TIME=$(stat -f %m "$VERIFY_FILE" 2>/dev/null || echo "0")
else
    FILE_TIME=$(stat -c %Y "$VERIFY_FILE" 2>/dev/null || echo "0")
fi

VERIFY_AGE=$((CURRENT_TIME - FILE_TIME))

if [[ $VERIFY_AGE -gt 3600 ]]; then
    MINUTES_AGO=$((VERIFY_AGE / 60))
    echo "Completion gate: Test verification for $REQ_MATCH is stale." >&2
    echo "" >&2
    echo "Verification was $MINUTES_AGO minutes ago (max: 60 minutes)." >&2
    echo "" >&2
    echo "Re-run: bash Haunt/scripts/verify-tests.sh $REQ_MATCH <agent-type>" >&2
    echo "" >&2
    echo "This ensures tests still pass before marking complete." >&2
    exit 2  # Blocking error
fi

# Verification is valid and recent
exit 0
