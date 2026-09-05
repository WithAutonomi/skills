# Security Policy

## Scope

This repository is an **operator skill**: documentation and skill files that instruct an AI agent to run and use Autonomi nodes. It builds no custody, key-management, or signing tooling. The posture below reflects that.

## Security posture

- **Non-custodial by construction.** Nodes are configured with a **public** wallet (rewards) address only. The skill never generates, stores, requests, logs, or transmits a private key, seed phrase, `SECRET_KEY`, or `AUTONOMI_WALLET_KEY` (ADR-0004). Any future spend/custody capability lives in an out-of-context substrate — never in the agent context, the skill, or this repo.
- **No secrets in the repo.** Never commit a private key or secret in code, examples, fixtures, or logs. If one is ever exposed, treat it as compromised: abandon/rotate the affected address and remove the secret from history.
- **Source-bound, no invented Autonomi surface.** Autonomi-specific commands, flags, constants, figures, and install behaviour carry explicit provenance under ADR-0006; ordinary operating-system/shell observation commands are not presented as Autonomi facts and are reviewed for the supported platforms. Installs are detect-first and non-mutating (ADR-0009). This limits the chance of the skill instructing an unsafe or fabricated action.
- **Distribution verification is a required target, not a current guarantee.** Upstream releases provide ML-DSA-65 / FIPS-204 signatures and `SHA256SUMS`, but the current script-based install route does not verify them before execution. Until every supported route performs and proves checksum/signature verification, contributors and documentation must not claim verified delivery (ADR-0008).

## Reporting a vulnerability

Please **do not open a public issue** for a security problem.

Report privately via GitHub's **"Report a vulnerability"** (the repository **Security** tab → private vulnerability reporting). <!-- Maintainers: add a direct security contact email here if preferred. -->

Include what you found, how to reproduce it, and the impact. We'll acknowledge, investigate, and coordinate a fix and disclosure.

## Especially valuable to report

- Any path where the skill could cause a private key to be generated, stored, logged, or transmitted.
- Any instruction that would put a key on a node or in a repo, or that overstates custody/spend safety.
- Invented or unverifiable commands, flags, or figures, or install/uninstall steps that mutate a system unexpectedly.
- Anything that would break safe distribution — bad metadata or install manifest, or failed signature/checksum verification.
