# GSD Checkpoint — Autonomi skill (current state)

Date: 2026-09-04
Project: Autonomi Skills (`WithAutonomi/skills`)
Slice/question: Retire the operator skill, land the task-routed `autonomi` prototype (0.1.1), and ready the repo to go public for the developers.autonomi.com launch (Sun 6 Sept 2026).
Prepared by: Cowork (Claude Fable 5.1), on Jim's behalf; updated by OpenCode for the uninstall correction
Agents/tools used: Cowork (Claude); OpenCode; independent Code Reviewer and Craft Reviewer; research subagents (distribution mechanics, sandbox egress, agent-wallet precedents, ANT acquisition, plugin manifests); GitHub; `ant` 0.3.5/0.3.6 in a Claude cloud container; docs.autonomi.com.

> **Read this first if you are the incoming agent.** Reading order: `README.md` → `skills/autonomi/SKILL.md` → its `references/` → `planning/TESTING.md` → `planning/HANDOFF.md` → `source-bindings/autonomi.md` → the prototype note at the top of `docs/DESIGN.md` → `docs/adr/`. Follow the coordination protocol in `CONTRIBUTING.md` (lanes; branch + PR, never commit to `main` directly; fetch/rebase before a session and after each merge).

## Status

**Continue.** The prototype is authored, statically checked, and on the branch `autonomi-skill-prototype` as a PR into `main`. It is **not yet gauntlet-tested on a real host**. Merge, the public flip and the website's install tabs follow the gauntlet.

## What happened

(since the 2026-06-22 checkpoint and the July docs refresh, PR #12)

- **Decision (Jim, 2 Sept):** build one skill named `autonomi`, routed by task — read, store, set up, build, run nodes, uninstall — as a **prototype to test with the community**; revise the ADRs once it is proven; no new ADR now. Distribution: the public GitHub repo is canonical; `npx skills add WithAutonomi/skills` is the primary install; a Claude Code plugin manifest lives in the same repo; the CLI comes from GitHub releases via the existing installer; npm distribution of the CLI is post-launch (Chris agreed; ant-client #190 filed).
- **Distribution unknowns verified from source** rather than assumed: skills CLI install mechanics (whole-directory copy; well-known index ships only `SKILL.md` unless an archive), plugin marketplaces, sandbox egress across harnesses (api.github.com 403 in Claude cloud while release downloads succeed; proxy-only sandboxes see `found 0 peers`), the skill-directory auditors (Snyk agent-scan, Socket).
- **The prototype built and revised** through six rounds of Jim's feedback: audience line up top; permanence and private/public before any write; quote-show-wait with an explicit waiver allowed; fetch-and-relay rather than sending the person to links; the demonstration read only on request; a basic node route with the wallet conversation; plain-language principle rather than a prescriptive table; latest-by-default install with no pinned version outside dated history; the OpenClaw manifest removed.
- **Key handling settled (Jim, 3 Sept):** the agent never sees a key; wallets are created by the person in a wallet app; `SECRET_KEY` is provisioned once by the person in the tool's environment, or the person runs the paid command; a composed wallet-generation procedure and a raw RPC balance read were withdrawn; the ANT contract address is baked into the *Verified against* table and the token is identified by it alone.
- **This PR:** the skill replaced; the operator skill archived verbatim under `docs/archive/operator-skill-v0/`; `planning/TESTING.md` and `source-bindings/autonomi.md` replaced; README rewritten; `LICENSE-MIT` / `LICENSE-APACHE` added; `.claude-plugin/` manifests added; SECURITY, CONTRIBUTING and the PR template updated to the new key line; DESIGN given a prototype note; HANDOFF, NEXT-PHASE and the release-endpoint note refreshed.
- **Review correction (4 Sept):** uninstall now distinguishes the executable, configuration, application data, logs and node directories; requires separate consent before deleting state; warns that removing resumable payment receipts can cause repayment; covers custom node paths, Windows `PATH` and installer leftovers; and preserves user files such as datamaps. Prototype version advanced to 0.1.1.

## Evidence

Files (branch `autonomi-skill-prototype`): `skills/autonomi/{SKILL.md,VERSION,references/install-and-verify.md,wallet-and-tokens.md,run-nodes.md,build-on-autonomi.md}`; `docs/archive/operator-skill-v0/*`; `planning/TESTING.md`; `source-bindings/autonomi.md`; `README.md`; `LICENSE-MIT`; `LICENSE-APACHE`; `.claude-plugin/marketplace.json`; `.claude-plugin/plugin.json`; `.github/SECURITY.md`; `CONTRIBUTING.md`; `.github/pull_request_template.md`; `docs/DESIGN.md` (note only); this file; `planning/HANDOFF.md`; `planning/NEXT-PHASE.md`; `planning/release-endpoint-accessibility.md`.

Checks run: see `planning/TESTING.md` “Evidence so far” — spec validation, skills.sh discovery, vocabulary lint, link check; installer and manual install paths on `ant` 0.3.6 in a container (version parsed from the latest `SHA256SUMS.txt`, checksum `OK`); offline address derivation; contract address matched to the docs page. The pushed skill files were verified byte-identical to the authored files, and the archived copies byte-identical to `main`, by git blob hash.

For the local 0.1.1 uninstall correction: ADR governance passed; `npx skills add ./ --list` discovered the skill; the documented equivalent frontmatter check passed because `skills-ref` is unavailable here (name match; description 1,019 characters; compatibility 332); version fields agree; length and vocabulary limits pass; `git diff --check` passes. No CI run includes these uncommitted edits yet, so local evidence is not the green of record.

Results: prototype complete as authored; not yet proven on a real host.

## Review findings

Clean-context test:

- Reviewer/tool: `gsd-clean-context-tester` / a fresh agent on a real host
- Result: **Not run.** Scenario A (free read) at minimum; B with a funded wallet; D for nodes.
- Findings: —

Adversarial review:

- Reviewer/tool: independent Code Reviewer for the 0.1.1 uninstall correction; full-branch `gsd-adversarial-reviewer` still to run before merge
- Result: **Pass for the correction; not run for the full branch.**
- Findings: the first pass blocked on reset after daemon shutdown and on unreachable custom paths being forgotten; it also flagged datamap consent, macOS path wording, missing exact-source bindings and empty installer directories. All were corrected; re-review found no blockers or other findings.

Craft Review:

- Reviewer/tool: two fresh Craft Review passes on the 0.1.1 uninstall correction
- Result: **Pass for the correction; full-branch review not run.**
- CONFORMANCE disposition: permission is now checked before starting or stopping anything; re-review confirmed the finding resolved. The Windows `PATH` wording nit was also resolved. No other findings.

## Drift / scope concerns

- The prototype runs ahead of ADR-0002/0003/0004/0005 and DESIGN §1–3, §7, §8. Deliberate, recorded in the DESIGN note; revise after proof, not before.
- `source-bindings/autonomi.md` is provenance by document and observation, not symbol-level bindings — an ADR-0006 gap accepted for the prototype.
- Two Further-reading links (`developers.autonomi.com/llms.txt`, `facts.json`) are held out until those surfaces are live.
- The licence holder line (“MaidSafe.net Limited”) is for Jim to confirm.
- The `.claude-plugin/` manifests are unverified on a real Claude Code.
- The node route has never been exercised live on `ant` 0.3.x — the same gap the operator skill had.

## Open questions / decisions for Jim

- Merge PR #12 first (recommended — this branch is based on it, so its diff shrinks to the prototype once #12 lands).
- Confirm the licence holder line.
- Who runs scenario A on a real host, and when.
- The public flip: visibility; private vulnerability reporting switched on (SECURITY.md relies on it); About description, website and topics; delete the merged `docs/install-examples` branch.

PR / upstream action gate:

- PR ready to raise? **Raised** — `autonomi-skill-prototype` → `main`, agent-authored, needs an approving review per CONTRIBUTING.
- Jim confirmed PR may be opened? **Yes** (3 Sept 2026).

## Recommended next step

1. Adversarial review on the branch (can run in the cloud).
2. Jim: test-install from the branch on his machine and run scenario A; B if a funded wallet is to hand.
3. Fix or flag findings; approving review; merge.
4. Public flip; website install tabs point at `main`; quickstart prompt loses “confirm 0.3.3”.
5. Trigger eval and Snyk scan; open the community-testing call; revise the ADRs when the evidence is in.

## Handoff note

Non-negotiables: the agent **never sees, requests, generates or handles a private key**; nodes take a public address only; spending is quote-show-wait unless the person explicitly waives it; the token is identified by contract address only; **no invented commands or figures** — trace everything, trust `--help` over the skill; the installed skill never modifies its own files; never edit an Accepted ADR (supersede); branch + PR, never direct to `main`; **PR creation on shared repos, marking ADRs Accepted, and the public flip are Jim-approval gates.**
