# Running nodes

Read this when the person wants a machine's spare capacity put to work on the network — running nodes — or when nodes are already running and need looking after. The short version is in the main skill; this is the detail.

## What a node is, and what it needs

A node is a small, long-running program that stores encrypted pieces of other people's data, keeps them available, and is paid in ANT for doing so. You run **several small nodes**, not one big one; each is independent. A node never sees readable data — everything it holds is encrypted by its owner before it arrives.

What a node needs from the machine:

- **Disk.** Each node wants at least about 20 GB free — a team recommendation rather than a hard limit, but below it the network is likely to drop that node (it earns nothing; nothing else is affected). Node data can live on the system drive or any mounted volume (`--data-dir-path`); an attached drive is fine with the person's consent. Check free space (`df -h`) and size the number of nodes to it; if no volume has room, say so rather than squeezing a node in. Above the minimum, storage grows on demand.
- **Bandwidth and uptime.** Nodes earn by being reliably present. A machine that is often off or on a poor connection will run nodes that earn little; that's worth saying before starting any.
- **Somewhere for earnings to go.** A public wallet address — see the next section.

What a node does *not* need: a private key, an account, or any payment. Running nodes is safe to do on the person's behalf for exactly that reason.

## Where the earnings go

Settle this with the person before adding any node. Earnings are paid in ANT to a public wallet address on Arbitrum One — `0x` followed by 40 hex characters — and that's all a node is ever given. Ask which wallet they'd like to use:

- If they already have one — from uploading to Autonomi before, from running nodes before, or just a wallet app they use — the address from that wallet is all you need, and reusing it means their earnings and any storage they pay for later sit in one place.
- If they'd rather keep node earnings separate, or have no wallet at all, guide them through creating one in a wallet app — you guide, they create, the app keeps the key. Both are in [wallet-and-tokens.md](wallet-and-tokens.md), along with the ownership steps that must follow. For receiving, no buying is involved and nothing needs configuring: the network pays the address. Adding the Arbitrum network and the token in their wallet app is only for seeing the balance there.

Then confirm the address back to them in full and check the format before using it. Earnings sent to a wrong address are gone. Never construct or correct an address yourself, and never accept a private key or seed phrase in place of one.

Worth saying at the same time, so nobody is surprised later: the balance will read zero for a while; it won't show in their wallet app until they've added the network and the token there (optional — the earnings arrive regardless); and earnings depend on how much the network is being used, which makes them modest today.

## The commands

All part of the `ant` tool. Two pieces: a **node-management daemon** (the `ant` binary running in the background, started with `ant node daemon start` — no separate install) that supervises the nodes, and the nodes themselves.

```bash
ant node add --rewards-address 0x<their address>          # register one node (add --count N for several)
ant node daemon start                                     # start the manager; binds to 127.0.0.1 on a free port
ant node start                                            # start every registered node (needs the daemon)
ant node status                                           # per-node state, version, uptime
ant node daemon status                                    # is the manager running, how many nodes
ant node stop [--service-name node1]                      # stop all, or one
ant node daemon stop                                      # stop the manager (nodes must be stopped first)
```

`ant node add` registers nodes and, if no node program is present, downloads it from the node's own official releases; it doesn't need the daemon and doesn't start anything. `start` and `stop` do need the daemon. `--upgrade-channel stable` (the default) lets nodes upgrade themselves along the stable release channel; leave that alone and keep them running rather than chasing versions by hand. Fixed ports (`--node-port 12000-12004`, a range matching `--count`) are only needed when the person has firewall rules to write.

Confirm with `ant node status`: each node should show as running (or starting) with a version and uptime. That's a live node earning to the person's address.

## Keeping it safe

- **The daemon stays on loopback.** It has no authentication. Never start it with `--listen-addr 0.0.0.0` unless the person explicitly owns that risk and controls the network path.
- **Don't churn.** Stopping and removing nodes forces the network to re-copy the data they held, and a node that comes and goes loses standing. Add nodes deliberately, leave them running, and treat `stop`, `dismiss` and `reset` as health measures, never as tuning.
- **Logging is off by default**, for privacy. Turn it on (`--log-dir-path` at `add` time) only to diagnose a specific problem. Don't read node logs or internal files to judge health.

## How they're doing

There is no rich health readout yet; work with what the tool and the machine give you:

- `ant node status` — running or not, version, uptime, per node.
- The machine itself — free disk, memory, CPU, network — for whether the fleet is right-sized.
- Earnings — the ANT balance at the person's address: `ant wallet balance` if the key is provisioned to the tool, otherwise the person looks in their wallet app or on the block explorer ([wallet-and-tokens.md](wallet-and-tokens.md)). A zero balance early on is normal, not a fault; be honest that with demand light today, node income is modest and the case for running nodes is contribution and the long run, not a return.

Report outcomes, not tables: "your three nodes are running, one has been up since Tuesday, nothing's earned yet" is what the person needs.

## Stopping and removing nodes

When the person wants fewer nodes, or none: `ant node stop` (all, or `--service-name` for one), then `ant node daemon stop`. That leaves the node data and registry in place, so nodes can be restarted later with their standing intact.

`ant node reset --force` deletes all node data and logs and clears the registry — every node has to be stopped first, and it is a last resort for a broken state, never routine. Confirm with the person before running it; there is no undo, and the nodes will start again from zero.

## Common problems

- `ant node start` says the daemon isn't running → `ant node daemon start` first.
- `ant node add` rejects the address → it must be `0x` plus 40 hex characters. Never substitute anything that looks like a key.
- A node shows as not running shortly after start → check free disk on its volume first; then `ant node status` again after a minute.
- The installed `ant node --help` disagrees with this page → trust the tool; report the difference rather than inventing a flag.
