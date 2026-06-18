# Source Map — Autonomi Operator Skill

> **Orientation only — not authoritative.** This map helps an agent *find where operator-relevant truth lives* in upstream code. It is **not** a fact source, and it must **not** be baked into or cited by `SKILL.md`. Authority and judgement live in two places: (1) **`SKILL.md` and its modules** — where the agent exercises judgement about what to say and how to say it; and (2) the **source-binding manifest** (ADR-0006) — where each specific claim is pinned to code (repo / file / symbol / commit). Use this map to know where to look; then read the code, apply judgement, and bind each claim in the manifest. The map can go stale — the code and the manifest cannot be skipped.
>
> Scope is **operator** (run and use the network), not developer/build (ADR-0003): build surfaces route to the Developer skill. The `autonomi-*-docs` repos are secondary cross-checks only, never a binding target — their own READMEs state the upstream code is the implementation truth. Org enumerated 2026-06-18 — 20 repos in `WithAutonomi`.

## Primary operator sources — bind here

### `ant-node` (Rust) — the node binary
- **Reward address (non-custodial):** `--rewards-address`; `src/payment/wallet.rs` — node holds no key, only verifies inbound payments name the address.
- **Node flags / behaviour:** `src/bin/ant-node/cli.rs` *(confirm exact path against the repo)*.
- **Releases:** ML-DSA-65 (FIPS-204) signatures + `SHA256SUMS` — verify before use.
- **Operating-procedure constants (later tiers):** IP/subnet diversity limits; storage auto-scales (no fixed per-node ceiling); close-group size (**read as both 5 and 7 — resolve against code before authoring runbooks**).

### `ant-client` (Rust) — the `ant` CLI + core + node-management daemon (the core operator surface)
- **Command tree:** `ant-cli/src/cli.rs` (+ the node command module under `ant-cli/src/commands/`). **Confirm the Tier-1 command tree directly against this code** — the SPEC's tree currently leans on the dev-docs reference; the binding target is the CLI source.
- **Node lifecycle:** `ant node add | start | stop | status | reset`; `ant node daemon start | stop | status | info` (the node-management daemon — this is the operator "daemon").
- **Install:** `install.sh` / `install.ps1` (repo root; `curl … | bash` / `irm … | iex`) or `cargo build --release --bin ant`.
- **No-key boundary:** `ant-cli/src/main.rs` `require_secret_key()` — `SECRET_KEY` is a private key; `ant wallet address | balance` derive from it, so they are **not** used on the no-key operate-and-earn path. (Balance-without-a-key is the open Tier-1 question.)

## Secondary / later-tier source — pointer, not a Tier-1 binding

- **`ant-sdk`** — the `antd` **data/SDK gateway** (distinct from the node-management daemon above). Relevant to the later "use ANT to store data" tier; external-signer `prepare`/`finalize` in `antd/src/rest/upload.rs`. Its language/mobile **bindings are developer surface — out of scope.**

## Libraries & contracts (development — not operator interfaces)

These are build dependencies the node/client/SDK link against. An operator agent never calls them; at most they are *provenance* for specific constants, only when a claim needs one.

- **`evmlib`** (Rust + Foundry: `src/`, `contracts/`, `abi/`) — the EVM library plus the Solidity payment-vault and ANT-token contracts. **Development, not an operator interface.** Operator relevance is **only** as the provenance for EVM constants (ANT token address, payment-vault address, Arbitrum network config) *if* a later-tier claim needs them (e.g. a read-only on-chain balance check). **Not needed for Tier-1; never a binding target for operator commands.**
- **`ant-protocol`** (Rust) — wire-protocol crate; a library, reference only, no operator commands.

## Out of scope — named so the exclusion is deliberate

- **`ant-keygen`** — *verified*: a **release-signing** utility (ML-DSA-65 signing/verifying release binaries; context `ant-node-release-v1`). Not the EVM wallet, not custody, not an operator tool; only the scheme behind the release signatures the install step verifies. Does **not** change ADR-0004 (no EVM-wallet keygen/keystore upstream).
- **`ant-android`, `ant-swift`, `ant-sdk` language bindings** — developer/build surface → Developer skill.
- **`saorsa-core`, `saorsa-transport`, `saorsa-pqc`, `saorsa-mls`, `ant-quic`, `saorsa-gossip`** — network/transport/crypto internals; the operator does not touch them.
- **`ant-ui`** (GUI), **`self_encryption`**, **`ant-merkle`** (libraries), **`indelible`** (a Go consumer app).
- **`autonomi-developer-docs`, `autonomi-node-docs`, `autonomi-token-docs`, `autonomi-learn-docs`, `autonomi-app-docs`, `autonomi-roadmap`** — secondary docs (agentically assembled, verification-stamped). Research / cross-check only; never the binding target.

## Verified anchor facts (with pins)

- **Install:** ant-client `install.sh` / `install.ps1`, or build `--bin ant`. *(verified: dev-docs `use-the-cli.md` @ `84332e2d`; confirm script behaviour against the repo.)*
- **Non-custodial node:** node configured with public `--rewards-address` only; no key on the node. *(ant-node `src/payment/wallet.rs` — read.)*
- **No-key boundary:** `ant wallet balance|address` need `SECRET_KEY`. *(ant-client `ant-cli/src/main.rs::require_secret_key` — read.)*
- **`antd` external-signer:** `prepare`/`finalize`, key never enters the daemon — an integration seam, not custody. *(ant-sdk `antd/src/rest/upload.rs` — read.)*
- **Releases signed:** ML-DSA-65 (FIPS-204) + `SHA256SUMS`. *(scheme/context confirmed via ant-keygen README.)*
- **Health:** `ant node status`; daemon `/api/v1/events` SSE; `--metrics-port` exists but no `/metrics` endpoint served — do not scrape.
- **No gasless path; `permit` not a usable payment route.** *(evmlib; spend/gas tier — provenance only.)*

## Source-of-truth stance

The map is **orientation**. Binding authority is the **source-binding manifest** (ADR-0006): each claim pinned to code — repo / file / symbol / commit (`source_evidence`), with compatibility (`tested_with` / `requires_min` / `known_incompatible`) a separate axis (ADR-0009). Judgement about *what the skill says* lives in `SKILL.md`. Docs repos are secondary cross-checks. Re-verify the command tree against `ant-client` source during authoring rather than trusting the dev-docs mirror.
