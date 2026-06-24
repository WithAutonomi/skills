# ADR-0012: Skill name — the product, not a mode of operation

- **Status:** Proposed
- **Date:** 2026-06-24
- **Decision owners:** Jim Collinson
- **Reviewers:** David Irvine, Hermes
- **Supersedes:** none
- **Superseded by:** none
- **Related:** ADR-0002 (single holistic skill), ADR-0003 (operator scope — "operator" as role), ADR-0007 (skills repo + sibling convention), ADR-0008 (distribution — description carries meaning)

## Context

This skill's *function* is to operate and use the Autonomi network, and the design records describe that role as "operator/use" (ADR-0002, ADR-0003). That role language is correct internally — but it is a separate question from what the **shipped skill is named**. Two forces make the name a deliberate product/IA decision, not an echo of the role word:

- **Users encounter Autonomi as the product they want to use — the tool, the network itself — not as a mode of operation.** Someone who has heard of the network thinks "I should install / use **Autonomi**," not "I should install the operator," or "the client." The thing they need to know is the product; the agent handles the rest.
- **The skill grows beyond any one mode.** Per ADR-0002 it is the single, expandable front door to using the whole network — node operation first, then wallet/ANT, then storing data. A role- or mode-named skill ("operator", "node", "client") would mislabel a scope that deliberately outgrows it.

Left unrecorded, the prevalent "operator" language invites the assumption that the skill is named for its role — and recurring "why not Operator / Client / Autonomi Operator?" questions. This ADR settles the name and the naming convention for the skill family.

## Decision Drivers

- Product-first ergonomics: users think in the product, not in modes of operation.
- A single holistic front door (ADR-0002) wants a single product name, not a mode label.
- The scope grows beyond node operation; the name must not pin it to one mode.
- Simple invocation: `/autonomi`, with the agent routing internally.
- No user-facing siloing by mode/use-case; one obvious entry point.
- Set a clear, durable naming convention for companion skills.
- Keep internal role vocabulary (operator, etc.) out of the product name (consistent with the skill-voice principle).

## Considered Options

1. **Role/function name — `operator` / `autonomi-operator`.** Rejected: "operator" is the internal role (ADR-0002/0003), not how users think; over-narrows a skill that grows beyond operating; surfaces internal vocabulary as the product name.
2. **`client` / `autonomi-client`.** Rejected: jargon; ambiguous (client vs node vs the network); not how people refer to Autonomi.
3. **`autonomi-node`.** Rejected: it is not just a node skill; the name would misrepresent the growing wallet/data scope.
4. **The unqualified product name `autonomi` for the primary skill; `autonomi-<qualifier>` for niche/advanced companions.** Chosen.

## Decision

The primary, generalised skill is named **`autonomi`** — the product — invoked `/autonomi`. It is the everyday front door to using the network; the agent routes internally across node operation, wallet/ANT, and (as the skill grows) data, so the user never appends a mode or use-case to the name.

**Companion skills that serve a genuinely different user or mode of use take a qualified name, `autonomi-<qualifier>`** — e.g. `autonomi-developer` (building *on* Autonomi). The qualifier is reserved for a distinct audience/mode, not for slicing the primary skill's own internal capabilities.

"Operator" and "use" remain **internal role descriptors** (ADR-0002/0003), not the product name.

Invariants:
- The primary skill is named for the **product** (`autonomi`), never for a role/mode/use-case.
- Companion skills for a distinct audience/mode use `autonomi-<qualifier>`; the primary stays unqualified.
- Internal role vocabulary (operator, client, node, tier, …) does not appear in the shipped skill name.
- One front door; no user-facing mode silos.

## Consequences

### Positive
- Simple, memorable invocation and information architecture; the product name is what users recognise.
- One front door that matches the single holistic skill (ADR-0002); no mode silos for users.
- A clear convention for the whole skills family; the "why not Operator/Client?" question is answered here.

### Negative / Trade-offs
- A broad product name conveys little about *what the skill does* on its own, so the **`description` carries that load** — both for trigger-matching (agent) and as chooser copy in multi-skill install UX (ADR-0008). The description bar is correspondingly high.
- "Autonomi" the skill vs "Autonomi" the network/product must be disambiguated by context (the skill is how an agent *uses* the network).

### Neutral / Operational
- Folder and frontmatter `name` are both `autonomi` (skills.sh requires `name` == folder); the repository is a separate decision (ADR-0007).

## Validation

The shipped skill's `name` is `autonomi`; companion skills follow `autonomi-<qualifier>`; no role/mode word appears in any shipped skill name; and the description is strong enough to carry meaning where the name is deliberately broad.

## Notes for AI-assisted work

AI tools may help draft this ADR, but **must not mark it Accepted without human review**. Accepted ADRs are immutable: create a new superseding ADR rather than editing an Accepted ADR.
