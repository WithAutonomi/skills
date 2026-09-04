# GSD Checkpoint — Autonomi skill (current state)

Date: 2026-09-04
Project: Autonomi Skills (`WithAutonomi/skills`)
Slice/question: Retire the operator skill, land the task-routed `autonomi` prototype (0.1.4), and ready the repo to go public for the developers.autonomi.com launch (Sun 6 Sept 2026).
Prepared by: Cowork (Claude Fable 5.1), on Jim's behalf; updated by OpenCode for the PR #13 repair
Agents/tools used: Cowork (Claude); OpenCode; independent Code Reviewer and Craft Reviewer; Hermes full-branch review; research subagents (distribution mechanics, sandbox egress, agent-wallet precedents, ANT acquisition, plugin manifests, uninstall practice); GitHub; `ant` 0.3.5/0.3.6 in a Claude cloud container; docs.autonomi.com.

> **Read this first if you are the incoming agent.** Reading order: `README.md` → `skills/autonomi/SKILL.md` → its `references/` → `planning/TESTING.md` → `planning/HANDOFF.md` → `source-bindings/autonomi.md` → the prototype note at the top of `docs/DESIGN.md` → `docs/adr/`. Follow the coordination protocol in `CONTRIBUTING.md` (lanes; branch + PR, never commit to `main` directly; fetch/rebase before a session and after each merge).

## Status

The binary-only 0.1.2 repair was committed and pushed as `dcca31ed347a12e620eaaaf784ec1e70ee26d6c8`; version 0.1.3 then corrected the source-backed `SECRET_KEY` requirements. Version 0.1.4 corrects the Unix manual install's configuration destination and aligns Proposed ADR-0013 with the simple `VERSION` advisory that already ships. Jim chose not to change the documented same-file replacement race, and approved binary-only uninstall as a temporary prototype divergence from Proposed ADR-0008 and DESIGN §6 while leaving formal merge-rule reconciliation open. The 0.1.4 local checks and disposable path proof pass; exact-revision review and CI are pending. The official Fable clean-context route still has not run, and required human approval is absent. Consult [PR #13](https://github.com/WithAutonomi/skills/pull/13) for the current branch revision and check results. The prototype is **not yet gauntlet-tested on a real host** or ready to merge. Merge, the public flip and the website's install tabs remain later gates.

## What happened

(since the 2026-06-22 checkpoint and the July docs refresh, PR #12)

- **Decision (Jim, 2 Sept):** build one skill named `autonomi`, routed by task — read, store, set up, build, run nodes, uninstall — as a **prototype to test with the community**; revise the ADRs once it is proven; no new ADR now. Distribution: the public GitHub repo is canonical; `npx skills add WithAutonomi/skills` is the primary install; a Claude Code plugin manifest lives in the same repo; the CLI comes from GitHub releases via the existing installer; npm distribution of the CLI is post-launch (Chris agreed; ant-client #190 filed).
- **Distribution unknowns verified from source** rather than assumed: skills CLI install mechanics (whole-directory copy; well-known index ships only `SKILL.md` unless an archive), plugin marketplaces, sandbox egress across harnesses (api.github.com 403 in Claude cloud while release downloads succeed; proxy-only sandboxes see `found 0 peers`), the skill-directory auditors (Snyk agent-scan, Socket).
- **The prototype built and revised** through six rounds of Jim's feedback: audience line up top; permanence and private/public before any write; quote-show-wait with an explicit waiver allowed; fetch-and-relay rather than sending the person to links; the demonstration read only on request; a basic node route with the wallet conversation; plain-language principle rather than a prescriptive table; latest-by-default install with no pinned version outside dated history; the OpenClaw manifest removed.
- **Key handling settled (Jim, 3 Sept):** the agent never sees a key; wallets are created by the person in a wallet app; `SECRET_KEY` is provisioned once by the person in the tool's environment, or the person runs the paid command; a composed wallet-generation procedure and a raw RPC balance read were withdrawn; the ANT contract address is baked into the *Verified against* table and the token is identified by it alone.
- **This PR:** the skill replaced; the operator skill archived verbatim under `docs/archive/operator-skill-v0/`; `planning/TESTING.md` and `source-bindings/autonomi.md` replaced; README rewritten; `LICENSE-MIT` / `LICENSE-APACHE` added; `.claude-plugin/` manifests added; SECURITY, CONTRIBUTING and the PR template updated to the new key line; DESIGN given a prototype note; HANDOFF, NEXT-PHASE and the release-endpoint note refreshed.
- **Initial review correction (4 Sept):** version 0.1.1 expanded uninstall into a category-by-category teardown. Although its scoped reviews passed, a later real-host review cleanup deleted pre-existing application data. No key, payment, upload or node action occurred, but the incident disproved the safety of exhaustive teardown guidance.
- **Repair decision (Jim, 4 Sept):** uninstall is binary-only by default, with all settings, application data, logs, nodes, payment receipts and user files retained. Stripe's first-party skills omit uninstall; among 14 first-party skills, none attempts exhaustive teardown; and X0X keeps a short separate page whose omissions and recursive deletion commands show why it is not a safe template. Version 0.1.2 implements the bounded rule and also corrects the tool-update and wallet-balance claims found by Hermes.
- **0.1.3 correction and deferral (Jim, 4 Sept):** ant-client source showed that every wallet subcommand constructs a wallet from `SECRET_KEY`; 0.1.3 now says `wallet address`, `wallet balance` and paying operations require it, while free reads and `file cost` do not. Jim chose to leave the separately documented same-file replacement race unchanged and approved binary-only uninstall as a temporary prototype divergence from Proposed ADR-0008 / DESIGN §6 rather than rewriting those formal sources in this slice.
- **0.1.4 install/freshness repair (Jim, 4 Sept):** the checksum-verified Unix manual path now writes `bootstrap_peers.toml` to the platform directory used by ant-client — `${XDG_CONFIG_HOME:-$HOME/.config}/ant` on Linux or `~/Library/Application Support/ant` on macOS — and preserves an existing file. Proposed ADR-0013 now describes the shipped best-effort semantic `VERSION` advisory rather than requiring channel-specific install identity and folder hashes. No checker, lock format, update automation or uninstall behaviour was added.

## Evidence

Files (branch `autonomi-skill-prototype`): `skills/autonomi/{SKILL.md,VERSION,references/install-and-verify.md,wallet-and-tokens.md,run-nodes.md,build-on-autonomi.md}`; `docs/archive/operator-skill-v0/*`; `planning/TESTING.md`; `source-bindings/autonomi.md`; `README.md`; `LICENSE-MIT`; `LICENSE-APACHE`; `.claude-plugin/marketplace.json`; `.claude-plugin/plugin.json`; `.github/SECURITY.md`; `CONTRIBUTING.md`; `.github/pull_request_template.md`; `docs/DESIGN.md` (note only); this file; `planning/HANDOFF.md`; `planning/NEXT-PHASE.md`; `planning/release-endpoint-accessibility.md`.

Checks run: see `planning/TESTING.md` “Evidence so far” — spec validation, skills.sh discovery, vocabulary lint, link check; installer and manual install paths on `ant` 0.3.6 in a container (version parsed from the latest `SHA256SUMS.txt`, checksum `OK`); offline address derivation; contract address matched to the docs page. The pushed skill files were verified byte-identical to the authored files, and the archived copies byte-identical to `main`, by git blob hash.

For the 0.1.1 uninstall correction: ADR governance passed; `npx skills add ./ --list` discovered the skill; the documented equivalent frontmatter check passed because `skills-ref` is unavailable here (name match; description 1,019 characters; compatibility 332); version fields agree; length and vocabulary limits pass; `git diff --check` passes. GitHub's ADR Governance check passed for correction commit `bd6cf78`.

For the 0.1.2 repair: ADR governance, skill discovery, equivalent frontmatter (description 1,021 characters; compatibility 332), synchronized version fields, plugin JSON, relative links/anchors, vocabulary, lengths, forbidden-claim scan and `git diff --check` pass. Fail-fast disposable proofs removed only an identity-checked Autonomi-shaped fake binary, preserved eight retained-state sentinels by SHA-256, and rejected an Apache Ant-shaped collision without deletion. Exact commands and output are in `planning/evidence/2026-Sep-04-pr13-repair.md`. Snyk was not run because its token is unavailable. No skill-specific CI arbiter exists; local evidence is weaker than CI and independent clean-context evidence.

For 0.1.3, the changed wallet claim traces directly to ant-client `ant-cli/src/main.rs` at `dbc01ce8fdbdfe9ac4d064d35f36b4684bf6a616`: wallet dispatch unconditionally calls `require_secret_key()`, while free reads and `file cost` construct a client without requiring a wallet. Exact local and review evidence remains in `planning/evidence/2026-Sep-04-pr13-repair.md`.

For 0.1.4, active skill/plugin versions are synchronized at 0.1.4. ADR governance, skill discovery, frontmatter, plugin JSON, relative links/anchors, vocabulary, lengths, forbidden-claim and exact-range whitespace checks pass. Disposable fixtures proved both the macOS and XDG-Linux config destinations, copying when absent and preserving existing bootstrap files byte-identically. Exact commands and output are in `planning/evidence/2026-Sep-04-pr13-repair.md`.

Results: the 0.1.2 safety repair, bounded 0.1.3 factual correction and 0.1.4 install/freshness repair pass local static and deterministic disposable-fixture checks; 0.1.4 exact-revision review/CI, the official Fable clean-context route and real-host proof remain outstanding.

## Review findings

Clean-context test:

- Reviewer/tool: official GSD Fable clean-context launcher
- Result: **Not run / deferred.** The validated retry did not invoke Fable: OpenCode rejected `cleancontext` as a primary agent and fell back to a default build agent. Its static trace is not clean-context evidence.
- Findings: The fallback ran no destructive command, `ant`, real-home access or Claude/Fable call. Its tracked-file write was replaced by an incident record in `planning/evidence/2026-Sep-04-pr13-repair.md`, and the launcher lock remains preserved for inspection. Scenario A (free read) remains the prototype's minimum real-host product gate; B needs a funded wallet and D needs a suitable node host.

Adversarial review:

- Reviewer/tool: independent Code Reviewer for 0.1.1; Hermes full-branch panel at `e616b9f`; fresh adversarial reviewers for the 0.1.2 repair
- Result: **0.1.3 bounded correction pass; full-branch review at `807e03cebe5b06886a42c6c013ed9797258122ac` remained NOT-READY pending the 0.1.4 repair and external gates. Exact 0.1.4 review is pending.**
- Findings: 0.1.2 corrected the nonexistent update flag, ANT-only wallet output, wrong-product deletion risk and false node-reset guarantee; 0.1.3 corrected the narrower false `SECRET_KEY` applicability claim. Review of 0.1.3 then found the broken manual-install config destination and ADR-0013's contradictory identity/hash requirement, corrected in the local 0.1.4 candidate. Blocking external gates remain official Fable clean-context, formal reconciliation of the Jim-approved Proposed ADR-0008 / DESIGN §6 prototype deferral, required human approval and dependency reconciliation with [PR #12](https://github.com/WithAutonomi/skills/pull/12). The same-file replacement race remains a non-blocking concern by Jim's decision.

Craft Review:

- Reviewer/tool: two 0.1.1 reviews; direct and prompt-bounded 0.1.2 Craft reviews; exact-commit archive review at `dcca31ed347a12e620eaaaf784ec1e70ee26d6c8`
- Result: **Implementation content pass; stale-state CONFORMANCE concern resolved; separate decision-record CONFORMANCE concern remains.**
- CONFORMANCE disposition: duplicated uninstall wording was reduced to one main rule plus a path-table clarification. Shipped Apache-specific wording was made product-neutral, leaving Apache only as a repository-side collision test. Exact review confirmed that stale commit/push wording was corrected. Jim explicitly approved the conflict with Proposed ADR-0008 and DESIGN §6 as a temporary prototype deferral; the prototype note and drift lists now record it, while formal merge-rule reconciliation remains open.

## Drift / scope concerns

- The prototype runs ahead of ADR-0002/0003/0004/0005 and DESIGN §1–3, §7, §8. Deliberate, recorded in the DESIGN note; revise after proof, not before.
- Binary-only uninstall also runs ahead of Proposed ADR-0008 and DESIGN §6, which still describe removing binaries and state. Jim explicitly approved this as a temporary prototype deferral on 4 September 2026; formal reconciliation remains required before merge.
- `source-bindings/autonomi.md` is provenance by document and observation, not symbol-level bindings — an ADR-0006 gap accepted for the prototype.
- At Jim's direction, 0.1.4 does not widen into Proposed ADR-0006 or `planning/ROADMAP.md`; their earlier version-manifest wording remains a later consistency cleanup rather than part of this repair.
- Two Further-reading links (`developers.autonomi.com/llms.txt`, `facts.json`) are held out until those surfaces are live.
- The skill-version URL is intentionally best-effort and returns 404 without authentication while the repository is private; verify an unauthenticated 200 response after the public flip and before promotion.
- The `.claude-plugin/` manifests are unverified on a real Claude Code.
- The node route has never been exercised live on `ant` 0.3.x — the same gap the operator skill had.

## Open questions / decisions for Jim

- Merge PR #12 first (recommended — this branch is based on it, so its diff shrinks to the prototype once #12 lands).
- Decide the formal pre-merge reconciliation for the temporarily deferred Proposed ADR-0008 / DESIGN §6 conflict.
- Who runs scenario A on a real host, and when.
- The public flip: visibility; private vulnerability reporting switched on (SECURITY.md relies on it); About description, website and topics; delete the merged `docs/install-examples` branch.

PR / upstream action gate:

- PR ready to raise? **Raised** — `autonomi-skill-prototype` → `main`, agent-authored, needs an approving review per CONTRIBUTING.
- Jim confirmed PR may be opened? **Yes** (3 Sept 2026).

## Recommended next step

1. Commit and push the bounded 0.1.4 repair, then use [PR #13](https://github.com/WithAutonomi/skills/pull/13) to verify exact-revision ADR CI and independent review; keep official Fable clean-context marked deferred rather than passed.
2. Jim: test-install from the branch on his machine and run scenario A; B only if a funded wallet is to hand.
3. Reconcile PR #12, obtain an approving review, and merge only after the declared gate is satisfied.
4. Public flip; verify the freshness URL unauthenticated; point website install tabs at `main`; quickstart prompt loses “confirm 0.3.3”.
5. Trigger eval and Snyk scan; open the community-testing call; revise the ADRs when the evidence is in.

## Handoff note

Non-negotiables: the agent **never sees, requests, generates or handles a private key**; nodes take a public address only; spending is quote-show-wait unless the person explicitly waives it; uninstall removes only the discovered executable by default and never treats testing as cleanup permission; the token is identified by contract address only; **no invented commands or figures** — trace everything, trust `--help` over the skill; the installed skill never modifies its own files; never edit an Accepted ADR (supersede); branch + PR, never direct to `main`; **PR creation on shared repos, marking ADRs Accepted, and the public flip are Jim-approval gates.**
