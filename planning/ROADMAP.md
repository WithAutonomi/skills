## Overview

| Phase | Name | Goal | Status |
| ----- | ---- | ---- | ------ |
| 01 | Design & de-risk | Lock scope, resolve the gasless-spend dependency, choose repo home | Not started |
| 02 | Author the skill | x0x-shaped SKILL.md + bundled files, on a local repo | Not started |
| 03 | Automate & distribute | Upstream sweep, version manifest, release pipeline, multi-channel | Not started |

---

## Phase 01: Design & de-risk

**Goal:** Enough certainty to author confidently.

**Milestones:**
- [ ] Scope boundary confirmed (one-skill full loop vs narrower)
- [ ] Gasless ANT-spend mechanism understood (evmlib / payment vault) or escalated to David
- [ ] Upstream repo set enumerated and "material change" policy drafted (ADR)
- [ ] Repo home and clean install source decided (ADR)

**Definition of Done:** DESIGN.md substantially complete; key ADRs drafted as Proposed.

## Phase 02: Author the skill

**Goal:** A working, x0x-quality skill on a local repo.

**Milestones:**
- [ ] SKILL.md (why → preflight → install/run → verify → secure wallet → spend-to-store → reference/troubleshooting)
- [ ] Bundled reference files (wallet security, storing data, troubleshooting)
- [ ] Install manifest and version self-check wired in

**Definition of Done:** A clean-context agent runs a node from the skill on devnet/testnet without inventing commands.

## Phase 03: Automate & distribute

**Goal:** Published, auto-updating, multi-channel.

**Milestones:**
- [ ] Upstream-sweep CI → regenerate → versioned release
- [ ] Version manifest hosted on an Autonomi URL
- [ ] ClawHub + skills.sh + Autonomi marketplace + docs pointer

**Definition of Done:** Published; ClawHub security scan passed; auto-update verified across channels.

---

## Delivery scope ladder (product capability tiers)

> A different axis from the build phases above. The phases are *how we build* (design → author → automate); this ladder is *what the skill does* at each release tier. Phase 02 authors these tiers in order, operate-and-earn first. The ADRs (0002/0004/0005) nod to this ladder but don't fix the sequence — it lives here. (@pm to integrate into the phase structure; the custody and gas team-calls noted below are still pending.)

**Tier 1 — Operate and earn**

- Scope: opener → resource preflight → install (`ant` CLI + daemon, fallbacks, verification) → run one and several nodes (count/ports/distribution within diversity limits) → monitor health (status + events) → reward address (the menu of sourcing options) → track rewards/balances → clean uninstall → onward pointers to the later tiers. No new tooling. The skill neither creates nor holds a key at this tier.
- Definition of Done: a clean-context agent, given only the installed skill, runs and monitors a healthy node (one and several) on the **live network**, configures a reward address, can check balances, and cleanly uninstalls — without inventing commands.

**Tier 2 — Secure and reason about ANT** *(gated on the custody decision — ADR-0004, team call)*

- Scope: wallet policy; the agent-managed (secrets-out-of-context) custody path; the user/provisioned path; balance and gas visibility; "what can I do next?" guidance; a declared recovery path required at wallet creation.

**Tier 3 — Spend / store loop** *(gated on the gas-strategy decision — ADR-0005, team call)*

- Scope: a chosen gas strategy; upload/retrieve with ANT + gas (or a funding/paymaster route); the full autonomous earn→store workflow.

---

## Future Phases (Backlog)

- **Phase 04:** Ongoing maintenance driven by upstream releases
- **Phase 05:** Multi-node fairness / distribution guidance
