# Security policy

## Supported versions

This project is in pre-release development. Security fixes are applied only to
the `main` branch. After the first stable release, the most recent minor
version line will receive security updates.

## Reporting a vulnerability

Do **not** report security vulnerabilities through public GitHub issues.

Report privately through one of these channels:

- GitHub Security Advisories: <https://github.com/focela/agent-ledger/security/advisories/new>
- Email: <security@focela.com.vn>

Include the following information:

- Affected component and version (commit SHA if reporting against `main`)
- Description of the vulnerability and potential impact
- Steps to reproduce
- Suggested fix, if available

We acknowledge reports within 3 business days. We send a status update within
7 days and deliver a fix or mitigation within 30 days, depending on severity.

## Sensitive data

Do not commit secrets, local environment files, or runtime logs. If these
files or paths exist locally, keep them out of version control:

- `.env`, `.env.*`, `docker/.env`, and `docker/.env.server`
- `.mcp.json` and `.cursor/mcp.json`
- The HMAC (Hash-based Message Authentication Code) secret file (default `/data/.hmac`, or `AGENT_LEDGER_HMAC_FILE`)
- Files under `logs/`, except `logs/.gitkeep`

If you commit sensitive data, rotate the affected secret and report the
incident through the private reporting process above.

## Disclosure policy

We follow coordinated disclosure:

1. The reporter submits the vulnerability privately.
2. We acknowledge receipt and begin investigation.
3. We validate the issue and develop a fix with the reporter.
4. We publish the fix and a security advisory.
5. We disclose publicly 30 days after releasing the fix, or sooner if agreed
   with the reporter.

## Scope

The following are considered security issues:

- HMAC secret exposure or weakening
- Authentication or authorization bypass
- Remote code execution inside the container or on the Docker host
- Data exfiltration from the bind-mount data directory
- Vulnerabilities in container build or supply chain

The following are out of scope:

- Vulnerabilities requiring physical access to the host
- Issues in third-party dependencies that are already disclosed and pending
  upstream patch
- Issues only reproducible against unsupported configurations
