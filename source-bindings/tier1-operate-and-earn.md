# Source-binding manifest — Tier 1 operate-and-earn

Purpose: bind every Tier 1 command, flag, volatile constant, and important factual claim to upstream source. `source_evidence` proves a claim; `tested_with`, `requires_min`, and `known_incompatible` are compatibility axes and are deliberately separate.

## Upstream revisions read

| Repo | Remote | Commit | Role |
| --- | --- | --- | --- |
| ant-client | https://github.com/WithAutonomi/ant-client.git | `4d0448458ec302af68a5504c533d105b0991c93c` | Binding target for `ant` CLI, node-management daemon, install scripts, and node registry/daemon behaviour. |
| ant-node | https://github.com/WithAutonomi/ant-node.git | `c53665bf4dda87cdbcf848606fa0182e822297d7` | Binding target for `ant-node` flags, rewards-address parsing, storage/resource constants, bootstrap discovery, and release-signature verifier. |
| evmlib | https://github.com/WithAutonomi/evmlib.git | `225acbb1af613193bcc8264b6ede4d7e4a7ac607` | Binding target only for EVM constants and read-only token balance path. |

## Compatibility metadata

tested_with:

- Local authoring source: commits listed above.
- Live self-test: installed `ant 0.1.5` at `/usr/local/bin/ant`; `ant node add/start/status/stop`, `ant node daemon start/status/info/stop`, daemon `DELETE /api/v1/nodes/{id}`, and read-only Arbitrum One `balanceOf` succeeded with public rewards address `0xb4CA36145C204d6629c33caB37796e78B4502b2A`. The added test node used `ant-node 0.13.0`. Do not treat source commits as runtime pins.

requires_min:

- No runtime minimum version declared by this manifest. The skill instructs detect-first and installed-help mismatch escalation.

known_incompatible:

- Installed `ant 0.1.5` used in the live self-test did not show `ant node add --upgrade-channel` in `ant node add --help`. That optional flag is source-bound to ant-client commit `4d0448458ec302af68a5504c533d105b0991c93c`; do not use it on older installed CLIs that do not advertise it.

## Resolved open questions

### 1. Balance check without a private key

Answer: current `ant node status` and the node-management daemon `/api/v1/events` stream are health/lifecycle surfaces and do not report reward totals. The Tier 1 key-free balance path is a read-only ERC-20 `balanceOf(address)` call for the public rewards address against the Autonomi payment token on Arbitrum One.

source_evidence:

- ant-client `ant-core/src/node/types.rs` defines `NodeStatusSummary` with node id, name, version, status, pid, uptime, and pending version; no rewards/balance field. Lines 373-398 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- ant-client `ant-core/src/node/events.rs` defines daemon SSE variants for starting/started/stopping/stopped/crashed/restarting/errored/download/upgrade events; no rewards/balance event. Lines 10-80 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- ant-client `ant-core/src/node/daemon/server.rs` exposes `/api/v1/status`, `/api/v1/events`, and `/api/v1/nodes/status`. Lines 151-166 and 188-251 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- evmlib `src/lib.rs` defines Arbitrum One public RPC URL `https://arb1.arbitrum.io/rpc` and payment token address `0xa78d8321B20c4Ef90eCd72f2588AA985A4BDb684`. Lines 52-65 and 153-164 at commit `225acbb1af613193bcc8264b6ede4d7e4a7ac607`.
- evmlib `artifacts/AutonomiNetworkToken.json` defines `balanceOf(address) -> uint256` as a `view` function. Lines 432-449 at commit `225acbb1af613193bcc8264b6ede4d7e4a7ac607`.
- evmlib deployed bytecode includes selector `0x70a08231` for `balanceOf(address)`. `artifacts/AutonomiNetworkToken.json` line 894 at commit `225acbb1af613193bcc8264b6ede4d7e4a7ac607`.
- evmlib `src/contract/network_token.rs::NetworkToken::balance_of` calls contract `balanceOf`. Lines 69-80 at commit `225acbb1af613193bcc8264b6ede4d7e4a7ac607`.
- evmlib `src/wallet.rs::balance_of_tokens` constructs a provider from `network.rpc_url()` and calls `NetworkToken::balance_of` with `network.payment_token_address()`. Lines 279-288 at commit `225acbb1af613193bcc8264b6ede4d7e4a7ac607`.
- ant-client wallet commands require the private-key path and are prohibited in Tier 1: `ant-cli/src/main.rs` wallet branch calls `require_secret_key()` before wallet actions, and `require_secret_key()` reads the private-key environment variable. Lines 127-132 and 387-390 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.

### 2. Daemon vs node-services

Answer: `ant node add` does not require the daemon. It checks daemon status and posts to the daemon if running, otherwise calls `add_nodes` directly. `ant node start` and `ant node stop` require the daemon and fail with a message to start it first.

source_evidence:

- ant-client `ant-cli/src/commands/node/add.rs::execute` checks daemon status and chooses `add_via_daemon` only when running; otherwise `add_directly`. Lines 82-91 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- ant-client `ant-core/src/node/mod.rs::add_nodes` documents that add resolves binary, loads registry, creates directories, saves registry, does not start nodes, and does not require the daemon. Lines 24-34 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- ant-client `ant-cli/src/commands/node/start.rs::execute` checks daemon status and bails with `Start it first with: ant node daemon start` when not running. Lines 15-22 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- ant-client `ant-cli/src/commands/node/stop.rs::execute` has the same daemon-running requirement. Lines 15-22 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.

### 3. Minimal live-node invocation

Answer: the minimal source-backed Tier 1 mainnet invocation is:

```bash
ant node add --rewards-address "$PUBLIC_REWARDS_ADDRESS"
ant node daemon start
ant node start
ant node status
```

Rationale:

- `--rewards-address` is the only required `ant node add` argument.
- `--count` defaults to `1`.
- `--network-id` defaults to `1` in `ant node add`, but current daemon supervisor does not pass any network-id argument to `ant-node`.
- `ant-node` defaults its EVM network to `arbitrum-one`.
- Bootstrap is auto-discovered from a `bootstrap_peers.toml` file; the `ant` manager copies that file from the downloaded node release when present.

source_evidence:

- ant-client `ant-cli/src/commands/node/add.rs::AddArgs` has required `--rewards-address`, default `--count 1`, optional port/data/log/binary/bootstrap/upgrade/env flags, and default `--network-id 1`. Lines 11-64 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- ant-client `ant-core/src/node/daemon/supervisor.rs::build_node_args` passes `--rewards-address`, `--root-dir`, optional logging, node port, metrics port, bootstrap peers, upgrade channel, and `--stop-on-upgrade`; it does not pass network-id or EVM-network. Lines 690-731 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- ant-node `src/bin/ant-node/cli.rs::Cli` defines default `--evm-network arbitrum-one`. Lines 52-62 and enum values lines 147-157 at commit `c53665bf4dda87cdbcf848606fa0182e822297d7`.
- ant-node `src/bin/ant-node/cli.rs::Cli::into_config` documents bootstrap precedence: CLI/bootstrap env, config file, auto-discovered `bootstrap_peers.toml`, then none. Lines 201-210 and 273-285 at commit `c53665bf4dda87cdbcf848606fa0182e822297d7`.
- ant-client `ant-core/src/node/mod.rs::add_nodes` copies `bootstrap_peers.toml` from the resolved node release archive into each node data dir when present. Lines 139-144 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- ant-node `src/config.rs::BootstrapPeersConfig::discover` searches env, executable dir, platform config dir, and `/etc/ant` on Unix. Lines 509-581 at commit `c53665bf4dda87cdbcf848606fa0182e822297d7`.

### 4. Resource preflight thresholds

Answer: source-backed numeric thresholds are limited. Tier 1 may require checks and cite source constants, but must not invent a fixed per-node storage ceiling or a numeric uptime/bandwidth sizing rule.

Source-backed checks/recommendations:

- Validate public rewards address format.
- Preserve disk above the default storage reserve; current default reserve is 500 MiB.
- Storage auto-scales from available disk and can grow on demand; no fixed per-node ceiling is claimed.
- If a release signature is verified with the built-in ML-DSA verifier, the verifier loads the whole binary in memory; source comments describe typical release binaries as 50-100 MB and recommend minimum 512 MB RAM for verification.
- `ant`/`ant-node` runtimes force at least 4 Tokio worker threads; do not translate that into a CPU minimum without further source.
- Keep daemon API on loopback unless the operator explicitly accepts exposure risk; source comments state the daemon has no authentication when exposed.

source_evidence:

- ant-client `ant-core/src/node/mod.rs::validate_rewards_address` requires `0x`/`0X`, exactly 40 hex characters after the prefix, and ASCII hex. Lines 230-258 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- ant-node `src/storage/lmdb.rs` defines `DEFAULT_DISK_RESERVE = 500 * MIB`; `LmdbStorageConfig` comments say writes are refused below reserve; `new` computes map size from available disk minus reserve and grows on demand. Lines 22-29, 49-75, 141-171, and 721-736 at commit `c53665bf4dda87cdbcf848606fa0182e822297d7`.
- ant-node `src/config.rs::StorageConfig` says explicit DB cap `0` auto-computes from available disk and grows on demand; default disk reserve is 500 MiB. Lines 407-455 at commit `c53665bf4dda87cdbcf848606fa0182e822297d7`.
- ant-node `src/upgrade/signature.rs` documents ML-DSA-65 verification loading full binaries, typical 50-100 MB release builds, and minimum 512 MB RAM recommended. Lines 1-18 at commit `c53665bf4dda87cdbcf848606fa0182e822297d7`.
- ant-client `ant-cli/src/main.rs` and ant-node `src/bin/ant-node/main.rs` both force at least 4 Tokio worker threads. ant-client lines 21-28 at commit `4d0448458ec302af68a5504c533d105b0991c93c`; ant-node lines 91-99 at commit `c53665bf4dda87cdbcf848606fa0182e822297d7`.
- ant-client `ant-cli/src/commands/node/daemon.rs::BindArgs` says default daemon bind is `127.0.0.1` and binding to non-loopback exposes node management because the daemon has no authentication. Lines 9-25 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.

## Command and flag bindings

### `ant` top-level

source_evidence:

- `ant` command name/version/about and subcommands `node`, `wallet`, `file`, `chunk`, `update`: ant-client `ant-cli/src/cli.rs` lines 9-111 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- `--json` global output flag: ant-client `ant-cli/src/cli.rs` lines 17-19 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- EVM network accepted values for data commands: ant-client `ant-cli/src/main.rs::resolve_evm_network` lines 415-451 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.

### Install/detect/update

source_evidence:

- Unix installer usage, `ANT_VERSION`, `INSTALL_DIR`, repo, binary name, target detection, install paths, release URL pattern, `bootstrap_peers.toml` install/skip behaviour: ant-client `install.sh` lines 1-126 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- Windows installer usage, install path, release URL pattern, `bootstrap_peers.toml`, PATH update, and ML-DSA-65 verification note: ant-client `install.ps1` lines 1-98 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- Source-build binary name `ant`: ant-client `ant-cli/Cargo.toml` lines 1-12 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- `ant update --force`: ant-client `ant-cli/src/commands/update.rs` lines 27-31 and execution lines 34-94 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.

### Node add/start/status/stop/reset

source_evidence:

- Node subcommands: ant-client `ant-cli/src/commands/node/mod.rs` lines 17-34 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- `ant node add` flags: `--rewards-address`, `--count`, `--node-port`, `--metrics-port`, `--data-dir-path`, `--log-dir-path`, `--network-id`, `--path`, `--version`, `--url`, `--bootstrap`, `--upgrade-channel`, `--env`: ant-client `ant-cli/src/commands/node/add.rs` lines 11-64 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- Port/range parsing and range/count validation: ant-client `ant-cli/src/commands/node/add.rs` lines 138-203 and ant-core `src/node/mod.rs` lines 52-70 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- `ant node start --service-name`: ant-client `ant-cli/src/commands/node/start.rs` lines 7-12 and execution lines 15-122 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- `ant node stop --service-name`: ant-client `ant-cli/src/commands/node/stop.rs` lines 7-12 and execution lines 15-119 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- `ant node status`: ant-client `ant-cli/src/commands/node/status.rs` lines 7-79 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- `ant node reset --force` and reset deletes data/logs/registry: ant-client `ant-cli/src/commands/node/reset.rs` lines 9-14, confirmation/deletion output lines 35-83, and ant-core `src/node/mod.rs` lines 164-202 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- Single-node registry removal for preserving existing nodes: ant-client `ant-core/src/node/daemon/server.rs` exposes `DELETE /api/v1/nodes/{id}` and rejects removal while the node is running. Lines 157-164 and 309-347 at commit `4d0448458ec302af68a5504c533d105b0991c93c`. ant-core `src/node/mod.rs::remove_node` removes a node from the registry and does not stop the node. Lines 154-162 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.

### Node-management daemon

source_evidence:

- `ant node daemon start|stop|status|info|run` and bind flags `--port`, `--listen-addr`: ant-client `ant-cli/src/commands/node/daemon.rs` lines 9-40 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- Daemon status/info output includes PID, port, API base, uptime, node counts: ant-client `ant-cli/src/commands/node/daemon.rs` lines 91-223 and ant-core `src/node/types.rs` lines 42-62 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- Daemon client uses `http://127.0.0.1:{port}/api/v1` and start spawns `ant node daemon run`: ant-client `ant-core/src/node/daemon/client.rs` lines 101-142, 247-264, and 354-371 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- Daemon routes: ant-client `ant-core/src/node/daemon/server.rs` lines 151-166 and OpenAPI descriptions lines 587-778 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.

### Managed `ant-node` arguments and behaviour

source_evidence:

- `ant-node` flags `--root-dir`, `--port`, `--ipv4-only`, `--bootstrap`, `--upgrade-channel`, `--rewards-address`, `--evm-network`, custom EVM flags, `--metrics-port`, `--network-mode`, `--config`, `--stop-on-upgrade`: ant-node `src/bin/ant-node/cli.rs` lines 16-136 at commit `c53665bf4dda87cdbcf848606fa0182e822297d7`.
- Rewards address parse/validation and wallet config stores only `Option<RewardsAddress>` plus network: ant-node `src/payment/wallet.rs` lines 1-57 and 60-115 at commit `c53665bf4dda87cdbcf848606fa0182e822297d7`.
- Payment config default: rewards address optional, EVM network default Arbitrum One, metrics port default 9100: ant-node `src/config.rs` lines 225-264 at commit `c53665bf4dda87cdbcf848606fa0182e822297d7`.
- Bootstrap config filename/env/search paths: ant-node `src/config.rs` lines 469-581 at commit `c53665bf4dda87cdbcf848606fa0182e822297d7`.

### Binary download/release verification claims

source_evidence:

- `ant` manager resolves latest/version/url/local `ant-node` binaries from `WithAutonomi/ant-node`, derives platform archive names, extracts `ant-node` and `bootstrap_peers.toml`, and caches versioned binaries: ant-client `ant-core/src/node/binary.rs` lines 8-20, 39-118, 130-159, 161-265, 276-399, and 442-480 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.
- ant-node release-signature verifier uses FIPS 204 ML-DSA-65, signing context `ant-node-release-v1`, embedded public key, signature size 3309, public key size 1952, and detached signature verification helpers: ant-node `src/upgrade/signature.rs` lines 1-33 and 165-290 at commit `c53665bf4dda87cdbcf848606fa0182e822297d7`.
- Windows ant-client installer notes ML-DSA-65 archive verification via `ant-keygen verify ... --context ant-release-v1`: ant-client `install.ps1` lines 10-15 at commit `4d0448458ec302af68a5504c533d105b0991c93c`.

## Important factual-claim bindings

- Source bindings are provenance, not runtime pins: repo ADR-0006 lines 37-44 and ADR-0009 lines 28-36 in this repository.
- One holistic, modular skill: repo ADR-0002 lines 37-50.
- Operator scope uses existing CLI/daemon surfaces and builds no new tooling: repo ADR-0003 lines 28-37.
- Node operation is non-custodial and receives to public address only; custody/spend is out of Tier 1: repo ADR-0004 lines 35-73.
- Install is detect-first/non-mutating by default: repo ADR-0008 lines 31-37 and ADR-0009 lines 28-36.
