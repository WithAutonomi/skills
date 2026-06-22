# Operating procedures

Use this file to decide whether a host is ready, how to scale cautiously, and what needs human authority.

## Boundary model

### Network enforces

- A rewards address must be a valid EVM-style public address.
- Node storage refuses writes when available disk space drops below the configured reserve.
- The daemon refuses reset while nodes are running.
- The daemon HTTP API binds to loopback by default; if exposed beyond loopback, it has no authentication.

### Skill recommends

- Start with one node, confirm health, then scale gradually.
- Prefer auto-selected ports unless the operator needs fixed firewall/service rules.
- Keep the daemon on loopback.
- Use public reward-address balance checks only.
- Preserve disk headroom; do not plan against a fixed per-node storage ceiling. Storage auto-scales with available disk space and a reserve.
- Capture preflight and health evidence in the templates before and after changes.

### Agent judges within remit

- Whether the current host has enough spare disk, memory, network reliability, and uptime for the requested node count.
- Whether to add one node or multiple nodes.
- Whether to install, update, reset, uninstall, or delete local state — only within explicit authority.
- Whether an observed balance or node failure crosses a human-escalation threshold.

## Preflight checks

Use `templates/node-preflight-checklist.md`. Minimum source-grounded checks:

- `ant --version` and `ant --help` work, or the operator approves official install.
- Public rewards address is `0x` plus 40 hex characters.
- No private key material is present in the task context.
- Disk has enough free space above the node's reserve; current source default reserve is 500 MiB.
- If using fixed node/metrics ports, those ports are free and ranges match node count.
- Bootstrap config exists from the installer/release or the operator has supplied explicit bootstrap peers.
- Daemon API remains loopback-only unless a human explicitly accepts exposure risk.
- The machine can remain online long enough to be useful; no source-backed numeric uptime threshold is claimed by this skill.

## Scaling procedure

1. Add and start one node.
2. Confirm `ant node status` and daemon status.
3. Wait long enough to see the process remain stable in repeated status checks.
4. Record the health report.
5. If the host still has resource headroom and the operator remit allows it, add more nodes with `--count` and matching port ranges only when fixed ports are needed.

Avoid a one-shot large `--count` unless the operator explicitly requested it and the host is provisioned for it. The CLI has a hard per-call cap to prevent accidental exhaustion, but that cap is not a sizing recommendation.

## Good-citizen heuristics

- Do not pack nodes onto a host just because the CLI allows many nodes in one call.
- Prefer reliable long-running hosts over bursty hosts.
- Keep logs/data in known locations when the operator wants auditability.
- Avoid exposing the daemon API outside the host.
- Stop nodes cleanly before reset/uninstall.
- Report unknowns plainly: if a resource threshold is not in source, say it is an operator judgement, not a network rule.

## Upgrade posture

- The skill, `ant`, and `ant-node` have independent lifecycles.
- Do not run `ant update` merely because this skill changed.
- Use `ant update` only for an explicit compatibility/security reason or operator request.
- If an existing setup is working, prefer observation over mutation.

## Evidence to capture

- `ant --version`
- address validation outcome (public address only; do not record any secret)
- `ant node add` result (service name, data/log dirs, version)
- `ant node daemon status`
- `ant node status`
- read-only balance response or reason it could not be checked
- stop/reset/uninstall commands and results when teardown is requested
