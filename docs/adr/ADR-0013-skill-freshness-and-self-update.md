# ADR-0013: Skill freshness and self-update

- **Status:** Proposed
- **Date:** 2026-07-13
- **Decision owners:** Jim Collinson
- **Reviewers:** David Irvine, Hermes
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0006 (skill content source-bound to upstream), ADR-0008 (structure & distribution — channel-agnostic), ADR-0009 (independent lifecycle / no lockstep); `planning/NEXT-PHASE.md` §3 & §5; `planning/node-resource-spec-brief.md`

## Context

The shipped skill is a **bundled, version-pinned snapshot** — `SKILL.md` plus bundled `references/` — deliberately self-contained so it installs and runs offline and on a fresh host (ADR-0008), with its facts bound to upstream code (ADR-0006).

A snapshot drifts from reality over time, and it does so along **independent axes**: the underlying `ant` tool updates on its own lifecycle; the skill's own instructions get revised; and the operational figures and advice it carries (resource sizing, shunning/standing rules) change faster than the whole skill is re-released. Distribution is channel-agnostic (ADR-0008), so no single channel's update flow can be *the* freshness mechanism; and any runtime fetch is an instruction/injection surface that must be bounded.

This ADR sets out how the skill stays current across those axes without sacrificing offline robustness, source-binding, or trust — by treating them as separate mechanisms rather than one.

## Decision Drivers

- Multiple distribution channels — no single channel's update flow can be the freshness mechanism.
- Offline / fresh-host robustness (ADR-0008) — the skill must install and operate from the bundle with no hard runtime dependency.
- Source-bound discipline (ADR-0006) — facts bind to upstream code; the artifact is regenerated from the manifest, not hand-edited to chase upstream.
- Volatile operational advice changes faster than whole-artifact releases.
- Trust/security — a runtime fetch must not let unverified content steer the agent.
- Don't pester; degrade gracefully — freshness must never block operation or nag.

## Considered Options

1. **Treat freshness as one mechanism — rely on the install channel** (e.g. skills.sh `version` + `npx skills update`). Rejected: channel-specific; ignores the other channels; and does nothing for tool-behaviour drift or for advice that moves faster than releases.
2. **Bundle everything; refresh only via full re-releases.** Rejected: can't keep fast-moving advice current between releases, and gives an installed copy no way to notice it's stale across channels.
3. **Live-fetch everything at runtime (no bundling).** Rejected: breaks the offline/fresh-host robustness the bundle exists for (contradicts ADR-0008) and maximises the trust surface.
4. **Separate the concerns into distinct mechanisms** — document tool behaviour as source-bound content; regenerate and version the artifact; let installed copies update on that version; and add a best-effort live check for the volatile parameters. Chosen.

## Decision

Skill freshness is handled as **four distinct mechanisms**, each with its own lifecycle:

**1. Tool & binary updates — documented, source-bound context.**
The `ant` tool and its binaries update on their own lifecycle (auto-upgrade channel; installer fetches the latest; ADR-0009). The skill does not manage this; it **documents** the behaviour so the agent operates with correct expectations, and every such fact is **source-bound** (ADR-0006). This is context the other mechanisms depend on, not a freshness mechanism the skill owns — when upstream update behaviour changes, that change enters the skill through mechanism 2.

**2. Producing skill versions — repo-side regeneration.**
Automation watches upstream against the source-bindings manifest, regenerates `SKILL.md` / `references/`, and re-releases a **version-pinned snapshot** (frontmatter `version`). The artifact is regenerated *from the manifest*, never hand-patched to chase upstream.

**3. Consuming skill updates — an installed copy staying current.**
An installed copy's currency is keyed on its `version`. It becomes current through the install channel's own flow (e.g. `npx skills update`) and/or a lightweight, **channel-independent** self-check that notices a newer published version and surfaces it. Updating the artifact is **never silent or automatic**; the copy operates from what it has until an update is applied.

**4. Volatile-parameter freshness — best-effort live advisory.**
For the figures and advice flagged as fast-moving (resource numbers, shunning/standing/best-practice), the skill MAY consult a single **authoritative, integrity-pinned** source at runtime, **best-effort**: reachable → prefer it and note the delta; unreachable or offline → fall back to the bundled, team-confirmed values and carry on. Checks run at **meaningful moments** (session start, and before consequential resource/scaling decisions), not on every action, and the agent **flags and defers** material changes to a human rather than silently acting on fetched advice.

Invariants:
- The skill **installs and operates fully offline from the bundle**; mechanisms 3 and 4 are **best-effort and never hard dependencies**.
- Facts stay **source-bound** (ADR-0006); mechanism 2 regenerates from the manifest rather than hand-patching to track upstream.
- Mechanism 4 reads **one authoritative, integrity-pinned source**; the agent never silently applies fetched values — it flags/defers material changes.
- Mechanism 1 (tool behaviour) is documented in-skill and kept current via mechanism 2; upstream changes flow through regeneration, not skill drift.
- Freshness never pesters: checks run at meaningful moments, and surface only what is genuinely the human's to decide.

Mechanism 4's authoritative source (ideally the *Recommended Node Resource Document*, see `planning/node-resource-spec-brief.md`), and whether mechanism 3's self-check ships, are **implementation choices deferred** to the build (NEXT-PHASE §3 & §5); this ADR fixes the model and its invariants.

## Consequences

### Positive

- Four separate mechanisms can be built, reasoned about, and secured independently.
- Freshness is **channel-independent** — it doesn't depend on any one install channel's update flow.
- Fast-moving advice (4) can update **without re-shipping the whole artifact**, while structural changes go through 2 and 3.
- Offline / fresh-host robustness is preserved by construction (best-effort, bundle-first).
- The trust boundary for any runtime fetch is explicit (single pinned source; flag-don't-apply).

### Negative / Trade-offs

- Mechanism 4 introduces a runtime dependency and an instruction/injection surface — mitigated by best-effort fallback, an integrity-pinned source, and flag-don't-auto-apply, but it is real surface to secure.
- Mechanism 2's regeneration automation is non-trivial engineering to build and maintain.
- Mechanism 4 depends on an authoritative source *existing* — it is blocked on the node-resource SOP (the *Recommended Node Resource Document*) and its upstream home.

### Neutral / Operational

- Ties directly to the freshness automation (NEXT-PHASE §3 = mechanism 2), the node-resource SOP (mechanism 4's source), and skills.sh `version` mechanics (one of mechanism 3's channels).
- Sequencing: mechanism 1 is already satisfied (documented, source-bound); 2 and 3 are staged; 4 waits on its authoritative source.

## Validation

- The skill installs and operates **fully from the bundle with no network**; disabling every freshness check changes nothing about core operation.
- Regeneration produces **version-pinned** snapshots; an installed copy's currency is judged on its `version`.
- Any mechanism-4 check **degrades gracefully** when its source is unreachable and **never auto-applies** fetched values without flagging them to a human.
- The skill's documented tool-update behaviour (mechanism 1) matches upstream and is refreshed by regeneration, not hand-edited.

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR.
