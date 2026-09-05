# ADR-0013: Skill freshness and channel-owned updates

- **Status:** Proposed
- **Date:** 2026-07-13
- **Decision owners:** Jim Collinson
- **Reviewers:** David Irvine, Hermes
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0006 (source-bound; mechanical-vs-judgement review split), ADR-0008 (channel-agnostic distribution), ADR-0009 (independent lifecycle); `planning/channel-update-research.md`; `planning/NEXT-PHASE.md` §3 & §5; `planning/node-resource-spec-brief.md`; `planning/REBUILD-BRIEF.md` (freshness / source-bindings section)

## Context

The shipped skill is a **bundled, versioned snapshot** — `SKILL.md` plus bundled `references/` — deliberately self-contained so its guidance can be loaded and used without contacting an update or freshness service (ADR-0008), with its facts bound to upstream code (ADR-0006). Autonomi operations still require whatever network access their task normally needs.

A snapshot drifts from reality along **independent axes**: the underlying `ant` tool updates on its own lifecycle; the skill's own instructions get revised; and a *narrow subset* of the operational figures it carries (resource sizing, shunning/standing thresholds) change faster than the whole skill is re-released. Distribution is channel-agnostic (ADR-0008), but every installed copy still arrived through a channel with its own update semantics. Runtime fetching solely to check the skill's own version duplicates that layer while adding latency, failure, and an instruction/injection surface.

This ADR sets out how the skill stays current across those axes without sacrificing bundle availability when freshness services are unavailable, source-binding, or trust — by treating them as separate mechanisms rather than one.

Research recorded in `planning/channel-update-research.md` found no ordinary first-party `SKILL.md` that checked its own version on load. Installed-skill freshness was owned by marketplaces, installers, or a product CLI; live fetching inside skills was reserved for task-specific documentation and data. This ADR adopts that model. Mechanism 3 has no runtime self-check; mechanism 4 retains the separately bounded, data-only runtime design for a narrow class of volatile operational values.

## Decision Drivers

- Multiple distribution channels, each with an update mechanism or an explicit manual-reinstall contract.
- No freshness-service dependency (ADR-0008) — load and use the bundled guidance without contacting an update or live-values endpoint.
- Source-bound discipline (ADR-0006) — facts bind to upstream code; regenerate from the manifest, and keep the mechanical-vs-judgement review split.
- A narrow set of operational values changes faster than whole-artifact releases.
- Trust/security — a runtime fetch must not let unverified content steer the agent; live material must be typed *data*, not free-form instructions.
- Don't pester; degrade gracefully — freshness failure never blocks access to bundled guidance or nags, but stale values must not authorise a first deployment or new consequential scaling.

## Considered Options

1. **Let each install channel own installed-skill updates, while handling other kinds of drift separately.** Chosen: this uses each channel's established delivery mechanism and keeps update code out of the instructions it replaces.
2. **Bundle everything; refresh only via full re-releases.** Rejected as a complete freshness model: releases are right for skill prose, but cannot keep fast-moving operational values current between releases.
3. **Fetch a published skill version whenever the skill is first used.** Rejected: duplicates install-channel update discovery, adds a network request to ordinary skill loading, and exposes remote input to the agent for no task-specific benefit.
4. **Live-fetch everything at runtime (no bundling).** Rejected: creates a hard freshness-service dependency, maximises the trust surface, and would fetch judgement-derived prose — unsafe to inject.
5. **Make install-manager identity and folder hashes a contract implemented by the skill.** Rejected: managers may use those mechanisms internally, but reproducing them in the skill would be channel-specific machinery without a clear user benefit.

## Decision

Skill freshness is handled as **four distinct mechanisms**, each with its own lifecycle.

**1. Tool & binary updates — documented, source-bound context (not a skill mechanism).**
The `ant` tool and its binaries update on their own lifecycle (auto-upgrade channel; installer fetches the latest; ADR-0009). The skill does not manage this; it **documents** the behaviour so the agent operates with correct expectations, and every such fact is **source-bound** (ADR-0006). This is context the other mechanisms depend on — when upstream update behaviour changes, that change enters the skill through mechanism 2, never by drift.

**2. Producing skill versions — reviewed, source-bound regeneration.**
Automation watches upstream against the source-bindings manifest and regenerates the artifact, respecting **ADR-0006's split**: **mechanical, source-bound content** (commands, flags, figures) may be regenerated automatically, while **judgement-derived content** (doctrine, prose, guidance) is **flagged for human review**, never silently rewritten. A regenerated candidate passes a **reviewed release/promotion gate** before it is published as a new version-pinned snapshot. Regeneration is from the manifest — not hand-patching to chase upstream.

**3. Consuming skill updates — the installation channel owns delivery.**
Every released skill carries synchronized version metadata across the surfaces used by its supported channels. The installed skill makes no network request solely to check its own version and does not inspect install-manager state or modify its own files.

The channel that installed a copy owns update discovery and delivery through its documented mechanism. A manually copied bundle is explicitly non-updating and is replaced by repeating the installation. A copy installed from an immutable `ref` remains pinned unless the person deliberately chooses a newer source. Channel-specific commands, metadata, and reload behaviour belong in source-bound implementation documentation, not this decision record.

**4. Volatile-value freshness — a deferred, bounded, data-only, best-effort live check.**
A narrow class of operational **values** (resource figures, shunning/standing thresholds) changes faster than the artifact is re-released. If this deferred mechanism is implemented, the skill MAY consult a single authoritative source at runtime. The fetch is **non-mutating observation**, but that does **not** itself grant network/egress authority: the bounded call runs only within affirmative network/egress remit. If that remit is missing or ambiguous, the agent skips the fetch and uses the bundled values. Even when authorised, the call is limited to the one authoritative source — never an open egress right. It runs under strict bounds:

- **Data-only, typed.** Only the structured, machine-readable **values block** is fetched (the parameters specified in `planning/node-resource-spec-brief.md`, once published as the Recommended Node Resource Document) — schema-typed numbers with units, never free-form prose. **Judgement-derived guidance/principles are never fetched**; they remain reviewed bundle content. (This mirrors the two-register split in the resource brief: *values* are source-bound data; *principles* are bundled doctrine.)
- **Trust protocol — not merely "pinned."** The check requires: a **signed, versioned envelope**; a **bundled trust root** (the publisher's public key shipped in the skill); a **canonical encoding and fixed schema**; **key rotation and revocation valid only when chained to the currently-trusted bundled root (or delivered by a reviewed bundle re-release)** — an unanchored rotation/revocation asserted over the runtime channel is rejected; **monotonic ordering and an expiry** (reject anything older than what's installed, or expired); **replay/downgrade rejection**; **authorised rollback only** — a rollback is a *forward*, higher-sequence signed instruction that lowers a value, never acceptance of an older/lower-sequence envelope (which stays rejected as a downgrade); and explicit handling of **malformed, unverifiable, or conflicting** responses (treat as *unavailable* → fall back to the bundle).
- **Best-effort and bundle-backed.** Reachable and verified → the value informs **observation and reporting**, and reaches behaviour only through the apply policy below. Unreachable, unverifiable, expired, or conflicting → **fall back to the bundled, team-confirmed values**. This is conservative continuity from the last reviewed baseline, not a guarantee that unresolved or stale values remain operationally current; **prolonged** unreachability is itself an escalation trigger.
- **Apply policy — default-material, fail-safe.** A verified live value does **not** silently change behaviour. **Every verified live delta is treated as material and gated unless it matches a fixed, bundled allowlist of cosmetic values** — materiality is default-on, not a denylist of named thresholds. Materiality is judged **against the reviewed, team-confirmed bundled baseline** (never against the last-applied live value, so a source cannot walk a safety value across the line in sub-threshold steps), and the **materiality criteria are themselves bundled and reviewed, never read from the fetched payload** (so a source cannot declare its own change immaterial). **Applying a material change** — anything that would authorise or expand consequential action (adding/removing nodes, moving data, changing node count or placement, crossing the disk/spread thresholds) — **requires human approval**; absent a human, the agent **defers the consequential action** and continues existing operation on bundled values. This gate holds **even inside a granted operational envelope**: a granted envelope authorises action computed from approved/bundled values, but a live delta that would expand consequential action beyond what those values authorised is still gated — verified-source is never self-authorising (reconciles ADR-0010's within-envelope autonomy). A verified **immaterial** value informs **monitoring and reporting only** and never becomes the basis of a consequential computation until approved. Once mechanism 4 exists and bundled values carry a declared maximum age, **stale bundled values** may sustain existing operation but do not authorise a first deployment or new consequential scaling; those actions wait for fresh verified values.

Checks run at **meaningful moments** (session start; before a consequential resource/scaling decision), not on every action, and surface only what is genuinely the human's to decide.

Invariants:
- **No freshness-service dependency.** The skill loads and provides bundled guidance without contacting an update or live-values endpoint; operational tasks may still require their normal network access. Mechanism 3 is external to skill execution and mechanism 4 is best-effort, never a hard dependency for access to the guidance.
- **Source-bound, reviewed regeneration.** Facts bind to upstream (ADR-0006); mechanical content may auto-regenerate, judgement-derived content is flagged for review, and a reviewed gate precedes any release.
- **Installed-skill updates are channel-owned** (mechanism 3); the skill performs no self-version fetch, managers use their native version/source records, manual copies state that they do not auto-update, and a pinned `ref` is never moved automatically.
- **Live material is typed data, never prose** (mechanism 4); judgement guidance stays bundled and reviewed.
- **Verified-source ≠ authorised-to-act.** A material live delta needs human approval — **even inside a granted envelope**; absent a human, defer the consequential action. Once mechanism 4 defines staleness, stale bundled values may sustain existing operation but never authorise a first deployment or new scaling.
- **Trust is explicit** (mechanism 4): signed/versioned envelope, bundled trust root, **root rotation/revocation only when chained to the bundled root**, schema, monotonic ordering/expiry, replay/downgrade rejection, forward-only authorised rollback, defined failure handling.
- **No pestering.** Checks run at meaningful moments and surface only genuinely-human decisions.

Mechanism 4 requires an authoritative *Recommended Node Resource Document* (specified by `planning/node-resource-spec-brief.md`, which currently lists the parameters it must quantify but is not yet a fetchable values block) and a detailed protocol/spec before implementation. This ADR fixes the model, trust and apply requirements, and invariants; the protocol/spec must fix mechanism 4's wire details before it is built.

## Consequences

### Positive

- Four mechanisms that can be built, reasoned about, and secured independently.
- Installed-skill update discovery and delivery use established channel machinery rather than a second mechanism embedded in the skill.
- A narrow set of values can update without re-shipping the artifact; structural change goes through the reviewed regenerate/release path.
- Bundled guidance remains available when an update or live-values service is unavailable.
- The runtime trust boundary is explicit and data-only, and "verified" is cleanly separated from "authorised to act."

### Negative / Trade-offs

- Mechanism 4 is a real security surface — it needs a genuine signing/verification protocol and careful failure handling; it is deliberately constrained (data-only, materiality-gated, bundle-backed) but non-trivial to build correctly.
- Mechanism 2 is engineering plus an ongoing review gate.
- Mechanism 4 is blocked on the authoritative values document existing and being published under the trust protocol.
- Manually copied skills have no automatic update notification, and some channels require the user to enable or request updates explicitly.

### Neutral / Operational

- Ties to NEXT-PHASE §3 (mechanism 2), supported installation channels (mechanism 3), and the node-resource SOP (mechanism 4's source). Implementation progress belongs in planning, not this decision record.

## Validation

- The skill loads and provides its bundled guidance without contacting an update or live-values endpoint; no network request is made solely to check the installed skill's version. Tests do not misrepresent network-dependent Autonomi operations as offline.
- **Mechanism 3:** each supported managed channel can update a released test copy through its documented operation; a manual copy is documented as non-updating; a pinned tag is not moved automatically; the skill does not inspect manager state or modify itself.
- **Mechanism 4:** without affirmative network/egress remit, no fetch occurs and the bundled values are used; when authorised, only typed values are fetched (never prose); a malformed / unsigned / expired / downgraded / conflicting response, and any unanchored trust-root rotation, is rejected and falls back to the bundle; **every delta is gated as material unless on the bundled cosmetic allowlist**, materiality is judged against the bundled baseline using bundled criteria, and a material delta is never applied without human approval **even inside a granted envelope** — absent a human the consequential action is deferred while existing operation continues on bundled values.
- **Mechanism 2:** mechanical regeneration is automatic; judgement-derived changes are flagged for review; nothing releases without passing the review gate.

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR.
