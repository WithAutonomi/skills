# Brief — Recommended Node Resource Document

> **For:** the Autonomi dev team. **From:** Jim + agent (drafted 2026-06-25). **Purpose:** define the questions an authoritative node-resource document needs to answer, so an agent can operate nodes well. This brief lists the *questions*, not the answers — several need real research/measurement.

## Why this document should exist

The `autonomi` skill teaches an agent to decide **what resources to contribute, where, and how many nodes** — then run them as a good citizen and adapt over time. To do that responsibly it needs authoritative resource guidance. Today the skill carries the **~20 GB/node** minimum as *team-confirmed, pending source*, and treats **memory, CPU, and bandwidth** as judgement-only ("keep the host responsive," no numbers).

Recommendation: capture this as **one authoritative document with a stable location in an upstream repo we already consume** (e.g. `ant-node` or `ant-client`), versioned, so the skill can **source-bind** to it exactly as it binds commands and flags — and the planned auto-update automation re-pins it when it changes. A single home avoids the figures drifting across docs.

## The decision an agent is making

Given a host, the agent chooses a contribution and runs it, **optimising across three interests that sometimes pull against each other**:

1. **Best allocation of the host's resources** — use spare capacity efficiently without harming the machine or its owner.
2. **What's best for the network** — reliability, capacity, and healthy spread.
3. **What's best for the local operator** — earn properly, keep upkeep low, and avoid the node being *shunned*.

The document should let an agent reason about all three, and tell it the **priority order when they conflict**.

## Questions to answer

### A. Disk / storage

- Is the **~20 GB/node** figure **additive** (per node — so N nodes on one drive want ~20 GB × N, which the skill currently assumes) or a **shared pool**? **How is the budget managed when multiple nodes share one drive?**
- What precisely is the relationship between the ~20 GB recommendation and the hard **500 MiB write-reserve**? Is shunning risk tied to falling below ~20 GB, to the reserve, to sustained vs. momentary shortfall?
- How fast does a node's stored data **grow**, and does it **plateau** or grow unbounded? Recommended **free-space headroom** above the minimum?
- **SSD vs HDD** — any requirement or strong preference? IOPS sensitivity? Filesystem constraints?
- Multiple nodes on one volume vs. spread across volumes — any **I/O-contention** guidance?

### B. Memory

- RAM **per node**, idle vs. active, and how it scales with stored data / peer count?
- Total RAM **headroom** to keep a host responsive (esp. a shared machine)?
- Behaviour under **memory pressure** — can a node be OOM-killed, and what does that do to its standing?

### C. CPU

- CPU **per node**, steady-state vs. bursts (replication, verification)?
- The node doesn't self-throttle — what **external caps** (OS priority / cgroups) are safe **without harming standing**? Recommended limits?
- Relationship between **core count** and how many nodes a host should run?

### D. Bandwidth / connectivity

- **Up/down bandwidth per node**, steady-state vs. burst?
- **Total data transfer over time** (e.g. GB/month) — needed to reason about metered/capped connections?
- **Connectivity quality** (latency, packet loss, inbound reachability / NAT, port requirements) — thresholds below which a node risks shunning or reduced earnings?
- Confirm and detail the **address-spread caps** (we believe ≈2 nodes/IP, ≈5/subnet): what happens to **excess** nodes (idle? penalised?), and how should an agent reason about **shared IPs / CGNAT**?

### E. Shunning — the failure mode to design against

- A **precise definition**: which behaviours/thresholds get a node shunned (disk, uptime, latency, dropped responses, version lag, …)?
- Is shunning **recoverable** — how long, and what does recovery require?
- **Early, observable signals** (within a query-based health model, i.e. no log-scraping) that predict shunning, so an agent can act *before* it happens?

### F. Uptime / churn

- Recommended **minimum uptime / availability** for a node to be worth running and not shunned?
- The **cost of churn** (stopping/removing/re-adding) on standing — quantified?
- Are **intermittent hosts** (laptops that sleep, machines that move networks) viable, and under what thresholds?

### G. Scaling & earnings efficiency

- Given the spread caps, at what point do **extra nodes on one host/IP stop adding value**?
- Is there an **optimal node size/count** per resource envelope ("many small vs. fewer large")?
- What does an agent **optimise to earn properly** — storage served, uptime, standing? How do these relate to reward?

### H. The three lenses — explicit trade-offs

- **Network:** what does the network most need from a contributor — reliability, capacity, or spread?
- **Host / human:** safe defaults for a **background tenant** vs. a **dedicated host**; how to guarantee the human's own use isn't degraded.
- **Operator standing / earnings:** the **minimum viable contribution** that earns without being shunned.
- **When these conflict, what is the recommended priority order?**

## Starting assumptions to confirm or correct

The skill currently encodes these (source-bound or team-confirmed). The document should validate or revise them:

- ~20 GB free disk **per node**, additive, to avoid that node being shunned *(team-confirmed, pending source)*.
- Hard **500 MiB** write-reserve; below it a node goes **serve-only** (no crash).
- A node **does not self-throttle** CPU/RAM; capping is the operator's job (OS-level).
- Storage share is **network-set**; you grow contribution by adding nodes, not enlarging one.
- Address spread ≈ **2/IP, ≈5/subnet**; excess nodes go unused.
- ~**7× replication** (a single node going down loses nothing).
- Per-node disk cap is settable **only via the node's TOML config**, not `ant node add`.
- Earnings are read **on-chain by public address**; node status does not report earned totals.

## How the skill will consume the result

One authoritative, versioned document at a stable upstream path → the skill **source-binds** each figure to it (like commands/flags) → the freshness automation re-pins when it changes → until it exists, the skill keeps these figures flagged *team-confirmed, pending source*. Answering these questions unblocks firm resource guidance in the skill and removes the judgement-only placeholders for memory, CPU, and bandwidth.
