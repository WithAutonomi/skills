# Autonomi Operator Skill — Design

> Canonical design, realigned to ADR-0001…0008. This supersedes the original pre-decision scaffold (which framed the work as a single "loop" and assumed a gas-abstraction path — both removed). Loose thinking lives in the vault (`Projects/Autonomi Skill`); this is the formal design. Volatile specifics (flags, constants, addresses, URLs) are **source-bound** to upstream per ADR-0006, not hardcoded here.

## 1. Purpose and shape

An **operator skill**: it teaches an AI agent to operate and *use* the Autonomi network, starting with running nodes and expanding toward whole-network use. It is **one holistic, internally-modular skill, progressively disclosed by task routing** (ADR-0002), modelled on x0x (ADR-0008). It teaches the **existing** CLI + daemon surfaces and builds no new tooling (ADR-0003); at the build frontier it points onward to the Developer skill. It lives in its own repository because it is a synthesis across many upstream repos with no natural home in any one (ADR-0007).

The pieces are **interrelated task journeys** — run a node; receive & secure ANT; use ANT to store data; acquire ANT — entered by task and routed via the SKILL.md, overlapping and feeding each other. *Not* a single linear loop.

## 2. SKILL.md structure (the lean, routing-first entry)

1. **Opener** — what Autonomi is, what it's for, and why run a node (David's brief). Accurate and source-bound, neutral on economics, cooperative framing, written to the agent as operator.
2. **Task routing** — "what are you trying to do?": run a node · receive & secure ANT · use ANT to store data · operate autonomously. Routes to modules; embodies the neutral-menu principle (inform the agent's judgement, don't make the decision).
3. **Core concepts** — brief: nodes, ANT, the rewards address, gas, data, human/agent authority.
4. **Safety boundaries** — non-custodial default, irreversibility, the money line, never put a key on a node or in the repo.
5. **Routing table** — which reference/runbook for which task, and onward pointers (Developer skill, live docs, repos).

## 3. Modules (`references/`, loaded on demand)

- `node-operation.md` — install, run one/many, configure, monitor, upgrade/stop. **(iteration-1 core)**
- `wallet-and-ant.md` — the rewards address (non-custodial default + sourcing hierarchy, ADR-0004), EVM address on Arbitrum One (ANT is an ERC-20), checking balance, and securing a key *if one is held* (the fallback custody path). **(iteration-1)**
- `using-ant-and-data.md` — how earned ANT is used to store/retrieve data on the real ANT + Arbitrum-gas path (ADR-0005); onward pointers; acquisition deferred (pointers only in v1). **(mental-model + pointers in v1)**
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

The skill is self-sufficient: installing it is all an agent needs. It installs the **existing** tools — the `ant` CLI (the node-management daemon is the `ant` binary in daemon mode; `ant-node` is fetched per node by the manager).

- **Install paths, with fallbacks (x0x model):** install script (`install.sh` / `install.ps1`, which `ant-client` already ships) → direct release artifacts → build-from-source; plus a fallback source (e.g. raw GitHub) if the primary URL is unreachable.
- **Verification:** confirm checksums and signatures *before use* and report the result to the agent — `ant-node` releases ship `SHA256SUMS` and ML-DSA-65 (FIPS-204) signatures. Plus the checks agents and distribution channels expect: declared behaviour matches actual, and a reviewed install script (ClawHub security scan).
- **Uninstall:** a documented, clean removal path — stop nodes and the daemon, then remove binaries and state (data dirs, registry, caches). Agents trust a skill they can cleanly reverse.
- All install URLs/versions are **source-bound** (ADR-0006) so the paths and fallbacks don't go brittle or stale.

## 7. Rewards and custody (ADR-0004)

Non-custodial by default: the node is given a **public rewards address** only and never holds spend-capable key material. Sourcing, in preference order: supplied by the human/principal → provisioned at setup → agent-generated fallback (record only the public address; the private key is never used to operate the node, so it is secured off the node host and resurfaces only, under authority, to spend). The address must be a valid EVM address usable on **Arbitrum One** (ANT is an ERC-20 there) so the holder can view and use the earned ANT.

## 8. Spend and acquire (ADR-0005; neutral-menu principle)

Document the real, current path to store data — ANT (ERC-20) **plus** a little native Arbitrum gas (ETH); there is no gasless path upstream, and we invent none — and surface the gas barrier as a known limitation to escalate. Present a neutral menu of paths to ANT (earn / acquire / obtain) and the live means to assess sufficiency (balance, `ant file cost`), so the agent judges for its remit; never editorialise volatile economics. ANT **acquisition** content is deferred from iteration 1 (onward pointers in v1).

## 9. Operating well — the boundary model

Three buckets the skill keeps distinct: **what the network enforces** (facts the agent works within), **what the skill recommends** (derived good-citizen procedures — right-size to the machine, spread across IPs/subnets where possible, keep nodes reliable), and **what is the agent's judgement** (how many nodes, distribution, scale up/down, autonomous vs human-checked). Functional and parameter-grounded, not network-design exposition.

## 10. Staying current (ADR-0006)

Every claim is **source-bound** to upstream (repo / file / symbol / commit) via a source-binding manifest; volatile facts are isolated and single-sourced; content is tagged mechanically-derived (auto-regenerable) vs judgement-derived (flag-for-review); per fact, a deliberate bake-with-pin vs fetch-live choice. An in-skill **version self-check** fetches a manifest from an Autonomi-controlled URL and warns if stale, continues if offline. The automation pipeline (upstream-sweep) is deferred; the regeneration-ready structure is mandatory now.

## 11. Metadata, licensing, provenance (ADR-0008)

Frontmatter: name, a triggering-tuned description, version, license, keywords. An install manifest on x0x's `metadata.openclaw.install` pattern. Licensing to match upstream (likely MIT OR Apache-2.0 — TBC). Clear **provenance / "about"**: the team behind it, the upstream repos it synthesises, and links — so agents and distribution channels can see what's behind it.

## 12. Iteration-1 scope and verification

**Scope (complete operate-and-earn, nothing required left out):** opener → resource preflight → install (CLI + daemon, fallbacks, verification) → run one and several nodes (count/ports/distribution within diversity limits) → monitor health (status + events) → non-custodial rewards address → the wallet/ANT needed to earn and secure → onward pointers for spend/data/acquire → clean uninstall. No new tooling; spend/data acquisition are mental-model + pointers.

**Definition of done:** a clean-context agent, given only the installed skill, runs and monitors a healthy node (one and several) on the **live network**, with a non-custodial rewards address, knows how to check and secure earnings, and can cleanly uninstall — without inventing commands.

## 13. Open questions (carried; mostly David/maintainer)

- GitHub home/org and clean install URL; published skill name; version-manifest hosting URL.
- Gas / acquisition easing (DEX guidance, a paymaster if one returns) — escalate to David.
- Upstream watch-set and "material change" policy (for the deferred automation).
- Pin volatile constants or fetch-live (e.g. the close-group size — read as both 5 and 7; resolve before authoring).

## Design History

- **2026-Jun-17:** Rewritten and realigned to ADR-0001…0008, superseding the original pre-decision scaffold; removed the "loop" abstraction and all gas-abstraction framing; added install/secure-delivery, uninstall, licensing, and provenance.
