#!/bin/bash
# Séance Phase Enforcement Hook
# Blocks: gco-dev-* agents when phase != SUMMONING
#
# This hook ensures dev agents can only be spawned during the SUMMONING phase
# of the Séance workflow. PM and Research agents are allowed in SCRYING.

set -euo pipefail

# Global disable check
if [[ "${HAUNT_HOOKS_DISABLED:-0}" == "1" ]]; then
    exit 0
fi

# Read hook input from stdin
INPUT=$(cat)

# Extract subagent type from tool input
SUBAGENT_TYPE=$(echo "$INPUT" | jq -r '.tool_input.subagent_type // ""')

# Only check gco-dev-* agents (backend, frontend, infrastructure)
if [[ ! "$SUBAGENT_TYPE" =~ ^gco-dev ]]; then
    exit 0  # Allow non-dev agents (PM, research, code-reviewer, etc.)
fi

# Find project directory
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(echo "$INPUT" | jq -r '.cwd')}"
PHASE_FILE="$PROJECT_DIR/.haunt/state/current-phase.txt"

# If no phase file exists, we're not in a séance - allow the spawn
# This permits dev agents outside of the séance workflow
if [[ ! -f "$PHASE_FILE" ]]; then
    exit 0
fi

# Read current phase
CURRENT_PHASE=$(cat "$PHASE_FILE" 2>/dev/null || echo "UNKNOWN")

# Block dev agents unless in SUMMONING phase
if [[ "$CURRENT_PHASE" != "SUMMONING" ]]; then
    echo "Phase violation: Cannot spawn $SUBAGENT_TYPE during $CURRENT_PHASE phase." >&2
    echo "" >&2
    echo "The Séance workflow requires transitioning to SUMMONING before spawning dev agents." >&2
    echo "Current phase: $CURRENT_PHASE" >&2
    echo "" >&2
    echo "To fix:" >&2
    echo "1. Complete SCRYING (planning) first" >&2
    echo "2. Present summoning prompt to user" >&2
    echo "3. Get user approval to summon agents" >&2
    echo "4. Write 'SUMMONING' to $PHASE_FILE" >&2
    echo "5. Then spawn dev agents" >&2
    exit 2  # Blocking error - shown to Claude
fi

exit 0
