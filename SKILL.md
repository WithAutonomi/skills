---
name: autonomi-operator
description: "Operate Autonomi nodes and earn ANT to a public rewards address: install or detect ant, run/manage nodes, monitor health, check read-only rewards balance, and cleanly stop/reset without private keys."
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

Use this skill when the agent needs to run Autonomi network nodes, receive node rewards to a **public EVM rewards address**, monitor node health, check the address balance read-only, and cleanly stop/reset. This Tier 1 path is deliberately non-custodial: the node receives a public address only.

If any step appears to require a private key, seed phrase, signing token, decrypted keystore, `SECRET_KEY`, or `AUTONOMI_WALLET_KEY`, stop. Those are prohibited and out of scope for Tier 1.

## Task routing

| If the user asks to... | Load this |
| --- | --- |
| install/detect `ant`, add/start/status/stop/reset nodes | `references/node-operation.md` |
| choose or validate a rewards address, understand ANT receive-only flow, check balance without a key | `references/wallet-and-ant.md` |
| decide how many nodes to run, preflight a host, run as a good network citizen | `references/operating-procedures.md` |
| diagnose daemon/node/add/start/status/balance issues | `references/troubleshooting.md` |
| capture readiness before starting | `templates/node-preflight-checklist.md` |
| report a running node fleet | `templates/node-health-report.md` |
| ask a human for authority to install, reset, delete state, upgrade, or spend | `templates/human-authority-request.md` |

Onward pointers only: wallet custody, signing, spending/withdrawing ANT, gas strategy, ANT acquisition, and data storage/spend loops are later tiers and remain gated decisions. For application/library development, route to the Autonomi Developer skill rather than teaching SDK internals here.

## Core concepts

- **Node** — the local `ant` CLI manages one or more external `ant-node` processes through the node-management daemon.
- **Rewards address** — a public EVM address on Arbitrum One used to receive node rewards. It is not a key and does not let the node spend.
- **ANT** — the ERC-20 payment token used by the network on Arbitrum One. Tier 1 only receives and observes balances.
- **Daemon** — `ant node daemon` is the local node-management process used for start/stop/status/API event streaming.
- **Authority boundary** — receiving rewards is autonomous within remit; installing tools, deleting node state, upgrading existing working tools, or spending funds needs explicit authority.

## Safe quick path

Replace the address with the public rewards address supplied by the operator. Treat it as public.

```bash
ant --version
ant --help

PUBLIC_REWARDS_ADDRESS="0x0000000000000000000000000000000000000000"
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
- Detect first. Install `ant` only when missing. Do not upgrade or mutate an existing working setup unless the user has explicitly granted that authority.
- `ant node reset` deletes node data/logs and clears the local registry; ask for authority before using it except in an explicitly approved teardown/test.

## Provenance and freshness

Every command, flag, volatile constant, and important factual claim in this Tier 1 package is bound in `source-bindings/tier1-operate-and-earn.md`. Source-evidence commits are provenance, not runtime version pins. If the installed `ant --help` disagrees on a command or flag you need, stop and surface the mismatch rather than inventing a fallback.
