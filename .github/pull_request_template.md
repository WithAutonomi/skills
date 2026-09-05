<!--
Keep this light. Fill in what's relevant and delete sections that don't apply to your change.
The aim: a reviewer — human or agent — can understand this PR and sanity-check its quality in a couple of minutes.
-->

## Summary

<!-- What does this change, and why? Lead with the outcome, in 1–3 sentences. -->

## Description

<!-- The detail: key files/modules touched, decisions made, and what a reviewer should look at first. -->

## ADR alignment

<!-- The decisions this rests on or changes — see docs/adr/. -->

- Aligns with: <!-- e.g. ADR-0004 (non-custodial), ADR-0006 (source-binding), ADR-0010 (human register) -->
- Architectural change? <!-- If yes, this PR must add or update a Proposed ADR, or link the one it implements. Never edit an Accepted ADR — supersede it (docs/adr/README.md). -->

## Fits the vision, design & personas

<!-- A quick gut-check that we're not drifting from who we serve or what we're building. A short note is enough. -->

- [ ] Consistent with VISION (purpose, audience, principles) and DESIGN.
- [ ] Considered the operator personas it affects (see DESIGN §13) and the plain-language register / escalation model (ADR-0010).
- Note: <!-- e.g. "default mode only; no change to human-facing copy" -->

## Security

- [ ] No secrets in the diff — no private key, seed phrase, `SECRET_KEY`, or `AUTONOMI_WALLET_KEY` in code, examples, or logs.
- [ ] Non-custodial boundary intact — nodes take a public wallet (rewards) address only; nothing instructs putting a key on a node or in the repo (ADR-0004).
- [ ] Install stays detect-first and non-mutating; any download/verify step is documented and source-bound (ADR-0009).

## Quality & verification

- [ ] Every Autonomi-specific command, flag, constant, figure, and install behaviour has explicit provenance; temporary team-confirmed exceptions are labelled pending upstream authority, and platform-specific shell/OS behaviour is checked rather than guessed (ADR-0006).
- [ ] `python3 scripts/adr-governance.py` passes.
- [ ] Gauntlet (for merge-candidate skill changes): clean-context test + adversarial review — <!-- done / not yet / N/A -->
- [ ] Docs updated (DESIGN / README / references) if a surface or behaviour changed.

## Distribution & metadata

<!-- Only if this touches SKILL.md, the frontmatter, or the install manifest. -->

- [ ] Frontmatter valid and complete — name, description, version, license, keywords.
- [ ] Install manifest (`metadata.openclaw.install`) correct; install and clean-uninstall paths documented; the current signature/checksum verification status is stated accurately, and any implemented verification remains intact (ADR-0008).
- [ ] Won't break packaging, and should pass distribution-channel security scans (e.g. ClawHub).

## For reviewers

<!-- WIP or ready to merge? What should review focus on? Any known follow-ups? -->
