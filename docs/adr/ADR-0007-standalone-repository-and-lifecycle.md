# ADR-0007: Dedicated first-party skills repository and release lifecycle

- **Status:** Proposed
- **Date:** 2026-06-17
- **Decision owners:** Jim Collinson
- **Reviewers:** David Irvine, Hermes
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0002 (single holistic skill), ADR-0008 (structure & distribution), ADR-0006 (source-binding), ADR-0009 (independent lifecycle); the Autonomi Developer skill (`WithAutonomi/autonomi-developer-docs`)

## Context

This skill is a **synthesis**. To teach an agent to use Autonomi as an operator it draws on and reconciles **multiple upstream repositories** — operating a node (`ant-node`); the CLI + node-management daemon (`ant-client`); ANT and what it is for (`evmlib`, token docs); data and the network beneath it (`self_encryption`), plus node and developer documentation. No single upstream repo encapsulates this agent-as-user view, so the skill has no natural home inside any one of them; embedding it in a code or docs repo would misrepresent its cross-cutting scope and couple it to that repo's lifecycle.

Autonomi also already has **more than one** first-party skill: the operator skill (`autonomi`) and a developer skill (build *on* Autonomi). They need a single, predictable, discoverable home rather than being scattered across the org's repos — today the developer skill sits inside a docs repo (`autonomi-developer-docs`), itself an awkward home for skill/action content. And skills install via tools such as `skills.sh`, whose interactive selection lists a repo's skills by **name + description** for the user to choose — so a dedicated skills repo with a README that lists what is available gives one clean install surface and a clear menu.

## Decision Drivers

- The skill synthesises across multiple upstream repos — no single repo is its natural home.
- More than one first-party skill exists; they want one predictable, discoverable home, not scattering across org repos.
- Installation ergonomics: one clean install surface; selection is description-driven; a README menu of available skills.
- A single *primary* skill for the everyday journey (use nodes to earn + store data) — users/agents should not install several skills for basic use — while leaving room for distinct, niche skills (e.g. developer) chosen by need.
- Independent lifecycle and release cadence, decoupled from any docs site or code repo (ADR-0009).
- Each skill self-contained; only the skill bundle ships, internal provenance/process stays repo-side.
- Cross-repository ADR/governance consistency with the Autonomi/Saorsa portfolio.

## Considered Options

1. **Sub-stream of the Autonomi 2.0 documentation work.** Rejected: different mandate and lifecycle.
2. **Inside one upstream code repo (`ant-node`/`ant-client`).** Rejected: the skill spans several repos; embedding in one misrepresents scope and couples lifecycles.
3. **Co-located in / installed from a docs repo** (as the developer skill currently is). Rejected: docs repos hold knowledge collections, not skill/action content; a docs URL is an odd install home and couples cadences.
4. **A standalone repository for a single skill.** Rejected: more than one first-party skill already exists; a single-skill repo does not accommodate siblings or give users one menu.
5. **A dedicated first-party skills repository holding one or more skills (`skills/<name>/`).** Chosen.

## Decision

First-party Autonomi skills live in a **dedicated skills repository** — **`WithAutonomi/skills`** — with its own ADRs, specs, and release lifecycle. Each skill is self-contained under **`skills/<name>/`** (`SKILL.md` + `VERSION` + bundled `references/`). The **`autonomi`** skill (operate nodes + use the network: upload/manage data) is the primary skill and the everyday journey; **sibling skills** (the developer skill, today in `autonomi-developer-docs`) consolidate in over time. The repo **README lists the available skills** with descriptions, mirroring what install tools show when choosing. `docs.autonomi.com/node` is a pointer to the skill, not its source. The repo starts under a personal account on an interim basis and is org-owned before any public or official use.

Invariants:

- A dedicated first-party skills repo; **not** embedded in, nor installed from, any single upstream code or docs repo.
- One skill per `skills/<name>/`; a **single primary skill** for everyday use, with room for distinct niche skills by choice.
- Only the **skill component** enters agent context (`SKILL.md` + bundled `references/`; `VERSION` remains adjacent release metadata). A channel package may also contain manifests or repo-side files, but `docs/`, `docs/adr/`, `planning/` and `source-bindings/` are never loaded as skill instructions.
- The README lists available skills + descriptions.
- Own ADRs/specs, own release lifecycle and automation (ADR-0006/0009).
- PR / merge / publish / **repo transfer** against any shared or upstream repo is a maintainer-approval gate.

Open (not decided here): re-homing the developer skill into this repo is a scheduled migration (its own automation + docs-pull; draft/beta; Jim-owned) — direction set here, logistics owned by the roadmap. Transfer of the repo to `WithAutonomi` is a gated step.

## Consequences

### Positive
- One canonical, discoverable home for first-party skills; one clean install surface; a clear README menu.
- Description-driven selection works well; the everyday user installs one primary skill.
- Room for niche skills without scattering across the org; independent lifecycle.

### Negative / Trade-offs
- Migrating the developer skill in is a non-trivial project (its own automation + docs-pull).
- A repo to maintain; the move to `WithAutonomi` remains a gated step.

### Neutral / Operational
- Adopts portfolio ADR governance (ADR-0001). The concrete install mechanics + quality bar are ADR-0008's job.

## Validation

The repository carries its own ADRs/specs/release artifacts, references multiple upstream repos without belonging to any, and the skill installs from it without depending on a docs or single-code repo. The README lists the available skills. Open items (org transfer, developer-skill migration) are resolved with the maintainer before publish.

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR.
