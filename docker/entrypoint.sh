#!/bin/sh
set -eu

data_dir="${AGENT_LEDGER_DATA_DIR:-/data}"
hmac_file="${AGENT_LEDGER_HMAC_FILE:-$data_dir/.hmac}"
run_as="node:node"
iii_config="/opt/agent-ledger/node_modules/@focela/agent-ledger/dist/iii-config.yaml"

[ -f "$iii_config" ] || { echo "[agent-ledger] ERROR: iii-config path not found: $iii_config" >&2; exit 1; }

mkdir -p "$data_dir"
# Avoid full-tree chown on restart if ownership is already correct.
if [ "$(stat -c '%U' "$data_dir" 2>/dev/null)" != "node" ]; then
  chown -R "$run_as" "$data_dir"
fi

# Comma-separated origins -> YAML list; reject values that would break YAML or CORS policy.
cors_defaults="http://localhost:3111,http://localhost:3113,http://127.0.0.1:3111,http://127.0.0.1:3113"
cors_yaml=$(
  printf '%s\n' "${AGENT_LEDGER_CORS_ORIGINS:-$cors_defaults}" \
  | tr ',' '\n' \
  | while read -r line; do
      origin=$(printf '%s' "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
      [ -n "$origin" ] || continue
      if printf '%s' "$origin" | grep -q '[\"\\]'; then
        echo "[agent-ledger] ERROR: invalid CORS origin (disallowed characters): $origin" >&2
        exit 1
      fi
      origin_scheme="${origin%%//*}"
      if [ "$origin_scheme" = "http:" ] || [ "$origin_scheme" = "https:" ]; then
        printf '          - "%s"\n' "$origin"
      else
        echo "[agent-ledger] ERROR: CORS origin must start with http:// or https://: $origin" >&2
        exit 1
      fi
    done
) || exit 1

cat > "$iii_config" <<EOF
workers:
  - name: iii-http
    config:
      port: 3111
      host: 0.0.0.0
      default_timeout: 180000
      cors:
        allowed_origins:
${cors_yaml}
        allowed_methods: [GET, POST, PUT, DELETE, OPTIONS]
  - name: iii-state
    config:
      adapter:
        name: kv
        config:
          store_method: file_based
          file_path: $data_dir/state_store.db
  - name: iii-queue
    config:
      adapter:
        name: builtin
  - name: iii-pubsub
    config:
      adapter:
        name: local
  - name: iii-cron
    config:
      adapter:
        name: kv
  - name: iii-stream
    config:
      port: 3112
      host: 0.0.0.0
      adapter:
        name: kv
        config:
          store_method: file_based
          file_path: $data_dir/stream_store
  - name: iii-observability
    config:
      enabled: true
      service_name: agent-ledger
      exporter: memory
      sampling_ratio: 1.0
      metrics_enabled: true
      logs_enabled: true
      logs_console_output: true
EOF
chown "$run_as" "$iii_config"

if [ ! -s "$hmac_file" ]; then
  secret="${AGENT_LEDGER_SECRET:-$(openssl rand -hex 32)}"
  umask 077
  printf '%s\n' "$secret" > "$hmac_file"
  chmod 600 "$hmac_file"
  chown "$run_as" "$hmac_file"
  echo "[agent-ledger] HMAC secret initialized at $hmac_file (chmod 600)."
  echo "[agent-ledger] To rotate: delete $hmac_file and restart the container."
fi

AGENT_LEDGER_SECRET="$(cat "$hmac_file")"
export AGENT_LEDGER_SECRET

exec gosu "$run_as" agent-ledger "$@"
