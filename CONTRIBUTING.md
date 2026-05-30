# Contributing

This guide defines the contribution workflow for agent-ledger. It covers
branches, commit messages, pull requests, code review, and issue reporting.

## Before you start

- Search existing issues and pull requests before opening a new one.
- Keep changes focused on one problem or feature.
- Include documentation updates when behavior or configuration changes.
- Use small pull requests when possible.

## Branches

Create `<type>/AGL-N` branches from the latest `main`. Create
`<type>/AGL-N_M` cherry-pick branches from the latest `develop`.

Branch names include the Jira ticket number (`AGL-N`):

| Pattern | Use case |
|---------|----------|
| `<type>/AGL-N` | Targeting `main` |
| `<type>/AGL-N_M` | Cherry-pick targeting `develop` (M = test cycle) |

`<type>` is one of:

| Type | Use case |
|------|----------|
| `feature` | New feature or capability |
| `fix` | Bug fix |
| `docs` | Documentation change |
| `refactor` | Internal refactor without behavior change |
| `perf` | Performance improvement |
| `test` | Test addition or fix |
| `ci` | CI/CD pipeline change |
| `build` | Build system or dependency change |
| `chore` | Maintenance task (deps, config, repo housekeeping) |

> Branch names use `feature`; commit messages use `feat`. These are different tokens.

`N` is the Jira ticket number. `M` starts at `1` and increments by one for each
QA (Quality Assurance) test cycle on `develop`. The change description belongs
in the Jira ticket, not in the branch name.

Examples:

- `feature/AGL-12`
- `fix/AGL-34`
- `chore/AGL-1`
- `chore/AGL-1_1` (first cherry-pick to `develop`)

## Commit messages

This project follows [Conventional Commits](https://www.conventionalcommits.org).

```text
<type>[optional scope]: <description>
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

## Pull requests

Each ticket uses two pull requests:

1. `<type>/AGL-N` to `main` (production target).
2. `<type>/AGL-N_M` to `develop` (commits cherry-picked from `<type>/AGL-N` for QA).

See the [Branches](#branches) section for valid `<type>` values.

If QA finds a bug, apply the fix on `<type>/AGL-N`. Then create
`<type>/AGL-N_{M+1}` (increment `M` by one) and cherry-pick the fix to `develop`.

Before opening a pull request:

1. Rebase onto the latest target branch (`main` or `develop`).
2. Run local checks with `make verify` when the target is available.
3. If deployment files changed, verify the service starts.
4. Update documentation for user-facing changes.

PR title format:

```text
[COMPANY] [TARGET] AGL-N Imperative description
```

- `COMPANY`: `Focela` for internal team contributions; `Community` for individual
  or external contributors.
- `TARGET`: the destination branch (`MAIN` or `DEV`).

Examples:

- `[Focela] [MAIN] AGL-12 Add OpenTelemetry tracing`
- `[Focela] [DEV] AGL-12 Add OpenTelemetry tracing`
- `[Community] [MAIN] AGL-12 Add OpenTelemetry tracing`

Each pull request must include:

- A description of the change.
- Key implementation details.
- Test results as a screenshot of the command output. Crop to the output
  area only (no full desktop). Width must be between 800 px and 1200 px.
  The text must be readable directly in the PR without clicking to enlarge.
- A cross-reference to the matching main or develop PR.
- A link to the Jira ticket.

## Code review

- At least one maintainer approval is required before merge.
- Address review comments or explain why no change is needed.
- Note any follow-up work in the PR description or as a comment.
- Squash merge is the default for `main`. `develop` accepts squash or merge.

## Reporting issues

Use GitHub issues for bugs and feature requests. When reporting a bug, include
steps to reproduce, expected behavior, actual behavior, and environment details.

For security vulnerabilities, follow [SECURITY.md](SECURITY.md).
