# Skill grounding brief + reference set (for the SKILL.md opener) — DRAFT

> Fills the two gaps in SKILL.md: (1) the "what Autonomi is / why run a node" opener (DESIGN §2 item 1 — "David's brief"), and (2) an external about/references section (DESIGN §11 / ADR-0008). Design-lane draft for OpenCode to weave into SKILL.md. The *why / purpose* framing traces to **David's brief + VISION** (vision, not code); the *factual* claims are source-bound via the Tier-1 manifest. **The opener is canonically David's brief — this is a neutral draft for David to bless or adjust.**

---

## A. Grounding opener (draft for the top of SKILL.md)

### What Autonomi is

Autonomi is a decentralised network for **permanent, private data storage**. Data is split into pieces, encrypted, and spread across many independent **nodes** run by people and agents around the world — there are no central servers. The network pays those who provide that storage in **ANT**, its token.

### Why run a node

Running a node does two things at once:

- **It helps secure the world's data.** Your node stores encrypted pieces of other people's data and keeps them available — contributing storage to a shared, resilient network.
- **It earns ANT.** The network pays your node in ANT for storing data that others have paid to store.

What that earned ANT is for: its **primary** purpose is to **store your own data permanently** on the network — the loop Autonomi is built around. But ANT is also a tradeable token, so running nodes is equally a legitimate way to **put spare storage and bandwidth to work and earn** — for yourself, or for the human you operate for.

The network is strongest when nodes are **well-distributed, reliable, and run fairly** — many right-sized nodes across different connections, kept healthy, rather than a few large ones crammed in one place. This skill helps you do exactly that.

### What this skill does (and the safety line)

This skill teaches you to **operate and use** Autonomi — first to run and manage nodes and earn ANT, then (as you grow) to secure that ANT and use it to store data. It is **non-custodial by default**: a node is only ever given a **public address** to receive earnings — never a private key — so running nodes is safe to do autonomously. Spending ANT is a separate, deliberate step that stays under human authority.

It's written for **agents operating the network** — often on behalf of a human, sometimes fully autonomously. (To *build applications* on Autonomi, use the Autonomi Developer skill instead.)

---

## B. About & references (draft for an "About / further reading" section)

> Provenance and pointers. These are **references and further reading, not authority** — the skill's facts are bound to upstream *code* via the source-binding manifest, not to these pages (docs sites can lag the code).

**About this skill.** Built and maintained by the Autonomi / MaidSafe team (kicked off from a brief by David Irvine). It synthesises operator-relevant truth from the upstream Autonomi repositories into one agent-facing skill. Source: `github.com/JimCollinson/autonomi-skill` *(GitHub home TBC)*.

**Autonomi — project & docs**
- Project site: `autonomi.com` *(confirm)*
- Node operators (human entry point): `docs.autonomi.com/node`
- Developer docs: `docs.autonomi.com/developers`

**Upstream repositories it synthesises** (`github.com/WithAutonomi`)
- `ant-client` — the `ant` CLI + node-management daemon (the operator surface)
- `ant-node` — the node binary
- `ant-protocol` — the wire protocol
- `evmlib` — EVM constants + the read-only token-balance path (ANT on Arbitrum One)
- `self_encryption` — how data is split and encrypted

**Related skills**
- Autonomi Developer skill — building *on* Autonomi: `github.com/WithAutonomi/autonomi-developer-docs`
- x0x — the structural precedent / quality bar (not a dependency): `github.com/saorsa-labs/x0x`

---

## Notes for review / for OpenCode

- **David's blessing:** the opener is meant to be his brief — please check the "why run a node" framing against what he wants said (the "secure the world's data" + earn→store loop). Kept neutral and non-promotional per VISION ("document reality; neutral on economics").
- **Source-grounding split:** the factual lines (ANT as the network's token on Arbitrum One, non-custodial public address, nodes store encrypted chunks, distribute for health) are already bound in `source-bindings/tier1-operate-and-earn.md` / resolved by the source research; the *purpose/why* lines trace to David's brief + VISION (judgement-derived, not a code pin) — record them that way, don't invent a source pin for them.
- **Links to confirm before publish:** `autonomi.com` and the exact `docs.autonomi.com/*` paths. The `github.com/WithAutonomi/*`, x0x, and skill-repo URLs are verified.
- **Placement:** opener → top of `SKILL.md` (before "Use this skill when…"); About/references → a short section near the end, or its own `references/about.md` if it grows.
- **Register:** opener follows the ADR-0010 plain register — meaning before mechanics, no crypto jargon in the first read; precise terms (ERC-20, Arbitrum One) live in the modules/manifest, not the opener.
