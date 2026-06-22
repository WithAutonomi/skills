# Node preflight checklist

Date/time:
Operator/user:
Host:
Purpose:

## Authority

- [ ] Authority to detect existing `ant`.
- [ ] Authority to install `ant` if missing.
- [ ] Authority to add/start node(s).
- [ ] Authority to stop node(s).
- [ ] Authority to reset/delete node state, if teardown is planned.
- [ ] No authority granted for private keys, custody, signing, spending, gas funding, withdrawals, bridging, or ANT acquisition.

## Wallet address for node earnings

- [ ] Public wallet address recorded:
- [ ] Address starts with `0x` and has 40 hex characters after the prefix.
- [ ] Address is intended for Arbitrum One ANT earnings.
- [ ] No private key, seed phrase, keystore, or signing token was requested or received.

## Tooling

- [ ] `ant --version` result:
- [ ] `ant --help` result:
- [ ] If installed now, installer used:
- [ ] Verification/checksum/signature status reported truthfully:

## Host/resource checks

- [ ] Disk free space checked; free space exceeds the node storage reserve plus operator-selected headroom.
- [ ] Current source default disk reserve noted as 500 MiB.
- [ ] No fixed per-node storage ceiling assumed; storage auto-scales with available disk.
- [ ] If fixed node ports are used, ports/ranges are free and match node count.
- [ ] If fixed metrics ports are used, ports/ranges are free and match node count.
- [ ] Bootstrap config exists or operator supplied source-backed bootstrap peers.
- [ ] Daemon API will remain on loopback unless explicit exposure authority is recorded.
- [ ] Host uptime/network reliability judged adequate by operator/agent remit.

## Planned command path

```bash
: "${PUBLIC_REWARDS_ADDRESS:?Set PUBLIC_REWARDS_ADDRESS to the public wallet address where node earnings go}"
ant node add --rewards-address "$PUBLIC_REWARDS_ADDRESS"
ant node daemon start
ant node start
ant node status
```

Additional approved flags:

Notes/risks:
