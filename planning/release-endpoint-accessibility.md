# Release endpoint accessibility — agents can't reach the binary CDN

> **Status:** Open · **Owner:** Jim (raise with David — gated, upstream `ant-client` release workflow) · **Becomes:** a future PR to `ant-client` release/install + a skills-side fallback once one exists · **Logged:** 2026-06-24

## Problem

Autonomi nodes are increasingly run by **AI agents**, which often operate in sandboxes with allowlisted network egress. The install path depends on GitHub's **release-asset CDN**, which is commonly blocked even when `github.com` / `raw.githubusercontent.com` are allowed. So `ant` can't be installed and the agent is stuck before it does any work — a silent adoption blocker for a primary audience.

## Evidence (live test, 2026-06-24)

- `install.sh` is fetched fine from `raw.githubusercontent.com`, then downloads the binary from `github.com/WithAutonomi/ant-client/releases/download/ant-cli-v<ver>/<asset>`, which **302-redirects to `release-assets.githubusercontent.com`**.
- In a restricted agent sandbox:
  - **Reachable:** `raw.githubusercontent.com`, `api.github.com`, `autonomi.com`, `index.crates.io`.
  - **Blocked (403):** `release-assets.githubusercontent.com` (the actual binary), `cdn.jsdelivr.net`, `static.crates.io` (no source-build path), `arb1.arbitrum.io` (the balance RPC — a separate but related allowlist issue).
- Net: the binary **could not be fetched by any path**. A `github.com/releases/download` "fallback" doesn't help — it lands on the same blocked CDN.
- Mechanics: release assets are **version-stamped** (`ant-<ver>-<target>.{tar.gz,zip}`), tag `ant-cli-vX.Y.Z`; the latest version is resolvable via `api.github.com/repos/WithAutonomi/ant-client/releases/latest`; archives are signed (ML-DSA-65 `.sig` + `SHA256SUMS.txt`).

## Why it matters

The skill already **fails gracefully** — it names the exact endpoint to allowlist (`release-assets.githubusercontent.com`) rather than flailing or inventing a workaround (see `skills/autonomi/references/node-provisioning.md` and `troubleshooting.md`). But that's a workaround the *human* has to action; it isn't a fix. For autonomous operation we want an install path that works in a default agent sandbox.

## Directions to consider (for a future PR / upstream)

1. **Host binaries on a broadly-permitted domain** — e.g. a mirror on `autonomi.com` (reachable in our test), or another stable, allowlist-friendly host; or commit-pinned assets served via `raw.githubusercontent.com` (size permitting).
2. **Documented install fallbacks** in `install.sh` and the skill — the `api.github.com` asset API, an `autonomi.com` mirror — each **verified via the ML-DSA `.sig` / `SHA256SUMS`** regardless of source, so a non-canonical host doesn't weaken delivery integrity.
3. **Keep naming the allowlist endpoints** (already done) — but pair it with a real alternate, not just an error message.
4. **CI reachability check** that exercises the install endpoints from representative agent-sandbox allowlists, to catch a blocked URL before an agent does.

## Next steps

- Raise with David (the `ant-client` release/hosting decision is a gated, team call).
- If accepted: a PR against `ant-client` (binary hosting + `install.sh` fallbacks), then a skills-side update to add the fallback path once it exists.
- Cross-refs: `REBUILD-BRIEF.md` §7 (install-endpoint accessibility); skill failure-handling in `node-provisioning.md` + `troubleshooting.md`. The blocked balance RPC (`arb1.arbitrum.io`) is a parallel item — the read-only balance path should also take configurable RPC endpoints + fallbacks.
