# ADR-0009: Independent lifecycle — no lockstep upgrades between skill, CLI, and node

- **Status:** Proposed
- **Date:** 2026-06-17
- **Decision owners:** Jim Collinson
- **Reviewers:** David Irvine
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0006 (source-binding), ADR-0007 (standalone repo), ADR-0008 (skill-led distribution / install)

## Context

ADR-0007 makes the skill a standalone repo that synthesises several upstream repos. We should avoid the risk of **hidden release coupling** between `ant-node`, the `ant` client, and other binaries — for example, a skill-only change forcing an upgrade of the `ant` CLI, the node daemon (`ant node daemon`), or `ant-node`, or the skill's source-evidence commits being mistaken for runtime version pins. This ADR therefore sets an explicit no-lockstep invariant **before** `SKILL.md` and the install manifest are authored, so source-bound documentation never becomes a forced-upgrade path. The load-bearing distinction: **source bindings are documentation provenance, not runtime pins.**

## Decision Drivers

- A skill-only change must never force a release or upgrade of `ant` or `ant-node`.
- Source-evidence (provenance for a claim) ≠ runtime version requirement.
- Installing/updating the skill must not mutate a working `ant` / `ant-node` setup without an explicit compatibility/security reason, and any such change stays within the agent's granted remit (escalating otherwise).
- Don't rehost or bundle upstream binaries; call official installers/releases.

## Considered Options

1. **Amend ADR-0007 with a coupling clause.** Viable, but this coupling boundary is worth being able to review and accept on its own.
2. **A dedicated ADR for the lifecycle/coupling boundary.** Chosen — a distinct invariant that can be reviewed and accepted on its own.
3. **Leave it implicit.** Rejected: hidden coupling is precisely the risk.

## Decision

**No lockstep lifecycle.** The operator skill, the `ant` CLI / node-management daemon, and `ant-node` are independently versioned artefacts. Skill-only changes must not require releases or upgrades of `ant` or `ant-node`. The skill may declare minimum-compatible, tested, and known-incompatible versions, but it must **not** pin source-evidence commits as runtime requirements. Installing or updating the skill must not mutate an existing working `ant` / `ant-node` setup unless a required compatibility or security boundary is crossed — and then only within the autonomy and remit the operator has granted the agent, escalating rather than mutating when the change falls outside that remit.

Guardrails (invariants):
- **Three independent version streams:** skill version, `ant` / `ant-core` version, `ant-node` version.
- **Provenance ≠ compatibility in the source-binding manifest** (see ADR-0006): `source_evidence` (repo/file/symbol/commit proving a claim) is documentation only; `tested_with`, `requires_min`, and `known_incompatible` express tool compatibility. A source-evidence commit is never a runtime pin.
- **Non-mutating install by default:** detect an existing `ant --version`; do not upgrade `ant` because the skill changed; do not alter the node registry, node binary path, or `ant-node` upgrade channel.
- **Official upstream only:** call official installers/releases when a tool is missing or explicitly needed; never bundle or rehost `ant-node`.
- **Docs sites link to the skill; they do not vendor or own it.**

## Consequences

### Positive

- The skill can iterate freely without dragging tool releases; no hidden coupling.
- An operator's working setup is not disturbed by a skill update.
- Source bindings stay honest provenance rather than accidental version locks.

### Negative / Trade-offs

- The skill must track and express compatibility ranges — more manifest discipline.
- Some skill changes will need a "known-incompatible" note rather than a forced upstream fix.

### Neutral / Operational

- Reinforces ADR-0007 (separate repo); shapes ADR-0008's install model (non-mutating) and ADR-0006's manifest (provenance vs compatibility fields).

## Validation

A skill-only change ships with no `ant` / `ant-node` release. Installing or updating the skill on a machine with a working `ant` / `ant-node` leaves their versions, registry, binary paths, and upgrade channel untouched unless a needed change falls within the agent's granted remit (or the operator approves it). The source-binding manifest carries distinct `source_evidence` vs `tested_with` / `requires_min` / `known_incompatible` fields, and review confirms no source-evidence commit is used as a runtime pin.

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR.
