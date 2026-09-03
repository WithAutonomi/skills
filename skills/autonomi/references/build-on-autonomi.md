# Building Autonomi into software

Read this only when the person's task is building or integrating — an application, a service, a pipeline — rather than storing or fetching something themselves. Everything in the main skill still applies: reads are free, writes are quoted and approved, keys never enter the conversation.

## Where it fits in a stack

Autonomi is the **permanence tier**: the place for data that must outlive the servers that produced it. It is not a CDN, a cache or a database, and it is slow by those standards on purpose.

| Operation | Typical today |
|---|---|
| Store a small file (~1 MB) | 0.5–2 min, including payment |
| Store 1 GB | ~3–6 min |
| Retrieve — first byte | ~20 s |
| Retrieve 1 GB | ~1 min |

**Right for:** checkpoints, artefacts, archives, app and user data written in the background, source-of-truth records, anything that must be citable forever.
**Wrong for:** request paths, interactive reads, bulk ingest at terabyte scale.
**Worth designing around:** addresses never change, so fronting Autonomi with any cache is trivial — cache forever, invalidate never. Write in the background; read through a cache; treat the address as the durable reference.

State these figures to the person as characteristics, not fine print; they decide where the network belongs in the design and they prevent a bad surprise later.

## What the network gives an application

Each of these is a property the design can rely on:

- **Accountless storage.** No sign-up, no API keys, no billing relationship. Write data, get an address back.
- **One-time payment.** Paid at write, never again. No subscriptions, no renewals.
- **Free reads.** No egress fees, no retrieval tiers, no metering, at any volume.
- **Content-addressed data.** The address is derived from the content — what you fetch is provably, byte-for-byte, what was stored.
- **Automatic deduplication.** Identical content resolves to the same address network-wide; pieces the network already holds aren't paid for again.
- **Encryption by default.** Self-encrypted on the client before data leaves the machine. Unreadable to nodes and to the network.
- **Immutable data.** Cannot be altered or deleted by any party. Addresses are safe to hard-code, cite and cache forever.
- **Public or private.** Public data is published at a shareable address; private data is retrievable only by whoever holds its datamap.

## Ways in

Three integration routes exist today. Choose by how the software is built, not by preference.

**1. The `ant` command line, scripted.** Everything in the main skill, driven from the application's own process. Simplest, no daemon, works anywhere the binary runs. Right for batch jobs, build pipelines, back-office archiving, and any language that can spawn a process. Use `--json` for machine-readable output on every command.

**2. The local daemon, `antd`, with language bindings.** A local gateway process the application talks to over REST or gRPC, with bindings for fifteen languages (Rust, Python, JavaScript/TypeScript, Go, C#, Java, Kotlin, Swift, Ruby, PHP, Dart, Lua, Elixir, Zig, C++). Right for long-running services and anything that wants a typed client rather than a subprocess. Install `antd` from its GitHub releases — binaries and native installers for macOS, Linux and Windows at [github.com/WithAutonomi/ant-sdk/releases](https://github.com/WithAutonomi/ant-sdk/releases). Note: the repository root is a set of bindings directories, not a single build; use the released binaries rather than cloning and building.

The daemon has a useful safety property for applications: it can run in an *external-signer* mode with no wallet key at all, handing payment details back to the caller to sign elsewhere. If the design wants the key kept out of the application process, that's the seam to build on.

**3. The MCP server, `antd-mcp`,** which exposes the daemon's operations as tools for agents. It is not a one-step install today — it needs the `ant-sdk` repository, an editable Python install of `antd-mcp/`, and a running daemon — so recommend it only when the person is specifically building an agent-facing integration and can accept that setup. Say so rather than presenting it as equivalent to the other two.

Whichever route: fetch the current documentation at [docs.autonomi.com/developers](https://docs.autonomi.com/developers) before writing integration code, and confirm the daemon or CLI version you are targeting. Versions move; your memory of the API doesn't.

## Money in an application

The same rules as for a person, applied to a process:

- The key lives in the environment of whatever process pays (`SECRET_KEY` for `ant`; the daemon has its own variable — check its docs), never in source, config files, logs or the conversation.
- Design for the quote/approve/upload sequence: a service that writes autonomously needs a spend policy the owner has agreed to, and should surface spend beyond it rather than proceed.
- Budget both balances — ANT for storage, ETH on Arbitrum One for fees — and monitor them; an application that runs out of ETH stops being able to write even with plenty of ANT.
- Deduplication means re-uploading unchanged data costs nothing and returns the same address; design idempotent writes around that.

## Choosing whether Autonomi is the right fit

Sometimes it isn't, and the person is better served hearing that early. It's the wrong choice when the data needs to be mutable in place, when reads must be fast enough for an interactive request path, when the application needs to delete data on demand, or when the volume is bulk ingest at terabyte scale. It's the right choice when the data must be permanent, when the cost model should be one payment rather than a subscription, when readers shouldn't need an account, or when the address itself needs to be trustworthy evidence of what was stored.
