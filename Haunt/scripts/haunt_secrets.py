"""
haunt_secrets.py - Tag Parser and 1Password CLI Wrapper for Secret Management

This module provides functionality to:
1. Parse 1Password secret references from .env files (REQ-298)
2. Fetch secrets from 1Password using the `op` CLI (REQ-300)

Secret tags use the format: # @secret:op:vault/item/field

Example:
    # @secret:op:ghost-county/api-keys/github-token
    GITHUB_TOKEN=placeholder

Returns dict mapping variable names to (vault, item, field) tuples.
"""

import os
import re
import subprocess
import logging
from pathlib import Path
from typing import Dict, Tuple


# Configure logging
logger = logging.getLogger(__name__)

# Constants for tag format
SECRET_TAG_PREFIX = "@secret:op:"
EXPECTED_TAG_PARTS = 3
TAG_SEPARATOR = "/"

# Constants for 1Password CLI
OP_CLI_COMMAND = "op"
OP_TOKEN_ENV_VAR = "OP_SERVICE_ACCOUNT_TOKEN"


# ========== EXCEPTION CLASSES ==========

class SecretTagError(Exception):
    """Exception raised for malformed secret tags or invalid .env file structure"""
    pass


class MissingTokenError(Exception):
    """Exception raised when OP_SERVICE_ACCOUNT_TOKEN environment variable is not set"""
    pass


class OpNotInstalledError(Exception):
    """Exception raised when the 1Password CLI (op) is not installed or not found"""
    pass


class AuthenticationError(Exception):
    """Exception raised when 1Password authentication fails"""
    pass


class SecretNotFoundError(Exception):
    """Exception raised when vault, item, or field is not found in 1Password"""
    pass


def _validate_tag_format(tag_content: str, line_num: int, full_line: str) -> None:
    """
    Validate tag format and raise SecretTagError with specific error message.

    Args:
        tag_content: The content after @secret:op:
        line_num: Line number for error message (1-indexed)
        full_line: Full line content for error message

    Raises:
        SecretTagError: Always raises with specific validation error
    """
    parts = tag_content.split(TAG_SEPARATOR)

    if len(parts) != EXPECTED_TAG_PARTS:
        raise SecretTagError(
            f"Malformed secret tag on line {line_num}: '{full_line}'. "
            f"Expected format: # {SECRET_TAG_PREFIX}vault/item/field "
            f"(exactly {EXPECTED_TAG_PARTS} parts separated by '{TAG_SEPARATOR}')"
        )

    # Check if using : instead of /
    if ':' in tag_content:
        raise SecretTagError(
            f"Malformed secret tag on line {line_num}: '{full_line}'. "
            f"Use '{TAG_SEPARATOR}' to separate vault/item/field, not ':'"
        )

    # Generic malformed error
    raise SecretTagError(
        f"Malformed secret tag on line {line_num}: '{full_line}'. "
        f"Expected format: # {SECRET_TAG_PREFIX}vault/item/field"
    )


def parse_secret_tags(env_file: str) -> Dict[str, Tuple[str, str, str]]:
    """
    Parse 1Password secret tags from an .env file.

    Args:
        env_file: Path to .env file containing secret tags

    Returns:
        Dictionary mapping variable names to (vault, item, field) tuples.
        Example: {"GITHUB_TOKEN": ("ghost-county", "api-keys", "github-token")}

    Raises:
        FileNotFoundError: If env_file does not exist
        SecretTagError: If secret tags are malformed or invalid

    Tag Format:
        # @secret:op:vault/item/field
        VAR_NAME=placeholder

    The tag must be immediately followed by a variable assignment on the next line.
    """
    file_path = Path(env_file)

    # Check file exists
    if not file_path.exists():
        raise FileNotFoundError(f"File not found: {env_file}")

    # Read file content
    with open(file_path, 'r') as f:
        lines = f.readlines()

    # Regex patterns for parsing
    tag_prefix_pattern = re.compile(rf'^\s*#\s*{re.escape(SECRET_TAG_PREFIX)}')
    tag_pattern = re.compile(
        rf'^\s*#\s*{re.escape(SECRET_TAG_PREFIX)}'
        r'([a-zA-Z0-9_-]+)/([a-zA-Z0-9_-]+)/([a-zA-Z0-9_-]+)(?:\s|#|$)'
    )
    var_pattern = re.compile(r'^([A-Z_][A-Z0-9_]*)=')

    result: Dict[str, Tuple[str, str, str]] = {}
    i = 0

    while i < len(lines):
        line = lines[i].strip()

        # Check if line contains a secret tag
        if tag_prefix_pattern.match(lines[i]):
            # Extract tag content and remove inline comments
            tag_content = lines[i].split(SECRET_TAG_PREFIX)[1].split('#')[0].strip()

            # Validate full tag format
            tag_match = tag_pattern.match(lines[i])

            if not tag_match:
                # Tag has prefix but invalid format - provide specific error
                _validate_tag_format(tag_content, i + 1, lines[i].strip())

            vault = tag_match.group(1)
            item = tag_match.group(2)
            field = tag_match.group(3)

            # Next line must contain a variable assignment
            if i + 1 >= len(lines):
                raise SecretTagError(
                    f"Secret tag on line {i+1} has no variable assignment following it"
                )

            next_line_idx = i + 1
            next_line = lines[next_line_idx].strip()

            # Skip blank lines is NOT allowed - tag must be immediately before variable
            if not next_line:
                raise SecretTagError(
                    f"Secret tag on line {i+1} must be immediately followed by variable assignment (no blank lines)"
                )

            # Check if next line is a variable assignment
            var_match = var_pattern.match(next_line)
            if not var_match:
                raise SecretTagError(
                    f"Secret tag on line {i+1} is not followed by a variable assignment. "
                    f"Found: '{next_line}'"
                )

            var_name = var_match.group(1)

            # Check for duplicate variable names
            if var_name in result:
                raise SecretTagError(
                    f"Duplicate secret tag for variable '{var_name}' (line {i+1})"
                )

            result[var_name] = (vault, item, field)

            # Skip the variable line since we processed it
            i += 2
            continue

        i += 1

    return result


def fetch_secret(vault: str, item: str, field: str) -> str:
    """
    Fetch a secret value from 1Password using the `op` CLI.

    Args:
        vault: Name of the 1Password vault
        item: Name of the item within the vault
        field: Name of the field within the item

    Returns:
        The secret value as a string

    Raises:
        TypeError: If vault, item, or field are not strings
        ValueError: If vault, item, or field are empty strings
        MissingTokenError: If OP_SERVICE_ACCOUNT_TOKEN environment variable not set
        OpNotInstalledError: If the `op` CLI is not installed or not found
        AuthenticationError: If 1Password authentication fails
        SecretNotFoundError: If vault, item, or field doesn't exist in 1Password

    Security:
        - Secret values are NEVER logged (only metadata like variable names)
        - Secrets exist in memory only, never written to disk
        - Uses OP_SERVICE_ACCOUNT_TOKEN from environment for authentication

    Example:
        >>> token = fetch_secret("my-vault", "api-keys", "github-token")
        >>> # Use token securely...
    """
    # Input validation - type checking
    if not isinstance(vault, str):
        raise TypeError(f"vault must be str, got {type(vault).__name__}")
    if not isinstance(item, str):
        raise TypeError(f"item must be str, got {type(item).__name__}")
    if not isinstance(field, str):
        raise TypeError(f"field must be str, got {type(field).__name__}")

    # Input validation - empty string checking
    if not vault:
        raise ValueError("vault must not be empty")
    if not item:
        raise ValueError("item must not be empty")
    if not field:
        raise ValueError("field must not be empty")

    # Check for service account token
    token = os.environ.get(OP_TOKEN_ENV_VAR)
    if not token:
        raise MissingTokenError(
            f"{OP_TOKEN_ENV_VAR} environment variable is not set. "
            "Set it to your 1Password service account token."
        )

    # Construct op:// reference format
    op_reference = f"op://{vault}/{item}/{field}"

    # Build command
    command = [OP_CLI_COMMAND, "read", op_reference]

    # Execute op CLI command
    try:
        logger.info(f"Fetching secret from 1Password: vault={vault}, item={item}, field={field}")
        result = subprocess.run(
            command,
            capture_output=True,
            text=True,
            check=False  # Don't raise on non-zero exit - we handle errors manually
        )
    except FileNotFoundError as e:
        logger.error(f"1Password CLI (op) not found: {e}")
        raise OpNotInstalledError(
            f"1Password CLI (op) is not installed or not found in PATH. "
            f"Install it from: https://developer.1password.com/docs/cli"
        )

    # Check for success
    if result.returncode == 0:
        secret_value = result.stdout.strip()
        logger.info(f"Successfully fetched secret for vault={vault}, item={item}, field={field}")
        # SECURITY: Never log the actual secret value
        return secret_value

    # Handle errors based on stderr content
    stderr = result.stderr.lower()

    # Authentication errors
    if "invalid service account token" in stderr or "authentication" in stderr:
        logger.error(f"1Password authentication failed: {result.stderr.strip()}")
        raise AuthenticationError(
            f"1Password authentication failed. Check that {OP_TOKEN_ENV_VAR} is valid."
        )

    # Not found errors (vault, item, or field)
    if "not found" in stderr:
        logger.error(f"Secret not found: {result.stderr.strip()}")
        raise SecretNotFoundError(
            f"Secret not found in 1Password. "
            f"Verify vault='{vault}', item='{item}', field='{field}' exist. "
            f"Error: {result.stderr.strip()}"
        )

    # Generic error fallback
    logger.error(f"1Password CLI error: {result.stderr.strip()}")
    raise SecretNotFoundError(
        f"Failed to fetch secret from 1Password. Error: {result.stderr.strip()}"
    )
