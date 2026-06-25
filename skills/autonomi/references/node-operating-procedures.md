# Node operating procedures

Ongoing operation: adding, starting, stopping, and watching nodes, and running them as a good citizen of the network. First-time host setup is in `node-provisioning.md`; teardown is in `node-uninstall.md`.

## What you're optimising for

Network health, within the host's resource limits. Reliable earnings follow from that — they aren't a rival goal. When choices conflict, favour the network's health and the host's safety over squeezing more nodes onto a machine; a stuffed or unreliable host earns less anyway.

## The boundary model

**The network enforces:**

- A rewards address must be a valid `0x` + 40-hex public address.
- A node refuses writes when free disk drops below its reserve (default 500 MiB).
- The daemon refuses `reset` while nodes are running.
- The daemon API binds to loopback by default; exposed beyond loopback it has no authentication.

**This skill recommends (human judgement, not network rules):**

- Start with one node, confirm health, then scale gradually.
- Run several right-sized nodes rather than one oversized one, and don't pack a host just because the CLI allows many nodes in one call.
- Spread nodes across different connections/locations rather than piling them onto a single network.
- Prefer reliable, long-running hosts; keep the daemon on loopback; preserve disk headroom (don't plan against a fixed per-node ceiling — storage auto-scales).
- Leave version upgrades to the network (see Upgrades).

**You judge, within remit:**

- Whether the host has enough spare disk, memory, bandwidth, and uptime for the requested node count.
- Whether to add one node or several.
- Whether to install / update / reset / uninstall / delete local state — only within explicit authority.
- Whether an observed balance or node failure crosses a human-escalation threshold.

## Resource strategy

Size by the resource that runs out first, not by a node count you picked. Budget each resource with headroom — disk (**at least ~20 GB free per node** — the team-recommended minimum to avoid that individual node being shunned (per-node, not the agent or machine), docs/source to follow — above the network's hard 500 MiB write-reserve), memory and bandwidth (keep the host responsive; no swapping, the human's own work not starved) — and let the **tightest** budget set how many nodes you run. Start conservative, then monitor and adjust deliberately. On a shared machine, run as a background tenant: take spare capacity, yield to the host's own work. The node won't throttle its own CPU/memory — apply OS-level priority or limits from outside if you need to.

Disk needn't be the system drive: `ant node add --data-dir-path <path>` places a node's data on any mounted volume (one prefix can hold several nodes' data), so survey **all** volumes (`df -h`) when deciding how many nodes and where — not just the default one. Using the human's other media (an external drive) is theirs to consent to (propose it; see `node-provisioning.md`), and the volume must stay attached. Treat this sizing as a living decision, not a one-off: re-check as load, earnings, and free space change, and rebalance or escalate deliberately rather than churning nodes.

## Running nodes

Add more nodes only when there's headroom and remit allows. Use optional flags only if they appear in `ant node add --help`:

```bash
ant node add --rewards-address "$PUBLIC_REWARDS_ADDRESS" --count 2
ant node add --rewards-address "$PUBLIC_REWARDS_ADDRESS" --node-port 12000-12001   # fixed ports; range matches --count
```

Start and stop, all nodes or one by service name (both need the daemon running):

```bash
ant node start
ant node start --service-name node1
ant node stop
ant node stop  --service-name node1
```

Avoid a one-shot large `--count` unless the human asked for it and the host is provisioned for it. The CLI validates `--count` and the port ranges you pass — a guard against accidental misconfiguration, not a sizing recommendation.

## Watching health

Read health on demand from what the tools expose — not from logs (don't scrape logs or a metrics endpoint for routine health):

```bash
ant node status            # per-node: Running / Starting / Errored, version, pid, uptime
ant node daemon status     # daemon running, node counts
ant node daemon info       # API base, ports
```

Healthy signs: the daemon is running; `ant node status` shows nodes `Running` (or `Starting`, or `Upgrade scheduled` during an expected upgrade); nothing is `Errored`; processes stay up across repeated checks. `ant node status` and the daemon event stream report lifecycle and health, **not** earned totals — check earnings on-chain via `wallet-and-tokens.md`.

## Disk and capacity over time

Capacity planning isn't one-time. A node's disk use grows as it stores more, and a host's spare resources shift. Watch free space on each node's **data volume** (the one behind its data dir — default or `--data-dir-path`), not just the system drive.

- As a volume approaches the node's **500 MiB write-reserve**, that node stops accepting writes, and a chronically cramped node risks being shunned — so act before then. Escalate early with specifics: which volume, how full, how close to the reserve, and the options (free space, or place **new** nodes on a roomier volume with `--data-dir-path`).
- Relocating an **existing** node's data to another drive isn't a single CLI step — treat it as a human-directed move, not something to improvise. Stopping a node keeps its data and is restartable; don't churn it just to chase space.
- Never rely on removable media that may be detached — a data volume going away takes the node's standing with it.

## Scaling, step by step

1. Add and start one node.
2. Confirm `ant node status` and `ant node daemon status`.
3. Watch it stay stable across repeated status checks.
4. If the host still has headroom and remit allows, add more — with matching port ranges only if you're using fixed ports.

## Upgrades — hands off

`ant`, `ant-node`, and this skill have independent lifecycles. Nodes auto-upgrade along their upgrade channel (`--upgrade-channel`, e.g. `stable`) and the network propagates versions, so keep them running rather than chasing a version. Don't run `ant update` just because this skill changed — only for an explicit compatibility/security reason or human request. If a setup is working, prefer observation over mutation.

## Down-levers — and don't churn

When you need to ease off, in order (each heavier): **stop adding** → **stop a node** (frees its CPU/memory/bandwidth, keeps its data, restartable) → **remove/reset** (frees disk, deletes data, permanent — a health-only last resort). Stopping and removing forces the network to re-replicate data and erodes a node's standing, so don't churn nodes as an optimisation. Teardown detail: `node-uninstall.md`.

## Advanced: a per-node disk cap

There's no per-node storage ceiling on `ant node add` — storage auto-scales with free disk, and a node refuses writes below its disk reserve regardless. A fixed per-node cap exists only in the node's own TOML config; treat it as advanced and human-directed. For most hosts, managing free-disk headroom and node count is the right lever.

## When to escalate

Surface to a human when: there's no valid public address; the human wants the agent to create or own a wallet, or to move / spend / withdraw / acquire ANT; the balance passes a remit threshold the human set; the host can't meet the ~20 GB/node disk bar on any available volume, or using the human's other media for node data needs their consent; or a key, seed, keystore, or signing token appears in the task context. Report unknowns plainly — if a threshold isn't in source, say it's a human judgement, not a network rule.
