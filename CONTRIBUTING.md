# Contributing

This guide covers the development workflow, commit format, and pull request
expectations for agent-ledger.

## Before You Start

- Search existing issues and pull requests before opening a new one.
- Keep changes focused on one problem or feature.
- Include documentation updates when behavior or configuration changes.
- Use small pull requests when possible.

## Branches

Use short-lived branches from the latest `staging` branch. `staging` is the
integration branch; `main` holds the released production state and receives
changes only by promoting `staging`.

Branch naming follows the Jira ticket number (`AGL-N`):

| Pattern | Use case |
|---------|----------|
| `feature/AGL-N` | New feature targeting `staging` |
| `feature/AGL-N_M` | Cherry-pick of `feature/AGL-N` to `develop` for testing |
| `fix/AGL-N` | Bug fix targeting `staging` |
| `chore/AGL-N` | Maintenance task targeting `staging` |

`N` is the Jira ticket number. `M` is the delivery number to `develop`: `1`
for the first cherry-pick, incremented for each re-delivery after a follow-up fix.

## Commit Messages

This project follows [Conventional Commits](https://www.conventionalcommits.org).

```text
<type>(<scope>): <description>
```

Examples:

```text
feat(docker): add health check
fix(scripts): handle missing secret file
docs(readme): add deployment guide link
```

Allowed types:

- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation change
- `refactor` - Internal refactor without behavior change
- `perf` - Performance improvement
- `test` - Test addition or fix
- `ci` - CI/CD pipeline change
- `build` - Build system or dependency change
- `chore` - Maintenance task

## License Headers

New source files start with an SPDX license header. It declares the file's
license in a machine-readable form that license-scanning tools can verify.

Use the comment syntax of the file's language:

```sh
# SPDX-License-Identifier: Apache-2.0
# Copyright 2026 Focela
```

Add the header to source and executable files: shell scripts, `Dockerfile`,
and `Makefile`. Do not add it to documentation, configuration data, `LICENSE`,
or `NOTICE`.

## Pull Requests

Each change is delivered through two pull requests:

1. `feature/AGL-N` to `staging` (integration target).
2. `feature/AGL-N_M` to `develop` (cherry-picked from the first PR for testing).

If testing finds a bug, fix on `feature/AGL-N`, then create `feature/AGL-N_{M+1}`
and cherry-pick the fix to `develop` again.

A release promotes `staging` to `main` through a `staging` -> `main` pull
request.

Before opening a pull request:

1. Rebase the latest target branch (`staging` or `develop`).
2. Run the relevant local checks.
3. Update documentation for user-facing changes.

PR title format:

```text
[COMPANY] [TARGET] AGL-N Imperative description
```

- `COMPANY`: the organization that owns the ticket (`Focela` for internal work,
  `Community` for external contributors).
- `TARGET`: the destination branch (`STG`, `DEV`, or `MAIN`).

Examples:

- `[Focela] [STG] AGL-12 Add OpenTelemetry tracing`
- `[Focela] [DEV] AGL-12 Add OpenTelemetry tracing`
- `[Community] [STG] AGL-12 Add OpenTelemetry tracing`

Each pull request should include:

- A short description of the change.
- A list of notable implementation details.
- Manual or automated test results, with evidence (output, logs, or
  screenshots) where applicable.
- A cross-reference to the matching staging or develop PR.
- A link to the Jira ticket.

## Code Review

- At least one maintainer approval is required before merge.
- Address review comments or explain why a change is not needed.
- Keep follow-up work explicit in the pull request notes.
- Squash merge is the default for `staging` and `develop`; a release promotion
  to `main` may use a merge commit to preserve per-ticket history.

## Reporting Issues

Use GitHub issues for bugs and feature requests. Include enough detail to
reproduce the problem when reporting a bug.

For security vulnerabilities, follow [SECURITY.md](SECURITY.md).
