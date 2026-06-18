# ADR-0003: Operator scope, boundary, and interface stance

- **Status:** Proposed
- **Date:** 2026-06-17
- **Decision owners:** Jim Collinson
- **Reviewers:** David Irvine
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0002 (single skill); the Autonomi Developer skill (`WithAutonomi/autonomi-developer-docs`); the x0x skill (`saorsa-labs/x0x`)

## Context

An Autonomi **Developer skill** already exists: a knowledge package for building *on* Autonomi (libraries, SDK, codebase). This skill is different in kind — it is for an agent *operating and using* the network. Without a sharp boundary, an "operator" skill drifts into network-design exposition or duplicates the Developer skill. There is also an interface question: node operation is exposed today by the `ant` CLI and its local node-management daemon; the only Autonomi MCP server (`antd-mcp`) covers client data/wallet operations and exposes **no** node-operation tools. The quality reference, x0x, hands agents a CLI plus a local daemon REST/WS API and builds no bespoke tooling.

## Decision Drivers

- Clear separation from the Developer skill: *operate/use* (doing) vs *build* (knowledge).
- Use the interfaces that exist; do not build infrastructure in this work.
- Functional guidance grounded in real tooling, not network-internals exposition.
- David's brief asks that agents be pointed toward building on the network; the build boundary should be a signposted onward path, not a dead-end.

## Considered Options

1. **Build agent-native tooling (e.g. a new MCP) for node operation.** Rejected for this work: out of scope, adds infrastructure to own and keep current, and no upstream node-operation MCP exists to wrap.
2. **Document the existing surfaces (CLI + local daemon; existing `antd`/`antd-mcp` for data/wallet).** Chosen.
3. **Defer all storage/use to the Developer skill.** Rejected: *using* the network (CLI uploads, wallet, monitoring) is operator territory; deferring it would hollow out the skill's purpose. We defer only *building on the libraries*.

## Decision

This is an **operator skill**: it teaches operating and using the Autonomi network through the **existing** interfaces — primarily the `ant` CLI and its local node-management daemon for node operation, and the `ant` CLI / `antd` gateway / existing `antd-mcp` for data and wallet operations. It introduces **no new tooling** (no new MCP, daemon, or binary) in this body of work. Building applications on the libraries/SDK is the Developer skill's domain; at that boundary this skill provides onward pointers — "further reading" to the Developer skill, the developer docs, and the relevant upstream repos — rather than teaching or duplicating how to build. The boundary is a signpost, not a dead-end.

Invariants:
- Document and drive **existing** upstream interfaces; build no new tooling here.
- Node operation is taught via the CLI + local daemon (no node-operation MCP exists upstream; we do not add one).
- Maintain the operate/use vs build boundary by cross-referencing the Developer skill, not duplicating it.
- Include onward pointers ("further reading") to building resources — the Developer skill, developer docs, and upstream repos — at the frontier; signpost the path to building, don't teach it.
- Content is functional (what to do, and the parameters needed to decide), not network-design exposition for its own sake.

## Consequences

### Positive

- No infrastructure to build or maintain; the skill tracks upstream surfaces.
- A clear lane distinct from the Developer skill; less duplication risk.

### Negative / Trade-offs

- The skill is constrained to what upstream exposes — e.g. node operation is CLI/daemon only, with no agent-native MCP.

### Neutral / Operational

- A future agent-native interface (e.g. an Autonomi node MCP) would be a separate future decision, not part of this work.

## Validation

Review confirms the skill introduces no new tool/daemon/MCP and that every operating command maps to an existing upstream surface. The boundary with the Developer skill is handled by cross-reference, not duplication. A clean-context agent operates using only documented existing commands.

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR.
