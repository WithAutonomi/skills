# GSD Work Packet: npm-first client installation

Date: 2026-09-24
Role: Implementer / verifier, OpenCode
Stage: Implementation, then PR preparation
Repo: [WithAutonomi/skills](https://github.com/WithAutonomi/skills)
Base: `69ca49452e7555f607646bc9f023718bf43cd046`
Branch: `autonomi-npm-install`
Authority: Jim approved implementation and local commits. On 24 September, after the Claude review was blocked, he directed: "Don't worry about the Claude review. Please can we just assemble a PR for this, and I can get it reviewed by Hermes?" This authorises pushing this branch and opening its PR into `main`, with Hermes review replacing the Claude gate for this change. Merge is not authorised.

## Goal and scope

Prefer `npm install -g @withautonomi/ant` when the client is absent and suitable Node.js/npm are available. Keep the main skill short, name both direct-install fallbacks there, and put their commands in the bundled installation reference. Preserve detection, product-identity checks, authority, existing working installations and retained user state.

Read first: `CONTRIBUTING.md`, `planning/TESTING.md`, `planning/HANDOFF.md`, `docs/DESIGN.md`, Proposed ADR-0006/0008/0009/0013/0014, current skill and references, `source-bindings/autonomi.md`, and pinned ant-client npm source.

Allowed changes: skill setup/compatibility/update/removal instructions; installation reference; four synchronized version surfaces; README; npm source evidence; installation-related current-state/design/source-map notes; testing instructions and a reproducible disposable npm proof; checkpoint and PR draft.

The test-procedure update is explicitly in scope: add npm install/update/removal coverage, including the supported launcher, while retaining existing direct-binary collision and retained-state checks. This is not permission to weaken checks. Existing CI, governance script, harness adapters and machine-wide environment remain unchanged.

Out of scope: OpenClaw support, skill distribution channels, node lifecycle changes, paid writes, wallet/key access, public listing, archived material, broad ADR reconciliation, production installation on Jim's machine.

## Alignment

This changes how the existing upstream client is obtained, not its capabilities or the skill's distribution channels. Source-bound content, detect-first lifecycle and channel-owned skill updates remain intact. Existing Proposed ADR-0008/DESIGN tensions over universal signature verification and state-deleting uninstall remain explicitly unresolved; npm packaging checks must not be described as local release-signature verification. Jim's approved npm removal scope removes the package and launchers, never retained application/user state.

## Verification and rigor

Meaningful shared-repo work: full scoped review. Unattended mode: No.

- Run `python3 scripts/adr-governance.py` and `git diff --check`.
- Run existing static requirements: equivalent frontmatter validation if `skills-ref` is unavailable, vocabulary/length, synchronized versions/plugin JSON, links, provenance and skill discovery.
- Exercise npm in a disposable prefix/home only: latest install, identity/help, existing-install preservation, approved package update, retained-state preservation on explicit uninstall. No real-home mutation, wallet, paid write, node or daemon operation. Disposable state and commands must be recorded for reproduction.
- Attempt scoped clean-context installation/free-read verification on a real host, Craft Review at this unit's checkpoint, and one adversarial review at the PR-preparation gate. Record unavailable checks as gaps, never passes.
- Owner override, 24 September: Claude clean-context review not required for this PR; Hermes review and Jim's merge decision remain. Existing local evidence, Craft and adversarial reports are retained. This waiver does not turn unperformed tests into passes or authorise changes to the shared review lock.
- No `.gsd/gate.sh` exists. The CI arbiter is `.github/workflows/adr-governance.yml`, path-filtered to ADR/governance changes; no installation-test CI arbiter exists, so installation evidence is weaker. No CI changes in this work.
- No failure dismissed as pre-existing/environmental without base reproduction. No secrets, borrowed credentials, or new paid tooling. Snyk runs only if its existing credential is available; otherwise report not run.

## Stop conditions and output

Stop for architectural/security-policy conflicts beyond the already recorded prototype divergences; gate/CI changes; real-host mutation; destructive user-state operations; spend; release publication or merge. Only this branch push and PR creation are authorised. Preserve unrelated work.

Return the PR URL, exact checks/results, review findings and evidence gaps for Hermes. Leave a current handoff. Do not call the candidate merge-ready before Hermes review and Jim's decision.
