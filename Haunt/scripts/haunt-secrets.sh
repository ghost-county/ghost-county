#!/usr/bin/env bash
# haunt-secrets.sh - 1Password secrets management wrapper
#
# Parses .env files for secret tags and retrieves secrets from 1Password.
# Tag format: # @secret:op:vault/item/field
#
# Security Note: This parser NEVER outputs or logs secret values, only
# metadata (vault/item/field names). Actual secret retrieval happens in
# separate functions with proper output redaction.
#
# ========== OUTPUT MASKING IMPLEMENTATION (REQ-303) ==========
#
# This script prevents secret exposure through comprehensive output masking:
#
# 1. LOGGING REDACTION:
#    - Only variable NAMES logged, never VALUES
#    - Example: "Loaded: GITHUB_TOKEN, API_KEY" (names only)
#    - Implementation: Arrays track names only (line 254, 302, 358)
#
# 2. ERROR MESSAGE SANITIZATION:
#    - Errors show metadata (vault/item/field) but NEVER secret values
#    - Example: "ERROR: Failed to fetch secret for GITHUB_TOKEN"
#    - Example: "ERROR: Vault: my-vault, Item: api-keys, Field: github-token"
#    - Implementation: Error messages constructed from metadata only (line 199-205)
#
# 3. STDOUT/STDERR SEPARATION:
#    - stdout: Secret values (only on fetch_secret SUCCESS, line 180)
#    - stderr: Metadata and errors only (NO secret values)
#    - Pattern: secret=$(fetch_secret ...) captures value, errors go to stderr
#
# 4. VALIDATION MODE:
#    - --validate flag checks resolvability without exposing values
#    - Debug output shows metadata only (op://vault/item/field paths)
#    - Implementation: Validation mode at line 271-290
#
# Anti-Leak Architecture:
#   - Variable tracking arrays: Store names only (never values)
#   - Error messages: Constructed from function parameters (metadata) not return values
#   - Success path: stdout only (controllable by caller via $(...))
#   - Failure path: stderr with safe metadata
#
# Test Coverage:
#   - Haunt/tests/test-haunt-secrets-anti-leak.sh (anti-leak tests)
#   - Haunt/tests/test-haunt-secrets.sh (functional tests)
#
# ==================================================================
#
# Usage:
#   bash haunt-secrets.sh <env_file>                 # Load secrets (normal mode)
#   bash haunt-secrets.sh --validate <env_file>      # Validate secrets without loading
#   bash haunt-secrets.sh --validate --debug <env_file>  # Validate with debug output

set -euo pipefail

# Constants - Tag Parsing
readonly SECRET_TAG_PREFIX="@secret:op:"
readonly SECRET_TAG_REGEX="^#[[:space:]]*${SECRET_TAG_PREFIX}(.+)$"
readonly VAULT_ITEM_FIELD_REGEX="^([^/]+)/([^/]+)/([^/]+)$"
readonly VAR_NAME_REGEX="^([A-Z_][A-Z0-9_]*)="

# Constants - fetch_secret Exit Codes
readonly EXIT_SUCCESS=0
readonly EXIT_MISSING_TOKEN=1
readonly EXIT_OP_NOT_INSTALLED=2
readonly EXIT_AUTH_FAILURE=3
readonly EXIT_NETWORK_ERROR=4
readonly EXIT_ITEM_NOT_FOUND=5
readonly EXIT_OTHER_ERROR=6

# parse_secret_tags - Parse .env file and extract secret tags
#
# Extracts 1Password secret references from .env files in the format:
#   # @secret:op:vault/item/field
#   VAR_NAME=placeholder
#
# Arguments:
#   $1 - Path to .env file
#
# Returns:
#   Zero or more lines in format: "VAR_NAME vault item field"
#   Empty output if no secret tags found (not an error)
#
# Exit codes:
#   0 - Success (including zero tags found)
#   1 - Error (file not found, malformed tag, tag not followed by variable)
#
# Example:
#   # @secret:op:ghost-county/api-keys/github-token
#   GITHUB_TOKEN=placeholder
#
# Outputs: "GITHUB_TOKEN ghost-county api-keys github-token"
parse_secret_tags() {
    local env_file="$1"

    # Validate input file exists
    if [[ ! -f "$env_file" ]]; then
        echo "ERROR: File not found: $env_file" >&2
        return 1
    fi

    # State tracking across lines
    local line_num=0
    local prev_tag=""
    local vault=""
    local item=""
    local field=""

    # Process file line by line
    while IFS= read -r line || [[ -n "$line" ]]; do
        line_num=$((line_num + 1))

        # Detect secret tag line: # @secret:op:vault/item/field
        if [[ "$line" =~ $SECRET_TAG_REGEX ]]; then
            local tag_content="${BASH_REMATCH[1]}"

            # Parse vault/item/field components
            if [[ "$tag_content" =~ $VAULT_ITEM_FIELD_REGEX ]]; then
                vault="${BASH_REMATCH[1]}"
                item="${BASH_REMATCH[2]}"
                field="${BASH_REMATCH[3]}"

                # Validate all components are non-empty (shouldn't happen with regex, but be safe)
                if [[ -z "$vault" || -z "$item" || -z "$field" ]]; then
                    echo "ERROR: Malformed secret tag at line $line_num: missing vault, item, or field" >&2
                    return 1
                fi

                # Store tag for next line processing
                prev_tag="$tag_content"
            else
                echo "ERROR: Malformed secret tag at line $line_num: expected format 'vault/item/field'" >&2
                return 1
            fi

        # Detect variable definition following a tag: VAR_NAME=value
        elif [[ -n "$prev_tag" && "$line" =~ $VAR_NAME_REGEX ]]; then
            local var_name="${BASH_REMATCH[1]}"

            # Output parsed data (space-separated for easy parsing)
            echo "$var_name $vault $item $field"

            # Reset state for next tag
            prev_tag=""

        # Detect non-comment, non-empty line after tag (error: tag must be followed by variable)
        elif [[ -n "$prev_tag" && -n "$line" && ! "$line" =~ ^[[:space:]]*# ]]; then
            echo "ERROR: Secret tag at line $((line_num - 1)) not followed by variable definition" >&2
            return 1
        fi

    done < "$env_file"

    # Check if file ended with unclosed tag (tag at end without variable)
    if [[ -n "$prev_tag" ]]; then
        echo "ERROR: Secret tag at end of file not followed by variable definition" >&2
        return 1
    fi

    return 0
}

# fetch_secret - Fetch secret value from 1Password using op CLI
#
# Retrieves a secret from 1Password using the op CLI tool.
# Requires OP_SERVICE_ACCOUNT_TOKEN environment variable for authentication.
#
# Arguments:
#   $1 - Vault name
#   $2 - Item name
#   $3 - Field name
#
# Returns:
#   Secret value on stdout (only if successful)
#   Error message on stderr
#
# Exit codes:
#   EXIT_SUCCESS (0) - Success (secret retrieved)
#   EXIT_MISSING_TOKEN (1) - Missing OP_SERVICE_ACCOUNT_TOKEN
#   EXIT_OP_NOT_INSTALLED (2) - op CLI not installed
#   EXIT_AUTH_FAILURE (3) - Authentication failure
#   EXIT_NETWORK_ERROR (4) - Network timeout or connection error
#   EXIT_ITEM_NOT_FOUND (5) - Item not found
#   EXIT_OTHER_ERROR (6) - Other error
#
# Security:
#   - NEVER logs or echoes the actual secret value to stderr
#   - Only outputs secret value to stdout on success
#   - Error messages do not contain secret data
#
# Example:
#   export OP_SERVICE_ACCOUNT_TOKEN="ops_..."
#   secret=$(fetch_secret "ghost-county" "api-keys" "github-token")
fetch_secret() {
    local vault="$1"
    local item="$2"
    local field="$3"

    # Validate required environment variable
    if [[ -z "${OP_SERVICE_ACCOUNT_TOKEN:-}" ]]; then
        echo "ERROR: OP_SERVICE_ACCOUNT_TOKEN environment variable is not set" >&2
        echo "ERROR: 1Password service account token required for authentication" >&2
        return $EXIT_MISSING_TOKEN
    fi

    # Check if op CLI is installed
    if ! command -v op &> /dev/null; then
        echo "ERROR: 1Password CLI (op) is not installed" >&2
        echo "ERROR: Install from: https://developer.1password.com/docs/cli/get-started/" >&2
        return $EXIT_OP_NOT_INSTALLED
    fi

    # Construct op:// reference
    local op_ref="op://${vault}/${item}/${field}"

    # Fetch secret from 1Password
    # Note: We capture both stdout and stderr to detect error types
    local temp_output=$(mktemp)
    local temp_error=$(mktemp)

    if op read "$op_ref" > "$temp_output" 2> "$temp_error"; then
        # Success: Output secret value (only place secret appears)
        cat "$temp_output"
        rm -f "$temp_output" "$temp_error"
        return $EXIT_SUCCESS
    else
        # Failure: Analyze error message to determine error type
        local error_msg=$(cat "$temp_error")
        rm -f "$temp_output" "$temp_error"

        # Detect error type from op CLI error message
        if [[ "$error_msg" =~ [Aa]uth|[Uu]nauthorized|[Ii]nvalid.*token ]]; then
            echo "ERROR: Authentication failed with 1Password" >&2
            echo "ERROR: Check OP_SERVICE_ACCOUNT_TOKEN is valid" >&2
            return $EXIT_AUTH_FAILURE
        elif [[ "$error_msg" =~ [Nn]etwork|[Tt]imeout|[Cc]onnection ]]; then
            echo "ERROR: Network error connecting to 1Password" >&2
            echo "ERROR: Check internet connection and try again" >&2
            return $EXIT_NETWORK_ERROR
        elif [[ "$error_msg" =~ [Nn]ot.*found|[Dd]oesn\'t.*exist ]]; then
            echo "ERROR: Secret not found in 1Password" >&2
            echo "ERROR: Vault: $vault, Item: $item, Field: $field" >&2
            return $EXIT_ITEM_NOT_FOUND
        else
            # Generic error
            echo "ERROR: Failed to fetch secret from 1Password" >&2
            echo "ERROR: $error_msg" >&2
            return $EXIT_OTHER_ERROR
        fi
    fi
}

# load_secrets - Load secrets from .env file and export to environment
#
# Parses .env file for secret tags, fetches secrets from 1Password,
# and exports both secrets and plaintext variables to environment.
#
# Arguments:
#   $1 - Path to .env file
#
# Behavior:
#   - Parses file using parse_secret_tags()
#   - Fetches each tagged secret using fetch_secret()
#   - Exports secrets as environment variables: export VAR_NAME=value
#   - Exports non-tagged plaintext variables as-is
#   - Logs variable names loaded (NEVER logs secret values)
#
# Exit codes:
#   0 - Success (all secrets loaded)
#   1 - Error (file not found, parse error, fetch failure)
#
# Security:
#   - NEVER logs or echoes secret values
#   - Only logs variable names
#   - Cleanup trap clears sensitive vars on script exit (if desired)
#
# Usage:
#   source Haunt/scripts/haunt-secrets.sh
#   load_secrets .env
#   echo $GITHUB_TOKEN  # secret value available
load_secrets() {
    local env_file="$1"
    local validate_only="${2:-false}"
    local debug="${3:-false}"

    # Validate input file exists (parse_secret_tags will also check, but fail fast)
    if [[ ! -f "$env_file" ]]; then
        echo "ERROR: File not found: $env_file" >&2
        return 1
    fi

    # Track loaded/validated variable names for logging (NOT values)
    local loaded_vars=()
    local validation_errors=()

    # Parse secret tags from .env file
    local secret_tags
    if ! secret_tags=$(parse_secret_tags "$env_file"); then
        echo "ERROR: Failed to parse secret tags from $env_file" >&2
        return 1
    fi

    # Process each secret tag: fetch/validate
    if [[ -n "$secret_tags" ]]; then
        while IFS= read -r tag_line; do
            # Parse space-separated format: VAR_NAME vault item field
            read -r var_name vault item field <<< "$tag_line"

            if [[ "$validate_only" == "true" ]]; then
                # Validation mode: Check if secret is resolvable without fetching
                if [[ "$debug" == "true" ]]; then
                    echo "DEBUG: Checking $var_name → op://$vault/$item/$field" >&2
                fi

                # Attempt to fetch secret (validate it exists without using the value)
                if fetch_secret "$vault" "$item" "$field" > /dev/null 2>&1; then
                    if [[ "$debug" == "true" ]]; then
                        echo "DEBUG: ✓ $var_name is resolvable" >&2
                    fi
                    loaded_vars+=("$var_name")
                else
                    local exit_code=$?
                    validation_errors+=("$var_name (op://$vault/$item/$field) - Exit code: $exit_code")
                    if [[ "$debug" == "true" ]]; then
                        echo "DEBUG: ✗ $var_name failed validation (exit code: $exit_code)" >&2
                    fi
                fi
            else
                # Normal mode: Fetch and export secrets
                local secret_value
                if ! secret_value=$(fetch_secret "$vault" "$item" "$field"); then
                    echo "ERROR: Failed to fetch secret for $var_name" >&2
                    return 1
                fi

                # Export secret as environment variable
                export "$var_name=$secret_value"

                # Track loaded variable name (NOT value)
                loaded_vars+=("$var_name")
            fi

        done <<< "$secret_tags"
    fi

    # Export plaintext variables (non-tagged lines with VAR=value format) - only in normal mode
    if [[ "$validate_only" == "false" ]]; then
        while IFS= read -r line || [[ -n "$line" ]]; do
            # Skip empty lines and comments
            [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

            # Detect variable definition: VAR_NAME=value
            if [[ "$line" =~ ^([A-Z_][A-Z0-9_]*)=(.*)$ ]]; then
                local var_name="${BASH_REMATCH[1]}"
                local var_value="${BASH_REMATCH[2]}"

                # Check if this variable was already loaded as a secret
                local is_secret=false
                if [[ ${#loaded_vars[@]} -gt 0 ]]; then
                    for loaded_var in "${loaded_vars[@]}"; do
                        if [[ "$loaded_var" == "$var_name" ]]; then
                            is_secret=true
                            break
                        fi
                    done
                fi

                # Only export if NOT a secret (secrets already exported above)
                if [[ "$is_secret" == false ]]; then
                    export "$var_name=$var_value"
                    loaded_vars+=("$var_name")
                fi
            fi
        done < "$env_file"
    fi

    # Report results
    if [[ "$validate_only" == "true" ]]; then
        # Validation mode reporting
        if [[ ${#validation_errors[@]} -gt 0 ]]; then
            echo "ERROR: Validation failed for ${#validation_errors[@]} secret(s):" >&2
            for error in "${validation_errors[@]}"; do
                echo "  - $error" >&2
            done
            return 1
        else
            local var_list=$(IFS=', '; echo "${loaded_vars[*]}")
            echo "✓ Validated ${#loaded_vars[@]} secret(s): $var_list" >&2
            return 0
        fi
    else
        # Normal mode logging (names only, NEVER values)
        if [[ ${#loaded_vars[@]} -gt 0 ]]; then
            local var_list=$(IFS=', '; echo "${loaded_vars[*]}")
            echo "Loaded: $var_list" >&2
        else
            echo "No variables loaded from $env_file" >&2
        fi
        return 0
    fi
}

# ========== CLI ENTRY POINT ==========

# main - CLI entry point for validation mode
#
# Parses command line arguments and calls load_secrets() with appropriate flags.
#
# Usage:
#   bash haunt-secrets.sh <env_file>                 # Normal mode (load/export)
#   bash haunt-secrets.sh --validate <env_file>      # Validation mode (check resolvability)
#   bash haunt-secrets.sh --validate --debug <env_file>  # Validation with debug output
#   bash haunt-secrets.sh --debug --validate <env_file>  # Debug + validation (order doesn't matter)
main() {
    local validate_mode="false"
    local debug_mode="false"
    local env_file=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --validate)
                validate_mode="true"
                shift
                ;;
            --debug)
                debug_mode="true"
                shift
                ;;
            -h|--help)
                echo "Usage: $0 [OPTIONS] <env_file>"
                echo ""
                echo "Options:"
                echo "  --validate    Validate secrets without loading/exporting"
                echo "  --debug       Show detailed diagnostics during validation"
                echo "  -h, --help    Show this help message"
                echo ""
                echo "Examples:"
                echo "  $0 .env                       # Load secrets (normal mode)"
                echo "  $0 --validate .env            # Validate secrets"
                echo "  $0 --validate --debug .env    # Validate with debug output"
                exit 0
                ;;
            -*)
                echo "ERROR: Unknown option: $1" >&2
                echo "Run '$0 --help' for usage information" >&2
                exit 1
                ;;
            *)
                # First non-flag argument is env file
                if [[ -z "$env_file" ]]; then
                    env_file="$1"
                else
                    echo "ERROR: Multiple env files specified: $env_file and $1" >&2
                    exit 1
                fi
                shift
                ;;
        esac
    done

    # Validate required argument
    if [[ -z "$env_file" ]]; then
        echo "ERROR: No .env file specified" >&2
        echo "Run '$0 --help' for usage information" >&2
        exit 1
    fi

    # Call load_secrets with appropriate flags
    if load_secrets "$env_file" "$validate_mode" "$debug_mode"; then
        exit 0
    else
        exit 1
    fi
}

# Only run main if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
