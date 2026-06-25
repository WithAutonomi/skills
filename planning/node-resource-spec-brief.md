# Brief — what an operating agent needs to understand to run Autonomi nodes well

> **For:** the Autonomi dev team. **From:** Jim + agents (2026-06-25). **Purpose:** written from the standpoint of the *agent the skill drives* — what it must understand to operate nodes effectively, and where its blind spots are. This is the **input** to a single authoritative **Recommended Node Resource Document** the team should author and keep at a stable location, which the skill then **source-binds** to. It states the agent's information needs, not the answers.
>
> *Synthesised from two independent, clean-context agent passes (this assistant + an OpenCode agent), each working only from the installed skill, neither seeing the other's view. Strong convergence is noted where it occurred.*

> **Form of the answer matters as much as the content.** Agents must **not** be left to infer numbers from soft prose — that is exactly where different models diverge ("keep the host responsive" → 50% headroom to one, 5% to another). The document must deliver **hard, quantified values with units, in a structured, versioned, source-bindable form** (a parameters table / manifest), with prose reserved for the *why* and the judgement. The agent should **read** the values, like it reads a command flag, not interpret them. The concrete list of values required is in *Parameters the document must quantify*, below.

## What "operating well" demands of the agent

The skill asks an agent to deliver four outcomes at once:

1. **Best use of the host's resources** *and* **what's best for the network**.
2. **Be a good network citizen and not get shunned**.
3. **Feed back timely, correct information** — to the human operator it acts for, *and* (as field reports) to the dev team.
4. **Make clear allocation/utilisation decisions** within a clear authority/remit, for the best outcome for all parties.

Each needs knowledge the agent does not fully have today.

## What the agent can already determine

So the gaps are visible — the skill encodes this today (source-bound or team-confirmed):

- Node takes a **public rewards address only**; earnings read **on-chain by address**; node status reports lifecycle/health but **not earned totals**.
- A node won't accept writes below a **500 MiB** reserve (serve-only, not crash). Per-node disk cap only in TOML, not on `ant node add`.
- A node **does not self-throttle** CPU/RAM — capping is the operator's job (OS-level).
- Storage share is **network-set** (grow by adding nodes); spread ≈ **2/IP, ≈5/subnet** (excess nodes unused); ~**7×** replication.
- **~20 GB free disk per node** to avoid that node being shunned *(team-confirmed, pending source)*, assumed additive.
- No OS service is installed (daemon/nodes are supervised processes); installer doesn't edit PATH.

Notice what's missing: **how earning works, what "healthy" means to the network, what the agent can actually see, and the authority it's operating under.** Those are the real gaps.

## Blind spots & information needs

Each item: **what's needed**, and **the decision it unblocks**. *(C = both passes converged independently.)*

### A. Earning & economics

- **The reward model — what actually drives earnings.** Is it paid for data stored, retrievals served, capacity held over time, or a mix? Event-driven or continuous? *Unblocks:* what to actually optimise for — without it, "earn properly" is guesswork.
- **Cost / stake and time to first reward.** Any cost to participate (gas to register, a bond)? How long before a new node earns? *Unblocks:* honest expectations, whether joining needs the human, and not alarming anyone over a normal zero balance.
- **Normal balance baseline.** How long a zero/low balance is expected. *Unblocks:* correct "this is fine" vs "something's wrong" calls.

### B. Resource envelopes & sizing *(C)*

- **Per-node figures beyond disk:** CPU, RAM, bandwidth, IO, and disk-growth-over-time, idle vs active, and how they scale with stored data/peers. *Unblocks:* how many nodes a host can carry; replaces "keep the host responsive" with something checkable.
- **Host-fit thresholds:** what "stays responsive" means concretely — swap/load/network-saturation levels that should trigger reducing or stopping nodes. *Unblocks:* protecting the human's own use.
- **Disk semantics:** is ~20 GB **per node (additive)** or a **shared pool** across nodes on one drive? Growth rate, plateau, sensible headroom, and the relationship to the 500 MiB hard reserve. *Unblocks:* the core capacity math and `--data-dir-path` placement.
- **Load profile over a node's life:** initial sync/onboarding burst (how long, how heavy) and repair/replication spikes (when peers leave) to *expect* rather than misread. *Unblocks:* sizing for peaks; not panicking during a normal repair storm.
- **Storage placement specifics:** acceptable drive classes, filesystem expectations, detach risk, and how to judge "stays attached" operationally. *Unblocks:* safe use of external/secondary volumes.

### C. Scaling & topology *(C)*

- **Scaling policy:** how long to observe one node before adding more, how many to add per step, and what signals should *block* further scaling. *Unblocks:* disciplined, safe growth.
- **Topology:** confirm the ≈2/IP, ≈5/subnet caps and what happens to excess nodes; how to reason about NAT/CGNAT and a single home connection; does the network benefit more from **fewer nodes across diverse IPs/locations** than many behind one connection? *Unblocks:* "best use of resources" — recognising diminishing returns and when more nodes stops helping.

### D. Standing, shunning & good citizenship *(C on the shunning model)*

- **A concrete shunning model:** what behaviours trigger it, how fast, whether it's observable, and how recovery works. *Unblocks:* acting *before* a node is dropped.
- **The standing-observability gap:** today the agent can see a *process is up* (pid/uptime/version) but **not whether the network considers the node well-connected, well-replicated, or in good standing** (the CLI doesn't expose peers/records/connectivity yet). *Unblocks:* real health monitoring — the SOP should say which standing signals *will* be exposed and which matter. *(Direct input to the upstream CLI health-metrics work.)*
- **Differential impact on standing:** do downtime, repeated start/stops, resets, version lag, full disks, detached volumes, and NAT/firewall issues affect standing *differently*? *Unblocks:* prioritising what to avoid.
- **"Do not churn," with examples:** which operator actions are harmless, which mildly harmful, which force costly re-replication. *Unblocks:* safe day-to-day operation.
- **Uptime, maintenance & graceful exit:** minimum uptime/availability to be worth running; how to **pause safely** and for how long during planned host work; a **graceful-departure** path that preserves standing and helps clean re-replication; and whether a supported **autostart/service model** for reboot/sleep is expected. *Unblocks:* viability of intermittent hosts and bringing nodes down *well*.
- **Version/protocol currency tolerance:** does a lagging version risk shunning, and what's the tolerance? *Unblocks:* how hard to insist on upgrades vs. leaving a working setup alone.

### E. Feedback & reporting

- **To the human operator:** what they actually care to hear (earnings milestones, health degradation, shunning risk, resource pressure, a node down), at what cadence, and what's noise. *Unblocks:* timely feedback without pestering.
- **To the dev team (field reports):** a reporting contract — what events, where, at what urgency, in what format — plus a **minimal diagnostic bundle** (exact `ant` outputs, versions, daemon info, node IDs/service names, host OS, disk/volume state, network/RPC failures, timestamps). *Unblocks:* useful, consistent reports that improve the network and skill.
- **Privacy / redaction rules:** whether public rewards addresses, node IDs, paths, IPs, logs, and hostnames are safe to include in a report. *Unblocks:* reporting without leaking operator data.
- **Escalation taxonomy:** named categories — install failure, daemon failure, node crash, suspected shunning, disk pressure, balance-read failure, RPC block, CLI/skill mismatch. *Unblocks:* consistent routing and urgency.
- **Normal baselines:** how long `Starting` can last, how often transient errors occur, how long zero balance is normal, what upgrade states look like. *Unblocks:* distinguishing normal from faulty.

### F. Remit, authority & safe autonomous operation

- **An operator remit template:** max node count, max disk, allowed volumes, bandwidth limits, install/update/reset authority, external-drive consent, and the balance-escalation threshold. *Unblocks:* the agent operating confidently inside clear bounds, and knowing exactly when to ask.
- **Supply-chain verification procedure** (if agents are expected to verify releases): trusted keys/checksums and accepted failure handling. *Unblocks:* honest "verified delivery" claims.
- **Daemon security on shared hosts:** local multi-user risk, firewall expectations, and whether loopback-only is sufficient. *Unblocks:* safe operation on machines the agent shares.
- **Key-material incident protocol:** the skill correctly says *stop* if a key/seed/keystore appears in context, but not what to record or how to sanitise. *Unblocks:* safe, clean handling of an accidental exposure.

## Parameters the document must quantify (with units)

These are the **hard values** the document must state — not describe. For each, give the **value or range**, the **unit**, the **condition** it applies under, and whether it is a **hard limit** (network-enforced) or a **recommendation** (judgement). Where a value genuinely varies, give a range and the variable it depends on. "It depends" is only acceptable with the dependency named and bounded.

**Disk**
- Minimum free disk **per node** — value (GB); and state explicitly **additive vs shared-pool** across nodes on one drive.
- Recommended headroom above the minimum — GB or %.
- Typical disk-growth rate — GB/day (or GB/week), and any plateau ceiling — GB.
- Hard write-reserve — MB *(known: 500 MiB)*.

**CPU**
- Per node at idle — cores or %; under load/burst — cores or %.
- Recommended host CPU headroom to leave free — %.

**Memory**
- Per node at idle — MB; under load — MB; scaling with stored data — MB per GB stored (if applicable).
- Recommended host RAM headroom — MB/GB or %.

**Bandwidth & connectivity**
- Sustained up/down per node — Mbps; burst up/down — Mbps.
- Monthly transfer per node — GB/month.
- Minimum connection quality — latency (ms), max packet loss (%); inbound-reachability requirement (yes/no).

**Topology**
- Max *useful* nodes per IP — count *(confirm ≈2)*; per subnet — count *(confirm ≈5)*.
- Suggested nodes-per-host for a typical home connection — range.

**Uptime, standing & shunning**
- Minimum uptime/availability to be worth running / avoid shunning — % or hours/day.
- Max tolerable continuous downtime before standing is harmed — hours.
- Max tolerable version lag — releases or days.
- Time from a trigger to being shunned — minutes/hours.
- Recovery time and conditions after shunning — hours/days.

**Earnings**
- Reward settlement cadence — time between payments.
- Expected time-to-first-reward for a new node — days.
- Token decimals / unit for balance display — integer *(so the agent can present a friendly amount)*.

## How the skill will consume this

One authoritative, **versioned** document at a stable upstream path → the **values block above is delivered structured and machine-readable**, so the skill **source-binds** each figure (like commands and flags) and the agent reads it rather than inferring it → the freshness automation re-pins when it changes, and the skill can do a best-effort runtime **advisory check** for the volatile parameters (see `planning/NEXT-PHASE.md` §5) → until it exists, the affected figures stay flagged *team-confirmed, pending source*. The items that would most change how well an agent operates are the **reward model (A)**, the **standing-observability gap (D)**, and the **shunning model (D)** — but every figure in the parameters list needs to arrive as a hard value, not prose.
