# Wallet and tokens — the public address and ANT

The home for everything to do with the address your nodes earn into and the ANT they earn. Today the skill does two things here, both without any key: it **receives** earnings to a public address, and it **reads** that address's balance. Creating or holding a wallet, signing, spending, withdrawing, or acquiring ANT are later, gated capabilities (see the end).

## The rewards address

A rewards address is a **public** EVM address that `ant-node` uses to receive payments. It must be `0x` followed by exactly 40 hexadecimal characters. The node stores the public address only — never a private key.

```bash
PUBLIC_REWARDS_ADDRESS="<public address supplied by the human>"
ant node add --rewards-address "$PUBLIC_REWARDS_ADDRESS"
```

**Where the address comes from** — all valid when they match the human's remit:

- **Supplied** — a human/principal gives an existing public address.
- **Provisioned** — the environment already holds a public address in config for the agent to use.
- **Agent-created** — first-class for future autonomous operation *only* when an out-of-context custody substrate creates and secures the wallet. This skill does not provide that substrate.

If no public address is available, stop and ask for one. Never generate a wallet in the language-model context.

## What this skill will not do (yet)

- Don't ask for, print, store, or pass any private key, seed, keystore, or signing token.
- Don't use wallet commands that need a spend-capable key path.
- Don't transfer, approve, withdraw, bridge, acquire, or spend ANT.
- Don't tell the human that agent-owned custody is in place — it's a later, gated capability.

## What node health does and doesn't tell you

`ant node status` and the daemon `/api/v1/events` stream report node lifecycle and health — IDs, status, versions, PIDs, uptime, starts/stops/crashes/upgrades. They do **not** report earned ANT totals. So the way to see earnings is on-chain, read-only.

## Check the ANT balance, read-only (no key)

This calls ERC-20 `balanceOf(address)` on the Autonomi token on Arbitrum One over public JSON-RPC. It reads public chain state only:

```bash
PUBLIC_REWARDS_ADDRESS="<public address supplied by the human>"
ADDRESS_HEX="${PUBLIC_REWARDS_ADDRESS#0x}"
ADDRESS_HEX="${ADDRESS_HEX#0X}"
ADDRESS_HEX="$(printf '%s' "$ADDRESS_HEX" | tr '[:upper:]' '[:lower:]')"
test ${#ADDRESS_HEX} -eq 40 || { printf 'invalid public rewards address\n' >&2; exit 1; }
CALL_DATA="0x70a08231000000000000000000000000${ADDRESS_HEX}"

curl -sS https://arb1.arbitrum.io/rpc \
  -H 'content-type: application/json' \
  --data "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"eth_call\",\"params\":[{\"to\":\"0xa78d8321B20c4Ef90eCd72f2588AA985A4BDb684\",\"data\":\"${CALL_DATA}\"},\"latest\"]}"
```

Reading the result:

- A successful response has a `result` hex string — the raw ERC-20 balance as a `uint256`.
- **Report the raw value, or say it's in the token's base units — don't convert to a human-readable ANT figure.** The token's decimals aren't asserted here, so a converted number would be guesswork; if a human needs a friendly amount, get the decimals from source first.
- `0x0` (or a 32-byte zero) means no token balance yet.
- Treat it as an observation of a public address, not proof a specific node has earned — payments may not have arrived.
- If RPC is unavailable, retry later or use a human-approved Arbitrum One read-only explorer. Never enter a key.

## Why not `ant wallet balance`?

In the current CLI, `ant wallet address` and `ant wallet balance` build a wallet from a private key (the `SECRET_KEY` environment variable) — a spend-capable path that's out of scope here. Use the read-only public balance call above instead.

## When to escalate

Ask for human authority when:

- no valid public rewards address is available;
- the human wants the agent to create or own a wallet;
- the human wants to move, spend, bridge, approve, or withdraw ANT;
- the public balance grows beyond a remit threshold the human set;
- a key, seed, keystore, or signing token appears in the task context.
