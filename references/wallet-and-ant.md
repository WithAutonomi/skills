# Wallet and ANT — receive side only

Tier 1 receives earnings to a public wallet address and checks that address read-only. It does not create wallets, handle keys, sign transactions, spend ANT, withdraw ANT, or solve gas.

## Wallet address for node earnings

The wallet address your node's earnings go to is a public EVM address used by `ant-node` to receive payments. Source validation requires `0x` plus exactly 40 hexadecimal characters. The node stores the public address, not a private key.

Use it like this:

```bash
: "${PUBLIC_REWARDS_ADDRESS:?Set PUBLIC_REWARDS_ADDRESS to the public wallet address where node earnings go}"
ant node add --rewards-address "$PUBLIC_REWARDS_ADDRESS"
```

## Address sourcing menu

All three are valid when they match the operator remit:

- **Supplied** — a human/principal gives an existing public address.
- **Provisioned** — the environment/operator has already placed a public address in configuration for the agent to use.
- **Agent-created** — first-class for future autonomous operation only when an out-of-context custody substrate creates and secures the wallet. Tier 1 does not provide that substrate.

If no public address is available, stop and ask for one. Do not generate a wallet in the language model context.

## What not to do in Tier 1

- Do not ask for, print, store, or pass private key material.
- Do not use wallet commands that require a spend-capable key path.
- Do not transfer, approve, withdraw, bridge, acquire, or spend ANT.
- Do not tell the user that agent-owned custody is complete. It is a later gated capability.

## What node health does and does not report

`ant node status` and the daemon `/api/v1/events` stream are health/lifecycle surfaces. The current daemon status types and event variants report node IDs, process status, versions, PIDs, uptime, starts/stops/crashes/downloads/upgrades. They do **not** report earned reward totals per node.

Therefore, the key-free balance check is on-chain and read-only.

## Check public ANT balance without a private key

This calls ERC-20 `balanceOf(address)` against the Autonomi payment token on Arbitrum One using public JSON-RPC. It reads public chain state only.

```bash
: "${PUBLIC_REWARDS_ADDRESS:?Set PUBLIC_REWARDS_ADDRESS to the public wallet address where node earnings go}"
ADDRESS_HEX="${PUBLIC_REWARDS_ADDRESS#0x}"
ADDRESS_HEX="${ADDRESS_HEX#0X}"
ADDRESS_HEX="$(printf '%s' "$ADDRESS_HEX" | tr '[:upper:]' '[:lower:]')"
test "${#ADDRESS_HEX}" -eq 40 || { printf 'invalid public wallet address\n' >&2; exit 1; }
case "$ADDRESS_HEX" in (*[!0-9a-f]*) printf 'invalid public wallet address\n' >&2; exit 1;; esac
CALL_DATA="0x70a08231000000000000000000000000${ADDRESS_HEX}"

curl -sS https://arb1.arbitrum.io/rpc \
  -H 'content-type: application/json' \
  --data "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"eth_call\",\"params\":[{\"to\":\"0xa78d8321B20c4Ef90eCd72f2588AA985A4BDb684\",\"data\":\"${CALL_DATA}\"},\"latest\"]}"
```

Interpretation:

- A successful response contains a `result` hex string: the raw ERC-20 balance as `uint256`.
- `0x0` or a 32-byte zero value means the address currently has no token balance.
- Treat the value as an observation of a public address, not proof that a specific node has earned; payments may not have arrived yet.
- If RPC is unavailable, retry later or use an operator-approved Arbitrum One read-only explorer. Never enter a key.

## Why not `ant wallet balance`?

`ant wallet address` and `ant wallet balance` construct a wallet from a private-key environment path in the current CLI. That is a spend-capable path and is prohibited in Tier 1. Use the read-only public balance call instead.

## When to escalate

Ask for human/operator authority when:

- no valid public wallet address is available;
- the operator wants the agent to create or own a wallet;
- the operator wants to move, spend, bridge, approve, or withdraw ANT;
- the public balance grows beyond a remit threshold the operator set;
- a key, seed, keystore, or signing token appears in the task context.
