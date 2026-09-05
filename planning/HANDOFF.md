# Current state & handoff

> **Entry point** for anyone — human or agent — picking up the `autonomi` skill. **Owner:** Jim. **Updated:** 2026-09-05. Read this first for where things stand and what's next.

## TL;DR

The `autonomi` skill — teaching an agent to run Autonomi nodes and earn ANT, non-custodially — is rebuilt, source-bound, and agent-tested to the preflight gate. It lives on a single clean `main` at **`WithAutonomi/skills`** (private), installable with `npx skills add WithAutonomi/skills`. The rebuild and the org transfer are done; work is now **recommencing** on the open threads below.

**Start here:** `README.md` → `skills/autonomi/SKILL.md` → its `references/` → this doc → `planning/REBUILD-BRIEF.md` (the full rationale) → `docs/adr/`. To test: `planning/TESTING.md`.

## What's in the repo (all on `main`)

- **`skills/autonomi/`** — the installable skill: `SKILL.md` + `references/` (node provisioning, operating procedures, uninstall, wallet-and-tokens, troubleshooting).
- **`docs/adr/`** — architecture decisions, ADR-0001 to ADR-0014, all **Proposed**.
- **`planning/`** — `REBUILD-BRIEF.md` (rationale/contract), `node-resource-spec-brief.md` (for the dev team), `TESTING.md`, `NEXT-PHASE.md` (parked threads), `release-endpoint-accessibility.md` (an upstream flag), and the OpenCode packet.
- **`source-bindings/`** — provenance: commands and sourced figures bound to upstream code; explicitly labelled team-confirmed values remain pending upstream authority (drives planned release regeneration).
- `README.md`, `CONTRIBUTING.md`.

Single clean `main` — all the earlier rebuild / brief / ADR branches were merged and removed.

## Repo & operational facts

- **Home & owner:** `WithAutonomi/skills`, transferred from `JimCollinson/skills` (GitHub redirects the old URLs). Hermes signed off on the name/home (ADR-0007 / 0012).
- **Visibility — private for now.** It will go **public at launch**: public is what enables unauthenticated `skills.sh` installs and true clean-context testing, and it's also what actually switches branch protection on (below). While private, installing via skills.sh needs the runner's own GitHub auth (an org member with access).
- **Branch protection — configured but not enforced.** A `main-branch-protect` ruleset exists (require a PR, block force-push + deletion, require the ADR CI check, 0 required approvals), but GitHub only enforces rulesets on **private** repos under **GitHub Team+**, and this org is on the free plan. So it's currently **honour-system** — branch + PR by convention (`CONTRIBUTING.md`). It **auto-activates when the repo goes public** (or the org upgrades).
- **Agent/integration access:** because the repo is private, an external integration (automation, or an agent's GitHub tooling) needs an explicit org grant to reach it — otherwise it can't read or write the repo.
- **Install:** `npx skills add WithAutonomi/skills` (from `main`; while private, needs the runner's GitHub auth).

## Working model & gates

- **Branch + PR** for changes — don't commit straight to `main` (protection is convention-only for now, so this runs on trust).
- **Proceed freely:** skill content and wording, `references/`, `docs/` prose, `README`, `planning/`, troubleshooting, tests, bug fixes, source-binding corrections.
- **Gated (needs an ADR and/or Jim):** architecture / protocol / security decisions and **accepting ADRs**; distribution-channel changes; repo/skill renaming; the **public flip**; anything touching keys / custody / spend (out of scope for the skill anyway).
- **ADR discipline:** inspect `docs/adr/` before changing architecture; draft new decisions as **Proposed**; never edit an Accepted ADR (supersede instead).

## State of the skill (what's done)

- **Source-bound with explicit exceptions:** every command and flag is tied to upstream `ant-client` / `ant-node` code (see `source-bindings/`). A figure that leads upstream documentation, such as the ~20 GB/node disk minimum, is labelled team-confirmed and pending source rather than presented as source-bound.
- **Safety doctrine:** non-custodial (nodes only ever get a public `--rewards-address`); spending/custody is out of scope and gated; daemon stays on loopback; no key handling anywhere.
- **Deliberate capacity model:** the agent decides what to contribute and where (which volume, how many nodes) up front, can place node data on other volumes via `--data-dir-path` (with the human's consent for their media), and monitors capacity over time.
- **Complete teardown:** `references/node-uninstall.md` covers nodes, daemon, CLI, custom/external data dirs, config paths, and a verification step. No OS service is involved (verified in source).
- **Reviewed:** a fresh adversarial pass flagged three things as "invented" that are in fact source-bound + live-tested (`DELETE /api/v1/nodes/{id}`, daemon ordering, network defaults) — docs lag the code. Lesson logged: review against the source manifest, not just the docs.
- **Agent-tested:** an OpenCode agent installed the skill and ran it to the preflight gate, correctly and safely (details in `planning/TESTING.md`).

## Open threads (what's next)

1. **Review the decision ADRs** — ADR-0007/0008/0010/0012/0013/0014 remain Proposed and need renewed human review before any acceptance decision.
2. **Full live end-to-end run** — the big unproven bit: we only reached the preflight gate. Proving a node comes up + a balance reads needs a host with ≥ ~20 GB free, full egress (binary CDN + Arbitrum RPC), ideally no pre-existing nodes. See `TESTING.md`.
3. **Node-resource SOP → dev team** (`planning/node-resource-spec-brief.md`) — the dev team to author a single authoritative *Recommended Node Resource Document* (resource numbers + the standing/shunning/reward model; hard values where knowable, explicit principles where judgement) that the skill source-binds to. Not yet picked up.
4. **Release-endpoint accessibility** (`planning/release-endpoint-accessibility.md`) — `ant`'s binary serves from a CDN many agent sandboxes block; an upstream `ant-client` change (likely Chris / the release process).
5. **Skill freshness & channel-owned updates — decided in ADR-0013 (Proposed).** Four mechanisms: documented tool-update context; reviewed source-bound regeneration; installation-channel delivery with no in-skill version probe; and a bounded, data-only, best-effort live check for volatile values. Release automation is staged in `NEXT-PHASE.md` §3; mechanism 4 depends on the resource document and a later protocol/spec.
6. **Parked next-phase** (`NEXT-PHASE.md`): UX / model-interpretation tuning; consolidating the developer skill into this repo.
7. **Voice/behaviour decisions — authored.** ADR-0010 amended (register runs two directions; translate by judgement, not find-and-replace); new **ADR-0014 (Proposed)** — autonomy is an input (no surfaced tiers), default-deny under uncertain remit, and a clean product surface (no internal vocabulary). Both Proposed, pending review.
8. **Keywords / discovery** (brief §8): a supply-side keyword pass + the `post-quantum` keyword call.

## How to test

See **`planning/TESTING.md`** — the repeatable agent-run prompt, the evidence so far, and what a full pass needs.

## Contacts

Jim (owner); David and Hermes contribute. Raise decisions/questions via PR comments or `planning/` notes.
