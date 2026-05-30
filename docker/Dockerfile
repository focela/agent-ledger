ARG III_VERSION=0.11.2

# iii: agent worker runtime (https://iii.dev); only the binary is copied.
FROM iiidev/iii:${III_VERSION} AS iii-image

FROM node:22-slim

ARG AGENT_LEDGER_VERSION=0.1.0
ARG III_VERSION=0.11.2
ARG III_SDK_VERSION=0.11.2

# DL3008: apt package versions not pinned; base image refresh applies security patches.
# hadolint ignore=DL3008
RUN apt-get update \
 && apt-get install -y --no-install-recommends openssl ca-certificates tini gosu curl \
 && rm -rf /var/lib/apt/lists/*

COPY --from=iii-image /app/iii /usr/local/bin/iii

WORKDIR /opt/agent-ledger

# NPM_TOKEN: set to install @focela/agent-ledger from a private registry.
RUN --mount=type=secret,id=npm_token \
    if [ -f /run/secrets/npm_token ]; then printf '//registry.npmjs.org/:_authToken=%s\n' "$(cat /run/secrets/npm_token)" > .npmrc; fi \
 && printf '{"name":"agent-ledger-deploy","version":"1.0.0","private":true,"overrides":{"iii-sdk":"%s"}}\n' \
      "${III_SDK_VERSION}" > package.json \
 && npm install "@focela/agent-ledger@${AGENT_LEDGER_VERSION}" --omit=optional --no-fund --no-audit \
 && rm -f .npmrc \
 && ln -s /opt/agent-ledger/node_modules/.bin/agent-ledger /usr/local/bin/agent-ledger

ENV AGENT_LEDGER_III_VERSION=${III_VERSION} \
    TINI_SUBREAPER=1

COPY --chmod=0755 entrypoint.sh /usr/local/bin/agent-ledger-entrypoint.sh

EXPOSE 3111

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/agent-ledger-entrypoint.sh"]
