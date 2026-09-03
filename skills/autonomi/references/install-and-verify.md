# Installing and verifying the `ant` tool

Read this when the installer script isn't appropriate, when a download is blocked, or when the person wants the download checked before anything runs. The short version is in the main skill; this is the full procedure.

## What gets installed

One binary, `ant`, plus one config file, `bootstrap_peers.toml` (the list of peers the client uses to find the network). Nothing else. No service is started, no system directory is touched, and `sudo` is never needed when you install into the user's home directory.

Default locations:

| | Binary | Config |
|---|---|---|
| Linux | `~/.local/bin/ant` | `~/.config/ant/bootstrap_peers.toml` |
| macOS | `~/.local/bin/ant` (set `INSTALL_DIR`; the script's own default is `/usr/local/bin`) | `~/Library/Application Support/ant/bootstrap_peers.toml` |
| Windows | `%LOCALAPPDATA%\ant\bin\ant.exe` (set `$env:INSTALL_DIR` to change); the installer adds this folder to the user PATH permanently | `%APPDATA%\ant\bootstrap_peers.toml` |

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

When and in what order is in the main skill under Uninstalling; nodes come first, and only with the person's say-so (see `run-nodes.md`). For the tool itself: delete the binary and the config directory listed at the top. On Windows, also remove the `%LOCALAPPDATA%\ant\bin` entry the installer script added to the user PATH (Settings → Environment Variables, or `[Environment]::SetEnvironmentVariable` in PowerShell). Nothing stored on the network is affected by uninstalling.
