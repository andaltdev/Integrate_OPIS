#!/usr/bin/env bash
# postgres-mcp.sh - Credential-validated wrapper for PostgreSQL MCP server
# Reads connection string from .env.postgres and launches the MCP server.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$ROOT_DIR/.env.postgres"

# Validate .env.postgres exists
if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: $ENV_FILE not found." >&2
  echo "Copy .env.postgres.example to .env.postgres and fill in your credentials." >&2
  exit 1
fi

# Enforce file permissions
PERMS=$(stat -f "%Lp" "$ENV_FILE" 2>/dev/null || stat -c "%a" "$ENV_FILE" 2>/dev/null)
if [ "$PERMS" != "600" ]; then
  echo "WARNING: Fixing permissions on $ENV_FILE (was $PERMS, setting to 600)" >&2
  chmod 600 "$ENV_FILE"
fi

# Source the env file
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a

# Validate connection string
if [ -z "${POSTGRES_CONNECTION_STRING:-}" ]; then
  echo "ERROR: POSTGRES_CONNECTION_STRING is not set in $ENV_FILE" >&2
  exit 1
fi

if echo "$POSTGRES_CONNECTION_STRING" | grep -qE '(your_username|your_password|your_host|your_database)'; then
  echo "ERROR: POSTGRES_CONNECTION_STRING contains placeholder values. Update $ENV_FILE with real credentials." >&2
  exit 1
fi

# Launch MCP server
exec npx -y @modelcontextprotocol/server-postgres "$POSTGRES_CONNECTION_STRING"
