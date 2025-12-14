#!/usr/bin/env bash
#
# cleanse.sh - Haunt Uninstall Script
#
# Removes Ghost County (Haunt) framework from your system.
# Supports partial (global only) or full (global + project) cleansing.
#
# Usage: bash Haunt/scripts/cleanse.sh [options]
#
# Options:
#   --partial       Remove ~/.claude/gco-* artifacts only (default)
#   --full          Remove ~/.claude/gco-* AND .haunt/ directory
#   --backup        Create backup before deletion
#   --force         Skip confirmation prompts (dangerous!)
#   --help          Show this help message
#
# Safety Features:
#   - Checks for uncommitted work in .haunt/
#   - Shows preview of what will be deleted
#   - Requires explicit confirmation (unless --force)
#   - Optional backup creation

set -e  # Exit on error
set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

# ============================================================================
# COLOR OUTPUT FUNCTIONS
# ============================================================================

# Color codes (matching setup-haunt.sh purple theme)
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly MAGENTA='\033[1;35m'
readonly BOLD='\033[1m'
readonly NC='\033[0m' # No Color

# Output functions
success() {
    echo -e "${GREEN}✓${NC} $1"
}

info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1" >&2
}

section() {
    echo ""
    echo -e "${BOLD}${MAGENTA}═══════════════════════════════════════════${NC}"
    echo -e "${BOLD}${PURPLE}  👻 $1${NC}"
    echo -e "${BOLD}${MAGENTA}═══════════════════════════════════════════${NC}"
    echo ""
}

# ============================================================================
# CONFIGURATION
# ============================================================================

# Global directories
GLOBAL_AGENTS_DIR="${HOME}/.claude/agents"
GLOBAL_RULES_DIR="${HOME}/.claude/rules"
GLOBAL_SKILLS_DIR="${HOME}/.claude/skills"
GLOBAL_COMMANDS_DIR="${HOME}/.claude/commands"

# Project directory
PROJECT_HAUNT_DIR=".haunt"

# Backup configuration
BACKUP_DIR="${HOME}"
BACKUP_TIMESTAMP=$(date +%Y-%m-%d-%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/haunt-backup-${BACKUP_TIMESTAMP}.tar.gz"

# Default options
MODE="partial"  # partial or full
CREATE_BACKUP=false
FORCE=false

# ============================================================================
# HELP MESSAGE
# ============================================================================

show_help() {
    cat << EOF
${BOLD}${MAGENTA}Cleanse - Haunt Uninstall Script${NC}

Cleanse the Haunt framework from your system.

${BOLD}Usage:${NC}
  bash cleanse.sh [options]

${BOLD}Options:${NC}
  --partial       Remove ~/.claude/gco-* artifacts only (default)
  --full          Remove ~/.claude/gco-* AND .haunt/ directory
  --backup        Create backup before deletion
  --force         Skip confirmation prompts (dangerous!)
  --help          Show this help message

${BOLD}Examples:${NC}
  # Interactive partial cleanse with backup
  bash cleanse.sh --partial --backup

  # Full cleanse (removes everything)
  bash cleanse.sh --full --backup

  # Force cleanse without prompts (use carefully!)
  bash cleanse.sh --full --force

${BOLD}Safety Features:${NC}
  - Checks for uncommitted work in .haunt/
  - Shows preview of what will be deleted
  - Requires explicit confirmation (unless --force)
  - Optional backup creation

${BOLD}Restore from Backup:${NC}
  cd ~
  tar -xzf ~/haunt-backup-YYYY-MM-DD-HHMMSS.tar.gz

EOF
}

# ============================================================================
# ARGUMENT PARSING
# ============================================================================

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --partial)
                MODE="partial"
                shift
                ;;
            --full)
                MODE="full"
                shift
                ;;
            --backup)
                CREATE_BACKUP=true
                shift
                ;;
            --force)
                FORCE=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                echo ""
                show_help
                exit 1
                ;;
        esac
    done
}

# ============================================================================
# DETECTION FUNCTIONS
# ============================================================================

# Check if .haunt/ has uncommitted changes or in-progress work
check_uncommitted_work() {
    local has_warnings=false

    # Check if .haunt/plans/roadmap.md exists
    if [[ ! -f "${PROJECT_HAUNT_DIR}/plans/roadmap.md" ]]; then
        return 0  # No roadmap, nothing to check
    fi

    # Check for git changes in .haunt/
    if git status --porcelain "${PROJECT_HAUNT_DIR}" 2>/dev/null | grep -q .; then
        warning "Uncommitted changes detected in ${PROJECT_HAUNT_DIR}/"
        has_warnings=true
    fi

    # Check for in-progress items in roadmap
    local in_progress_count=$(grep -c "^### 🟡" "${PROJECT_HAUNT_DIR}/plans/roadmap.md" 2>/dev/null || echo "0")
    if [[ "$in_progress_count" -gt 0 ]]; then
        warning "${in_progress_count} requirement(s) marked 🟡 In Progress in roadmap"
        has_warnings=true
    fi

    if [[ "$has_warnings" == "true" ]]; then
        echo ""
        echo -e "${YELLOW}🔮 Recommendation: Finish or commit your work before cleansing.${NC}"
        echo ""
        return 1
    fi

    return 0
}

# Count files to be removed
count_files() {
    local pattern="$1"
    local dir="$2"

    if [[ ! -d "$dir" ]]; then
        echo "0"
        return
    fi

    find "$dir" -maxdepth 1 -name "$pattern" -type f 2>/dev/null | wc -l | tr -d ' '
}

# Count directories to be removed
count_dirs() {
    local pattern="$1"
    local dir="$2"

    if [[ ! -d "$dir" ]]; then
        echo "0"
        return
    fi

    find "$dir" -maxdepth 1 -name "$pattern" -type d 2>/dev/null | wc -l | tr -d ' '
}

# ============================================================================
# PREVIEW FUNCTIONS
# ============================================================================

preview_deletion() {
    section "Preview: What Will Be Cleansed"

    local total_files=0
    local total_dirs=0

    echo -e "${BOLD}Global Artifacts (~/.claude/):${NC}"
    echo ""

    # Agents
    local agent_count=$(count_files "gco-*.md" "$GLOBAL_AGENTS_DIR")
    if [[ "$agent_count" -gt 0 ]]; then
        echo -e "  ${PURPLE}Agents${NC} (${agent_count} files):"
        find "$GLOBAL_AGENTS_DIR" -maxdepth 1 -name "gco-*.md" -type f 2>/dev/null | while read -r file; do
            echo "    - $(basename "$file")"
        done | sort
        echo ""
        total_files=$((total_files + agent_count))
    else
        echo -e "  ${PURPLE}Agents${NC}: None found"
        echo ""
    fi

    # Rules
    local rules_count=$(count_files "gco-*.md" "$GLOBAL_RULES_DIR")
    if [[ "$rules_count" -gt 0 ]]; then
        echo -e "  ${PURPLE}Rules${NC} (${rules_count} files):"
        find "$GLOBAL_RULES_DIR" -maxdepth 1 -name "gco-*.md" -type f 2>/dev/null | while read -r file; do
            echo "    - $(basename "$file")"
        done | sort
        echo ""
        total_files=$((total_files + rules_count))
    else
        echo -e "  ${PURPLE}Rules${NC}: None found"
        echo ""
    fi

    # Skills
    local skills_count=$(count_dirs "gco-*" "$GLOBAL_SKILLS_DIR")
    if [[ "$skills_count" -gt 0 ]]; then
        echo -e "  ${PURPLE}Skills${NC} (${skills_count} directories):"
        find "$GLOBAL_SKILLS_DIR" -maxdepth 1 -name "gco-*" -type d 2>/dev/null | while read -r dir; do
            echo "    - $(basename "$dir")/"
        done | sort
        echo ""
        total_dirs=$((total_dirs + skills_count))
    else
        echo -e "  ${PURPLE}Skills${NC}: None found"
        echo ""
    fi

    # Commands (all .md files in commands dir since they're all GCO-related)
    local commands_count=$(count_files "*.md" "$GLOBAL_COMMANDS_DIR")
    if [[ "$commands_count" -gt 0 ]]; then
        echo -e "  ${PURPLE}Commands${NC} (${commands_count} files):"
        find "$GLOBAL_COMMANDS_DIR" -maxdepth 1 -name "*.md" -type f 2>/dev/null | while read -r file; do
            echo "    - $(basename "$file")"
        done | sort
        echo ""
        total_files=$((total_files + commands_count))
    else
        echo -e "  ${PURPLE}Commands${NC}: None found"
        echo ""
    fi

    # Project artifacts (if full mode)
    if [[ "$MODE" == "full" ]]; then
        echo -e "${BOLD}Project Artifacts (.haunt/):${NC}"
        echo ""
        if [[ -d "$PROJECT_HAUNT_DIR" ]]; then
            echo "  - ${PROJECT_HAUNT_DIR}/plans/"
            echo "  - ${PROJECT_HAUNT_DIR}/completed/"
            echo "  - ${PROJECT_HAUNT_DIR}/progress/"
            echo "  - ${PROJECT_HAUNT_DIR}/tests/"
            echo "  - ${PROJECT_HAUNT_DIR}/docs/"
            echo ""
            total_dirs=$((total_dirs + 1))  # Count .haunt as one directory
        else
            echo "  ${PURPLE}.haunt/${NC}: Not found"
            echo ""
        fi
    fi

    echo -e "${BOLD}Total:${NC} ${total_files} files, ${total_dirs} directories"
    echo ""
}

# ============================================================================
# BACKUP FUNCTIONS
# ============================================================================

create_backup() {
    section "Creating Backup"

    local backup_paths=()

    # Add global artifacts to backup
    [[ -d "$GLOBAL_AGENTS_DIR" ]] && backup_paths+=("$(realpath --relative-to="$HOME" "$GLOBAL_AGENTS_DIR" 2>/dev/null || echo ".claude/agents")")
    [[ -d "$GLOBAL_RULES_DIR" ]] && backup_paths+=("$(realpath --relative-to="$HOME" "$GLOBAL_RULES_DIR" 2>/dev/null || echo ".claude/rules")")
    [[ -d "$GLOBAL_SKILLS_DIR" ]] && backup_paths+=("$(realpath --relative-to="$HOME" "$GLOBAL_SKILLS_DIR" 2>/dev/null || echo ".claude/skills")")
    [[ -d "$GLOBAL_COMMANDS_DIR" ]] && backup_paths+=("$(realpath --relative-to="$HOME" "$GLOBAL_COMMANDS_DIR" 2>/dev/null || echo ".claude/commands")")

    # Add project artifacts if full mode
    if [[ "$MODE" == "full" && -d "$PROJECT_HAUNT_DIR" ]]; then
        backup_paths+=("$PROJECT_HAUNT_DIR")
    fi

    if [[ ${#backup_paths[@]} -eq 0 ]]; then
        warning "No files to backup (nothing installed)"
        return 1
    fi

    info "Backup location: ${BACKUP_FILE}"

    # Create backup using tar
    # Note: We need to handle both home-relative and project-relative paths
    (
        cd "$HOME" && tar -czf "$BACKUP_FILE" \
            --exclude="*.pyc" \
            --exclude="__pycache__" \
            --exclude=".DS_Store" \
            "${backup_paths[@]}" 2>/dev/null
    ) || {
        # If the first approach fails (paths might be project-relative), try alternative
        if [[ "$MODE" == "full" && -d "$PROJECT_HAUNT_DIR" ]]; then
            tar -czf "$BACKUP_FILE" \
                -C "$HOME" .claude/agents .claude/rules .claude/skills .claude/commands 2>/dev/null || true
            tar -czf "$BACKUP_FILE" --append "$PROJECT_HAUNT_DIR" 2>/dev/null || true
        fi
    }

    if [[ -f "$BACKUP_FILE" ]]; then
        local backup_size=$(du -h "$BACKUP_FILE" | cut -f1)
        success "Backup created: ${BACKUP_FILE} (${backup_size})"
        return 0
    else
        error "Backup creation failed"
        return 1
    fi
}

# ============================================================================
# DELETION FUNCTIONS
# ============================================================================

# Remove GCO-prefixed files from a directory
remove_gco_files() {
    local dir="$1"
    local pattern="$2"
    local description="$3"

    if [[ ! -d "$dir" ]]; then
        info "${description}: Directory not found, skipping"
        return 0
    fi

    local count=$(count_files "$pattern" "$dir")
    if [[ "$count" -eq 0 ]]; then
        info "${description}: No files to remove"
        return 0
    fi

    info "Removing ${description} (${count} files)..."
    find "$dir" -maxdepth 1 -name "$pattern" -type f -delete 2>/dev/null || {
        error "Failed to remove some ${description}"
        return 1
    }
    success "Removed ${description}"
}

# Remove GCO-prefixed directories
remove_gco_dirs() {
    local dir="$1"
    local pattern="$2"
    local description="$3"

    if [[ ! -d "$dir" ]]; then
        info "${description}: Directory not found, skipping"
        return 0
    fi

    local count=$(count_dirs "$pattern" "$dir")
    if [[ "$count" -eq 0 ]]; then
        info "${description}: No directories to remove"
        return 0
    fi

    info "Removing ${description} (${count} directories)..."
    find "$dir" -maxdepth 1 -name "$pattern" -type d -exec rm -rf {} + 2>/dev/null || {
        error "Failed to remove some ${description}"
        return 1
    }
    success "Removed ${description}"
}

# Remove all command files (they're all GCO-related)
remove_all_commands() {
    local dir="$GLOBAL_COMMANDS_DIR"

    if [[ ! -d "$dir" ]]; then
        info "Commands: Directory not found, skipping"
        return 0
    fi

    local count=$(count_files "*.md" "$dir")
    if [[ "$count" -eq 0 ]]; then
        info "Commands: No files to remove"
        return 0
    fi

    info "Removing commands (${count} files)..."
    find "$dir" -maxdepth 1 -name "*.md" -type f -delete 2>/dev/null || {
        error "Failed to remove some commands"
        return 1
    }
    success "Removed commands"
}

# Remove project .haunt directory
remove_project_artifacts() {
    if [[ ! -d "$PROJECT_HAUNT_DIR" ]]; then
        info "Project artifacts (.haunt/): Not found, skipping"
        return 0
    fi

    info "Removing project artifacts (.haunt/)..."
    rm -rf "$PROJECT_HAUNT_DIR" 2>/dev/null || {
        error "Failed to remove ${PROJECT_HAUNT_DIR}/"
        return 1
    }
    success "Removed ${PROJECT_HAUNT_DIR}/"
}

# ============================================================================
# CONFIRMATION FUNCTIONS
# ============================================================================

confirm_action() {
    local prompt="$1"

    if [[ "$FORCE" == "true" ]]; then
        info "Force mode enabled, skipping confirmation"
        return 0
    fi

    echo -e "${YELLOW}${prompt}${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]] || [[ "$response" =~ ^[Yy][Ee][Ss]$ ]]; then
        return 0
    else
        return 1
    fi
}

final_confirmation() {
    if [[ "$FORCE" == "true" ]]; then
        info "Force mode enabled, skipping final confirmation"
        return 0
    fi

    echo ""
    echo -e "${RED}${BOLD}⚠️  FINAL WARNING ⚠️${NC}"
    echo ""
    echo "This will permanently delete the files listed above."
    if [[ "$CREATE_BACKUP" == "false" ]]; then
        echo -e "${YELLOW}NO BACKUP will be created. This action CANNOT be undone.${NC}"
    else
        echo "A backup will be created before deletion."
    fi
    echo ""
    echo -e "${YELLOW}Type 'CLEANSE' to proceed (or anything else to abort): ${NC}"
    read -r response

    if [[ "$response" == "CLEANSE" ]]; then
        return 0
    else
        info "Cleanse aborted by user"
        exit 0
    fi
}

# ============================================================================
# MAIN CLEANSE LOGIC
# ============================================================================

perform_cleanse() {
    section "Beginning the Cleansing Ritual"

    local failed=false

    # Create backup if requested
    if [[ "$CREATE_BACKUP" == "true" ]]; then
        if ! create_backup; then
            if confirm_action "Backup failed. Continue without backup? (yes/no): "; then
                warning "Continuing without backup"
            else
                error "Cleanse aborted"
                exit 1
            fi
        fi
    fi

    # Remove global artifacts
    echo ""
    info "Cleansing global spirits from ~/.claude/..."
    echo ""

    remove_gco_files "$GLOBAL_AGENTS_DIR" "gco-*.md" "agents" || failed=true
    remove_gco_files "$GLOBAL_RULES_DIR" "gco-*.md" "rules" || failed=true
    remove_gco_dirs "$GLOBAL_SKILLS_DIR" "gco-*" "skills" || failed=true
    remove_all_commands || failed=true

    # Remove project artifacts if full mode
    if [[ "$MODE" == "full" ]]; then
        echo ""
        info "Cleansing project artifacts (.haunt/)..."
        echo ""
        remove_project_artifacts || failed=true
    fi

    echo ""
    if [[ "$failed" == "true" ]]; then
        warning "Cleanse completed with some failures"
        warning "Some remnants may linger..."
        return 1
    else
        success "The cleansing is complete. Ghost County has been purified."
        if [[ "$CREATE_BACKUP" == "true" && -f "$BACKUP_FILE" ]]; then
            info "Backup saved to: ${BACKUP_FILE}"
        fi
        return 0
    fi
}

# ============================================================================
# MAIN FUNCTION
# ============================================================================

main() {
    # Parse arguments
    parse_arguments "$@"

    # Show banner
    section "Cleanse - Haunt Uninstall"

    echo -e "${MAGENTA}"
    cat << "EOF"
                    .     .
                 .  |\-^-/|   .
                /| } O.=" O { |\
               /╱ \-_ _ _-/    \\
EOF
    echo -e "${NC}"

    # Capitalize first letter of mode (bash 3.2 compatible)
    local mode_display="$(echo "${MODE:0:1}" | tr '[:lower:]' '[:upper:]')${MODE:1}"
    echo -e "${BOLD}Mode:${NC} ${mode_display} Cleanse"
    if [[ "$MODE" == "full" ]]; then
        echo -e "${RED}⚠️  Full mode will remove BOTH ~/.claude/gco-* AND .haunt/${NC}"
    fi
    echo ""

    # Check for uncommitted work (only warn, don't block)
    section "Checking for Restless Spirits"
    if ! check_uncommitted_work; then
        if ! confirm_action "Continue anyway? (yes/no): "; then
            info "Cleanse aborted - tend to your spirits first"
            exit 0
        fi
    else
        success "No uncommitted work detected"
    fi

    # Preview what will be deleted
    preview_deletion

    # Final confirmation
    final_confirmation

    # Perform the cleanse
    perform_cleanse

    echo ""
    section "The Veil Has Been Purified"
    echo ""
    echo "Your repository walks in clarity once more."
    echo ""
    if [[ "$CREATE_BACKUP" == "true" && -f "$BACKUP_FILE" ]]; then
        echo "To restore from backup:"
        echo "  cd ~"
        echo "  tar -xzf ${BACKUP_FILE}"
        echo ""
    fi
    echo "To reinstall Haunt:"
    echo "  bash Haunt/scripts/setup-haunt.sh"
    echo ""
}

# Run main function
main "$@"
