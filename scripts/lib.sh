#!/usr/bin/env bash
# Shared variables and helpers; sourced by scripts in this directory.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE_FILE="$ROOT/docker/compose.yaml"
DOCKER_DIR="$ROOT/docker"
export ROOT COMPOSE_FILE DOCKER_DIR

info()  { echo "[agent-ledger] $*"; }
ok()    { echo "[agent-ledger] OK: $*"; }
error() { echo "[agent-ledger] ERROR: $*" >&2; }

compose() {
  docker compose --project-directory "$DOCKER_DIR" -f "$COMPOSE_FILE" "$@"
}

# Strip docker exec line endings from the HMAC secret.
read_agent_ledger_secret() {
  # Single quotes are intentional: the variable expands in the container shell.
  # shellcheck disable=SC2016
  compose exec -T agent-ledger \
    sh -c 'cat "${AGENT_LEDGER_HMAC_FILE:-/data/.hmac}"' 2>/dev/null \
    | tr -d '\n\r' || true
}
