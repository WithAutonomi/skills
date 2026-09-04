# Installing and verifying the `ant` tool

Read this when the installer script isn't appropriate, when a download is blocked, or when the person wants the download checked before anything runs. The short version is in the main skill; this is the full procedure.

## What gets installed

The installer places one binary, `ant`, plus one config file, `bootstrap_peers.toml` (the list of peers the client uses to find the network). On Windows, the installer script also adds the binary's folder to the user's `PATH`; the manual procedure does not. No service is started, no system directory is touched, and `sudo` is never needed when you install into the user's home directory. Running the tool can later create application data and logs in the locations below.

Default locations:

| | Binary | Config | Application data | Logs |
|---|---|---|---|---|
| Linux | `~/.local/bin/ant` | `${XDG_CONFIG_HOME:-$HOME/.config}/ant/bootstrap_peers.toml` | `${XDG_DATA_HOME:-$HOME/.local/share}/ant` | `<application data>/logs` |
| macOS | `~/.local/bin/ant` (set `INSTALL_DIR`; the script's own default is `/usr/local/bin`) | `~/Library/Application Support/ant/bootstrap_peers.toml` | `~/Library/Application Support/ant` | `~/Library/Logs/ant` |
| Windows | `%LOCALAPPDATA%\ant\bin\ant.exe` (set `$env:INSTALL_DIR` to change); the installer adds this folder to the user PATH permanently | `%APPDATA%\ant\bootstrap_peers.toml` | `%APPDATA%\ant` | `%APPDATA%\ant\logs` |

`INSTALL_DIR` can move the binary. Nodes can also be given custom data and log locations when they are added, so their files are not necessarily under the default application-data directory.

## Release layout

Every release publishes, at `https://github.com/WithAutonomi/ant-client/releases/download/ant-cli-v<version>/`:

- one archive per platform: `ant-<version>-<target>.tar.gz` (or `.zip` on Windows)
- a detached post-quantum signature per archive: `<archive>.sig`
- `SHA256SUMS.txt` covering every archive and signature

Targets: `x86_64-unknown-linux-musl`, `aarch64-unknown-linux-musl`, `x86_64-apple-darwin`, `aarch64-apple-darwin`, `x86_64-pc-windows-msvc`. The Linux builds are static, so they run on any distribution.

## Verified manual install

Pick the target for the machine (`uname -s` / `uname -m`: Linux x86_64 → `x86_64-unknown-linux-musl`; Linux aarch64 → `aarch64-unknown-linux-musl`; macOS arm64 → `aarch64-apple-darwin`; macOS x86_64 → `x86_64-apple-darwin`). The checksum file for the newest release is reachable without the GitHub API, and its lines name the version, so it doubles as the version lookup:

```bash
T=x86_64-unknown-linux-musl                     # your target
mkdir -p ~/.local/bin && cd "$(mktemp -d)"
curl -fsSLO https://github.com/WithAutonomi/ant-client/releases/latest/download/SHA256SUMS.txt
V=$(sed -nE 's/.* ant-([0-9]+\.[0-9]+\.[0-9]+)-.*\.tar\.gz$/\1/p' SHA256SUMS.txt | head -1)   # e.g. 0.3.6
curl -fsSLO "https://github.com/WithAutonomi/ant-client/releases/download/ant-cli-v$V/ant-$V-$T.tar.gz"
sha256sum -c --ignore-missing SHA256SUMS.txt      # macOS: shasum -a 256 -c --ignore-missing SHA256SUMS.txt
```

To install a specific version instead, set `V` yourself and fetch that release's `SHA256SUMS.txt` from `releases/download/ant-cli-v$V/`.

Continue only if the line for the archive says `OK`. A mismatch means a corrupted or wrong download: delete it, tell the person, and stop.

```bash
tar xzf "ant-$V-$T.tar.gz"
cp "ant-$V-$T/ant" ~/.local/bin/ant && chmod +x ~/.local/bin/ant
mkdir -p ~/.config/ant                            # macOS: "$HOME/Library/Application Support/ant"
cp "ant-$V-$T/bootstrap_peers.toml" ~/.config/ant/   # skip if one already exists
ant --version
```

If `~/.local/bin` isn't on the PATH, tell the person the one line to add (`export PATH="$HOME/.local/bin:$PATH"`) rather than editing their shell profile yourself.

### Windows (PowerShell)

Only an x86_64 build is published; on ARM64 Windows it runs under emulation. No administrator rights are needed for any of this.

```powershell
$T = "x86_64-pc-windows-msvc"
$Tmp = Join-Path $env:TEMP "ant-install"; New-Item -ItemType Directory -Force $Tmp | Out-Null; Set-Location $Tmp
irm "https://github.com/WithAutonomi/ant-client/releases/latest/download/SHA256SUMS.txt" -OutFile SHA256SUMS.txt
$V = (Select-String -Path SHA256SUMS.txt -Pattern "ant-(\d+\.\d+\.\d+)-$T\.zip$").Matches[0].Groups[1].Value
irm "https://github.com/WithAutonomi/ant-client/releases/download/ant-cli-v$V/ant-$V-$T.zip" -OutFile "ant-$V-$T.zip"
$expected = (Select-String -Path SHA256SUMS.txt -Pattern "ant-$V-$T.zip$").Line.Split(' ')[0]
$actual   = (Get-FileHash "ant-$V-$T.zip" -Algorithm SHA256).Hash
if ($actual -ine $expected) { throw "Checksum mismatch — delete the download and stop" }
```

Continue only past that check:

```powershell
Expand-Archive "ant-$V-$T.zip" -DestinationPath $Tmp
$Bin = Join-Path $env:LOCALAPPDATA "ant\bin"; New-Item -ItemType Directory -Force $Bin | Out-Null
Copy-Item "ant-$V-$T\ant.exe" $Bin
$Cfg = Join-Path $env:APPDATA "ant"; New-Item -ItemType Directory -Force $Cfg | Out-Null
if (-not (Test-Path "$Cfg\bootstrap_peers.toml")) { Copy-Item "ant-$V-$T\bootstrap_peers.toml" $Cfg }
& "$Bin\ant.exe" --version
```

The manual path does **not** change the PATH. Either run the tool by its full path, or tell the person the folder to add (`%LOCALAPPDATA%\ant\bin`) and let them decide; the installer script does this for them, persistently, which is the one thing to mention before running it.

## About the signatures

Each archive also carries an ML-DSA-65 signature (`.sig`), made with a key whose public half lives in the ant-client repository. Checking it by hand needs a separate tool, so this skill doesn't ask you to. What it does rely on: the checksum check above for the first install, and the fact that `ant update` verifies that signature itself, against a copy of the public key built into the binary, before it installs any later version. Once one verified `ant` is on the machine, every later one can be checked without extra tooling.

## When a download is blocked

Symptoms: `curl: (22) The requested URL returned error: 403`, a connection refused, or a proxy error page. Stop, and tell the person which host to allow. The hosts involved:

| Host | Needed for |
|---|---|
| `github.com` | the release download URL |
| `objects.githubusercontent.com`, `release-assets.githubusercontent.com` | where the download actually redirects |
| `raw.githubusercontent.com` | the installer script (not needed for the manual path) |
| `api.github.com` | only the installer's "find the latest version" step — the manual path above avoids it by reading the version from the newest release's checksum file, and `ANT_VERSION=<version>` makes the installer skip it too |

Several agent sandboxes allow the first three by default but not the last, which is why the fallbacks above exist. Never substitute a mirror or alternative host from memory; if the official hosts can't be reached, the person needs to change the environment or install on a different machine.

## When the tool installs but finds no peers

`Connected to autonomi network (found 0 peers)` means the machine can't make direct outbound connections. The network runs peer-to-peer over UDP; an environment that only permits web traffic through an HTTP proxy will install the tool fine and then never see a peer. That's an environment limit — say so, and don't loop retrying. `Failed to create dual-stack network nodes` is different and fixable: the host has no working IPv6, so add `--ipv4-only` (a global flag, before the subcommand) and retry.

## Removing the tool

When and in what order is in the main skill under Uninstalling. Treat each of these as a separate choice and get the person's agreement before deleting it:

1. **Nodes.** Account for custom `--data-dir-path` and `--log-dir-path` locations used when the nodes were added; mount those volumes before reset, and stop if a possible location is unknown or unavailable. Before starting the daemon or stopping nodes, confirm that those actions are within the person's existing explicit permission; ask if not. Keep the daemon running, run `ant node stop`, inspect the output for failures, then use `ant node status` to confirm that every node reports `Stopped` or `Evicted`. If a stop failed or any status is uncertain, do not reset. After separate approval to destroy the node data, run `ant node reset --force` while the daemon is still running so it enforces its running-node check. Reset removes recorded directories only when it can reach them, then clears the registry: verify every expected path is gone before reporting success. Stop the daemon last. See `run-nodes.md` for normal node handling.
2. **Binary.** Locate the executable actually in use with `command -v ant` on macOS/Linux or `(Get-Command ant).Source` in PowerShell, show the path, then delete that file. Do not assume it is in the default location when `INSTALL_DIR` may have been used. Offer to remove dedicated installer-created directories only when they are empty; never remove shared directories such as `~/.local/bin` or `/usr/local/bin`.
3. **Config.** The installer-created file is `bootstrap_peers.toml` at the config path in the table. If the person enabled log forwarding, the same directory can contain `log_forward.json`, including its write-only API token. On macOS and Windows the config and application-data directories are the same, so remove only the config files they identified if other state is being kept.
4. **Application data.** This may contain downloaded node binaries, default-location node data, the node registry and daemon files, peer and performance caches, temporary upload state, log-forwarding offsets, and payment receipts that let a failed paid upload resume without paying again. Explain that deleting the receipts can make a retry pay again. Never delete this directory while the person is keeping default-location nodes.
5. **Logs.** Remove the platform log directory only if the person wants local logs removed. On Linux and Windows this is inside the application-data directory, so removing all application data removes these logs too. Registered nodes may have custom log directories; node reset handles those when node deletion was approved. A daemon started with a custom `--log-path` also leaves its dated log files there; remove that known log family only if approved.
6. **Installer leftovers.** The scripted route leaves `ant-install.sh` or `ant-install.ps1` wherever it was downloaded. The manual route may leave the downloaded archive and extraction directory. Offer to remove known leftovers, but do not search broadly or guess.

On Windows, remove the exact install-directory entry from the user's `PATH` if it was added for `ant`. The Windows installer adds that entry automatically; a manual installation has one only if the person chose to add it. On macOS/Linux the installer only warns when its directory is absent from `PATH`, so do not edit shell startup files unless the person asks you to reverse a change they made themselves.

Downloads, source files and datamap files are the person's files, not installation state. Leave them alone unless explicitly asked. A datamap may be the only way to retrieve a private upload; before deleting one, explain that access may be lost permanently, recommend a backup, and get confirmation for that specific file. Nothing already stored on the network is affected by uninstalling.
