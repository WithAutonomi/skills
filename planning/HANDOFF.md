# Current state & handoff

> **Entry point** for anyone — human or agent — picking up the `autonomi` skill. **Owner:** Jim. **Updated:** 2026-09-24. Read this first for where things stand and what's next.

## TL;DR

**Latest decision (24 September):** Jim waived the blocked Claude review and authorised this branch's PR for **Hermes review** instead. Implementation is committed at `81f023e7d74c232dd04bd47a88bf82f09887cc8a`; subsequent commits record review/handoff only. The shared review lock remains untouched. Hermes review and Jim's merge decision are the next gates; no merge is authorised. Full evidence and remaining test gaps are in [the checkpoint](evidence/2026-Sep-24-npm-install.md).

The **one task-routed prototype (0.1.4)** merged through [PR #13](https://github.com/WithAutonomi/skills/pull/13) at `69ca49452e7555f607646bc9f023718bf43cd046`. The older operator-only skill is archived; do not edit it for current installation changes. **0.1.5 npm-first client installation** is on `autonomi-npm-install`; main retains 0.1.4 until review and merge. The change keeps both direct installers in the bundled reference, updates npm lifecycle guidance and preserves all user/application state. Scope: [`PACKET-autonomi-npm-install.md`](packets/PACKET-autonomi-npm-install.md). The prototype remains unproven across all live scenarios; no new Windows or node-operation support claim is made.

**Start here:** `README.md` → `skills/autonomi/SKILL.md` → its `references/` → `planning/TESTING.md` → this doc → `source-bindings/autonomi.md` → the prototype note at the top of `docs/DESIGN.md` → `docs/adr/`.

## What's in the repo

- **`skills/autonomi/`** — the installable skill component: `SKILL.md`, `VERSION`, `references/` (`install-and-verify`, `wallet-and-tokens`, `run-nodes`, `build-on-autonomi`). It is the only part loaded as skill instructions; Claude Code may physically cache the repository-root plugin package.
- **`.claude-plugin/`** — Claude Code marketplace + plugin manifests; the repo root is the plugin root.
- **`docs/`** — `DESIGN.md` (the operator-era design, opening with the prototype note), `VISION.md`, `CURRENT.md` (checkpoint), `adr/` (ADR-0001 to ADR-0014, all **Proposed**), `archive/operator-skill-v0/` (the retired skill and its source bindings), and the June design specs (`operating-doctrine.md`, `skill-grounding.md`, `FEATURES.md`, `SOURCE-MAP.md`, `SPEC-tier1-operate-and-earn.md`).
- **`planning/`** — `TESTING.md` (the test protocol and the evidence so far), `NEXT-PHASE.md` (parked threads), `REBUILD-BRIEF.md`, `ROADMAP.md`, the two briefs, `packets/`, `release-endpoint-accessibility.md`.
- **`source-bindings/autonomi.md`** — where every shipped claim comes from.
- `README.md`, `CONTRIBUTING.md`, `LICENSE-MIT`, `LICENSE-APACHE`, `.github/` (security policy, PR template, ADR-governance workflow).

## Repo & operational facts

- **Home & owner:** `WithAutonomi/skills`, transferred from `JimCollinson/skills` (GitHub redirects the old URLs). Hermes signed off on the name/home (ADR-0007 / 0012).
- **Visibility — private.** A later explicit public flip will enable unauthenticated skills.sh installs, public listing, and enforcement of the configured branch ruleset. Do not infer approval from the earlier 6 September launch target. While private, installing via skills.sh needs the runner's own GitHub authentication and repository access. Before the flip: enable **private vulnerability reporting** (SECURITY.md relies on it), set the About description / website / topics, and delete the merged `docs/install-examples` branch.
- **Branch protection — configured but not enforced.** A `main-branch-protect` ruleset exists (require a PR, block force-push + deletion, require the ADR CI check, 0 required approvals), but GitHub only enforces rulesets on **private** repos under **GitHub Team+**, and this org is on the free plan. So it's currently **honour-system** — branch + PR by convention (`CONTRIBUTING.md`). It **auto-activates when the repo goes public** (or the org upgrades).
- **Agent/integration access:** because the repo is private, an external integration (automation, or an agent's GitHub tooling) needs an explicit org grant to reach it — otherwise it can't read or write the repo.
- **Install:** `npx skills add WithAutonomi/skills` (from `main`); to test-install an unmerged branch, its name must be slash-free (skills.sh can't parse a slashed-branch tree URL).

## Working model & gates

- **Branch + PR** for changes — don't commit straight to `main` (protection is convention-only for now, so this runs on trust).
- **Proceed freely:** skill content and wording, `references/`, `docs/` prose, `README`, `planning/`, tests, bug fixes, provenance corrections — bumping `VERSION` whenever a shipped file changes.
- **Gated (needs an ADR and/or Jim):** architecture / protocol / security decisions and **accepting ADRs**; distribution-channel changes; repo/skill renaming; the **public flip**; anything touching keys / custody / spend beyond what the skill already does.
- **ADR discipline:** inspect `docs/adr/` before changing architecture; draft new decisions as **Proposed**; never edit an Accepted ADR (supersede instead). The prototype deliberately runs ahead of ADR-0002/0003/0004/0005 — recorded in the DESIGN note. Binary-only uninstall also conflicts with Proposed ADR-0008 and DESIGN §6, which still describe removing state; Jim approved that as a temporary prototype deferral on 4 September 2026 and, on 6 September, directed that broader reconciliation follow prototype evidence rather than block PR #13.

## State of the skill (what's done)

- **One skill, routed by task.** Read / store / set up / build / run nodes / uninstall, with “do what you were asked, and no more” as the routing rule. The audience is assumed to be a non-developer until they show otherwise; plain register by principle, not by table.
- **The key line.** The agent never sees a private key: wallets are created by the person in a wallet app; a paid write uses a `SECRET_KEY` the person provisions once in the tool's environment, or the person runs the paid command; any key appearing in context means stop, new wallet, move funds. Nodes take a public address only. The token is identified by its contract address, baked into the *Verified against* table.
- **Spend.** Permanence and public/private established first; quote, show, wait by default; an explicit waiver within a limit is honoured and every spend still reported.
- **Install (0.1.5 candidate).** Detect first; prefer `npm install -g @withautonomi/ant` with existing Node.js/npm. Keep direct Linux/macOS and Windows scripts (fetch/read/run) and checksum-verified manual installation in the bundled reference. No Node installation solely for the CLI, no forced overwrites or privileged workaround. npm client delivery does not prove UDP or node-download reachability.
- **Uninstall (0.1.5 candidate).** Remove only the confirmed tool: the owning npm package/launchers, or the identified standalone executable. Settings, application data, logs, nodes, payment receipts, installer downloads and user files are retained by default. Testing never implies cleanup permission. No node teardown is part of package removal.
- **Freshness.** Skill updates remain channel-owned; the installed skill never checks its own version or modifies its own files. Separately, `ant --version` reports without updating; an authorised npm client update uses its owning npm installation, while direct copies retain `ant update`. Neither update is a check-only operation.
- **Provenance.** Every Autonomi-specific command, flag, constant, URL, figure, and install behaviour traces to `source-bindings/autonomi.md`; temporary team-confirmed exceptions are labelled pending upstream authority. The prototype record is document/observation-level rather than the symbol-level target in Proposed ADR-0006.
- **Policy ahead of implementation.** PR #12's Proposed default-deny rule permits only necessary non-mutating observation under missing, ambiguous, or exceeded remit. The prototype's broader reversible-action wording has not yet been reconciled; this is recorded, not presented as an implemented guarantee.
- **Verified / not verified.** `planning/TESTING.md` “Evidence so far” is the historical list. The binary-only safety checks, deterministic disposable uninstall/collision proofs, 0.1.3 key-claim source check, and 0.1.4 macOS/XDG config-path and preservation proofs pass; exact results are in `planning/evidence/2026-Sep-04-pr13-repair.md`. The 6 September reconciliation also passes ADR governance, branch-wide whitespace, discovery, equivalent metadata validation, synchronized 0.1.4 versions, length/vocabulary checks, an isolated local copy, checksum-verified disposable installation of `ant` 0.3.6, a live free read that connected to 5 peers and returned a valid JPEG, and an authenticated install from the private GitHub branch whose copied skill/version match the checkout byte-for-byte. Current exact-head CI and review status are tracked on [PR #13](https://github.com/WithAutonomi/skills/pull/13). **Not verified:** older-copy update execution through skills.sh and Claude Code; a paid write on 0.3.6; the live node route; the trigger eval, Snyk, or Windows. The earlier Fable route did not run, and Jim excluded a new Fable run from this reconciliation slice.

## Open threads (what's next)

1. **Hermes review of npm-first installation.** Review the 0.1.5 PR, evidence and carried observations, then return to Jim for the merge decision. Claude review is waived for this change; recovering its shared lock is not part of this work.
2. **Public flip and the site.** Visibility, private vulnerability reporting, About/topics; the website's install tabs point at `main`; the quickstart prompt loses “confirm 0.3.3”.
3. **Developer-site surfaces.** Once `developers.autonomi.com/llms.txt` and `facts.json` are live, add them to Further reading in a later version bump.
4. **Community testing.** Trigger eval; Snyk scan (needs a token); open the testing call; collect transcripts and score them against F1–F10 in `planning/TESTING.md`.
5. **ADR revision after proof** (0002 / 0003 / 0004 / 0005 / 0007 / 0008) — or split the skill if F3/F4 recur. Preserve the intended bundled operational core with optional external depth, and require a declared recovery path at creation for every future agent-created wallet. Accepting any decision ADR remains Jim's gate.
6. **ant-client asks.** npm distribution is now available ([#190](https://github.com/WithAutonomi/ant-client/issues/190)); this candidate consumes it. Other asks remain: unversioned release-asset aliases; checksum verification inside `install.sh` / `install.ps1`; a secrets mechanism so an agent can pay without a raw key in `SECRET_KEY`.
7. **Node route depth.** Grow *Run nodes* from the archived operator references once the shape is proven; the node-resource SOP for the dev team (`planning/node-resource-spec-brief.md`) still stands.
8. **Parked:** source-bound regeneration automation (`NEXT-PHASE.md` §3); rebuilding symbol-level provenance on `source-bindings/autonomi.md` (ADR-0006 gap).
9. **Skill-release automation:** channel-owned consumer updates are documented; the publisher-side source-bound regeneration pipeline remains parked in `NEXT-PHASE.md` §3.

## How to test

See **`planning/TESTING.md`** — failure signals, the trigger eval set, the cold-run scenarios, static checks, and what “proven” means.

## Contacts

Jim (owner); David, Hermes and Chris contribute. Raise decisions/questions via PR comments or `planning/` notes.
