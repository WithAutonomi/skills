# GSD Work Packet - PR #13 post-PR #12 reconciliation

Date: 2026-09-06
Prepared by: OpenCode
Requested agent/tool: OpenCode
Role requested: Implementer / Verifier
Review mode: proportionate local verification; manual Hermes review before merge

## Project / workspace

Project: Autonomi Skills
Repo/path: `WithAutonomi/skills`, branch `autonomi-skill-prototype`
Current source of truth: merged `main`, this packet, `planning/TESTING.md`, `planning/HANDOFF.md`, and [PR #13](https://github.com/WithAutonomi/skills/pull/13)

## Goal

Reconcile the 0.1.4 task-routed prototype with the decisions and current-state corrections merged through [PR #12](https://github.com/WithAutonomi/skills/pull/12), then leave one clean exact-head candidate for a manual Hermes review.

## Read first

- `CONTRIBUTING.md`
- `README.md`
- `planning/HANDOFF.md`
- `planning/TESTING.md`
- `docs/DESIGN.md`
- `docs/adr/`
- `source-bindings/autonomi.md`
- `planning/evidence/2026-Sep-04-pr13-repair.md`

## Stage

Implementation / reconciliation / verification

## Approved slice

Jim approved these instructions live on 2026-09-06:

- Reconcile PR #13 with merged PR #12 and prepare it for re-review.
- Keep every ADR **Proposed**. Do not expand this slice to resolve broader Proposed-ADR contradictions; use the prototype evidence, then amend the Proposed records.
- Preserve the intended later direction: bundled operational core with optional external depth, and recovery required for every agent-created wallet.
- The prototype's recorded divergence from the Proposed ADR/design set, including binary-only uninstall, is not a pre-merge reconciliation gate for this prototype.
- Do not run Fable, extensive adversarial review, or Craft Review. Manual Hermes review is the independent gate before merge.

## Scope

- Merge current `origin/main` into `autonomi-skill-prototype` without rewriting the published branch.
- Resolve conflicts by preserving PR #12's channel-owned-update, authority/remit, provenance, platform-truth, security, and current-state corrections while preserving PR #13's task-routed 0.1.4 prototype, plugin packaging, bounded uninstall, source bindings, test protocol, and archive.
- Update active current-state documents and [PR #13](https://github.com/WithAutonomi/skills/pull/13) so merged PR #12 is no longer a dependency and the owner-approved prototype/ADR deferral is explicit.
- Run the repository's static checks, a disposable skill-install smoke test, and a bounded free-read exercise if the documented path works without touching real user state.
- Push the reconciled exact head and record exact-head CI.

## Out of scope

- Marking any ADR Accepted.
- Resolving broader Proposed-ADR contradictions before prototype evidence exists.
- Adding capabilities, changing the prototype's product design, or bumping version unless conflict resolution changes shipped skill content.
- Paid writes, wallet-key use, node operations, destructive cleanup, publication, repository visibility changes, or merging the PR.
- Fable, adversarial, Craft, Snyk, trigger-evaluation, Windows, or multi-harness testing.

## Verification required

- `GITHUB_BASE_REF=main python3 scripts/adr-governance.py`
- `git diff --check origin/main...HEAD`
- Confirm all ADRs remain Proposed and no Accepted ADR changed.
- Run the static checks in `planning/TESTING.md` section 3, except Snyk and broader evals explicitly excluded above.
- `npx skills add ./ --list` and a disposable branch-install smoke test with isolated project/home state.
- If feasible without real-home, paid, wallet, or node action: exercise Scenario A's free-read path in disposable state; otherwise record the exact environmental blocker without weakening the gate.
- GitHub ADR Governance CI on the pushed exact head.
- Manual Hermes review before merge.

## Stop conditions

Stop and report if conflict resolution requires a new product/security/architecture decision, changes an Accepted ADR, weakens the key/spend/uninstall boundaries, requires CI/test-harness changes, touches real user state, spends funds, starts nodes, publishes, changes visibility, or merges the PR.

## Required output

- Reconciliation decisions and files changed.
- Local smoke/exercise evidence and limitations.
- Exact pushed head and CI status.
- Remaining manual Hermes and human merge gates.
