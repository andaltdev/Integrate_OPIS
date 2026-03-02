#!/usr/bin/env bash
# clone-all.sh - Idempotent script to clone all OPIS repositories
# Usage: ./scripts/clone-all.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

ADO_BASE="git@ssh.dev.azure.com:v3/intappdevops/Integrate_OPIS"

# ADO repositories (18)
ADO_REPOS=(
  integrate-opis-argo-applications
  opis-atom-cloud
  opis-atom-cloud-self-service
  opis-availability-tests
  opis-boomi-api
  opis-boomi-mcp
  opis-cds-agent
  opis-cds-agent-dto
  opis-connector-all
  opis-db-provisioner
  opis-ips
  opis-notification-service
  opis-observability
  opis-process-reporting-widget
  opis-shared-library
  opis-ui-service
  opis-vault-migration-tool
  opis-web
)

# GitHub repositories
GITHUB_REPOS=(
  "https://github.com/andaltdev/opis-notification-service-next.git"
)

clone_or_skip() {
  local url="$1"
  local name="$2"
  local dest="$ROOT_DIR/$name"

  if [ -d "$dest" ]; then
    echo "SKIP  $name (already exists)"
  else
    echo "CLONE $name"
    git clone "$url" "$dest"
  fi
}

echo "=== Cloning OPIS repositories ==="
echo "Root: $ROOT_DIR"
echo ""

# Clone ADO repos
for repo in "${ADO_REPOS[@]}"; do
  clone_or_skip "$ADO_BASE/$repo" "$repo"
done

# Clone GitHub repos
for url in "${GITHUB_REPOS[@]}"; do
  name=$(basename "$url" .git)
  clone_or_skip "$url" "$name"
done

echo ""
echo "=== Done ==="
