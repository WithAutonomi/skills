# Autonomi Skills

First-party [Agent Skills](https://agentskills.io) for the **Autonomi** network — installable, self-contained instructions that teach an AI agent to operate Autonomi from its own tools.

This is the home for Autonomi's first-party skills. It holds one or more skills under `skills/`, each independently installable.

## Skills in this repo

| Skill | What it's for | Status |
| --- | --- | --- |
| **`autonomi`** | Run and manage Autonomi nodes, and earn ANT (the Autonomi Network Token) for the storage they provide. Non-custodial. | **Available** |
| `autonomi-developer` | Build applications *on* Autonomi (libraries, SDK). | Planned — currently at [`WithAutonomi/autonomi-developer-docs`](https://github.com/WithAutonomi/autonomi-developer-docs) |

## Install

The skill is standards-compliant ([agentskills.io](https://agentskills.io)), so it isn't tied to one channel.

### skills.sh (from GitHub)

```bash
# Install the autonomi skill (it's the only one here, so a bare add installs it)
npx skills add WithAutonomi/skills

# …or name it explicitly
npx skills add WithAutonomi/skills --skill autonomi
```

Useful flags: `--skill <name>` (pick a specific skill), `--all` (install all), `-a <agent>` (target agent, e.g. `opencode`, `claude`, or `*` for all), `-g` (install globally), `-l` (list without installing), `-y` (no prompts). When the repo holds more than one skill, a bare `add` opens an interactive picker keyed on each skill's name + description.

### ClawHub / OpenClaw

```bash
openclaw skills install autonomi
```

The skill carries an OpenClaw install manifest in its frontmatter (`metadata.openclaw`) describing how to fetch and verify the upstream `ant` binary.

### What gets installed

The **skill bundle** — `skills/autonomi/SKILL.md` plus its bundled `references/`. The skill is agent-facing instructions; on first use it guides the agent to install the upstream **`ant`** CLI (the Autonomi tool) itself, non-custodially. Nothing here holds keys or moves funds.

> **Heads-up — binary install in locked-down sandboxes.** The `ant` installer downloads its binary from GitHub's release CDN (`release-assets.githubusercontent.com`), which some AI-agent sandboxes block even when `github.com` is allowed. The skill detects this and tells you exactly what to allowlist rather than failing silently. Tracked as an upstream/release item in [`planning/release-endpoint-accessibility.md`](planning/release-endpoint-accessibility.md).

## Repo layout

```
skills/<name>/          # the installable skill bundle(s) — the ONLY thing that ships
  autonomi/
    SKILL.md            # entry point: what Autonomi is, key terms, safety, get-started, CLI ref, config
    references/         # on-demand depth: provisioning, operating, uninstall, wallet, troubleshooting

docs/                   # repo-side, never ships
  adr/                  # architecture decision records
planning/               # briefs, handoff, open threads
source-bindings/        # provenance for commands/sourced figures; drives release regeneration
scripts/                # maintenance / freshness automation
```

Only `skills/<name>/` is discovered and installed; everything else is for maintainers.

## Contributing

Branch + PR (never direct-to-main); architecture/protocol/security decisions go through an ADR in `docs/adr/`. See [`CONTRIBUTING.md`](CONTRIBUTING.md), and [`planning/HANDOFF.md`](planning/HANDOFF.md) for current state, open decisions, and how to test.

## Status & roadmap

This repo is the org's first-party skills home at `WithAutonomi/skills` (private for now; it'll go public when it's ready to distribute). Current state, the rebuild brief, and the review entry point are in [`planning/`](planning/).

---

Built by the Autonomi team (MaidSafe). Autonomi: <https://autonomi.com>
