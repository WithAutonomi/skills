# Autonomi skill — review & asks (for Hermes)

> **From:** Jim · **Date:** 2026-06-25 · **Heads-up:** Jim is off-grid **2026-06-26 → ~2026-07-10** (no connectivity). This is the state of the `autonomi` skill and the asks before he goes. Full detail in [`planning/HANDOFF.md`](HANDOFF.md) — start there.

## What it is

The `autonomi` skill: teaches an AI agent to run Autonomi nodes and earn ANT for the storage they provide — **non-custodial** (nodes only ever get a public rewards address). Rebuilt to the x0x quality bar, every command and figure **source-bound** to upstream code. Repo: `JimCollinson/skills` (proposed home: `WithAutonomi/skills`).

## Where it's at

- **Skill** (`skills/autonomi/`): rebuilt, source-bound, cleaned of the old root layout, installable. An agent has tested it end-to-end to the preflight gate (install / detect / command-&-flag validation / address check all pass; it stops safely when it should and invents nothing). Complete teardown. Deliberate "decide what to contribute, where, and how many" capacity model.
- **Being merged to `main` now**, so `npx skills add` works without a branch path.
- **Planning**: `HANDOFF.md` (the map), `TESTING.md` (repeatable agent test + evidence), `NEXT-PHASE.md` (parked threads), `node-resource-spec-brief.md` (for the dev team), `REBUILD-BRIEF.md` (full rationale), `release-endpoint-accessibility.md` (an upstream flag).
- **ADRs**: three decision ADRs — **0007** (repository), **0008** (distribution), **0012** (naming) — Proposed, on a review branch; plus the existing Proposed ADRs in `docs/adr/`.

## Moving parts (branches → PRs)

| Branch | What | Status |
| --- | --- | --- |
| `rebuild-skill` | the skill + planning + README | **merging to `main` now** |
| `docs/rebuild-brief` | rationale brief + release-endpoint flag | **merging to `main` now** |
| `docs/skills-repo-naming-distribution` | the 3 decision ADRs (0007/0008/0012) | **open for your review** (left Proposed) |

## Ask before end of day (time-sensitive)

1. **Confirm the repo name/home today.** We want to move to **`WithAutonomi/skills`** so the team owns it and work can continue while Jim's away. If you're good with the name and home (ADR-0007 / 0012), say so **today** and Jim will transfer before he leaves. (It's renamable later if needed — we just don't want to block on it.)

## Asks for while Jim's away

2. **Review** the skill, the overall approach, and the three decision ADRs — comment freely, but **leave them Proposed**; Jim marks them Accepted on his return.
3. **Gatekeeper role:** you and David self-approve skill/doc changes within the bounds in `HANDOFF.md`; hold the org transfer, architecture, protocol, and security calls for Jim. **David is the point of contact.**
4. **Eyes on two hand-offs:**
   - the **release-endpoint flag** — `ant`'s binary serves from a GitHub CDN many agent sandboxes block; needs an upstream `ant-client` fix (hosting + fallbacks). Raise with the wider team.
   - the **node-resource brief** — the dev team needs to author a single authoritative *Recommended Node Resource Document* (hard values + SOP principles) that the skill source-binds to. The brief spells out exactly what's needed.

## Start here

`README.md` → `planning/HANDOFF.md` → `skills/autonomi/SKILL.md` → its `references/` → `planning/REBUILD-BRIEF.md` → `docs/adr/`. To test: `planning/TESTING.md`.
