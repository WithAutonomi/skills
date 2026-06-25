# GSD Work Packet — Independent node-operation needs brief

Date: 2026-06-25
Prepared by: Jim + Claude (Cowork)
Requested agent/tool: OpenCode (fresh, clean context)
Role requested: Thinker
Review mode, if applicable: N/A (independent parallel take — not a review of existing work)

## Project / workspace

Project: Autonomi Skill — the `autonomi` agent skill (run Autonomi nodes, earn ANT, non-custodial)
Repo/path: github.com/WithAutonomi/skills (private); skill at `skills/autonomi/`
Obsidian/project notes: not needed — do **not** read them (see Constraints)
Current source of truth: the installed `autonomi` skill bundle (`SKILL.md` + `references/`)

## Goal

Produce an independent, fresh-context brief answering: **as an AI agent tasked with operating Autonomi nodes using the `autonomi` skill, what do you still need to understand — your blind spots and information needs — to run nodes effectively and be a good network citizen?** Your brief will be compared against one written independently by another agent, to build the strongest combined version for the dev team. **Form your own view — do not try to match or reproduce anyone else's.**

## Read first

- Install and read the skill (its bundled instructions are the knowledge an operator is *given*):

  ```
  npx skills add WithAutonomi/skills
  ```

  Read `SKILL.md` and every file under its `references/`.
- Nothing else.

## Stage

Loose thinking / Decision prep

## Approved slice or question

"Given only what the skill tells an operator, what would an agent still need to know to run nodes well — and what does it *not* need?" Articulate the needs; do not answer them.

## Relevant artifacts

PRD/product brief: the skill itself is the artifact under consideration
ADR(s): n/a for this task
Spec(s): n/a
Plan/state: n/a
Previous review/checkpoint: **deliberately withheld** to keep your view independent

## Scope

- Take the standpoint of the agent the skill drives. Orient around four operating outcomes the skill must support:
  1. Best use of the host's resources **and** what's best for the network.
  2. Being a good network citizen and **not getting shunned**.
  3. Feeding back **timely, correct information to the human operator**.
  4. Making clear resource-**allocation / utilisation** decisions for the best outcome for all parties.
- For each information need / blind spot: state **what you'd need to know** and **the decision it would unblock**.
- Include a section on **what likely does NOT need to be in an operating SOP** (scope boundaries).
- Output a single markdown document.

## Out of scope

- **Answering** the questions — you are surfacing what must be *delivered* to an operating agent, not deriving answers.
- The data upload/storage side, building *on* Autonomi, and anything requiring keys/spend (the skill is receive-only, non-custodial).

## Constraints / forbidden actions

- **Independence:** do NOT read any existing brief, or this repo's `planning/`, `docs/`, or `source-bindings/`. Work only from the installed skill so your view is genuinely your own.
- **Do NOT dig into source code to derive answers.** The whole point of the skill is that an operating agent should never have to read source to run a node well. If you find yourself wanting to read `ant-node` / `ant-protocol` / `saorsa-core` / `evmlib` to *answer* a question, that is itself the signal — record it as an information need to be delivered, and move on.
- Do NOT actually run, install (beyond reading), or operate nodes; do not modify any repo; no PRs.

## Verification required

- Self-check before returning: every item is a *need to know* (not an answer); all four outcomes are covered; the "what doesn't belong in the SOP" section is present; nothing was drawn from an existing brief or planning note.
- Clean-context test required? N/A
- Adversarial review required? No
- Jim PR-raise approval required? N/A (no repo changes)
- Reviewer independence requirement: must not consult the existing brief or planning notes.
- Validation evidence to inspect: the returned brief + a one-paragraph note on what it was grounded in.

## Stop conditions

Stop and report if:

- The skill won't install or can't be read (report exactly what blocked it).
- You are tempted to answer a question from source — record it as a need instead, and continue.

## Required output

Return:

- role performed (Thinker);
- sources read (which skill files);
- the brief (markdown): information needs / blind spots grouped sensibly, each with *what you need to know* + *the decision it unblocks*; plus a "what doesn't belong in the SOP" section;
- method note: how you grounded it, and anything you deliberately excluded;
- blockers/risks;
- recommended next step.
