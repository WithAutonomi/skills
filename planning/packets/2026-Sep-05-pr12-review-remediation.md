# GSD Work Packet — PR #12 review remediation

Date: 2026-Sep-05
Prepared by: OpenCode
Requested agent/tool: OpenCode and independent reviewers
Role requested: Implementer, verifier, adversarial reviewer, Craft reviewer, clean-context reviewer
Review mode: Full ADR/documentation review

## Project / workspace

Project: Autonomi skill
Repo/path: `/Users/jimcollinson/code/skills`
Current source of truth: PR #12 branch `docs/state-refresh` plus David Irvine's reviews at head `7f3b2e2690975184ab88aba3910cbbe05b597812`

## Goal

Make PR #12 ready for renewed human review by resolving David's four outstanding findings and aligning Proposed ADR-0013 with Jim's later channel-owned update decision.

The four findings are:

1. Installed-skill updates belong to the installation channel; do not add an in-skill self-version request.
2. Safety and authority gates are identical across contexts; only disclosure and escalation routing vary.
3. Missing, ambiguous, or exceeded remit permits only necessary non-mutating observation, followed by asking, escalating, or deferring.
4. Acting inside an affirmative existing envelope needs no per-action approval; granting or widening authority remains explicit.

## Read first

- `CONTRIBUTING.md`
- `docs/adr/TOOLING.md`
- David Irvine's reviews on PR #12
- Proposed ADR-0004, ADR-0008, ADR-0009, ADR-0010, ADR-0013 and ADR-0014
- `docs/DESIGN.md` §4 and §13

## Stage

Implementation

## Approved slice

Repair PR #12's decision and planning documents, validate them, push the revised head, and update the PR for human re-review. Stop before merge or ADR acceptance.

## Scope

- Preserve and finish the inherited uncommitted authority/remit corrections.
- Make channel-owned installed-skill updates the Proposed ADR-0013 decision; remove the proposed in-skill self-version check.
- Reconcile active design and planning references with those decisions.
- Update PR #12's title/body and evidence after verification.

## Out of scope

- Skill implementation or runtime behaviour.
- Accepting any ADR.
- Merging PR #12 or PR #13.
- Rebasing or otherwise changing PR #13.
- Repository visibility or publication.

## Constraints / forbidden actions

- Preserve all inherited uncommitted work unless a line conflicts with Jim's later channel-owned update decision.
- Do not edit Accepted ADRs; all changed ADRs must remain Proposed.
- Do not weaken remit, custody, spend, or human-governance gates.
- No test, CI, harness, build, or environment changes.

## Unattended mode / rigor profile

Unattended mode: No

Rigor profile: Full review because this changes Proposed architectural and authority decisions. Run local validation, independent adversarial review, Craft Review, verification, and a clean-context documentation review before requesting human approval.

## Verification required

- `GITHUB_BASE_REF=main python3 scripts/adr-governance.py`
- `git diff --check origin/main...HEAD`
- Focused search for superseded self-check and authority wording in active changed documents
- Confirm all changed ADRs remain Proposed and no Accepted ADR changed
- GitHub ADR Governance CI on the pushed exact head
- Independent adversarial, Craft, verifier, and clean-context results

No `.gsd/gate.sh` exists. GitHub Actions `ADR Governance` on PR #12 is the only CI arbiter and covers ADR structure/governance, not semantic correctness.

## Stop conditions

Stop and report if the repair requires changing an Accepted ADR, implementation, CI/test machinery, or a decision not already made by Jim. Stop before merge, publication, repository visibility changes, or ADR acceptance.

## Required output

- Files and decisions changed
- Local and CI evidence
- Review findings and dispositions
- Remaining human gate
- Exact pushed head
