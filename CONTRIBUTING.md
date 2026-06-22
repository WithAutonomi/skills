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
- Merge needs at least one approving review and green CI. <!-- working default; the exact merge gate is the maintainers' call -->

## Checks before you open a PR

- Run the ADR governance gate: `python3 scripts/adr-governance.py`.
- For merge-candidate skill changes, run the **gauntlet**: a clean-context agent test on the live network, plus an independent adversarial review by an agent that did not author the change (see the Tier-1 packet for the pattern).

## Provenance

- Note in the PR when work was authored or co-authored by an agent, and which tool/model — so the trail is clear for the next human or agent.

Thanks for contributing.
