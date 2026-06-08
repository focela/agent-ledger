#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright 2026 Focela

set -euo pipefail
source "$(dirname "$0")/lib.sh"

compose down
ok "agent-ledger stopped"
