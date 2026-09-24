# Autonomi Skills

First-party [Agent Skills](https://agentskills.io) for the **Autonomi** network — installable, self-contained instructions that let an AI agent read from, store on, build on and run the network from its own tools.

## Skills in this repo

| Skill | What it does | Status |
| --- | --- | --- |
| **`autonomi`** | Read data by content address; store files publicly or privately and get a permanent address back; run nodes that contribute spare disk and earn ANT; wire the network into an application. One skill, routed by task. The agent never sees a wallet key. | **Prototype 0.1.5** — being tested with the community |

## Install

The skill follows the [Agent Skills](https://agentskills.io) format, so it isn't tied to one tool. Pick whichever route your agent uses.

### skills.sh (from GitHub; repository access required while private)

```bash
npx skills add WithAutonomi/skills
```

Useful flags: `-a claude`, `-a codex`, `-a opencode` or `-a '*'` to choose the agent; `-g` to install globally; `-y` to skip prompts. Update later with `npx skills update autonomi`.

### Claude Code plugin

```text
/plugin marketplace add WithAutonomi/skills
/plugin install autonomi@withautonomi
```

Custom Claude Code marketplaces do not auto-update by default. Enable auto-update for `withautonomi` in `/plugin` → **Marketplaces**, or update explicitly with:

```
/plugin update autonomi@withautonomi
```

### ClawHub / OpenClaw

Future only. The earlier version-pinned installer metadata was removed because OpenClaw's current contract cannot express the release route without going stale. No working OpenClaw installer or public ClawHub listing is claimed.

### By hand

Copy `skills/autonomi/` — `SKILL.md`, `VERSION` and `references/` — into wherever your agent loads skills from (for Claude Code, `~/.claude/skills/autonomi/`). Keep the folder together: the references are loaded on demand. Copies installed by hand do not update automatically; repeat the installation to replace them with a newer release.

After an update, start a new agent session before relying on the new instructions. In Claude Code, `/reload-plugins` can activate an updated plugin without restarting when the client says a reload is available.

### What the agent loads, and what happens on first use

The agent loads only the skill component in `skills/autonomi/`. skills.sh and manual installations copy that directory; Claude Code caches the repository-root plugin package declared in `.claude-plugin/marketplace.json`, then discovers `skills/autonomi/` within it as the skill component. Repo-side files are not loaded as skill instructions.

On first use the agent detects the upstream **`ant`** command-line client and leaves a working installation alone. If it is missing, the preferred route is `npm install -g @withautonomi/ant` with existing Node.js 18+ and npm. Without those, direct Linux/macOS and Windows installers remain available, fetched and read before execution, plus a checksum-verified manual alternative. The agent learns the tool from `ant --help`. This installs the **CLI**, not the skill; the skill-install commands above remain unchanged. Full procedures are in [`install-and-verify.md`](skills/autonomi/references/install-and-verify.md).

The npm release workflow verifies archive checksums and signatures before packaging; this is not a local release-signature check during installation. The direct scripts do not yet verify checksums or signatures themselves, so universally verified delivery remains a target rather than a current guarantee. Nothing in the skill holds keys or moves funds. A paid write uses a `SECRET_KEY` the person provisions to the tool's environment themselves, or the person runs the paid command; the agent only ever works with public addresses, and spending is quote-show-wait by default.

> **Sandboxes.** npm delivers the client through its registry rather than GitHub's release-download hosts, addressing the client-distribution gap tracked in [ant-client #190](https://github.com/WithAutonomi/ant-client/issues/190). Registry access still depends on the environment. Direct-install fallbacks and subsequent node downloads need their release hosts reachable. The network itself uses direct UDP connections, so npm does not make a proxy-only sandbox able to reach peers.

## Status

A prototype, deliberately: one skill for readers, writers, builders and node operators, to find out whether they can share a skill without any of them feeling the others' weight. What it has to prove, how it's tested and the evidence so far are in [`planning/TESTING.md`](planning/TESTING.md); where every shipped claim comes from is in [`source-bindings/autonomi.md`](source-bindings/autonomi.md); current state and open threads are in [`planning/HANDOFF.md`](planning/HANDOFF.md). The design record and ADRs under `docs/` were written for the earlier node-operator-only skill; [`docs/DESIGN.md`](docs/DESIGN.md) opens with a note on how they relate to what ships now.

> **Platform status:** no platform has completed the full live prototype test. The Windows install path is source-read but has not been run on Windows. Treat its instructions as unverified until that test is complete; see `planning/HANDOFF.md`.

> **Direct-download fallback limits.** GitHub's release CDN (`release-assets.githubusercontent.com`) can be blocked even when `github.com` is allowed. The skill reports the failing host rather than inventing a mirror or bypassing policy. Historical failures and the npm follow-up are recorded in [`planning/release-endpoint-accessibility.md`](planning/release-endpoint-accessibility.md).

## Repo layout

```
skills/autonomi/        # skill component; copied directly by skills.sh and manual installs
  SKILL.md              # entry: what Autonomi is, ground rules, task router, keys & money, verified-against, further reading
  VERSION               # release version, kept in sync with skill and plugin metadata
  references/           # on demand: install-and-verify, wallet-and-tokens, run-nodes, build-on-autonomi

.claude-plugin/         # Claude Code marketplace + plugin manifests (repo root is the plugin root)
docs/                   # repo-side, never loaded as skill instructions: design, ADRs, archive
planning/               # current state, test protocol, briefs, parked threads
source-bindings/        # provenance for every shipped claim
scripts/                # ADR governance check (runs in CI)
```

Only `skills/<name>/` is discovered as an agent skill. Claude Code may cache the repository-root plugin package, but repo-side files remain maintainer material rather than skill instructions.

## Contributing

Branch + PR, never direct to `main`; architecture, protocol and security decisions go through an ADR in `docs/adr/`. See [`CONTRIBUTING.md`](CONTRIBUTING.md). Security reports: [`.github/SECURITY.md`](.github/SECURITY.md).

## Licence

MIT or Apache-2.0, at your option — see [`LICENSE-MIT`](LICENSE-MIT) and [`LICENSE-APACHE`](LICENSE-APACHE).

---

Built by the Autonomi team (MaidSafe). Autonomi: <https://autonomi.com> · documentation: <https://docs.autonomi.com> · for developers: <https://developers.autonomi.com>
