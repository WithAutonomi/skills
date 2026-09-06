<!--
Keep this light. Fill in what's relevant and delete sections that don't apply to your change.
The aim: a reviewer — human or agent — can understand this PR and sanity-check its quality in a couple of minutes.
-->

## Summary

<!-- What does this change, and why? Lead with the outcome, in 1–3 sentences. -->

## Description

<!-- The detail: key files touched, decisions made, and what a reviewer should look at first. -->

## ADR alignment

<!-- The decisions this rests on or changes — see docs/adr/. -->

- Aligns with: <!-- e.g. ADR-0006 (provenance), ADR-0008 (skill-led distribution), ADR-0010 (human register), ADR-0013 (freshness) -->
- Architectural change? <!-- If yes, this PR must add or update a Proposed ADR, or link the one it implements. Never edit an Accepted ADR — supersede it (docs/adr/README.md). The prototype's known divergence from ADR-0002/0003/0004/0005 is recorded in docs/DESIGN.md; don't widen it silently. -->

## Fits the vision, design & the person

<!-- A quick gut-check that we're not drifting from who we serve or what we're building. A short note is enough. -->

- [ ] Consistent with VISION (purpose, audience, principles) and the prototype note in DESIGN.
- [ ] Considered the person on the other end — not necessarily a developer or crypto-literate — and the plain-language register / escalation model (ADR-0010, ADR-0014).
- Note: <!-- e.g. "reference wording only; no change to what the agent does" -->

## Security

- [ ] No secrets in the diff — no private key, seed phrase, `SECRET_KEY`, or `AUTONOMI_WALLET_KEY` value in code, examples, or logs.
- [ ] The key line is intact — the agent never asks for, accepts, reads, prints, transmits, or generates a private key; nodes take a public address only; a paid write uses a `SECRET_KEY` the person provisions outside the conversation, or the person runs the command; a key appearing in context means stop, new wallet, move funds.
- [ ] Spending stays quote-show-wait by default; public uploads happen only when the person chose public; venues, addresses, and prices come from the verified table or a fetched official page, never memory.
- [ ] Install stays detect-first and read-before-run (no `curl | sh`) and does not mutate an existing working setup without affirmative remit; any download/verify step is documented and traced (ADR-0009, ADR-0014).

## Quality & verification

- [ ] Every Autonomi-specific command, flag, constant, URL, figure, and install behaviour has explicit provenance; temporary team-confirmed exceptions are labelled pending upstream authority, and platform-specific shell/OS behaviour is checked rather than guessed (ADR-0006).
- [ ] `python3 scripts/adr-governance.py` passes.
- [ ] Static checks from `planning/TESTING.md` §3 run (spec validation, vocabulary lint, fact check, length).
- [ ] Gauntlet (for merge-candidate skill changes): clean-context run of the relevant scenario on a real host + adversarial review — <!-- done / not yet / N/A -->
- [ ] Docs updated (README / DESIGN note / TESTING / HANDOFF) if a surface or behaviour changed.

## Distribution & metadata

<!-- Only if this touches skills/autonomi/. -->

- [ ] Frontmatter valid per agentskills.io — `name` matches the folder, `description` ≤ 1024 chars, `compatibility` ≤ 500, `license`, `metadata.version`.
- [ ] `skills/autonomi/VERSION`, frontmatter `metadata.version`, `.claude-plugin/plugin.json`, and `.claude-plugin/marketplace.json` were bumped together when a shipped file changed.
- [ ] The loaded skill component contains only `SKILL.md`, `VERSION`, and `references/` under `skills/autonomi/`; repo-side files possibly cached with a channel package are not loaded as skill instructions; no hard-coded tool version appears outside the dated *Verified against* table.
- [ ] Supported install/update channels and the current signature/checksum verification status are stated accurately; OpenClaw/ClawHub is not claimed as supported while its installer contract is unmet (ADR-0008).
- [ ] Expected to pass the skill-directory scanners (no piped installs, no secrets, no service changes); `.claude-plugin/` manifests remain valid if the skill's name or description changed.

## For reviewers

<!-- WIP or ready to merge? What should review focus on? Any known follow-ups? -->
