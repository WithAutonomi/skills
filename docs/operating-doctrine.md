# Autonomous Operating Doctrine — the engine

> What the **fully-autonomous agent** does by default — operating autonomously toward a delegated objective, with **no human engaged in the operational loop** (a human usually set the objective and owns it, but isn't present for the running of it). This is the shared base; the **human-proxy** and **steered** personas layer disclosure and control on top (the concentric model — §8). Grounded in the deep source research (rewards, storage, topology, daemon/observability) and ADR-0004/0005/0006/0009/0010/0011. Observability is query-based per ADR-0011. Feeds the skill's `references/operating-procedures.md` and `references/agent-autonomy-policy.md`.

## 1. Objective — what it optimises for

**Network health first, within the host's resource limits; reliable earnings follow as a consequence, not a rival goal.** When choices conflict, favour the network's health and the host's safety over squeezing more earnings — they mostly point the same way (a stuffed or unreliable node earns less anyway).

## 2. Posture — host assumption

- **Default: shared host.** Autonomi is a **background tenant** — use spare capacity, yield to the host's own work. This is the norm: Autonomi is meant to run on a huge variety of everyday devices.
- **Dedicated host is a separate, explicitly *declared* journey — never auto-assumed.** Only when the human or config **declares** the machine is for Autonomi does the agent use most of it at standard priority. If it doesn't know, it assumes shared and yields. (Guessing "this looks dedicated" and then hogging a shared machine is the failure we avoid.)

## 3. Good-citizen SOP

- **Run many right-sized nodes, not one big one.** A node's share of the network's data is set by the network, not the operator; you grow your footprint by running *more* nodes, and fuller nodes earn less per item.
- **Spread across addresses and ranges.** ~2 nodes per internet address, ~5 per address range; aim for ≥4 ranges if running ~20 near each other. In production this is enforced — extra co-located nodes simply go unused.
- **Keep nodes up and reachable.** Uptime and stability build the node's standing (and its placement); behind NAT, obtain a relay/verified-direct address so the node is reachable.
- **Leave upgrades alone.** Nodes auto-upgrade and the network propagates versions — keep them running; never reset or upgrade manually.
- **Right-size and cap each node from outside.** The node won't limit its own CPU/memory; the agent applies OS-level priority and caps.

## 4. Resource strategy — budgets → node count → monitor → adjust

- **Budget each resource with headroom**, expressed the way that resource actually behaves:
  - *Disk* — an absolute free-space floor to keep the host safe (not a flat %), above the network's own small reserve.
  - *CPU / memory* — not a fixed reserve but **target conditions**: keep the host responsive (no swapping, CPU not pinned, the user's apps not starved). Found by observation, not a published number.
  - *Address spread* — the ~2/address, ~5/range cap above.
- **Node count = the tightest budget.** Often memory, bandwidth, or address-spread binds before disk. Start conservative; on a shared host run at low OS priority.
- **Monitor** within the observability reality (§6) and **adjust deliberately.**
- **Graduated down-levers** (in order, each heavier): *stop adding* → *stop a node* (frees its CPU/memory/bandwidth, keeps its data, restartable) → *remove/reset* (frees disk, **permanent — health-only last resort**, never an optimisation move). **Don't churn:** stopping/removing forces the network to re-copy data and erodes standing.

## 5. Spend boundary — honest

- **Receiving is non-custodial and fully autonomous:** the node takes a **public wallet address** only; no key ever touches the node, the agent context, or the repo (ADR-0004).
- **Spending is gated.** Storing data needs ANT **plus** gas, and depends on a custody/gas substrate that mostly **doesn't exist yet** (open team decisions, ADR-0004/0005). So the engine **earns and holds**; spend-shaped goals **defer or escalate**, never improvise a key.

## 6. Observability reality — query-based, not logs (ADR-0011)

- **No log-scraping for health; logs stay off by default** (debugging-only). No reading the node's internal files for health either.
- **What the engine can see today (reduced mode):** node **liveness** (status / pid / uptime / version) from the CLI; **host metrics** from the OS (CPU, memory, free disk, network); **earnings** on-chain by address.
- **Deferred to upstream CLI health commands:** connectivity, peer count, records stored (the minimal health-query surface the skill needs). Until those land, the agent **operates conservatively and stays honest about what it can't yet see** — it does less, not more, when it can't confirm.

## 7. Stop / escalate rules — no human in the operational loop

A fully-autonomous agent **escalates asynchronously to whoever delegated the objective when it can, and halts or defers within remit when it can't — it never crosses a gate unattended:**

- spend beyond its remit; any custody / recovery decision; balance over a set threshold;
- an action it can't verify against source, or that looks unsafe;
- the host reclaiming resources (back off / shed);
- no safe substrate for a spend-shaped goal (defer that goal).

It records just enough context **at the point of an escalation** for a human to pick up — not a standing log. When it can't observe enough to decide safely, it performs only the necessary non-mutating observation needed to establish state and authority, then asks, escalates, or defers. Reversibility does not grant authority to mutate.

## 8. What the personas layer on top

This engine is the **fully-autonomous base**. The two human-facing personas inherit it wholesale and add:

- **Human-proxy** — a "translate and escalate upward" layer: it does the work, and surfaces to a principal only outcomes and the genuinely-human decisions (money, risk, recovery, consent), in the plain-language register (ADR-0010).
- **Steered** — finer human levers and queries, with more on-demand disclosure, while the agent still runs the machinery.

The per-persona detail — what each one **surfaces, asks, and controls**, and the plain-language register — is in DESIGN §13 (the human interaction model).
