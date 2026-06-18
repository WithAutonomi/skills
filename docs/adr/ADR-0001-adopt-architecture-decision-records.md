# ADR-0001: Adopt Architecture Decision Records

- **Status:** Proposed
- **Date:** 2026-06-17
- **Decision owners:** Jim Collinson
- **Reviewers:** David Irvine
- **Supersedes:** none
- **Superseded by:** none
- **Related:** Autonomi/Saorsa portfolio ADR standard (`WithAutonomi/autonomi-developer-docs`, PR #56); paired vault project `Projects/Autonomi Skill`

## Context

This repository participates in the wider Autonomi/Saorsa engineering portfolio, where architectural decisions affect protocols, storage behaviour, cryptography, APIs, operations, and long-term maintenance. This skill is additionally **largely AI-derived from upstream repos and intended to be AI-maintained**, which raises the risk that design intent, trade-offs, and constraints are lost or silently drift. The portfolio already defines a standard ADR mechanism; this repo should adopt it rather than invent one.

## Decision Drivers

- Preserve the reasoning behind architectural choices.
- Make trade-offs visible during review.
- Give humans and AI tools a reliable source of architectural context.
- Prevent silent drift from agreed decisions.
- Stay consistent with Autonomi and Saorsa repositories.

## Considered Options

1. Keep architecture reasoning only in PR descriptions and issues.
2. Maintain informal design notes without lifecycle governance.
3. Adopt the portfolio's version-controlled ADRs with CI governance.

## Decision

We will maintain Architecture Decision Records in `docs/adr/` using the team-standard mechanics mirrored from the portfolio (the `TEMPLATE.md`, `.adr-kit.yaml`, `scripts/adr-governance.py`, and the `adr-governance.yml` CI gate). New decisions start as `Proposed`; acceptance is a human gate (Jim for this repo). `Accepted` ADRs are immutable: a changed decision is recorded as a new superseding ADR rather than by editing the accepted record.

## Consequences

### Positive

- Architectural intent becomes searchable and reviewable.
- AI agents have explicit constraints to inspect before changing the skill.
- Reviews check decision quality, not just mechanics.
- Supersession creates an audit trail instead of rewriting history.

### Negative / Trade-offs

- Design work becomes more explicit and may slow rushed changes.
- ADRs must be kept aligned with meaningful architectural changes.

### Neutral / Operational

- CI enforces ADR format and immutable `Accepted` status.
- This repo mirrors the portfolio standard; if the standard evolves upstream, this repo re-syncs rather than diverging.

## Validation

The ADR governance check (`python3 scripts/adr-governance.py`) must pass. Reviewers verify that architectural changes carry appropriate ADR coverage and that accepted ADRs are not modified in place.

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR.
