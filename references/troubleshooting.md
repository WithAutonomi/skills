# Troubleshooting

Start with the invariant: if a proposed fix needs private key material, it is not a Tier 1 fix.

## `ant` is not found

1. Check whether the installer path is on `PATH`.
2. Linux default install path: `~/.local/bin/ant`.
3. macOS default install path: `/usr/local/bin/ant`.
4. Windows default install path: `%LOCALAPPDATA%\ant\bin\ant.exe`.
5. If missing, install through the official upstream installer with operator authority.

## Installer succeeds but `ant --help` fails

- Open a new terminal/session so PATH changes apply.
- Run the binary by full path to confirm it exists.
- If install output said bootstrap config already existed, do not overwrite it without authority.

## `ant node add` rejects the rewards address

- Confirm the public address starts with `0x` and has 40 hex characters after the prefix.
- Do not substitute a private key, seed, mnemonic, or keystore.
- If no valid public address is available, stop and ask for one.

## `ant node start` says the daemon is not running

Start the daemon first:

```bash
ant node daemon start
ant node start
```

`ant node add` can add directly without a running daemon, but start/stop require it.

## Daemon status says not running

```bash
ant node daemon status
ant node daemon start
ant node daemon status
```

If a custom port/listen address was requested and an old daemon is already running, stop it before applying new bind settings.

## Node is `Stopped`

- If the daemon is not running, `ant node status` reports registered nodes as stopped.
- Start the daemon, then start nodes.

```bash
ant node daemon start
ant node start
ant node status
```

## Node is `Errored` or repeatedly crashes

- Capture `ant node status` and `ant node daemon status`.
- Check the data/log path printed by `ant node add`. If no custom log dir was configured, node stdout/stderr logs are written under the node data directory.
- Confirm bootstrap config exists or explicit bootstrap peers were supplied.
- Confirm disk has free space above the reserve.
- If the issue persists, stop and report the exact output; do not invent flags.

## Reset fails because nodes are running

Stop nodes first:

```bash
ant node stop
ant node reset
```

Only use `--force` when non-interactive teardown has been explicitly approved.

If other registered nodes already exist, do not use reset for a test cleanup. Stop the test node by service name, remove only that node's registry entry through the daemon API `DELETE /api/v1/nodes/{id}`, then delete only the test node's recorded data/log directories.

## Balance check returns RPC error or empty result

- Confirm the public address is valid and unchanged.
- Confirm the token contract address in the command is `0xa78d8321B20c4Ef90eCd72f2588AA985A4BDb684` for Arbitrum One.
- Retry the read-only RPC call; public RPC endpoints can fail transiently.
- A zero balance is not a node-health failure by itself. Rewards may not have arrived.

## You are asked to spend, withdraw, bridge, approve, or acquire ANT

Stop and escalate. Tier 1 does not spend or sign. Use `templates/human-authority-request.md` to capture the request and route it to the later custody/gas decision path.

## Source mismatch

If installed `ant --help` shows the command or flag you need differs from this skill, stop and report:

- installed `ant --version`;
- command attempted;
- observed help/output;
- the relevant source-binding entry from `source-bindings/tier1-operate-and-earn.md`.
