# autonomi-skill

Source and formal project truth for the **Autonomi operator skill** — an auto-updating, agent-facing skill that teaches an AI agent to operate the Autonomi network: run and manage nodes, receive rewards to a non-custodial public address, and route onward to wallet and data guidance for securing or spending the ANT they earn.

This repository holds the formal artifacts: ADRs, design, the roadmap, and — once authored — the skill package itself. Loose thinking, research, and planning notes live in the paired Obsidian vault project `Projects/Autonomi Skill`.

## Status

**Phase 01 — design & de-risk, substantially complete.** The design and the nine load-bearing decisions are drafted; the skill itself is not yet authored. The ADRs are **Proposed**, pending acceptance (Jim as decision owner, after David's review). Two decisions are deliberately left open for a team call — see **Open team decisions** in the roadmap:

- **Agent wallet custody substrate** — where key generation, storage, recovery, and signing live (ADR-0004).
- **Gas strategy** — how an agent holding only ANT pays the Arbitrum gas needed to spend it (ADR-0005).

## Start here (reading order)

1. `docs/DESIGN.md` — what we're building and how it works, realigned to the ADRs.
2. `docs/adr/` — the architectural decisions and their rationale (start at `docs/adr/README.md`; ADR-0001…0009).
3. `planning/ROADMAP.md` — build phases, the delivery scope ladder (capability tiers), and the **Open team decisions** that gate later tiers.

## Layout

- `docs/DESIGN.md` — the design, realigned to the ADRs. _(Forthcoming: a source-binding manifest and the skill package.)_
- `docs/adr/` — Architecture Decision Records (team-standard governance; see `docs/adr/README.md`).
- `planning/ROADMAP.md` — phases, capability ladder, and open team decisions (the vault holds only a pointer).
- `scripts/adr-governance.py` — ADR validation gate; CI workflow in `.github/workflows/`.

## Governance

This repo follows the Autonomi/Saorsa ADR standard. Before changing architecture, inspect `docs/adr/`; draft Proposed ADRs from `docs/adr/TEMPLATE.md`; never edit an Accepted ADR (supersede it); never mark an ADR Accepted autonomously. PR / publish against any shared or upstream repo is a maintainer-approval gate.

## Positioning

Draws on the x0x skill (`saorsa-labs/x0x`) as a **structural precedent and quality bar — not a dependency** (ADR-0008). Distinct from the Autonomi Developer skill (`WithAutonomi/autonomi-developer-docs`): that covers building *on* Autonomi; this covers *operating and using* it.
