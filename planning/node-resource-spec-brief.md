# Brief — what an operating agent needs to understand to run Autonomi nodes well

> **For:** the Autonomi dev team. **From:** Jim + agent (2026-06-25). **Purpose:** written from the standpoint of the *agent the skill drives* — what it must understand to operate nodes effectively, and where its blind spots are given what's knowable today. This is the **input** to a single authoritative **Recommended Node Resource Document** that should live at a stable location in an upstream repo. It states the agent's information needs, not the answers.

## What "operating well" actually demands of the agent

The skill asks an agent to deliver four outcomes at once:

1. **Best use of the host's resources** *and* **what's best for the network** — contribute real capacity without harming the machine or its owner.
2. **Be a good network citizen and not get shunned** — run nodes the network keeps and rewards, not ones it drops.
3. **Feed back timely, correct information to the human operator** — earnings, health, risks, in language they can act on.
4. **Make clear allocation/utilisation decisions for the best outcome for all parties.**

Each of these needs knowledge the agent does **not** fully have today. The rest of this brief is that gap, made explicit.

## What the agent can already determine

So the gaps are visible, here's what the skill encodes today (source-bound or team-confirmed):

- The node takes a public rewards address only; earnings are read **on-chain by that address**, and node status reports lifecycle/health but **not earned totals**.
- A node won't accept writes below a **500 MiB** disk reserve; it goes serve-only, not crash. A per-node disk cap exists only in TOML, not on `ant node add`.
- A node **does not self-throttle** CPU/RAM — capping is the operator's job (OS-level).
- Storage share is **network-set**; you grow contribution by adding nodes, not enlarging one. Address spread ≈ **2/IP, ≈5/subnet**; excess nodes go unused. ~**7×** replication.
- **~20 GB free disk per node** avoids that node being shunned *(team-confirmed, pending source)* — assumed additive.

Notice what's missing from that list: **how earning works, what "healthy" means to the network, and what the agent can actually see.** Those are the real blind spots.

## Blind spots & information needs

Each item: **what I'd need to know**, and **the decision it unblocks**.

### 1. The reward model — how earning actually works
The single biggest gap. I can read a balance, but I don't know **what drives it**: is it paid for storing data, for serving retrievals, for capacity held over time, or some mix? Is it event-driven or continuous? **Decision it unblocks:** what to actually optimise for ("earn properly"), and whether more nodes / more disk / better uptime is what moves earnings — without this I'm guessing.

### 2. Cost and time to first reward
Is there any **cost or stake to participate** (gas to register, a bond)? The skill assumes receive-only and non-custodial, but if joining has a cost, that changes the advice and may need the human. And **how long until a new node earns** — a fresh node's expected ramp. **Decision it unblocks:** setting honest expectations, and not alarming a human over a zero balance that's simply normal-for-now.

### 3. What "healthy / in good standing" means — and what I can observe
Today I can see a **process is up** (status, pid, uptime, version). I **cannot see whether the network considers my node well-connected, well-replicated, or in good standing** — the on-demand CLI doesn't expose peer count, record count, or connectivity yet (this is the upstream health-metrics work). This is a critical operating blind spot: I'm asked to keep nodes healthy and avoid shunning while half-blind to the thing that matters. **Decision it unblocks:** real health monitoring and early intervention. **The SOP should say which standing/health signals will be exposed and which ones matter.**

### 4. Shunning — triggers, warning, recovery
What **specifically** gets a node shunned — sustained disk shortfall, low uptime, slow/dropped responses, version lag, poor connectivity? Is there a **warning state or a reputation score** I can read before it's terminal? Is shunning **recoverable**, how long, and how? **Decision it unblocks:** acting *before* a node is dropped rather than discovering it after — the difference between good citizenship and wasted capacity.

### 5. A node's load profile over its life
What does a node *do* to a host over time? Is there an **initial sync/onboarding burst** (how long, how heavy)? Do **repair/replication events** (when peers leave) cause CPU/bandwidth/disk spikes I should expect rather than misread as faults? **Decision it unblocks:** sizing for peaks not just steady-state, and not panicking (or starving the host) during a normal repair storm.

### 6. Disk semantics — the 20 GB question
Is ~20 GB **per node (additive)** or a **shared pool** across nodes on one drive? How fast does a node fill, does it **plateau**, and what **headroom** above the minimum is sane? Relationship between the ~20 GB recommendation and the 500 MiB hard reserve. **Decision it unblocks:** the core capacity math and the `--data-dir-path` placement guidance.

### 7. Memory, CPU, bandwidth envelopes
Per-node figures (idle vs active), how they scale with stored data/peers, and **host headroom** to stay responsive. For bandwidth: steady-state vs burst, and **total transfer over time** (metered connections). The skill currently has *no numbers* here. **Decision it unblocks:** how many nodes a given host can carry, and replacing "keep the host responsive" with something an agent can actually check.

### 8. Connectivity and the spread caps
Confirm the ≈2/IP, ≈5/subnet caps and what happens to excess nodes. How should I reason about **NAT / CGNAT / a single home connection**, where the effective cap is low — so I recognise **diminishing returns** and don't spin up ten nodes that the network won't use? Does inbound reachability / port openness affect standing or earnings? **Decision it unblocks:** "best use of resources" — knowing when *more nodes stops helping* on a given connection.

### 9. Uptime, churn cost, and graceful exit
Minimum **uptime/availability** to be worth running and not shunned. The quantified **cost of churn** on standing. And is there a **graceful-departure** path that helps the network re-replicate cleanly and preserves standing, versus a hard stop? **Decision it unblocks:** whether intermittent hosts (laptops that sleep) are viable, and how to bring a node down *well*.

### 10. Version / protocol currency
How current must a node be — does running a lagging version risk shunning, and what's the tolerance? (Auto-upgrade exists, but I should know the stakes.) **Decision it unblocks:** how hard to insist on upgrades vs. leaving a working setup alone.

### 11. What to feed back to the human, and when
What does a human operator actually care to hear, and at what cadence — earnings milestones, health degradation, shunning risk, resource pressure, a node down? What's noise? **Decision it unblocks:** the "timely, correct feedback" outcome — surfacing what matters without pestering.

## What probably does *not* belong in this SOP

To keep it operational and not a protocol spec, it likely **doesn't** need: consensus/encryption internals; the data **upload/storage** side (future skill scope); building **on** Autonomi (developer skill); anything requiring **keys/spend** (out of scope, non-custodial); the wire protocol or crate architecture. The agent needs *operating* knowledge — what to do and the parameters to decide — not how the network is built.

## How the skill will consume this

One authoritative, **versioned** document at a stable upstream path → the skill **source-binds** its figures (like commands and flags) → the freshness automation re-pins when it changes, and the skill can do a best-effort **advisory check** at runtime for the volatile parameters (see `planning/NEXT-PHASE.md` §5) → until it exists, the affected figures stay flagged *team-confirmed, pending source*. Answering items 1, 3, and 4 in particular is what would most change how well an agent can operate — more than the raw resource numbers.
