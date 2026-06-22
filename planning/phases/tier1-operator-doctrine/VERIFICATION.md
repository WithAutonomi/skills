# Verification — Tier 1 operator doctrine pass

Date: 2026-06-22
Verifier: GPT-5.5 verifier
Repo/worktree: `/Users/jimcollinson/code/autonomi-skill-doctrine`
Branch: `feat/tier1-operator-doctrine`
Base: `main` (`5178dee`)
Scope verified: final branch state after implementation commit `6e0250c`, including checkpoint, source-binding, and approved wallet-language cleanup.

## Status

**passed** — 6/6 approved goals verified.

This is goal-backward verification of the authoring/doctrine pass. I did **not** run the deferred clean-context live-network test or independent adversarial gauntlet; those remain separate PR/readiness gates.

## Evidence inspected

- `git status --short && git diff --name-status main` — branch diff vs `main` covers `SKILL.md`, `docs/CURRENT.md`, `references/agent-autonomy-policy.md`, `references/node-operation.md`, `references/operating-procedures.md`, `references/troubleshooting.md`, `references/wallet-and-ant.md`, `source-bindings/tier1-operate-and-earn.md`, `templates/node-health-report.md`, `templates/node-preflight-checklist.md`, and `planning/phases/tier1-operator-doctrine/VERIFICATION.md`.
- `git status --short --branch && git log --oneline --decorate -10 && git diff --stat main` — branch `feat/tier1-operator-doctrine`, implementation commit `6e0250c`, plus final cleanup state.
- `git diff --name-status HEAD && git diff --stat HEAD` — cleanup verified in `SKILL.md`, `docs/CURRENT.md`, Tier-1 references, templates, source bindings, and this verification artifact.
- `python3 scripts/adr-governance.py` — passed: 11 ADR files checked.
- `git diff --check` and `git diff --check HEAD` — passed with no output.
- `git diff --name-status main -- docs/adr scripts/adr-governance.py .github/workflows .adr-kit.yaml` — no output; ADRs/governance unchanged.
- Source docs: `docs/skill-grounding.md`, `docs/DESIGN.md` §13, `docs/operating-doctrine.md`, ADR-0004/0006/0009/0010/0011, `planning/ROADMAP.md`, and `planning/packets/PACKET-tier1-operate-and-earn.md`.
- Authored surfaces: `SKILL.md`, `references/agent-autonomy-policy.md`, `references/node-operation.md`, `references/operating-procedures.md`, `references/wallet-and-ant.md`, `references/troubleshooting.md`, templates, and `source-bindings/tier1-operate-and-earn.md`.

## Goal checks

### 1. Apply `docs/skill-grounding.md` to `SKILL.md` opener/About/references

**Verified.**

- `SKILL.md:41-45` now provides the grounded Autonomi opener: what Autonomi is, why running a node helps the network, ANT receive/observe framing, and the non-custodial public-wallet-address boundary.
- `SKILL.md:113-135` adds About/further-reading, canonical Autonomi references, upstream repositories synthesised, related-skill routing, and provenance/freshness.
- `source-bindings/tier1-operate-and-earn.md:117-129` binds product/opener claims to `autonomi.com` pages, `docs/skill-grounding.md`, and `docs/VISION.md`.

Artifact status: `SKILL.md` exists, is substantive, and is wired as the root skill entrypoint.

### 2. Weave `docs/DESIGN.md` §13 personas and ADR-0010 register through routing/copy

**Verified.**

- `SKILL.md:47-53` introduces the fully autonomous, human-proxy, and steered-operation persona model and the default plain-language/by-exception register.
- `SKILL.md:64` routes autonomous-operation questions to `references/agent-autonomy-policy.md`.
- `references/agent-autonomy-policy.md:32-40` expands persona layering and plain-language behaviour.
- `source-bindings/tier1-operate-and-earn.md:130-139` binds persona/plain-language claims to DESIGN §13, ADR-0010, operating doctrine, and ADR-0009.

Artifact status: `references/agent-autonomy-policy.md` exists, is substantive, and is wired from `SKILL.md` task routing.

### 3. Deepen operating procedures and add/wire agent-autonomy policy from operating doctrine

**Verified.**

- `references/operating-procedures.md:3-12` adds the network-health-first objective, no-invented-threshold rule, shared-host default, explicit dedicated-host declaration, and start-small posture.
- `references/operating-procedures.md:56-71` adds budgets → node count → monitor → adjust and graduated down-levers.
- `references/operating-procedures.md:92-109` implements query-based/reduced-mode observability.
- `references/operating-procedures.md:111-124` and `references/agent-autonomy-policy.md:57-71` add stop/escalate rules.
- `references/agent-autonomy-policy.md:3-17` and `42-55` set autonomy/resource/authority boundaries.
- `source-bindings/tier1-operate-and-earn.md:141-163` binds operating-doctrine, query-health, and autonomy-policy boundaries.

Artifact status: operating procedures and autonomy policy exist, are substantive, and are wired from `SKILL.md:63-64`.

### 4. Keep new command/flag/constant/figure/important factual claims source-bound per ADR-0006

**Verified.**

- `SKILL.md:17` declares `source-bindings/tier1-operate-and-earn.md` as the source-binding manifest; `SKILL.md:133-135` points readers there for every command, flag, volatile constant, and important factual claim.
- Product/doctrine bindings are recorded in `source-bindings/tier1-operate-and-earn.md:13-21` and `117-163`.
- Command/flag/daemon/API and constant bindings remain recorded in `source-bindings/tier1-operate-and-earn.md:38-115` and `165-231`.
- The runtime public wallet address previously present in source bindings is removed; `source-bindings/tier1-operate-and-earn.md:28` states runtime wallet addresses are operational data and must not be committed.
- Search for runtime-style `0x...` addresses found only the source-bound Autonomi token contract in `source-bindings`, `references/wallet-and-ant.md`, and `references/troubleshooting.md`.

Artifact status: source-binding manifest exists, is substantive, and is wired from SKILL metadata/provenance.

### 5. Preserve non-custodial Tier 1 boundaries from ADR-0004/0009/0011

**Verified.**

- `SKILL.md:43-45` states Tier 1 receive/observe only and says the node gets only a public wallet address via `--rewards-address`, never a private key.
- `SKILL.md:55`, `105-109`, `references/wallet-and-ant.md:26-31`, and `references/agent-autonomy-policy.md:18-30` prohibit private keys, custody, signing, spend/withdraw/bridge/approve/acquire/swap, gas, and upload/payment.
- `references/wallet-and-ant.md:39-66` uses a read-only ERC-20 `balanceOf` path and explicitly rejects `ant wallet address` / `ant wallet balance` because those require a spend-capable private-key path.
- `SKILL.md:109`, `references/node-operation.md:161`, `references/operating-procedures.md:92-109`, and `references/troubleshooting.md:60` preserve ADR-0011 query-based health: no log scraping, metrics scraping, or node-internal file reads for health.

Guardrail searches found no secret assignments or key-handling examples; mentions of `SECRET_KEY` / `AUTONOMI_WALLET_KEY` are prohibitions or escalation triggers.

### 6. Honor user wording constraint for human-facing wallet-address language

**Verified.**

- Current human-facing Tier-1 surfaces use “public wallet address where rewards will be paid” in the SKILL description/opener/routing/core concept/error guard (`SKILL.md:3`, `43`, `62`, `75`, `88`), node runbook (`references/node-operation.md:3`, `7`, `59`), wallet runbook (`references/wallet-and-ant.md:3`, `7`, `12`, `44`), operating procedures (`references/operating-procedures.md:17`, `100`), autonomy policy (`references/agent-autonomy-policy.md:16`), and templates (`templates/node-preflight-checklist.md:19`, `45`; `templates/node-health-report.md:6`).
- Cleanup specifically replaced earlier non-approved earnings wording with the approved phrase.
- `--rewards-address` remains as CLI/source detail in command snippets, safety bullets, and source bindings; it is not used as the human-facing label for the concept.

## Guardrails

- **No ADR/governance edits:** verified by path-scoped diff; ADR governance also passed.
- **No Tier 2/3 implementation:** content points onward but keeps custody, signing, spending, gas, acquisition, and upload/payment outside Tier 1.
- **No runtime public wallet address committed:** guardrail search found only the source-bound ANT token contract address.
- **No unsupported health path:** authored guidance explicitly rejects log, metrics, and node-internal-file health signals.
- **Deferred gauntlet not run:** clean-context live-network test and independent adversarial review remain required before treating Tier 1 as fully PR/merge ready.

## Gaps

None found for the six approved authoring/doctrine goals.

## Recommendation

Proceed to the deferred fresh-agent gates for PR/merge readiness: clean-context live-network test and independent adversarial review. Do not treat this verification as satisfying those deferred gates.
