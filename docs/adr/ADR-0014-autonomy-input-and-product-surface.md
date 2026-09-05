# ADR-0014: Autonomy is an input, not a mode — default-deny remit, and a clean product surface

- **Status:** Proposed
- **Date:** 2026-07-13
- **Decision owners:** Jim Collinson
- **Reviewers:** David Irvine, Hermes
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0002 (single holistic skill), ADR-0003 (operator scope), ADR-0004 (non-custodial), ADR-0009 (remit-gated operation), ADR-0010 (human interaction model & register), ADR-0012 (product-first naming), DESIGN §13 (operator personas), `planning/REBUILD-BRIEF.md` §10.

## Context

The skill serves operators across an autonomy spectrum (a human operating directly; an agent acting as a human's proxy; a fully autonomous agent — DESIGN §13, ADR-0010). Two tempting patterns would harm the skill, and a third gap needs closing:

- **Self-classified autonomy tiers.** It is tempting to have the skill instruct the agent to *classify itself* into an autonomy "tier"/"mode" and branch its behaviour on that. But the agent's autonomy is **already an input** it holds from its human/harness — self-classification is redundant, error-prone, and dangerous: a mis-selected tier could weaken the safety line that must hold regardless of autonomy.
- **Internal vocabulary leaking into the product.** The skill is designed using internal/build vocabulary — tiers, personas, "operator", "engine", "gauntlet", "packet", "source-binding", ADR/spec references. If that language leaks into the shipped, product-facing text, it mislabels and clutters the product (related to the naming decision, ADR-0012, and the register decision, ADR-0010).
- **No defined behaviour under uncertain remit.** ADR-0004/0009 gate custody/spend/authority, but nothing defines what the agent does *by default* when remit is **missing, ambiguous, or exceeded** — and that default must not depend on a self-selected mode.

## Decision Drivers

- The non-custodial safety line (ADR-0004) must hold **independent of autonomy** — no tier may weaken it.
- Self-classification is redundant (autonomy is an input) and a new error surface.
- The shipped product must read as a clean, self-contained product (ADR-0010/0012), not as build scaffolding.
- Uncertainty needs a **safe, predictable default** that doesn't rely on a mode.

## Considered Options

1. **Surface autonomy tiers the agent self-selects, and branch behaviour per tier.** Rejected: redundant (autonomy is an input), error-prone, and risks a weaker safety path on a mis-selected tier.
2. **Leave autonomy handling and the uncertain-remit default implicit/undefined.** Rejected: no defined behaviour under ambiguous remit invites over-reach, and leaves the product-surface vocabulary boundary unstated.
3. **Autonomy is an input (no surfaced tiers); a mode-free default-deny under uncertain remit; and an explicit no-internal-vocabulary product-surface boundary.** Chosen.

## Decision

**1. Autonomy is an input — no surfaced tiers, no self-classification.** The skill does not ask the agent to classify itself into an autonomy mode; its autonomy is an input it already holds from its human/harness. Personas (DESIGN §13) are a **design lens** — for authoring, and for adapting *disclosure* (ADR-0010) — **not a runtime tiering** the agent selects; behaviour and safety never branch on a self-declared tier. The non-custodial safety line (ADR-0004) is **universal and mode-free**.

**2. Mode-free default-deny under uncertain remit.** When remit is **missing, ambiguous, or would be exceeded**, the agent — regardless of persona — takes only the **least-authority, safe, reversible** action, and otherwise **asks, escalates, or defers**. It never assumes broader authority to close a gap. This is the default behaviour ADR-0004/0009 imply, made explicit and mode-independent.

**3. A clean product surface — no internal vocabulary.** The **product surface** — the skill instructions loaded into agent context from `SKILL.md` and `references/` — carries **none of the internal/build/process vocabulary** used to design the skill. The forbidden set (illustrative, not exhaustive): "tier", "persona", "operator" as a label, "engine", "capture evidence", "gauntlet", "packet", "source-binding" as user-facing jargon, ADR/spec/PR references, TODO / process markers, and internal mode names. Repo-side material (`docs/`, `docs/adr/`, `planning/`, `source-bindings/`) is **exempt**: a channel package may contain it, but it is not loaded as skill instructions.

Invariants:
- **Autonomy is an input; the skill never makes the agent self-classify into a tier.**
- **The non-custodial safety line is universal and mode-free** — no autonomy level relaxes it.
- **Default-deny under uncertainty:** missing / ambiguous / exceeded remit → least-authority, safe, reversible action only, else ask / escalate / defer.
- **No internal/build vocabulary in the loaded product surface** (`SKILL.md` + `references/`); repo-side docs are exempt.

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

- **Personas without self-classification:** exercised as all three personas, the skill never prompts the agent to declare a tier, and the safety/escalation behaviour is identical across them.
- **Uncertain-remit default:** given missing / ambiguous / exceeded remit, the agent takes only least-authority reversible action or asks / escalates / defers — never broader authority.
- **Product-surface boundary:** the shipped `SKILL.md` + `references/` contain none of the forbidden build/process vocabulary (a lint/grep + adversarial read); repo-side docs are not checked.

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR.
