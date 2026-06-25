# Handoff — review entry & continuity

> **For:** Hermes (review) and David (gate-holder). **From:** Jim. **Date:** 2026-06-25.
> **Heads-up:** Jim is **off-grid from 2026-06-26 for ~2 weeks (back ~2026-07-10)** — no connectivity, can't unblock anything. This doc is written so the team can keep moving without him.

## TL;DR

The `autonomi` skill — teaching an agent to run Autonomi nodes and earn ANT, non-custodially — is rebuilt, source-bound, agent-tested, and ready to review. It's on the **`rebuild-skill`** branch at `skills/autonomi/`. This handoff maps everything, states what you can decide while Jim's away, and how to test.

**Start here:** `README.md` → `skills/autonomi/SKILL.md` → its `references/` → this doc → `planning/REBUILD-BRIEF.md` (the full rationale) → `docs/adr/`. Then run the test in `planning/TESTING.md`.

## Where the work lives (branches)

| Branch | Contents | Open as PR for review |
| --- | --- | --- |
| **`rebuild-skill`** | The rebuilt skill (`skills/autonomi/` + `references/`), new `README.md`, this handoff, `TESTING.md`. Old root-level skill + `templates/` removed. | → `main` — the main review |
| **`docs/rebuild-brief`** | `planning/REBUILD-BRIEF.md` (the contract/rationale) + `planning/release-endpoint-accessibility.md` (the binary-hosting flag). | → `main` — planning context |
| **`docs/skills-repo-naming-distribution`** | ADRs **0007** (repo), **0008** (distribution), **0012** (skill naming) — Proposed. | → `main` — decision lane |

Keep the lanes separate (skill content vs. decisions vs. planning) — don't bundle the ADR decisions into the skill PR.

## Governance while Jim is away

Agreed model: **David + Hermes self-approve within bounds.**

- **Proceed freely (review + merge):** skill content and wording, `references/`, `docs/` prose, `README`, `planning/` notes, troubleshooting, tests, bug fixes, source-binding corrections. Use branch + PR; David approves Hermes's PRs and vice-versa.
- **Hold until Jim is back (or take to the wider team):** the **org transfer** to `WithAutonomi` and any **repo/skill renaming**; **architecture / protocol / security** decisions and marking those ADRs **Accepted**; **distribution-channel** changes; anything touching **keys / custody / spend** (out of scope for the skill anyway). These aren't blockers for improving the skill — they're the few things to leave parked.
- The **release-endpoint** item (below) is an upstream `ant-client` change — raise with the wider MaidSafe team, not gated on Jim.

ADR discipline holds: inspect `docs/adr/` before changing architecture; draft new decisions as **Proposed**; never edit an Accepted ADR (supersede instead).

## State of the skill (what's done)

- **Source-bound:** every command, flag, and figure is tied to upstream `ant-client` / `ant-node` code (see `source-bindings/`). Where a figure leads the docs (the ~20 GB/node disk minimum), it's flagged inline as team-confirmed, pending source.
- **Safety doctrine:** non-custodial (nodes only ever get a public `--rewards-address`); spending/custody is out of scope and gated; daemon stays on loopback; no key handling anywhere.
- **Deliberate capacity model:** the agent decides what to contribute and where (which volume, how many nodes) up front, can place node data on other volumes via `--data-dir-path` (with the human's consent for their media), and monitors capacity over time.
- **Complete teardown:** `references/node-uninstall.md` covers nodes, daemon, CLI, custom/external data dirs, config paths, and a verification step. No OS service is involved (verified in source).
- **Reviewed:** a fresh adversarial pass flagged three things as "invented" that are in fact source-bound + live-tested (`DELETE /api/v1/nodes/{id}`, daemon ordering, network defaults) — docs lag the code. Lesson logged: review against the source manifest, not just the docs.
- **Agent-tested:** an OpenCode agent installed the skill and ran it to the preflight gate, correctly and safely (details in `planning/TESTING.md`).

## Open decisions & Jim's guidance (so you're not blocked)

1. **Org transfer + repo name.** Jim's lean: transfer to **`WithAutonomi/skills`** (repo name `skills`, the org's multi-skill home). Deferred to David's sign-off; **do it after Jim's back** (decision was to stay on `JimCollinson/skills` for now). ADR-0007 / 0012 capture the reasoning.
2. **The three decision ADRs (0007/0008/0012).** Proposed. David can review and refine; per the bounds above, leave them **Proposed** (don't mark Accepted) until Jim's back unless the wider team decides.
3. **Release-endpoint accessibility** (`planning/release-endpoint-accessibility.md`). The `ant` binary serves from a CDN many agent sandboxes block. Directions + a PR-candidate are written up; raise with the wider team — it's an `ant-client` release-workflow change, not a skills-repo one.
4. **Voice/behaviour ADRs not yet written.** The brief (§10) plans three: "no autonomy tiers," "skill voice — no internal vocabulary," and a tightening of ADR-0010 (modes are design-only; two-register voice). Captured as intent; the team can author them.
5. **Keywords / discovery.** A supply-side keyword pass (`earn`, `spare-capacity`, etc.) and the `post-quantum` keyword call are open (brief §8).
6. **Full live end-to-end run.** Not yet done — needs a host with ≥ ~20 GB free, full egress (binary CDN + Arbitrum RPC), ideally no pre-existing nodes. See `TESTING.md`.

## How to test

See **`planning/TESTING.md`** — it has the repeatable agent-run prompt, the evidence so far, and what a full pass needs.

## Contact

Jim is offline 2026-06-26 → ~2026-07-10. **David is the point of contact** in his absence. Feedback that would otherwise go to Jim: leave it in PR comments / `planning/` notes for his return.
