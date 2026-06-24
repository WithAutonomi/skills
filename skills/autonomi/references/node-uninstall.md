# Node uninstall — stopping, removing, and tearing down

Undoing the setup, cleanly. The levers run from gentlest to most destructive — pick the lightest one that does the job, and only touch state you created under the human's remit.

| To… | Use | Deletes data? |
| --- | --- | --- |
| Pause a node, keep its data | `ant node stop` | No — restartable |
| Remove one node, keep the others | daemon `DELETE /api/v1/nodes/{id}` + delete its dirs | Only that node's |
| Remove all nodes and the registry | `ant node reset` | Yes — all node data/logs |
| Remove the `ant` tool itself | delete the binary | The tool |

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
5. Delete only the data/log directories created for that node, and only if they aren't shared with another node.

## Reset — remove all node state (authority required)

`reset` deletes node data and logs and clears the registry, and it fails while nodes are running. Use it only when you own all local node state, or the human explicitly approves clearing every registered node. If the host has other nodes you didn't create, use single-node removal above instead.

```bash
ant node stop
ant node reset           # interactive confirmation
ant node reset --force   # only in an explicitly approved, non-interactive teardown
```

## Uninstall the `ant` tool

Only remove a tool you installed under the human's remit:

1. `ant node stop`
2. `ant node reset` (or `--force`) only when explicitly approved.
3. `ant node daemon stop`
4. Remove the `ant` binary, if this run installed it:
   - Linux: `~/.local/bin/ant`
   - macOS: `/usr/local/bin/ant`
   - Windows: `%LOCALAPPDATA%\ant\bin\ant.exe`
5. `bootstrap_peers.toml` (in the platform config dir): the installers skip overwriting an existing one, so don't delete a pre-existing config without approval.

Then report what you stopped, removed, and deleted — plainly, in the conversation. No key or secret is ever part of that.
