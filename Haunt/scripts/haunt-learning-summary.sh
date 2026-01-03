#!/bin/bash
# haunt-learning-summary.sh - Generate weekly learning summary from UOCS learnings
# Part of the Learning Extraction System

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
haunt-learning-summary.sh - Generate weekly learning summary

USAGE:
    bash Haunt/scripts/haunt-learning-summary.sh [options]

OPTIONS:
    -d, --days N            Number of days to include (default: 7)
    -o, --output FILE       Write summary to file instead of stdout
    -f, --format FORMAT     Output format: text (default), markdown, json
    -h, --help              Show this help message

EXAMPLES:
    # Generate summary for last 7 days (default)
    bash Haunt/scripts/haunt-learning-summary.sh

    # Generate summary for last 14 days
    bash Haunt/scripts/haunt-learning-summary.sh --days 14

    # Save summary to file
    bash Haunt/scripts/haunt-learning-summary.sh --output weekly-summary.md

    # Generate JSON output
    bash Haunt/scripts/haunt-learning-summary.sh --format json
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

# Extract keywords from learning session
extract_keywords() {
    local file="$1"
    grep -oiE "(learned|realized|discovered|insight|pattern|mistake|revelation|understood|improved|optimized)" "$file" \
        | tr '[:upper:]' '[:lower:]' \
        | sort | uniq -c | sort -rn || true
}

# Extract key insights from learning session (first 5 lines after header)
extract_insights() {
    local file="$1"
    # Skip header, get first 500 chars of content
    tail -n +4 "$file" | head -c 500 | tr '\n' ' ' | sed 's/  */ /g' || true
}

# Generate text format summary
generate_text_summary() {
    local days="$1"
    local cutoff_date="$2"

    echo -e "${CYAN}===== Learning Summary: Last $days Days =====${NC}"
    echo -e "${BLUE}Generated: $(date '+%Y-%m-%d %H:%M')${NC}"
    echo ""

    # Find learning sessions
    local learning_files=$(find "$LEARNINGS_DIR" -name "*-learning.md" -type f -newermt "$cutoff_date" 2>/dev/null | sort -r)

    if [[ -z "$learning_files" ]]; then
        echo -e "${YELLOW}No learning sessions found in last $days days.${NC}"
        return 0
    fi

    local count=$(echo "$learning_files" | wc -l | tr -d ' ')
    echo -e "${GREEN}Total Learning Sessions: $count${NC}"
    echo ""

    # Aggregate keyword stats
    echo -e "${MAGENTA}Top Learning Keywords:${NC}"
    local all_keywords=$(mktemp)
    while IFS= read -r file; do
        extract_keywords "$file" >> "$all_keywords"
    done <<< "$learning_files"

    awk '{count[$2]+=$1} END {for (word in count) print count[word], word}' "$all_keywords" \
        | sort -rn | head -10 | while read -r count keyword; do
        echo -e "  ${GREEN}[$count]${NC} $keyword"
    done
    rm "$all_keywords"

    echo ""
    echo -e "${MAGENTA}Learning Sessions:${NC}"
    echo ""

    # List each learning session with preview
    local session_num=0
    while IFS= read -r file; do
        ((session_num++))
        local basename=$(basename "$file")
        local timestamp=$(echo "$basename" | sed 's/-learning.md//' | sed 's/-/:/3' | sed 's/-/:/3' | sed 's/T/ /')
        local keyword_count=$(grep -o "Keywords Detected:" "$file" | wc -l | tr -d ' ')

        echo -e "${BLUE}[$session_num]${NC} ${YELLOW}$timestamp${NC}"

        # Extract first meaningful line as summary
        local preview=$(extract_insights "$file")
        if [[ -n "$preview" ]]; then
            echo "  Preview: ${preview:0:150}..."
        fi

        echo "  File: ${file#$PROJECT_ROOT/}"
        echo ""
    done <<< "$learning_files"
}

# Generate markdown format summary
generate_markdown_summary() {
    local days="$1"
    local cutoff_date="$2"

    echo "# Learning Summary: Last $days Days"
    echo ""
    echo "**Generated:** $(date '+%Y-%m-%d %H:%M')"
    echo ""

    # Find learning sessions
    local learning_files=$(find "$LEARNINGS_DIR" -name "*-learning.md" -type f -newermt "$cutoff_date" 2>/dev/null | sort -r)

    if [[ -z "$learning_files" ]]; then
        echo "No learning sessions found in last $days days."
        return 0
    fi

    local count=$(echo "$learning_files" | wc -l | tr -d ' ')
    echo "**Total Learning Sessions:** $count"
    echo ""

    # Aggregate keyword stats
    echo "## Top Learning Keywords"
    echo ""
    local all_keywords=$(mktemp)
    while IFS= read -r file; do
        extract_keywords "$file" >> "$all_keywords"
    done <<< "$learning_files"

    awk '{count[$2]+=$1} END {for (word in count) print count[word], word}' "$all_keywords" \
        | sort -rn | head -10 | while read -r count keyword; do
        echo "- **$keyword:** $count occurrences"
    done
    rm "$all_keywords"

    echo ""
    echo "## Learning Sessions"
    echo ""

    # List each learning session
    local session_num=0
    while IFS= read -r file; do
        ((session_num++))
        local basename=$(basename "$file")
        local timestamp=$(echo "$basename" | sed 's/-learning.md//' | sed 's/-/:/3' | sed 's/-/:/3' | sed 's/T/ /')

        echo "### Session $session_num: $timestamp"
        echo ""

        # Extract preview
        local preview=$(extract_insights "$file")
        if [[ -n "$preview" ]]; then
            echo "${preview:0:300}..."
            echo ""
        fi

        echo "**File:** \`.haunt/history/learnings/$(basename "$file")\`"
        echo ""
    done <<< "$learning_files"
}

# Generate JSON format summary
generate_json_summary() {
    local days="$1"
    local cutoff_date="$2"

    # Find learning sessions
    local learning_files=$(find "$LEARNINGS_DIR" -name "*-learning.md" -type f -newermt "$cutoff_date" 2>/dev/null | sort -r)

    if [[ -z "$learning_files" ]]; then
        echo '{"sessions": [], "count": 0, "days": '$days'}'
        return 0
    fi

    local count=$(echo "$learning_files" | wc -l | tr -d ' ')

    echo '{'
    echo '  "generated": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'",'
    echo '  "days": '$days','
    echo '  "count": '$count','
    echo '  "sessions": ['

    local first=1
    while IFS= read -r file; do
        [[ $first -eq 0 ]] && echo ','
        first=0

        local basename=$(basename "$file")
        local timestamp=$(echo "$basename" | sed 's/-learning.md//' | sed 's/-/:/3' | sed 's/-/:/3')
        local preview=$(extract_insights "$file" | sed 's/"/\\"/g')

        echo -n '    {"timestamp": "'$timestamp'", "file": "'${file#$PROJECT_ROOT/}'", "preview": "'${preview:0:200}...'"}'
    done <<< "$learning_files"

    echo ''
    echo '  ]'
    echo '}'
}

# Main
main() {
    # Default options
    local days=7
    local output_file=""
    local format="text"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -d|--days)
                days="$2"
                shift 2
                ;;
            -o|--output)
                output_file="$2"
                shift 2
                ;;
            -f|--format)
                format="$2"
                shift 2
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                echo "ERROR: Unknown option: $1" >&2
                usage
                exit 1
                ;;
        esac
    done

    # Validate format
    if [[ ! "$format" =~ ^(text|markdown|json)$ ]]; then
        echo "ERROR: Invalid format: $format (must be text, markdown, or json)" >&2
        exit 1
    fi

    # Find project root and learnings directory
    PROJECT_ROOT=$(find_project_root)
    LEARNINGS_DIR="$PROJECT_ROOT/.haunt/history/learnings"

    if [[ ! -d "$LEARNINGS_DIR" ]]; then
        echo -e "${RED}ERROR: Learnings directory not found${NC}" >&2
        echo "Expected: $LEARNINGS_DIR" >&2
        echo "Run UOCS initialization first (part of REQ-335)" >&2
        exit 1
    fi

    # Calculate cutoff date (N days ago)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS date command
        cutoff_date=$(date -v-${days}d '+%Y-%m-%d')
    else
        # Linux date command
        cutoff_date=$(date -d "$days days ago" '+%Y-%m-%d')
    fi

    # Generate summary based on format
    local output=""
    case "$format" in
        text)
            output=$(generate_text_summary "$days" "$cutoff_date")
            ;;
        markdown)
            output=$(generate_markdown_summary "$days" "$cutoff_date")
            ;;
        json)
            output=$(generate_json_summary "$days" "$cutoff_date")
            ;;
    esac

    # Output to file or stdout
    if [[ -n "$output_file" ]]; then
        echo "$output" > "$output_file"
        echo -e "${GREEN}Summary written to: $output_file${NC}" >&2
    else
        echo "$output"
    fi
}

main "$@"
