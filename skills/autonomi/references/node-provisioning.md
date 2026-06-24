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

Run these before the first node. This is a one-time fit check, not something to repeat on every start/stop:

- `ant --version` / `ant --help` work (or the human approved the install).
- The public rewards address passes the `0x` + 40-hex check above.
- No private key material is anywhere in the task context.
- **Free disk** — at least **~20 GB per node** (team-recommended minimum, docs/source to follow; too little risks **that individual node** being **shunned** — the network drops just that node, not the agent or the machine), and comfortably above the network's hard **500 MiB write-reserve**. Storage auto-scales up from there; don't plan against a fixed per-node ceiling.
- If you'll use fixed node/metrics ports, they're free and the ranges match the node count.
- A `bootstrap_peers.toml` exists (from the installer/release), or the human supplied source-backed bootstrap peers.
- The daemon API will stay on loopback unless a human explicitly accepts the exposure.
- The machine can stay online long enough to be useful — a human judgement; there's no source-backed uptime number.

If release-signature verification will run, note the verifier loads the whole binary into memory; release builds are typically 50–100 MB and ≥ 512 MB RAM is recommended for that step.

## 5. Add your first node

```bash
ant node add --rewards-address "$PUBLIC_REWARDS_ADDRESS"   # one node, Arbitrum One, by default
ant node daemon start
ant node start
ant node status
```

Defaults from source: one node (`--count 1`); the node binary uses `--evm-network arbitrum-one`; bootstrap peers auto-discovered. Don't rely on `--network-id` as a live network selector — the current daemon doesn't forward it to the node.

Once one node is healthy, scaling up and running it well is `node-operating-procedures.md`.
