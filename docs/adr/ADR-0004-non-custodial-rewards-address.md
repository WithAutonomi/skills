# ADR-0004: Non-custodial rewards address by default

- **Status:** Proposed
- **Date:** 2026-06-17
- **Decision owners:** Jim Collinson
- **Reviewers:** David Irvine
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0005 (spend documented, not solved); `WithAutonomi/ant-node` (`src/payment/wallet.rs`, `src/bin/ant-node/cli.rs`)

## Context

A running node earns real ANT, and the operator is often an autonomous agent, sometimes with no human in the loop. The current `ant-node` code shows the safe shape is the only shape the software offers: a node is configured with a **public wallet address** for rewards (the `--rewards-address 0x…` flag) and holds **no** signer or private key — it merely verifies that inbound on-chain payments name that address. The node docs say it plainly: provide only a public address, never a private key. So the skill can speak precisely to what *it* and the *node* require and handle; what it cannot and must not claim is where a human's key is physically kept. What the decision must still answer is *where the public wallet address comes from* — especially when no human is in the loop.

## Decision Drivers

- Safety of funds under autonomous operation.
- Least privilege: operating a node should grant no spending authority.
- Claim only what we control — what the node and skill require and handle — not where a human's key lives.
- Do not present self-custody as a default, or as a reflex for when other options are unavailable.
- Align with the network's actual design (the node cannot spend).

## Considered Options

1. **The skill creates or handles a private key to run the node.** Rejected: the node software neither needs nor accepts a private key, so handling one for node operation adds risk for no benefit.
2. **Point the node at a public wallet address; the skill never needs or handles the private key to operate.** Chosen.
3. **Require a human to supply an address for every action.** Rejected: needlessly blocks autonomous operation, which is safe when the skill handles no spending key.

## Decision

The default operator path configures the node with a **public wallet address** — the address that rewards are paid to. The **node requires only that public address** and holds no key, and **the skill never needs or handles the private key to run a node.** Operating a node therefore carries no spending authority and no custody burden. Acquiring or handling a spend-capable key is a separate, explicit, gated step (the money line) — never a node-setup convenience.

**Where the public wallet address comes from.** Three options — not a ranked ladder, and self-generation is never a default nor a reflex for when the others aren't available:

- **Supplied** — a human or principal provides an existing public wallet address (pasted in, or a designated wallet/provider address). Non-custodial.
- **Provisioned** — for an autonomously-running agent, the address is provided at setup by whoever set the agent running. Non-custodial.
- **Agent-created** — the agent generates its own reward wallet. This is custody, and it is **gated**: undertake it only where the conditions exist for the agent to create, secure (encrypted backup), and manage the key so that no funds are lost. The agent must **not** create a wallet merely because no supplied or provisioned address is available.

If none is safely available — no supplied or provisioned address, and the agent cannot properly custody a self-created wallet — the agent does **not** earn into an unsafe or unspendable address: it stops and escalates (or asks the human) rather than proceeding. In every case the node is given only the public address; what differs is who holds the key, and whether it can be held safely at all. The address must be a valid EVM address usable on **Arbitrum One** (ANT is an ERC-20 there), so the holder can view and use the earned ANT.

Invariants:
- Node operation is non-custodial by default: the skill never needs or handles a private key to run a node, and never instructs putting one into node configuration.
- The node is given only a public wallet address; receiving rewards never requires a private key.
- "Operate autonomously, spend under authority": running and optimising nodes can be fully autonomous; spending earned ANT requires the key-holder.
- Agent self-generation of the reward wallet is never the default, and never a reflex when a supplied/provisioned address is unavailable; it is permitted only where the agent can create, secure, and manage the key so funds are not lost — a hard gate, not a recommendation.
- If no address can be sourced safely, the agent stops or escalates rather than earning into an unsafe or unspendable address.
- For a human's pre-existing key, the skill offers best-practice securing guidance only and makes no claim about where it is stored.

## Consequences

### Positive

- Autonomous node operation is safe; it matches the upstream design (the node has no signer), and the skill's claims stay within what it can actually control.
- It prevents two failure modes: rewards earned into an inaccessible address, and an agent nudged into custody it cannot safely handle.

### Negative / Trade-offs

- Spending earned ANT requires bringing in the key-holder — by design (the safety gate, not a defect).

### Neutral / Operational

- Custody and key-securing guidance live in the money/wallet module for the cases where a spend-capable key is genuinely required.

## Validation

A clean-context agent runs a node configured with only a public wallet address and handles no private key; the live-network test uses a public wallet address for rewards. Review confirms: the skill never needs, handles, or instructs placing a private key for node operation; a self-generated reward wallet is configured only where key creation, securing, and management are in place; and when no address can be sourced safely the agent halts or escalates rather than configuring an unsafe or unspendable address.

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR.
