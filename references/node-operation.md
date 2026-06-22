# Node operation

This is the Tier 1 runbook for operating Autonomi nodes with a public rewards address only.

## 0. Rules before touching the machine

1. Confirm the operator supplied or approved a **public EVM rewards address**.
2. Confirm you will not handle any private key material. Tier 1 only needs the public address.
3. Use `templates/node-preflight-checklist.md` before installing, adding, starting, or resetting nodes.
4. Detect first; install only when `ant` is missing or unusable.

## 1. Detect `ant`

```bash
ant --version
ant --help
```

If both commands work, do not reinstall or upgrade merely because this skill exists. If `ant` is missing, install through the official upstream installer.

## 2. Install `ant` only when missing

Linux/macOS official installer:

```bash
curl -fsSL https://raw.githubusercontent.com/WithAutonomi/ant-client/main/install.sh | bash
ant --version
ant --help
```

Windows official installer:

```powershell
irm https://raw.githubusercontent.com/WithAutonomi/ant-client/main/install.ps1 | iex
ant --version
ant --help
```

Source-build fallback when Rust is already available and the operator approves building from source:

```bash
git clone https://github.com/WithAutonomi/ant-client.git
cd ant-client
cargo build --release --bin ant
```

Install notes:

- The Unix installer installs `ant` to `~/.local/bin` on Linux and `/usr/local/bin` on macOS unless `INSTALL_DIR` is set.
- The Windows installer installs to `%LOCALAPPDATA%\ant\bin` unless `INSTALL_DIR` is set.
- The installers add/copy `bootstrap_peers.toml` to the platform config directory when missing.
- If you verify downloaded release archives/signatures/checksums separately, report the exact verification result before use. If you cannot verify, say so explicitly; do not claim verified delivery.

## 3. Validate the public rewards address

The rewards address must be an EVM-style address: `0x` plus 40 hex characters. It may be a human-supplied, provisioned, or safe-substrate-created public address. Tier 1 does not create wallets.

```bash
PUBLIC_REWARDS_ADDRESS="<public EVM rewards address supplied by operator>"
```

Do not paste or request any key, seed, keystore, or signing token.

## 4. Add node configuration

Minimal mainnet add command:

```bash
ant node add --rewards-address "$PUBLIC_REWARDS_ADDRESS"
```

Useful source-backed optional flags. Only use optional flags that are present in the installed `ant node add --help`; source evidence is not a runtime version pin.

```bash
ant node add --rewards-address "$PUBLIC_REWARDS_ADDRESS" --count 2
ant node add --rewards-address "$PUBLIC_REWARDS_ADDRESS" --node-port 12000-12001
ant node add --rewards-address "$PUBLIC_REWARDS_ADDRESS" --metrics-port 13000-13001
ant node add --rewards-address "$PUBLIC_REWARDS_ADDRESS" --data-dir-path /path/to/ant-node-data
ant node add --rewards-address "$PUBLIC_REWARDS_ADDRESS" --log-dir-path /path/to/ant-node-logs
ant node add --rewards-address "$PUBLIC_REWARDS_ADDRESS" --bootstrap <source-backed-bootstrap-peer-addr-1>,<source-backed-bootstrap-peer-addr-2>
ant node add --rewards-address "$PUBLIC_REWARDS_ADDRESS" --upgrade-channel stable
```

Mainnet defaults from source:

- `ant node add` defaults to `--count 1` and `--network-id 1`.
- The managed `ant-node` binary defaults to `--evm-network arbitrum-one`.
- The `ant` manager copies `bootstrap_peers.toml` from the downloaded `ant-node` release when present; `ant-node` also auto-discovers a bootstrap file from well-known paths. Use `--bootstrap` only when you have source-backed bootstrap peers from the operator/upstream.

Current source note: `ant node add` accepts and stores `--network-id`, but the current daemon supervisor does not pass a `network-id` argument to `ant-node`. Do not rely on it as the live EVM selector. For Tier 1 mainnet operation, the minimal source-backed selector is the default `ant-node --evm-network arbitrum-one` plus discovered bootstrap peers.

## 5. Start the node-management daemon

`ant node add` can add directly when the daemon is not running. `ant node start` and `ant node stop` require the daemon.

```bash
ant node daemon status
ant node daemon start
ant node daemon status
```

The daemon binds to loopback by default. Do not use `--listen-addr 0.0.0.0` unless the operator explicitly owns the network exposure risk; the daemon has no authentication.

Optional daemon bind controls:

```bash
ant node daemon start --port 8765
ant node daemon start --listen-addr 127.0.0.1
```

## 6. Start nodes

Start all registered nodes:

```bash
ant node start
```

Start one registered node by service name:

```bash
ant node start --service-name node1
```

## 7. Monitor health

Primary health command:

```bash
ant node status
```

Daemon summary:

```bash
ant node daemon status
ant node daemon info
```

Optional event stream for lifecycle events:

```bash
ant --json node daemon info
# Use the reported api_base, then:
curl -N http://127.0.0.1:PORT/api/v1/events
```

Expected healthy signs:

- daemon status says running;
- `ant node status` shows the registered node as `Running`, `Starting`, or `Upgrade scheduled` during an expected upgrade;
- no node is `Errored`;
- the node process remains up across repeated status checks.

Do not scrape a metrics endpoint as the Tier 1 health path. The source-backed management surfaces for this skill are `ant node status`, `ant node daemon status/info`, and the daemon event stream.

## 8. Check rewards/balance without a key

Use `references/wallet-and-ant.md`. `ant node status` and the daemon event stream report lifecycle and health, not earned token totals. The source-backed key-free balance path is a read-only ERC-20 `balanceOf` call to the Autonomi token contract on Arbitrum One.

## 9. Stop cleanly

Stop all nodes:

```bash
ant node stop
```

Stop one node:

```bash
ant node stop --service-name node1
```

Stop the daemon after nodes are stopped:

```bash
ant node daemon stop
```

## 10. Reset node state only with authority

Reset removes node data, logs, and clears the registry. It fails while nodes are running.

Use reset only when you own all local node state or the operator explicitly approves clearing every registered node. If the machine already has other registered nodes, do **not** use reset for a test-node cleanup.

```bash
ant node stop
ant node reset
```

For non-interactive teardown in an explicitly approved test or cleanup:

```bash
ant node stop
ant node reset --force
```

### Single-node cleanup when preserving existing nodes

When you added one test node on a machine that already has other registered nodes, clean up only that node:

1. Record the node ID, service name, data directory, and log directory from `ant node add` / `ant node status`.
2. Stop that node only:

   ```bash
   ant node stop --service-name node11
   ```

3. Ensure the daemon is running and get the API base:

   ```bash
   ant node daemon start
   ant --json node daemon info
   ```

4. Use the reported `api_base` and node ID to remove only that registry entry:

   ```bash
   curl -sS -X DELETE http://127.0.0.1:PORT/api/v1/nodes/11
   ```

5. Delete only the data/log directories that were created for that same test node, and only if they are not shared with any other node.

## 11. Clean uninstall

Only uninstall a tool or delete state you installed/created under the operator's remit.

1. `ant node stop`
2. `ant node reset` or `ant node reset --force` only when explicitly approved.
3. `ant node daemon stop`
4. Remove the `ant` binary from the installer path if this run installed it:
   - Linux default: `~/.local/bin/ant`
   - macOS default: `/usr/local/bin/ant`
   - Windows default: `%LOCALAPPDATA%\ant\bin\ant.exe`
5. Keep or remove `bootstrap_peers.toml` according to operator authority. The installers skip overwriting an existing bootstrap config, so do not delete a pre-existing one without approval.

Record the cleanup in `templates/node-health-report.md` or a session summary.
