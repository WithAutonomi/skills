# ADR-0004: Non-custodial node operation; agent wallet custody out of context

- **Status:** Proposed
- **Date:** 2026-06-17 (reframed 2026-06-18)
- **Decision owners:** Jim Collinson
- **Reviewers:** David Irvine
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0005 (gas — a separate decision); ADR-0009 (remit-gated operation); ADR-0006 (source-binding); DESIGN §7 and ROADMAP (capability ladder). Current-state source: `WithAutonomi/ant-node` (`--rewards-address`, `src/payment/wallet.rs`); `WithAutonomi/ant-client` (`ant-cli/src/main.rs` `require_secret_key`, `ant-cli/src/commands/data/wallet.rs`); `WithAutonomi/ant-sdk` (`antd/src/rest/wallet.rs` `AUTONOMI_WALLET_KEY`; `antd/src/rest/upload.rs` external-signer `prepare_upload`/`finalize_upload`; `docs/external-signer-flow.md`).

## Context

A running node earns real ANT, and the operator is often an autonomous agent — sometimes with no human in the loop. Two source-verified facts shape the decision:

1. **The node never holds a key.** `ant-node` takes only a public `--rewards-address` and verifies that inbound on-chain payments name it. So **node operation is non-custodial by construction** — receiving rewards needs no private key at all.
2. **Direct spend currently lacks custody tooling.** The `ant` CLI reads a raw private key from the `SECRET_KEY` env var (`require_secret_key`); its `wallet` subcommands are only `address` and `balance`. `antd` can either load an internal wallet from `AUTONOMI_WALLET_KEY` **or** run in an **external-signer** mode (no wallet key) — it returns payment details via `prepare_upload`/`finalize_upload`, an external caller signs and submits the EVM payment, and the daemon finalises with the tx hashes. None of these paths provides wallet creation, an encrypted keystore, recovery, or a built-in signing policy; the external-signer flow is an *integration seam*, not custody (the key still lives with whoever signs). The GUI uses WalletConnect, but the headless story is still "bring your own signer / custody substrate."

David's steer is that forcing ordinary users to supply or understand a crypto wallet is the *scary* path, so for autonomous use an agent owning its own small-value wallet should be a first-class option — provided the private key never reaches the agent's reasoning context. The catch this ADR is honest about: the tooling that would keep a key safe (generation, encrypted storage, recovery, bounded signing) **does not exist upstream today** and must be designed/built or supplied by the host. "Agent-created" must therefore never mean "LLM-created."

## Decision Drivers

- Safety of funds under autonomous operation.
- Least privilege: operating a node grants no spending authority.
- Preserve autonomy: a no-human agent should operate end-to-end within its remit, not be blocked by a missing human.
- Keep the agent's reasoning context free of spend-capable secrets.
- Be honest about current tooling: never imply a custody substrate that does not exist.
- Claim only what the node and skill control, not where a human's key lives.

## Considered Options

1. **Handle a raw private key in the agent context to create/own the wallet.** Rejected: the node needs no key, and a raw key in an agent's context is the core risk we are eliminating.
2. **Require a human-supplied address for every autonomous agent.** Rejected: needlessly blocks autonomous operation and (per David) pushes ordinary users onto the most confusing path.
3. **Agent-owned wallets via an out-of-context custody substrate that meets defined properties, with the substrate's home left as an explicit team decision.** Chosen — it commits autonomy and safety as invariants while being honest that the substrate must still be chosen or built.

## Decision

**Node operation is non-custodial by construction.** The node is given only a public reward address and holds no key; the skill never needs, handles, or instructs placing a private key to run a node.

**Reward-wallet sourcing is a neutral menu — not a ranked ladder and not a hard default.** The agent chooses from its remit, the user, and the available safe tooling:

- **Supplied** — a human/principal provides an existing public address (external custody).
- **Provisioned** — whoever set the agent running provides the address at setup (external custody).
- **Agent-created** — the agent provisions and manages its own reward wallet. This is a **first-class path for autonomous operation**, not an exceptional fallback. It is permitted only where it runs through a custody substrate that keeps key material out of the agent's context (properties below). "Agent-created" means substrate-created on the agent's behalf — **never LLM-created**.

**Secrets out of the agent context is necessary but not sufficient.** Keeping the private key out of the LLM, prompts, and logs is required, but on its own it does not make custody safe. An agent-created wallet is permitted only where the substrate also provides:

- key generation outside the agent context;
- encryption at rest;
- the key never printed, logged, committed, or returned to the agent;
- a **declared recovery path at creation time** (human, designated custodian, encrypted backup + passphrase, recovery phrase shown once to a human, or platform-keychain backup);
- a scoped spend/resource policy;
- auditable spend requests;
- signing confined to the substrate/wrapper/process boundary, with agent-facing output limited to public address, balance, transaction hash, and status.

If those properties cannot be met, the wallet must be treated as **disposable/low-value** and is unsuitable for accumulating meaningful rewards — otherwise the agent stops and escalates.

**Receive is autonomous; spend is under authority.** Running nodes and receiving rewards is fully autonomous regardless of sourcing. Spending or withdrawing ANT is gated by the **remit the operator granted** (envelopes), per ADR-0009 — not per-action human approval. Escalation is **risk-based, not literacy-based**: escalate on no safe custody substrate, a balance crossing a remit threshold, backup/verification failure, a spend beyond the granted envelope, or an explicit self-custody opt-in — never merely because no human supplied an address or "understands crypto."

**Honest current-state boundary.** No existing path provides wallet creation, an encrypted keystore, recovery, or a signing policy, so **agent-owned spend authority is not yet enabled by existing tooling**. Operate-and-earn runs now on a public reward address (key-free). `antd`'s external-signer mode is a useful headless *seam* a custody substrate could plug into, but it is not custody — the substrate still has to exist somewhere else (a reviewed wrapper or upstream wallet support). Agent-owned custody and autonomous spend are **first-class target capabilities** gated on that. A residual remains regardless: at spend time the key must materialise in some signing process's environment — it can be kept out of the agent's context, not out of all process memory.

**Where the custody substrate lives is an open team decision** — assumed host platform / signposted external tooling / a reviewed skill-provided wrapper / upstream `ant` wallet support / a staged combination. This ADR commits the invariants and required properties above; the substrate's home is escalated to the team and recorded later by amendment or a follow-on ADR. **Gas funding is a separate decision (ADR-0005):** a paymaster solves "no ETH for gas," not "who controls the key."

The address must be a valid EVM address usable on **Arbitrum One** (ANT is an ERC-20 there). Delivery sequencing across the capability ladder is owned by the roadmap, not this ADR.

Invariants:

- **Node non-custodial (hard):** the skill never needs, handles, or instructs placing a private key for node operation; the node gets only a public address.
- **Secrets out of context (hard):** no private key, seed, decrypted keystore, or signing token ever enters the agent's context, prompts, logs, or memory; the agent sees only public address / balance / tx hash / status.
- **Necessary but not sufficient:** out-of-context handling does not by itself authorise agent-created custody; the substrate must also meet the required properties, including a declared recovery path at creation.
- **Menu, not default:** supplied, provisioned, and agent-created are all valid; agent-created is first-class for an autonomous remit, never second-class or emergency-only — but no single path is a hard-coded universal default.
- **Receive ≠ spend:** receiving is fully autonomous; spending/withdrawing is remit-gated (ADR-0009) with risk-based escalation.
- **Honest tooling:** the skill never implies a custody substrate, keystore, or signing boundary that upstream does not provide.
- For a human's pre-existing key, the skill offers best-practice guidance only and makes no claim about where it is stored.

## Consequences

### Positive

- Preserves autonomy: a no-human agent can operate end-to-end within its remit, and own a wallet where a safe substrate exists.
- Eliminates the worst failure mode (a raw key in the agent's reasoning context) as a hard invariant.
- Prevents inaccessible rewards via the recovery-at-creation gate.
- Honest about the gap, so the skill won't claim safety it can't deliver.

### Negative / Trade-offs

- Agent-owned spend is not available from existing tooling; it depends on a custody substrate that must be chosen/built (open team decision), or on upstream wallet support.
- Even with a wrapper, the key materialises in a signing process's environment at spend — out of the agent context, not out of all process memory.
- More to specify and review (substrate properties, recovery, audit) before agent-owned spend ships.

### Neutral / Operational

- The custody-substrate location is escalated as a team agenda item and tracked as an open decision (related to, but separate from, ADR-0005/gas).
- Custody and key-securing guidance live in the wallet module for the cases that need it.
- Sequencing of these capabilities is owned by the roadmap (capability ladder), not this ADR.

## Validation

A clean-context agent runs a node configured with only a public address and handles no private key. For any agent-created wallet, review confirms: no key/seed/keystore/signing token ever appears in the agent's context, prompts, logs, or memory (only public address, balance, tx hash, status); a recovery path is declared at creation, else the wallet is marked disposable/low-value; spend happens only within a granted envelope, through the substrate boundary; and the agent escalates on the defined risk triggers, never on the absence of a human. The skill makes no claim of a keystore or signing boundary that upstream lacks. The live-network test uses a reward address sourced by each available path.

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR. The custody-substrate location remains an open team decision, to be recorded by amendment or a follow-on ADR.
