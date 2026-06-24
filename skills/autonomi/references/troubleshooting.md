# Troubleshooting

Start with the invariant: **if a proposed fix needs private key material, it is not a fix this skill makes.** Stop and escalate instead.

## `ant` not found

1. Check the installer path is on `PATH`.
2. Default install paths: Linux `~/.local/bin/ant`, macOS `/usr/local/bin/ant`, Windows `%LOCALAPPDATA%\ant\bin\ant.exe`.
3. If it's genuinely missing, install via the official upstream installer, within remit (`node-provisioning.md`).

## Installer ran but `ant --help` fails

- Open a new shell so `PATH` changes apply.
- Run the binary by full path to confirm it exists.
- If the installer said a bootstrap config already existed, don't overwrite it without authority.

## The install download fails (403 / proxy / blocked endpoint)

The script runs (it's on `raw.githubusercontent.com`), but the binary download fails with a 403 or proxy error. This is an **environment allowlist** issue, not a skill or version problem: GitHub serves release *binaries* from a separate CDN (currently `release-assets.githubusercontent.com`) that some sandboxes block even when `raw.githubusercontent.com` is allowed. Don't invent a workaround or a different URL. Report the exact endpoint that failed, and tell the human the install needs **both** `raw.githubusercontent.com` and `release-assets.githubusercontent.com` reachable — or to run on a host with broader network access.

## `ant node add` rejects the address

- The public address must be `0x` + exactly 40 hex characters.
- Don't substitute a private key, seed, mnemonic, or keystore.
- If no valid public address is available, stop and ask for one.

## `ant node start` says the daemon isn't running

```bash
ant node daemon start
ant node start
```

`ant node add` works without the daemon, but start/stop need it.

## Daemon reports not running

```bash
ant node daemon status
ant node daemon start
ant node daemon status
```

If a custom port / listen address was requested and an old daemon is already running, stop it before applying new bind settings.

## A node shows `Stopped`

If the daemon isn't running, `ant node status` reports registered nodes as stopped. Start the daemon, then the nodes:

```bash
ant node daemon start
ant node start
ant node status
```

## A node is `Errored` or keeps crashing

- Capture `ant node status` and `ant node daemon status`.
- Stay on query-based health: `ant node status`, daemon status / info / events, and OS host metrics. Don't enable or scrape logs for routine health, and don't read node-internal files for it.
- For targeted debugging only, note the data/log path printed by `ant node add` so a human can inspect it if they choose.
- Confirm a bootstrap config exists (or explicit bootstrap peers were supplied), and that free disk is above the reserve.
- If it persists, stop and report the exact output — don't invent a flag.

## `reset` fails because nodes are running

Stop nodes first; use `--force` only in an explicitly approved non-interactive teardown:

```bash
ant node stop
ant node reset
```

If the host has other registered nodes you didn't create, don't `reset` — remove only your node (`node-uninstall.md`).

## Balance check errors or returns empty

- Confirm the public address is valid and unchanged.
- Confirm the token contract in the call is `0xa78d8321B20c4Ef90eCd72f2588AA985A4BDb684` (Arbitrum One).
- Retry the read-only RPC; public endpoints fail transiently.
- A zero balance is not a node-health failure — rewards may not have arrived.
- If the RPC endpoint is *blocked* by the environment (a 403 / proxy error, not a transient failure), that's an allowlist issue, not a bad call: the balance check needs an Arbitrum One RPC reachable (default `arb1.arbitrum.io`). Name it for the human to allowlist, or use an approved Arbitrum One read-only explorer.

## You're asked to spend, withdraw, bridge, approve, or acquire ANT

Stop and escalate. This skill receives and observes only; it does not spend or sign. Surface the request to the human as the genuinely-human decision it is (`wallet-and-tokens.md`).

## The installed tool disagrees with this skill

If the installed `ant --help` shows the command or flag you need differs from what's written here, **trust the installed tool.** Stop and report: the installed `ant --version`, the command attempted, and the observed help/output. Don't invent a fallback.
