# Autonomi Operator Skill — Roadmap

> Canonical roadmap (the vault holds only a pointer). It sequences the work; it does not restate VISION, amend the ADRs, or write DESIGN. Two axes run through it: **build phases** (*how* we build — design → author → automate) and the **delivery scope ladder** (*what the skill does*, per capability tier). Phase 02 authors the ladder tiers in order. ADRs are referenced, not redefined; ADR **acceptance** is a human gate held by the decision owner (Jim) after the named reviewer's review (David Irvine), and any PR / merge / publish is a maintainer-approval gate.

## Overview

| Phase | Name                    | Goal                                                                                  | Status                |
| ----- | ----------------------- | ------------------------------------------------------------------------------------- | --------------------- |
| 01    | Design & de-risk        | Settle shape, scope, and the load-bearing decisions before any authoring              | In progress (nearly done) |
| 02    | Author the skill        | Build the operator skill, climbing the delivery scope ladder tier by tier             | Not started           |
| 03    | Automate freshness      | Add the upstream-sweep so the skill is kept current mechanically (deferred per ADR-0006) | Not started           |

---

## Phase 01: Design & de-risk

**Goal:** Lock the skill's shape, scope, interface stance, and safety posture as reviewable decisions, so authoring can proceed without re-litigating architecture. DESIGN substantially complete; the load-bearing decisions captured as ADRs.

**Milestones:**
- [x] Standalone repo created with portfolio ADR governance (template, `.adr-kit.yaml`, governance script, CI gate) — ADR-0001.
- [x] Scope and shape fixed: one holistic, internally-modular, progressively-disclosed operator skill (use, not build), x0x as precedent — ADR-0002, ADR-0008.
- [x] Operator scope, boundary, and interface stance set: existing `ant` CLI + node-management daemon, no new tooling, build frontier routes to the Developer skill — ADR-0003.
- [x] Non-custodial node operation committed; reward-address sourcing as a neutral menu (supplied / provisioned / agent-created); agent-created first-class for autonomous use via an out-of-context custody substrate (never LLM-created), secrets-out-of-context necessary-but-not-sufficient, declared recovery path at creation — ADR-0004.
- [x] Spend-to-store understood and escalated: real path is ANT + native Arbitrum gas; **no upstream gasless path exists**; gas is a team strategy call, not an in-skill invention — ADR-0005.
- [x] Source-binding decided: every claim source-bound to upstream, volatile facts single-sourced, mechanically-derived vs judgement-derived split, plus the cross-repo freshness contract — ADR-0006.
- [x] Repo home and lifecycle decided: standalone repo, org-owned before public; independent lifecycle, no lockstep between skill / `ant` / `ant-node`; source bindings are provenance, not runtime pins — ADR-0007, ADR-0009.
- [x] DESIGN substantially complete and realigned to ADR-0001…0009 (including the capability ladder, §12).
- [x] Repo published and under review (`JimCollinson/autonomi-skill`, David a collaborator; Hermes/David review pass).
- [ ] **ADR acceptance** — Jim (decision owner) accepts the nine Proposed ADRs after David's review (human gate; not done autonomously).
- [ ] **Agent wallet custody substrate** decided — where keygen / storage / recovery / signing live (assumed-host / signposted / skill-provided wrapper / upstream `ant` / staged). Open team decision; gates Tier 2/3 — ADR-0004.
- [ ] **Gas strategy** decided — the route that lets earned ANT actually be spent (agent ETH float / pre-funded envelope / faucet-grant / paymaster / defer). Open team decision; gates Tier 3 — ADR-0005.
- [ ] Source-binding manifest format pinned (the `source_evidence` vs `tested_with` / `requires_min` / `known_incompatible` shape) before authoring — ADR-0006, ADR-0009.
- [ ] Close-group size resolved (read as both 5 and 7 in source) — pin or fetch-live before authoring runbooks.
- [ ] Pre-publish housekeeping confirmed: org transfer (→ WithAutonomi), licence (likely MIT OR Apache-2.0 — TBC), and the clean install / version-manifest URL — ADR-0007, ADR-0008.

**Definition of Done:**
- DESIGN substantially complete and the load-bearing ADRs drafted as Proposed — **essentially met**. The phase closes when the ADRs are accepted (Jim as decision owner, after David's review) and the two open team decisions (custody substrate, gas strategy) are recorded, the manifest format and close-group size are pinned, and the pre-publish items are resolved. ADR acceptance is a human gate; the custody and gas calls are team decisions, not @pm/agent calls.

> The two open team decisions do not block all of Phase 02: Tier 1 (operate-and-earn) is unblocked and can be authored while custody (Tier 2) and gas (Tier 3) are settled.

---

## Phase 02: Author the skill

**Goal:** Produce the installable operator skill — SKILL.md, modules, templates, install manifest, and verification — built on the existing `ant` CLI + daemon (ADR-0003, ADR-0008), source-bound throughout (ADR-0006), climbing the delivery scope ladder tier by tier. Each tier ships a complete, honest story for what it covers; later tiers add modules and routing, never a second install (ADR-0002).

**Milestones:**

*Foundation (spans all tiers):*
- [ ] Lean, routing-first SKILL.md authored (opener, task routing, core concepts, safety boundaries, routing table) per DESIGN §2; metadata/frontmatter, provenance/attribution, and install manifest on x0x's `metadata.openclaw.install` pattern — ADR-0008.
- [ ] Skill-led, non-mutating install + verified delivery: detect/install the existing `ant` only when missing, confirm checksums + ML-DSA-65 signatures before use, clean uninstall path — ADR-0008, ADR-0009.
- [ ] Source-binding manifest populated as content lands (provenance per claim; volatile facts single-sourced; bake-with-pin vs fetch-live per fact) — ADR-0006.

*Tier 1 — Operate and earn (authored first; unblocked now):*
- [ ] `node-operation.md`: install, run one/many, configure, monitor (`ant node status`, daemon `/api/v1/events` SSE), upgrade/stop, clean uninstall.
- [ ] `wallet-and-ant.md` (receive side): the public reward address (non-custodial by construction), checking balance; the sourcing menu present with agent-created framed first-class but its substrate gated to Tier 2 — ADR-0004.
- [ ] `operating-procedures.md` + `troubleshooting.md`: the network-enforces / skill-recommends / agent-judges boundary model; good-citizen heuristics.
- [ ] Templates: `node-preflight-checklist`, `node-health-report`, `human-authority-request`.
- [ ] **Tier-1 verification gauntlet:** evidence captured; a fresh clean-context agent completes the node-operate-and-earn journey on the **live network** from a single install with only a public address (no key handled); a fresh adversarial review; blockers resolved or accepted by the maintainer — ADR-0002, ADR-0008.

*Tier 2 — Secure and reason about ANT (gated on the custody decision, ADR-0004):*
- [ ] `wallet-and-ant.md` (custody side): the chosen custody substrate's create/store/recover/sign path with secrets out of context; the supplied/provisioned path; balance and gas visibility; "what can I do next?" guidance.
- [ ] `agent-autonomy-policy.md`: "operate autonomously, spend under authority" — resource/spend envelopes and risk-based escalation — ADR-0004, ADR-0009.
- [ ] **Tier-2 verification gauntlet:** review confirms no key/seed/keystore/signing token ever enters the agent context (only public address / balance / tx hash / status); recovery declared at creation or wallet marked disposable; escalation on the defined risk triggers — ADR-0004.

*Tier 3 — Spend / store loop (gated on the gas decision, ADR-0005, and the custody decision, ADR-0004):*
- [ ] `using-ant-and-data.md` (spend side): upload/retrieve with ANT + the chosen gas route; the full autonomous earn→store workflow. Until both decisions land, this module ships **mental model + honest pointers only** (the gas constraint stated plainly; acquisition deferred to pointers) — ADR-0005.
- [ ] **Tier-3 verification gauntlet:** the closed earn→store loop demonstrated on the live network within the chosen gas strategy; no gasless path implied; spend confined to a granted envelope through the substrate boundary.

**Definition of Done:**
- A clean-context agent, given only the installed skill, completes the operate-and-earn journey end to end on the live network and the skill passes the security scan (the Tier-1 bar that makes the skill releasable). Tier 2 and Tier 3 are done when their gating team decisions are made and each clears its own verification gauntlet. Every shipped claim is source-bound; no tier implies tooling or a payment path that upstream does not provide.

> Authoring SKILL.md, the manifest schema, and module contents needs the source-binding manifest format pinned and the close-group size resolved (Phase 01 open items). Tier 2 cannot be authored as *complete* until the custody substrate is chosen; Tier 3 cannot until both the custody and gas decisions are made — flag the missing decision, do not invent a substrate or a gas mechanism.

---

## Phase 03: Automate freshness

**Goal:** Turn the regeneration-ready structure into a working pipeline so the skill is kept current mechanically rather than by hand — the deferred half of ADR-0006.

**Milestones:**
- [ ] Version self-check live: the skill fetches a manifest from an Autonomi-controlled URL and warns if stale, continues if offline — ADR-0006.
- [ ] Upstream-sweep pipeline: analyses the enumerated upstream watch-set, regenerates mechanically-derived content, flags judgement-derived content for review — ADR-0006.
- [ ] Cross-repo freshness contract operational: upstream repos signal operator-facing changes (issue/PR or release-note marker the freshness check consumes) — ADR-0006, ADR-0007.

**Definition of Done:**
- An installed copy self-reports staleness, and an upstream change to a source-bound fact is detected and routed to regeneration-or-review without a manual rewrite. (Structure is mandatory from Phase 02; the pipeline itself is explicitly deferred per ADR-0006 and may begin only after the watch-set and "material change" policy are settled.)

---

## Delivery scope ladder (product capability tiers)

What the skill *does*, per release tier — the conceptual scope map from DESIGN §12. Phase 02 authors these in order; the **sequencing and definition of done live here, not in the ADRs** (ADR-0004/0005 nod to the ladder but do not fix it). A closed earn→store loop is **not** required for value — useful node operation lands first.

- [ ] **Tier 1 — Operate and earn.** Install/detect `ant`; accept or provision a public reward address under safe policy; run, manage, and monitor nodes; track rewards and balances; clean uninstall / recovery. The skill neither creates nor holds a key at this tier. *(Unblocked now.)*
- [ ] **Tier 2 — Secure and reason about ANT.** Wallet policy; the agent-managed (secrets-out-of-context) custody path and the user/provisioned path; balance and gas visibility; "what can I do next?" guidance. *(Gated on the custody-substrate decision — ADR-0004.)*
- [ ] **Tier 3 — Spend / store loop.** A chosen gas strategy; upload/retrieve with ANT + gas (or a funding/paymaster route); the full autonomous earn→store workflow. *(Gated on the gas-strategy decision — ADR-0005 — and the custody decision — ADR-0004.)*

The skill stays honest about the boundary at every tier: *it can operate nodes and help an agent earn; autonomous storage-spending depends on the gas/payment path and the custody decision.*

---

## Future Phases (Backlog)

<!-- Not yet planned in detail; carried as direction, not commitment. Each is a Phase-02 module/routing addition (ADR-0002), never a new install. -->

- **ANT acquisition.** Beyond earning — a neutral menu of paths to obtain ANT when earnings fall short (currently pointers only). Surfaces once the spend/store tier is solid — ADR-0005.
- **Build-frontier routing.** Strengthen the onward hand-off to the Autonomi Developer skill at the point where "using" shades into "building on" the network — ADR-0003.
- **GUI / human-facing surfaces.** Out of scope for the agent-first passes; revisit only if there is a clear non-primary-user need.
- **Agent-native node interface.** A future upstream node-operation MCP (none exists today) would be a separate decision, not part of this skill's work — ADR-0003.
