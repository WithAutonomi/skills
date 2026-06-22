# GSD Checkpoint — Autonomi Operator Skill (current state)

Date: 2026-06-22
Project: Autonomi Operator Skill (`JimCollinson/autonomi-skill`)
Slice/question: Design phase (engine, personas, grounding) complete and merged to `main`; Tier-1 operate-and-earn skill authored and merged. Next: the build round (apply the design to the skill content) + the Tier-1 verification gauntlet.
Prepared by: Cowork (Claude) orchestration, on Jim's behalf
Agents/tools used: Cowork (Claude); deep source-research subagents against `WithAutonomi/*` and `saorsa-labs/*`; GitHub; Autonomi canonical docs (`autonomi.com/llms.txt`).

> **Read this first if you are the incoming agent.** Fetch the real `main` (tip below) before doing anything — design and docs were updated via reviewed PRs, so a stale local clone may be missing files. Follow the coordination protocol in `CONTRIBUTING.md` (lanes; branch + PR, never commit to `main` directly; fetch/rebase before a session and after each merge). Reading order: `README.md` → `docs/VISION.md` → `docs/DESIGN.md` (esp. §13) → `docs/adr/` → `docs/operating-doctrine.md` → `docs/skill-grounding.md` → `SKILL.md` + `references/` + `source-bindings/tier1-operate-and-earn.md` → `planning/ROADMAP.md`.

## Status

**Continue.** The design phase is complete and fully in `main`; the Tier-1 skill is authored and merged. The next work is (a) verifying the merged Tier-1 via the gauntlet and (b) the build round that applies the design (doctrine, personas, grounding) to the skill content. ADRs remain **Proposed** (acceptance is a human gate). Tier 2/3 stay gated on two open team decisions.

## What happened

(since the 2026-06-18 checkpoint)

- **Tier-1 operate-and-earn skill authored and merged** (PR #1): `SKILL.md` (frontmatter + `metadata.openclaw.install`), `references/` (node-operation, wallet-and-ant, operating-procedures, troubleshooting), `templates/`, and a thorough `source-bindings/tier1-operate-and-earn.md` resolving the spec's four open questions with file/line evidence and a live author self-test (ant 0.1.5 / ant-node 0.13.0; key-free balance read on Arbitrum One).
- **Deep source research (5 strands)** against upstream code, grounding the operating model. Key findings: earnings come from storing *paid* PUTs (median-of-7 paid 3×; pricing quadratic in records stored); per-node storage auto-scales to disk (no fixed ceiling) but per-node *value* is gated by keyspace share + 3-day pruning, so **many right-sized nodes** beat one big one; **IP/subnet diversity is enforced in production** (~2/IP, ~5 per /24-/48); **close group = 7** (Kademlia K = 20); node health is known in-process but the CLI/daemon expose only process state, so **health is query-based, not logs** (ADR-0011); per-node disk cap only via a direct `--config` TOML.
- **ADR-0011 added** (PR #3, Proposed): health observability is query-based, not log-based; logs off by default; v1 works within current CLI + OS host metrics + on-chain earnings; richer health deferred to upstream CLI commands.
- **DESIGN §13 expanded** (PR #4): the three operator personas as a **concentric** model — fully-autonomous = the engine; **human-proxy** and **steered** inherit it — on a Surfaces/Asks/Controls/Register frame, with worked examples; persona 3 renamed **Steered operation**; fully-autonomous reframed to "no human in the *operational* loop" (distal delegator, async escalation).
- **Operating doctrine + grounding landed** (PR #5): `docs/operating-doctrine.md` (the engine: network-health-first objective, good-citizen SOP, budgets→count→monitor→adjust resource strategy with graduated down-levers, shared-host default with dedicated-is-declared, honest spend boundary, query-based observability, stop/escalate); `docs/skill-grounding.md` (the SKILL.md opener — "what Autonomi is / why run a node," aligned to `autonomi.com/llms.txt` — plus an About/references section).
- **Contributing process merged** (PR #2): `CONTRIBUTING.md`, `.github/pull_request_template.md`, `.github/SECURITY.md`, and a **coordination protocol** (lanes: design/ADRs vs skill files; branch+PR not direct-to-main; fetch/rebase before+after; review required for ADR/security/agent-authored changes).
- **Operating-model note:** Cowork holds the design/ADR lane; the implementer (OpenCode + a coding model) authors the skill files; the GSD @pm/orchestrator owns sequencing + packet generation. Cowork + Jim review and steer.

## Evidence

Files changed/artifacts produced (all on `main`):

- Design: `docs/DESIGN.md` (incl. expanded §13), `docs/adr/ADR-0001…0011`, `docs/operating-doctrine.md`, `docs/skill-grounding.md`, `docs/VISION.md`, `docs/FEATURES.md`, `docs/SOURCE-MAP.md`, `docs/SPEC-tier1-operate-and-earn.md`.
- Skill: `SKILL.md`, `references/*`, `templates/*`, `source-bindings/tier1-operate-and-earn.md`.
- Process: `CONTRIBUTING.md`, `.github/pull_request_template.md`, `.github/SECURITY.md`, `scripts/adr-governance.py`, `.github/workflows/`.
- Planning: `planning/ROADMAP.md`, `planning/packets/PACKET-tier1-operate-and-earn.md`.
- Merged PRs: #1 (Tier-1 skill), #2 (contributing), #3 (ADR-0011), #4 (DESIGN §13), #5 (doctrine + grounding). **Current `main` tip: `5178dee`** (plus this checkpoint).

Checks run:

- `scripts/adr-governance.py` ran green at **9 ADRs** (2026-06-18); ADR-0010 and ADR-0011 have since been added via PRs — **re-run to confirm at 11** (governance runs in CI on PRs; not independently re-run this session).
- Tier-1 source surface verified against ant-client / ant-node / evmlib at pinned commits (recorded in the source-binding manifest), incl. an author live self-test.

Results: design complete and merged; Tier-1 authored and source-bound. The independent verification gauntlet has **not** yet run (see below).

## Review findings

Clean-context test:

- Reviewer/tool: `gsd-clean-context-tester`
- Result: **Not run** — outstanding for the merged Tier-1 skill (a fresh agent, installed skill only, live network).
- Findings: —

Adversarial review:

- Reviewer/tool: David's Hermes ran two **documentation/ADR** passes earlier (resolved); the **code/skill** adversarial gauntlet by a fresh agent is **Not run**.
- Result: Docs review — Concerns, resolved. Skill adversarial — Not run.
- Findings: the earlier blocker (ADR-0004 antd overstatement) was fixed; the built skill has not been adversarially reviewed.

## Drift / scope concerns

- ADRs are **Proposed, not Accepted** — acceptance is a human gate (Jim decision-owner, after review). Never mark Accepted autonomously; supersede, don't edit.
- **Tier 2/3 are gated** on the custody (ADR-0004) and gas (ADR-0005) team decisions — do not start them; the build round stays in **ungated operate-and-earn**.
- `docs/SOURCE-MAP.md` has minor stale bits: it still calls the close-group size "5 and 7" (resolved to **7**) and says "evmlib not needed for Tier-1" (the key-free balance read does use evmlib as provenance). Tidy in a later pass.
- The full source-research synthesis is held in Cowork's working notes (not the repo); the repo carries the conclusions (doctrine, manifest, DESIGN).

## Open questions / decisions for Jim

- **Two team decisions** still parked: the agent-wallet **custody substrate** (ADR-0004) and the **gas strategy** (ADR-0005). See the vault `Open Decisions Brief.md`.
- **ADR acceptance** awaits review (Jim decision-owner; David + Hermes review).
- Light carry-forward: a team glance at the SKILL.md opener framing (now canonical-aligned to `autonomi.com/llms.txt`).

PR / upstream action gate:

- PR ready to raise? **N/A right now** — PRs #1–#5 are already merged on Jim's own repo. The next build round will produce **agent-authored PRs**, which (per CONTRIBUTING) need an approving review before merge.
- Jim confirmed PR may be opened? **N/A** — the live gates are **transfer to WithAutonomi** and **external publish**, neither pending.
- Draft PR title/description prepared: N/A.

## Recommended next step

Hand to the GSD @pm/orchestrator for two sequenced slices, **ungated operate-and-earn only**:

1. **Verify first — the Tier-1 gauntlet** on the merged skill: a fresh `gsd-clean-context-tester` (installed skill only, live network, no key handled) plus a fresh `gsd-adversarial-reviewer`. Capture evidence; fix or flag findings.
2. **Then the build round** — apply the design to the skill content: add the SKILL.md opener + About from `docs/skill-grounding.md`; weave the §13 personas/register through the routing; deepen `references/operating-procedures.md` and author `references/agent-autonomy-policy.md` from `docs/operating-doctrine.md`; source-bind any new claims in the manifest.

Do not start Tier 2/3 (custody/gas gated).

## Handoff note

Non-negotiables: **never generate, store, log, or pass a private key** (`SECRET_KEY`/`AUTONOMI_WALLET_KEY`) — nodes take a **public address only**; **no invented commands/figures** — everything source-bound (ADR-0006); **health from queries, not logs** (ADR-0011), logs off by default; **shared-host default**, dedicated only when declared; **removal/reset is health-only**, never an optimisation lever; **hands-off auto-upgrade**; don't edit Accepted ADRs (supersede); follow the `CONTRIBUTING.md` coordination protocol (lanes; branch+PR; fetch before/after); **PR-to-shared/upstream, transfer to WithAutonomi, and publish are Jim-approval gates.** The operating engine is `docs/operating-doctrine.md`; the personas are DESIGN §13; the opener/about source is `docs/skill-grounding.md`.
