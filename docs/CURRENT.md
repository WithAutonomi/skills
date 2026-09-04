# GSD Checkpoint — Autonomi skill (current state)

Date: 2026-09-04
Project: Autonomi Skills (`WithAutonomi/skills`)
Slice/question: Retire the operator skill, land the task-routed `autonomi` prototype (0.1.2), and ready the repo to go public for the developers.autonomi.com launch (Sun 6 Sept 2026).
Prepared by: Cowork (Claude Fable 5.1), on Jim's behalf; updated by OpenCode for the PR #13 repair
Agents/tools used: Cowork (Claude); OpenCode; independent Code Reviewer and Craft Reviewer; Hermes full-branch review; research subagents (distribution mechanics, sandbox egress, agent-wallet precedents, ANT acquisition, plugin manifests, uninstall practice); GitHub; `ant` 0.3.5/0.3.6 in a Claude cloud container; docs.autonomi.com.

> **Read this first if you are the incoming agent.** Reading order: `README.md` → `skills/autonomi/SKILL.md` → its `references/` → `planning/TESTING.md` → `planning/HANDOFF.md` → `source-bindings/autonomi.md` → the prototype note at the top of `docs/DESIGN.md` → `docs/adr/`. Follow the coordination protocol in `CONTRIBUTING.md` (lanes; branch + PR, never commit to `main` directly; fetch/rebase before a session and after each merge).

## Status

The 0.1.2 implementation repair was committed and pushed as `dcca31ed347a12e620eaaaf784ec1e70ee26d6c8`; this follow-up records the resulting review state. Exact-commit Craft found stale pre-commit wording in this file and `planning/HANDOFF.md`, which this follow-up corrects. The official Fable clean-context route did not run: OpenCode rejected `cleancontext` as a primary agent, fell back to a default build agent, and no Claude/Fable call occurred. Consult [PR #13](https://github.com/WithAutonomi/skills/pull/13) for the current branch revision and check results. The prototype is **not yet gauntlet-tested on a real host** or ready to merge. Merge, the public flip and the website's install tabs remain later gates.

## What happened

(since the 2026-06-22 checkpoint and the July docs refresh, PR #12)

- **Decision (Jim, 2 Sept):** build one skill named `autonomi`, routed by task — read, store, set up, build, run nodes, uninstall — as a **prototype to test with the community**; revise the ADRs once it is proven; no new ADR now. Distribution: the public GitHub repo is canonical; `npx skills add WithAutonomi/skills` is the primary install; a Claude Code plugin manifest lives in the same repo; the CLI comes from GitHub releases via the existing installer; npm distribution of the CLI is post-launch (Chris agreed; ant-client #190 filed).
- **Distribution unknowns verified from source** rather than assumed: skills CLI install mechanics (whole-directory copy; well-known index ships only `SKILL.md` unless an archive), plugin marketplaces, sandbox egress across harnesses (api.github.com 403 in Claude cloud while release downloads succeed; proxy-only sandboxes see `found 0 peers`), the skill-directory auditors (Snyk agent-scan, Socket).
- **The prototype built and revised** through six rounds of Jim's feedback: audience line up top; permanence and private/public before any write; quote-show-wait with an explicit waiver allowed; fetch-and-relay rather than sending the person to links; the demonstration read only on request; a basic node route with the wallet conversation; plain-language principle rather than a prescriptive table; latest-by-default install with no pinned version outside dated history; the OpenClaw manifest removed.
- **Key handling settled (Jim, 3 Sept):** the agent never sees a key; wallets are created by the person in a wallet app; `SECRET_KEY` is provisioned once by the person in the tool's environment, or the person runs the paid command; a composed wallet-generation procedure and a raw RPC balance read were withdrawn; the ANT contract address is baked into the *Verified against* table and the token is identified by it alone.
- **This PR:** the skill replaced; the operator skill archived verbatim under `docs/archive/operator-skill-v0/`; `planning/TESTING.md` and `source-bindings/autonomi.md` replaced; README rewritten; `LICENSE-MIT` / `LICENSE-APACHE` added; `.claude-plugin/` manifests added; SECURITY, CONTRIBUTING and the PR template updated to the new key line; DESIGN given a prototype note; HANDOFF, NEXT-PHASE and the release-endpoint note refreshed.
- **Initial review correction (4 Sept):** version 0.1.1 expanded uninstall into a category-by-category teardown. Although its scoped reviews passed, a later real-host review cleanup deleted pre-existing application data. No key, payment, upload or node action occurred, but the incident disproved the safety of exhaustive teardown guidance.
- **Repair decision (Jim, 4 Sept):** uninstall is binary-only by default, with all settings, application data, logs, nodes, payment receipts and user files retained. Stripe's first-party skills omit uninstall; among 14 first-party skills, none attempts exhaustive teardown; and X0X keeps a short separate page whose omissions and recursive deletion commands show why it is not a safe template. Version 0.1.2 implements the bounded rule and also corrects the tool-update and wallet-balance claims found by Hermes.

## Evidence

Files (branch `autonomi-skill-prototype`): `skills/autonomi/{SKILL.md,VERSION,references/install-and-verify.md,wallet-and-tokens.md,run-nodes.md,build-on-autonomi.md}`; `docs/archive/operator-skill-v0/*`; `planning/TESTING.md`; `source-bindings/autonomi.md`; `README.md`; `LICENSE-MIT`; `LICENSE-APACHE`; `.claude-plugin/marketplace.json`; `.claude-plugin/plugin.json`; `.github/SECURITY.md`; `CONTRIBUTING.md`; `.github/pull_request_template.md`; `docs/DESIGN.md` (note only); this file; `planning/HANDOFF.md`; `planning/NEXT-PHASE.md`; `planning/release-endpoint-accessibility.md`.

Checks run: see `planning/TESTING.md` “Evidence so far” — spec validation, skills.sh discovery, vocabulary lint, link check; installer and manual install paths on `ant` 0.3.6 in a container (version parsed from the latest `SHA256SUMS.txt`, checksum `OK`); offline address derivation; contract address matched to the docs page. The pushed skill files were verified byte-identical to the authored files, and the archived copies byte-identical to `main`, by git blob hash.

For the 0.1.1 uninstall correction: ADR governance passed; `npx skills add ./ --list` discovered the skill; the documented equivalent frontmatter check passed because `skills-ref` is unavailable here (name match; description 1,019 characters; compatibility 332); version fields agree; length and vocabulary limits pass; `git diff --check` passes. GitHub's ADR Governance check passed for correction commit `bd6cf78`.

For the 0.1.2 repair: ADR governance, skill discovery, equivalent frontmatter (description 1,021 characters; compatibility 332), synchronized version fields, plugin JSON, relative links/anchors, vocabulary, lengths, forbidden-claim scan and `git diff --check` pass. Fail-fast disposable proofs removed only an identity-checked Autonomi-shaped fake binary, preserved eight retained-state sentinels by SHA-256, and rejected an Apache Ant-shaped collision without deletion. Exact commands and output are in `planning/evidence/2026-Sep-04-pr13-repair.md`. Snyk was not run because its token is unavailable. No skill-specific CI arbiter exists; local evidence is weaker than CI and independent clean-context evidence.

Results: 0.1.2 repair passes local static and deterministic disposable-fixture checks; not yet tested by the official Fable clean-context route or proven on a real host.

## Review findings

Clean-context test:

- Reviewer/tool: official GSD Fable clean-context launcher
- Result: **Not run / deferred.** The validated retry did not invoke Fable: OpenCode rejected `cleancontext` as a primary agent and fell back to a default build agent. Its static trace is not clean-context evidence.
- Findings: The fallback ran no destructive command, `ant`, real-home access or Claude/Fable call. Its tracked-file write was replaced by an incident record in `planning/evidence/2026-Sep-04-pr13-repair.md`, and the launcher lock remains preserved for inspection. Scenario A (free read) remains the prototype's minimum real-host product gate; B needs a funded wallet and D needs a suitable node host.

Adversarial review:

- Reviewer/tool: independent Code Reviewer for 0.1.1; Hermes full-branch panel at `e616b9f`; fresh adversarial reviewers for the 0.1.2 repair
- Result: **0.1.2 content pass: no remaining CRITICAL/HIGH content finding. Final evidence recheck: no CRITICAL, HIGH or MEDIUM finding. Overall readiness blocked on immutable-revision gates.**
- Findings: 0.1.2 corrected the nonexistent update flag, ANT-only wallet output, wrong-product deletion risk and false node-reset guarantee. A HIGH evidence-transcript defect was fixed by a fail-fast rerun with exact commands and output. The last LOW evidence request was resolved by naming the changed-claim source review and narrowing the reproducibility statement.

Craft Review:

- Reviewer/tool: two 0.1.1 reviews; direct and prompt-bounded 0.1.2 Craft reviews; exact-commit archive review at `dcca31ed347a12e620eaaaf784ec1e70ee26d6c8`
- Result: **Implementation content pass; exact-commit CONFORMANCE concern in current-state prose corrected by this follow-up.**
- CONFORMANCE disposition: duplicated uninstall wording was reduced to one main rule plus a path-table clarification. Shipped Apache-specific wording was made product-neutral, leaving Apache only as a repository-side collision test. Exact-commit Craft found that this file and `planning/HANDOFF.md` still said commit/push was pending after it had happened; those statements are corrected here.

## Drift / scope concerns

- The prototype runs ahead of ADR-0002/0003/0004/0005 and DESIGN §1–3, §7, §8. Deliberate, recorded in the DESIGN note; revise after proof, not before.
- `source-bindings/autonomi.md` is provenance by document and observation, not symbol-level bindings — an ADR-0006 gap accepted for the prototype.
- Two Further-reading links (`developers.autonomi.com/llms.txt`, `facts.json`) are held out until those surfaces are live.
- The skill-version URL is intentionally best-effort and returns 404 without authentication while the repository is private; verify an unauthenticated 200 response after the public flip and before promotion.
- The `.claude-plugin/` manifests are unverified on a real Claude Code.
- The node route has never been exercised live on `ant` 0.3.x — the same gap the operator skill had.

## Open questions / decisions for Jim

- Merge PR #12 first (recommended — this branch is based on it, so its diff shrinks to the prototype once #12 lands).
- Who runs scenario A on a real host, and when.
- The public flip: visibility; private vulnerability reporting switched on (SECURITY.md relies on it); About description, website and topics; delete the merged `docs/install-examples` branch.

PR / upstream action gate:

- PR ready to raise? **Raised** — `autonomi-skill-prototype` → `main`, agent-authored, needs an approving review per CONTRIBUTING.
- Jim confirmed PR may be opened? **Yes** (3 Sept 2026).

## Recommended next step

1. Use [PR #13](https://github.com/WithAutonomi/skills/pull/13) to verify exact-revision ADR CI and independent review, update its stale 0.1.0 metadata, and keep official Fable clean-context marked deferred rather than passed.
2. Jim: test-install from the branch on his machine and run scenario A; B only if a funded wallet is to hand.
3. Reconcile PR #12, obtain an approving review, and merge only after the declared gate is satisfied.
4. Public flip; verify the freshness URL unauthenticated; point website install tabs at `main`; quickstart prompt loses “confirm 0.3.3”.
5. Trigger eval and Snyk scan; open the community-testing call; revise the ADRs when the evidence is in.

## Handoff note

Non-negotiables: the agent **never sees, requests, generates or handles a private key**; nodes take a public address only; spending is quote-show-wait unless the person explicitly waives it; uninstall removes only the discovered executable by default and never treats testing as cleanup permission; the token is identified by contract address only; **no invented commands or figures** — trace everything, trust `--help` over the skill; the installed skill never modifies its own files; never edit an Accepted ADR (supersede); branch + PR, never direct to `main`; **PR creation on shared repos, marking ADRs Accepted, and the public flip are Jim-approval gates.**
