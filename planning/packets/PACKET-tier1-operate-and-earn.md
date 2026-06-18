# GSD Work Packet

Date: 2026-06-18
Prepared by: Cowork (Claude) orchestration, on Jim's behalf
Requested agent/tool: OpenCode + coding model, working in the `autonomi-skill` repo
Role requested: **Implementer** (one slice)
Review mode, if applicable: N/A for this packet — the gauntlet (clean-context test + adversarial review) is a separate dispatch to fresh agents.

## Project / workspace

Project: Autonomi Operator Skill — an auto-updating, agent-facing skill teaching an AI agent to operate and use the Autonomi network.
Repo/path: `github.com/JimCollinson/autonomi-skill` (local `~/Code/autonomi-skill`)
Obsidian/project notes: vault `Projects/Autonomi Skill` (loose thinking only; VISION/FEATURES/DESIGN/ROADMAP/DECISIONS are stubs pointing to the repo)
Current source of truth: **the repo** — `docs/DESIGN.md`, `docs/adr/ADR-0001…0009` (all Proposed), `planning/ROADMAP.md`, and the slice spec `docs/SPEC-tier1-operate-and-earn.md`.

## Goal

Author the **Tier-1 (operate-and-earn) first pass** of the skill, built on the **existing** `ant` CLI + node daemon, source-bound throughout, so that a clean-context agent — given only the installed skill — can install/detect `ant`, configure a **public** reward address, run/manage one or more nodes on the **live network**, monitor health, check earned rewards for that public address, and cleanly stop/uninstall — **without seeing or handling any private key**. Resolve the four open questions in the spec by checking upstream source, not by inventing.

## Read first

- `docs/SPEC-tier1-operate-and-earn.md` — the slice spec (scope, acceptance bar, source-bound command surface, open questions, gauntlet). **Primary.**
- `docs/DESIGN.md` — §2 (SKILL.md structure), §3 (modules), §5 (interface model), §6 (install/secure delivery), §12 (capability ladder).
- `docs/adr/` — ADR-0002 (one holistic skill), ADR-0003 (operator scope/interface, existing surfaces only), ADR-0004 (non-custodial / secrets-out-of-context — **invariants, do not touch the decision**), ADR-0006 (source-binding), ADR-0008 (x0x-precedent structure + `metadata.openclaw.install`), ADR-0009 (no-lockstep / non-mutating install).
- `planning/ROADMAP.md` — Tier 1 in the ladder; the Open team decisions (custody, gas) that bound what Tier 1 may claim.
- The **x0x skill** (`saorsa-labs/x0x`) — structural precedent: `SKILL.md` shape, progressive disclosure, the `metadata.openclaw.install` manifest pattern, signature/checksum verification.
- Upstream for grounding: ant-client `ant-cli/src/cli.rs` + command modules; dev-docs `docs/cli/command-reference.md` & `use-the-cli.md` (verification header: ant-client commit `84332e2d`, verified 2026-06-10); `ant-node` releases (`SHA256SUMS` + ML-DSA-65 / FIPS-204 signatures).

## Stage

Implementation.

## Approved slice or question

Tier 1 (operate-and-earn) authoring, approved by the team on 2026-06-18 (Jim + David's Hermes): author and agent-test Tier 1 only, while ADR-0004/0005 remain Proposed and under David's architecture review. **One slice: author the Tier-1 skill files in the repo on a feature branch.** Not Tier 2/3.

## Relevant artifacts

PRD/product brief: `docs/VISION.md` (David's original brief is captured in the vault kickoff notes).
ADR(s): `docs/adr/ADR-0001…0009` — all **Proposed**. ADR-0004 (custody) and ADR-0005 (gas) carry the open team decisions; treat their invariants as binding, their open questions as out of scope.
Spec(s): `docs/SPEC-tier1-operate-and-earn.md`.
Plan/state: `planning/ROADMAP.md`; vault `planning/STATE.md`.
Previous review/checkpoint: Hermes review pass (near-ready; the `antd` external-signer source-accuracy fix is applied — commit `f843545`).

## Scope

- Author: `SKILL.md` (lean, routing-first, Tier-1 scoped, frontmatter, onward pointers); the `metadata.openclaw.install` manifest (install the existing `ant`; verify signatures/checksums; documented clean uninstall); `references/node-operation.md`; `references/wallet-and-ant.md` (receive side only); `references/operating-procedures.md`; `references/troubleshooting.md`; `templates/node-preflight-checklist`, `templates/node-health-report`, `templates/human-authority-request`.
- Resolve the spec's four open questions against source and record the answers + source bindings: (1) balance check **without a key**; (2) daemon vs node-services relationship; (3) minimal live-node invocation; (4) resource-preflight thresholds (grounded — storage auto-scales, no fixed per-node ceiling).
- Capture a source binding (repo/file/symbol/commit) for every command, flag, and constant (ADR-0006).
- Self-test by following the skill's own instructions on the live network; capture evidence. Commit atomically on a feature branch (`feat(tier1): …`).

## Out of scope

Custody wrappers; key generation/storage/signing; spending or withdrawing ANT; gas/paymaster; ANT acquisition; user-facing data upload/retrieve as a goal (a public download may be used only as an install smoke-test); any Tier-2/3 content beyond onward pointers; marking any ADR Accepted; editing ADRs; transferring the repo to WithAutonomi; publishing to any channel; raising a PR to any upstream/shared repo.

## Constraints / forbidden actions

- **Never** generate, request, store, log, echo, or pass a private key, seed phrase, `SECRET_KEY`, or `AUTONOMI_WALLET_KEY`. The node is configured with a **public `--rewards-address` only**.
- **No invented commands, flags, or figures.** Everything is source-bound; if a needed fact isn't in upstream source, **stop and flag** — do not guess.
- **Do not edit the ADRs** (Proposed, human-gated). If the build reveals a conflict with an ADR, **stop and flag to Jim** (ADRs are superseded by humans, never silently edited).
- Detect-first, install-only-when-missing; do not mutate an existing working `ant` / `ant-node` setup beyond the slice's remit (ADR-0009).
- Do not claim agent-owned custody or spending is available or complete (ADR-0004/0005 Proposed).
- Feature branch only; atomic commits. **PR creation, merge to `main`, transfer to WithAutonomi, or any publish = Jim-approval gates — do not perform them.**
- Diff against the repo must touch only intended skill paths (`SKILL.md`, `references/`, `templates/`, the manifest, source-binding notes); no upstream-repo changes.

## Verification required

- `python3 scripts/adr-governance.py` passes (unchanged — 9 ADRs).
- Implementer self-test on the **live network**, following only the skill's own text: install/detect `ant`; `ant node add --rewards-address <public>`; `ant node start`; `ant node status` shows a running node; reward-balance check succeeds **without a private key**; `ant node stop`; clean `ant node reset`/uninstall. Capture the command transcript and outputs as evidence.
- No `SECRET_KEY` / `AUTONOMI_WALLET_KEY` set at any point in the Tier-1 journey (grep the transcript to confirm).

For PRs / merge candidates / substantial completed work:

- Clean-context test required? **Yes** — `gsd-clean-context-tester`, fresh agent, installed skill only, live network.
- Adversarial review required? **Yes** — `gsd-adversarial-reviewer` tries to disprove readiness (a step needing a key, an invented command/flag, a missing fallback, an unsafe default, a custody/spend over-claim).
- Jim PR-raise approval required? **Yes** — explicit approval before any PR/merge/transfer/publish.
- Reviewer independence requirement: the clean-context tester and adversarial reviewer must be **fresh agents that did not author the skill**.
- Validation evidence to inspect: the cold-read transcript (install → run → monitor → balance-check → teardown, no key handled); the adversarial findings list; the source-binding notes resolving the four open questions; the path-scoped diff.

## Stop conditions

Stop and report if:

- A required Tier-1 step would need a private key / `SECRET_KEY` (the scope or a command is wrong).
- A command, flag, or constant cannot be confirmed in upstream source (do not invent).
- The balance-check-without-a-key path has no clean, source-backed answer.
- The build surfaces a conflict with a Proposed ADR (especially 0004/0005) — flag to Jim; do not edit the ADR.
- The work pulls toward custody/gas/spend (Tier 2/3) — out of scope.
- About to raise a PR, merge, transfer to WithAutonomi, or publish — Jim gate.

## Required output

Return:

- role performed;
- sources read;
- output/changes (files authored, branch name, commits);
- verification evidence (the live-network self-test transcript; governance result; no-key confirmation);
- resolved open questions with source citations and the recorded source bindings;
- clean-context findings, if applicable;
- adversarial findings, if applicable;
- blockers/risks;
- recommended next checkpoint.

---

## Operating model from here (for the orchestrator)

This is the last hand-crafted packet. From now on, the **GSD orchestrator + @pm own roadmapping, planning, sequencing, and packet generation** for this project; Jim and the Cowork orchestration stay at the review / steer / amend (product + architecture) level. After this slice: run the gauntlet, write a `gsd-checkpoint`, and have @pm sequence the next slice (Tier 2/3 remain gated on the custody and gas team decisions — do not start them until those land). Surface to Jim at each checkpoint and at every approval gate above.
