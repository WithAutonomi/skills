# Channel-owned skill update research

Date: 2026-Sep-05

## Question

Should an ordinary installed skill check its own version when loaded, or should the installation channel own update discovery and delivery?

## Evidence

Eight current first-party skill collections were inspected at fixed revisions. The documentation-path column records an independent fixed-revision verification on 2026-Sep-05; the original review did not preserve its path list.

| Collection | Revision | `SKILL.md` count | Collection documentation inspected |
| --- | --- | ---: | --- |
| [Stripe AI](https://github.com/stripe/ai/tree/68382523846ea5bfad75ba1ef58dc5db031d0a5a) | `68382523846ea5bfad75ba1ef58dc5db031d0a5a` | 48 | `README.md`; `providers/README.md` |
| [Anthropic skills](https://github.com/anthropics/skills/tree/41bbe19d1a1a7eaab5e7bb9050a417e5c6cffc8f) | `41bbe19d1a1a7eaab5e7bb9050a417e5c6cffc8f` | 20 | `README.md` (installation only; no update guidance found) |
| [Vercel agent skills](https://github.com/vercel-labs/agent-skills/tree/063bee94c3f4df8453406c830b0a7df0f2860278) | `063bee94c3f4df8453406c830b0a7df0f2860278` | 9 | `README.md` (installation only; no update guidance found) |
| [Cloudflare skills](https://github.com/cloudflare/skills/tree/b8aeca6d7e2d614d7bd0e5220c8dd7645fe58a93) | `b8aeca6d7e2d614d7bd0e5220c8dd7645fe58a93` | 13 | `README.md` (installation only; no update guidance found) |
| [Sentry for AI](https://github.com/getsentry/sentry-for-ai/tree/6a9642c5b01d7b91daa253a8de4a3ef39c639562) | `6a9642c5b01d7b91daa253a8de4a3ef39c639562` | 34 | `README.md`; `packages/installer/README.md`; plugin README files under `src/plugins/` |
| [Supabase agent skills](https://github.com/supabase/agent-skills/tree/8331f910845103c08d51f6ca1d86ebb7d1f745e3) | `8331f910845103c08d51f6ca1d86ebb7d1f745e3` | 2 | `README.md` (installation only; no update guidance found) |
| [Hugging Face skills](https://github.com/huggingface/skills/tree/97862b0fcc89c850fdd00c82ede1e62d3c930a6d) | `97862b0fcc89c850fdd00c82ede1e62d3c930a6d` | 26 | `README.md` (`hf skills update`) |
| [Shopify AI Toolkit](https://github.com/Shopify/Shopify-AI-Toolkit/tree/2619755e4f4e908fb205e889bac769de1767d40f) | `2619755e4f4e908fb205e889bac769de1767d40f` | 22 | `README.md`; `.hermes-plugin/README.md` |
| **Total** | | **174** | |

Method: enumerate each revision's recursive Git tree, retain blobs whose path ends in `SKILL.md`, search every blob for `version|update|upgrade|outdated|latest|refresh|sync|manifest|remote|fetch|curl|wget`, inspect each match in context, then inspect collection-level installation/update documentation. The read-only command pattern is:

```sh
gh api "repos/${repo}/git/trees/${sha}?recursive=1" --jq '.tree[] | select(.type == "blob" and (.path | endswith("SKILL.md"))) | [.path, .sha] | @tsv'
```

Each returned blob was read at its SHA with `gh api -H 'Accept: application/vnd.github.raw+json' "repos/${repo}/git/blobs/${blob_sha}"` and searched with `rg -n -i 'version|update|upgrade|outdated|latest|refresh|sync|manifest|remote|fetch|curl|wget'`. All eight trees reported `truncated: false`. This fixed-revision candidate review found no ordinary `SKILL.md` checking its own version when loaded; it does not prove that no differently worded implementation could exist. The collections that documented update behaviour assigned it to an installation channel or product CLI; runtime fetching described inside skills was task-specific rather than self-version checking.

The skills.sh implementation was separately checked at [`vercel-labs/skills@5527c09adc367612b0bffd9c80e3bc28a6b01b6d`](https://github.com/vercel-labs/skills/tree/5527c09adc367612b0bffd9c80e3bc28a6b01b6d). Global updates in [`updateGlobalSkills`](https://github.com/vercel-labs/skills/blob/5527c09adc367612b0bffd9c80e3bc28a6b01b6d/src/update.ts#L284-L485) use stored source/ref/path identity and compare folder hashes before reinstalling changed content (GitHub comparison lines 370-372; cloned-source comparison lines 405-407). Project updates select non-local lock entries in [`getProjectSkillsForUpdate`](https://github.com/vercel-labs/skills/blob/5527c09adc367612b0bffd9c80e3bc28a6b01b6d/src/update.ts#L224-L239), then [`updateProjectSkills`](https://github.com/vercel-labs/skills/blob/5527c09adc367612b0bffd9c80e3bc28a6b01b6d/src/update.ts#L487-L648) reinstalls selected, non-deleted skills without a folder-hash comparison. Its recorded `ref` may be a branch or tag and is resolved again during update, so a recorded ref is not by itself an immutable pin; a content-addressed commit SHA or channel-enforced immutable release identifier is needed for that guarantee. Neither update path uses skill frontmatter as a semantic-version comparison contract.

## Decision Input

Jim chose the channel-owned pattern for Autonomi: the installed skill performs no request solely to check its own version and never updates itself. Managed installation channels use their own update mechanism; manually copied bundles require deliberate reinstall. Proposed ADR-0013 records the durable decision. Channel-specific implementation commands and reload behaviour remain source-bound implementation documentation rather than ADR content.
