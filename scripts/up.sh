#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright 2026 Focela

set -euo pipefail
source "$(dirname "$0")/lib.sh"

if ! command -v docker >/dev/null 2>&1; then
  error "Docker not found. Install: https://docs.docker.com/get-docker/"
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  error "curl not found. Install curl before running make up"
  exit 1
fi

info "Building and starting agent-ledger..."
compose up -d --build

info "Waiting for health check..."
for _ in $(seq 1 60); do
  curl -fsS http://127.0.0.1:3111/agent-ledger/livez >/dev/null 2>&1 && break
  sleep 2
done

if curl -fsS http://127.0.0.1:3111/agent-ledger/livez >/dev/null 2>&1; then
  ok "Server ready. Viewer: http://localhost:3113"
else
  error "server not ready. Run: make logs"
  exit 1
fi

echo ""
SECRET="$(read_agent_ledger_secret)"
if [ -n "$SECRET" ]; then
  echo "AGENT_LEDGER_SECRET=$SECRET"
else
  info "secret not yet available. Run: make secret"
fi
