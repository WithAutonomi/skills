# Channel-owned skill update research

Date: 2026-Sep-05

## Question

Should an ordinary installed skill check its own version when loaded, or should the installation channel own update discovery and delivery?

## Evidence

Eight current first-party skill collections were inspected at fixed revisions:

- [Stripe AI](https://github.com/stripe/ai/tree/68382523846ea5bfad75ba1ef58dc5db031d0a5a)
- [Anthropic skills](https://github.com/anthropics/skills/tree/41bbe19d1a1a7eaab5e7bb9050a417e5c6cffc8f)
- [Vercel agent skills](https://github.com/vercel-labs/agent-skills/tree/063bee94c3f4df8453406c830b0a7df0f2860278)
- [Cloudflare skills](https://github.com/cloudflare/skills/tree/b8aeca6d7e2d614d7bd0e5220c8dd7645fe58a93)
- [Sentry for AI](https://github.com/getsentry/sentry-for-ai/tree/6a9642c5b01d7b91daa253a8de4a3ef39c639562)
- [Supabase agent skills](https://github.com/supabase/agent-skills/tree/8331f910845103c08d51f6ca1d86ebb7d1f745e3)
- [Hugging Face skills](https://github.com/huggingface/skills/tree/97862b0fcc89c850fdd00c82ede1e62d3c930a6d)
- [Shopify AI Toolkit](https://github.com/Shopify/Shopify-AI-Toolkit/tree/2619755e4f4e908fb205e889bac769de1767d40f)

Method: enumerate the 174 `SKILL.md` files at those revisions; search their instructions for version, update, manifest, and remote-fetch behaviour; inspect every match in context; then inspect collection-level installation/update documentation where present. No ordinary `SKILL.md` checked its own version when loaded. The collections that documented update behaviour assigned it to an installation channel or product CLI; runtime fetching described inside skills was task-specific rather than self-version checking.

The skills.sh implementation was separately checked at [`vercel-labs/skills@5527c09adc367612b0bffd9c80e3bc28a6b01b6d`](https://github.com/vercel-labs/skills/tree/5527c09adc367612b0bffd9c80e3bc28a6b01b6d). Its updater uses stored source/ref/path identity plus folder hashes and reinstalls changed content; it does not use skill frontmatter as a semantic-version comparison contract.

## Decision Input

Jim chose the channel-owned pattern for Autonomi: the installed skill performs no request solely to check its own version and never updates itself. Managed installation channels use their own update mechanism; manually copied bundles require deliberate reinstall. Proposed ADR-0013 records the durable decision. Channel-specific implementation commands and reload behaviour remain source-bound implementation documentation rather than ADR content.
