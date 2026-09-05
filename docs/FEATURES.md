# Autonomi Operator Skill — Features (MoSCoW)

## Must Have (MVP)

- [ ] "Why run a node" narrative — secure humanity's data, and earn ANT to store your own data
- [ ] Resource-fit preflight the agent can run (disk, bandwidth, uptime, ports, OS/arch)
- [ ] Install and run one or more nodes, referencing upstream binaries, per platform
- [ ] Verify and monitor node health and earnings
- [ ] Receive rewards to a non-custodial public wallet address (the node holds no key) and check balance
- [ ] Versioned releases and documented updates through each supported installation channel

## Should Have (V1)

- [ ] Secure an agent-owned wallet via an out-of-context custody substrate, with a declared recovery path — gated on the custody-substrate decision (ADR-0004)
- [ ] Spend earned ANT to store and retrieve data on the real path (ANT + Arbitrum gas) — gated on the gas-strategy decision (ADR-0005); no gasless path invented
- [ ] Guidance for running multiple nodes fairly / distributing them
- [ ] Troubleshooting playbook (bundled reference file)
- [ ] Upstream-sweep automation feeding a release pipeline

## Could Have (Future)

- [ ] Listing in an Autonomi-owned marketplace and embedding on the website/docs
- [ ] Automated multi-channel publish (ClawHub, skills.sh, etc)
- [ ] Reputation / fairness guidance for node distribution

## Won't Have (Out of Scope)

- Developer "how to build on Autonomi" content (covered by the Developer skill)
- A GUI
- Reimplementing or re-hosting node binaries

---

## Completed
