# ADR-0002: A single holistic operator skill, internally modular

- **Status:** Proposed
- **Date:** 2026-06-17
- **Decision owners:** Jim Collinson
- **Reviewers:** TBD
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0003 (operator scope & boundary), ADR-0004 (non-custodial rewards), ADR-0006 (source-binding), ADR-0007 (standalone repo); vault `spec/VISION.md`, `spec/DESIGN.md`; the x0x skill (`saorsa-labs/x0x`)

## Context

David's brief is triggered by node operation, but it explicitly points beyond it — it asks for agents to "earn tokens to store their own immutable data" and to "use the client libs to use their ANT to store data." So broadening past a bare node-runner is **sanctioned by the brief, not scope-creep**. The capability being asked for is an agent that can **utilise the Autonomi network as a whole**, on behalf of (or independently of) a human. These needs are interrelated, not separable:

- ANT handling is **integral, not ring-fenced** knowledge: to operate a node usefully the agent must securely handle a wallet, receive and secure the ANT it earns, and manage that ANT.
- The point of earning ANT is to **use** the network — chiefly storing and retrieving its own data; if the agent wants to do that, it must know how.
- If earnings fall short of what it wants to store, it needs to understand how to **acquire more ANT**.
- At the frontier, "using" shades into "building on" the network.

Each is another seam the skill can progressively disclose. Shipping them as a suite of separate installs is poor ergonomics and splits the safety-critical money seam (custody must be present the instant a node earns — see ADR-0004). The model that fits is x0x's, which threads exactly this kind of progressive disclosure elegantly through a single `SKILL.md`: one modular skill that routes by task and leans on external resources for depth — an expandable entry point, not a fixed monolith and not a suite.

## Decision Drivers

- The real goal is whole-network utilisation; node operation is the first story, not the ceiling.
- The earning↔custody seam must never be split across installs.
- One obvious, expandable front door; avoid making agents install a collection of skills.
- Progressive disclosure by task routing manages size and intent without fragmenting installs.
- Lean on external resources (live docs, the Developer skill) for depth and for the build frontier.
- The single-skill, progressively-disclosed model is already proven in the wild by x0x; adopting a proven structure de-risks the approach.

## Considered Options

1. **A suite of separate skills (node / wallet / data / …).** Rejected: poor onboarding (install many to do one job), a missing-dependency window around live funds, and multiplied distribution/security-scan surface.
2. **One undifferentiated monolith.** Rejected: hard to maintain, regenerate, and route; cannot grow cleanly.
3. **One holistic skill, internally modular, progressively disclosed by task routing, and expandable.** Chosen.

## Decision

We will ship **one holistic operator skill**, internally modular and **progressively disclosed by task routing** — the model x0x has already proven in the wild — designed to **expand** from the node-first story toward whole-network utilisation: not a suite, and not a frozen monolith. Disclosure operates at two layers:

- **Intra-skill:** a lean entry routes by the agent's task/intent to bundled modules (node operation / money: wallet + payment / data storage / …) and templates, loaded on demand.
- **Outward:** the skill routes/onboards to external resources and other skills for depth — live docs, and the Developer skill at the build frontier (per ADR-0003) — exactly as x0x leans on its own reference docs.

The **first pass** delivers the complete node-operate-and-earn story (including the ANT handling required to earn and secure). Later passes extend coverage (use earned ANT to store data, acquire more ANT, onward to building) by **adding modules and routing, not by spawning sibling installs**.

Invariants:
- One install; the capability grows by adding modules/routing, never by requiring a second install for the core job.
- Disclosure is by task/intent routing (intra-skill) and by routing to external resources/skills (outward).
- The node-first first pass is complete for its story; the earning↔custody seam is never split across installs.
- The build frontier routes to the Developer skill (ADR-0003); this skill stays an operator/use skill.

## Consequences

### Positive

- A single front door that grows with the network's use cases; no suite to assemble.
- No missing-dependency gap around live funds; progressive disclosure manages size.
- Matches the proven x0x model (modular, progressively disclosed, leans on other resources).

### Negative / Trade-offs

- One version number spans several upstream concerns — mitigated by per-module source-binding (ADR-0006).
- A broader trigger/description than a narrow single-purpose skill; routing quality becomes load-bearing.

### Neutral / Operational

- Internal modularity and clean routing are hard requirements, not options.
- The expandable end-state is the north star; each pass must still ship a complete story for what it covers.

## Validation

A clean-context agent completes the node-operate-and-earn journey from a single install with no second install required. Adding a later capability is demonstrably a module/routing addition, not a new install. Review confirms: no safety-critical step depends on a separate install; intra-skill and outward routing work; and the build frontier defers to the Developer skill.

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR.
