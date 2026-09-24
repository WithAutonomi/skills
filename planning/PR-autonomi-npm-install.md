## Summary

Prefer `npm install -g @withautonomi/ant` when the CLI is missing and suitable Node.js/npm are available. Keep direct Linux/macOS and Windows installers discoverable from the main skill, with commands in the bundled installation reference. Leave working installations and all user/application state untouched.

## Description

- npm-aware setup, ownership checks, updates, removal and download troubleshooting.
- Direct scripts retain fetch/read/run and the checksum-verified manual alternative remains available.
- CLI installation remains separate from skill installation; no OpenClaw support or listing added.
- README and provenance now describe the published npm route, with current handoff and testing expectations.
- Four release surfaces bumped together to 0.1.5.

## Alignment and security

Preserves source-grounded instructions, detect-first lifecycle, identity checks, channel-owned skill updates, authority and state-preserving removal. The previously recorded Proposed-ADR verification/uninstall gaps remain unresolved; this change does not claim packaging-time signature checks are local signature verification. No Accepted records, wallet rules, paid operations, node lifecycle, CI or governance machinery changed.

## Verification

- Local ADR governance, equivalent frontmatter checks, four-version agreement, plugin JSON, vocabulary/length, relative links/anchors, whitespace and skill discovery passed.
- Isolated macOS npm install/identity/help, repeated detection, same-version package update, explicit removal and nine retained-state hashes passed on `ant` 0.3.8.
- Craft Review passed. One fresh adversarial report found no CRITICAL/HIGH content defect; it identified incomplete fresh-agent and committed-revision evidence. The candidate is now committed; fresh-agent evidence remains a limitation.
- No installation-test CI arbiter exists; evidence is weaker. The existing ADR workflow is filtered to governance changes.
- **Claude review not run, explicitly waived by Jim in favour of Hermes review.** Its shared review lock remains untouched. Hermes review and Jim's merge decision are still required.
- Snyk was not run (token absent); Windows/Linux runtime, live-network, wrong-prefix refusal by a fresh agent, and cross-version upgrade checks were not performed in this slice. Do not treat the mechanical proof as agent-behaviour evidence.

Evidence and exact commands: [npm-install checkpoint](https://github.com/WithAutonomi/skills/blob/autonomi-npm-install/planning/evidence/2026-Sep-24-npm-install.md). Scope and owner approval: [work packet](https://github.com/WithAutonomi/skills/blob/autonomi-npm-install/planning/packets/PACKET-autonomi-npm-install.md).

## For Hermes

Focus on npm ownership before update/removal, fallback discoverability, unchanged retained-state safeguards and honest verification wording. The inherited Windows `-ExecutionPolicy Bypass` invocation is carried as a non-blocking review observation, not newly introduced behaviour. Do not infer support across untested platforms or that npm solves peer/network access restrictions.

Start with [the main skill](https://github.com/WithAutonomi/skills/blob/autonomi-npm-install/skills/autonomi/SKILL.md) and [installation reference](https://github.com/WithAutonomi/skills/blob/autonomi-npm-install/skills/autonomi/references/install-and-verify.md), then compare the npm claims with [their pinned upstream sources](https://github.com/WithAutonomi/skills/blob/autonomi-npm-install/source-bindings/autonomi.md). `bash planning/evidence/npm-install-proof.sh` reproduces the disposable macOS/Linux package-lifecycle proof; it must not be repurposed to remove a real installation.

Agent-authored using OpenCode / OpenAI gpt-6-astra; static, Craft and adversarial reviewers used fresh contexts but the same model/provider. Jim authorised this PR specifically for Hermes review. No merge approval is implied.
