# autonomi-skill

Source and formal project truth for the **Autonomi operator skill** — an auto-updating, agent-facing skill that teaches an AI agent to operate the Autonomi network: run and manage nodes, securely receive and custody the ANT they earn, and (routed onward) use that ANT to store data.

This repository holds the formal artifacts: ADRs, design, specs, and — once authored — the skill package itself. Loose thinking, research, and planning live in the paired Obsidian vault project `Projects/Autonomi Skill`.

## Status

Phase 01 — design & de-risk. The skill itself is not yet authored. See `docs/adr/` for the architectural decisions (Proposed, pending acceptance).

## Layout

- `docs/adr/` — Architecture Decision Records (team-standard governance; see `docs/adr/README.md`).
- `scripts/adr-governance.py` — ADR validation gate; CI workflow in `.github/workflows/`.
- _(forthcoming)_ `docs/DESIGN.md`, a source-binding manifest, and the skill package.

## Governance

This repo follows the Autonomi/Saorsa ADR standard. Before changing architecture, inspect `docs/adr/`; draft Proposed ADRs from `docs/adr/TEMPLATE.md`; never edit an Accepted ADR (supersede it); never mark an ADR Accepted autonomously. PR / publish against any shared or upstream repo is a maintainer-approval gate.

## Positioning

Modelled on the x0x skill (`saorsa-labs/x0x`) for structure and quality. Distinct from the Autonomi Developer skill (`WithAutonomi/autonomi-developer-docs`): that covers building *on* Autonomi; this covers *operating and using* it.
