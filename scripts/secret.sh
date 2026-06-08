#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright 2026 Focela

set -euo pipefail
source "$(dirname "$0")/lib.sh"
SECRET="$(read_agent_ledger_secret)"
if [ -z "$SECRET" ]; then
  error "secret not available. Run: make up"
  exit 1
fi
echo "AGENT_LEDGER_SECRET=$SECRET"
