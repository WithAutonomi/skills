# ADR-0005: Spend-to-store is documented, not solved

- **Status:** Proposed
- **Date:** 2026-06-17
- **Decision owners:** Jim Collinson
- **Reviewers:** TBD
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0004 (non-custodial rewards); ADR-0006 (source-binding); `WithAutonomi/evmlib`, `WithAutonomi/autonomi-token-docs`

## Context

David's brief flags that agents cannot easily acquire ETH for gas. ANT is an ERC-20, and spending it for storage requires native Arbitrum gas; the wallet tracks ANT and gas balances separately, and the token docs state plainly that a small amount of Arbitrum ETH is needed for fees. A source audit found **no** gasless mechanism upstream — no paymaster, account abstraction, meta-transaction, or permit anywhere in the org (with a code comment confirming permits are not yet implemented). So the "earn ANT → store your own data" loop does **not** close gaslessly today: an agent holding only earned ANT still needs gas to spend it.

## Decision Drivers

- Honesty and the quality bar: do not paper over a real gap.
- The skill documents reality, not aspiration.
- Changing the network/payment design is not this work's remit.

## Considered Options

1. **Design or ship a gasless mechanism (e.g. ERC-4337/paymaster) in the skill.** Rejected: that is a product/network change to Autonomi, not an operator-skill concern, and would document machinery that does not exist.
2. **Document the real, current path (ANT + native Arbitrum gas) and record the gas barrier as a known upstream gap to escalate.** Chosen.
3. **Omit spend entirely.** Rejected: agents need to understand how earned ANT is used and what it currently takes; omission leaves a dead-end.

## Decision

The skill **documents the real, current spend-to-store path** (ANT as an ERC-20 plus native Arbitrum gas, via existing tooling) and **neither invents nor depends on** gasless/account-abstraction mechanisms. The gas barrier is recorded as a known upstream limitation and surfaced to David — not solved in-skill.

Invariants:
- No invented or assumed mechanisms; all spend content reflects verified upstream reality.
- The gas constraint is stated plainly (you need ANT *and* a little Arbitrum ETH); the skill never implies a gasless path that does not exist.
- The gap is escalated upstream, not hidden.
- If upstream later ships gas abstraction, the skill updates through the source-binding/regeneration mechanism (ADR-0006), not by pre-emptive invention.

## Consequences

### Positive

- The skill is accurate and will not break at its own climax; preserves trust.

### Negative / Trade-offs

- The earn→store loop is not frictionless today; for an agent with only ANT, spending still needs gas funded — stated honestly rather than wished away.

### Neutral / Operational

- "What you can do with your ANT" is routed to live docs / the Developer skill at the appropriate depth; the constraint is revisited if upstream changes.

## Validation

Every spend-related claim traces to upstream code or docs. A clean-context agent is never told a gasless path exists when it does not. Review rejects any invented mechanism.

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR.
