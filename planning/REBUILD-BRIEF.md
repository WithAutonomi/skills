# Autonomi Skill — Rebuild Brief

> The single contract the rebuild is built against, distilled from the session read-through. Supersedes the scratch critique log.

## 0. Approach

1. **Consolidate & lock** — this brief; open calls closed (§11).
2. **Co-build, artifact-first** — draft `SKILL.md` spine together, then the references; on a branch; source-bound throughout. Specs/ADRs updated just behind to capture the contract + lessons.
3. **Verify & propose** — clean-context + adversarial gauntlet by fresh agents; evidence captured; PR for Jim's approval, coordinated with David + Hermes (shared repo).
- **PR #7 (the held OC build) is superseded by this rebuild, not merged.**
- **Status (2026-06-24):** the decision-lane ADR PR (0007 / 0008 / 0012 — repo, distribution, naming) is **staged** on branch `docs/skills-repo-naming-distribution`, awaiting Jim to open as a draft + David/Hermes review. Next: co-build the `SKILL.md` spine (§5).

## 1. Governing posture (north star)

Autonomi runs **quietly in the background**; the **agent absorbs the complexity** (jargon, admin, crypto mechanics); the **human isn't pestered** unless they ask in, and isn't shown jargon unless the agent judges that's their register. Plain-and-quiet is the **default, adaptive by judgement — not a rule**. Everything below serves this.

## 2. Naming, repo & distribution

- **Skill name:** `autonomi` (frontmatter `name`, = folder name) → invoked `/autonomi`. Flagship "use the network" skill; `autonomi-developer` is the qualified sibling (build *on* Autonomi). Display H1: "Autonomi".
- **Repo:** `skills` — target `WithAutonomi/skills`, the org's first-party skills home (holds `skills/autonomi/` now; ready for siblings like `autonomi-developer`). **Plan:** rename the current `JimCollinson/autonomi-skill` → `JimCollinson/skills` now so the later move to the org is a one-hit ownership transfer with the name already correct; GitHub auto-redirects old URLs. Transfer to `WithAutonomi` is a gated step.
- **The repo holds multiple first-party skills over time.** `autonomi` (operate nodes + use the network: upload/manage data) now; **`autonomi-developer` (build *on* Autonomi) to consolidate in later.** The developer skill is **draft/beta** and carries its own automation + pulls from the developer docs — so re-homing it is a **non-trivial mini-project to schedule** (roadmap work), not a quick copy. Consolidating first-party skills here — rather than scattering them across the org's source repos — gives users one clean install and one maintenance home. (Captured by amending ADR-0007, §10.)
- **Repo README = the menu of first-party skills.** Lists each available skill with a short description (what it's for, who it's for) — so someone arriving for the developer skill sees it exists and where, rather than being surprised it's in the docs. Same descriptions that power the install picker → another reason each skill's `description` must be strong.
- **Skill path in repo:** `skills/autonomi/` (subdir) — portable, and keeps repo-side provenance out of the shipped artifact.
- **Decoupling:** repo name appears only in the install string; invocation is `/autonomi` regardless.

| Layer | Value |
|---|---|
| Org (target) | `WithAutonomi` |
| Repo | `skills` (org's first-party skills home) |
| Skill folder | `skills/autonomi/` |
| Skill `name` | `autonomi` |
| Invocation | `/autonomi` |
| Install (skills.sh) | `npx skills add WithAutonomi/skills` (lone skill → installs it) — or `--skill autonomi` to be explicit |
| Install (ClawHub) | `openclaw skills install autonomi` |

- **Three layers (the install ergonomics):**
  1. **The skill bundle** = `skills/autonomi/` (`SKILL.md` + bundled `references/`) — the *only* thing that installs; agent-facing; self-contained.
  2. **`references/`** = a subset of that bundle — agent-facing depth, loaded on demand; **bundled, not linked** (offline / fresh-host / version-locked).
  3. **Repo-side only, never ships** = `docs/`, `docs/adr/`, `planning/`, `source-bindings/` — human/maintainer/process-facing (`source-bindings` exists to drive autonomous regeneration, not for the running agent).
  - Install discovery scans root + `skills/`, so it pulls **only layer 1**. The `skills/<name>/` subdir does double duty: multi-skill layout **and** the wall that keeps internal scaffolding out of the installed product — the "no internal stuff in the product" principle at the file level.
- **Install behaviour (verified by running the CLI):** it clones the repo and discovers skills (root + `skills/` one level deep → finds `skills/autonomi/`). **One skill → installs it; multiple → an interactive multi-select picker** ("Select skills to install (space to toggle)") listing each skill's **name + description** — so the `description` is also the picker copy (another reason it must be strong). Flags: `--skill autonomi` (explicit/deterministic — use in install docs), `--all` (all), `-y` (non-interactive), `--list` (preview). `metadata.internal: true` hides a skill from discovery during build.
- **Channels are plural; the repo is the source.** skills.sh is one channel (itself multi-agent); others: OpenClaw/ClawHub (`metadata.openclaw.install`), native/direct (directory or git URL), and a possible future Autonomi skills marketplace. The skill is standards-compliant (agentskills.io), so it's bound to no single channel. (Channel-specific UX like the skills.sh picker is illustrative.)

## 3. Voice & register

- **Two registers.** skill→agent = **precise** (EVM address, `--rewards-address`, ERC-20); agent→human = **translated** to that person ("the wallet where I'll put your earnings"). The translation map is the agent's human-facing tool — soft, illustrative, judgement-applied, **never a find-and-replace**, never the skill's own voice.
- **No internal/build vocabulary in the product:** no "tier", "operator", "persona", "engine", "capture evidence", "Tier 1 package", broken/aspirational refs, or TODO flags. Plain, purpose-first, self-contained.
- **Soft guidance must read as soft** — anything shaped like "standardize/replace X with Y" gets executed literally (the cause of the `public wallet address` find-and-replace).
- **`ant` (CLI) vs ANT (token):** disambiguate every time; in unstyled identifiers (filenames, env vars) disambiguate lexically (`ant-token`, not bare `ant`).

## 4. Modes / autonomy

- **Personas/modes are design artifacts — not surfaced.** The skill does not make the agent self-classify into autonomy tiers; its autonomy is an input it already has from its human/harness.
- Replace with **decision-anchored, universal guidance:** what/how-much to surface, what language, and when creating a wallet / handling keys / signing / spending warrants involving the human. The non-custodial safety line is universal and mode-free.

## 5. SKILL.md structure (the spine — rich, front-loaded)

Order: frontmatter → **what Autonomi is** (network-first; ANT = Autonomi Network Token) → **key terms** (define `ant` vs ANT, node, daemon, public address) → **how you operate + safety invariants** (do-the-work / escalate-by-exception; non-custodial; never handle keys; spend/authority gated + surfaced; verify installs honestly; daemon on loopback unless authorised) → **get started** (detect/install → start → verify) → **what you can do** (intent menu → references) → **CLI reference** (core, source-bound) → compact **config (TOML) / storage / common-errors** blocks → **about**.

- **Scope line** near the top: covers running/managing nodes & earning ANT now; storing/retrieving your own data as the skill grows.
- Front-load install/start/verify; not precious about length; **safety invariants live here** (never behind an on-demand reference).
- **The config (TOML) block is real and source-bound** — not a copy of x0x's. It covers the genuine Autonomi node config: the per-node **disk cap** (only settable via a TOML config, not `ant node add`), `bootstrap_peers.toml`, and node/metrics ports. **Storage** block = node data/log dirs + key locations; **common-errors** = the high-frequency failures (drawn from troubleshooting). Include only what's source-bound; drop a block if it has no real content.

## 6. Reference set (bundled, lean)

`references/`: `node-provisioning` · `node-operating-procedures` · `node-uninstall` · `wallet-and-tokens` (cross-cutting) · `troubleshooting`.

- **Lifecycle split:** provisioning (first-time + the *one-time* preflight; opens with "all reversible → see uninstall") / operating-procedures (high-frequency, lean; the renamed `operating-procedures`, doctrine merged) / uninstall.
- **Preflight = provisioning-time, not per-op.** Inlined (no template).
- **Naming convention:** area-prefix for area-specific (`node-*`); no prefix for cross-cutting (`wallet-and-tokens`, `troubleshooting`).
- **`wallet-and-tokens`:** canonical home for token/wallet/ANT; **owns key/custody/spend depth**; node files point here (no duplication); receive + read-only balance now, spend/custody/acquire later (gated). Rewrite precise-to-agent.
- **Templates:** removed (no use case; reintroduce only if a feature needs one).
- **Security:** core invariants in SKILL.md; depth in-domain; no separate file.
- **Node-operation §0 "rules before touching the machine" → "ground rules"** (invariants/preconditions); "confirm" = the agent's own precondition, not a user prompt; align the address rule to "supplied / provisioned / substrate-created; the skill never creates wallets/keys".

## 7. Source-bindings, freshness & CI

- **Repo-side only**, renamed off `tier1-*` → `source-bindings`. Binds **only what the skill uses/claims**: `ant-client`, `ant-node`, `evmlib` (`self_encryption` orientation-only until data-storage). Reconcile the shipped "synthesised repos" list to this subset.
- **Freshness model:** automation watches upstream vs the manifest → regenerates SKILL.md/references → **re-releases** a version-pinned snapshot. The using agent consumes the bundled snapshot (no runtime live-fetch).
- **CI live-test owns command correctness** (not manual review) and is the seed for **troubleshooting** sourcing: upstream known issues + pitfalls anticipated from the code + **gated** agent field-reports (candidate → reproduce/validate → bind → ship).

## 8. Keywords & scope

Keywords (plain infra/storage lead; `depin` low as an accurate classifier; the *crypto mess* stays out of the voice, not the classification):

`autonomi, ant, peer-to-peer, peer-to-peer-infrastructure, infrastructure, data-storage, decentralized-storage, permanent-storage, storage, node, nodes, networking, depin, earn`

- **Dropped:** `autonomi-network-token` (verbose; `ant` + `autonomi` cover it).
- **Reconsider `post-quantum`:** a real network differentiator, but a weak *discovery* term for an operate/earn skill (someone searching it is researching crypto, not looking to run a node). Lean drop or keep-low — Jim's call.
- **To research (Jim's angle — not yet done):** keywords for *agents earning with spare resources* / supply-side. Candidate terms to ground: `earn`, `monetize` / `monetise`, `passive`, `spare-storage`, `spare-capacity`, `idle-resources`, `resource-sharing`, `storage-rewards`, `node-rewards`, `provider`, `ai-agent`. Run a focused pass against comparable storage-provider / DePIN skills + the skills.sh directory before settling.

## 9. Cleanups

- **Include `llms-full.txt`** (now confirmed reachable) as the comprehensive-context further-reading link, alongside `llms.txt`. Still **not a fact authority** (docs can lag code; facts stay code-bound).
- De-tier all prose; rename source-bindings off `tier1-*`; remove the DESIGN terminology-standardization directive that caused the find-replace.

## 10. Lessons → specs/ADRs (so they don't recur)

- **ADR-0010 (Proposed):** tighten — modes design-only; soft register; two-register; no find-and-replace.
- **New Proposed ADRs (genuinely new decisions):** "skill does not prescribe autonomy tiers"; "skill voice — no internal/build vocabulary, product self-contained"; **ADR-0012 "skill name — the product, not a mode of operation"** (primary skill = `autonomi`; companions = `autonomi-<qualifier>`; "operator/use" stays an internal role, not the name; pre-empts "why not Operator/Client?").
- **Repository/distribution = AMEND existing drafts, not a new ADR** (staged: ADR-0007 + ADR-0008 amended, ADR-0012 added — branch `docs/skills-repo-naming-distribution`). All ADRs stay Proposed; David reviews; Jim accepts; never mark Accepted autonomously. Evolution lives in the PR description, not the ADR body (repo ADR template has no history section). The other ADR work (no-autonomy-tiers, skill-voice, tighten ADR-0010 register/modes) is a *separate* theme (product voice & behaviour) and rides with the build, not the decision PR.
- **New authoring & structure spec:** section order, front-load, intent routing, bundle discipline, define-before-use, templates-only-when-the-doc-is-the-deliverable, safety-in-SKILL.md.
- **DESIGN:** §13 personas = design tool (not surfaced); the reference map; remove the terminology directive.
- **CONTRIBUTING:** the authoring rules.

## 11. Open / parked

- Custody substrate (ADR-0004) and gas easing (ADR-0005) — team decisions, gated, deferred.
- Open: `post-quantum` keyword keep-low/drop; the earn/spare-resource keyword research pass.
- Locked this session: skill name `autonomi`; repo `WithAutonomi/skills`; modes design-only; `depin` keyword in; provisioning + operation separate; templates removed; bundle references; source-bindings repo-side; security invariants in SKILL.md; cross-cutting reference = `wallet-and-tokens`.
