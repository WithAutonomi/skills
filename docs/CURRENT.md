# GSD Checkpoint — Tier 1 operator doctrine pass

Date: 2026-06-22
Project: Autonomi Operator Skill (`JimCollinson/autonomi-skill`)
Slice/question: Apply completed operator doctrine / grounding to the already-merged Tier-1 operate-and-earn skill.
Prepared by: OpenCode GSD orchestrator, with @pm, @operative, @codereviewer, @verifier, @craft.

> **Incoming agent:** start from `main`, then read `README.md` → `docs/VISION.md` → `docs/DESIGN.md` (especially §13) → `docs/adr/` (especially ADR-0004, 0006, 0009, 0010, 0011) → `docs/operating-doctrine.md` → `docs/skill-grounding.md` → `SKILL.md` + `references/` + `source-bindings/tier1-operate-and-earn.md` → `CONTRIBUTING.md`.

## Status

**Stop for PR review.** The doctrine authoring slice is complete on branch `feat/tier1-operator-doctrine`; PR #7 is open into `main`: https://github.com/JimCollinson/autonomi-skill/pull/7. Do not merge, publish, or transfer without Jim's approval.

Meaningful work-unit? **Yes** — it changes the shipped skill content, operating policy, and source-binding manifest.

Review cadence: code review + verification + Craft Review completed. **Fresh-agent clean-context live test and adversarial gauntlet are explicitly deferred** by slice instruction; they must be dispatched separately by agents that did not author this skill content.

Unreviewed backlog if deferred:

- Fresh clean-context live-network test from the installed skill.
- Independent adversarial review of Tier-1 readiness, including ADR-0010 plain-language / over-exposure and ADR-0011 query-based health checks.

## What happened

- Synced from current `main` (`5178dee`) into a fresh clone and created `feat/tier1-operator-doctrine`.
- Ran @pm to turn the approved slice into a concrete implementation checklist.
- Ran @operative to apply the doctrine pass in commit `6e0250c`:
  - added the grounded SKILL opener and About/references section from `docs/skill-grounding.md`;
  - wove the DESIGN §13 personas and ADR-0010 plain-language / by-exception escalation model through `SKILL.md`;
  - deepened `references/operating-procedures.md` from `docs/operating-doctrine.md`;
  - added `references/agent-autonomy-policy.md`;
  - updated wallet-address language, validation snippets, query-based health guidance, and source bindings;
  - removed the committed runtime public wallet address from source bindings.
- Ran code review, goal verification, and Craft Review.
- Added verifier evidence at `planning/phases/tier1-operator-doctrine/VERIFICATION.md` and cleaned up the source-binding section layout.

## Evidence

CI arbiter / green of record:

- Location: GitHub Actions `ADR Governance` workflow on PR/main changes touching ADR governance files.
- Status: no checks reported on branch `feat/tier1-operator-doctrine` / PR #7 at checkpoint time (`gh pr checks 7`).
- Note: this repo currently has no full skill-content CI arbiter; evidence for Markdown skill changes is local review + PR review, so non-ADR evidence is weaker than clean CI.

Local fast gate / `.gsd/gate.sh`:

- Installed? N/A — no `.gsd/gate.sh` exists in this repo.
- Commands run:
  - `python3 scripts/adr-governance.py`
  - `git diff --check main...HEAD`
- Result: passed.

Files changed/artifacts produced:

- `SKILL.md`
- `references/agent-autonomy-policy.md`
- `references/operating-procedures.md`
- `references/node-operation.md`
- `references/wallet-and-ant.md`
- `references/troubleshooting.md`
- `templates/node-preflight-checklist.md`
- `templates/node-health-report.md`
- `source-bindings/tier1-operate-and-earn.md`
- `planning/phases/tier1-operator-doctrine/VERIFICATION.md`
- `docs/CURRENT.md`

Checks run:

- `python3 scripts/adr-governance.py` → passed, 11 ADR files checked.
- `git diff --check main...HEAD` → passed.
- `gh pr checks 7` → no checks reported on the branch.
- @codereviewer → passed.
- @verifier → passed, 6/6 goals; wrote `planning/phases/tier1-operator-doctrine/VERIFICATION.md`.
- @craft → passed; no CONFORMANCE findings.

## Honesty rules check

- No-harness-modification: **Pass** — no CI, gate, harness, daemon wrapper, build invocation, or test-harness changes.
- Baseline-diff for evidence: **N/A / Pass** — no failures dismissed as flaky/environmental/pre-existing.
- Evidence reproducible-from-branch: **Pass** for local Markdown checks; deferred fresh-agent live gauntlet still required for full Tier-1 readiness.
- Local vs CI consistency: CI not yet observed for this PR branch; no local/CI conflict known.

## Review findings

Clean-context test:

- Reviewer/tool: Not run.
- Result: **Not run — explicitly deferred.**
- Findings: Must be run by a fresh agent after this authoring PR, from repo/docs/skill only.

Adversarial review:

- Reviewer/tool: Not run.
- Required? Yes for Tier-1 readiness, but explicitly deferred by this slice instruction.
- Result: **Not run — explicitly deferred.**
- Findings: Run separately before treating Tier 1 as ready.

Craft Review:

- Reviewer/tool: @craft.
- Verdict: **Pass.**
- CONFORMANCE findings and dispositions: none.
- NIT carried/fixed: source-binding doctrine sections were moved out of the original “Resolved open questions” sequence into `Doctrine and product claim bindings`.

## Drift / scope concerns

- Tier 2/3 remain gated on custody/gas decisions (ADR-0004/0005). This slice did not implement custody, signing, spend, gas, upload, or acquisition.
- Health remains query-based per ADR-0011: no log scraping, metrics scraping, or node-internal file reads for health.
- Runtime public wallet addresses are operational inputs; do not commit them to source bindings, evidence, PR text, or issues.

## Open questions / decisions for Jim

- PR review/merge decision.
- Whether to dispatch the deferred clean-context live-network test and adversarial review immediately against this PR branch.

PR / upstream action gate:

- PR ready to raise? **Yes.**
- PR raised? **Yes:** https://github.com/JimCollinson/autonomi-skill/pull/7
- Jim confirmed PR may be opened? **Yes — requested in the slice.**
- Jim confirmed PR may be merged? **No.** Stop for review.

## Recommended next step

Review the PR. Then dispatch fresh-agent clean-context live-network testing and independent adversarial review before declaring Tier 1 ready.

## Handoff note

This branch is an authoring/doctrine pass only. It deliberately does **not** run the Tier-1 live gauntlet. Future reviewers should focus on whether the skill now speaks in the approved plain-language/persona register, whether `agent-autonomy-policy.md` correctly reflects the operating doctrine, and whether source bindings cover all new product/doctrine claims without runtime-address leakage.
