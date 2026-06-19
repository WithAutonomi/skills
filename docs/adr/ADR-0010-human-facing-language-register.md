# ADR-0010: Human interaction model — disclosure, escalation, and a plain-language register

- **Status:** Proposed
- **Date:** 2026-06-18
- **Decision owners:** Jim Collinson
- **Reviewers:** David Irvine
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0002 (progressive disclosure), ADR-0003 (operator scope), ADR-0004 (non-custodial / risk-based escalation), ADR-0009 (remit-gated operation), VISION (audience & principles), DESIGN §13 (operator personas + translation map).

## Context

The skill is authored **for an AI agent**, where technical precision is correct and necessary — `--rewards-address`, an EVM address on Arbitrum One, ANT as an ERC-20, a transaction fee, ML-DSA signatures. But the operator running through the skill spans a spectrum (a person directly; an agent acting for a human; a fully autonomous agent), and crypto/developer jargon and a pile of low-level decisions are unhelpful — even alienating — to an ordinary person (the same "scary path" concern behind ADR-0004). David's intent, which we share: the agent should **do most of the work itself** — using its intelligence, judgement, and granted remit — and **not burden the operator** with inner workings, crypto detail, or routine choices, escalating to a human only when genuinely needed; and when it does communicate, use plain (but not patronising) language, ready to explain and expand on request. Nothing currently defines this interaction model, so the first authoring pass risks both over-exposing mechanics and over-asking. (This is distinct from the internal terminology standardization — "public wallet address" — which governs our own docs; this ADR governs how the agent *relates to and talks to* the operator.)

## Decision Drivers

- The product reaches ordinary people through agents; alienating language or decision-dumping defeats the purpose.
- Do-the-work-by-default: leverage the agent's judgement; reserve the human's attention for what's genuinely theirs.
- Progressive disclosure (ADR-0002) applies to vocabulary and to *how much* is surfaced, not just modules.
- Safety is not "burden": money / risk / authority decisions must still reach the human (ADR-0004/0009).
- Accuracy must survive simplification — plain must not become wrong, and must not imply capabilities or safety that don't exist (ADR-0004/0005).

## Considered Options

1. **One technical register, everything surfaced.** Rejected: precise for the agent, alienating and burdensome for the humans it serves.
2. **Dumb the skill down / hide everything.** Rejected: strips the precision the agent needs, risks inaccuracy, and would hide decisions that are rightfully the human's.
3. **A defined interaction model: do-the-work-by-default with by-exception escalation, persona-aware, expressed in a plain-language register with a translation layer.** Chosen.

## Decision

The skill defines how the agent **relates to and talks to** the operator, in three parts.

**1. Division of labour & disclosure.** The agent **shoulders the inner workings and the routine operational decisions itself** — using its judgement and the remit it has been granted (ADR-0004/0009). It surfaces to the operator **outcomes** and **the decisions that are genuinely theirs**, and otherwise stays out of the way. "How much to reveal" = as little as needed for the operator to stay informed and in control of what actually matters to them. Crucially, *minimise burden* applies to **operational mechanics and jargon, not to authority**: spend, risk, recovery, and consent decisions are always surfaced — quietly handling routine ops is good; quietly making a money/risk decision is not. Escalation is **by exception**, on the risk-based triggers already defined (authority/spend beyond remit, balance over threshold, backup/recovery, no safe substrate, explicit opt-in) — never for routine work, and never gated on "do you understand crypto?".

**2. Persona-aware.** The operator is one of three personas (defined in DESIGN §13): a **human** operating directly, an **agent acting as a human's proxy**, or a **fully autonomous agent**. The agent adapts disclosure and register to which it is serving — full plain-language translation for a human; minimal-but-sufficient surfacing by a proxy agent to its principal; internal precision plus audit/escalation-only for a fully autonomous agent (which, absent a human, halts/defers at a gate rather than crossing it).

**3. Plain-language register.** When addressing a human, the agent uses plain language — **assume intelligence, not knowledge** (plain, not patronising) — leads with meaning before naming a precise term, reports outcomes rather than commands/flags/hashes, keeps network/crypto internals out of view unless asked, and is **always ready to explain and expand on request** (progressive depth). A translation layer (technical → human; e.g. "a transaction fee for the payment", not "native Arbitrum gas") lives in DESIGN §13 and is applied across all human-facing copy. Accuracy is never sacrificed for simplicity.

Invariants:

- **Do the work; escalate by exception.** The agent handles routine operation and decisions within its remit; it does not narrate machinery or hand the operator routine choices.
- **Never hide authority.** Money, risk, recovery, and consent decisions are always surfaced to the human, regardless of how light the rest of the disclosure is.
- **Plain, not patronising.** Human-facing language assumes intelligence, not specialist knowledge; precise terms are available, introduced in plain words first, and explained on request.
- **Outcomes, not mechanics.** No CLI tables, flags, hashes, or raw addresses in human-facing output unless asked.
- **Accuracy over simplicity.** Simplification never makes a claim wrong or implies a capability/safety property that doesn't exist.
- The translation map and personas live in DESIGN §13; exact word choices are a product/UX decision owned by Jim.

## Consequences

### Positive

- Ordinary people can run nodes through an agent without being burdened or alienated; matches David's intent.
- The autonomy spectrum is handled coherently (human ↔ proxy ↔ fully autonomous) by one model.
- Testable: the gauntlet can check for over-exposure, over-asking, and jargon.

### Negative / Trade-offs

- Authors maintain a register and a translation map, and must judge the do-vs-surface line — more care per claim.
- A risk of over-simplifying into inaccuracy, or of under-surfacing a decision that *was* the human's — mitigated by the "never hide authority" and "accuracy over simplicity" invariants and the review gauntlet.

### Neutral / Operational

- Builds on ADR-0004's risk-based escalation and ADR-0009's remit; this ADR is their UX expression, not a new escalation policy.
- The internal "public wallet address" standardization is the agent-facing precision layer; the human-facing layer translates further.

## Validation

A reading of the agent's human-facing output finds it plain and non-patronising, with no unexplained crypto/developer jargon and no raw mechanics; the agent is shown to handle routine work without surfacing it, yet to surface money/risk/authority decisions every time; it explains/expands correctly on request; and simplification introduces no inaccuracy. The clean-context and adversarial gauntlet includes this read (over-exposure, over-asking, jargon, and any hidden authority decision are findings).

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR.
