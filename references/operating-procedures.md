# Operating procedures

Use this file to decide whether a host is ready, how to scale cautiously, how to observe health, and what needs human authority. The operating objective is: **network health first, within the host's resource limits; reliable earnings follow as a consequence.**

Do not invent numeric thresholds. If a number is not source-bound in `source-bindings/tier1-operate-and-earn.md`, treat it as operator judgement or upstream/product doctrine to verify, not as a Tier 1 rule.

## Host posture

- **Default: shared host.** Autonomi is a background tenant. Use spare capacity, yield to the host's main work, and keep the machine responsive.
- **Dedicated host only if explicitly declared.** Do not infer that a machine is dedicated. If the human/config has not declared it dedicated to Autonomi, assume shared and run conservatively.
- **Start small.** Add nodes gradually; observe each change before adding more.

## Boundary model

### Network enforces

- A wallet address for node earnings must be a valid EVM-style public address.
- Node storage refuses writes when available disk space drops below the configured reserve.
- The daemon refuses reset while nodes are running.
- The daemon HTTP API binds to loopback by default; if exposed beyond loopback, it has no authentication.

### Skill recommends

- Start with one node, confirm health, then scale gradually.
- Prefer auto-selected ports unless the operator needs fixed firewall/service rules.
- Keep the daemon on loopback.
- Use public wallet-address balance checks only.
- Preserve disk headroom; do not plan against a fixed per-node storage ceiling. Storage auto-scales with available disk space and a reserve.
- Run many right-sized nodes rather than one oversized node, but do not cite unsourced per-address/range figures as rules.
- Spread nodes across distinct connections/address ranges where possible and source-backed; if distribution facts are not source-bound for the current run, state that limitation plainly.
- Keep nodes up and reachable; reliability is better than churn.
- Let managed node upgrades happen through the supported manager path. Do not manually reset or churn nodes as an optimisation move.
- Apply host-level priority/caps from outside the node process when needed; the node does not provide a complete self-throttling policy.
- Capture preflight and health evidence in the templates before and after changes.

### Agent judges within remit

- Whether the current host has enough spare disk, memory, network reliability, and uptime for the requested node count.
- Whether to add one node or multiple nodes.
- Whether to install, update, reset, uninstall, or delete local state — only within explicit authority.
- Whether an observed balance or node failure crosses a human-escalation threshold.

## Preflight checks

Use `templates/node-preflight-checklist.md`. Minimum source-grounded checks:

- `ant --version` and `ant --help` work, or the operator approves official install.
- Public wallet address is `0x` plus 40 hex characters.
- No private key material is present in the task context.
- Disk has enough free space above the node's reserve; current source default reserve is 500 MiB.
- If using fixed node/metrics ports, those ports are free and ranges match node count.
- Bootstrap config exists from the installer/release or the operator has supplied explicit bootstrap peers.
- Daemon API remains loopback-only unless a human explicitly accepts exposure risk.
- The machine can remain online long enough to be useful; no source-backed numeric uptime threshold is claimed by this skill.

## Resource strategy: budgets → node count → monitor → adjust

1. **Budget each resource with headroom.**
   - Disk: keep an absolute free-space floor above the node's source-backed reserve and any operator-declared host floor.
   - CPU/memory: use target conditions, not an invented number. The host should remain responsive, avoid swapping, and not starve the user's work.
   - Network: prefer stable connectivity and long-running availability over bursty operation.
   - Address/connectivity spread: spread when possible, but do not present unsourced numeric distribution claims as current source-backed rules.
2. **Choose node count from the tightest budget.** Disk is not automatically the limiter; memory, bandwidth, host responsiveness, or address/connectivity spread may bind first.
3. **Monitor through supported queries and host OS state.** See query-based observability below.
4. **Adjust deliberately.** Avoid churn; every stop/remove can force network repair work.

Graduated down-levers, from lightest to heaviest:

1. **Stop adding nodes.** Reversible and usually the first response.
2. **Stop a node.** Frees CPU/memory/bandwidth while keeping data and registry state restartable.
3. **Remove/reset state.** Frees disk but is permanent and should be a health-only last resort, never an earnings optimisation. Require explicit authority unless the run was an approved teardown/test.

## Scaling procedure

1. Add and start one node.
2. Confirm `ant node status` and daemon status/info.
3. Wait long enough to see the process remain stable in repeated status checks.
4. Record the health report.
5. If the host still has resource headroom and the operator remit allows it, add more nodes with `--count` and matching port ranges only when fixed ports are needed.

Avoid a one-shot large `--count` unless the operator explicitly requested it and the host is provisioned for it. The CLI has a hard per-call cap to prevent accidental exhaustion, but that cap is not a sizing recommendation.

## Good-citizen heuristics

- Do not pack nodes onto a host just because the CLI allows many nodes in one call.
- Prefer reliable long-running hosts over bursty hosts.
- Keep data locations known when the operator wants auditability, but do not read node-internal files for health.
- Avoid exposing the daemon API outside the host.
- Stop nodes cleanly before reset/uninstall.
- Report unknowns plainly: if a resource threshold is not in source, say it is an operator judgement, not a network rule.

## Query-based observability

Health is query-based, not log-based. Use only supported surfaces:

- `ant node status` for registered node process state.
- `ant node daemon status` and `ant node daemon info` for daemon state/API base/summary.
- Daemon `/api/v1/events` for lifecycle events when needed.
- OS host metrics for host stewardship: CPU, memory, free disk, network availability/pressure.
- Public on-chain balance for the wallet address where earnings are paid.

Do **not** use these as routine health signals:

- no log-scraping for health;
- no enabling node logs for ongoing health; logs stay off by default and are targeted-debugging only;
- no metrics scraping; `--metrics-port` existing as a flag is not a supported health endpoint;
- no reading node-internal files or database paths for health.

Reduced mode is honest: until upstream exposes supported queries for connectivity, peer count, and records stored, do not infer those values from logs or files. If the missing depth matters to a decision, choose the smaller reversible action or escalate.

## Stop / escalate rules

Stop, defer, or ask for authority when:

- the task asks for spending, withdrawing, bridging, approving, acquiring ANT, gas funding, upload/payment, signing, or custody;
- a key, seed, keystore, signing token, `SECRET_KEY`, or `AUTONOMI_WALLET_KEY` appears;
- no valid public wallet address is available for `--rewards-address`;
- a public balance crosses a threshold set by the operator/remit;
- an action cannot be verified against source or looks unsafe;
- host resource pressure means the node fleet is harming the host's main work;
- the next step would expose the daemon beyond loopback, delete state, reset all nodes, upgrade a working setup, or mutate someone else's node registry outside explicit authority;
- a spend-shaped goal has no safe custody/gas substrate.

If no human/principal is reachable at a gate, halt or defer within remit. Never cross a money, risk, recovery, consent, or authority gate unattended.

## Upgrade posture

- The skill, `ant`, and `ant-node` have independent lifecycles.
- Do not run `ant update` merely because this skill changed.
- Use `ant update` only for an explicit compatibility/security reason or operator request.
- If an existing setup is working, prefer observation over mutation.

## Evidence to capture

- `ant --version`
- address validation outcome (public wallet address only; do not record any secret)
- `ant node add` result (service name, data/log dirs, version)
- `ant node daemon status`
- `ant node daemon info` when API base/events are used
- `ant node status`
- read-only balance response or reason it could not be checked
- stop/reset/uninstall commands and results when teardown is requested
