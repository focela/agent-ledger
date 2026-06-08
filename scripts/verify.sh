#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright 2026 Focela

set -euo pipefail
source "$(dirname "$0")/lib.sh"

status=0

if command -v shellcheck >/dev/null 2>&1; then
  info "shellcheck scripts"
  # severity=warning drops SC1091 (cannot follow the dynamically sourced lib.sh).
  shellcheck --severity=warning "$ROOT"/scripts/*.sh || status=1
else
  info "shellcheck not found; skipping"
fi

if command -v hadolint >/dev/null 2>&1; then
  info "hadolint Dockerfile"
  hadolint "$DOCKER_DIR/Dockerfile" || status=1
else
  info "hadolint not found; skipping"
fi

info "compose config"
compose config -q || status=1

if [ "$status" -eq 0 ]; then
  ok "verify passed"
else
  error "verify failed"
  exit 1
fi
