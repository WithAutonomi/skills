# Installing and verifying the `ant` tool

Read this for installation details, direct-install alternatives, blocked downloads, or identifying the installation before an update or removal. The short version is in the main skill; detect and identify any existing `ant` there first, and leave a working installation alone.

## Install with npm (preferred when available)

Check `node --version` and `npm --version`: the package needs Node.js 18+ and a compatible npm. Use an existing supported Node release; don't install Node solely for this tool when a direct installer will do.

```bash
npm install -g @withautonomi/ant
ant --version
ant --help
ant file --help
```

Confirm Autonomi identity using the main skill's check, not just the command's name. The package supplies Linux/macOS x64 and ARM64 binaries and Windows x64 (also used on ARM64 under emulation). Node.js launches the native binary every time, so it must remain installed. Keep optional dependencies enabled: `--omit=optional` or `--no-optional` skips the platform binary and leaves an unusable launcher.

When install scripts are permitted, the package copies `bootstrap_peers.toml` to the platform config directory only if absent. If scripts are disabled, leave that policy intact: the client has built-in peers, so a missing config file alone is not an installation failure. npm installation does not start nodes or a service.

If the command isn't found, check `npm prefix -g`: npm puts launchers in `<prefix>/bin` on Unix and directly in `<prefix>` on Windows. Confirm that location is on `PATH`, or use the launcher's full path; don't silently edit a shell profile. If the prefix is unwritable or a conflicting launcher exists, stop and explain rather than using `sudo`, `--force`, or changing npm configuration. A permitted direct user-directory install is an alternative, not permission to bypass policy.

### npm installation ownership

Before updating or removing, find the command actually in use (`command -v ant` on Unix; `(Get-Command ant).Source` on Windows) and confirm its Autonomi identity. Then inspect the same npm environment:

```bash
npm prefix -g
npm root -g
npm list -g --depth=0 @withautonomi/ant
```

Confirm the discovered launcher belongs to this listed package: the Unix symlink or Windows npm shim must target `@withautonomi/ant/bin/ant.js` under the reported package root. A package listing alone does not prove it owns the active command. Stop on a different prefix, local/project installation, other package manager, alias or unexplained wrapper rather than applying a global command to it. An absent npm listing does not prove a standalone binary.

With ownership confirmed, retain the same npm environment and prefix for the authorised action: `npm update -g @withautonomi/ant` or `npm uninstall -g @withautonomi/ant`. For an explicitly selected prefix, pass `--prefix "<confirmed-prefix>"`. Never update all global packages or remove an unrelated command revealed afterwards. Keep settings and user state; package removal is not node teardown. If running processes depend on this installation, explain that before proceeding, not by silently stopping them.

## Direct installer fallbacks

Use when suitable Node.js/npm are absent or a direct install is preferred and permitted. Fetch, read, then run the official script; do not pipe a download into a shell. These scripts do not themselves verify checksums/signatures; use the manual path below when a checksum check is needed.

**Linux / macOS:**

```bash
curl -fsSL https://raw.githubusercontent.com/WithAutonomi/ant-client/main/install.sh -o ant-install.sh
# Read ant-install.sh before running it.
INSTALL_DIR="$HOME/.local/bin" bash ant-install.sh
```

Set `INSTALL_DIR` as shown: the macOS script otherwise defaults to `/usr/local/bin`, which may not be writable. The script installs the latest stable release. If its version lookup at `api.github.com` is blocked, use the manual path below or set `ANT_VERSION=<version>` alongside `INSTALL_DIR`, taking the version from the latest release's checksum file.

**Windows (PowerShell):**

```powershell
irm https://raw.githubusercontent.com/WithAutonomi/ant-client/main/install.ps1 -OutFile ant-install.ps1
# Read ant-install.ps1 before running it.
powershell -ExecutionPolicy Bypass -File .\ant-install.ps1
```

The script persistently adds `%LOCALAPPDATA%\ant\bin` to the user PATH; explain that before running it, and that a new terminal may be needed. Honour the environment's script-execution policy; use the manual alternative rather than overriding an organisational restriction. After either install, run `ant --version`, `ant --help` and `ant file --help` and confirm identity as in the main skill.

## Direct-install locations

The installer places one binary, `ant`, plus one config file, `bootstrap_peers.toml` (the list of peers the client uses to find the network). On Windows, the installer script also adds the binary's folder to the user's `PATH`; the manual procedure does not. No service is started, no system directory is touched, and `sudo` is never needed when you install into the user's home directory. Running the tool can later create application data and logs in the locations below.

Default direct-install locations (npm's binary and launcher live under its package root/prefix instead; config and application-data locations are shared):

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
if [ "$(uname -s)" = "Darwin" ]; then
  ANT_CONFIG_DIR="$HOME/Library/Application Support/ant"
else
  ANT_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ant"
fi
mkdir -p "$ANT_CONFIG_DIR"
test -e "$ANT_CONFIG_DIR/bootstrap_peers.toml" || cp "ant-$V-$T/bootstrap_peers.toml" "$ANT_CONFIG_DIR/"
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

Each release archive also carries an ML-DSA-65 signature (`.sig`), made with a key whose public half lives in the ant-client repository. Checking it by hand needs a separate tool, so this skill doesn't ask you to. The manual path above checks the archive checksum; direct installations can later use `ant update`, which verifies the release signature against a public key built into the binary before replacing it.

The npm release workflow checks the archive checksum and signature before packaging the native binary and publishes with npm provenance (a record tying the package to its source and publishing workflow). That is not a local Autonomi-signature check during `npm install`. Report only checks actually performed; do not describe every installation as locally signature-verified.

## When a download is blocked

Symptoms: a 403, connection refused, or a proxy error page. Report the failing host. npm obtains the launcher and native binary from its registry (normally `registry.npmjs.org`), without downloading a GitHub release at install time. Honour a configured organisation registry; don't change it to evade policy. Direct installs use these hosts:

| Host | Needed for |
|---|---|
| `github.com` | the release download URL |
| `objects.githubusercontent.com`, `release-assets.githubusercontent.com` | where the download actually redirects |
| `raw.githubusercontent.com` | the installer script (not needed for the manual path) |
| `api.github.com` | only the installer's "find the latest version" step — the manual path above avoids it by reading the version from the newest release's checksum file, and `ANT_VERSION=<version>` makes the installer skip it too |

Some sandboxes allow release downloads but block the API; others block the release hosts too. The official npm route can work where GitHub downloads are unavailable, if permitted. Never substitute a mirror or alternative host from memory. If no documented route is permitted and reachable, stop and ask for an approved environment. Installing the client does not prove node downloads or direct network connections will work.

## When the tool installs but finds no peers

`Connected to autonomi network (found 0 peers)` means the machine can't make direct outbound connections. The network runs peer-to-peer over UDP; an environment that only permits web traffic through an HTTP proxy will install the tool fine and then never see a peer. That's an environment limit — say so, and don't loop retrying. `Failed to create dual-stack network nodes` is different and fixable: the host has no working IPv6, so add `--ipv4-only` (a global flag, before the subcommand) and retry.

## Removing the tool

Follow [Removing the tool](../SKILL.md#removing-the-tool) in the main skill. For npm, confirm ownership above and let npm remove its package and launchers. For a standalone installation, the path table is a clue, not permission: locate and identify the actual executable before removing that file only. Preserve settings, application data, logs, nodes, receipts, downloads, source files and datamaps in either case.
