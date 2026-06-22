# Skill grounding — opener + references

> Grounding for the SKILL.md opener — what Autonomi is and why run a node — plus an About / references section. The purpose/why framing is product/vision; the factual claims are source-bound via the Tier-1 source-binding manifest.

---

## A. Grounding opener (for the top of SKILL.md)

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

## B. About & references (an "About / further reading" section)

> Provenance and pointers — references and further reading, not authority. The skill's facts are bound to upstream *code* via the source-binding manifest, not to these pages.

**About this skill.** Built and maintained by the Autonomi / MaidSafe team. It synthesises operator-relevant truth from the upstream Autonomi repositories into one agent-facing skill. Source: this repository.

**Autonomi — project & docs**
- Project site: `autonomi.com`
- Start a node (human guide): `docs.autonomi.com/node`

**Upstream repositories it synthesises** (`github.com/WithAutonomi`)
- `ant-client` — the `ant` CLI + node-management daemon (the operator surface)
- `ant-node` — the node binary
- `ant-protocol` — the wire protocol
- `evmlib` — EVM constants + the read-only token-balance path (ANT on Arbitrum One)
- `self_encryption` — how data is split and encrypted

**Related skills**
- Autonomi Developer skill — building *on* Autonomi: `github.com/WithAutonomi/autonomi-developer-docs`
- x0x — the structural precedent / quality bar (not a dependency): `github.com/saorsa-labs/x0x`
