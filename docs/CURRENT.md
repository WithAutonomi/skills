# GSD Checkpoint — Autonomi Operator Skill (current state)

Date: 2026-06-18
Project: Autonomi Operator Skill (`JimCollinson/autonomi-skill`)
Slice/question: Phase 01 (design & de-risk) substantially complete; Tier-1 (operate-and-earn) authoring dispatched to OpenCode.
Prepared by: Cowork (Claude) orchestration, on Jim's behalf
Agents/tools used: Cowork (Claude); `gsd-plan` agent (roadmap refresh); GitHub; source verification against `WithAutonomi/*`.

> **Read this first if you are the incoming agent.** `git pull` to the real `main` (tip below) before doing anything — this repo has been updated via API pushes, so a stale local clone may be missing files. Reading order: `README.md` → `docs/SPEC-tier1-operate-and-earn.md` → `planning/packets/PACKET-tier1-operate-and-earn.md` → `docs/DESIGN.md` → `docs/adr/` → `planning/ROADMAP.md`.

## Status

**Continue.** Design is substantially complete and the Tier-1 build slice is specced, packetised, and ready to execute. ADRs are Proposed and under David's architecture review — that does **not** block Tier 1 (it deliberately avoids the open decisions).

## What happened

- Designed the skill as **one holistic, modular, progressively-disclosed operator skill** (use, not build), on the existing `ant` CLI + node daemon, x0x as structural precedent. Captured as 9 Proposed ADRs + `docs/DESIGN.md`.
- Two decisions deliberately parked for a **team call** and recorded as open: the **agent wallet custody substrate** (ADR-0004) and the **gas strategy** (ADR-0005). A decision-support brief is in the vault (`Open Decisions Brief.md`).
- David's Hermes reviewed twice (repo + ADRs): "near-ready." Its one blocker — ADR-0004 overstated `antd`'s spend/custody surface (it omitted the headless **external-signer** `prepare`/`finalize` mode) — was verified against source and **fixed** (commit `f843545`); the external-signer flow is recorded as an integration seam, not custody.
- De-versioned the docs (capability ladder is a concept in DESIGN; sequencing lives in ROADMAP, not the ADRs); added an "Open team decisions" section to ROADMAP; moved VISION/FEATURES into the repo; reconciled the vault stubs.
- Wrote the **Tier-1 SPEC** (`docs/SPEC-tier1-operate-and-earn.md`) and the **Tier-1 work packet** (`planning/packets/PACKET-tier1-operate-and-earn.md`).
- **Operating model shift:** from here the GSD orchestrator + @pm own roadmapping, planning, sequencing, and packet generation; Jim + Cowork stay at review/steer/amend.

## Evidence

Files changed/artifacts produced (all on `main`):

- Docs: `README.md`, `docs/VISION.md`, `docs/FEATURES.md`, `docs/DESIGN.md`, `docs/SPEC-tier1-operate-and-earn.md`, `docs/adr/ADR-0001…0009` (+ ADR `README`/`TEMPLATE`/`TOOLING`).
- Planning: `planning/ROADMAP.md` (build phases + capability ladder + Open team decisions), `planning/packets/PACKET-tier1-operate-and-earn.md`.
- Governance: `scripts/adr-governance.py`, `.adr-kit.yaml`, `.github/workflows/`.
- Vault: `Open Decisions Brief.md`; VISION/FEATURES/DESIGN/ROADMAP/DECISIONS are stubs pointing here.
- Key commits: `356058c` (VISION/FEATURES in repo), `f843545` (Hermes source-accuracy fix), `3743aeb` (Tier-1 SPEC), `7fe7245` (Tier-1 packet). **Current `main` tip: `7fe7245`** (plus this checkpoint).

Checks run:

- `python3 scripts/adr-governance.py` → **passed, 9 ADRs.**
- Source verification of the Tier-1 command surface: ant-client `ant-cli/src/cli.rs` + dev-docs `command-reference.md`/`use-the-cli.md` (verification header @ `84332e2d`, 2026-06-10); install via `install.sh`/`install.ps1`; `antd` external-signer in `antd/src/rest/upload.rs`; `ant-node` releases ship `SHA256SUMS` + ML-DSA-65 (FIPS-204).

Results: governance green; command surface grounded and source-bound; the one review blocker resolved.

## Review findings

Clean-context test:

- Reviewer/tool: gsd-clean-context-tester
- Result: **Not run** — Tier 1 is not built yet; this is the gauntlet defined in the packet.
- Findings: —

Adversarial review:

- Reviewer/tool: David's Hermes (documentation/ADR review, two passes) — note this was a **docs** review, not the code/skill adversarial gauntlet.
- Result: Concerns, **resolved** (the `antd` external-signer overstatement fixed in `f843545`).
- Findings: structure coherent; ADR-0004 distinctions correct; ladder treats custody/gas as gating team decisions; one source-accuracy blocker (now fixed); minor non-blocking suggestions applied.

## Drift / scope concerns

- ADRs are **Proposed, not Accepted** — acceptance is a human gate (Jim as decision owner, after David's review). Never mark Accepted autonomously; never edit an ADR (supersede via Jim).
- **Tier 2/3 are gated** on the custody (ADR-0004) and gas (ADR-0005) team decisions — do not start them.
- Local-clone-vs-remote: pushes were via API; pull `main` to avoid acting on a stale tree.

## Open questions / decisions for Jim

- The two team decisions (custody substrate, gas strategy) need the dedicated call — see the vault `Open Decisions Brief.md`.
- ADR acceptance awaits David's architecture review.

PR / upstream action gate:

- PR ready to raise? **No** — Tier 1 not built yet.
- Jim confirmed PR may be opened? **N/A.** (Work to date has been direct pushes to `main` on Jim's own repo; the gates are **transfer to WithAutonomi** and **external publish**, neither pending. PR/merge against any shared/upstream repo would need Jim's explicit approval.)
- Draft PR title/description prepared: N/A.

## Recommended next step

Execute `planning/packets/PACKET-tier1-operate-and-earn.md` as the **Implementer** slice (OpenCode, feature branch): author `SKILL.md` + the Tier-1 modules + templates + install manifest, resolve the spec's four open questions from source, self-test on the live network with a public reward address only. Then run the **gauntlet** (fresh-agent clean-context test on the live network + adversarial review), write a follow-up checkpoint, and surface to Jim at the PR/transfer/publish gates. Do not touch Tier 2/3.

## Handoff note

You are picking up a clean, source-grounded design with a ready Tier-1 build packet. The non-negotiables for Tier 1: **never generate, store, log, or pass a private key** (`SECRET_KEY`/`AUTONOMI_WALLET_KEY`) — the node takes a **public `--rewards-address` only**; **no invented commands** (everything source-bound, ADR-0006); don't edit ADRs; don't transfer/publish without Jim. The orchestrator/@pm now own planning and sequencing; Jim + Cowork review and steer.
