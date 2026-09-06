# Security Policy

## Scope

This repository holds the `autonomi` Agent Skill: Markdown instructions an AI agent follows to read from, store on, build on and run the Autonomi network through the upstream `ant` command-line client. It builds no custody, key-management or signing tooling of its own. The posture below reflects that.

## Security posture

- **The agent never sees a private key.** The current prototype has the agent work only with public things — wallet addresses, balances, transaction hashes, and status. It never asks for, accepts, reads, prints, logs, transmits, or generates a private key or seed phrase. A paid write needs the wallet's key available to the upstream `ant` tool as `SECRET_KEY`; the person provisions that outside the conversation in the environment where the tool runs, or runs the paid command in their own terminal. This is not an agent-custody substrate. Any future agent-created wallet or custody capability requires a separately approved substrate that keeps secrets outside agent context and provides recovery; ADR-0004 deliberately leaves its location open. If a key appears in agent context by any route, the instruction is to stop, not use or repeat it, and tell the person to create a new wallet and move the funds.
- **Nodes are non-custodial by construction.** A node is given a public address to be paid into (`--rewards-address`) and nothing else; it cannot spend.
- **Spending is approved.** Quote, show, wait by default. The person may lift that explicitly within a limit they set, and every spend is still reported.
- **The token is identified by contract address only**, carried in the skill's *Verified against* table and cross-checked against the official documentation. The agent never names an exchange, bridge, venue, or address from memory.
- **No secrets in the repo.** Never commit a private key, seed phrase, `SECRET_KEY`, or `AUTONOMI_WALLET_KEY` in code, examples, fixtures, or logs. If one is exposed, treat it as compromised: create a new wallet, move the funds, and remove the secret from history.
- **Install is detect-first and read-before-run.** The agent uses an existing working `ant` when present. Otherwise it fetches the official installer and reads it before running it (never `curl | sh`), or takes a manual path that verifies the release archive against the published `SHA256SUMS.txt`. Later `ant update` operations verify the release's ML-DSA-65 signature against a key built into the binary. The installer scripts themselves do not verify checksums today; the skill says so rather than claiming otherwise.
- **Source-bound, with no invented Autonomi surface.** Autonomi-specific commands, flags, constants, figures, and install behaviour carry explicit provenance under ADR-0006. Temporary team-confirmed exceptions are labelled pending upstream authority. Ordinary operating-system and shell behaviour is not presented as an Autonomi fact and must be checked for every claimed platform. The current Windows path is source-read but untested, as recorded in `planning/HANDOFF.md`.
- **Distribution verification is a required target, not a current guarantee.** Upstream releases provide ML-DSA-65 / FIPS-204 signatures and `SHA256SUMS`, but the script-based install route does not verify them before execution. Until every supported route performs and proves checksum/signature verification, contributors and documentation must not claim universally verified delivery (ADR-0008).
- **The node-management daemon stays on loopback.** It has no authentication; the skill never exposes it.

## Reporting a vulnerability

Please **do not open a public issue** for a security problem.

Report privately via GitHub's **"Report a vulnerability"** (the repository **Security** tab → private vulnerability reporting). <!-- Maintainers: add a direct security contact email here if preferred. -->

Include what you found, how to reproduce it, and the impact. We'll acknowledge, investigate, and coordinate a fix and disclosure.

## Especially valuable to report

- Any instruction — or any plausible reading of one — that would lead an agent to request, handle, generate, store, log or transmit a private key or seed phrase.
- Any path by which a spend could happen without the person's approval, or a public upload without the person choosing public.
- A venue, address or price the skill could be read as supplying from memory rather than from the verified table or a fetched official page.
- Invented or unverifiable commands, flags or figures; install or uninstall steps that mutate a system unexpectedly; anything that would make the agent work around a blocked download rather than stop.
- Anything that would break safe distribution — bad frontmatter, a stale install path, or a failure of the checksum path.
