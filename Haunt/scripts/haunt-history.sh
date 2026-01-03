#!/bin/bash
# haunt-history.sh - Search and query UOCS history archive
# Part of the Universal Output Capture System (UOCS)

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Usage information
usage() {
    cat <<EOF
haunt-history.sh - Search UOCS history archive

USAGE:
    bash Haunt/scripts/haunt-history.sh <command> [options]

COMMANDS:
    search <term>           Search all history for term (grep-based)
    list [type]             List files by type (sessions, learnings, research, decisions)
    show <file>             Display specific history file
    recent [type] [N]       Show N most recent files by type (default: 10)
    stats                   Show history statistics
    events <tool>           Search tool events JSONL
    agent <agent-type>      List outputs from specific agent type

OPTIONS:
    -h, --help              Show this help message
    -v, --verbose           Verbose output

EXAMPLES:
    # Search all history for "authentication"
    bash Haunt/scripts/haunt-history.sh search authentication

    # List all learning sessions
    bash Haunt/scripts/haunt-history.sh list learnings

    # Show 5 most recent research outputs
    bash Haunt/scripts/haunt-history.sh recent research 5

    # Show history statistics
    bash Haunt/scripts/haunt-history.sh stats

    # Search tool events for "Edit" tool usage
    bash Haunt/scripts/haunt-history.sh events Edit

    # List all gco-research outputs
    bash Haunt/scripts/haunt-history.sh agent gco-research
EOF
}

# Find project root (look for .haunt directory)
find_project_root() {
    local current_dir="$PWD"
    while [[ "$current_dir" != "/" ]]; do
        if [[ -d "$current_dir/.haunt" ]]; then
            echo "$current_dir"
            return 0
        fi
        current_dir=$(dirname "$current_dir")
    done
    echo "ERROR: Not in a Haunt project (no .haunt/ directory found)" >&2
    exit 1
}

# Initialize paths
PROJECT_ROOT=$(find_project_root)
HISTORY_DIR="$PROJECT_ROOT/.haunt/history"

if [[ ! -d "$HISTORY_DIR" ]]; then
    echo -e "${RED}ERROR: UOCS not initialized (no .haunt/history/ directory)${NC}" >&2
    echo "Run: mkdir -p .haunt/history/{sessions,learnings,research,decisions,events,metadata}" >&2
    exit 1
fi

# Command: search
cmd_search() {
    local term="$1"
    echo -e "${CYAN}Searching history for: ${YELLOW}$term${NC}"
    echo ""

    local results=$(grep -ril "$term" "$HISTORY_DIR" 2>/dev/null || true)

    if [[ -z "$results" ]]; then
        echo -e "${YELLOW}No results found.${NC}"
        return 0
    fi

    echo "$results" | while read -r file; do
        local relative_path="${file#$HISTORY_DIR/}"
        local file_type=$(dirname "$relative_path")
        echo -e "${GREEN}[$file_type]${NC} $relative_path"

        # Show context (2 lines before and after match)
        grep -n -C 2 "$term" "$file" | head -20 | sed 's/^/  /' || true
        echo ""
    done
}

# Command: list
cmd_list() {
    local type="${1:-all}"
    echo -e "${CYAN}Listing history files: ${YELLOW}$type${NC}"
    echo ""

    case "$type" in
        sessions|learnings|research|decisions|events|metadata)
            local dir="$HISTORY_DIR/$type"
            if [[ ! -d "$dir" ]]; then
                echo -e "${YELLOW}No directory: $type${NC}"
                return 0
            fi

            local files=$(find "$dir" -type f -name "*.md" -o -name "*.jsonl" 2>/dev/null | sort -r)
            if [[ -z "$files" ]]; then
                echo -e "${YELLOW}No files found in $type${NC}"
                return 0
            fi

            echo "$files" | while read -r file; do
                local relative_path="${file#$HISTORY_DIR/}"
                local size=$(du -h "$file" | awk '{print $1}')
                echo -e "${GREEN}[$size]${NC} $relative_path"
            done
            ;;
        all)
            for subdir in sessions learnings research decisions events metadata; do
                if [[ -d "$HISTORY_DIR/$subdir" ]]; then
                    local count=$(find "$HISTORY_DIR/$subdir" -type f 2>/dev/null | wc -l | tr -d ' ')
                    echo -e "${GREEN}[$count files]${NC} $subdir/"
                fi
            done
            ;;
        *)
            echo -e "${RED}ERROR: Unknown type: $type${NC}" >&2
            echo "Valid types: sessions, learnings, research, decisions, events, metadata, all" >&2
            exit 1
            ;;
    esac
}

# Command: show
cmd_show() {
    local file="$1"

    # Support both absolute and relative paths
    if [[ ! -f "$file" ]]; then
        # Try relative to HISTORY_DIR
        file="$HISTORY_DIR/$file"
    fi

    if [[ ! -f "$file" ]]; then
        echo -e "${RED}ERROR: File not found: $file${NC}" >&2
        exit 1
    fi

    echo -e "${CYAN}Showing: ${YELLOW}${file#$HISTORY_DIR/}${NC}"
    echo ""
    cat "$file"
}

# Command: recent
cmd_recent() {
    local type="${1:-all}"
    local limit="${2:-10}"

    echo -e "${CYAN}Recent history files: ${YELLOW}$type (limit: $limit)${NC}"
    echo ""

    local search_path=""
    case "$type" in
        sessions|learnings|research|decisions)
            search_path="$HISTORY_DIR/$type"
            ;;
        all)
            search_path="$HISTORY_DIR"
            ;;
        *)
            echo -e "${RED}ERROR: Unknown type: $type${NC}" >&2
            exit 1
            ;;
    esac

    find "$search_path" -type f -name "*.md" -print0 2>/dev/null \
        | xargs -0 ls -t 2>/dev/null \
        | head -n "$limit" \
        | while read -r file; do
            local relative_path="${file#$HISTORY_DIR/}"
            local file_type=$(dirname "$relative_path")
            local size=$(du -h "$file" | awk '{print $1}')
            local mtime=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$file" 2>/dev/null || stat -c "%y" "$file" 2>/dev/null | cut -d. -f1)
            echo -e "${GREEN}[$file_type]${NC} ${BLUE}[$mtime]${NC} ${YELLOW}[$size]${NC} $relative_path"
        done
}

# Command: stats
cmd_stats() {
    echo -e "${CYAN}UOCS History Statistics${NC}"
    echo ""

    for subdir in sessions learnings research decisions events metadata; do
        if [[ -d "$HISTORY_DIR/$subdir" ]]; then
            local count=$(find "$HISTORY_DIR/$subdir" -type f 2>/dev/null | wc -l | tr -d ' ')
            local total_size=$(du -sh "$HISTORY_DIR/$subdir" 2>/dev/null | awk '{print $1}')
            echo -e "${GREEN}$subdir:${NC} $count files ($total_size)"
        fi
    done

    echo ""
    local total_files=$(find "$HISTORY_DIR" -type f 2>/dev/null | wc -l | tr -d ' ')
    local total_size=$(du -sh "$HISTORY_DIR" 2>/dev/null | awk '{print $1}')
    echo -e "${YELLOW}Total:${NC} $total_files files ($total_size)"

    # Show event stats if events exist
    local event_log="$HISTORY_DIR/events/tool-events.jsonl"
    if [[ -f "$event_log" ]]; then
        echo ""
        local event_count=$(wc -l < "$event_log" | tr -d ' ')
        echo -e "${MAGENTA}Tool Events:${NC} $event_count events captured"
    fi
}

# Command: events
cmd_events() {
    local tool="${1:-}"
    local event_log="$HISTORY_DIR/events/tool-events.jsonl"

    if [[ ! -f "$event_log" ]]; then
        echo -e "${YELLOW}No tool events captured yet.${NC}"
        return 0
    fi

    if [[ -z "$tool" ]]; then
        # Show all tools used
        echo -e "${CYAN}Tool Usage Summary${NC}"
        echo ""
        jq -r '.tool' "$event_log" | sort | uniq -c | sort -rn | while read -r count name; do
            echo -e "${GREEN}[$count uses]${NC} $name"
        done
    else
        # Show events for specific tool
        echo -e "${CYAN}Events for tool: ${YELLOW}$tool${NC}"
        echo ""
        jq -r "select(.tool == \"$tool\") | \"\(.timestamp) [\(.status)] \(.tool)\"" "$event_log" | head -20
    fi
}

# Command: agent
cmd_agent() {
    local agent_type="$1"
    local metadata_file="$HISTORY_DIR/metadata/subagent-index.jsonl"

    if [[ ! -f "$metadata_file" ]]; then
        echo -e "${YELLOW}No subagent metadata yet.${NC}"
        return 0
    fi

    echo -e "${CYAN}Outputs from agent: ${YELLOW}$agent_type${NC}"
    echo ""

    jq -r "select(.agent_type | startswith(\"$agent_type\")) | \"\(.timestamp) \(.output_path)\"" "$metadata_file" \
        | while read -r timestamp path; do
            local relative_path="${path#$HISTORY_DIR/}"
            echo -e "${BLUE}[$timestamp]${NC} $relative_path"
        done
}

# Main command dispatcher
main() {
    if [[ $# -eq 0 ]]; then
        usage
        exit 1
    fi

    local command="$1"
    shift

    case "$command" in
        search)
            if [[ $# -eq 0 ]]; then
                echo "ERROR: search requires a term" >&2
                usage
                exit 1
            fi
            cmd_search "$@"
            ;;
        list)
            cmd_list "$@"
            ;;
        show)
            if [[ $# -eq 0 ]]; then
                echo "ERROR: show requires a file path" >&2
                usage
                exit 1
            fi
            cmd_show "$@"
            ;;
        recent)
            cmd_recent "$@"
            ;;
        stats)
            cmd_stats
            ;;
        events)
            cmd_events "$@"
            ;;
        agent)
            if [[ $# -eq 0 ]]; then
                echo "ERROR: agent requires an agent type" >&2
                usage
                exit 1
            fi
            cmd_agent "$@"
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "ERROR: Unknown command: $command" >&2
            usage
            exit 1
            ;;
    esac
}

main "$@"
