# SPDX-License-Identifier: Apache-2.0
# Copyright 2026 Focela
.DEFAULT_GOAL := help
.PHONY: help up down logs secret verify

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN{FS=":.*?## "}{printf "  %-9s %s\n", $$1, $$2}'

up: ## Build and start the stack
	./scripts/up.sh

down: ## Stop the stack
	./scripts/down.sh

logs: ## Follow container logs
	./scripts/logs.sh

secret: ## Print AGENT_LEDGER_SECRET
	./scripts/secret.sh

verify: ## Run shellcheck, hadolint, and compose validation
	./scripts/verify.sh
