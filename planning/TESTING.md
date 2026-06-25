# Testing the autonomi skill

The skill is **agent-run**, so the real test is a *fresh agent installing it and following it end-to-end* — not a human typing commands. This is also the seed for a future CI live-test.

## What "working" means here

A clean-context agent, given only the skill, should: install/detect `ant` → decide a sensible contribution (where node data lives, how many nodes) → add and start a node earning to a public address → confirm health → read the on-chain balance → tear down — and, crucially, **stop and report rather than invent** whenever the skill is missing, ambiguous, or contradicted by the installed tool.

## Evidence so far (OpenCode, 2026-06-25)

Two clean-context runs on Jim's machine:

- **Run 1** surfaced an install-command bug: `skills.sh` can't parse a `tree/<branch>/<path>` URL when the branch name contains a slash. Fixed by using a slash-free branch (`rebuild-skill`).
- **Run 2** (corrected install) — the skill **passed** the reachable stages and behaved exactly as designed:
  - Installed cleanly into OpenCode.
  - Detected existing `ant 0.1.5`; correctly did **not** reinstall.
  - Validated every command/flag it needed against the live `ant … --help`.
  - Validated the public rewards address.
  - Ran preflight, found the system drive had only ~3 GB free and pre-existing nodes it didn't create, and **stopped safely** — touched nothing, invented nothing.
  - This surfaced one real gap (preflight named the ~20 GB bar but gave no check command and no stop-vs-recommend guidance) — **now fixed**.

**Verdict:** install, detect, command/flag validation, address validation, and preflight gating all work; the safety doctrine (don't churn, don't invent, escalate) holds. What's left to prove is the *node actually coming up + a balance read*, which needs a host with room and full egress.

## Repeatable agent-run test

Give a fresh OpenCode (or other) agent this prompt. Use a throwaway public rewards address.

```
You are a fresh agent with no prior knowledge of Autonomi. Install the skill
below, then operate entirely from it — do not use outside knowledge of Autonomi.

INSTALL
  npx skills add WithAutonomi/skills
  (Install into OpenCode. The repo is private, so skills.sh needs your GitHub auth
   set up — install with an account that has access to the org.)

TASK
  Following only the autonomi skill, set up and run one Autonomi node on this
  machine, earning to this public rewards address, then verify it's healthy and
  read its on-chain balance:

    PUBLIC_REWARDS_ADDRESS=0xb4CA36145C204d6629c33caB37796e78B4502b2A

  Work through the skill's own flow: detect/install `ant` → decide where node
  data should live and how many nodes (the skill covers this) → add a node →
  start the daemon and node → confirm status → read the balance. When done, tear
  the test node down using the skill's uninstall procedure and report what you
  removed.

RULES (these are the test)
  - Follow the skill. If anything is missing, ambiguous, or the installed `ant
    --help` contradicts it, STOP and report it — do NOT invent a command, flag,
    or figure, and do NOT route around a blocked endpoint.
  - Non-custodial: only ever pass the PUBLIC address. Never generate, request,
    store, or paste a private key, seed, or keystore. If the task seems to need
    one, stop and report.
  - If a network endpoint is blocked, name the exact endpoint and keep reporting
    rather than working around it.

ENVIRONMENT
  Full network egress. Installing the binary needs `release-assets.githubusercontent.com`;
  the balance read needs `arb1.arbitrum.io` (or another Arbitrum One RPC). A
  default agent sandbox blocks both — if you can't reach them, say so and stop.

REPORT BACK
  For each step (detect, install, capacity decision, add, daemon start, node
  start, status, balance, teardown): what you ran, what happened, whether you had
  to go outside the skill. End with a verdict: could a fresh agent operate
  Autonomi from this skill alone? What was missing, unclear, or wrong?
```

## What a full end-to-end pass needs

- **Disk:** ≥ ~20 GB free on the chosen data volume. On a machine whose system drive is tight, the skill will look for another mounted volume (e.g. an external drive) and place node data there via `--data-dir-path` — so an external drive with space is a valid way to get a real run on an otherwise-full machine.
- **Egress:** `release-assets.githubusercontent.com` (binary) and `arb1.arbitrum.io` (balance RPC) reachable. A default agent sandbox blocks both (see `release-endpoint-accessibility.md`); use a host with broader access.
- **Clean-ish host:** ideally no pre-existing nodes, so teardown is unambiguous; otherwise the agent will (correctly) refuse to touch nodes it didn't create.

Capture the agent's report as evidence; that report is what a CI live-test job should assert against.
