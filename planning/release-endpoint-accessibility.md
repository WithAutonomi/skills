# Release endpoint accessibility — agents can't always reach the binary

> **Status:** Updated 2026-09-03 — the skill now handles the blocked cases; the durable fix is npm distribution, tracked upstream as [ant-client #190](https://github.com/WithAutonomi/ant-client/issues/190) (post-launch, agreed with Chris) · **Owner:** Jim · **Logged:** 2026-06-24

## Update — 2026-09-03

What changed since June:

- **Which host blocks varies by sandbox.** In a Claude Code cloud container (Sept 2026) the release download itself succeeded while **`api.github.com`** — which `install.sh` uses only to find the latest version — returned 403. Other sandboxes block the release CDN (`release-assets.githubusercontent.com`) as observed in June. Both cases are real; neither is universal.
- **The skill handles both without inventing a host.** The installer is fetched and read before running (no `curl | sh`), installs the latest stable release by default; if the version lookup is blocked, the manual path reads the version from `https://github.com/WithAutonomi/ant-client/releases/latest/download/SHA256SUMS.txt` (reachable without the API), downloads the archive and verifies its checksum; `ANT_VERSION=<version>` makes the installer skip the lookup. If the download host itself is blocked, the skill names the exact hosts and stops. See `skills/autonomi/references/install-and-verify.md`.
- **The durable fix is a package manager.** npm is on every default sandbox allowlist we checked; skill-directory scanners pass package-manager installs and flag direct downloads. Distributing the signed `ant` binary through npm (esbuild-style optionalDependencies, the pattern Biome, Turborepo, swc, Deno and Stripe's CLI use) is filed as **ant-client #190**.
- **Still asks on ant-client:** unversioned release-asset aliases (so `releases/latest/download/ant-<target>.tar.gz` doesn't go stale per release); checksum or signature verification inside `install.sh` / `install.ps1`.
- **The `arb1.arbitrum.io` concern is moot.** The prototype no longer performs a raw RPC balance read; it uses `ant wallet balance` when the key is provisioned to the tool, otherwise the person's wallet app or the block explorer.

The original note follows for the record.

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

The skill already **fails gracefully** — it names the exact endpoint to allowlist rather than flailing or inventing a workaround. But that's a workaround the *human* has to action; it isn't a fix. For autonomous operation we want an install path that works in a default agent sandbox.

## Directions considered (June 2026)

1. **Host binaries on a broadly-permitted domain** — e.g. a mirror on `autonomi.com` (reachable in the June test), or another stable, allowlist-friendly host; or commit-pinned assets served via `raw.githubusercontent.com` (size permitting). *Set aside in Sept: a new host is a new seam to allowlist and a new thing to keep in sync; npm is the host every sandbox already allows.*
2. **Documented install fallbacks** in `install.sh` and the skill — each **verified via the ML-DSA `.sig` / `SHA256SUMS`** regardless of source, so a non-canonical host doesn't weaken delivery integrity. *The skill's manual path does this for the checksum.*
3. **Keep naming the allowlist endpoints** — but pair it with a real alternate, not just an error message. *Done in the skill.*
4. **CI reachability check** that exercises the install endpoints from representative agent-sandbox allowlists, to catch a blocked URL before an agent does. *Still open.*

## Cross-refs

`REBUILD-BRIEF.md` §7 (install-endpoint accessibility); `skills/autonomi/references/install-and-verify.md`; `planning/TESTING.md` (environment variants); ant-client #190.
