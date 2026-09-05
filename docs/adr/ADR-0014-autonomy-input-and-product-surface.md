# ADR-0014: Autonomy is an input, not a mode — default-deny remit, and a clean product surface

- **Status:** Proposed
- **Date:** 2026-07-13
- **Decision owners:** Jim Collinson
- **Reviewers:** David Irvine, Hermes
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0002 (single holistic skill), ADR-0003 (operator scope), ADR-0004 (non-custodial / least privilege), ADR-0008 (mutations only within granted remit), ADR-0009 (independent lifecycle), ADR-0010 (human interaction model & register), ADR-0012 (product-first naming), DESIGN §13 (operator personas), `planning/REBUILD-BRIEF.md` §10.

## Context

The skill serves operators across an autonomy spectrum (a person in hands-on steered operation; an agent acting as a human's proxy; a fully autonomous agent — DESIGN §13, ADR-0010). Two tempting patterns would harm the skill, and a third gap needs closing:

- **Self-classified autonomy tiers.** It is tempting to have the skill instruct the agent to *classify itself* into an autonomy "tier"/"mode" and branch its behaviour on that. But the agent's autonomy is **already an input** it holds from its human/harness — self-classification is redundant, error-prone, and dangerous: a mis-selected tier could weaken the safety line that must hold regardless of autonomy.
- **Internal vocabulary leaking into the product.** The skill is designed using internal/build vocabulary — tiers, personas, "operator", "engine", "gauntlet", "packet", "source-binding", ADR/spec references. If that language leaks into the shipped, product-facing text, it mislabels and clutters the product (related to the naming decision, ADR-0012, and the register decision, ADR-0010).
- **No defined behaviour under uncertain remit.** ADR-0004/0009 gate custody/spend/authority, but nothing defines what the agent does *by default* when remit is **missing, ambiguous, or exceeded** — and that default must not depend on a self-selected mode.

## Decision Drivers

- The non-custodial safety line (ADR-0004) must hold **independent of autonomy** — no tier may weaken it.
- Self-classification is redundant (autonomy is an input) and a new error surface.
- The shipped product must read as a clean, self-contained product (ADR-0010/0012), not as build scaffolding.
- Uncertainty needs a **safe, predictable default** that doesn't rely on a mode.
- Safety/reversibility is **not** authority — mutation needs granted remit (ADR-0004 / 0008 / 0009).

## Considered Options

1. **Surface autonomy tiers the agent self-selects, and branch behaviour per tier.** Rejected: redundant (autonomy is an input), error-prone, and risks a weaker safety path on a mis-selected tier.
2. **Leave autonomy handling and the uncertain-remit default implicit/undefined.** Rejected: no defined behaviour under ambiguous remit invites over-reach, and leaves the product-surface vocabulary boundary unstated.
3. **Autonomy is an input (no surfaced tiers); a mode-free default-deny under uncertain remit; and an explicit no-internal-vocabulary product-surface boundary.** Chosen.

## Decision

**1. Autonomy is an input — no surfaced tiers, no self-classification.** The skill does not ask the agent to classify itself into an autonomy mode; its autonomy is an input it already holds from its human/harness. Personas (DESIGN §13) are a **design lens** — for authoring, and for adapting *disclosure* (ADR-0010) — **not a runtime tiering** the agent selects; behaviour and safety never branch on a self-declared tier. The non-custodial safety line (ADR-0004) is **universal and mode-free**.

**2. Mode-free default-deny under uncertain remit — deny *mutation*, not necessary observation.** Safety and reversibility are **not** authority. When remit is missing, ambiguous, or exceeded, the agent may perform only the **necessary non-mutating observation** needed to establish state and authority. Regardless of persona:

- **Missing or ambiguous remit** → the agent limits itself to the **non-mutating observation** needed to establish state and authority (e.g. read-only status/balance checks), and otherwise **asks / escalates / defers**. It does **not** mutate to "fill" the gap, even reversibly.
- **Exceeded remit** → it does **not** perform the proposed action; it remains limited to necessary non-mutating observation, then asks / escalates / defers.
- **Any consequential or state-changing action** (install/upgrade, start/stop, delete/reset, volume selection, spend) → requires **affirmative remit**; absent that, ask / escalate / defer.
- **Emergency containment** is **not** a self-declarable licence. No emergency-mutation authority exists by default: any such authority would have to be **separately and explicitly defined and granted** (narrowly bounded), and **until it is, the capability is inert** — the agent must not assume it, and "emergency" is never self-declared to justify a mutation.

This makes explicit and mode-independent the remit-gating of ADR-0004 / 0008 / 0009: mutate only within granted remit; escalate rather than mutate outside it.

**3. A clean product surface — no internal vocabulary.** The **product surface** — everything shipped/installed: `SKILL.md` and `references/` — carries **none of the internal/build/process vocabulary** used to design the skill. The forbidden set (illustrative, not exhaustive): "tier", "persona", "operator" as a label, "engine", "capture evidence", "gauntlet", "packet", "source-binding" as user-facing jargon, ADR/spec/PR references, TODO / process markers, and internal mode names. Repo-side material (`docs/`, `docs/adr/`, `planning/`, `source-bindings/`) is **exempt** — it is not shipped.

Invariants:
- **Autonomy is an input; the skill never makes the agent self-classify into a tier.**
- **The non-custodial safety line is universal and mode-free** — no autonomy level relaxes it.
- **Default-deny is deny-*mutation*, not necessary observation.** Missing, ambiguous, or exceeded remit permits only necessary non-mutating observation to establish state and authority, followed by asking/escalating/deferring; any state-changing action needs **affirmative remit**. Safety/reversibility never substitutes for authority (ADR-0004 / 0008 / 0009).
- **No internal/build vocabulary in the shipped product surface** (`SKILL.md` + `references/`); repo-side docs are exempt.

## Consequences

### Positive

- Safety behaviour is coherent across all three personas with **no branching on a self-declared tier** and no mis-classification risk.
- A predictable, safe default under uncertain remit.
- The shipped product reads cleanly, matching the naming and register decisions (ADR-0010/0012).

### Negative / Trade-offs

- Default-deny occasionally asks/defers where a bolder agent would act — an accepted cost given the non-custodial safety posture (ADR-0004).
- Authors must actively police the product-surface vocabulary boundary.

### Neutral / Operational

- Refines ADR-0010's persona-awareness (personas adapt *disclosure*, not *authority*) and complements ADR-0012 (product-first naming).
- Builds on ADR-0004 (non-custodial) and ADR-0009 (remit) as their behavioural default, not a new escalation policy.

## Validation

- **Personas without self-classification:** exercised as all three personas, the skill never prompts the agent to declare a tier; the **authority/safety gates are identical** across them, while **disclosure and escalation *routing* are appropriate to the supplied context** — a present human, a proxy's principal, or an autonomous agent's asynchronous/deferred path (ADR-0010) — never keyed on a self-declared tier.
- **Uncertain-remit default, by action class:** with missing/ambiguous/exceeded remit, **only necessary read-only status/balance checks are allowed** to establish state and authority; **install/upgrade, start/stop, delete/reset, external-volume selection, and spend are not performed without affirmative remit** — the agent asks/escalates/defers. Reversibility does not authorise a mutation.
- **Product-surface boundary:** the shipped `SKILL.md` + `references/` contain none of the forbidden build/process vocabulary (a lint/grep + adversarial read); repo-side docs are not checked.

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR.
