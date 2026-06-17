# ADR-0007: Standalone repository and release lifecycle for the skill

- **Status:** Proposed
- **Date:** 2026-06-17
- **Decision owners:** Jim Collinson
- **Reviewers:** TBD
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0002 (single holistic skill), ADR-0006 (source-binding); the Autonomi Developer skill (`WithAutonomi/autonomi-developer-docs`); vault `spec/DECISIONS.md`

## Context

This skill is a **synthesis**. To teach an agent to use Autonomi as an operator, it must draw on and reconcile **multiple upstream repositories** — covering, among others:

- operating a node (`ant-node`);
- the CLI and the node-management daemon (`ant-client`);
- ANT tokens — holding them, and what they can be used for, such as storing data (`evmlib`, `ant-protocol`, the token docs);
- data and the network beneath it (`self_encryption`, `saorsa-core`), plus the node and developer documentation.

No single upstream repository encapsulates all of these moving parts from a functional, **agent-as-user** perspective — which is precisely what this skill sets out to do. So there is no existing repo where it naturally lives: embedding it in any one of them (a single code repo, or a docs repo) would misrepresent its cross-cutting scope and couple it to that repo's lifecycle. It is a synthesis job, and it deserves a repository of its own.

The supporting reasons reinforce this. It is an **operator skill** (action), not documentation (a discrete knowledge collection); it references upstream binaries; it carries its own automation (an upstream-sweep and version manifest, per ADR-0006) and verification workflow, maintained by multiple agents; and it needs to be **installable and accessible from anywhere**, independent of any one repo's structure. Co-locating it in — or installing it from — a docs repo (as the Developer skill does) is one option that was considered, but a docs-repo URL is an odd marketplace for an operator skill and couples unrelated cadences. The likely reviewer question — "why a separate repo?" — is answered by the synthesis nature above.

## Decision Drivers

- The skill synthesises across multiple upstream repos — no single repo is its natural home.
- It must be installable and accessible from anywhere, independent of any one repo.
- Independent lifecycle and release cadence, decoupled from the docs site.
- A distinct mandate from the documentation project: action/skill, not a knowledge collection.
- Its own automation (upstream-sweep, version manifest) and verification workflow.
- Cross-repository ADR/governance consistency with the Autonomi/Saorsa portfolio.

## Considered Options

1. **A task/sub-stream under the Autonomi 2.0 documentation work.** Rejected: different mandate and lifecycle; too much (binaries, automation, multi-agent, releases) to ride as a docs task.
2. **Live inside one upstream code repo (e.g. `ant-node` or `ant-client`).** Rejected: the skill spans several repos; no single one covers what it references, so embedding it in one misrepresents its scope and couples it to that repo's lifecycle.
3. **Co-locate in / install from a docs repo (`autonomi-node-docs`, as the Developer skill does).** Rejected: docs repos hold discrete, knowledge-based collections, not skill/action content, and do not span the multi-repo surface this skill needs; a docs URL is an odd install home and couples release cadences.
4. **Its own standalone repository and project.** Chosen.

## Decision

The skill lives in its **own repository**, with its own ADRs, specs, and release lifecycle — because no upstream repo is its natural home (it synthesises several) and it must be installable and accessible from anywhere. It is **not** a sub-stream of the documentation project and is **not** installed from `autonomi-node-docs`. `docs.autonomi.com/node` becomes a pointer to the skill, not its source. The repository mirrors the portfolio ADR governance for consistency.

Invariants:
- Own repo, own ADRs/specs, own release lifecycle and automation.
- Not embedded in, nor installed from, any single upstream code or docs repo; it references many and belongs to none.
- The docs site is a pointer, not the source.
- PR / merge / publish against any shared or upstream repo is a maintainer-approval gate.

Open (not decided here): the GitHub organisation/home and the clean install URL — a David/maintainer decision. The repo starts local.

## Consequences

### Positive

- A single canonical home for a multi-repo synthesis, installable and accessible from anywhere.
- Independent, ergonomic release and install path; a clear mandate separate from docs.
- Room for the skill's own automation and verification without entangling any upstream repo.

### Negative / Trade-offs

- Another repository to maintain; the GitHub home and install URL remain open decisions.

### Neutral / Operational

- The repo adopts the same ADR governance as the rest of the portfolio (ADR-0001) for consistency.

## Validation

The repository carries its own ADRs, specs, and (later) release artifacts, references multiple upstream repos without belonging to any of them, and the skill installs without depending on a docs or single-code repo. The open items (GitHub org/home, install URL) are resolved with the maintainer before publish.

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR.
