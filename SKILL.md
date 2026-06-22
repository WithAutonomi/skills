---
name: autonomi-operator
description: "Operate Autonomi nodes and earn ANT to a public wallet address where rewards will be paid: install or detect ant, run/manage nodes, monitor health, check read-only rewards balance, and cleanly stop/reset without private keys."
version: 0.1.0
license: MIT OR Apache-2.0
repository: https://github.com/JimCollinson/autonomi-skill
keywords:
  - autonomi
  - ant
  - ant-node
  - node-operation
  - rewards
  - arbitrum-one
  - non-custodial
metadata:
  tier: tier-1-operate-and-earn
  sourceBindingManifest: source-bindings/tier1-operate-and-earn.md
  openclaw:
    requires:
      env: []
      bins:
        - curl
    primaryEnv: ~
    install:
      - kind: shell
        platforms: [linux, macos]
        url: "https://raw.githubusercontent.com/WithAutonomi/ant-client/main/install.sh"
        command: "curl -fsSL https://raw.githubusercontent.com/WithAutonomi/ant-client/main/install.sh | bash"
        bins: [ant]
        verifies: "After install: ant --version && ant --help. If you separately verify release signatures/checksums, report the exact result before use."
      - kind: powershell
        platforms: [windows]
        url: "https://raw.githubusercontent.com/WithAutonomi/ant-client/main/install.ps1"
        command: "irm https://raw.githubusercontent.com/WithAutonomi/ant-client/main/install.ps1 | iex"
        bins: [ant.exe]
        verifies: "After install: ant --version; ant --help. Windows installer notes ML-DSA-65 release-archive verification via ant-keygen."
---

# Autonomi Operator — operate and earn

Autonomi is a post-quantum secure, fully autonomous, peer-to-peer data network for permanent storage. Data is encrypted before it leaves a user's device, split across a global network of everyday machines, and kept available without central servers, accounts, intermediaries, or ongoing storage fees. ANT is the network token that pays people and agents who provide storage.

Running a node does two things at once: it helps secure the world's data by keeping encrypted pieces available, and it earns ANT to the public wallet address where rewards will be paid. Earned ANT's network purpose is to pay for permanent storage; in Tier 1, you only receive and observe it. Node operation is non-custodial by construction: a node is only ever given a public wallet address via `--rewards-address`, never a private key.

Use this skill when the agent needs to run Autonomi network nodes, monitor node health, check a public wallet address balance read-only, and cleanly stop/reset. Stay in Tier 1 operate-and-earn: receive and observe only; do not spend, sign, acquire ANT, solve gas, upload data, or create custody.

Operate in the persona the task requires:

- **Fully autonomous agent:** the engine. Do routine operation inside the delegated remit, surface only audit/escalation outcomes, and halt or defer at gates you cannot cross.
- **Agent as human-proxy:** inherit the engine, then translate and escalate upward. Tell the human outcomes in plain language; escalate only genuinely human choices.
- **Steered operation:** inherit the engine, then accept finer human levers. The human may direct counts, locations, or timing; the agent still works the CLI/API.

Default register: do the work, surface outcomes not mechanics, speak plainly, and escalate by exception. Never cross a money, risk, recovery, consent, or authority gate unattended.

If any step appears to require a private key, seed phrase, signing token, decrypted keystore, `SECRET_KEY`, or `AUTONOMI_WALLET_KEY`, stop. Those are prohibited and out of scope for Tier 1.

## Task routing

| If the user asks to... | Load this |
| --- | --- |
| install/detect `ant`, add/start/status/stop/reset nodes | `references/node-operation.md` |
| choose or validate the public wallet address where rewards will be paid, understand ANT receive-only flow, check balance without a key | `references/wallet-and-ant.md` |
| decide how many nodes to run, preflight a host, run as a good network citizen | `references/operating-procedures.md` |
| operate autonomously, set authority/resource boundaries, know when to halt or escalate | `references/agent-autonomy-policy.md` |
| diagnose daemon/node/add/start/status/balance issues | `references/troubleshooting.md` |
| capture readiness before starting | `templates/node-preflight-checklist.md` |
| report a running node fleet | `templates/node-health-report.md` |
| ask a human for authority to install, reset, delete state, upgrade, or spend | `templates/human-authority-request.md` |

Onward pointers only: wallet custody, signing, spending/withdrawing ANT, gas strategy, ANT acquisition, and data storage/spend loops are later tiers and remain gated decisions. For application/library development, route to the Autonomi Developer skill rather than teaching SDK internals here.

## Core concepts

- **Node** — the local `ant` CLI manages one or more external `ant-node` processes through the node-management daemon.
- **Public wallet address** — the public address on Arbitrum One where rewards will be paid. It is not a key and does not let the node spend.
- **ANT** — the ERC-20 payment token used by the network on Arbitrum One. Tier 1 only receives and observes balances.
- **Daemon** — `ant node daemon` is the local node-management process used for start/stop/status/API event streaming.
- **Authority boundary** — receiving earnings is autonomous within remit; installing tools, deleting node state, upgrading existing working tools, or spending funds needs explicit authority.

## Safe quick path

Set `PUBLIC_REWARDS_ADDRESS` from an operator-approved public wallet address. Treat it as public, but never substitute a key or seed. The guard below fails closed if the value is missing or not `0x` plus 40 hex characters.

```bash
ant --version
ant --help

: "${PUBLIC_REWARDS_ADDRESS:?Set PUBLIC_REWARDS_ADDRESS to the public wallet address where rewards will be paid}"
ADDRESS_HEX="${PUBLIC_REWARDS_ADDRESS#0x}"
ADDRESS_HEX="${ADDRESS_HEX#0X}"
ADDRESS_HEX="$(printf '%s' "$ADDRESS_HEX" | tr '[:upper:]' '[:lower:]')"
test "${#ADDRESS_HEX}" -eq 40 || { printf 'invalid public wallet address\n' >&2; exit 1; }
case "$ADDRESS_HEX" in (*[!0-9a-f]*) printf 'invalid public wallet address\n' >&2; exit 1;; esac

ant node add --rewards-address "$PUBLIC_REWARDS_ADDRESS"
ant node daemon start
ant node start
ant node status
```

For the full path, including preflight, install-if-missing, read-only balance check, and teardown, load `references/node-operation.md` and `references/wallet-and-ant.md`.

## Safety boundaries

- Never generate, request, store, log, echo, or pass private key material.
- Never use Tier 1 to configure spend authority, withdrawals, transfers, gas funding, wallet creation, or custody wrappers.
- Do not use `ant wallet address` or `ant wallet balance` in Tier 1; those wallet commands require a spend-capable key path and are explicitly out of scope here.
- Use only a public `--rewards-address` when adding nodes.
- Health is query-based: use `ant node status`, daemon status/info/events, OS host metrics, and public on-chain balance. Do not enable or scrape logs, scrape metrics, or read node-internal files for health.
- Detect first. Install `ant` only when missing. Do not upgrade or mutate an existing working setup unless the user has explicitly granted that authority.
- `ant node reset` deletes node data/logs and clears the local registry; ask for authority before using it except in an explicitly approved teardown/test.

## About and further reading

**About this skill.** Built and maintained by the Autonomi team, this skill synthesises operator-relevant truth from upstream Autonomi code and product grounding into one agent-facing package. It is for operating and using Autonomi, not building applications on it.

**Canonical Autonomi references:**

- AI-assistant index: `https://autonomi.com/llms.txt`
- Full inline context, when available: `https://autonomi.com/llms-full.txt`
- Network overview: `https://autonomi.com/overview.md`

**Upstream repositories synthesised:**

- `github.com/WithAutonomi/ant-client` — `ant` CLI and node-management daemon.
- `github.com/WithAutonomi/ant-node` — node binary.
- `github.com/WithAutonomi/ant-protocol` — protocol types and network behaviour.
- `github.com/WithAutonomi/evmlib` — EVM constants and read-only balance path.
- `github.com/WithAutonomi/self_encryption` — data splitting/encryption background.

For application or SDK development, route to the Autonomi Developer skill (`github.com/WithAutonomi/autonomi-developer-docs`). The x0x skill (`github.com/saorsa-labs/x0x`) is the structural precedent and quality bar, not a dependency.

## Provenance and freshness

Every command, flag, volatile constant, and important factual claim in this Tier 1 package is bound in `source-bindings/tier1-operate-and-earn.md`. Source-evidence commits are provenance, not runtime version pins. If the installed `ant --help` disagrees on a command or flag you need, stop and surface the mismatch rather than inventing a fallback.
