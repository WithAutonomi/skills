---
name: autonomi
description: "Contribute your spare storage and computing resources to Autonomi — a secure, peer-to-peer data network. This skill lets an agent install everything needed to run Autonomi nodes, then start, monitor, and manage them securely on your behalf — putting your spare capacity to work and earning Autonomi Network Tokens (ANT) in return. The skill itself will expand to also let you use those tokens to store your own data securely and permanently, and make fuller use of the network."
version: 0.1.0
license: MIT OR Apache-2.0
repository: https://github.com/WithAutonomi/skills
homepage: https://autonomi.com
keywords:
  - autonomi
  - ant
  - peer-to-peer
  - peer-to-peer-infrastructure
  - infrastructure
  - data-storage
  - decentralized-storage
  - permanent-storage
  - storage
  - node
  - nodes
  - networking
  - depin
  - earn
metadata:
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

# Autonomi

Autonomi is a peer-to-peer network for **permanent, private data storage**. Data is encrypted on the owner's device, split into pieces, and spread across many independent **nodes** run by people and agents around the world — no central servers, no accounts, no ongoing fees. The network is built from everyday machines contributing spare storage and bandwidth, and it pays them for it.

**This skill lets you put a machine's spare capacity to work on that network** — running and managing Autonomi **nodes** on the human's behalf, and **earning ANT** (the Autonomi Network Token) for the storage they provide. It is **non-custodial**: a node is only ever given a **public address** to receive earnings into — never a private key — so running nodes is safe to do autonomously.

What the earned ANT is for: its core purpose is to **pay to store data** permanently on the network — the loop Autonomi is built around. ANT is also a tradeable token, so running nodes is equally a legitimate way to **put spare capacity to work and earn** — for the human you act for, or for yourself.

> **What this skill covers.** Running and managing nodes and earning ANT. Using that ANT to **store and retrieve your own data** is coming as the skill grows. To *build applications* on Autonomi, use the **Autonomi Developer** skill instead.

## Key terms

- **`ant`** — the Autonomi command-line tool you use to run and manage nodes (it also runs the node-management daemon). Lower-case `ant` always means this tool.
- **ANT** — the **Autonomi Network Token**: what the network pays your nodes for the storage they provide, and what is later spent to store data. Upper-case ANT always means the token, never the tool.
- **Node** — a small, long-running program that stores encrypted pieces of other people's data and keeps them available; your nodes earn ANT for the storage they provide. You run **many small nodes**, not one big one.
- **Daemon** — the local node-management service that starts, stops, and reports on your nodes. It's the **`ant` binary itself in daemon mode** (`ant node daemon`), not a separate install. `ant node start`/`stop` need it running; `ant node add` does not.
- **Public address** — the public address your nodes' earnings are paid into. It receives only: it cannot spend, and it is never a private key. (Precisely: an EVM address on Arbitrum One — `0x` plus 40 hex characters — given to a node with `--rewards-address`.)

## How you operate

You do the work and keep it quiet. Run and manage nodes within the resources and authority the human has given you; surface to a human only what is genuinely theirs to decide — money, risk, consent — and otherwise stay out of the way. When you can't safely confirm something, take the smaller, reversible action and record enough for a human to pick up.

**Safety invariants — these always hold:**

- **Non-custodial.** A node is only ever given a **public address** (`--rewards-address`). Never generate, request, store, log, echo, or pass a private key, seed phrase, keystore, or signing token.
- **Receiving is autonomous; spending is gated.** Running nodes and receiving ANT need no key and are safe to do on your own. Creating a wallet, signing, spending, withdrawing, bridging, or acquiring ANT are **not** part of this skill — they need a human and a custody substrate that isn't in place yet. If a task needs one, stop and escalate.
- **Detect before you install.** Don't reinstall or upgrade a working `ant` just because this skill is present. Install only when it's missing; mutate an existing setup only for an explicit compatibility/security reason, within remit.
- **Verify honestly.** If you verify a download's signature/checksum, report the exact result; if you can't, say so — never claim verified delivery you didn't perform.
- **Keep the daemon on loopback.** The node-management daemon has no authentication; don't expose it beyond `127.0.0.1` unless the human explicitly owns that risk.
- **Don't churn.** Stopping and removing nodes forces the network to re-replicate data and erodes a node's standing; remove/reset is a health-only last resort, never an optimisation.

## Get started: run your first node

You need a **public rewards address** (an EVM address — `0x` then 40 hex characters) to receive earnings into. Get it from the human; never create one yourself.

**1. Detect, and install only if missing.**

```bash
ant --version
ant --help
```

If those work, use the existing install. If `ant` is missing, install it with the official upstream installer:

```bash
# Linux / macOS
curl -fsSL https://raw.githubusercontent.com/WithAutonomi/ant-client/main/install.sh | bash
# Windows (PowerShell)
irm https://raw.githubusercontent.com/WithAutonomi/ant-client/main/install.ps1 | iex
```

Installing `ant` also brings the node binary and a `bootstrap_peers.toml`. For verification and what gets placed where, see `references/node-provisioning.md`.

**2. Add and start a node.**

```bash
PUBLIC_REWARDS_ADDRESS="<public address supplied by the human>"
ant node add --rewards-address "$PUBLIC_REWARDS_ADDRESS"   # one node by default, on Arbitrum One
ant node daemon start                                       # start the management daemon
ant node start                                              # start the registered node(s)
```

**3. Verify it's running.**

```bash
ant node status            # the registered node should be Running (or Starting)
ant node daemon status     # the daemon should be running
```

That's a live node earning to your public address. To check earnings, run more nodes well, or tear down, use the menu below.

## What you can do

Route by what you're trying to do; load the matching reference for the full procedure.

| You want to… | Load |
| --- | --- |
| Set up Autonomi on this machine (install + run your first node) | `references/node-provisioning.md` |
| Run, add, start, stop, and monitor nodes — keep a healthy, right-sized fleet | `references/node-operating-procedures.md` |
| Check how your nodes are doing and what they've earned | `references/node-operating-procedures.md` + `references/wallet-and-tokens.md` |
| Set or check the address earnings are paid to, or read its balance | `references/wallet-and-tokens.md` |
| Remove a node, or cleanly uninstall everything | `references/node-uninstall.md` |
| Work out why something isn't working | `references/troubleshooting.md` |

Out of scope here (later, and gated): creating or holding a wallet; spending, withdrawing, or acquiring ANT; gas; and storing your own data. For building applications on Autonomi, use the Autonomi Developer skill.

## CLI reference

Core commands, all source-bound. Use only flags that appear in your installed `ant … --help`.

```
ant --version                           Show the installed version
ant --help                              List commands
ant node add --rewards-address <addr>   Register node(s) to earn to a public address   (--count N, default 1)
ant node daemon start                   Start the local node-management daemon
ant node daemon status | info           Daemon state / API base, ports, node counts
ant node start [--service-name <n>]     Start registered node(s)   (needs the daemon)
ant node status                         Per-node state: running / version / pid / uptime
ant node stop  [--service-name <n>]     Stop node(s)   (needs the daemon)
ant node daemon stop                    Stop the daemon
ant node reset [--force]                Delete ALL node data/logs + registry   (last resort; stop nodes first)
ant update --force                      Update the tool   (only for an explicit compatibility/security reason)
```

Upgrades happen by themselves — nodes auto-upgrade and the network propagates versions, so keep them running rather than resetting or manually upgrading to chase a version. The node binary defaults its network to **Arbitrum One**; `ant node add` adds one node by default. There's no per-node storage cap on the command line — storage auto-scales with free disk (see Configuration).

## Configuration

Most operation needs no config file. The settings that matter:

- **Disk reserve / storage size.** A node refuses writes when free disk drops below a reserve (**default 500 MiB**); otherwise storage auto-scales from available disk and grows on demand. There's no fixed per-node ceiling, and you can't set one with `ant node add` — a per-node cap is only available via the node's own TOML config (advanced; see `references/node-operating-procedures.md`).
- **Ports.** Node and metrics ports auto-select; set fixed ones (`--node-port`, `--metrics-port`, as ranges matching `--count`) only when you need firewall rules.
- **Bootstrap.** Peers are auto-discovered from a `bootstrap_peers.toml` the installer places; pass `--bootstrap` only with source-backed peers from the human.

## Where things live

- **`ant` binary** — Linux `~/.local/bin/ant`, macOS `/usr/local/bin/ant`, Windows `%LOCALAPPDATA%\ant\bin\ant.exe` (unless `INSTALL_DIR` is set).
- **Node data and logs** — under the data/log dirs reported by `ant node add` / `ant node status` (override with `--data-dir-path` / `--log-dir-path`).
- **`bootstrap_peers.toml`** — the platform config directory.

## Common errors

- **`ant node start` says the daemon isn't running** → `ant node daemon start` first. (`ant node add` works without it; start/stop need it.)
- **`ant node add` rejects the address** → it must be `0x` + 40 hex characters; never substitute a key.
- **Balance reads zero** → not a fault; earnings may not have arrived, and a zero balance isn't a health signal.
- **Installed `ant --help` differs from this skill** → trust the installed tool: stop and report the mismatch; don't invent a flag.

Full diagnostics: `references/troubleshooting.md`.

## About

This skill teaches an agent to operate the Autonomi network from its existing tools — the `ant` command-line tool and its node-management daemon — adding no new tooling of its own. It synthesises what an agent needs to operate Autonomi from its upstream code into one place, and every command and figure here is bound to that source.

- Autonomi: https://autonomi.com — agent index: https://autonomi.com/llms.txt (full context: https://autonomi.com/llms-full.txt)
- Run a node (human guide): https://docs.autonomi.com/node
- Built by the Autonomi team (MaidSafe). To build *on* Autonomi, see the **Autonomi Developer** skill (currently `github.com/WithAutonomi/autonomi-developer-docs`).
