# Node provisioning — first-time setup

Setting Autonomi up on a machine for the first time: detect or install the tools, check the host is a good fit, supply the public address earnings are paid into, and add your first node.

Everything here is **cleanly reversible** — `node-uninstall.md` is the exact teardown path, worth a glance before you commit to installing anything.

## Ground rules

Hold these as preconditions before you install or change anything. They are yours to satisfy, not questions to put to a human:

- You have a **public rewards address** (an EVM address — `0x` + 40 hex characters), or you can get one from the human. You never create one yourself.
- You will not handle any private key, seed phrase, keystore, or signing token. Running nodes needs only the public address.
- Detect first; install only when `ant` is missing or unusable, and only within the human's remit.

## 1. Detect `ant`

```bash
ant --version
ant --help
```

If both work, don't reinstall or upgrade just because this skill is present. If `ant` is missing, install it.

## 2. Install `ant` (only when missing)

Official installer:

```bash
# Linux / macOS
curl -fsSL https://raw.githubusercontent.com/WithAutonomi/ant-client/main/install.sh | bash
ant --version && ant --help

# Windows (PowerShell)
irm https://raw.githubusercontent.com/WithAutonomi/ant-client/main/install.ps1 | iex
```

Source build — only when Rust is already present and the human approves:

```bash
git clone https://github.com/WithAutonomi/ant-client.git
cd ant-client && cargo build --release --bin ant
```

What the installer does:

- Installs `ant` to `~/.local/bin` (Linux), `/usr/local/bin` (macOS), or `%LOCALAPPDATA%\ant\bin` (Windows), unless `INSTALL_DIR` is set.
- Places `bootstrap_peers.toml` in the platform config directory if it's missing (it won't overwrite an existing one).
- The node binary (`ant-node`) is fetched and managed by `ant` when you add nodes — so installing `ant` brings everything needed to run nodes.
- The installer puts `ant` in a user bin dir and updates `PATH`; if `ant` isn't found immediately after installing, open a new shell so the change applies.

**Verification.** Releases are signed (ML-DSA-65). If you verify a downloaded archive's signature or checksum, report the exact result before use. If you can't verify, say so plainly — never claim verified delivery you didn't perform.

**If the binary download is blocked.** The install *script* is fetched from `raw.githubusercontent.com`, but the *binary* it downloads comes from GitHub's release CDN (currently `release-assets.githubusercontent.com`) — and some locked-down sandboxes allow the first while blocking the second, so the install fails with a 403 / proxy error even though the script ran. Don't route around it or invent a different URL. Report the exact endpoint that failed and tell the human the install needs **both** `raw.githubusercontent.com` (the script) and `release-assets.githubusercontent.com` (the binary) reachable — or to run on a host with broader network access. If neither is possible, stop; there's no safe workaround.

## 3. Validate the public rewards address

```bash
PUBLIC_REWARDS_ADDRESS="<public address supplied by the human>"
```

It must be `0x` followed by exactly 40 hexadecimal characters. It may be **supplied** by the human, already **provisioned** in the environment, or — for future autonomous operation only — created by an out-of-context custody substrate, which this skill does not provide. If you don't have a valid public address, stop and ask for one. Never paste or request a key. Full detail in `wallet-and-tokens.md`.

## 4. Preflight the host (once)

A one-time fit check before the first node — not something to repeat on every start/stop. Two parts: **decide what you're contributing**, then **confirm the host can carry it**.

### Decide your contribution — what, where, how much

A deliberate choice, not a default. Make it on the merits and within the human's remit — autonomously (or by proxy) if you have that remit, otherwise by asking:

- **Where the node data lives.** It can sit on the system drive *or* any other mounted volume — an attached external drive, a separate data disk. Pick the location that's the best fit (enough free space, stays attached, not fighting the human's own use), rather than assuming the system drive. `df -h` shows every mounted volume and its free space; also weigh spare memory and bandwidth.
- **How many nodes.** Each node wants **≥ ~20 GB free** on its data volume. More nodes contribute — and earn — more, but only if the chosen location truly has the room and the host stays responsive; a stuffed host earns less. Size to the resource that runs out first (full doctrine: `node-operating-procedures.md`, Resource strategy).
- **Act or ask.** Proceed if you have remit to choose. Ask when the choice is materially the human's — using their other media for node data, a plan that differs from what they asked, or a contribution beyond your remit. Put it concretely, e.g.: "The system drive has 3 GB free; your external drive at `/Volumes/Backup` has 400 GB. I'd run two nodes there — OK?"

### Confirm the host can carry it

- `ant --version` / `ant --help` work (or the human approved the install).
- The public rewards address passes the `0x` + 40-hex check above.
- No private key material is anywhere in the task context.
- **Free space on the volume(s) you chose** — `df -h <path>` — is **≥ ~20 GB per node** you'll place there. This ~20 GB is a strong recommendation, **not** a network-enforced limit: below it, **that individual node** is likely to be **shunned** (the network drops just that one node, so it earns nothing; other nodes, the agent, and the machine are unaffected). It's separate from the network's hard **500 MiB write-reserve** (a node stops accepting writes below that). If your chosen volume can't meet the bar and no other can, and the human can't free space, stop and report — don't squeeze a node onto a volume below it. Above the bar, storage auto-scales; don't plan against a fixed per-node ceiling.
- If you'll use fixed node/metrics ports, they're free and the ranges match the node count.
- A `bootstrap_peers.toml` exists (from the installer/release), or the human supplied source-backed bootstrap peers.
- The daemon API will stay on loopback unless a human explicitly accepts the exposure.
- The machine can stay online long enough to be useful — a human judgement; there's no source-backed uptime number.

If release-signature verification will run, note the verifier loads the whole binary into memory; release builds are typically 50–100 MB and ≥ 512 MB RAM is recommended for that step.

### Placing node data on a chosen volume

When the location you chose isn't the default, point the node at it with `--data-dir-path` — a custom data-directory prefix (pair with `--log-dir-path` if logs should follow). One prefix can hold several nodes' data:

```bash
ant node add --rewards-address "$PUBLIC_REWARDS_ADDRESS" \
  --data-dir-path /Volumes/Backup/autonomi
```

Source-bound: `--data-dir-path <PATH>` / `--log-dir-path <PATH>` are options on `ant node add`. Choose a volume that **stays attached** — node data must remain available or the node loses its standing, so removable media that may be unplugged is a poor choice. If, after surveying, **no** volume can meet the bar and the human can't free space, stop and report — there's nowhere safe to put the data.

## 5. Add your first node

```bash
ant node add --rewards-address "$PUBLIC_REWARDS_ADDRESS"   # one node, Arbitrum One, by default
ant node daemon start
ant node start
ant node status
```

If you chose a non-default data location in preflight, add `--data-dir-path <path>` (and `--log-dir-path` if wanted) to the `add` command above.

Defaults from source: one node (`--count 1`); the node binary uses `--evm-network arbitrum-one`; bootstrap peers auto-discovered. Don't rely on `--network-id` as a live network selector — the current daemon doesn't forward it to the node.

Once one node is healthy, scaling up and running it well is `node-operating-procedures.md`.
