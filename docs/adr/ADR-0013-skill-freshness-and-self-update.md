# ADR-0013: Skill freshness and channel-owned updates

- **Status:** Proposed
- **Date:** 2026-07-13
- **Decision owners:** Jim Collinson
- **Reviewers:** David Irvine, Hermes
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0006 (source-bound; mechanical-vs-judgement review split), ADR-0008 (channel-agnostic distribution), ADR-0009 (independent lifecycle); `planning/NEXT-PHASE.md` §3 & §5; `planning/node-resource-spec-brief.md`; `planning/REBUILD-BRIEF.md` (freshness section)

## Context

The shipped skill is a **bundled, versioned snapshot** — `SKILL.md`, `VERSION` and bundled `references/` — deliberately self-contained so it installs and runs offline and on a fresh host (ADR-0008), with its facts bound to upstream code (ADR-0006).

A snapshot drifts from reality along **independent axes**: the underlying `ant` tool updates on its own lifecycle; the skill's own instructions get revised; and a *narrow subset* of the operational figures it carries (resource sizing, shunning/standing thresholds) change faster than the whole skill is re-released. Distribution is channel-agnostic (ADR-0008), but every installed copy still arrived through a channel with its own update semantics. Runtime fetching solely to check the skill's own version duplicates that layer while adding latency, failure and an instruction/injection surface.

This ADR sets out how the skill stays current across those axes without sacrificing offline robustness, source-binding, or trust — by treating them as separate mechanisms rather than one.

**Decision history.** An early 0.1.4 candidate made a best-effort runtime fetch of a published `VERSION` scalar. A 5 September 2026 review of current first-party collections from Stripe, Anthropic, Vercel, Cloudflare, Sentry, Supabase, Hugging Face and Shopify found no ordinary `SKILL.md` that checked its own version on load. Installed-skill freshness was owned by marketplaces, installers or a product CLI; live fetching inside skills was reserved for task-specific documentation and data. This ADR adopts that model. Mechanism 3 has no runtime self-check; mechanism 4 retains the separately bounded, data-only runtime design for a narrow class of volatile operational values.

## Decision Drivers

- Multiple distribution channels, each with an update mechanism or an explicit manual-reinstall contract.
- Offline / fresh-host robustness (ADR-0008) — install and operate from the bundle with no hard runtime dependency.
- Source-bound discipline (ADR-0006) — facts bind to upstream code; regenerate from the manifest, and keep the mechanical-vs-judgement review split.
- A narrow set of operational values changes faster than whole-artifact releases.
- Trust/security — installed-skill updates come from the chosen distribution channel; live operational material must be verified, typed *data*, not free-form instructions.
- Don't pester; degrade gracefully — freshness never blocks operation or nags.

## Considered Options

1. **Let each install channel own installed-skill updates, while handling other kinds of drift separately.** Chosen: this uses established marketplace/source-hash machinery and keeps update code out of the instructions it replaces.
2. **Bundle everything; refresh only via full re-releases.** Rejected as a complete freshness model: releases are right for skill prose, but cannot keep fast-moving operational values current between releases.
3. **Fetch a published skill version whenever the skill is first used.** Rejected: duplicates install-channel update discovery, adds a network request to ordinary skill loading, and exposes remote input to the agent for no task-specific benefit.
4. **Live-fetch everything at runtime (no bundling).** Rejected: breaks offline/fresh-host robustness (ADR-0008), maximises the trust surface, and would fetch judgement-derived prose — unsafe to inject.
5. **Make install-manager identity and folder hashes a contract implemented by the skill.** Rejected: managers may use those mechanisms internally, but reproducing them in the skill would be channel-specific machinery without a clear user benefit.

## Decision

Skill freshness is handled as **four distinct mechanisms**, each with its own lifecycle.

**1. Tool & binary updates — documented, source-bound context (not a skill mechanism).**
The `ant` tool and its binaries update on their own lifecycle (auto-upgrade channel; installer fetches the latest; ADR-0009). The skill does not manage this; it **documents** the behaviour so the agent operates with correct expectations, and every such fact is **source-bound** (ADR-0006). This is context the other mechanisms depend on — when upstream update behaviour changes, that change enters the skill through mechanism 2, never by drift.

**2. Producing skill versions — reviewed, source-bound regeneration.**
Automation watches upstream against the source-bindings manifest and regenerates the artifact, respecting **ADR-0006's split**: **mechanical, source-bound content** (commands, flags, figures) may be regenerated automatically, while **judgement-derived content** (doctrine, prose, guidance) is **flagged for human review**, never silently rewritten. A regenerated candidate passes a **reviewed release/promotion gate** before it is published as a new version-pinned snapshot. Regeneration is from the manifest — not hand-patching to chase upstream.

**3. Consuming skill updates — the installation channel owns delivery.**
Every released skill carries synchronized semantic versions in its frontmatter, bundled `VERSION` file, plugin manifest and marketplace entry. The installed skill makes no network request solely to check its own version and does not inspect install-manager state or modify its own files.

The channel that installed a copy owns update discovery and delivery: skills.sh installations use the source and folder-hash records behind `npx skills update autonomi`; Claude Code marketplace installations use the plugin's declared version and either marketplace auto-update (when enabled) or `/plugin update autonomi@withautonomi`; a manually copied bundle is explicitly non-updating and is replaced by repeating the installation. A copy installed from an immutable `ref` remains pinned unless the person deliberately chooses a newer source. An update written to disk does not retroactively replace instructions already loaded into a conversation; use the client's supported reload operation or begin a new session before relying on the new version.

**4. Volatile-value freshness — a bounded, data-only, best-effort live check.**
A narrow class of operational **values** (resource figures, shunning/standing thresholds) changes faster than the artifact is re-released. For these, the skill MAY consult a single authoritative source at runtime, under strict bounds:

- **Data-only, typed.** Only the structured, machine-readable **values block** is fetched (the parameters in `planning/node-resource-spec-brief.md`) — schema-typed numbers with units, never free-form prose. **Judgement-derived guidance/principles are never fetched**; they remain reviewed bundle content. (This mirrors the two-register split in the resource brief: *values* are source-bound data; *principles* are bundled doctrine.)
- **Trust protocol — not merely "pinned."** The check requires: a **signed, versioned envelope**; a **bundled trust root** (the publisher's public key shipped in the skill); a **canonical encoding and fixed schema**; **key rotation and revocation** support; **monotonic ordering and an expiry** (reject anything older than what's installed, or expired); **replay/downgrade rejection**; **authorised rollback only**; and explicit handling of **malformed, unverifiable, or conflicting** responses (treat as *unavailable* → fall back to the bundle).
- **Best-effort, offline-safe.** Reachable and verified → the value updates the agent's **awareness** and may inform observation/reporting. Unreachable, unverifiable, expired, or conflicting → **fall back to the bundled, team-confirmed values and carry on**.
- **Apply policy — materiality-gated.** A verified live value does **not** silently change behaviour. **Applying a material change** — one that would authorise consequential action (adding/removing nodes, moving data, crossing the disk/spread thresholds) — **requires human approval**. **Materiality** = any delta that crosses a safety or consequence threshold in the values (e.g. the per-node disk minimum, the address-spread caps, or anything that changes node count or placement). If a material delta is verified but **no human is available**, the agent **defers the consequential action** and continues existing operation on bundled values. **Stale bundled values may sustain existing operation but must never authorise new consequential scaling.**

Checks run at **meaningful moments** (session start; before a consequential resource/scaling decision), not on every action, and surface only what is genuinely the human's to decide.

Invariants:
- **Offline-first.** The skill installs and operates fully from the bundle with no network; mechanism 3 is external to skill execution and mechanism 4 is best-effort, never a hard dependency.
- **Source-bound, reviewed regeneration.** Facts bind to upstream (ADR-0006); mechanical content may auto-regenerate, judgement-derived content is flagged for review, and a reviewed gate precedes any release.
- **Installed-skill updates are channel-owned** (mechanism 3); the skill performs no self-version fetch, managers use their native version/source records, manual copies state that they do not auto-update, and a pinned `ref` is never moved automatically.
- **Live material is typed data, never prose** (mechanism 4); judgement guidance stays bundled and reviewed.
- **Verified-source ≠ authorised-to-act.** A material live delta needs human approval; absent a human, defer the consequential action; stale bundled values sustain existing operation but never authorise new scaling.
- **Trust is explicit** (mechanism 4): signed/versioned envelope, bundled trust root, schema, rotation/revocation, ordering/expiry, replay/downgrade rejection, defined failure handling.
- **No pestering.** Checks run at meaningful moments and surface only genuinely-human decisions.

Mechanism 4's authoritative source (the *Recommended Node Resource Document*, `planning/node-resource-spec-brief.md`) remains an implementation choice for its later specification. This ADR fixes the model, the trust and apply requirements, and the invariants; **mechanism 4's wire protocol may warrant its own detailed protocol ADR when it is built.**

## Consequences

### Positive

- Four mechanisms that can be built, reasoned about, and secured independently.
- Installed-skill update discovery and delivery use established channel machinery rather than a second mechanism embedded in the skill.
- A narrow set of values can update without re-shipping the artifact; structural change goes through the reviewed regenerate/release path.
- Offline / fresh-host robustness is preserved by construction.
- The runtime trust boundary is explicit and data-only, and "verified" is cleanly separated from "authorised to act."

### Negative / Trade-offs

- Mechanism 4 is a real security surface — it needs a genuine signing/verification protocol and careful failure handling; it is deliberately constrained (data-only, materiality-gated, offline-safe) but non-trivial to build correctly.
- Mechanism 2 is engineering plus an ongoing review gate.
- Mechanism 4 is blocked on the authoritative values document existing and being published under the trust protocol.
- Manually copied skills have no automatic update notification, and custom marketplaces require the user to enable auto-update or update explicitly.

### Neutral / Operational

- Returns installed-skill freshness to the rebuild brief's "no runtime live-fetch" model; mechanism 4 remains a separately bounded exception for typed operational data.
- Ties to NEXT-PHASE §3 (mechanism 2), supported installation channels (mechanism 3), and the node-resource SOP (mechanism 4's source). Implementation progress belongs in planning, not this decision record.

## Validation

- The skill installs and operates **fully from the bundle with no network**; no network request is made solely to check the installed skill's version.
- **Mechanism 3:** skills.sh and Claude Code can update a released test copy through their documented channel operation; a manual copy is documented as non-updating; a pinned tag is not moved automatically; the skill does not inspect manager state or modify itself.
- **Mechanism 4:** only typed values are fetched (never prose); a malformed / unsigned / expired / downgraded / conflicting response is rejected and falls back to the bundle; a material delta is never applied without human approval, and absent a human the consequential action is deferred while existing operation continues on bundled values.
- **Mechanism 2:** mechanical regeneration is automatic; judgement-derived changes are flagged for review; nothing releases without passing the review gate.

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR.
