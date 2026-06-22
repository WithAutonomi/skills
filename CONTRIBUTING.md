# Contributing to autonomi-skill

The **Autonomi operator skill** and its formal project truth — vision, design, ADRs, roadmap, and the skill itself — live here. This is a docs-and-skill repo, not a code-heavy one: contributions are mostly Markdown (the skill, references, templates) plus the ADR record. The bar is **clarity, accuracy, and safety**, not build machinery.

Contributors are humans and AI agents alike; these conventions keep the trail readable for both.

## Ground rules

- **Never commit a secret.** No private key, seed phrase, `SECRET_KEY`, or `AUTONOMI_WALLET_KEY` in code, examples, or logs — nodes use a **public** wallet (rewards) address only (ADR-0004). See [`.github/SECURITY.md`](.github/SECURITY.md).
- **Source-bind every claim.** Commands, flags, constants, and figures are pinned to upstream source (repo / file / symbol / commit). Don't invent — if it isn't confirmable in source, flag it rather than guess (ADR-0006).
- **Decisions go through ADRs.** Architectural, protocol, security, or storage changes add or update a **Proposed** ADR before merge; Accepted ADRs are immutable (supersede, don't edit). See [`docs/adr/README.md`](docs/adr/README.md).

## Branch & PR flow

- `main` is protected and always stable. Do all work on a short-lived branch off `main`.
- Branch names: `feat/…`, `fix/…`, `docs/…`, `chore/…` (or `name/topic` for personal / WIP branches).
- Commits follow [Conventional Commits](https://www.conventionalcommits.org): `feat`, `fix`, `docs`, `chore`, `refactor`, `test` — e.g. `feat(tier1): add node preflight checklist`.
- Open a PR into `main` using the [pull request template](.github/pull_request_template.md). Fill in what's relevant; delete what isn't.
- Merge needs green CI and a completed PR. An approving review is required for ADR, architecture, or security/custody changes and for agent-authored PRs — and welcome on anything else.

## Working in parallel (humans + agents)

Humans and agents (e.g. OpenCode) often work this repo at the same time; these rules keep us from diverging.

- **Lanes — one writer per area.** Design and decisions (`docs/`, `docs/adr/`, `planning/`) are one lane; the skill itself (`SKILL.md`, `references/`, `templates/`, `source-bindings/`) is another. A file has a single owner at a time — don't edit the same file from two places at once. Design lands as an ADR or spec; the implementer turns it into skill content.
- **Never commit to `main` directly** — including via the GitHub API. Everything goes through a short-lived branch and a PR. (Direct API pushes to `main` are what caused an earlier divergence.)
- **Fetch before you work, and after every merge.** `git fetch` and rebase onto the latest `main` before starting a session and whenever a PR lands, so nobody builds on a stale base.
- **Keep branches small and merge them promptly.** Long-lived branches drift; short ones reconcile cleanly.
- **Announce pushes.** When you push a branch or open a PR, say so, so others know to fetch.
- **One person merges** to `main` at a time, deliberately — no racing merges.

## Checks before you open a PR

- Run the ADR governance gate: `python3 scripts/adr-governance.py`.
- For merge-candidate skill changes, run the **gauntlet**: a clean-context agent test on the live network, plus an independent adversarial review by an agent that did not author the change (see the Tier-1 packet for the pattern).

## Provenance

- Note in the PR when work was authored or co-authored by an agent, and which tool/model — so the trail is clear for the next human or agent.

Thanks for contributing.
