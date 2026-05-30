.PHONY: help up down logs secret verify

help:
	@printf '%s\n' \
		'Targets:' \
		'  make up      Build and start the stack' \
		'  make down    Stop the stack' \
		'  make logs    Follow container logs' \
		'  make secret  Print AGENT_LEDGER_SECRET' \
		'  make verify  Lint scripts and validate compose config'

up:
	./scripts/up.sh

down:
	./scripts/down.sh

logs:
	./scripts/logs.sh

secret:
	./scripts/secret.sh

verify:
	./scripts/verify.sh
