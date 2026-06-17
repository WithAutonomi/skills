# ADR-0004: Non-custodial rewards address by default

- **Status:** Proposed
- **Date:** 2026-06-17
- **Decision owners:** Jim Collinson
- **Reviewers:** TBD
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0005 (spend documented, not solved); `WithAutonomi/ant-node` (`src/payment/wallet.rs`, `src/bin/ant-node/cli.rs`)

## Context

A running node earns real ANT, and the operator is often an autonomous agent acting without a human in the loop. A node host is internet-facing and long-running — the worst place to keep a key that controls funds. The current `ant-node` code confirms the safe shape is already the only shape: a node is configured with a **public rewards address** (`--rewards-address 0x…`) and holds **no** signer or private key; it merely verifies that inbound on-chain payments name its address. The node docs say explicitly: use only a public address, never a private key. What the decision must still answer is *where that public address comes from* — especially when no human is in the loop.

## Decision Drivers

- Safety of funds under autonomous operation.
- Least privilege: operating a node should grant no spending authority.
- The node host is network-exposed and long-lived.
- Aligns the architecture with the network's actual design (the node cannot spend).

## Considered Options

1. **Agent generates/holds a node wallet (custody on the host).** Rejected as a default: places a spend-capable key on an exposed, long-running host and is not even required by the node software.
2. **Configure the node with a public address whose private key the agent does not hold (non-custodial).** Chosen.
3. **Require a human to supply an address for every action.** Rejected: needlessly blocks autonomous operation, which is safe when non-custodial.

## Decision

The default operator path configures the node with a **public rewards address whose private key the agent does not hold**; the node never holds spend-capable key material. Operating a node therefore carries no spending authority and no custody burden. Holding a spend-capable key is a separate, explicit, gated step (the money line) — never a node-setup convenience.

**Where the address comes from**, in preference order: (1) a human or principal **supplies** an existing EVM address — pasted in, or a designated wallet/provider address; (2) for an autonomously-running agent, the address is **provisioned at setup** by whoever set it running — there is always a principal whose resources are in use; (3) as a **fallback, the agent generates a wallet** and records only its public address for the node. Because the rewards private key is **never used during node operation** (receiving needs only the public address), any agent-generated key is immediately secured away from the node host — handed to the principal, or stored encrypted/offline — and resurfaces only, under authority, if the ANT is later spent. In every case the node holds only the public address; what differs is who holds the key. The address must be a valid EVM address usable on **Arbitrum One** (ANT is an ERC-20 there), so the holder can view and use the earned ANT.

Invariants:
- Node operation is non-custodial by default; the skill never instructs putting a private key on a node.
- "Operate autonomously, spend under authority": running/optimising nodes can be fully autonomous; spending earned ANT requires the key-holder.
- If a spend-capable key is ever genuinely needed, that invokes the wallet/custody and human-authority guidance, not a node-setup shortcut.
- Prefer sourcing the address from the principal (supplied or provisioned); agent self-generation is a fallback, not the default.
- Receiving rewards never requires the private key: the node is given only the public address, and any private key is kept off the node host.

## Consequences

### Positive

- Autonomous node operation is safe; matches the upstream design (the node has no signer); architecture and safety model reinforce each other.

### Negative / Trade-offs

- Spending earned ANT requires bringing in the key-holder — by design (this is the safety gate, not a defect).

### Neutral / Operational

- Custody guidance lives in the money/wallet module for the cases where a spend-capable key is genuinely required.

## Validation

A clean-context agent runs a node configured with a public rewards address and holds no key material; the live-network test uses a receive-only address. Review confirms the skill never instructs placing a private key on a node.

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR.
