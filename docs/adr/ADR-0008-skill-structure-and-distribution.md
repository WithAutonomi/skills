# ADR-0008: Skill structure, quality bar, and skill-led distribution (x0x as precedent)

- **Status:** Proposed
- **Date:** 2026-06-17
- **Decision owners:** Jim Collinson
- **Reviewers:** David Irvine
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0002 (single holistic skill), ADR-0003 (operator scope & interface), ADR-0006 (source-binding), ADR-0007 (dedicated skills repository); the x0x skill (`saorsa-labs/x0x`)

## Context

ADR-0002 fixes the skill's *shape* (one modular skill, progressively disclosed) and ADR-0003 its *scope* (operate via existing surfaces). What is not yet committed is the skill's concrete *structure*, *quality bar*, and *distribution model*. x0x is a useful **precedent** (not a dependency): a pattern proven in the wild that we draw on, while the structure here is justified by Autonomi's own requirements. Its `SKILL.md` is a self-sufficient entry that installs the tools (the `x0x` CLI and `x0xd` daemon), orients the agent, and discloses depth through linked references. It is not a developer tutorial, yet from it an agent can find and do everything — an excellent jumping-off point. The principle we draw from it is **skill-led distribution**: all an agent needs is the skill, and the skill brings the tools and the knowledge with it.

## Decision Drivers

- All an agent needs is the skill — a single, self-sufficient entry point.
- Skill-led distribution (the x0x pattern): the skill installs/configures the existing tools, not a separate setup.
- Progressive disclosure as the quality bar: lean entry → modules on demand → outward to deeper topics.
- The housekeeping of a high-quality, installable skill: accurate metadata, an install manifest, a version self-check, a sound security posture.
- Adopt a proven pattern (x0x as precedent) rather than invent one.

## Considered Options

1. **A bare instructions document** (no manifest, metadata, or self-check). Rejected: not a self-sufficient, installable, high-quality skill; would fail the quality bar and the security scan.
2. **A skill plus separate manual setup of the tools.** Rejected: an agent should need nothing but the skill; separate setup is friction and a source of drift.
3. **An x0x-style skill**: self-sufficient entry, skill-led distribution of the existing CLI + daemon, progressive disclosure, and full metadata/housekeeping. Chosen.

## Decision

The skill is structured and quality-gated following the same broad pattern as x0x — a self-contained, progressively disclosed skill — but justified by Autonomi's own requirements; **x0x is a precedent, not a dependency.** Invariants:

- **Self-sufficiency / skill-led distribution:** installing the skill is all an agent needs. The skill bootstraps access to the **existing upstream tools** — it detects what is already present, installs the `ant` CLI (the node daemon is the same `ant` binary in daemon mode) only when missing, and upgrades or mutates an existing setup only for an explicit compatibility/security reason **and only within the agent's granted remit** (escalating otherwise), per ADR-0009. It adds no new tooling (per ADR-0003) and is the single jumping-off point from which the agent can go as deep as it needs.
- **Progressive-disclosure layering:** a lean entry (opener + task routing) → **bundled** modules/references loaded on demand for depth (data storage, the upstream repos, security, developer-level detail). Live docs and other skills are **further reading, not the depth mechanism** — the skill is bundled so it works on a fresh/offline host and stays version-locked (ADR-0006), per ADR-0002 and ADR-0003.
- **High-quality housekeeping:** accurate frontmatter/metadata (name, a triggering-tuned description, version, license, keywords); clear provenance/attribution (the team behind it, the upstream repos it draws on, links); an install manifest following x0x's `metadata.openclaw.install` pattern, referencing upstream release binaries with signature verification; and an in-skill version self-check (per ADR-0006).
- **Channel-agnostic distribution (from the dedicated skills repository, ADR-0007).** The skill conforms to the shared Agent Skills spec (agentskills.io) and installs through multiple channels, none privileged — e.g. `skills.sh` (`npx skills add`, which fans out to many agents), OpenClaw/ClawHub (via the `metadata.openclaw.install` manifest), and native/direct install (a directory or git URL). Channel-specific install UX is illustrative, not the mechanism — e.g. `skills.sh` lists a repo's skills by name + description for selection, so the `description` is both trigger-tuned (agent) and chooser-facing (human), with `--skill <name>` the deterministic selector.
- **Only the skill bundle ships:** what installs is `SKILL.md` + the bundled `references/`; repo-side material (`docs/`, `docs/adr/`, `planning/`, `source-bindings/`) never ships (ADR-0007).
- **Verified, secure delivery and clean removal:** checksums and signatures for both the skill and the binaries it installs, confirmed before use and reported back to the agent; the security checks agents and distribution channels expect (declared behaviour matches actual, reviewed install script); and a documented, clean **uninstall** path (stop processes, remove binaries and state) — agents trust a skill more when they can cleanly reverse it.
- **Quality bar:** structure, security posture (signed binaries, reviewed install script, passes the security scan), and clarity on par with x0x.

The detailed structure — exact sections, module files, manifest schema — is specified in DESIGN, not fixed here.

## Consequences

### Positive

- An agent needs only the skill; it is self-sufficient and a clean jumping-off point.
- Built on a proven, high-quality, installable pattern rather than an invented one.

### Negative / Trade-offs

- More housekeeping to build and keep current (metadata, manifest, self-check) — mitigated by the source-binding of ADR-0006.

### Neutral / Operational

- The concrete structure is DESIGN's job; this ADR sets the distribution model and the quality bar.

## Validation

A clean-context agent, given only the installed skill, can obtain the tools and operate from the skill alone (the iteration-1 live-network test). The skill passes the security scan, and its structure and metadata are on par with x0x.

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR.
