# Autonomi Operator Skill — Design

> Canonical design, realigned to ADR-0001…0009. This supersedes the original pre-decision scaffold (which framed the work as a single "loop" and assumed a gas-abstraction path — both removed). Loose thinking lives in the vault (`Projects/Autonomi Skill`); this is the formal design. Volatile specifics (flags, constants, addresses, URLs) are **source-bound** to upstream per ADR-0006, not hardcoded here.

## 1. Purpose and shape

An **operator skill**: it teaches an AI agent to operate and *use* the Autonomi network, starting with running nodes and expanding toward whole-network use. It is **one holistic, internally-modular skill, progressively disclosed by task routing** (ADR-0002), with x0x as a precedent (ADR-0008). It teaches the **existing** CLI + daemon surfaces and builds no new tooling (ADR-0003); at the build frontier it points onward to the Developer skill. It lives in its own repository because it is a synthesis across many upstream repos with no natural home in any one (ADR-0007).

The pieces are **interrelated task journeys** — run a node; receive & secure ANT; use ANT to store data; acquire ANT — entered by task and routed via the SKILL.md, overlapping and feeding each other. *Not* a single linear loop.

## 2. SKILL.md structure (the lean, routing-first entry)

1. **Opener** — what Autonomi is, what it's for, and why run a node (David's brief). Accurate and source-bound, neutral on economics, cooperative framing, written to the agent as operator.
2. **Task routing** — "what are you trying to do?": run a node · receive & secure ANT · use ANT to store data · operate autonomously. Routes to modules; embodies the neutral-menu principle (inform the agent's judgement, don't make the decision).
3. **Core concepts** — brief: nodes, ANT, the rewards address, gas, data, human/agent authority.
4. **Safety boundaries** — non-custodial default, irreversibility, the money line, never put a key on a node or in the repo.
5. **Routing table** — which reference/runbook for which task, and onward pointers (Developer skill, live docs, repos).

## 3. Modules (`references/`, loaded on demand)

- `node-operation.md` — install, run one/many, configure, monitor, upgrade/stop. **(operate-and-earn)**
- `wallet-and-ant.md` — the public reward address (node non-custodial by construction) and the **menu** of sourcing options (supplied / provisioned / agent-created), with **agent-created first-class** for autonomous use via an out-of-context custody substrate — never LLM-created (ADR-0004); EVM address on Arbitrum One (ANT is an ERC-20); checking balance; and custody/recovery only where the agent owns a wallet (secrets out of context; declared recovery at creation). **(operate-and-earn → secure ANT)**
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

Node operation is **non-custodial by construction**: the node is given a **public reward address** only, holds no key, and the skill never needs or handles a private key to run a node. Reward-wallet sourcing is a **neutral menu** — not a ranked ladder and not a hard default: **supplied**, **provisioned**, or **agent-created**. Agent-created is **first-class for autonomous use**, but is substrate-created on the agent's behalf — **never LLM-created**: keeping the key out of the agent context is *necessary but not sufficient*, so it is permitted only through a custody substrate that also provides encryption at rest, a **declared recovery path at creation**, a scoped spend policy, auditability, and signing confined to the substrate boundary (the agent sees only public address / balance / tx hash / status). Receiving is fully autonomous; spending is remit-gated (ADR-0009) with risk-based escalation. Because `ant` provides no wallet creation, keystore, or signing boundary today, agent-owned spend is a **target capability gated on an open team decision** about where the custody substrate lives (assumed-host / signposted / skill-provided wrapper / upstream `ant` / staged); operate-and-earn runs now on a public address. The address must be a valid EVM address usable on **Arbitrum One** (ANT is an ERC-20 there).

## 8. Spend and acquire (ADR-0005; neutral-menu principle)

Document the real, current path to store data — ANT (ERC-20) **plus** a little native Arbitrum gas (ETH); there is no gasless path upstream, and we invent none — and surface the gas barrier as a known limitation to escalate. Present a neutral menu of paths to ANT (earn / acquire / obtain) and the live means to assess sufficiency (balance, `ant file cost`), so the agent judges for its remit; never editorialise volatile economics. ANT **acquisition** is outside the operate-and-earn tier (onward pointers only for now).

## 9. Operating well — the boundary model

Three buckets the skill keeps distinct: **what the network enforces** (facts the agent works within), **what the skill recommends** (derived good-citizen procedures — right-size to the machine, spread across IPs/subnets where possible, keep nodes reliable), and **what is the agent's judgement** (how many nodes, distribution, scale up/down, autonomous vs human-checked). Functional and parameter-grounded, not network-design exposition.

## 10. Staying current (ADR-0006)

Every claim is **source-bound** to upstream (repo / file / symbol / commit) via a source-binding manifest; volatile facts are isolated and single-sourced; content is tagged mechanically-derived (auto-regenerable) vs judgement-derived (flag-for-review); per fact, a deliberate bake-with-pin vs fetch-live choice. An in-skill **version self-check** fetches a manifest from an Autonomi-controlled URL and warns if stale, continues if offline. Upstream repos signal operator-facing changes back to the skill (the cross-repo freshness contract, ADR-0006). The automation pipeline (upstream-sweep) is deferred; the regeneration-ready structure is mandatory now.

## 11. Metadata, licensing, provenance (ADR-0008)

Frontmatter: name, a triggering-tuned description, version, license, keywords. An install manifest on x0x's `metadata.openclaw.install` pattern. Licensing to match upstream (likely MIT OR Apache-2.0 — TBC). Clear **provenance / "about"**: the team behind it, the upstream repos it synthesises, and links — so agents and distribution channels can see what's behind it.

## 12. Progressive delivery — capability ladder

The skill is built to expand (ADR-0002's modular, progressively-disclosed shape; ADR-0005's spend-is-a-frontier stance): useful node operation lands first, and further capability layers on without reworking the core. A closed earn→store loop is *not* required for value.

The ladder below is the **conceptual scope map** — what the capability tiers *are*:

- **Operate and earn** — install/detect `ant`; accept or provision a public reward address under safe policy; run, manage, and monitor nodes; track rewards and balances; clean uninstall / recovery. (The skill neither creates nor holds a key at this tier.)
- **Secure and reason about ANT** — wallet policy; the agent-managed (secrets-out-of-context) custody path and the user/provisioned path; balance and gas visibility; "what can I do next?" guidance.
- **Spend / store loop** — a chosen gas strategy; upload/retrieve with ANT + gas (or a funding/paymaster route); the full autonomous earn→store workflow. Gated on the gas-strategy decision (ADR-0005) and the custody decision (ADR-0004).

> **Sequencing lives in roadmap planning, not here.** What each iteration contains, the order, and the definition of done are owned by `planning/ROADMAP.md` (formalised by @pm). DESIGN holds the *concept*; the roadmap holds the *plan*. ADR-0004/0005 nod to this ladder but do not fix the sequence.

The skill stays honest about the boundary at every tier: *it can operate nodes and help an agent earn; autonomous storage-spending depends on the gas/payment path and the custody decision.*

## 13. Open questions (carried; mostly David/maintainer)

- GitHub home/org and clean install URL; published skill name; version-manifest hosting URL.
- Agent wallet custody substrate (where keygen/storage/recovery/signing live: assumed-host / signposted / skill-provided wrapper / upstream `ant`) — open team decision (relates to ADR-0004).
- Gas / acquisition easing (DEX guidance, a paymaster if one returns) — escalate to David (ADR-0005).
- Upstream watch-set and "material change" policy (for the deferred automation).
- Pin volatile constants or fetch-live (e.g. the close-group size — read as both 5 and 7; resolve before authoring).

## Design History

- **2026-Jun-17:** Rewritten and realigned to ADR-0001…0009, superseding the original pre-decision scaffold; removed the "loop" abstraction and all gas-abstraction framing; added install/secure-delivery, uninstall, licensing, and provenance; aligned to the address-sourcing menu (gated self-generation, no "fallback"/"node host" framing) and the remit-gated, non-mutating install.
- **2026-Jun-18:** Refinement round from team review — added the capability ladder (ADR-0005 as a frontier, not a blocker for node operation); x0x reframed as precedent not dependency; cross-repo freshness contract noted (ADR-0006).
- **2026-Jun-18 (later):** De-versioned the delivery framing — DESIGN keeps the capability ladder as a *concept*; the iteration sequencing, scope, and definition of done move to roadmap planning (`planning/ROADMAP.md`), nodded to from ADR-0004/0005. Module tags now name capability tiers rather than iteration numbers. Added the agent-wallet-custody substrate as an open team decision.
- **2026-Jun-18 (ADR-0004 applied):** ADR-0004 reframed — agent-created wallet first-class for autonomous use via an out-of-context custody substrate (never LLM-created); secrets-out-of-context necessary-but-not-sufficient; recovery-path-at-creation; honest that `ant` has no custody tooling today (substrate location an open team decision). §3 and §7 re-synced; the "being revised" note removed.
