#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
SECRET="$(read_agent_ledger_secret)"
if [ -z "$SECRET" ]; then
  error "secret not available. Run: make up"
  exit 1
fi
echo "AGENT_LEDGER_SECRET=$SECRET"
