# GSD Work Packet — PR #13 0.1.3 key correction

Date: 2026-09-04
Prepared by: OpenCode
Requested agent/tool: OpenCode with fresh adversarial and Craft review
Role requested: Implementer / Reviewer / Verifier
Review mode: Adversarial review / Craft review; clean-context deferred

## Project / workspace

Project: Autonomi Skills
Repo/path: `WithAutonomi/skills`, isolated branch worktree `autonomi-skill-prototype`
Current source of truth: `docs/CURRENT.md`, `planning/HANDOFF.md`, [PR #13](https://github.com/WithAutonomi/skills/pull/13)

## Goal

Correct the false claim that `SECRET_KEY` is required only for paying commands, bump the shipped prototype to 0.1.3, and record Jim's binary-only uninstall decision as a temporary prototype divergence from Proposed ADR-0008 and DESIGN §6.

## Read first

- `CONTRIBUTING.md`
- `skills/autonomi/SKILL.md`
- `skills/autonomi/references/wallet-and-tokens.md`
- `source-bindings/autonomi.md`
- `docs/DESIGN.md`
- `docs/adr/ADR-0008-skill-structure-and-distribution.md`
- `planning/TESTING.md`
- `planning/evidence/2026-Sep-04-pr13-repair.md`

## Stage

Implementation

## Approved slice

Jim approved these choices live on 2026-09-04:

- **Fix key claim only.** State that `wallet address`, `wallet balance`, and paying operations require `SECRET_KEY`; free reads and cost quotes do not.
- Bump all active shipped/version metadata to 0.1.3.
- **Record prototype deferral.** Keep Proposed ADR-0008 and DESIGN §6 unchanged, but record that Jim explicitly approved binary-only uninstall as a temporary prototype divergence before formal reconciliation.
- Do not change the documented check-then-delete race in this slice.

## Scope

- Correct `skills/autonomi/references/wallet-and-tokens.md` and its exact source binding.
- Update active version surfaces and status/evidence records.
- Add the approved temporary-divergence statement to the prototype note at the top of `docs/DESIGN.md`; do not change DESIGN §6.
- Update [PR #13](https://github.com/WithAutonomi/skills/pull/13) metadata after the exact revision is known.

## Out of scope

- Changing uninstall behavior or the same-file replacement race.
- Editing Proposed ADR-0008 or the underlying DESIGN §6 rule.
- Marking any ADR Accepted.
- Retrying clean-context in this session.
- Real keys, wallet commands, payments, node actions, merge, publication, or repository visibility changes.

## Constraints

- The agent never reads, requests, prints, generates, or handles a private key.
- Source the correction from `WithAutonomi/ant-client` commit `dbc01ce8fdbdfe9ac4d064d35f36b4684bf6a616`, especially `ant-cli/src/main.rs` lines 133–138, 191–211, and 393–400.
- Preserve the failed clean-context lock for inspection and do not count its fallback as evidence.
- Do not modify `.gsd/gate.sh`, CI, a test harness, build invocation, or environment setup.

## Verification required

Meaningful work-unit: Yes — shipped key guidance and an explicit security-decision deferral change.

- Run ADR governance, skill discovery, frontmatter/version, plugin JSON, links, lengths, vocabulary, forbidden-claim, exact-range whitespace, and source-binding checks.
- Run fresh exact-revision adversarial and Craft review after commit.
- Require GitHub ADR CI on the same revision.
- Official Fable clean-context: `Not run`/deferred; no retry in this session.
- No skill-specific CI arbiter exists; evidence is weaker.

## Stop conditions

Stop and report if:

- source inspection contradicts the bounded correction;
- implementation would expose or exercise a real key or wallet;
- the change would require rewriting the uninstall decision rather than recording the approved deferral;
- any ADR would need to be marked Accepted;
- any merge, publication, visibility change, or destructive real-host action arises.

## Required output

- Files and claims changed.
- Source and local verification evidence.
- Exact-revision adversarial, Craft, and CI results.
- Remaining Fable, real-host, dependency, approval, and decision-record risks.
- [PR #13](https://github.com/WithAutonomi/skills/pull/13) metadata status; no merge.
