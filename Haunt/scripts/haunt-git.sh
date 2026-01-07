#!/usr/bin/env bash
#
# haunt-git.sh - Structured Git Operations Wrapper
#
# Returns structured JSON output for common git operations, eliminating
# parsing variance from text-based git output.
#
# Usage:
#   haunt-git status                  # Get repository status as JSON
#   haunt-git diff-stat [<ref>..<ref>]  # Get diff statistics as JSON
#   haunt-git log [--count=N]         # Get commit history as JSON
#   haunt-git <command> --raw         # Pass through to regular git
#
# Exit Codes:
#   0 - Success
#   1 - Error (git command failed or invalid usage)
#   2 - Not in a git repository

set -e
set -u
set -o pipefail

# ============================================================================
# CONFIGURATION
# ============================================================================

readonly SCRIPT_NAME="haunt-git"
readonly VERSION="1.0.0"

# ============================================================================
# ERROR HANDLING
# ============================================================================

error() {
    echo "{\"error\": \"$1\"}" >&2
    exit "${2:-1}"
}

# Check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        error "Not in a git repository" 2
    fi
}

# ============================================================================
# JSON ESCAPING
# ============================================================================

# Escape JSON special characters
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
    # Escape carriage returns
    input="${input//$'\r'/\\r}"
    echo "$input"
}

# ============================================================================
# SLUG GENERATION
# ============================================================================

# Generate slug from title (lowercase, hyphenate, truncate 30 chars)
generate_slug() {
    local title="$1"
    # Convert to lowercase (compatible with bash 3.2+)
    local slug
    slug=$(echo "$title" | tr '[:upper:]' '[:lower:]')
    # Replace spaces with hyphens
    slug=$(echo "$slug" | tr ' ' '-')
    # Remove special characters (keep letters, numbers, hyphens)
    slug=$(echo "$slug" | sed 's/[^a-z0-9-]//g')
    # Remove multiple consecutive hyphens
    slug=$(echo "$slug" | sed 's/-\+/-/g')
    # Remove leading/trailing hyphens
    slug=$(echo "$slug" | sed 's/^-\+//; s/-\+$//')
    # Truncate to 30 characters
    slug="${slug:0:30}"
    # Remove trailing hyphen if truncation created one
    slug=$(echo "$slug" | sed 's/-$//')
    echo "$slug"
}

# ============================================================================
# GIT STATUS COMMAND
# ============================================================================

cmd_status() {
    check_git_repo

    # Get current branch (handles detached HEAD)
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD")
    if [[ "$branch" == "HEAD" ]]; then
        # Detached HEAD - get commit hash
        branch="detached:$(git rev-parse --short HEAD)"
    fi

    # Get tracking branch info
    local ahead=0
    local behind=0
    local tracking_branch
    tracking_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "")

    if [[ -n "$tracking_branch" ]]; then
        # Get ahead/behind counts
        local ahead_behind
        ahead_behind=$(git rev-list --left-right --count "$tracking_branch"...HEAD 2>/dev/null || echo "0	0")
        behind=$(echo "$ahead_behind" | cut -f1)
        ahead=$(echo "$ahead_behind" | cut -f2)
    fi

    # Get file status using porcelain format (stable across git versions)
    local staged=()
    local modified=()
    local untracked=()
    local conflicted=()

    while IFS= read -r line; do
        if [[ -z "$line" ]]; then
            continue
        fi

        local status_code="${line:0:2}"
        local filepath="${line:3}"
        filepath=$(escape_json "$filepath")

        case "$status_code" in
            # Staged files (index has changes)
            A\ |M\ |D\ |R\ |C\ )
                staged+=("\"$filepath\"")
                ;;
            # Modified files (working tree has changes)
            \ M|\ D)
                modified+=("\"$filepath\"")
                ;;
            # Both staged and modified
            MM|AM|MD)
                staged+=("\"$filepath\"")
                modified+=("\"$filepath\"")
                ;;
            # Untracked files
            \?\?)
                untracked+=("\"$filepath\"")
                ;;
            # Merge conflicts
            UU|AA|DD|AU|UA|DU|UD)
                conflicted+=("\"$filepath\"")
                ;;
        esac
    done < <(git status --porcelain 2>/dev/null)

    # Check for merge in progress
    local merge_in_progress="false"
    if [[ -f .git/MERGE_HEAD ]]; then
        merge_in_progress="true"
    fi

    # Build JSON output
    # Handle empty arrays safely
    local staged_json=""
    local modified_json=""
    local untracked_json=""
    local conflicted_json=""

    if [[ ${#staged[@]} -gt 0 ]]; then
        staged_json=$(IFS=,; echo "${staged[*]}")
    fi
    if [[ ${#modified[@]} -gt 0 ]]; then
        modified_json=$(IFS=,; echo "${modified[*]}")
    fi
    if [[ ${#untracked[@]} -gt 0 ]]; then
        untracked_json=$(IFS=,; echo "${untracked[*]}")
    fi
    if [[ ${#conflicted[@]} -gt 0 ]]; then
        conflicted_json=$(IFS=,; echo "${conflicted[*]}")
    fi

    cat <<EOF
{
  "branch": "$(escape_json "$branch")",
  "tracking_branch": "$(escape_json "$tracking_branch")",
  "ahead": $ahead,
  "behind": $behind,
  "staged": [$staged_json],
  "modified": [$modified_json],
  "untracked": [$untracked_json],
  "conflicted": [$conflicted_json],
  "merge_in_progress": $merge_in_progress
}
EOF
}

# ============================================================================
# GIT DIFF-STAT COMMAND
# ============================================================================

cmd_diff_stat() {
    check_git_repo

    local ref_range="${1:-}"

    # Get diff statistics
    local diff_output
    if [[ -n "$ref_range" ]]; then
        diff_output=$(git diff --numstat "$ref_range" 2>/dev/null || error "Invalid ref range: $ref_range")
    else
        # Default: diff between working tree and HEAD
        diff_output=$(git diff --numstat HEAD 2>/dev/null || echo "")
    fi

    local files_changed=0
    local total_insertions=0
    local total_deletions=0
    local file_stats=()

    while IFS=$'\t' read -r insertions deletions filepath; do
        if [[ -z "$filepath" ]]; then
            continue
        fi

        # Handle binary files (git shows "-" for insertions/deletions)
        if [[ "$insertions" == "-" ]]; then
            insertions=0
        fi
        if [[ "$deletions" == "-" ]]; then
            deletions=0
        fi

        total_insertions=$((total_insertions + insertions))
        total_deletions=$((total_deletions + deletions))
        files_changed=$((files_changed + 1))

        filepath=$(escape_json "$filepath")
        file_stats+=("{\"file\": \"$filepath\", \"insertions\": $insertions, \"deletions\": $deletions}")
    done <<< "$diff_output"

    # Build JSON output
    local files_json=""
    if [[ ${#file_stats[@]} -gt 0 ]]; then
        files_json=$(IFS=,; echo "${file_stats[*]}")
    fi

    cat <<EOF
{
  "files_changed": $files_changed,
  "insertions": $total_insertions,
  "deletions": $total_deletions,
  "files": [$files_json]
}
EOF
}

# ============================================================================
# GIT LOG COMMAND
# ============================================================================

cmd_log() {
    check_git_repo

    local count=10  # Default to last 10 commits
    local ref_range=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --count=*)
                count="${1#*=}"
                shift
                ;;
            --count)
                count="$2"
                shift 2
                ;;
            *)
                # Assume it's a ref range
                ref_range="$1"
                shift
                ;;
        esac
    done

    # Build git log command
    local git_cmd="git log --format=%H%n%an%n%ae%n%at%n%s -n $count"
    if [[ -n "$ref_range" ]]; then
        git_cmd="$git_cmd $ref_range"
    fi

    local commits=()
    local commit_data=()
    local line_num=0

    while IFS= read -r line; do
        commit_data+=("$line")
        line_num=$((line_num + 1))

        # Every 5 lines is one complete commit
        if [[ $line_num -eq 5 ]]; then
            local hash="${commit_data[0]}"
            local author="${commit_data[1]}"
            local email="${commit_data[2]}"
            local timestamp="${commit_data[3]}"
            local message="${commit_data[4]}"

            # Escape JSON strings
            author=$(escape_json "$author")
            email=$(escape_json "$email")
            message=$(escape_json "$message")

            commits+=("{\"hash\": \"$hash\", \"author\": \"$author\", \"email\": \"$email\", \"timestamp\": $timestamp, \"message\": \"$message\"}")

            # Reset for next commit
            commit_data=()
            line_num=0
        fi
    done < <($git_cmd 2>/dev/null || error "Failed to retrieve git log")

    # Build JSON output
    local commits_json=""
    if [[ ${#commits[@]} -gt 0 ]]; then
        commits_json=$(IFS=,; echo "${commits[*]}")
    fi

    cat <<EOF
{
  "count": ${#commits[@]},
  "commits": [$commits_json]
}
EOF
}

# ============================================================================
# BRANCH MANAGEMENT COMMANDS
# ============================================================================

# Get current branch name
cmd_branch_current() {
    check_git_repo

    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD")

    local is_detached="false"
    if [[ "$branch" == "HEAD" ]]; then
        is_detached="true"
        branch=$(git rev-parse --short HEAD)
    fi

    branch=$(escape_json "$branch")

    cat <<EOF
{
  "branch": "$branch",
  "is_detached": $is_detached
}
EOF
}

# List all branches with REQ association
cmd_branch_list() {
    check_git_repo

    local branches=()
    local current_branch
    current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD")

    while IFS= read -r branch; do
        if [[ -z "$branch" ]]; then
            continue
        fi

        # Remove leading whitespace and asterisk
        branch=$(echo "$branch" | sed 's/^[* ] *//')

        local is_current="false"
        if [[ "$branch" == "$current_branch" ]]; then
            is_current="true"
        fi

        # Extract REQ-XXX from branch name (format: {type}/REQ-XXX-slug)
        local req_id=""
        if [[ "$branch" =~ (feature|fix|docs|refactor)/REQ-([0-9]+)- ]]; then
            req_id="REQ-${BASH_REMATCH[2]}"
        fi

        branch=$(escape_json "$branch")
        req_id=$(escape_json "$req_id")

        branches+=("{\"name\": \"$branch\", \"req_id\": \"$req_id\", \"is_current\": $is_current}")
    done < <(git branch 2>/dev/null)

    # Build JSON output
    local branches_json=""
    if [[ ${#branches[@]} -gt 0 ]]; then
        branches_json=$(IFS=,; echo "${branches[*]}")
    fi

    cat <<EOF
{
  "count": ${#branches[@]},
  "branches": [$branches_json]
}
EOF
}

# Create a feature branch for a requirement
cmd_branch_create() {
    check_git_repo

    if [[ $# -lt 2 ]]; then
        error "Usage: branch-create REQ-XXX \"Title\""
    fi

    local req_id="$1"
    local title="$2"
    local branch_type="${3:-feature}"  # Default to feature

    # Validate REQ-XXX format
    if [[ ! "$req_id" =~ ^REQ-[0-9]+$ ]]; then
        error "Invalid requirement ID format. Expected REQ-XXX"
    fi

    # Generate slug from title
    local slug
    slug=$(generate_slug "$title")

    if [[ -z "$slug" ]]; then
        error "Failed to generate slug from title"
    fi

    local branch_name="${branch_type}/${req_id}-${slug}"

    # Check if branch already exists
    if git rev-parse --verify "$branch_name" &>/dev/null; then
        error "Branch already exists: $branch_name"
    fi

    # Create and checkout branch
    if ! git checkout -b "$branch_name" 2>/dev/null; then
        error "Failed to create branch: $branch_name"
    fi

    branch_name=$(escape_json "$branch_name")
    req_id=$(escape_json "$req_id")
    slug=$(escape_json "$slug")

    cat <<EOF
{
  "branch": "$branch_name",
  "req_id": "$req_id",
  "slug": "$slug",
  "created": true
}
EOF
}

# Find branch for a requirement
cmd_branch_for_req() {
    check_git_repo

    if [[ $# -lt 1 ]]; then
        error "Usage: branch-for-req REQ-XXX"
    fi

    local req_id="$1"

    # Validate REQ-XXX format
    if [[ ! "$req_id" =~ ^REQ-[0-9]+$ ]]; then
        error "Invalid requirement ID format. Expected REQ-XXX"
    fi

    local found_branch=""
    local branch_type=""

    while IFS= read -r branch; do
        if [[ -z "$branch" ]]; then
            continue
        fi

        # Remove leading whitespace and asterisk
        branch=$(echo "$branch" | sed 's/^[* ] *//')

        # Check if branch matches REQ-ID pattern
        if [[ "$branch" =~ ^(feature|fix|docs|refactor)/${req_id}- ]]; then
            found_branch="$branch"
            branch_type="${BASH_REMATCH[1]}"
            break
        fi
    done < <(git branch 2>/dev/null)

    if [[ -z "$found_branch" ]]; then
        req_id=$(escape_json "$req_id")
        cat <<EOF
{
  "found": false,
  "req_id": "$req_id",
  "branch": null
}
EOF
    else
        found_branch=$(escape_json "$found_branch")
        branch_type=$(escape_json "$branch_type")
        req_id=$(escape_json "$req_id")

        cat <<EOF
{
  "found": true,
  "req_id": "$req_id",
  "branch": "$found_branch",
  "type": "$branch_type"
}
EOF
    fi
}

# Safely delete a merged branch
cmd_branch_delete() {
    check_git_repo

    if [[ $# -lt 1 ]]; then
        error "Usage: branch-delete <branch-name>"
    fi

    local branch="$1"
    local force="${2:-false}"

    # Prevent deleting current branch
    local current_branch
    current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ "$branch" == "$current_branch" ]]; then
        error "Cannot delete current branch. Checkout another branch first."
    fi

    # Prevent deleting main/master
    if [[ "$branch" == "main" || "$branch" == "master" ]]; then
        error "Cannot delete protected branch: $branch"
    fi

    # Check if branch exists
    if ! git rev-parse --verify "$branch" &>/dev/null; then
        error "Branch does not exist: $branch"
    fi

    # Check if branch is merged
    local is_merged="false"
    if git branch --merged | grep -q "^[* ]*${branch}$"; then
        is_merged="true"
    fi

    # Delete branch
    local deleted="false"
    if [[ "$is_merged" == "true" ]]; then
        if git branch -d "$branch" &>/dev/null; then
            deleted="true"
        else
            error "Failed to delete branch: $branch"
        fi
    elif [[ "$force" == "true" ]]; then
        if git branch -D "$branch" &>/dev/null; then
            deleted="true"
        else
            error "Failed to force delete branch: $branch"
        fi
    else
        error "Branch not merged and force=false: $branch"
    fi

    branch=$(escape_json "$branch")

    cat <<EOF
{
  "branch": "$branch",
  "deleted": $deleted,
  "was_merged": $is_merged
}
EOF
}

# ============================================================================
# HELP TEXT
# ============================================================================

show_help() {
    cat <<EOF
$SCRIPT_NAME - Structured Git Operations Wrapper

USAGE:
    $SCRIPT_NAME <command> [options]

COMMANDS:
    status                          Get repository status as JSON
    diff-stat [<ref>..<ref>]        Get diff statistics as JSON
    log [--count=N] [<ref>]         Get commit history as JSON

    branch-current                  Get current branch name as JSON
    branch-list                     List all branches with REQ associations as JSON
    branch-create REQ-XXX "Title"   Create feature/REQ-XXX-slug branch
    branch-for-req REQ-XXX          Find branch for requirement
    branch-delete <branch> [force]  Safely delete merged branch

OPTIONS:
    --raw                  Pass through to regular git (for any command)
    --help                 Show this help message
    --version              Show version information

EXAMPLES:
    # Get current repository status
    $SCRIPT_NAME status

    # Get diff statistics between HEAD and working tree
    $SCRIPT_NAME diff-stat

    # Get diff statistics between two refs
    $SCRIPT_NAME diff-stat main..feature-branch

    # Get last 5 commits
    $SCRIPT_NAME log --count=5

    # Get commits in a ref range
    $SCRIPT_NAME log main..HEAD

    # Get current branch
    $SCRIPT_NAME branch-current

    # List all branches
    $SCRIPT_NAME branch-list

    # Create feature branch
    $SCRIPT_NAME branch-create REQ-042 "Add Dark Mode Toggle"

    # Find branch for requirement
    $SCRIPT_NAME branch-for-req REQ-042

    # Delete merged branch
    $SCRIPT_NAME branch-delete feature/REQ-042-add-dark-mode-toggle

    # Pass through to regular git
    $SCRIPT_NAME status --raw

VERSION:
    $VERSION
EOF
}

# ============================================================================
# MAIN DISPATCH
# ============================================================================

main() {
    if [[ $# -eq 0 ]]; then
        show_help
        exit 1
    fi

    local command="$1"
    shift

    # Check for --raw flag (pass through to git)
    local has_raw=false
    local clean_args=()
    for arg in "$@"; do
        if [[ "$arg" == "--raw" ]]; then
            has_raw=true
        else
            clean_args+=("$arg")
        fi
    done

    if [[ "$has_raw" == true ]]; then
        if [[ ${#clean_args[@]} -gt 0 ]]; then
            exec git "$command" "${clean_args[@]}"
        else
            exec git "$command"
        fi
    fi

    # Dispatch to command handlers
    case "$command" in
        status)
            cmd_status "$@"
            ;;
        diff-stat)
            cmd_diff_stat "$@"
            ;;
        log)
            cmd_log "$@"
            ;;
        branch-current)
            cmd_branch_current "$@"
            ;;
        branch-list)
            cmd_branch_list "$@"
            ;;
        branch-create)
            cmd_branch_create "$@"
            ;;
        branch-for-req)
            cmd_branch_for_req "$@"
            ;;
        branch-delete)
            cmd_branch_delete "$@"
            ;;
        --help|-h|help)
            show_help
            ;;
        --version|-v)
            echo "$SCRIPT_NAME version $VERSION"
            ;;
        *)
            error "Unknown command: $command (use --help for usage)"
            ;;
    esac
}

main "$@"
