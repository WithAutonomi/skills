# Security Policy

## Scope

This repository holds the `autonomi` Agent Skill: Markdown instructions an AI agent follows to read from, store on, build on and run the Autonomi network through the upstream `ant` command-line client. It builds no custody, key-management or signing tooling of its own. The posture below reflects that.

## Security posture

- **The agent never sees a private key.** The skill has the agent work only with public things — wallet addresses, balances, transaction hashes, status. It never asks for, accepts, reads, prints, logs or passes a private key or seed phrase, never generates a wallet or key, and never runs a command that does. A paid write needs the wallet's key available to the `ant` tool as `SECRET_KEY`; the person provisions that themselves, once, in the environment the agent's tools run in — or runs the paid command in their own terminal. If a key ever appears in the agent's context by any route, the instruction is to stop, not use or repeat it, and tell the person to create a new wallet and move the funds.
- **Nodes are non-custodial.** A node is given a public address to be paid into (`--rewards-address`) and nothing else; it cannot spend.
- **Spending is approved.** Quote, show, wait by default. The person may lift that explicitly, within a limit they set, and every spend is still reported.
- **The token is identified by contract address only**, carried in the skill's *Verified against* table and cross-checked against the official documentation. The agent never names an exchange, bridge, venue or address from memory.
- **No secrets in the repo.** Never commit a private key, seed phrase or secret in code, examples, fixtures or logs. If one is ever exposed, treat it as compromised: create a new wallet, move the funds, and remove the secret from history.
- **Install is detect-first and read-before-run.** The agent uses an existing `ant` if there is one. Otherwise it fetches the official installer and reads it before running it (never `curl | sh`), or takes a manual path that verifies the release archive against the published `SHA256SUMS.txt`. Later updates go through `ant update`, which verifies the release's ML-DSA-65 signature against a key built into the binary. The installer scripts themselves do not verify checksums today; the skill says so rather than claiming otherwise.
- **Nothing invented.** Commands, flags and figures trace to upstream source or documentation (`source-bindings/autonomi.md`). The agent is told to learn the tool from `ant --help`, to trust the tool over the skill if they differ, and never to guess a flag or route around a blocked host.
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
