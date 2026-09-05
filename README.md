# Autonomi Skills

First-party [Agent Skills](https://agentskills.io) for the **Autonomi** network — installable, self-contained instructions that let an AI agent read from, store on, build on and run the network from its own tools.

## Skills in this repo

| Skill | What it does | Status |
| --- | --- | --- |
| **`autonomi`** | Read data by content address; store files publicly or privately and get a permanent address back; run nodes that contribute spare disk and earn ANT; wire the network into an application. One skill, routed by task. The agent never sees a wallet key. | **Prototype 0.1.4** — being tested with the community |

## Install

The skill follows the [Agent Skills](https://agentskills.io) format, so it isn't tied to one tool. Pick whichever route your agent uses.

### skills.sh — any agent

```bash
npx skills add WithAutonomi/skills
```

Useful flags: `-a claude`, `-a codex`, `-a opencode` or `-a '*'` to choose the agent; `-g` to install globally; `-y` to skip prompts. Update later with `npx skills update autonomi`.

### Claude Code plugin

```
/plugin marketplace add WithAutonomi/skills
/plugin install autonomi@withautonomi
```

Custom Claude Code marketplaces do not auto-update by default. Enable auto-update for `withautonomi` in `/plugin` → **Marketplaces**, or update explicitly with:

```
/plugin update autonomi@withautonomi
```

### By hand

Copy `skills/autonomi/` — `SKILL.md`, `VERSION` and `references/` — into wherever your agent loads skills from (for Claude Code, `~/.claude/skills/autonomi/`). Keep the folder together: the references are loaded on demand. Copies installed by hand do not update automatically; repeat the installation to replace them with a newer release.

After an update, start a new agent session before relying on the new instructions. In Claude Code, `/reload-plugins` can activate an updated plugin without restarting when the client says a reload is available.

### What gets installed, and what happens on first use

The skill bundle only: `skills/autonomi/`. On first use the agent detects or installs the upstream **`ant`** command-line client from its official GitHub releases — fetching and reading the installer before running it, or taking a checksum-verified manual path — and learns the tool from `ant --help`. Nothing in the skill holds keys or moves funds. A paid write uses a `SECRET_KEY` the person provisions to the tool's environment themselves, or the person runs the paid command; the agent only ever works with public addresses, and spending is quote-show-wait by default.

> **Sandboxes.** Installing `ant` needs `github.com` and its release hosts reachable. The installer's version lookup uses `api.github.com`, which some agent sandboxes block while allowing the download itself; the skill then falls back to a manual path that reads the version from the release checksum file. The network is peer-to-peer over UDP, so a proxy-only sandbox can install the tool but will see `found 0 peers` — the skill says so rather than retrying. Distributing the CLI through npm, which every sandbox allows, is tracked in [ant-client #190](https://github.com/WithAutonomi/ant-client/issues/190).

## Status

A prototype, deliberately: one skill for readers, writers, builders and node operators, to find out whether they can share a skill without any of them feeling the others' weight. What it has to prove, how it's tested and the evidence so far are in [`planning/TESTING.md`](planning/TESTING.md); where every shipped claim comes from is in [`source-bindings/autonomi.md`](source-bindings/autonomi.md); current state and open threads are in [`planning/HANDOFF.md`](planning/HANDOFF.md). The design record and ADRs under `docs/` were written for the earlier node-operator-only skill; [`docs/DESIGN.md`](docs/DESIGN.md) opens with a note on how they relate to what ships now.

## Repo layout

```
skills/autonomi/        # the installable skill — the ONLY thing that ships
  SKILL.md              # entry: what Autonomi is, ground rules, task router, keys & money, verified-against, further reading
  VERSION               # release version, kept in sync with skill and plugin metadata
  references/           # on demand: install-and-verify, wallet-and-tokens, run-nodes, build-on-autonomi

.claude-plugin/         # Claude Code marketplace + plugin manifests (repo root is the plugin root)
docs/                   # repo-side, never ships: design, ADRs, archive of the retired operator skill
planning/               # current state, test protocol, briefs, parked threads
source-bindings/        # provenance for every shipped claim
scripts/                # ADR governance check (runs in CI)
```

Only `skills/<name>/` is discovered and installed; everything else is for maintainers.

## Contributing

Branch + PR, never direct to `main`; architecture, protocol and security decisions go through an ADR in `docs/adr/`. See [`CONTRIBUTING.md`](CONTRIBUTING.md). Security reports: [`.github/SECURITY.md`](.github/SECURITY.md).

## Licence

MIT or Apache-2.0, at your option — see [`LICENSE-MIT`](LICENSE-MIT) and [`LICENSE-APACHE`](LICENSE-APACHE).

---

Built by the Autonomi team (MaidSafe). Autonomi: <https://autonomi.com> · documentation: <https://docs.autonomi.com> · for developers: <https://developers.autonomi.com>
