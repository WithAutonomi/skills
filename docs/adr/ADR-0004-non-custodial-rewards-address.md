# ADR-0004: Non-custodial rewards address by default

- **Status:** Proposed
- **Date:** 2026-06-17
- **Decision owners:** Jim Collinson
- **Reviewers:** TBD
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0005 (spend documented, not solved); `WithAutonomi/ant-node` (`src/payment/wallet.rs`, `src/bin/ant-node/cli.rs`)

## Context

A running node earns real ANT, and the operator is often an autonomous agent, sometimes with no human in the loop. The current `ant-node` code shows the safe shape is the only shape the software offers: a node is configured with a **public wallet address** for rewards (the `--rewards-address 0x…` flag) and holds **no** signer or private key — it merely verifies that inbound on-chain payments name that address. The node docs say it plainly: provide only a public address, never a private key. So the skill can speak precisely to what *it* and the *node* require and handle; what it cannot and must not claim is where a human's key is physically kept. What the decision must still answer is *where the public wallet address comes from* — especially when no human is in the loop.

## Decision Drivers

- Safety of funds under autonomous operation.
- Least privilege: operating a node should grant no spending authority.
- Claim only what we control — what the node and skill require and handle — not where a human's key lives.
- Align with the network's actual design (the node cannot spend).

## Considered Options

1. **The skill creates or handles a private key to run the node.** Rejected: the node software neither needs nor accepts a private key, so handling one for node operation adds risk for no benefit.
2. **Point the node at a public wallet address; the skill never needs or handles the private key to operate.** Chosen.
3. **Require a human to supply an address for every action.** Rejected: needlessly blocks autonomous operation, which is safe when the skill handles no spending key.

## Decision

The default operator path configures the node with a **public wallet address** — the address that rewards are paid to. The **node requires only that public address** and holds no key, and **the skill never needs or handles the private key to run a node.** Operating a node therefore carries no spending authority and no custody burden. Acquiring or handling a spend-capable key is a separate, explicit, gated step (the money line) — never a node-setup convenience.

**Where the public wallet address comes from**, in preference order: (1) a human or principal **supplies** an existing one — pasted in, or a designated wallet/provider address; (2) for an autonomously-running agent, it is **provisioned at setup** by whoever set the agent running; (3) as a **fallback, the agent creates a wallet** and uses only its public address for the node. Because the private key is **never used to operate the node** (receiving needs only the public address), the skill does not handle it for node operation; where a key is created, the skill *recommends* securing it (encrypt, back up, never commit) as best practice — it makes no claim about where the key ultimately resides. In every case the node is given only the public address; what differs is who holds the key. The address must be a valid EVM address usable on **Arbitrum One** (ANT is an ERC-20 there), so the holder can view and use the earned ANT.

Invariants:
- Node operation is non-custodial by default: the skill never needs or handles a private key to run a node, and never instructs putting one into node configuration.
- The node is given only a public wallet address; receiving rewards never requires a private key.
- "Operate autonomously, spend under authority": running and optimising nodes can be fully autonomous; spending earned ANT requires the key-holder.
- Prefer sourcing the address from the principal (supplied or provisioned); agent self-generation is a fallback, not the default.
- The skill claims only what it and the node require and handle; it makes no guarantee about where a human's private key is stored, and offers key-securing steps only as best-practice recommendations.

## Consequences

### Positive

- Autonomous node operation is safe; it matches the upstream design (the node has no signer), and the skill's claims stay within what it can actually control.

### Negative / Trade-offs

- Spending earned ANT requires bringing in the key-holder — by design (the safety gate, not a defect).

### Neutral / Operational

- Custody and key-securing guidance live in the money/wallet module for the cases where a spend-capable key is genuinely required.

## Validation

A clean-context agent runs a node configured with only a public wallet address and handles no private key; the live-network test uses a public wallet address for rewards. Review confirms the skill never needs, handles, or instructs placing a private key for node operation, and makes no unverifiable claim about where a key is stored.

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR.
