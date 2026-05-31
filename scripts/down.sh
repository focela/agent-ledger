#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"

# Stop log watcher before stopping the container.
stop_log_watcher

compose down
ok "agent-ledger stopped"
