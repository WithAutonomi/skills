# Contributing to Autonomi Skills

The **`autonomi` skill** — one task-routed skill that lets an agent read from, store on, build on and run the Autonomi network — and its project truth (vision, design, ADRs, test protocol, provenance) live here. This is a docs-and-skill repo, not a code-heavy one: contributions are mostly Markdown (the skill, its references, the repo-side record) plus the ADR trail. The bar is **clarity, accuracy, and safety**, not build machinery.

Contributors are humans and AI agents alike; these conventions keep the trail readable for both.

## Ground rules

- **Never commit a secret.** No private key, seed phrase, `SECRET_KEY`, or `AUTONOMI_WALLET_KEY` value in code, examples, or logs. The skill's own rule binds contributors too: the agent never sees a key; nodes take a **public** address only; a paid write uses a `SECRET_KEY` the person provisions outside the conversation, or the person runs the command. See [`.github/SECURITY.md`](.github/SECURITY.md).
- **Bind every Autonomi claim to provenance.** Autonomi-specific commands, flags, constants, URLs, figures, and install behaviour must trace to [`source-bindings/autonomi.md`](source-bindings/autonomi.md), normally pinned upstream source. Temporary team-confirmed exceptions are explicit and pending upstream authority. Ordinary operating-system and shell behaviour is not an Autonomi claim, but platform-specific behaviour must still be checked rather than guessed (ADR-0006).
- **Bump the version with the skill.** Any change to a shipped file (`skills/autonomi/SKILL.md`, `VERSION`, `references/`) bumps `skills/autonomi/VERSION`, the frontmatter's `metadata.version`, and both Claude plugin versions together. Install channels use their own version or source records to deliver updates.
- **Decisions go through ADRs.** Architectural, protocol, security, storage, or custody changes add or update a **Proposed** ADR before merge; Accepted ADRs are immutable (supersede, don't edit). See [`docs/adr/README.md`](docs/adr/README.md). The prototype deliberately runs ahead of ADR-0002/0003/0004/0005 and the uninstall target in ADR-0008; see the note at the top of [`docs/DESIGN.md`](docs/DESIGN.md). Revise those Proposed records from prototype evidence rather than claiming the divergence is already resolved.

## Branch & PR flow

- Project policy treats `main` as protected and stable: do all work on a short-lived branch off `main`. GitHub's configured ruleset is not technically enforced while this private repository is on the organisation's free plan; see `planning/HANDOFF.md` for the current enforcement state.
- Branch names: `feat/…`, `fix/…`, `docs/…`, `chore/…` (or `name/topic` for personal / WIP branches). If a branch needs to be **test-installed** before merge, give it a slash-free name — skills.sh can't parse a slashed-branch tree URL.
- Commits follow [Conventional Commits](https://www.conventionalcommits.org): `feat`, `fix`, `docs`, `chore`, `refactor`, `test` — e.g. `feat(autonomi): add the datamap read-back check`.
- Open a PR into `main` using the [pull request template](.github/pull_request_template.md). Fill in what's relevant; delete what isn't.
- Merge needs green CI and a completed PR. An approving review is required for ADR, architecture, or security/custody changes and for agent-authored PRs — and welcome on anything else.

## Working in parallel (humans + agents)

Humans and agents often work this repo at the same time; these rules keep us from diverging.

- **Lanes — one writer per area.** Design and decisions (`docs/`, `docs/adr/`, `planning/`) are one lane; the skill itself (`skills/autonomi/` and `source-bindings/`) is another. A file has a single owner at a time — don't edit the same file from two places at once. Design lands as an ADR or spec; the implementer turns it into skill content.
- **Never commit to `main` directly** — including via the GitHub API. Everything goes through a short-lived branch and a PR. (Direct API pushes to `main` are what caused an earlier divergence.)
- **Fetch before you work, and after every merge.** `git fetch` and rebase onto the latest `main` before starting a session and whenever a PR lands, so nobody builds on a stale base.
- **Keep branches small and merge them promptly.** Long-lived branches drift; short ones reconcile cleanly.
- **Announce pushes.** When you push a branch or open a PR, say so, so others know to fetch.
- **One person merges** to `main` at a time, deliberately — no racing merges.

## Checks before you open a PR

- Run the ADR governance gate: `python3 scripts/adr-governance.py`.
- For any change to the shipped skill, the static checks in [`planning/TESTING.md`](planning/TESTING.md) §3: spec validation, vocabulary lint, fact check against the provenance file, length, version bump.
- For merge-candidate skill changes, the **gauntlet**: a clean-context agent run of the relevant scenario from `planning/TESTING.md` §2 on a real host (not a proxy-only sandbox), plus an independent adversarial review by an agent that did not author the change.

## Provenance

- Note in the PR when work was authored or co-authored by an agent, and which tool/model — so the trail is clear for the next human or agent.

Thanks for contributing.
