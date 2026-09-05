# Current state & handoff

> **Entry point** for anyone — human or agent — picking up the `autonomi` skill. **Owner:** Jim. **Updated:** 2026-09-05. Read this first for where things stand and what's next.

## TL;DR

The `autonomi` skill is now **one task-routed skill** — read data by content address, store it publicly or privately, run nodes that earn ANT, build the network into an application — prepared as a **prototype (0.1.4)** for testing with the community. It replaces the June operator-only skill, which is archived verbatim under `docs/archive/operator-skill-v0/`. It lives at **[`WithAutonomi/skills`](https://github.com/WithAutonomi/skills)** (private until the launch flip), installable with `npx skills add WithAutonomi/skills` from `main` or as a Claude Code plugin. Version 0.1.3 corrected the `SECRET_KEY` requirements; 0.1.4 corrects the Unix manual install's platform config destination and uses channel-owned skill updates rather than a first-use `VERSION` request. Jim chose not to change the documented same-file replacement race, accepted the narrow bootstrap check-then-copy race rather than adding atomic machinery, and approved binary-only uninstall as a temporary prototype divergence from Proposed ADR-0008 / DESIGN §6, with formal reconciliation still required before merge. The official Fable gate, dependency [PR #12](https://github.com/WithAutonomi/skills/pull/12), and required human approval remain open. Consult [PR #13](https://github.com/WithAutonomi/skills/pull/13) for the current revision and check results. The prototype is **not yet proven on a real host or ready to merge**.

**Start here:** `README.md` → `skills/autonomi/SKILL.md` → its `references/` → `planning/TESTING.md` → this doc → `source-bindings/autonomi.md` → the prototype note at the top of `docs/DESIGN.md` → `docs/adr/`.

## What's in the repo

- **`skills/autonomi/`** — the installable skill: `SKILL.md`, `VERSION`, `references/` (`install-and-verify`, `wallet-and-tokens`, `run-nodes`, `build-on-autonomi`). The only thing that ships.
- **`.claude-plugin/`** — Claude Code marketplace + plugin manifests; the repo root is the plugin root.
- **`docs/`** — `DESIGN.md` (the operator-era design, opening with the prototype note), `VISION.md`, `CURRENT.md` (checkpoint), `adr/` (ADR-0001 to ADR-0014, all **Proposed**), `archive/operator-skill-v0/` (the retired skill and its source bindings), and the June design specs (`operating-doctrine.md`, `skill-grounding.md`, `FEATURES.md`, `SOURCE-MAP.md`, `SPEC-tier1-operate-and-earn.md`).
- **`planning/`** — `TESTING.md` (the test protocol and the evidence so far), `NEXT-PHASE.md` (parked threads), `REBUILD-BRIEF.md`, `ROADMAP.md`, the two briefs, `packets/`, `release-endpoint-accessibility.md`.
- **`source-bindings/autonomi.md`** — where every shipped claim comes from.
- `README.md`, `CONTRIBUTING.md`, `LICENSE-MIT`, `LICENSE-APACHE`, `.github/` (security policy, PR template, ADR-governance workflow).

## Repo & operational facts

- **Home & owner:** `WithAutonomi/skills`, transferred from `JimCollinson/skills` (GitHub redirects the old URLs). Hermes signed off on the name/home (ADR-0007 / 0012).
- **Visibility — private until launch.** It goes **public with developers.autonomi.com (6 Sept 2026)**: public is what enables unauthenticated `skills.sh` installs, the skills.sh listing and true clean-context testing — and it's what actually switches branch protection on (below). While private, installing via skills.sh needs the runner's own GitHub auth (an org member with access). Before the flip: enable **private vulnerability reporting** (SECURITY.md relies on it), set the About description / website / topics, and delete the merged `docs/install-examples` branch.
- **Branch protection — configured but not enforced.** A `main-branch-protect` ruleset exists (require a PR, block force-push + deletion, require the ADR CI check, 0 required approvals), but GitHub only enforces rulesets on **private** repos under **GitHub Team+**, and this org is on the free plan. So it's currently **honour-system** — branch + PR by convention (`CONTRIBUTING.md`). It **auto-activates when the repo goes public** (or the org upgrades).
- **Agent/integration access:** because the repo is private, an external integration (automation, or an agent's GitHub tooling) needs an explicit org grant to reach it — otherwise it can't read or write the repo.
- **Install:** `npx skills add WithAutonomi/skills` (from `main`); to test-install an unmerged branch, its name must be slash-free (skills.sh can't parse a slashed-branch tree URL).

## Working model & gates

- **Branch + PR** for changes — don't commit straight to `main` (protection is convention-only for now, so this runs on trust).
- **Proceed freely:** skill content and wording, `references/`, `docs/` prose, `README`, `planning/`, tests, bug fixes, provenance corrections — bumping `VERSION` whenever a shipped file changes.
- **Gated (needs an ADR and/or Jim):** architecture / protocol / security decisions and **accepting ADRs**; distribution-channel changes; repo/skill renaming; the **public flip**; anything touching keys / custody / spend beyond what the skill already does.
- **ADR discipline:** inspect `docs/adr/` before changing architecture; draft new decisions as **Proposed**; never edit an Accepted ADR (supersede instead). The prototype deliberately runs ahead of ADR-0002/0003/0004/0005 — recorded in the DESIGN note. Binary-only uninstall also conflicts with Proposed ADR-0008 and DESIGN §6, which still describe removing state; Jim approved that as a temporary prototype deferral on 4 September 2026. Formal reconciliation remains a pre-merge checkpoint.

## State of the skill (what's done)

- **One skill, routed by task.** Read / store / set up / build / run nodes / uninstall, with “do what you were asked, and no more” as the routing rule. The audience is assumed to be a non-developer until they show otherwise; plain register by principle, not by table.
- **The key line.** The agent never sees a private key: wallets are created by the person in a wallet app; a paid write uses a `SECRET_KEY` the person provisions once in the tool's environment, or the person runs the paid command; any key appearing in context means stop, new wallet, move funds. Nodes take a public address only. The token is identified by its contract address, baked into the *Verified against* table.
- **Spend.** Permanence and public/private established first; quote, show, wait by default; an explicit waiver within a limit is honoured and every spend still reported.
- **Install.** Detect first; the official installer fetched and read before running, latest stable, no pinned version outside dated history; a checksum-verified manual path that reads the version from `releases/latest/download/SHA256SUMS.txt`; fallbacks for a blocked `api.github.com`; an honest `found 0 peers` explanation for proxy-only sandboxes; `--ipv4-only` for hosts without IPv6.
- **Uninstall.** A request to uninstall `ant` removes only the discovered executable. Settings, application data, logs, nodes, payment receipts, installer downloads and user files are retained by default. Testing and one-off installation never imply cleanup permission; broader destruction is separately requested, explained, source-checked and confirmed. Application data is never recursively deleted as a node-removal shortcut.
- **Freshness.** Skill updates belong to the installation channel: `npx skills update autonomi`, Claude Code marketplace update (automatic only when enabled), or deliberate reinstall for a manual copy. The installed skill makes no request to check its own version and never modifies its own files. Task-specific live documentation remains the source for facts whose currency matters. Separately, `ant --version` is the non-mutating tool check; `ant update` can replace the executable and runs only after approval.
- **Verified / not verified.** `planning/TESTING.md` “Evidence so far” is the honest list. The binary-only safety checks, deterministic disposable uninstall/collision proofs, 0.1.3 key-claim source check and 0.1.4 macOS/XDG config-path and preservation proofs pass; exact results are in `planning/evidence/2026-Sep-04-pr13-repair.md`. Exact re-review at `83f178847f8ca2377207d21afba2325db0e238b6` found no CRITICAL/HIGH issue, found the raw freshness-response concern now removed, and raised the bootstrap race Jim accepted; its Craft review passed. **Not verified:** exact review/CI of the new channel-owned freshness revision; the official Fable clean-context gate, because the dedicated route failed before invoking Fable; a live read or write on 0.3.6 on a real host; the node route live; the trigger eval, Snyk or Windows.

## Open threads (what's next)

1. **Finish the gauntlet.** Local binary-only checks, portable disposable proofs, the 0.1.3 key-claim source check and the 0.1.4 config-path proof pass. Use [PR #13](https://github.com/WithAutonomi/skills/pull/13) to inspect the current immutable revision, exact re-reviews and ADR CI. Keep official Fable clean-context marked deferred until its dedicated route can run; formally reconcile the Jim-approved Proposed ADR-0008 / DESIGN §6 prototype deferral and [PR #12](https://github.com/WithAutonomi/skills/pull/12); then obtain required human approval. Scenario A (free read) still needs a real host; B (paid write) and D (nodes) run only when a funded wallet and a host with room are available.
2. **Public flip and the site.** Visibility, private vulnerability reporting, About/topics; the website's install tabs point at `main`; the quickstart prompt loses “confirm 0.3.3”.
3. **Developer-site surfaces.** Once `developers.autonomi.com/llms.txt` and `facts.json` are live, add them to Further reading in a later version bump.
4. **Community testing.** Trigger eval; Snyk scan (needs a token); open the testing call; collect transcripts and score them against F1–F10 in `planning/TESTING.md`.
5. **ADR revision after proof** (0002 / 0003 / 0004 / 0005 / 0007) — or split the skill if F3/F4 recur. Accepting the decision ADRs (0007 / 0008 / 0012 / 0013 / 0014) remains Jim's gate.
6. **ant-client asks.** npm distribution of the CLI (#190, post-launch, agreed with Chris); unversioned release-asset aliases; checksum verification inside `install.sh` / `install.ps1`; a secrets mechanism so an agent can pay without a raw key in `SECRET_KEY`.
7. **Node route depth.** Grow *Run nodes* from the archived operator references once the shape is proven; the node-resource SOP for the dev team (`planning/node-resource-spec-brief.md`) still stands.
8. **Parked:** source-bound regeneration automation (`NEXT-PHASE.md` §3); rebuilding symbol-level provenance on `source-bindings/autonomi.md` (ADR-0006 gap).
9. **Skill-release automation:** channel-owned consumer updates are documented; the publisher-side source-bound regeneration pipeline remains parked in `NEXT-PHASE.md` §3.

## How to test

See **`planning/TESTING.md`** — failure signals, the trigger eval set, the cold-run scenarios, static checks, and what “proven” means.

## Contacts

Jim (owner); David, Hermes and Chris contribute. Raise decisions/questions via PR comments or `planning/` notes.
