#!/usr/bin/env bash
# Lint deployment files; does not build images or start containers.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v shellcheck >/dev/null 2>&1; then
  echo "[agent-ledger] ERROR: shellcheck is required" >&2
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "[agent-ledger] ERROR: docker is required" >&2
  exit 1
fi

shellcheck -e SC1091 -x "$ROOT/scripts/"*.sh "$ROOT/docker/entrypoint.sh"
docker compose --project-directory "$ROOT/docker" -f "$ROOT/docker/compose.yaml" config --quiet

echo "[agent-ledger] verify: OK"
