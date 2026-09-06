# Archive — the operator skill (v0)

The first `autonomi` skill taught an agent one thing: run Autonomi nodes and earn ANT, non-custodially. It was rebuilt in June 2026 (PR #9), source-bound to upstream code, and agent-tested to the preflight gate. In September 2026 it was retired in favour of the single task-routed `autonomi` skill under `skills/autonomi/` — read, store, build, run nodes — shipped as a prototype for community testing.

These files are verbatim copies of the operator skill as it stood on `main` at commit `70a1f7f` (25 June 2026). **Nothing in this folder ships**: only `skills/<name>/` is installed. They are kept because the node-operation depth here — the deliberate capacity model, `--data-dir-path` placement, the boundary model, single-node removal, the teardown verification step, the pinned source bindings — is the material for growing the prototype's *Run nodes* route once the prototype has proven its shape.

| File | Was |
|---|---|
| `SKILL.md` | `skills/autonomi/SKILL.md` |
| `references/node-provisioning.md` | first-time setup, preflight, placing node data |
| `references/node-operating-procedures.md` | the boundary model, resource strategy, scaling, down-levers |
| `references/node-uninstall.md` | stop / remove one / reset / uninstall, with verification |
| `references/troubleshooting.md` | diagnostics |
| `references/wallet-and-tokens.md` | the public address and the key-free RPC balance read (superseded: the prototype uses `ant wallet balance` or the person's wallet app / explorer) |
| `source-bindings-tier1-operate-and-earn.md` | `source-bindings/tier1-operate-and-earn.md` — every command and figure bound to ant-client / ant-node / evmlib at pinned commits |

Some of what these say is stale against `ant` 0.3.x (install paths on macOS, the `curl | bash` install line, the CDN-only framing of the blocked-download problem). Treat them as a record and a quarry, not as instructions. The live history is `git log -- skills/autonomi` before this archive commit.
