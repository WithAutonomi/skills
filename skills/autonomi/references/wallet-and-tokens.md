# Wallet and tokens

Read this whenever money enters the picture: a paid write, node earnings, or a person asking what ANT is and how to get some. The rules that matter most are in the main skill under "Keys and money"; this is the detail behind them, for both directions — money coming in from nodes, and money going out for storage.

## The line you never cross

You work with the wallet's **public address** — freely. You never work with its **private key**: you don't ask for it, accept it, read it from a file, print it, log it, or pass it as a command argument, and the person should never paste it into the conversation. If a private key or seed phrase ever appears in your context by any route — pasted by the person, echoed by a command, printed in a trace — stop, don't use it, don't repeat it, and tell the person plainly: that wallet should now be treated as exposed; create a new one and move the funds. No exceptions, however it happened.

## One wallet, two jobs

Everything financial on Autonomi runs through an ordinary Ethereum-style (EVM) wallet on the **Arbitrum One** network. The same wallet can do both jobs:

| | What's needed | What you handle |
|---|---|---|
| **Receive node earnings** | the wallet's **public address** only (`0x` + 40 hex characters) | the address — public, safe to see and repeat |
| **Pay for storage** | ANT and a little ETH in the wallet, and the wallet's **private key** available to the `ant` tool as `SECRET_KEY` | nothing — the person provides it to the tool's environment; you never touch it |

ANT is the network's token (an ERC-20 on Arbitrum One): it's what nodes are paid in and what storage is paid with. ETH on Arbitrum One pays the transaction fee when spending; receiving needs none. So a person who runs nodes and later wants to store data can use the one wallet for both, and the ANT their nodes earned can pay for their uploads — that's the loop the network is built around. Spending it still needs the key available to the tool and a little ETH for fees; be honest that there is no fee-free route today.

## Which wallet? — the conversation

Before adding a node or preparing a paid write, settle the wallet with the person. Ask, don't assume:

**They already have one** — a wallet app such as MetaMask, or one they've used with Autonomi before. Then the address is all you need for earnings; they read it from their wallet app. Reuse it for everything unless they want separation.

**They need one.** Guide them through creating it in a standard wallet app — the next section. You guide; they create; the app keeps the key and its recovery phrase. This is the only way a wallet gets made here.

Whichever it is: **confirm the address back to them** before using it. Read it out in full, check it's `0x` followed by exactly 40 hexadecimal characters, and ask them to confirm it's theirs — earnings sent to a wrong address are gone. Never construct, guess or "fix" an address, and never accept anything that looks like a private key or seed phrase in its place.

## Guiding someone through creating a wallet

Any standard wallet app works; the network's own documentation uses MetaMask as its example, so that's the smoothest path to relay. Only the first step makes the wallet. The other two are for *seeing* ANT inside the app — the network pays the address, and the `ant` tool reads and pays from it, whether or not the app has been told about Arbitrum or the token.

| Step | What the person does | Fetch and relay |
|---|---|---|
| 1. Create the wallet | Installs MetaMask (browser extension or mobile), creates a new wallet, and **writes down the recovery phrase the app shows, keeping it somewhere safe offline** — that phrase is the wallet, and the app won't show it again unprompted | https://docs.autonomi.com/token/using-autonomi-tokens/holding/how-to-create-a-metamask-wallet.md |
| 2. Give you the address | Copies the account address from the app | — |
| Optional — see ANT in the app | Adds the Arbitrum One network in the app's network selector, then imports the ANT token by its contract address (the one in the main skill's *Verified against* table; the page shows the same) | https://docs.autonomi.com/token/using-autonomi-tokens/holding/add-arbitrum-network.md then https://docs.autonomi.com/token/using-autonomi-tokens/holding/import-the-autonomi-token.md |

What to say alongside: the recovery phrase and the private key are the two things that must never be shared with anyone, including you; the address is public and fine to share. For receiving node earnings, step 1 and the address are the whole setup — offer the optional step when they ask how to see what they've earned, or want to send ANT from the app. For spending, they'll also need ANT and a little ETH on Arbitrum One — see below — and buying through the app does need the network added.

Don't route people to hardware-wallet guides or exchange pages for this; those are for holding tokens long-term, not for setting up a wallet an agent will work with.

**Building and testing without real money.** If the person is developing and wants to try writes without spending, the documented route is a local network on their own machine — nodes plus a local payment chain, no real tokens: fetch and relay https://docs.autonomi.com/developers/guides/set-up-a-local-network.md. (The tool also accepts `--evm-network arbitrum-sepolia`, the Arbitrum test network; whether a public test network is running against it at any given time is something to check in the documentation, not assume.)

## Acquiring ANT and ETH — spending only

Receiving needs nothing bought. For spending, the wallet needs ANT and a little ETH, both on Arbitrum One. Two rules before any of the routes below:

**Identify the token by its contract address, never by its name.** Other assets are called "ANT" and "Autonomi" on various venues. The address is the one in the main skill's *Verified against* table — `0xa78d8321B20c4Ef90eCd72f2588AA985A4BDb684` on Arbitrum One — and the official page https://docs.autonomi.com/token/using-autonomi-tokens/holding/import-the-autonomi-token.md carries it too if you want a second look. Check that any exchange listing, swap page or token page you point the person at shows that exact address. If it doesn't, or you can't see one, don't send them there.

**Relay the official buying page, don't improvise venues.** Fetch https://docs.autonomi.com/token/using-autonomi-tokens/buying.md for the current list. Don't add exchanges, bridges or faucets from your own knowledge.

Then guide by where the person is starting from — ask two things: roughly where they are, and whether they already hold any cryptocurrency.

**Starting with a bank card and nothing else.** The fewest-steps path avoids centralised exchanges altogether, which is worth knowing because several of the exchanges listed don't serve the UK, the US, Canada and other territories. Instead: their wallet app's own *Buy* feature (MetaMask and Uniswap both offer one, backed by regulated payment providers) can buy **ETH directly on Arbitrum One** — no separate bridging step — after an identity check with the provider. With ETH on Arbitrum, they swap some of it for ANT on Uniswap (below), keeping a little ETH back for fees. Card purchases carry a few percent in fees; say so.

**Already holding crypto on an exchange.** Withdraw ETH (or USDC) to their wallet address **choosing the Arbitrum One network** at withdrawal — cheaper and faster than bridging — then swap on Uniswap.

**Already holding crypto in their own wallet on another network.** Move it to Arbitrum One with Arbitrum's official bridge (search for it rather than trusting a remembered address, and relay its current steps), then swap. Withdrawing from an exchange straight to Arbitrum is simpler if that's an option.

**The swap itself, on Uniswap.** The official docs page for this is https://docs.autonomi.com/token/using-autonomi-tokens/buying/via-uniswap.md — fetch and relay it; it links Uniswap's page for the token by contract address, and says to keep roughly $10 of ETH on Arbitrum for fees. The person does the swap in their own wallet: you can prepare it for them by giving them that token page, having checked its address against the verified one, so what they see is already the right asset on the right network. They review the amount and confirm in their wallet app; you never sign anything. Two cautions to pass on: the ANT pool on Uniswap is modest, so a large buy moves the price — small amounts, or a few smaller swaps, get a better rate; and Uniswap's own website isn't available in a handful of sanctioned countries, in which case a wallet app's built-in swap reaches the same pool.

Be honest that this first-time setup takes longer than the storing itself, and that for a first write the person needs only a small amount of each.

## Receiving: node earnings

A node is given the address with `ant node add --rewards-address 0x…` and holds nothing else — no key, ever. Earnings arrive as ANT at that address on Arbitrum One. Early on the balance is simply zero — that's normal, not a fault — and earnings depend on how much the network is being used, which today makes them modest.

How the person sees what they've earned depends on what the tool has:

- If the wallet's key is provisioned to the tool (see Spending), `ant wallet balance` shows its ANT balance.
- ETH is checked in the person's wallet app or on the Arbitrum block explorer. If the key isn't provisioned — the usual case for someone who only runs nodes — use the same places for ANT too. The explorer shows any public address without a wallet at all; fetch and relay https://docs.autonomi.com/node/guides/how-to-guides/view-your-autonomi-tokens-with-the-block-explorer.md.

Either way it's the balance of an address, not proof that any particular node earned it.

## Spending: paying for storage

The `ant` tool reads the wallet's private key from the `SECRET_KEY` environment variable for `wallet address`, `wallet balance`, and commands that pay. Reads and cost quotes never need it. The key reaches the tool in one of two ways, and in neither do you handle it:

**Set up once, by the person, in the environment your tools run in.** Wherever your harness takes environment variables for its tools — a settings file, an MCP or tool configuration's `env` block, a profile for the account the agent runs under, or a per-process injector from a password manager — the person puts `SECRET_KEY` there once. After that, wallet checks and `ant file upload` simply work when you run them, and you never reference the key at all. Tell them the variable's name and where their harness keeps such settings; don't set it for them, and don't test whether it's set by printing anything — a wallet command or upload without it says `SECRET_KEY environment variable required`, which is the only check you need.

**Or the person runs the paid command.** You do everything up to the quote, then hand them the exact `ant file upload …` line to run in their own terminal, and they paste back the address or datamap location. One copy-paste per upload; nothing for you to protect.

Either way, the standing rules: never print the environment (`env`, `printenv`, `set`), never run with shell tracing on (`set -x`), never pass a key as a command argument, never write one into a repository or a `.env` file, never read a file that might hold one. The balance checks that *are* yours to run once the key is provisioned show only public things:

```bash
ant wallet address     # the address the tool will pay from
ant wallet balance     # ANT balance
```

Run these *before* asking the person to approve an upload, and have them confirm in their wallet app or the Arbitrum block explorer that the address also has enough ETH on Arbitrum One. A wallet with ANT but no ETH can't pay the fee; ETH on Ethereum mainnet doesn't count.

`ant file upload` asks the network for a price, approves the token spend, pays, and stores the pieces. The transaction is on-chain and irreversible, and the data can't be deleted afterwards — that's the product. So the default is quote, show, wait; if the person has explicitly told you not to ask each time, stay within whatever limit they set and still tell them what each upload cost. And because a wallet the tool can spend from has no limits of its own, suggest the habit every careful setup uses: keep in it only what the next job or two needs, and top up on request.

## What you never do

- Ask for, accept, read, echo, log, store or pass on a private key or seed phrase — in any direction, by any route.
- Generate a wallet or key yourself, or run commands that do.
- Move, withdraw, swap, bridge or spend ANT on the person's behalf beyond a storage payment they've approved.
- Quote a price, an exchange, or a contract address from memory.

And escalate — ask, rather than proceed — when no valid address is available, when the person wants you to hold or manage a wallet, when a balance crosses a limit they've set, or when anything that looks like a key turns up in the task.
