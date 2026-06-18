# Source Map — Autonomi Operator Skill

> Where operator-relevant truth lives in **upstream code**. The skill binds to code (repo / file / symbol / commit) per ADR-0006; this map is navigation + provenance, **not** a copy of the code (which would go stale). Scope is **operator** — run and use the network — not developer/build (ADR-0003): build surfaces (language/mobile SDKs, app development) route to the Autonomi Developer skill.
>
> The `autonomi-*-docs` repos are **secondary cross-checks only, never the binding target** — their own READMEs state the upstream code is the implementation truth, and they are themselves agentically assembled. (Open question Jim flagged: whether we rely on them at all; resolved here as "research/cross-check only.")
>
> Org enumerated 2026-06-18 — 20 repos in `WithAutonomi`. This map seeds the ADR-0006 source-binding manifest.

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

## Secondary / later-tier sources — pointer, not a Tier-1 binding

- **`ant-sdk`** — the `antd` **data/SDK gateway** (distinct from the node-management daemon above). Relevant to the later "use ANT to store data" tier; external-signer `prepare`/`finalize` in `antd/src/rest/upload.rs`. Its language/mobile **bindings are developer surface — out of scope.**
- **`evmlib`** (Rust) — EVM/payments (ANT ERC-20, gas, token contract address). Reference for the spend/gas tier; for Tier-1, only the "reward address is an EVM address on **Arbitrum One**" fact.
- **`ant-protocol`** (Rust) — wire-protocol crate; reference, not operator-facing commands.

## Out of scope — named so the exclusion is deliberate

- **`ant-keygen`** — *verified*: a **release-signing** utility (ML-DSA-65 signing/verifying release binaries; context `ant-node-release-v1`). Not the EVM wallet, not custody, not an operator tool; only the scheme behind the release signatures the install step verifies. Does **not** change ADR-0004 (no EVM-wallet keygen/keystore upstream).
- **`ant-android`, `ant-swift`, `ant-sdk` language bindings** — developer/build surface → Developer skill.
- **`saorsa-core`, `saorsa-transport`, `saorsa-pqc`, `saorsa-mls`, `ant-quic`, `saorsa-gossip`** — network/transport/crypto internals; the operator does not touch them.
- **`ant-ui`** (GUI), **`self_encryption`**, **`ant-merkle`** (libraries), **`indelible`** (a Go consumer app).
- **`autonomi-developer-docs`, `autonomi-node-docs`, `autonomi-token-docs`, `autonomi-learn-docs`, `autonomi-app-docs`, `autonomi-roadmap`** — secondary docs (agentically assembled, verification-stamped). Research / cross-check only; never the binding target. (`autonomi-developer-docs` carries `repo-registry.yml` / `component-registry.yml` — a useful inventory, not authoritative for behaviour.)

## Verified anchor facts (with pins)

- **Install:** ant-client `install.sh` / `install.ps1`, or build `--bin ant`. *(verified: dev-docs `use-the-cli.md` @ `84332e2d`; confirm the script behaviour against the repo.)*
- **Non-custodial node:** node configured with public `--rewards-address` only; no key on the node. *(ant-node `src/payment/wallet.rs` — read.)*
- **No-key boundary:** `ant wallet balance|address` need `SECRET_KEY`. *(ant-client `ant-cli/src/main.rs::require_secret_key` — read.)*
- **`antd` external-signer:** `prepare`/`finalize`, key never enters the daemon — an integration seam, not custody. *(ant-sdk `antd/src/rest/upload.rs` — read.)*
- **Releases signed:** ML-DSA-65 (FIPS-204) + `SHA256SUMS`. *(scheme/context confirmed via ant-keygen README.)*
- **Health:** `ant node status`; daemon `/api/v1/events` SSE; `--metrics-port` exists but no `/metrics` endpoint served — do not scrape.
- **No gasless path; `permit` not a usable payment route.** *(evmlib; spend/gas tier.)*

## Source-of-truth stance

Bind to **code**: repo / file / symbol / commit (ADR-0006 `source_evidence`). Tool compatibility (`tested_with` / `requires_min` / `known_incompatible`) is a separate axis (ADR-0009). Docs repos are secondary cross-checks. Re-verify the command tree against `ant-client` source during authoring rather than trusting the dev-docs mirror.
