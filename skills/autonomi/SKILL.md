---
name: autonomi
description: "Build on, integrate with, and use the Autonomi network — permanent, accountless, encrypted data storage with free reads — for the user. Add durable storage to an app or stack; read and download data by content address; upload files or data, publicly or privately, and get a permanent address back; handle the keys and wallet a paid write needs, safely; run nodes that contribute spare disk and bandwidth and earn the network's token. Data is encrypted before it leaves the machine, content-addressed and immutable; paid once, never again; no sign-up, API key or server. Use it whenever the user is building something that must keep data permanently, wants decentralised or Autonomi storage in an app, wants to store or archive something for good, publish tamper-proof data, fetch data from a content address, keep data with no server behind it, or put a machine's spare capacity to work — or mentions Autonomi, ANT, ant, antd or datamaps. It installs and verifies the tools it needs. Not for request paths or databases."
license: MIT OR Apache-2.0
compatibility: "Needs a shell with curl and tar (PowerShell on Windows), outbound HTTPS to github.com to fetch the ant CLI, and direct internet access for the network itself (the client talks to peers over UDP, so a proxy-only sandbox can install the tool but cannot reach the network). A paid write also needs a wallet the user funds and controls."
metadata:
  version: "0.1.0"
  author: Autonomi
  homepage: https://autonomi.com
  repository: https://github.com/WithAutonomi/skills
---

# Autonomi

Autonomi is a data network: permanent, accountless, encrypted storage that anyone can read from for free. You write data once, pay once, and get back a content address that works forever — no account, no API key, no server to keep running. Data is encrypted on the user's machine before it leaves, stored in pieces across independent peers, and cannot be altered or removed afterwards. Reads are free at any volume. Those peers are ordinary machines — anyone's — running small programs called nodes, and the network pays them in its token, ANT, for the storage they provide.

This skill lets you do that work for the person you're helping: fetch data from an address, store data and hand back its address, put a machine's spare capacity to work by running nodes, and — only when their task is building software — wire the network into an application. Everything runs through one tool, the `ant` command-line client, which this skill installs and verifies if it isn't already there.

Made by the Autonomi team. Draws on [ant-client](https://github.com/WithAutonomi/ant-client) (the `ant` CLI) and the network documentation at [docs.autonomi.com](https://docs.autonomi.com). Source and issues: [WithAutonomi/skills](https://github.com/WithAutonomi/skills).

**Who you're likely helping.** Not necessarily a developer, and quite possibly new to the command line, to running anything on their machine, and to tokens and wallets. Assume that until they show you otherwise, and let their questions, what they tell you, and what you already know about them set the level. Start in everyday language; introduce a precise term by saying what it's for first; keep the jargon of cryptocurrency and infrastructure out of what you say unless they use it first. Plain must still be accurate. There's more under [Working with the person](#working-with-the-person).

## Before you do anything

- **Reading is free and needs nothing.** No wallet, no key, no payment.
- **Writing is permanent.** Data stored on the network cannot be altered or deleted afterwards, by anyone. There are two kinds: **private** (the default — retrievable only by whoever holds its datamap file) and **public** (published at an address anyone can read, forever). Make sure the person understands which they're choosing before anything is uploaded; public is for things they genuinely want available to everyone, permanently.
- **Writing costs real money.** Quote the cost first, show it, and wait for the go-ahead — unless the person has explicitly told you they don't want to approve each spend. See [Keys and money](#keys-and-money).
- **You never see the wallet key.** You work with the wallet's public address, freely. The private key you never ask for, accept, read, print or log; the person makes it available to the `ant` tool themselves. If one ever appears in the conversation, stop and tell them to create a new wallet and move the funds — see [Keys and money](#keys-and-money).
- **Learn the tool from itself.** Run `ant --help` and `ant file --help` and use only the commands and flags they document. Do not guess flags or Autonomi-specific details from memory.

## What are you trying to do?

| The task | Go to |
|---|---|
| Get data from the network — download by address, or from a datamap file | [Read](#read-data-from-the-network) |
| Put data on the network — store a file, get its permanent address, know the cost first | [Store](#store-data-on-the-network) |
| Install, verify or check the `ant` tool | [Set up the tool](#set-up-the-tool) |
| Build Autonomi into an application or service, or choose how it fits a stack | [references/build-on-autonomi.md](references/build-on-autonomi.md) — read it only when the task is building software |
| Run nodes — put spare disk and bandwidth to work and earn ANT | [Run nodes](#run-nodes) |
| Take the tool, or nodes, off a machine | [Uninstalling](#uninstalling) |

Do what you were asked, and no more. Someone who asked you to fetch a file doesn't need to hear about wallets, nodes or building applications; someone who asked you to store a file doesn't need a demonstration first.

The `references/` files travel with this skill. If one you need isn't alongside this file — some install paths copy only `SKILL.md` — fetch it from `https://raw.githubusercontent.com/WithAutonomi/skills/main/skills/autonomi/references/<name>` and carry on.

## Set up the tool

Detect first — never reinstall or upgrade something that is already working:

```bash
ant --version
```

If that prints a version, skip to the task. If not, install. Three ways, none needing administrator rights:

**Installer script** (macOS / Linux). This is the official installer from the tool's own repository; it installs the newest stable release. The only difference from the one-liner in the README is that you save the script and read it before running it, rather than piping it straight into a shell — the security scanners that skill directories run flag piped installs, and reading first costs nothing.

```bash
curl -fsSL https://raw.githubusercontent.com/WithAutonomi/ant-client/main/install.sh -o ant-install.sh
# read ant-install.sh — it downloads one archive, extracts one binary and a config file, never uses sudo
INSTALL_DIR="$HOME/.local/bin" bash ant-install.sh
```

Set `INSTALL_DIR` as shown: without it the script defaults to `/usr/local/bin` on macOS, which may not be writable. If the script fails at "could not read the release list" or a `403` from `api.github.com`, the environment blocks the version lookup but not the download itself — a known quirk of some sandboxes. Then either use the verified manual install below, which learns the version from the checksum file, or re-run with a version pinned: `ANT_VERSION=<version> bash ant-install.sh`, taking the version from the newest line of https://github.com/WithAutonomi/ant-client/releases/latest/download/SHA256SUMS.txt.

**Installer script** (Windows, PowerShell). Same shape — fetch, read, run:

```powershell
irm https://raw.githubusercontent.com/WithAutonomi/ant-client/main/install.ps1 -OutFile ant-install.ps1
# read ant-install.ps1 — it downloads one archive, extracts ant.exe and a config file, and adds its folder to the user PATH
powershell -ExecutionPolicy Bypass -File .\ant-install.ps1
```

It installs to `%LOCALAPPDATA%\ant\bin` (override with `$env:INSTALL_DIR`) and **adds that folder to the user's PATH permanently** — tell the person that before running it, and that a new terminal is needed afterwards. Only an x86_64 build exists; on an ARM64 Windows machine it runs under emulation, which the script says itself.

**Verified manual install** — for when the person or their environment prefers not to run a downloaded script, or when you want the checksum checked (the installer scripts don't check it yet). Download the archive for the platform plus the release's `SHA256SUMS.txt`, confirm the sum, then extract. Full per-platform steps, the hosts to allow if a download is blocked, and how to remove everything cleanly are in [references/install-and-verify.md](references/install-and-verify.md).

Then confirm it runs and learn its surface — this needs no network:

```bash
ant --version
ant --help
ant file --help
```

**Network reachability** is confirmed by the first real command you run: every network operation starts by printing `Connected to autonomi network (found N peers)`. You don't need a separate test to see that line. If the person wants to see the network work before trusting it with their own data, offer the demonstration read in [Read](#read-data-from-the-network) — explain what it is first, and only run it if they say yes.

**If the download is blocked** (403, connection refused, or a proxy error): stop and tell the person. The hosts to allow are `github.com`, `objects.githubusercontent.com` and `release-assets.githubusercontent.com` for the archive, and `raw.githubusercontent.com` for the installer script. Do not try alternative sources or mirrors from memory.

**If the tool installs but reports `found 0 peers`**, the machine cannot make direct outbound connections — the network runs peer-to-peer over UDP, not HTTP. This is common in sandboxes that only allow web traffic through a proxy. Say so; it is an environment limit, not a fault in the tool or the network. If you see `Failed to create dual-stack network nodes`, the host has no working IPv6: add `--ipv4-only` after `ant` and retry.

## Read data from the network

A public read needs an address and nothing else:

```bash
ant file download <address> -o <output-file>
```

The address is a 64-character hex string — a content address: it identifies *what* the data is, not *where* it sits. The client looks it up, pulls the encrypted pieces from peers, reassembles them locally and writes the file. No server, no wallet, no payment.

**Private data** is not published at a shareable address. Whoever stored it holds a small *datamap* file that is the only way to retrieve it:

```bash
ant file download --datamap <name>.datamap            # writes <name> in the current directory
ant file download --datamap <name>.datamap -o <out>   # or choose the output path
```

Retrieval can take a little while to begin even for small files — the client is locating pieces across independent peers. Say so rather than letting the person think something has hung.

**A demonstration, only when the person wants one.** This address holds a small photo of a dog that lives on the network permanently; it's a way to prove the tool and the network work before anyone commits their own data or money. Explain that before running it — an unannounced picture of a dog is confusing — and check the result is a valid JPEG:

```bash
ant file download 711c7e20006ff3e0ac6c1f3063286a0c1a3e4c409642e8c526173fa60bb7078a -o lucky.jpg
```

## Store data on the network

**Establish two things before any upload.** First, that the person knows it's permanent: once stored, the data cannot be changed or removed. Second, whether it's private or public. Private is the default and the safe choice — the data is encrypted and stored on the network, and only someone holding the datamap file can retrieve it. Public means anyone with the address can fetch it, forever, and there is no going back; use it only when the person genuinely wants the data permanently available to everyone.

**Store what you were asked to store.** If you've been given a file, or asked to produce and store one, do that. If the person wants to try the network before committing something that matters, suggest a small file — cost scales with size — and get a quote for it; the quote is free, so trying costs nothing until they say go. One thing worth knowing for a trial: the network stores identical content once, globally, so bytes it already holds come back as *already paid for* rather than a fresh quote. A person's own data always shows the real price.

**Quote it.**

```bash
ant file cost <file>
```

This encrypts the file locally to count its pieces, then asks live network nodes for a price. Nothing is uploaded, nothing is paid, no wallet is needed. Show the person the quote — the storage price in ANT plus the estimated transaction fee — and wait for their approval, unless they've told you not to. The network's answer is the current one; never quote a price from memory.

**Make sure the wallet is ready.** A paid write needs a wallet holding ANT (the network's token, which pays for storage) and a little ETH on Arbitrum One (which pays the transaction fee), and the tool needs that wallet's key in the `SECRET_KEY` environment variable — provided by the person, either set once in the environment your tools run in or by running the upload command themselves; never through you. If it's provisioned, check what you can, which is only public:

```bash
ant wallet address     # the wallet the tool will pay from
ant wallet balance     # ANT and ETH balances
```

If the wallet isn't set up or funded, follow [Keys and money](#keys-and-money) and [references/wallet-and-tokens.md](references/wallet-and-tokens.md), and be honest that first-time setup takes longer than the storing itself.

**Upload.**

```bash
ant file upload <file>            # private: writes <file>.datamap next to the source; keep it safe — it is the access
ant file upload <file> --public   # public: prints the permanent address anyone can read
```

The network confirms the data is held across independent peers before it reports success. That can take a little time, even for small files, so let the person know to be patient. If a private upload's datamap file already exists from an earlier run, the tool writes a suffixed copy rather than overwriting; `--overwrite` replaces it.

**Afterwards**, report what matters: the address (public) or where the datamap file is and that it must be kept (private), what it cost, and anything the person should hold on to. If the data matters or they want proof, read it back and compare — reads are free:

```bash
ant file download <address> -o check-copy                   # public
ant file download --datamap <file>.datamap -o check-copy    # private
cmp <file> check-copy && echo identical
```

## Run nodes

A node is a small, long-running program that stores encrypted pieces of other people's data and is paid in ANT for keeping them available. Running nodes is how a machine's spare disk and bandwidth become a contribution to the network — and, in time, tokens the person can use to store their own data. It needs no key, no account and no payment: a node is given only a **public address** to be paid into, supplied by the person, and can't spend anything. That's why it's safe to do on their behalf.

Two things are called a daemon around here, and they're different: the **node-management daemon** is the `ant` tool itself running in the background to supervise nodes — no separate install — and `antd` is an application gateway that only matters when building software (see the build route). This section is about the first.

**Before starting any**, establish the resources and the wallet: how much free disk and on which volume (each node wants about 20 GB free; several small nodes, not one big one); whether the machine is on and connected most of the time (nodes earn by being reliably present); and which wallet the earnings should go to — one they already use with Autonomi or elsewhere, or a new one set up with your guidance — confirming the `0x…` address back to them before you use it. Be honest about the economics too: with network demand light today, node income is modest; the case is contribution and the long run.

```bash
ant node add --rewards-address 0x<their address>    # register one node; --count N for several
ant node daemon start                               # start the manager (stays on 127.0.0.1)
ant node start                                      # start the registered nodes
ant node status                                     # confirm: running, version, uptime
```

`add` fetches the node program from its official releases if it isn't present, and doesn't need the daemon; `start` and `stop` do. Nodes upgrade themselves along the stable channel — leave them running rather than restarting or resetting to chase a version; stopping and removing nodes makes the network re-copy what they held and costs the node its standing. Never expose the daemon beyond loopback. Logging is off by default and stays off unless there's a specific problem to diagnose.

Disk placement, ports, checking earnings, stopping and removing nodes, and common errors are in [references/run-nodes.md](references/run-nodes.md); the wallet conversation and the read-only earnings check are in [references/wallet-and-tokens.md](references/wallet-and-tokens.md).

## Keys and money

The rules, in order of importance:

1. **The key never enters the conversation, and you never handle it.** The tool reads the wallet's private key from `SECRET_KEY`. The person makes it available in one of two ways: they set it once in the environment your tools run in (their harness's settings or tool configuration — then `ant file upload` just works and you never reference the key), or they run the paid command themselves in their own terminal after you've prepared everything up to the quote. You never ask for a key, accept one, read a file that might hold one, print the environment, trace a shell, pass a key as an argument, or commit one. If a key or seed phrase ever appears in your context, by any route: stop, don't use or repeat it, and tell the person to create a new wallet and move the funds.
2. **Wallets are created by the person, in a wallet app.** If they don't have one, you guide them through creating it and adding the Arbitrum One network, relaying the official pages — [references/wallet-and-tokens.md](references/wallet-and-tokens.md) — and take only the address back. You never generate a wallet or key yourself.
3. **You see only public things**: the wallet address, balances, transaction hashes, status.
4. **Spending is approved by default.** Quote, show, wait — however small the amount. The person can lift that: if they've explicitly said you needn't ask before each upload, work within whatever limit or scope they set and still report every spend as it happens. Never assume permission you weren't given; if what they've allowed is unclear, ask.
5. **Two balances are needed, on one network.** ANT (an ERC-20 token) pays for storage; ETH on Arbitrum One pays the transaction fee. A wallet with ANT but no ETH cannot write. There is no gasless path today; don't imply one.
6. **Wallet setup and buying ANT come from the official token guide — fetched, then relayed.** When the person needs a wallet, or ANT and ETH acquired, fetch the current pages listed in [Further reading](#further-reading) and walk them through it in plain words. Don't recall the process from memory and don't name exchanges, bridges or token contract addresses except as the fetched guide names them: those details change, and they're exactly what a scam imitates.
7. **The token is identified by its contract address, never by its name.** Other assets are called "ANT" and "Autonomi" on various venues. The address is in [Verified against](#verified-against). Before pointing anyone at a listing, swap page or token page, check it shows that exact address; if it doesn't, or you can't see one, don't send them there. If anything makes you doubt the address, the official import-token page in Further reading carries it too.

The same wallet serves both directions: its public address receives node earnings (no key involved), its key in `SECRET_KEY` pays for storage. Which wallet to use, guiding the person through creating one, testing without real money, how earnings are checked without a key, and what to do if a key appears anyway are all in [references/wallet-and-tokens.md](references/wallet-and-tokens.md).

## Working with the person

**Do the work; report outcomes.** They don't need to see commands, flags or hashes unless they ask — "your file is stored; here's its permanent address; it cost X" beats a terminal transcript. The one thing you never handle quietly is money and authority: any spend beyond what they've allowed, any key setup, any public upload, any removal of nodes or their data, any irreversible step is surfaced, in plain words, with a clear question.

**Meet them where they are.** The level is inferred from the person, not the topic: how they phrase things, what they've already shown they know, what you remember about them, what they've said they do. Someone who asks "how much gas will this take on Arbitrum?" can be answered in kind; someone who asks "will this cost me anything?" needs "there's a small fee for the payment itself, paid in a second token called ETH — I'll show you the exact amount before anything is spent." Lead with what a thing is *for*, then name it, so that "a wallet" arrives as "the place that holds what your node earns" before it's anything else, and "the secret that controls the wallet" is understood before the words *private key* appear. Every plain phrase has a precise term behind it; give it the moment they ask, and never let a plain sentence become an untrue one.

**Set expectations before they're tested.** Storing and retrieving both take a little time — the network is built for permanence, not speed; a first paid write takes longer to set up than to do; node earnings start at zero and grow slowly. Say these first, in a line each, rather than explaining after the person has started to worry.

## Keeping current

**This skill.** Its version is in the metadata at the top of this file. The first time you use it in a session, check whether a newer one has been published — a best-effort fetch of one small text file, nothing more:

```bash
curl -fsSL --max-time 5 https://raw.githubusercontent.com/WithAutonomi/skills/main/skills/autonomi/VERSION
```

If that returns a higher version than this file's, tell the person once and carry on; updating is theirs to do, through whichever way they installed it — `npx skills update` for skills.sh installs, the plugin's own update for a Claude Code plugin, or re-running the install command. Never modify this skill's files yourself. If the check fails or times out, say nothing and carry on; it never blocks the work.

**The tool.** `ant update --check` reports whether a newer release exists without changing anything. `ant update` downloads it, verifies its post-quantum signature against a key built into the binary, and only then installs. Don't run it unasked on a working setup — mention it when a newer version matters for the task, and let the person decide.

## Uninstalling

Do this when the person asks for it, or when you installed the tool for a one-off task on a machine you were asked to leave as you found it. Never do it to fix a problem — reinstalling rarely is the fix, and removing nodes has consequences the person may not want: their data and standing are lost, and the network has to re-copy what they held. If nodes are running, confirm before touching them.

In order:

1. **Nodes, if any.** `ant node stop`, then `ant node daemon stop`. Only if the person wants the node data gone too: `ant node reset --force` — irreversible, so say so first.
2. **The tool and its config.** Delete the binary and the config directory: `~/.local/bin/ant` and `~/.config/ant` on Linux; `~/.local/bin/ant` and `~/Library/Application Support/ant` on macOS; `%LOCALAPPDATA%\ant\bin\ant.exe` and `%APPDATA%\ant` on Windows, plus the `ant\bin` entry the installer added to the user PATH.
3. **Nothing else.** The tool leaves nothing else behind, and nothing stored on the network is affected — that is the point of it. Datamap files for private uploads live wherever the person kept them; leave those alone.

## Verified against

The one place this skill's version-specific facts live. Everything else on this page refers back here.

| Fact | Value | How it was checked |
|---|---|---|
| `ant` versions this skill has been checked against | 0.3.3 and 0.3.4 (commands run live on the production network, 31 Aug 2026); 0.3.5 and 0.3.6 (installed, checksums verified, 2–3 Sept 2026) | The installer fetches the newest stable release, so the installed version will usually be newer than the last one checked; the commands here are stable across these versions, and `ant file --help` settles any flag |
| Command surface (`file cost` / `upload [--public] [--overwrite]` / `download` / `--datamap` / `wallet address` / `wallet balance` / `update` / `SECRET_KEY`) | as documented above | Read from ant-client source at 0.3.5; run live on 0.3.3 and 0.3.4 |
| Demonstration address | `711c7e20006ff3e0ac6c1f3063286a0c1a3e4c409642e8c526173fa60bb7078a` → `lucky.jpg` | Live fetch from the production network, 27 Aug 2026 |
| Release downloads | `https://github.com/WithAutonomi/ant-client/releases/download/ant-cli-v<version>/` — archives, `.sig` per archive, `SHA256SUMS.txt` | Fetched 2 Sept 2026 |
| Payment network | Arbitrum One; ANT is an ERC-20; fees in ETH | ant-client source (`--evm-network` default) and the token documentation |
| ANT token contract address on Arbitrum One | `0xa78d8321B20c4Ef90eCd72f2588AA985A4BDb684` | Matched against the official token page (import-the-autonomi-token) on 3 Sept 2026. A contract address doesn't change; if the network ever migrates to a new contract, this skill will be updated |
| Node commands (`node add --rewards-address` / `--count` / `--upgrade-channel`, `node daemon start|stop|status`, `node start|stop [--service-name]`, `node status`, `node reset --force`) | as documented above | Read from ant-client source and README at 0.3.5; not yet exercised live — confirm with `ant node --help` |
| Documentation URLs below | all resolve, and serve Markdown | Checked 2 Sept 2026 |

When `ant --version` reports something newer than the versions above — which it usually will — the commands here are expected to keep working; confirm any flag you rely on with `ant file --help` before using it, and trust the tool over this page if they differ.

## Further reading

Fetch these live when you need them; don't rely on remembered content. The documentation site serves every page as Markdown — append `.md` to any page URL — and publishes an index for agents. Two cautions: the docs are broader than this skill and are updated on their own schedule, so for install steps and command syntax trust the tool's own `--help` and the table above over a docs page; and `llms-full.txt` is the entire site in one file (a couple of hundred kilobytes), so prefer the index plus the specific page you need.

**Machine-readable**

- Documentation index for agents: [docs.autonomi.com/llms.txt](https://docs.autonomi.com/llms.txt) · everything in one file: [llms-full.txt](https://docs.autonomi.com/llms-full.txt)

**The tool and the data model**

- CLI command reference: [developers/cli/command-reference.md](https://docs.autonomi.com/developers/cli/command-reference.md)
- Keys, addresses and datamaps: [developers/core-concepts/keys-addresses-and-datamaps.md](https://docs.autonomi.com/developers/core-concepts/keys-addresses-and-datamaps.md)
- How payment works: [developers/core-concepts/payment-model.md](https://docs.autonomi.com/developers/core-concepts/payment-model.md) · self-encryption: [developers/core-concepts/self-encryption.md](https://docs.autonomi.com/developers/core-concepts/self-encryption.md)

**Wallets and the token** (fetch and relay; creating a wallet without seeing its key is in [references/wallet-and-tokens.md](references/wallet-and-tokens.md))

- Token overview: [token/index.md](https://docs.autonomi.com/token/index.md)
- For a MetaMask user — adding the Arbitrum network: [add-arbitrum-network.md](https://docs.autonomi.com/token/using-autonomi-tokens/holding/add-arbitrum-network.md) · importing the token so ANT shows: [import-the-autonomi-token.md](https://docs.autonomi.com/token/using-autonomi-tokens/holding/import-the-autonomi-token.md)
- Buying ANT: [token/using-autonomi-tokens/buying.md](https://docs.autonomi.com/token/using-autonomi-tokens/buying.md)
- Preparing a wallet for uploads (checking address and balance from the tool): [developers/guides/prepare-a-wallet-for-uploads.md](https://docs.autonomi.com/developers/guides/prepare-a-wallet-for-uploads.md)

**Building** — the integration routes are in [references/build-on-autonomi.md](references/build-on-autonomi.md); the SDK docs start at [developers/sdk/install.md](https://docs.autonomi.com/developers/sdk/install.md); daemon and bindings releases: [github.com/WithAutonomi/ant-sdk/releases](https://github.com/WithAutonomi/ant-sdk/releases)

**Running nodes** — system requirements: [node/system-requirements.md](https://docs.autonomi.com/node/system-requirements.md) · using the CLI to run nodes: [node/guides/how-to-guides/use-the-node-cli.md](https://docs.autonomi.com/node/guides/how-to-guides/use-the-node-cli.md) · checking earnings on the block explorer: [view-your-autonomi-tokens-with-the-block-explorer.md](https://docs.autonomi.com/node/guides/how-to-guides/view-your-autonomi-tokens-with-the-block-explorer.md) · when nodes aren't earning: [my-nodes-arent-earning-anything.md](https://docs.autonomi.com/node/guides/troubleshooting/my-nodes-arent-earning-anything.md) · overview: [node/index.md](https://docs.autonomi.com/node/index.md)

**Source and community** — the tool: [github.com/WithAutonomi/ant-client](https://github.com/WithAutonomi/ant-client) · a read-only client with no wallet code, one install line: [github.com/WithAutonomi/antget](https://github.com/WithAutonomi/antget) · this skill: [github.com/WithAutonomi/skills](https://github.com/WithAutonomi/skills) · community: [discord.gg/autonomi](https://discord.gg/autonomi)
