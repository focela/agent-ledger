#!/usr/bin/env bash
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

if [ ! -f "$DOCKER_DIR/.env.server" ] && [ -f "$DOCKER_DIR/.env.server.example" ]; then
  cp "$DOCKER_DIR/.env.server.example" "$DOCKER_DIR/.env.server"
  ok "Created docker/.env.server from .env.server.example"
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

# Rotate logs daily; delete files older than 14 days to cap disk usage.
LOG_DIR="$ROOT/logs"
PID_FILE="$LOG_DIR/.log.pid"
mkdir -p "$LOG_DIR"

find "$LOG_DIR" -name 'agent-ledger-*.log' -mtime +14 -delete 2>/dev/null || true

# Stop previous log watcher if still running.
if [ -f "$PID_FILE" ]; then
  OLD_PID="$(cat "$PID_FILE")"
  if ps -p "$OLD_PID" -o args= 2>/dev/null | grep -qF "$LOG_DIR"; then
    pkill -P "$OLD_PID" 2>/dev/null || true
    kill "$OLD_PID" 2>/dev/null || true
  fi
  rm -f "$PID_FILE"
fi

# Restart docker logs at midnight so each day has its own file.
nohup bash -c "
  while true; do
    TODAY=\$(date '+%Y-%m-%d')
    LOG_FILE='$LOG_DIR'/agent-ledger-\${TODAY}.log
    ln -sf agent-ledger-\${TODAY}.log '$LOG_DIR/agent-ledger.log'
    docker compose -f '$COMPOSE_FILE' logs -f --no-color --timestamps --no-log-prefix --tail 0 agent-ledger \
      >> \"\$LOG_FILE\" 2>&1 &
    INNER=\$!
    while [ \"\$(date '+%Y-%m-%d')\" = \"\$TODAY\" ]; do sleep 30; done
    kill \"\$INNER\" 2>/dev/null || true
  done
" &
echo $! > "$PID_FILE"
info "Log file: $LOG_DIR/agent-ledger-$(date '+%Y-%m-%d').log"
