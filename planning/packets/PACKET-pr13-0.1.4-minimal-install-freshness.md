# GSD Work Packet — PR #13 minimal 0.1.4 install/freshness repair

Date: 2026-09-04
Prepared by: OpenCode
Role requested: Implementer / ADR drafter / Reviewer / Verifier
Review mode: ADR validation / Adversarial review / Craft review; clean-context deferred

## Project / workspace

Project: Autonomi Skills
Repo/path: `WithAutonomi/skills`, isolated branch worktree `autonomi-skill-prototype`
Current source of truth: `docs/CURRENT.md`, `planning/HANDOFF.md`, [PR #13](https://github.com/WithAutonomi/skills/pull/13)

## Goal

Make the smallest correction to the broken Unix manual-install config destination, and align still-Proposed ADR-0013 with the simple `VERSION` check that already ships. Add no identity/hash machinery.

## Approved slice

Jim approved the minimal route live on 2026-09-04:

- Fix the manual install to use the platform's actual config directory and preserve an existing `bootstrap_peers.toml`.
- Bump active shipped/version metadata to 0.1.4.
- Keep the existing best-effort semantic `VERSION` check.
- Update Proposed ADR-0013 to describe that check, remove the contradictory identity/hash requirement and remove implementation sequencing from the ADR.
- Add no new checker, lock format, folder hash, update automation, or uninstall behavior.

## Scope

- `skills/autonomi/references/install-and-verify.md`
- Active version surfaces and exact source binding
- Proposed ADR-0013, `docs/DESIGN.md` freshness wording, and the directly contradictory PR #12-era `planning/NEXT-PHASE.md` record
- Current state, testing, evidence, and [PR #13](https://github.com/WithAutonomi/skills/pull/13) metadata

## Out of scope

- Implementing install identity or folder hashing
- Changing the update command, uninstall behavior, or the carried same-file race
- Resolving the separate Proposed ADR-0008 / DESIGN §6 uninstall conflict
- Marking any ADR Accepted
- Retrying clean-context in this session
- Real keys, payments, node actions, merge, publication, or repository visibility changes

## Verification required

- Prove the config-path snippet in disposable macOS and XDG-Linux fixtures without touching the real home.
- Prove an existing bootstrap file remains byte-identical.
- Run ADR governance, skill discovery, frontmatter/version, plugin JSON, links, lengths, vocabulary, forbidden-claim, source-binding, and exact-range whitespace checks.
- Validate the Proposed ADR update against repo-local ADR rules.
- Run fresh exact-revision adversarial and Craft review and require GitHub ADR CI.
- Official Fable clean-context remains `Not run`/deferred; do not retry in this session.

## Stop conditions

Stop if the change requires new runtime machinery, an Accepted ADR edit, a real-home write, a real `ant` invocation, CI/harness/gate changes, merge, publication, or repository visibility changes.

## Required output

- Bounded changes and source evidence
- Disposable path-preservation proof
- ADR validation, local checks, exact-revision reviews, and CI
- Remaining Fable, real-host, PR #12, ADR-0008/DESIGN §6, and human-approval gates
