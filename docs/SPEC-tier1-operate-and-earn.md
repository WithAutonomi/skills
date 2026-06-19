# SPEC — Tier 1: Operate and earn

> Bounded build slice for the Autonomi Operator Skill. Defines what Tier 1 must do, the acceptance bar, the source-bound command surface, and the verification plan. Scope is fixed by the team go-ahead (2026-Jun-18): **author and agent-test Tier 1 only**; ADR-0004 (custody) and ADR-0005 (gas) stay **Proposed** and are not touched. Aligns to DESIGN §2–§6 and §12 and the ROADMAP capability ladder. This is a spec (what the chunk must do), not a plan (order) or an ADR (invariant).

## Scope

**In:** the operate-and-earn journey — explain why; preflight machine fit; install/detect `ant` (verified); configure a **public wallet address**; add/run one and several nodes on the live network; monitor health; check earned rewards for that public address; stop and cleanly uninstall/reset. Good-citizen operating heuristics. Onward pointers to the later (gated) tiers.

**Out (explicitly):** agent-owned custody wrappers; key generation/storage/signing; spending or withdrawing ANT; gas / paymaster; ANT acquisition; user-facing data upload/retrieve as a goal (a public download is used only as an install smoke-test). These are Tier 2/3, gated on the open team decisions.

## Acceptance bar (definition of done)

> A clean-context agent, given only the installed skill, can install/detect `ant`, configure a public wallet address, run/manage one or more nodes on the live network, monitor health, check rewards/balance, and cleanly stop/uninstall — **without seeing or handling any private key.**

## Safety invariants (Tier 1)

- The skill never generates, requests, stores, logs, or passes a private key, seed, or `SECRET_KEY` / `AUTONOMI_WALLET_KEY` (ADR-0004: node non-custodial + secrets-out-of-context).
- The node is configured with a **public `--rewards-address` only**.
- No claim that agent-owned custody or spending is available; the sourcing menu names "agent-created" as first-class for autonomous use but routes its custody substrate onward to Tier 2 (gated; ADR-0004 Proposed).
- Detect-first, install-only-when-missing; mutate an existing `ant` / `ant-node` setup only within granted remit (ADR-0008, ADR-0009).
- Every command/flag/constant is source-bound (ADR-0006); no invented commands or fallbacks.

## Command surface (source-bound; ant-client @ `84332e2d`, dev-docs verified 2026-06-10)

- **Install:** `curl -fsSL https://raw.githubusercontent.com/WithAutonomi/ant-client/main/install.sh | bash` (Linux/macOS) · `irm …/install.ps1 | iex` (Windows) · or build from source (`cargo build --release --bin ant`). Installer also writes `bootstrap_peers.toml`.
- **Verify:** `ant-node` releases ship `SHA256SUMS` + ML-DSA-65 (FIPS-204) signatures — confirm before use, report result.
- **Detect:** `ant --version`, `ant --help`.
- **Add node(s):** `ant node add --rewards-address 0x… [--count N] [--node-port PORT|RANGE] [--metrics-port PORT|RANGE] [--data-dir-path PATH] [--network-id 1] [--upgrade-channel stable]` — `--rewards-address` is required; `--network-id 1` is mainnet.
- **Start / stop:** `ant node start [--service-name NAME]` · `ant node stop [--service-name NAME]` (all, or one).
- **Status:** `ant node status`.
- **Reset:** `ant node reset [--force]` (clears data, logs, registry).
- **Daemon (optional for Tier 1; for SDK/data discovery):** `ant node daemon start|stop|status|info`.
- **CLI self-update:** `ant update [--force]`.
- **Network selection:** `--evm-network arbitrum-one` (live).
- **Wallet (receive side):** the node needs only the public address. `ant wallet address` / `ant wallet balance` derive from `SECRET_KEY` (a **private** key) → **not used in Tier 1.** Balance-check path is an open question below.

## Deliverables

- `SKILL.md` — lean, routing-first entry (opener · task routing · core concepts · safety boundaries · routing table), Tier-1 scoped, onward pointers to later tiers; frontmatter (name, triggering-tuned description, version, license, keywords).
- Install manifest on x0x's `metadata.openclaw.install` pattern — installs the existing `ant`, verifies signatures/checksums; documents clean uninstall.
- `references/node-operation.md` — install → preflight → add → start → status/monitor → stop → reset/uninstall.
- `references/wallet-and-ant.md` (receive side) — what a public wallet address is; non-custodial by construction; the sourcing menu (supplied / provisioned / agent-created, the latter first-class but its substrate gated to Tier 2); how to check the reward balance **without a private key**.
- `references/operating-procedures.md` — good-citizen heuristics + the network-enforces / skill-recommends / agent-judges boundary model.
- `references/troubleshooting.md`.
- `templates/` — `node-preflight-checklist`, `node-health-report`, `human-authority-request`.

## Open questions to resolve during authoring (grounded, not invented)

1. **Balance check without a key.** Confirm whether `ant node status` and/or the daemon `/api/v1/events` SSE stream report earned rewards per node; and/or document the read-only ERC-20 `balanceOf(rewards_address)` path via an Arbitrum RPC / explorer (the ANT token contract address is a source-bound volatile fact). `ant wallet balance` is out (needs `SECRET_KEY`).
2. **Daemon vs node-services.** Confirm whether `ant node add` / `start` require `ant node daemon start` first, or manage services independently.
3. **Minimal live-node invocation.** Confirm the smallest correct flag set for a healthy mainnet node (`--network-id 1` / `--evm-network arbitrum-one`) and any required bootstrap.
4. **Resource preflight thresholds.** What to check (disk, RAM, ports, bandwidth, uptime) and grounded recommended ranges — storage auto-scales (no fixed per-node ceiling); do not invent figures.

## Verification plan (the gauntlet)

- **Clean-context test** — `gsd-clean-context-tester`, given only the installed skill, runs the acceptance-bar journey on the **live network**; capture evidence (commands, outputs, a node visible in `ant node status`, balance-check result, clean teardown).
- **Adversarial review** — `gsd-adversarial-reviewer` tries to disprove readiness: any step that needs a private key, an invented command/flag, a missing fallback, an unsafe default, or an over-claim about custody/spend.
- Blockers resolved or explicitly accepted by Jim. Nothing transfers to WithAutonomi or publishes without sign-off.

## Source bindings

- Command surface: ant-client `ant-cli/src/cli.rs`; dev-docs `docs/cli/command-reference.md` & `use-the-cli.md` (header: ant-client commit `84332e2d`, verified 2026-06-10).
- Install: ant-client `install.sh` / `install.ps1`.
- Verification: `ant-node` releases `SHA256SUMS` + ML-DSA-65 (FIPS-204).
- Public wallet address (non-custodial): ant-node `--rewards-address`, `src/payment/wallet.rs`.
- Health: `ant node status`; daemon `/api/v1/events` SSE; `--metrics-port` exists but no `/metrics` endpoint is served — do not scrape it.
