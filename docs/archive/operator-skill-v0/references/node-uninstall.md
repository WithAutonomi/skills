# Node uninstall — stopping, removing, and tearing down

Undoing the setup, cleanly. The levers run from gentlest to most destructive — pick the lightest one that does the job, and only touch state you created under the human's remit.

| To… | Use | Deletes data? |
| --- | --- | --- |
| Pause a node, keep its data | `ant node stop` | No — restartable |
| Remove one node, keep the others | daemon `DELETE /api/v1/nodes/{id}` + delete its dirs | Only that node's |
| Remove all nodes and the registry | `ant node reset` | Yes — all node data/logs |
| Remove the `ant` tool itself | delete the binary + config | The tool |

The daemon and nodes are **processes the daemon supervises, not OS services** — nothing is registered to start at boot, so there's no service to unregister. Stopping them, clearing node state, and removing the binary is the whole job.

## Stop a node (reversible)

```bash
ant node stop                       # all nodes
ant node stop --service-name node1  # one node
ant node daemon stop                # stop the daemon once nodes are stopped
```

Stopping frees CPU / memory / bandwidth and keeps the node's data — it's restartable. This is the right lever for easing load; it isn't teardown.

## Remove one node, preserving others

When you added a node on a machine that already has other registered nodes, remove only yours — don't `reset` (that clears everything):

1. Note the node ID, service name, data dir, and log dir from `ant node add` / `ant node status`.
2. Stop that node:

   ```bash
   ant node stop --service-name node11
   ```

3. Ensure the daemon is running and get the API base:

   ```bash
   ant node daemon start
   ant --json node daemon info
   ```

4. Remove only that registry entry, using the reported API base and the node ID:

   ```bash
   curl -sS -X DELETE http://127.0.0.1:PORT/api/v1/nodes/11
   ```

   The daemon refuses to remove a node while it's running, so stop it first.
5. Delete only the data/log directories created for that node — and only if they aren't shared with another node. If you placed it on a custom location with `--data-dir-path` / `--log-dir-path` (e.g. an external volume), delete it **there**, on that volume — the default-path list below won't cover it.

## Reset — remove all node state (authority required)

`reset` clears the registry and removes each node's **recorded** data directory — including custom `--data-dir-path` locations — and it fails while nodes are running, so stop them first. It only removes dirs it can **reach**: if any node's data lives on an **external or secondary volume, mount that volume before you reset**, or its data is left behind. Use `reset` only when you own all local node state, or the human explicitly approves clearing every registered node. If the host has other nodes you didn't create, use single-node removal above instead.

```bash
ant node stop
ant node reset           # interactive confirmation
ant node reset --force   # only in an explicitly approved, non-interactive teardown
```

Log directories may not be swept by `reset` — confirm and remove them as part of *Node data on other volumes* and *Confirm teardown*, below.

## Node data on other volumes

If you used `--data-dir-path` (or `--log-dir-path`) to place node data off the system drive, teardown has to follow it there:

- **Mount the volume(s) first**, so `reset` / single-node removal can clean the recorded dirs.
- **Afterwards, confirm the directory is actually gone** on that volume; if a drive was detached during teardown, remove the leftover dir manually once it's reattached.
- Do the same for any custom **log** directory.

## Uninstall the `ant` tool

Only remove a tool you installed under the human's remit:

1. `ant node stop`
2. `ant node reset` (or `--force`) only when explicitly approved.
3. `ant node daemon stop`
4. Remove the `ant` binary, if this run installed it — at its install dir: default Linux `~/.local/bin/ant`, macOS `/usr/local/bin/ant`, Windows `%LOCALAPPDATA%\ant\bin\ant.exe`, or wherever `INSTALL_DIR` pointed.
5. Bootstrap config + config dir, **only if this run created them** — the installer skips an existing `bootstrap_peers.toml`, so don't delete a pre-existing one without approval:
   - Linux: `${XDG_CONFIG_HOME:-~/.config}/ant/` (holds `bootstrap_peers.toml`)
   - macOS: `~/Library/Application Support/ant/`
6. The installer **doesn't edit `PATH` or install any service**, so there's nothing else registered to undo. If *you* added the install dir to a shell `PATH` (in `.bashrc`/`.zshrc` or similar), remove that line.

## Confirm teardown

Before declaring done:

- `ant node status` lists none of the nodes you created (run it before removing the binary); `ant node daemon status` shows the daemon stopped.
- The data and log directories are gone — including any custom `--data-dir-path` / `--log-dir-path` locations on other volumes.
- The binary is gone from its install dir.

Then report what you stopped, removed, and deleted — plainly, in the conversation. No key or secret is ever part of that.
