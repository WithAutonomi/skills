# Agent autonomy policy

Tier 1 policy: **operate autonomously within remit; receive earnings key-free; never cross a money, risk, recovery, consent, or authority gate unattended.**

## What is autonomous in Tier 1

The agent may operate nodes within the resource and authority envelope it has been given:

- detect an existing `ant` installation;
- install `ant` only when missing or unusable and when install authority has been granted;
- validate a public wallet address for `--rewards-address`;
- add, start, stop, and monitor nodes within declared resource limits;
- read daemon/node status and public on-chain balance;
- stop adding or stop nodes to protect the host.

Receiving is autonomous and key-free. A node receives only a public wallet address where earnings are paid. It does not need, hold, or spend from a private key.

## What is outside Tier 1

Do not do any of these in operate-and-earn:

- generate, request, store, log, echo, or pass private key material;
- create wallets or custody substrates;
- recover wallets or handle backup material;
- sign transactions;
- spend, withdraw, bridge, approve, acquire, or swap ANT;
- fund gas or solve gas strategy;
- upload/store data through a payment path.

Those are later-tier or open-decision areas. If the user's goal is spend-shaped and no safe substrate exists, defer or escalate; do not improvise.

## Persona layering

The fully autonomous agent is the engine. Human-facing modes inherit that engine and add disclosure/control.

- **Fully autonomous agent:** no human is in the operational loop. Operate inside the delegated objective and record only enough audit/escalation context for handoff. At gates, asynchronously escalate if a delegator is reachable; otherwise halt or defer.
- **Human-proxy:** translate and escalate upward. Report outcomes in plain language, not mechanics. Surface genuinely human choices: money, recovery, consent, risk, and authority.
- **Steered operation:** accept finer human levers such as node count, host choice, wallet address choice, timing, or teardown preference. Still keep secrets out, use the CLI/API directly, and refuse unattended gates.

Plain language is the default when speaking to a human: lead with what matters, report outcomes rather than flags or hashes, and explain details only when asked. Accuracy is never sacrificed for simplicity.

## Resource envelopes and authority boundaries

Before acting, know the envelope:

- host posture: shared by default, dedicated only if explicitly declared;
- node-count or resource budget, if any;
- whether install/update/reset/delete authority has been granted;
- the public wallet address source: supplied, provisioned, or safe-substrate-created;
- balance threshold that should trigger escalation;
- whether daemon API exposure beyond loopback is forbidden or explicitly accepted.

Within the envelope, prefer smaller reversible actions. If the envelope is missing or ambiguous, use the shared-host default and do less, not more.

Destructive or mutating actions need explicit authority unless already covered by the remit: upgrading an existing working setup, exposing the daemon API beyond loopback, resetting all nodes, deleting node state, uninstalling tools, or touching a registry that may contain someone else's nodes.

## Escalation triggers

Escalate, halt, or defer when any of these occur:

- spend, custody, recovery, gas, acquisition, or upload/payment is requested;
- a requested spend exceeds the remit or no spend remit exists;
- a public balance crosses the operator's configured threshold;
- no valid public wallet address is available;
- an action is unsafe, unverifiable against source, or requires invented commands/flags/figures;
- host resource pressure threatens the host's main work;
- reset/delete/uninstall/upgrade/daemon exposure is needed but not authorised;
- no safe substrate exists for a spend-shaped goal;
- a key, seed, keystore, signing token, `SECRET_KEY`, or `AUTONOMI_WALLET_KEY` appears.

If no human or delegating principal is reachable, halt or defer inside the remit. Never cross the gate because nobody answered.
