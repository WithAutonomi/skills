# ADR-0013: Skill freshness and self-update

- **Status:** Proposed
- **Date:** 2026-07-13
- **Decision owners:** Jim Collinson
- **Reviewers:** David Irvine, Hermes
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0006 (source-bound; mechanical-vs-judgement review split), ADR-0008 (distribution — channel-agnostic; requires a channel-independent self-check), ADR-0009 (independent lifecycle); `planning/NEXT-PHASE.md` §3 & §5; `planning/node-resource-spec-brief.md`; `planning/REBUILD-BRIEF.md` (freshness section — revised here, see Context)

## Context

The shipped skill is a **bundled, version-pinned snapshot** — `SKILL.md` plus bundled `references/` — deliberately self-contained so it installs and runs offline and on a fresh host (ADR-0008), with its facts bound to upstream code (ADR-0006).

A snapshot drifts from reality along **independent axes**: the underlying `ant` tool updates on its own lifecycle; the skill's own instructions get revised; and a *narrow subset* of the operational figures it carries (resource sizing, shunning/standing thresholds) change faster than the whole skill is re-released. Distribution is channel-agnostic (ADR-0008), so no single channel's update flow can be *the* freshness mechanism; and any runtime fetch is an instruction/injection surface that must be bounded.

This ADR sets out how the skill stays current across those axes without sacrificing offline robustness, source-binding, or trust — by treating them as separate mechanisms rather than one.

**Reversal recorded.** An earlier proposal (`REBUILD-BRIEF.md`, freshness section) stated the skill would perform **no runtime live-fetch** — freshness by bundled snapshot only. Mechanisms 3 and 4 below **revise that**: mechanism 3 fetches one version scalar as a best-effort advisory, while mechanism 4 introduces a *bounded, best-effort, data-only* runtime check for a narrow class of volatile values. Where the two conflict, this ADR governs; the brief's "no live-fetch" line is superseded by these constrained checks.

## Decision Drivers

- Multiple distribution channels — no single channel's update flow can be the freshness mechanism.
- Offline / fresh-host robustness (ADR-0008) — install and operate from the bundle with no hard runtime dependency.
- Source-bound discipline (ADR-0006) — facts bind to upstream code; regenerate from the manifest, and keep the mechanical-vs-judgement review split.
- A narrow set of operational values changes faster than whole-artifact releases.
- Trust/security — a runtime fetch must not let unverified content steer the agent; live material must be typed *data*, not free-form instructions.
- Don't pester; degrade gracefully — freshness never blocks operation or nags.

## Considered Options

1. **Treat freshness as one mechanism — rely on the install channel's update.** Rejected: channel-specific; ignores other channels; does nothing for tool-behaviour drift or for values that move faster than releases.
2. **Bundle everything; refresh only via full re-releases.** Rejected: can't keep fast-moving values current between releases, and gives an installed copy no cross-channel way to notice it's stale.
3. **Live-fetch everything at runtime (no bundling).** Rejected: breaks offline/fresh-host robustness (ADR-0008), maximises the trust surface, and would fetch judgement-derived prose — unsafe to inject.
4. **Separate the concerns into distinct mechanisms** — document tool behaviour as source-bound content; regenerate and version the artifact under a reviewed gate; a channel-independent self-check for installed-copy currency; and a bounded, data-only, best-effort live check for a narrow set of volatile values. Chosen.
5. **Make install-manager identity and folder hashes the universal self-check contract.** Rejected: that state is channel-specific and unavailable to manual or plugin installs. Requiring the skill to recreate it would add machinery without improving the simple job of telling a person that a newer reviewed skill version exists.

## Decision

Skill freshness is handled as **four distinct mechanisms**, each with its own lifecycle.

**1. Tool & binary updates — documented, source-bound context (not a skill mechanism).**
The `ant` tool and its binaries update on their own lifecycle (auto-upgrade channel; installer fetches the latest; ADR-0009). The skill does not manage this; it **documents** the behaviour so the agent operates with correct expectations, and every such fact is **source-bound** (ADR-0006). This is context the other mechanisms depend on — when upstream update behaviour changes, that change enters the skill through mechanism 2, never by drift.

**2. Producing skill versions — reviewed, source-bound regeneration.**
Automation watches upstream against the source-bindings manifest and regenerates the artifact, respecting **ADR-0006's split**: **mechanical, source-bound content** (commands, flags, figures) may be regenerated automatically, while **judgement-derived content** (doctrine, prose, guidance) is **flagged for human review**, never silently rewritten. A regenerated candidate passes a **reviewed release/promotion gate** before it is published as a new version-pinned snapshot. Regeneration is from the manifest — not hand-patching to chase upstream.

**3. Consuming skill updates — an installed copy staying current.**
Every released skill carries the same semantic version in its frontmatter and bundled `VERSION` file. At first use in a session, the installed copy makes one best-effort, short-timeout fetch of the canonical published `VERSION` file. A valid higher version means **tell the person once and continue**; an equal, older, malformed, unavailable or slow response means carry on silently. The fetched value is a version scalar only, never executable content or instructions.

This is the channel-independent self-check required by ADR-0008. It does not identify how the copy was installed and does not apply an update. Updating remains **deliberate, surfaced and channel-owned**: the person uses skills.sh, their plugin manager or their manual install route. A copy installed from an immutable `ref` remains pinned unless the person deliberately chooses a newer source; the advisory never moves it automatically.

**4. Volatile-value freshness — a bounded, data-only, best-effort live check.**
A narrow class of operational **values** (resource figures, shunning/standing thresholds) changes faster than the artifact is re-released. For these, the skill MAY consult a single authoritative source at runtime, under strict bounds:

- **Data-only, typed.** Only the structured, machine-readable **values block** is fetched (the parameters in `planning/node-resource-spec-brief.md`) — schema-typed numbers with units, never free-form prose. **Judgement-derived guidance/principles are never fetched**; they remain reviewed bundle content. (This mirrors the two-register split in the resource brief: *values* are source-bound data; *principles* are bundled doctrine.)
- **Trust protocol — not merely "pinned."** The check requires: a **signed, versioned envelope**; a **bundled trust root** (the publisher's public key shipped in the skill); a **canonical encoding and fixed schema**; **key rotation and revocation** support; **monotonic ordering and an expiry** (reject anything older than what's installed, or expired); **replay/downgrade rejection**; **authorised rollback only**; and explicit handling of **malformed, unverifiable, or conflicting** responses (treat as *unavailable* → fall back to the bundle).
- **Best-effort, offline-safe.** Reachable and verified → the value updates the agent's **awareness** and may inform observation/reporting. Unreachable, unverifiable, expired, or conflicting → **fall back to the bundled, team-confirmed values and carry on**.
- **Apply policy — materiality-gated.** A verified live value does **not** silently change behaviour. **Applying a material change** — one that would authorise consequential action (adding/removing nodes, moving data, crossing the disk/spread thresholds) — **requires human approval**. **Materiality** = any delta that crosses a safety or consequence threshold in the values (e.g. the per-node disk minimum, the address-spread caps, or anything that changes node count or placement). If a material delta is verified but **no human is available**, the agent **defers the consequential action** and continues existing operation on bundled values. **Stale bundled values may sustain existing operation but must never authorise new consequential scaling.**

Checks run at **meaningful moments** (session start; before a consequential resource/scaling decision), not on every action, and surface only what is genuinely the human's to decide.

Invariants:
- **Offline-first.** The skill installs and operates fully from the bundle with no network; mechanisms 3 and 4 are best-effort and never hard dependencies.
- **Source-bound, reviewed regeneration.** Facts bind to upstream (ADR-0006); mechanical content may auto-regenerate, judgement-derived content is flagged for review, and a reviewed gate precedes any release.
- **Currency by the canonical published `VERSION` scalar** (mechanism 3); a channel-independent, best-effort self-check surfaces a higher version without blocking work; applying an update is always deliberate and channel-owned; a pinned `ref` is never moved automatically.
- **Live material is typed data, never prose** (mechanism 4); judgement guidance stays bundled and reviewed.
- **Verified-source ≠ authorised-to-act.** A material live delta needs human approval; absent a human, defer the consequential action; stale bundled values sustain existing operation but never authorise new scaling.
- **Trust is explicit** (mechanism 4): signed/versioned envelope, bundled trust root, schema, rotation/revocation, ordering/expiry, replay/downgrade rejection, defined failure handling.
- **No pestering.** Checks run at meaningful moments and surface only genuinely-human decisions.

Mechanism 4's authoritative source (the *Recommended Node Resource Document*, `planning/node-resource-spec-brief.md`) remains an implementation choice for its later specification. This ADR fixes the model, the trust and apply requirements, and the invariants; **mechanism 4's wire protocol may warrant its own detailed protocol ADR when it is built.**

## Consequences

### Positive

- Four mechanisms that can be built, reasoned about, and secured independently.
- Freshness discovery is channel-independent (mechanism 3's published `VERSION` check), while each install channel retains its own update operation.
- A narrow set of values can update without re-shipping the artifact; structural change goes through the reviewed regenerate/release path.
- Offline / fresh-host robustness is preserved by construction.
- The runtime trust boundary is explicit and data-only, and "verified" is cleanly separated from "authorised to act."

### Negative / Trade-offs

- Mechanism 4 is a real security surface — it needs a genuine signing/verification protocol and careful failure handling; it is deliberately constrained (data-only, materiality-gated, offline-safe) but non-trivial to build correctly.
- Mechanism 2 is engineering plus an ongoing review gate.
- Mechanism 4 is blocked on the authoritative values document existing and being published under the trust protocol.

### Neutral / Operational

- Reverses the brief's "no runtime live-fetch" (recorded in Context).
- Ties to NEXT-PHASE §3 (mechanism 2), the node-resource SOP (mechanism 4's source), and ADR-0008's required self-check (mechanism 3). Implementation progress belongs in planning, not this decision record.

## Validation

- The skill installs and operates **fully from the bundle with no network**; disabling every freshness check changes nothing about core operation.
- **Mechanism 3:** an equal published `VERSION` is silent; a valid higher version is surfaced once without blocking; malformed, unavailable and slow responses are silent; no response can modify the installed copy; each channel retains its own deliberate update operation; a pinned tag is not moved automatically.
- **Mechanism 4:** only typed values are fetched (never prose); a malformed / unsigned / expired / downgraded / conflicting response is rejected and falls back to the bundle; a material delta is never applied without human approval, and absent a human the consequential action is deferred while existing operation continues on bundled values.
- **Mechanism 2:** mechanical regeneration is automatic; judgement-derived changes are flagged for review; nothing releases without passing the review gate.

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR.
