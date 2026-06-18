# Autonomi Operator Skill — Vision

## Purpose

An auto-updating, agent-facing skill that teaches an AI agent to **operate and use the Autonomi network** — starting with running and managing nodes, and expanding (via progressive disclosure) toward using the network as a whole: handling the ANT that nodes earn, storing and retrieving data, acquiring more ANT when needed, and — at the frontier — routing onward to building on Autonomi.

It is **one modular operator skill, not a suite**: a lean entry that routes by the agent's task to bundled modules and leans on external resources for depth (the x0x model). The **first pass** delivers the complete node-operate-and-earn story; the skill is designed to grow toward full-network utilisation by adding modules and routing, never by requiring a collection of installs.

It is an **operator skill** — about *doing and using*, not *building* — deliberately distinct from the Autonomi Developer skill (a *knowledge* package for building applications on Autonomi). At the build frontier it routes to the Developer skill rather than duplicating it.

## Goals

1. Give an agent everything it needs to **decide to run, and successfully run and manage one or more Autonomi nodes** — the why, a resource-fit check, the exact commands, multi-node operation, health monitoring, and good-citizen operating procedures.
2. Teach the agent to **receive and handle the ANT it earns** — node operation is non-custodial by construction (the node holds no key); reward-address sourcing is a neutral menu (supplied / provisioned / agent-created), with agent-created first-class for autonomous use via an out-of-context custody substrate (the private key never enters the agent context; a recovery path declared at creation); plus how earning works and how to check the balance.
3. Document, honestly, **how earned ANT is used to store data** on the real, current payment path (ANT plus native gas) — without inventing or assuming a gas-abstraction mechanism that does not exist upstream; surface the gas constraint as a known limitation and route to live docs for spend depth.
4. Be **expandable toward whole-network use** — using ANT, acquiring more when short, storing and retrieving data — through progressive disclosure by task routing, not through extra installs.
5. **Stay current automatically** — content derived from and source-bound to upstream, with an in-skill version self-check, structured so a future upstream-sweep can regenerate it.
6. Be **widely distributed and easy to install** at x0x-level quality, passing security scans.

## Non-Goals

- Not developer documentation or "how to build apps on Autonomi" — that is the Developer skill. Route, do not duplicate.
- Not a node binary or a reimplementation of `ant-node` — it instructs the use of upstream binaries and tooling.
- Not a builder of new tooling (no new MCP, daemon, or binary) in this work — it uses existing CLI and daemon surfaces.
- Not inventing network or payment mechanisms (e.g. gas abstraction) — it documents reality and escalates gaps.
- Not a suite of separate installs.
- Not Autonomi 1.0 / MaidSafe-era content; no GUI in the first pass (agent-driven CLI/daemon operation).

## Success Criteria

- **First pass:** a fresh agent, given only this skill, can explain why to run a node, check machine fit, install and run one and several nodes on the **live network**, monitor health, configure a non-custodial rewards address, and check and secure earnings — without inventing commands — with clear onward pointers for using ANT (storing data) and acquiring more.
- The skill grows by adding modules and routing, not new installs.
- Installed copies self-report staleness; content traces to upstream sources.
- Passes the security scan; structure and quality on par with the x0x skill.

## Target Users / Audience

Primary: **AI agents as operators and decision-makers** — managing, configuring, and optimising nodes and network use — **usually, but not necessarily, on behalf of a human** (Fae and similar, including autonomous, altruistic, and background operation). Secondary: humans arriving via `docs.autonomi.com/node` as a non-primary entry point.

## Key Principles

- **One modular skill, progressively disclosed by task routing.** Not a suite and not a frozen monolith; route by intent to bundled modules, lean on external resources for depth, and expand by adding modules.
- **Node-first, whole-network-bound.** Start with the complete node story; grow toward using the network as a whole.
- **x0x is the structural precedent and quality bar** — a proven pattern we draw on, not a dependency.
- **Operate autonomously, spend under authority.** Running and optimising nodes is non-custodial and can be fully autonomous; spending real ANT is the gated money line.
- **Document reality; don't invent.** Everything is derived from and source-bound to upstream; route to live facts for volatile detail; never assert mechanisms that don't exist.
- **Equip judgment with a neutral menu.** At every choice point — how many nodes, which path to ANT, whether to spend — give the agent an accurate, useful, user-friendly, and reasonably neutral menu of options for its use case, plus the live means to assess them. The skill's purpose is to inform the agent's judgement, not to make the decision for it.
- **Safety around funds.** Default to non-custodial; make irreversibility explicit; never put a key on a node or in the repo.
- **Cooperative framing.** Running nodes helps secure the network's data; earning ANT is the means to use the network.

---

## Background

Kicked off by a brief from David Irvine; the verbatim brief and the full design discussion are captured in the project's kickoff notes (in the paired vault). The brief is triggered by node operation, but the capability is broader: an agent that can utilise the Autonomi network as a whole. These needs are interrelated — operating a node usefully requires handling the ANT it earns; the point of earning is to use the network; if earnings fall short, the agent needs more ANT. So these are treated as interrelated, overlapping task journeys — entered by task and routed through a single modular skill, node-first — rather than one linear loop or a suite of separate domains.

## Related

- Reference: the x0x skill (`saorsa-labs/x0x`) and the Autonomi Developer skill (`WithAutonomi/autonomi-developer-docs`).
