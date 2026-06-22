# ADR-0011: Health observability is query-based, not log-based

- **Status:** Proposed
- **Date:** 2026-06-22
- **Decision owners:** Jim Collinson
- **Reviewers:** David Irvine
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0006 (source-bound; no invented/brittle surface), ADR-0009 (detect-first / non-mutating), ADR-0004 (non-custodial), DESIGN §5 (interface model), §9 (operating boundary), §12 (capability ladder); the operate-and-earn SOP; the upstream "CLI health commands" thread.

## Context

The good-citizen operating SOP wants to observe node health — connectivity, peer count, records stored — to operate well and steward host resources. Source verification (June 2026) established:

- The node **knows this state in-process**: saorsa-core `P2PNode` exposes `is_bootstrapped()`, `peer_count()`, `connected_peers()`, routing-table size, `uptime()`; the storage layer exposes record/byte counts (`current_chunks()` / `stats()`).
- But the **CLI and node-management daemon expose only process-supervision state** — status, pid, uptime, version — plus lifecycle events. **No metrics endpoint is served** (`--metrics-port` is plumbed but inert; the in-repo Prometheus/monitoring configs reference metric names that exist in no source).
- So the only ways to derive richer health **today** are (a) **parsing node logs**, or (b) **reading the node's internal data files** (e.g. the on-disk database size).

Logs are **off by default** (privacy) and accumulate; enabling them fleet-wide to derive ongoing health would bloat storage and is brittle (parsing changeable strings) — counter to the team's no-logs preference and to smooth host operation. Reading the node's internal data files is a precise point-in-time read, but couples the skill to an **undocumented internal layout** — the same brittleness class as log strings.

## Decision Drivers

- No data bloat / no log accumulation for routine operation (team preference; clean host stewardship).
- No coupling to brittle internals (log strings, on-disk file layout) — the spirit of ADR-0006.
- The skill must be **useful now**, within what the CLI/daemon actually expose.
- Health state already exists in-process; the correct exposure is **on-demand queries**, not accumulation.

## Considered Options

1. **Parse node logs for health.** Rejected: needs logging on fleet-wide (bloat), brittle string parsing, against the no-logs preference.
2. **Read the node's internal data files** (e.g. data-dir size) for footprint. Rejected for v1: precise, but couples to undocumented internal layout; same brittleness class; defer until a supported query exists.
3. **Query on demand via supported interfaces; until health commands exist, operate within the current CLI process-state + OS host metrics + on-chain earnings.** Chosen.

## Decision

Health observability is **query-based, not log-based**. The skill does **not** enable node logging for ongoing health, does **not** scrape logs, and does **not** read node-internal files for health signals. Logging remains **off by default** and is used only for **targeted debugging**.

In its first version the skill operates within what is available, with no bespoke instrumentation:

- **Node liveness/state** from the CLI/daemon — status, pid, uptime, version — plus lifecycle events.
- **Host resource state** read from the operating system — CPU, memory, free disk, network. This is the host's own state (not Autonomi internals) and is the basis for host-stewardship decisions.
- **Earnings** read on-chain from the public wallet address.

Richer **network-citizen health** — connectivity, peer count, records stored — is **deferred to on-demand CLI health commands** (pursued upstream). Those values already exist in-process, so exposing them is *surfacing*, not new instrumentation. Until they land, the skill runs in a clearly-bounded **reduced mode** (liveness + host metrics + on-chain earnings) and does not substitute log-scraping or file-sniffing.

The minimal health-query surface the skill needs (input to the upstream thread): **connectivity (bootstrapped/connected), peer count, records stored** — with **relevant/in-range record count** as a stretch (no in-process aggregate exists for it today).

Invariants:

- **No log-scraping for health.** Logging stays off by default; debugging-only; never a health data source.
- **No coupling to node internals** (log strings or on-disk file layout) for health signals.
- **Work within supported interfaces.** Health depth grows when supported queries exist — not by reaching into internals.
- **Host metrics via the OS are always permitted** — host stewardship needs them, and they are not Autonomi internals.
- **Reduced mode is honest:** the skill states what it cannot currently observe rather than inferring it unreliably.

## Consequences

### Positive

- No data bloat; aligns with the team's no-logs stance and clean host operation.
- Not brittle: no dependence on changeable log strings or internal file layouts.
- Ships now within real capabilities, and upgrades cleanly when health commands land.

### Negative / Trade-offs

- v1 has limited network-citizen health awareness (no live peers/records/connectivity), so fine-grained "monitor → adjust" tuning is partial until the upstream commands exist.
- Creates a soft dependency on the upstream CLI health-commands work.

### Neutral / Operational

- Defines the minimal health-query surface (above) as a concrete requirement fed to the upstream thread.
- When health commands ship, this ADR is extended or superseded to record the upgraded capability.

## Validation

A review confirms the skill: enables no logging by default; scrapes no logs; reads no node-internal files for health; derives host decisions from OS metrics and earnings from chain; and clearly states its reduced-mode limits. The clean-context and adversarial gauntlet checks that no health signal is sourced from logs or internal files.

## Notes for AI-assisted work

AI tools may draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted one.
