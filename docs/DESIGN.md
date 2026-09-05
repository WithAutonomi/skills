# Autonomi Operator Skill — Design

> Canonical design target, not an exact inventory of the currently shipped files. Read `planning/HANDOFF.md` and `README.md` for implementation state. This supersedes the original pre-decision scaffold and is aligned with the repository's Proposed ADRs; none is Accepted autonomously. Volatile specifics (flags, constants, addresses, URLs) are **source-bound** to upstream per ADR-0006, not hardcoded here.

## 1. Purpose and shape

An **operator skill**: it teaches an AI agent to operate and *use* the Autonomi network, starting with running nodes and expanding toward whole-network use. It is **one holistic, internally-modular skill, progressively disclosed by task routing** (ADR-0002), with x0x as a precedent (ADR-0008). It teaches the **existing** CLI + daemon surfaces and builds no new tooling (ADR-0003); at the build frontier it points onward to the Developer skill. It lives in its own repository because it is a synthesis across many upstream repos with no natural home in any one (ADR-0007).

The pieces are **interrelated task journeys** — run a node; receive & secure ANT; use ANT to store data; acquire ANT — entered by task and routed via the SKILL.md, overlapping and feeding each other. *Not* a single linear loop.

## 2. SKILL.md structure (the lean, routing-first entry)

1. **Opener** — what Autonomi is, what it's for, and why run a node (David's brief). Accurate and source-bound, neutral on economics, cooperative framing, written to the agent as operator.
2. **Task routing** — "what are you trying to do?": run a node · receive & secure ANT · use ANT to store data · operate autonomously. Routes to modules; embodies the neutral-menu principle (inform the agent's judgement, don't make the decision).
3. **Core concepts** — brief: nodes, ANT, the public wallet address, gas, data, human/agent authority.
4. **Safety boundaries** — non-custodial default, irreversibility, the money line, never put a key on a node or in the repo.
5. **Routing table** — which reference/runbook for which task, and onward pointers (Developer skill, live docs, repos).

> Human-facing output follows the interaction model and plain-language register in §13 (ADR-0010): the agent does the work and surfaces little, speaks plainly, and escalates by exception.

## 3. Modules (`references/`, loaded on demand)

- `node-operation.md` — install, run one/many, configure, monitor, upgrade/stop. **(operate-and-earn)**
- `wallet-and-ant.md` — the public wallet address (node non-custodial by construction) and the **menu** of sourcing options (supplied / provisioned / agent-created), with **agent-created first-class** for autonomous use via an out-of-context custody substrate — never LLM-created (ADR-0004); EVM address on Arbitrum One (ANT is an ERC-20); checking balance; and custody/recovery only where the agent owns a wallet (secrets out of context; declared recovery at creation). **(operate-and-earn → secure ANT)**
- `using-ant-and-data.md` — how earned ANT is used to store/retrieve data on the real ANT + Arbitrum-gas path (ADR-0005); onward pointers; acquisition deferred (pointers only for now). **(spend / store tier — mental model + pointers until then)**
- `operating-procedures.md` — good-citizen heuristics and the recommends / network-enforces / agent-judges boundary model.
- `agent-autonomy-policy.md` — "operate autonomously, spend under authority": resource and spend envelopes, what needs human sign-off.
- `troubleshooting.md`.

## 4. Templates (`templates/`)

- `node-preflight-checklist` · `node-health-report` · `human-authority-request` (the one-time policy/approval grant, not a per-action nag).

## 5. Interface model (per pillar; ADR-0003)

- **Node operation →** the `ant` CLI driving the local node-management daemon (`ant node …`), which supervises the external `ant-node`. No node-operation MCP exists upstream and we add none.
- **Data / wallet →** the `ant` CLI, or the `antd` gateway / existing `antd-mcp` (pointered). No new tooling.
- **Health →** `ant node status` and the daemon `/api/v1/events` SSE stream. The `--metrics-port` flag exists but no `/metrics` endpoint is served yet — do **not** instruct scraping it.

## 6. Install and secure delivery (skill-led distribution; ADR-0008)

The skill is self-sufficient: installing it is all an agent needs. It detects what is already present and installs the **existing** tools only when missing — the `ant` CLI (the node daemon is the same `ant` binary in daemon mode; `ant-node` is fetched per node) — mutating an existing setup only for a compatibility/security reason and within the agent's granted remit (per ADR-0009).

- **Install paths, with fallbacks (x0x pattern):** install script (`install.sh` / `install.ps1`, which `ant-client` already ships) → direct release artifacts → build-from-source; plus a fallback source (e.g. raw GitHub) if the primary URL is unreachable.
- **Verification:** confirm checksums and signatures *before use* and report the result to the agent — `ant-node` releases ship `SHA256SUMS` and ML-DSA-65 (FIPS-204) signatures. Plus the checks agents and distribution channels expect: declared behaviour matches actual, and a reviewed install script (ClawHub security scan).
- **Uninstall:** a documented, clean removal path — stop nodes and the daemon, then remove binaries and state (data dirs, registry, caches). Agents trust a skill they can cleanly reverse.
- All install URLs/versions are **source-bound** (ADR-0006) so the paths and fallbacks don't go brittle or stale.

## 7. Rewards and custody (ADR-0004)

Node operation is **non-custodial by construction**: the node is given a **public wallet address** only, holds no key, and the skill never needs or handles a private key to run a node. Sourcing the public wallet address is a **neutral menu** — not a ranked ladder and not a hard default: **supplied**, **provisioned**, or **agent-created**. Agent-created is **first-class for autonomous use**, but is substrate-created on the agent's behalf — **never LLM-created**: keeping the key out of the agent context is *necessary but not sufficient*, so it is permitted only through a custody substrate that also provides encryption at rest, a **declared recovery path at creation**, a scoped spend policy, auditability, and signing confined to the substrate boundary (the agent sees only public address / balance / tx hash / status). Receiving is fully autonomous; spending is remit-gated (ADR-0009) with risk-based escalation. Because the stack provides no wallet creation, encrypted keystore, recovery, or signing policy today, agent-owned spend is a **target capability gated on an open team decision** about where the custody substrate lives (assumed-host / signposted / skill-provided wrapper / upstream `ant` / staged); operate-and-earn runs now on a public wallet address. (`antd` does expose a headless external-signer seam — `prepare`/`finalize`, the key never enters the daemon — that a substrate could plug into, but it is not itself custody.) The address must be a valid EVM address usable on **Arbitrum One** (ANT is an ERC-20 there).

## 8. Spend and acquire (ADR-0005; neutral-menu principle)

Document the real, current path to store data — ANT (ERC-20) **plus** a little native Arbitrum gas (ETH); there is no gasless path upstream, and we invent none — and surface the gas barrier as a known limitation to escalate. Present a neutral menu of paths to ANT (earn / acquire / obtain) and the live means to assess sufficiency (balance, `ant file cost`), so the agent judges for its remit; never editorialise volatile economics. ANT **acquisition** is outside the operate-and-earn tier (onward pointers only for now).

## 9. Operating well — the boundary model

Three buckets the skill keeps distinct: **what the network enforces** (facts the agent works within), **what the skill recommends** (derived good-citizen procedures — right-size to the machine, spread across IPs/subnets where possible, keep nodes reliable), and **what is the agent's judgement** (how many nodes, distribution, scale up/down, autonomous vs human-checked). Functional and parameter-grounded, not network-design exposition.

## 10. Staying current (ADR-0006)

Every claim is **source-bound** to upstream (repo / file / symbol / commit) via a source-binding manifest; volatile facts are isolated and single-sourced; content is tagged mechanically-derived (auto-regenerable) vs judgement-derived (flag-for-review); per fact, a deliberate bake-with-pin vs approved, bounded fetch-live choice. New skill versions are delivered by the channel that installed them, or by deliberate reinstall for a manual copy (ADR-0013). The skill does not make a network request to check its own version. A separate, optional live check may fetch only signed, typed volatile values within granted network/egress remit, falling back to the bundle otherwise (ADR-0013). Upstream repos signal operator-facing changes back to the skill (the cross-repo freshness contract, ADR-0006). The automation pipeline (upstream-sweep) is deferred; the regeneration-ready structure is mandatory now.

## 11. Metadata, licensing, provenance (ADR-0008)

Frontmatter: name, a triggering-tuned description, version, license, keywords. An install manifest on x0x's `metadata.openclaw.install` pattern. Licensing to match upstream (likely MIT OR Apache-2.0 — TBC). Clear **provenance / "about"**: the team behind it, the upstream repos it synthesises, and links — so agents and distribution channels can see what's behind it.

## 12. Progressive delivery — capability ladder

The skill is built to expand (ADR-0002's modular, progressively-disclosed shape; ADR-0005's spend-is-a-frontier stance): useful node operation lands first, and further capability layers on without reworking the core. A closed earn→store loop is *not* required for value.

The ladder below is the **conceptual scope map** — what the capability tiers *are*:

- **Operate and earn** — install/detect `ant`; accept or provision a public wallet address under safe policy; run, manage, and monitor nodes; track rewards and balances; clean uninstall / node-state recovery. (The skill neither creates nor holds a key at this tier.)
- **Secure and reason about ANT** — wallet policy; the agent-managed (secrets-out-of-context) custody path and the user/provisioned path; balance and gas visibility; "what can I do next?" guidance.
- **Spend / store loop** — a chosen gas strategy; upload/retrieve with ANT + gas (or a funding/paymaster route); the full autonomous earn→store workflow. Gated on the gas-strategy decision (ADR-0005) and the custody decision (ADR-0004).

> **Sequencing lives in roadmap planning, not here.** What each iteration contains, the order, and the definition of done are owned by `planning/ROADMAP.md` (formalised by @pm). DESIGN holds the *concept*; the roadmap holds the *plan*. ADR-0004/0005 nod to this ladder but do not fix the sequence.

The skill stays honest about the boundary at every tier: *it can operate nodes and help an agent earn; autonomous storage-spending depends on the gas/payment path and the custody decision.*

## 13. Human interaction model (personas, disclosure, language register)

> How the agent relates to and talks to the operator (ADR-0010). Default stance: do the work, surface little, speak plainly, escalate by exception. The personas are **concentric, not parallel**: the **fully-autonomous agent is the engine** (the operating doctrine — §9 and `agent-autonomy-policy`); the two human-facing personas **inherit it wholesale** and layer disclosure and control on top.

### The three personas

**1. Fully autonomous agent — the engine (base).**
- *Who:* operating autonomously toward a **delegated, often long-running or open-ended objective**, with **no human engaged in the operational loop**. A human (or another agent) has very likely set the objective and owns the outcome — but isn't present for the running of it and isn't consulted for routine operation. The network work is usually a *means* to a broader goal (earn revenue, contribute to infrastructure, store data in the background); the agent holds full command of the operational and crypto detail.
- *Surfaces:* nothing routinely — an auditable trace, and outcomes only if the delegator has a channel to receive them.
- *Asks / escalates:* at a gate it can't cross alone, it **escalates asynchronously to whoever delegated the objective if it can reach them; if not, it halts or defers within remit.** It never crosses a money / risk / authority gate unattended.
- *Controls:* none in real time; it self-governs within the remit it was given and the doctrine.
- *Register:* the conversational register is dormant — it speaks only in audit/logs and in any escalation it raises.

**2. Agent as human-proxy — engine + "translate and escalate up."** *(the expected case, e.g. Fae; the primary persona for language)*
- *Who:* an agent operating on behalf of a human principal. The human hands it resources toward an explicit goal ("run nodes and earn," "contribute ~100 GB").
- *Surfaces:* outcomes in plain language — is it running, what it's earned, is the money safe — and the occasional genuinely-useful, opt-in suggestion. Not mechanics, not routine ops.
- *Asks / escalates:* the genuinely-human gates only — spend/authority beyond remit, balance over a threshold, backup/recovery, consent — **by exception, never routine, never gated on crypto-literacy.**
- *Controls:* light and goal-level. The human sets the goal, the resource budget, and grants authority; the agent decides the how. The human can redirect ("earn more," "use less"), not micromanage.
- *Register:* full plain-language translation (the map below); assume intelligence, not knowledge; explain on request. This is where the register matters most.
- *Example:* the agent runs quietly for weeks, then surfaces only when it must — *"Heads up: your node has earned enough now that it's worth protecting. Securing it needs a one-time setup and a recovery step only you can approve — shall we do that now? It keeps running either way."* (A money/recovery gate, surfaced plainly, the human decides; no mechanics.)

**3. Steered operation (hands-on, agent-assisted) — engine + finer human levers.**
- *Who:* a person who wants more direct control, likely already familiar with the network or already running nodes. They use the agent to avoid the command line — but still aren't pushing buttons; it's a chat/text-driven operation where they issue specific signals and queries.
- *Surfaces:* more, on demand — node status, counts, what's contributed, where rewards go — with more depth available than the proxy offers, when asked.
- *Asks / escalates:* the same money/risk/recovery/consent gates, but a hands-on operator chooses to confirm more decisions by preference. The agent still never crosses a gate unattended.
- *Controls:* finer levers — how many nodes, how a node is set up, how much is contributed, where rewards go, when to scale. The agent works the CLI/API; the human directs the specifics.
- *Register:* plain by default, but it **meets the operator's fluency** — precise terms are fine with a knowledgeable user — and never forces jargon; explains on request.
- *Example:* — "I've loads of disk free; can I run more nodes?" — *"Disk isn't the limit here — your internet connection is. The network only counts about two nodes per address, so on this one connection ~2 productive nodes is the ceiling; more would sit idle and earn nothing. To run more you'd add another network or location. Want me to make sure your two are running well instead?"* (Finer lever, but honest about the real constraint, in plain words.)

**Across all three:** the agent shoulders routine work, adapts disclosure and register to the persona, and **never crosses a money / risk / authority gate unattended.** The line between autonomous and proxy is *how present the human is* — a distal delegator who has stepped back (1) versus a present principal who expects to be kept in the loop (2) — not whether a human exists at all.

### Disclosure & division of labour

Default to doing the work; surface outcomes and genuinely authority-gated choices; keep mechanics and jargon out of the way. Minimise *operational* burden, never *authority* — but "authority" means **granting or widening an envelope**, not acting within one. A spend / risk / recovery / consent envelope is explicitly granted by, or its widening escalated to, the **authorised principal/delegator**; it is never inferred. **Acting within a granted envelope** needs no per-action approval (ADR-0004/0009), and reporting adapts to the available channel. Human-only gates remain human: in particular, ADR acceptance and ADR-0013's material live-value approval cannot be delegated to the running agent. Escalate by exception, not for routine ops, and never on crypto-literacy; where the authorised decision-maker can't be reached, **halt/defer** rather than cross the gate.

### Language register

Plain, not patronising — assume intelligence, not specialist knowledge. Lead with meaning before naming a precise term; report outcomes, not commands / flags / hashes; keep internals (close groups, DHT, quorum, key formats, gas mechanics) out of human view unless asked; always be ready to explain and expand on request (progressive depth). Accuracy is never sacrificed for simplicity.

### Translation map (technical → human; first cut, product-owned — refine over time)

- "your EVM rewards address on Arbitrum One" → "the wallet address your node's earnings go to"
- "ANT (ERC-20 token)" → "ANT, the network's token"
- "native Arbitrum gas" → "a transaction fee for the payment"
- "private key / `SECRET_KEY`" → "the secret that controls the wallet" (kept out of view)
- raw `ant node status` table → "your node's running fine and has earned X so far"
- "node" — keep, but introduce on first use ("a small program that stores encrypted pieces of others' data and earns tokens")
- internal-only, not surfaced unless asked: close group, DHT, quorum, replication, ML-DSA, keystore, flags, hashes

## 14. Open questions (carried; mostly David/maintainer)

- Release/promotion mechanics and clean install/update verification for each supported channel.
- Agent wallet custody substrate (where keygen/storage/recovery/signing live: assumed-host / signposted / skill-provided wrapper / upstream `ant`) — open team decision (relates to ADR-0004).
- Gas / acquisition easing (DEX guidance, a paymaster if one returns) — escalate to David (ADR-0005).
- Upstream watch-set and "material change" policy (for the deferred automation).
- Pin volatile constants or define an approved, bounded fetch-live contract (e.g. the close-group size — read as both 5 and 7; resolve before authoring).

## Design History

- **2026-Jun-17:** Rewritten and realigned to ADR-0001…0009, superseding the original pre-decision scaffold; removed the "loop" abstraction and all gas-abstraction framing; added install/secure-delivery, uninstall, licensing, and provenance; aligned to the address-sourcing menu (gated self-generation, no "fallback"/"node host" framing) and the remit-gated, non-mutating install.
- **2026-Jun-18:** Refinement round from team review — added the capability ladder (ADR-0005 as a frontier, not a blocker for node operation); x0x reframed as precedent not dependency; cross-repo freshness contract noted (ADR-0006).
- **2026-Jun-18 (later):** De-versioned the delivery framing — DESIGN keeps the capability ladder as a *concept*; the iteration sequencing, scope, and definition of done move to roadmap planning (`planning/ROADMAP.md`), nodded to from ADR-0004/0005. Module tags now name capability tiers rather than iteration numbers. Added the agent-wallet-custody substrate as an open team decision.
- **2026-Jun-18 (ADR-0004 applied):** ADR-0004 reframed — agent-created wallet first-class for autonomous use via an out-of-context custody substrate (never LLM-created); secrets-out-of-context necessary-but-not-sufficient; recovery-path-at-creation; honest that `ant` has no custody tooling today (substrate location an open team decision). §3 and §7 re-synced; the "being revised" note removed.
- **2026-Jun-18 (terminology):** standardized prose on "public wallet address" (the public wallet address where rewards are paid), replacing "reward(s) address"; the literal `--rewards-address` flag and "rewards" (earnings) are unchanged.
- **2026-Jun-18 (interaction model):** added ADR-0010 + §13 — operator personas (human / agent-as-proxy / fully autonomous), do-the-work-by-default disclosure with by-exception escalation, and a plain-language register + translation map ("a transaction fee for the payment", not "native Arbitrum gas"). Open questions renumbered §13→§14.
- **2026-Jun-22 (interaction model expanded):** §13 personas deepened on a consistent Surfaces / Asks / Controls / Register frame with the concentric framing (fully-autonomous = the engine; proxy + steered inherit it) and worked examples; persona 3 renamed **Steered operation** (was "human operator (direct)"); the fully-autonomous persona reframed from "no human in the loop" to "no human in the *operational* loop" (distal delegator; async escalation). Design under ADR-0010 (no new decision).
