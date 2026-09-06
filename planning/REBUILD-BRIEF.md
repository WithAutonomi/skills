# Autonomi Skill — Rebuild Brief

> **Historical June rebuild contract.** The build has since landed and this brief is superseded for current work by `docs/CURRENT.md`, `planning/HANDOFF.md`, and the Proposed ADRs. Its staged-branch status, separate-developer-skill plan, and OpenClaw exploration are retained as design history, not present-tense instructions; the current 0.1.4 prototype combines task routes and supports skills.sh, Claude Code, and direct/manual installation.

## 0. Approach

1. **Consolidate & lock** — this brief; open calls closed (§11).
2. **Co-build, artifact-first** — draft `SKILL.md` spine together, then the references; on a branch; source-bound throughout. Specs/ADRs updated just behind to capture the contract + lessons.
3. **Verify & propose** — clean-context + adversarial gauntlet by fresh agents; evidence captured; PR for Jim's approval, coordinated with David + Hermes (shared repo).
- **PR #7 (the held OC build) is superseded by this rebuild, not merged.**
- **Status (2026-06-24):** the decision-lane ADR PR (0007 / 0008 / 0012 — repo, distribution, naming) is **staged** on branch `docs/skills-repo-naming-distribution`, awaiting Jim to open as a draft + David/Hermes review. The skill build is on `feat/rebuild-skill` (SKILL.md + 5 references, source-bound). This brief is committed at `planning/REBUILD-BRIEF.md` on `docs/rebuild-brief`.

## 1. Governing posture (north star)

Autonomi runs **quietly in the background**; the **agent absorbs the complexity** (jargon, admin, crypto mechanics); the **human isn't pestered** unless they ask in, and isn't shown jargon unless the agent judges that's their register. Plain-and-quiet is the **default, adaptive by judgement — not a rule**. Everything below serves this.

## 2. Naming, repo & distribution

- **Skill name:** `autonomi` (frontmatter `name`, = folder name) → invoked `/autonomi`. Flagship "use the network" skill; `autonomi-developer` is the qualified sibling (build *on* Autonomi). Display H1: "Autonomi".
- **Repo:** `skills` — now `WithAutonomi/skills` (private), the org's first-party skills home (holds `skills/autonomi/` now; ready for siblings like `autonomi-developer`). **Done (2026-06-24):** renamed `JimCollinson/autonomi-skill` to `skills`; **done (2026-06-25):** transferred to `WithAutonomi/skills` with the name/home confirmed.
- **The repo holds multiple first-party skills over time.** `autonomi` (operate nodes + use the network: upload/manage data) now; **`autonomi-developer` (build *on* Autonomi) to consolidate in later.** The developer skill is **draft/beta** and carries its own automation + pulls from the developer docs — so re-homing it is a **non-trivial mini-project to schedule** (roadmap work), not a quick copy. Consolidating first-party skills here — rather than scattering them across the org's source repos — gives users one clean install and one maintenance home. (Captured by amending ADR-0007, §10.)
- **Repo README = the menu of first-party skills.** Lists each available skill with a short description (what it's for, who it's for) — so someone arriving for the developer skill sees it exists and where, rather than being surprised it's in the docs. Same descriptions that power the skills.sh picker → another reason each skill's `description` must be strong.
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
| Install (ClawHub) | Future only — the version-pinned manifest was removed until ant-client offers suitable version-independent release assets |

- **Three layers (the install ergonomics):**
  1. **The skill component** = `skills/autonomi/` (`SKILL.md` + `VERSION` + bundled `references/`) — the only part discovered as a skill; agent-facing; self-contained.
  2. **`references/`** = a subset of that bundle — an operational core loaded on demand; **bundled, not linked** (available without a live-docs dependency and version-locked). Live resources provide optional further depth.
  3. **Repo-side, never loaded as skill instructions** = `docs/`, `docs/adr/`, `planning/`, `source-bindings/` — human/maintainer/process-facing (`source-bindings` exists to drive autonomous regeneration, not for the running agent). It can be physically present when a channel caches the repository-root plugin package.
  - skills.sh discovery scans root + `skills/`, so a direct skill install pulls **only layer 1**. Claude Code separately caches the repository-root plugin package and discovers layer 1 within it. The `skills/<name>/` subdir does double duty: multi-skill layout **and** the wall that keeps internal scaffolding out of the agent's instructions — the "no internal stuff in the product" principle at the context level.
- **Install behaviour (verified by running the CLI):** it clones the repo and discovers skills (root + `skills/` one level deep → finds `skills/autonomi/`). **One skill → installs it; multiple → an interactive multi-select picker** ("Select skills to install (space to toggle)") listing each skill's **name + description** — so the `description` is also the picker copy (another reason it must be strong). Flags: `--skill autonomi` (explicit/deterministic — use in install docs), `--all` (all), `-y` (non-interactive), `--list` (preview). `metadata.internal: true` hides a skill from discovery during build.
- **Channels are plural; the repo is the source.** Current channels are skills.sh (itself multi-agent), Claude Code plugin marketplace, and native/direct installation (directory or git URL). OpenClaw/ClawHub and a possible Autonomi skills marketplace remain future channels. The skill is standards-compliant (agentskills.io), so it is bound to no single channel. (Channel-specific UX like the skills.sh picker is illustrative.)

## 3. Voice & register

- **Two registers.** skill→agent = **precise** (EVM address, `--rewards-address`, ERC-20); agent→human = **translated** to that person ("the wallet where I'll put your earnings"). The translation map is the agent's human-facing tool — soft, illustrative, judgement-applied, **never a find-and-replace**, never the skill's own voice.
- **No internal/build vocabulary in the product:** no "tier", "operator", "persona", "engine", "capture evidence", "Tier 1 package", broken/aspirational refs, or TODO flags. Plain, purpose-first, self-contained.
- **Soft guidance must read as soft** — anything shaped like "standardize/replace X with Y" gets executed literally (the cause of the `public wallet address` find-and-replace).
- **`ant` (CLI) vs ANT (token):** disambiguate every time; in unstyled identifiers (filenames, env vars) disambiguate lexically (`ant-token`, not bare `ant`).

## 4. Modes / autonomy

- **Personas/modes are design artifacts — not surfaced.** The skill does not make the agent self-classify into autonomy tiers; its autonomy is an input it already has from its human/harness.
- Replace with **decision-anchored, universal guidance:** what/how-much to surface, what language, and when creating a wallet / handling keys / signing / spending warrants involving the human. The non-custodial safety line is universal and mode-free.

## 5. SKILL.md structure (the spine — rich, front-loaded)

Order: frontmatter → **what Autonomi is** (network-first; ANT = Autonomi Network Token) → **key terms** (define `ant` vs ANT, node, daemon, public address) → **how you operate + safety invariants** (do-the-work / escalate-by-exception; non-custodial; never handle keys; authority grants/widening explicit, within-envelope action autonomous, reporting adaptive; verify installs honestly; daemon on loopback unless authorised) → **get started** (detect/install → start → verify) → **what you can do** (intent menu → references) → **CLI reference** (core, source-bound) → compact **config (TOML) / storage / common-errors** blocks → **about**.

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
- **Freshness model (see ADR-0013 for the authoritative model):** automation watches upstream vs the manifest → regenerates SKILL.md/references → **re-releases** a versioned snapshot; the using agent can load the bundled guidance without contacting a freshness service, while network operations still require their normal connectivity. New versions are delivered by the installation channel, or by deliberate reinstall for a manual copy, rather than by a self-version request inside the skill. ADR-0013 separately defines a **bounded, data-only, best-effort** runtime check for a narrow class of volatile values (resource/threshold figures), never free-form prose and never a hard dependency for access to the guidance.
- **CI live-test owns command correctness** (not manual review) and is the seed for **troubleshooting** sourcing: upstream known issues + pitfalls anticipated from the code + **gated** agent field-reports (candidate → reproduce/validate → bind → ship).
- **Install-endpoint accessibility (research + CI follow-up — Jim; not blocking the build):** `raw.githubusercontent.com` install URLs are sometimes blocked in agent sandboxes/allowlists while other GitHub URL types aren't. Research + test alternates — notably the **release `latest/download` URL on `github.com`** (`github.com/WithAutonomi/ant-client/releases/latest/download/…`, the x0x pattern), plus `api.github.com` and the jsDelivr CDN. Then (1) source-bind the per-platform release-asset URLs and add them as **install fallbacks**; once stable version-independent assets exist, they can also support a future OpenClaw manifest; (2) add a **CI check that the install endpoints are reachable from a variety of agent environments/allowlists**, to catch a blocked URL before an agent does.
  - **Confirmed (2026-06-24):** `ant-client` DOES publish signed per-platform release archives on `github.com` — latest `ant-cli-v0.2.8`; assets `ant-<ver>-<target>.{tar.gz,zip}` (linux-musl x64/arm64, apple-darwin x64/arm64, windows-msvc) + `.sig` (ML-DSA-65) + `SHA256SUMS.txt`, at `github.com/WithAutonomi/ant-client/releases/download/<tag>/<asset>`. Wrinkle: asset names are **version-stamped** and the tag is `ant-cli-vX.Y.Z`, so x0x's static `latest/download/<fixed-name>` doesn't work as-is — resolve the latest version via `api.github.com/repos/WithAutonomi/ant-client/releases/latest`, then fetch the asset (both allowlist-friendly domains; neither raw.githubusercontent). Bonus: `install.sh` itself is fetched from raw.githubusercontent — the blocked hop — so a direct-asset fallback that skips the script is the real win, and it's verifiable via the `.sig`/SHA256SUMS.
  - **Live sandbox test (2026-06-24) — the blocker is the binary CDN, not the domain:** in a restricted agent sandbox, **reachable**: `raw.githubusercontent.com`, `api.github.com`, `index.crates.io`, `autonomi.com`; **blocked**: `release-assets.githubusercontent.com` (where release binaries actually serve — so `github.com/releases/download` AND the api-asset path both 302→403), `cdn.jsdelivr.net`, `static.crates.io` (no source build), `arb1.arbitrum.io` (balance RPC). Net: **`ant` could not be installed by any path, and balance couldn't be read** — so the github-releases fallback doesn't rescue this case. Implications: (1) the skill should **fail gracefully and name the domains to allowlist** (`release-assets.githubusercontent.com` for install; `arb1.arbitrum.io`/an explorer for balance) instead of flailing; (2) the read-only balance path needs **configurable RPC endpoints + fallbacks**; (3) a full live operational test needs a fuller-network host (the commands themselves are already source-validated by the manifest's live self-test).
- **Live end-to-end verification = agent-run, full-egress (capture for CI).** The clean-context test must be an *agent* following the installed skill end-to-end (install → add → start → status → balance) and seeing the node come up healthy — **not** a human typing commands (the skill is agent-run; the human is never handed CLI). It needs an environment with the binary CDN (`release-assets.githubusercontent.com`) and the Arbitrum RPC (`arb1.arbitrum.io`) reachable — i.e. deliberately broader egress than a default agent sandbox, which blocks both (per the sandbox test above). So the CI/test runner is itself a setup requirement, not a given.
- **Per-node storage minimum = ~20 GB (team-confirmed 2026-06-24; not yet in source/docs).** To avoid **the individual node** being **shunned** (per-node — the network drops just that node, not the agent or machine), provision ≥ ~20 GB free disk per node — distinct from the hard 500 MiB write-reserve. Added to the skill (SKILL.md config, provisioning preflight, operating resource-strategy) **attributed inline as team-confirmed, pending source** — not faked as source-bound. The accountable repository record, unresolved additive/shared semantics, and upstream revalidation path are now captured in `source-bindings/tier1-operate-and-earn.md`; **re-bind to code/docs when upstream catches up** (this is the model for team-confirmed figures that lead the docs).
- **Gauntlet must review against source/manifest, not just docs (lesson, 2026-06-24 adversarial review).** A fresh reviewer with only the public docs flagged three *correct, source-bound, live-tested* things as "invented" — the `DELETE /api/v1/nodes/{id}` single-node removal, the daemon ordering (`add` needs no daemon; `start`/`stop` do), and the `--network-id`-not-forwarded / node-defaults-`arbitrum-one` behaviour — because `docs.autonomi.com` lags the code. Implication: **doc-only reviewers and CI will mis-flag code-bound-but-undocumented facts**, so the gauntlet (and any CI doc-check) must verify against the source-bindings manifest / upstream code, not the docs. Vindicates the skill's "trust the installed tool; docs lag" stance. The review also surfaced genuine small fixes (report-raw-balance/decimals, `SECRET_KEY` wording, daemon parenthetical, count-cap softening, `--upgrade-channel`, PATH note) — applied.

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
- **Repository/distribution = AMEND existing drafts, not a new ADR (all eleven ADRs are Proposed → edit, don't supersede):**
  - **ADR-0007 (standalone repository):** already decides own-repo / not-inside-`ant-client`-or-`ant-node` (✓ point 1). Amend: standalone-single-skill → **dedicated first-party multi-skill `WithAutonomi/skills` repo** (operator now, developer migrating in — consistent with 0007's own rejection of docs-repo homes); **close its open item** (GitHub org/home + install URL) by recording `WithAutonomi/skills`; update its treatment of the developer skill. (May retitle.)
  - **ADR-0008 (structure & distribution):** owns skill-led distribution. Amend with the verified install ergonomics (skills.sh, `--skill autonomi`, multi-select picker, description-as-chooser-copy) + the three-layer ships model; **reconcile its "depth routes outward to live docs" with the bundle-references decision** (bundle-first).
  - Governance: stays Proposed; David reviews; Jim accepts; never mark Accepted autonomously.
  - **Process (Jim's Q):** **amend, not a follow-up ADR** (0007 is Proposed → editable; follow-ups are for Accepted decisions, and refining a draft would leave two competing Proposed ADRs). Keep the evolution in the **PR description, not the ADR body** — the repo's ADR template has no history section, and README Rule 3/4 put change-history in the supersede chain (Accepted) or the PR (Proposed); the ADR stays a clean standalone statement. Land the **skills-strategy ADRs (0007 + 0008 + 0012** — one coherent cluster: repo + distribution + naming) as **one standalone decision-lane PR, reviewed by Hermes/David before/separate from the skill-build PR** — don't bury an architecture decision in a content PR. The other ADR work (no-autonomy-tiers, skill-voice, tighten ADR-0010 register/modes) is a *separate* theme (product voice & behaviour) and rides with the build, not this PR. The re-brief stays out of the decision PR (planning/pre-read, committed separately). **Present the evolution to Hermes** (short note + the PR). Draft via the repo's ADR template (gsd-adr). Also: **repo README lists the available skills** (§2).
- **New authoring & structure spec:** section order, front-load, intent routing, bundle discipline, define-before-use, templates-only-when-the-doc-is-the-deliverable, safety-in-SKILL.md.
- **DESIGN:** §13 personas = design tool (not surfaced); the reference map; remove the terminology directive.
- **CONTRIBUTING:** the authoring rules.

## 11. Open / parked

- Custody substrate (ADR-0004) and gas easing (ADR-0005) — team decisions, gated, deferred.
- Locked this session: modes design-only; `depin` keyword in; provisioning + operation separate; templates removed; bundle references; source-bindings repo-side; security invariants in SKILL.md; repo target `WithAutonomi/skills` (rename done 2026-06-24; transfer gated).
