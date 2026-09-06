# GSD Work Packet — PR #13 repair

Date: 2026-09-04
Prepared by: OpenCode (OpenAI `gpt-5.6-sol`), approved by Jim
Requested agent/tool: OpenCode
Role requested: Implementer / Coordinator
Review mode: Clean-context test / Adversarial review / Craft review

## Project / workspace

Project: Autonomi Skills
Repo/path: `WithAutonomi/skills`; isolated worktree for `autonomi-skill-prototype`
Current source of truth: `docs/CURRENT.md`, `planning/TESTING.md`, `planning/HANDOFF.md`, `source-bindings/autonomi.md`, and PR #13

## Goal

Repair PR #13's confirmed factual and safety defects without widening the prototype: replace exhaustive teardown guidance with a binary-only uninstall default, correct update and wallet claims, set the approved licence holder, synchronize version 0.1.2, and leave an honest verification record.

## Read first

- `CONTRIBUTING.md`
- `skills/autonomi/SKILL.md` and its references
- `source-bindings/autonomi.md`
- `planning/TESTING.md`
- `docs/CURRENT.md`
- `planning/HANDOFF.md`
- relevant Proposed ADRs, especially ADR-0003, ADR-0006, and ADR-0013

## Stage

Implementation, verification, review, and handoff.

## Approved slice

Jim approved the repair plan and chose the binary-only uninstall default on 2026-09-04. An uninstall request authorizes removal of the discovered `ant` executable only. Settings, application data, logs, nodes, payment receipts, and user files remain untouched unless the person separately requests destructive cleanup.

## Scope

- Shorten uninstall guidance in the main skill and install reference.
- Correct `ant update` and wallet-balance claims against ant-client 0.3.6 source.
- Update provenance and add a disposable-environment uninstall scenario.
- Bump all active version surfaces to 0.1.2.
- Change the MIT copyright line to `Copyright 2026 Autonomi`.
- Reconcile current-state, handoff, test evidence, and PR metadata.

## Out of scope

- Recovering or recreating the host's deleted Autonomi state.
- Running `ant` against the real home directory.
- Paid writes, node lifecycle actions, repository visibility changes, merge, or publication.
- Revising or accepting ADRs.
- Changing CI, a test harness, build invocation, or environment setup.

## Verification required

Meaningful work-unit: Yes — shared-repository skill guidance includes destructive-operation safety.
Local fast gate: No `.gsd/gate.sh` exists.
CI arbiter: GitHub ADR Governance only; no CI arbiter exists for skill-specific checks, so evidence is weaker.
Required reviews: fresh adversarial and Craft reviews of the full repair; clean-context uninstall behavior exercised only in a disposable directory.

Run the repository's documented static checks: ADR governance, skill discovery, frontmatter, vocabulary, source binding, links, lengths, synchronized versions, and `git diff --check`. Run Snyk only if its existing token is available; do not alter the environment to manufacture a pass.

## Stop conditions

Stop and report if work appears to require changing CI, a gate, test harness, build command, or environment setup; if a check would touch the real Autonomi installation or `~/Library/Application Support/ant`; if a failure is dismissed without base-branch evidence; if an Accepted ADR would need changing; or before any commit, push, merge, publication, paid operation, node operation, or repository visibility change not explicitly authorized.

## Required output

Return changed files, verification evidence, independent review results, remaining risks, PR #12 dependency status, and the next owner checkpoint.
