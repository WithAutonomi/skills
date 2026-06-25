# Handoff — review entry & continuity

> **For:** Hermes (review) and David (gate-holder). **From:** Jim. **Date:** 2026-06-25.
> **Heads-up:** Jim is **away and unavailable for a period** — can't unblock anything in real time. This doc is written so the team can keep moving without him.

## TL;DR

The `autonomi` skill — teaching an agent to run Autonomi nodes and earn ANT, non-custodially — is rebuilt, source-bound, agent-tested, and ready to review. **Everything is now on `main`** — one branch, no open PRs to chase — so `npx skills add JimCollinson/skills` installs it directly. This handoff maps the repo, states what you can decide while Jim's away, and how to test.

**Start here:** `README.md` → `skills/autonomi/SKILL.md` → its `references/` → this doc → `planning/REBUILD-BRIEF.md` (the full rationale) → `docs/adr/`. Then run the test in `planning/TESTING.md`.

## What's in the repo (all on `main`)

- **`skills/autonomi/`** — the installable skill: `SKILL.md` + `references/` (node provisioning, operating procedures, uninstall, wallet-and-tokens, troubleshooting).
- **`docs/adr/`** — the architecture decisions, ADR-0001 to ADR-0012, all **Proposed**.
- **`planning/`** — `REBUILD-BRIEF.md` (the rationale/contract), `node-resource-spec-brief.md` (for the dev team), `TESTING.md`, `NEXT-PHASE.md` (parked threads), `release-endpoint-accessibility.md` (an upstream flag), and the OpenCode packet.
- **`source-bindings/`** — provenance: every command/figure bound to upstream code (drives the planned auto-update).
- `README.md`, `CONTRIBUTING.md`.

The repo is a single clean `main` — the earlier rebuild / brief / ADR branches have all been merged and removed, so there's nothing else to track down.

## Governance while Jim is away

Agreed model: **David + Hermes self-approve within bounds.**

- **Proceed freely (review + merge):** skill content and wording, `references/`, `docs/` prose, `README`, `planning/` notes, troubleshooting, tests, bug fixes, source-binding corrections. Use branch + PR; David approves Hermes's PRs and vice-versa.
- **Hold for Jim (or take to the wider team):** **architecture / protocol / security** decisions and marking ADRs **Accepted**; **distribution-channel** changes; any further **repo/skill renaming**; anything touching **keys / custody / spend** (out of scope for the skill anyway). These aren't blockers for improving the skill — they're the few things to leave parked.
- **Org transfer to `WithAutonomi`** is pending Hermes confirming the name/home (ADR-0007 / 0012); once he's happy, Jim does the transfer. Until then it stays on `JimCollinson/skills` (GitHub auto-redirects old URLs after the move).
- The **release-endpoint** item (below) is an upstream `ant-client` change — raise with the wider MaidSafe team, not gated on Jim.

ADR discipline holds: inspect `docs/adr/` before changing architecture; draft new decisions as **Proposed**; never edit an Accepted ADR (supersede instead).

## State of the skill (what's done)

- **Source-bound:** every command, flag, and figure is tied to upstream `ant-client` / `ant-node` code (see `source-bindings/`). Where a figure leads the docs (the ~20 GB/node disk minimum), it's flagged inline as team-confirmed, pending source.
- **Safety doctrine:** non-custodial (nodes only ever get a public `--rewards-address`); spending/custody is out of scope and gated; daemon stays on loopback; no key handling anywhere.
- **Deliberate capacity model:** the agent decides what to contribute and where (which volume, how many nodes) up front, can place node data on other volumes via `--data-dir-path` (with the human's consent for their media), and monitors capacity over time.
- **Complete teardown:** `references/node-uninstall.md` covers nodes, daemon, CLI, custom/external data dirs, config paths, and a verification step. No OS service is involved (verified in source).
- **Reviewed:** a fresh adversarial pass flagged three things as "invented" that are in fact source-bound + live-tested (`DELETE /api/v1/nodes/{id}`, daemon ordering, network defaults) — docs lag the code. Lesson logged: review against the source manifest, not just the docs.
- **Agent-tested:** an OpenCode agent installed the skill and ran it to the preflight gate, correctly and safely (details in `planning/TESTING.md`).

## Open items & Jim's guidance (so you're not blocked)

1. **Org transfer + repo name.** Move to **`WithAutonomi/skills`** so the team owns it while Jim's away — pending your 👍 on the name/home (reasoning in ADR-0007 / 0012). Jim does the transfer once confirmed. Renamable later.
2. **The decision ADRs (0007 / 0008 / 0012)** — on `main`, **Proposed**. Review and comment freely, but leave them Proposed; Jim marks them Accepted on his return.
3. **Release-endpoint accessibility** (`planning/release-endpoint-accessibility.md`). The `ant` binary serves from a CDN many agent sandboxes block. Directions + a PR-candidate are written up; raise with the wider team (likely Chris / the release process) — it's an `ant-client` change, not a skills-repo one.
4. **Node-resource SOP brief → dev team** (`planning/node-resource-spec-brief.md`). What an operating agent needs to understand (resource numbers + the standing/shunning/reward model) and the *form* the answers must take (hard values where knowable, explicit principles where judgement). The dev team should author a single authoritative *Recommended Node Resource Document* the skill source-binds to. Being shared with the team.
5. **Parked next-phase threads** (`planning/NEXT-PHASE.md`): UX/model tuning; the resource specs above; source-bound auto-update automation; consolidating the developer skill into this repo; and the **skill self-update mechanism** (§5 — how an installed copy learns it's stale across channels, not just skills.sh).
6. **Voice/behaviour ADRs not yet written.** The brief (§10) plans three: "no autonomy tiers," "skill voice — no internal vocabulary," and a tightening of ADR-0010 (modes design-only; two-register voice). Captured as intent; the team can author them.
7. **Keywords / discovery.** A supply-side keyword pass (`earn`, `spare-capacity`, etc.) and the `post-quantum` keyword call are open (brief §8).
8. **Full live end-to-end run.** Not yet done — needs a host with ≥ ~20 GB free, full egress (binary CDN + Arbitrum RPC), ideally no pre-existing nodes. See `TESTING.md`.

## How to test

See **`planning/TESTING.md`** — it has the repeatable agent-run prompt, the evidence so far, and what a full pass needs.

## Contact

Jim is away and unavailable for a period. **David is the point of contact** in his absence. Feedback that would otherwise go to Jim: leave it in PR comments / `planning/` notes for his return.
