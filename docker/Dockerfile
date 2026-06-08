# syntax=docker/dockerfile:1

# SPDX-License-Identifier: Apache-2.0
# Copyright 2026 Focela

# The base image is pinned by tag, not digest: a tag refresh delivers security
# updates, while a pinned digest would freeze them. Pin a digest only when a
# reproducible build matters more than automatic patches.
ARG III_VERSION=0.11.2

FROM iiidev/iii:${III_VERSION} AS iii-image

FROM node:22-slim

ARG AGENT_LEDGER_VERSION=0.1.0
ARG III_VERSION=0.11.2
ARG III_SDK_VERSION=0.11.2

# Leave apt package versions unpinned so base-image refreshes keep them patched.
# hadolint ignore=DL3008
RUN apt-get update \
 && apt-get install -y --no-install-recommends openssl ca-certificates tini gosu curl \
 && rm -rf /var/lib/apt/lists/*

COPY --from=iii-image /app/iii /usr/local/bin/iii

WORKDIR /opt/agent-ledger
RUN printf '{"name":"agent-ledger-deploy","version":"1.0.0","private":true,"overrides":{"iii-sdk":"%s"}}\n' "${III_SDK_VERSION}" > package.json \
 && npm install "@focela/agent-ledger@${AGENT_LEDGER_VERSION}" --omit=optional --no-fund --no-audit \
 && ln -s /opt/agent-ledger/node_modules/.bin/agent-ledger /usr/local/bin/agent-ledger

ENV AGENT_LEDGER_III_VERSION=${III_VERSION} \
    TINI_SUBREAPER=1

LABEL org.opencontainers.image.title="agent-ledger" \
      org.opencontainers.image.description="Self-hosted Docker deployment for the agent-ledger MCP service" \
      org.opencontainers.image.source="https://github.com/focela/agent-ledger" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.vendor="Focela"

COPY --chmod=0755 entrypoint.sh /usr/local/bin/agent-ledger-entrypoint.sh

EXPOSE 3111

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
 CMD curl -fsS http://127.0.0.1:3111/agent-ledger/livez || exit 1

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/agent-ledger-entrypoint.sh"]
