# Next phase — parked workstreams

> Captured 2026-06-25 (Jim, pre-holiday). The skill is intentionally at "usable shape." These are the threads that come next — **not** blockers for the current review.

## 1. UX & model-interpretation tuning

The skill is built to the quality bar, but it hasn't been tuned against **how different models read it** and how they translate it back to the human (the agent→human register). Next-phase work: run the skill across several models, observe where interpretation diverges or the human-facing translation misses, and tune wording/structure accordingly. A lightweight, repeatable eval harness (fixed prompts + a rubric, per model) would make this systematic rather than anecdotal. Not yet started.

## 2. Resource-sizing specifics — pending upstream spec

The skill currently carries the **~20 GB/node** minimum as *team-confirmed, pending source*, and treats **bandwidth / memory / CPU** as human judgement with **no source numbers** ("keep the host responsive"). We need real upstream specifics to firm these up:

- **Confirm the disk figure and its semantics.** Is ~20 GB **per node** — additive, so N nodes on one drive want ~20 GB × N (what the skill currently assumes) — or a **shared pool**? **How is the budget managed when multiple nodes share one drive?** This directly affects the capacity math and the `--data-dir-path` placement guidance.
- **Bandwidth, memory, CPU** thresholds / guidance to replace the current judgement-only language.

These belong in the **upstream repos** as the authoritative SOP, with the skill **source-binding** to them (same pattern as commands and flags). Full set of questions for that document: **`planning/node-resource-spec-brief.md`**. Until then, the figures stay flagged as team-confirmed. Tied to the body of work following the **2026-06-24 team call**.

## 3. Skill auto-update automation (from source-bindings)

Not started — deliberately deferred until the skill is usable and in the right shape. The foundation is already here: `source-bindings/` binds every command and figure to upstream code at a pinned commit. The automation (per the rebuild brief's freshness model) watches upstream vs. the manifest → regenerates `SKILL.md`/`references/` → re-releases a version-pinned snapshot. Jim has prior art from the Docs repo to draw on. Owner: TBD, after the skill settles. **See also #5 (the consumer-side update mechanism), which this produces versions *for*.**

## 4. Consolidate the developer skill into this repo

Move **`autonomi-developer`** (build *on* Autonomi) into `skills/` here, so the repo is the org's single first-party skills home. **Wait until the base `autonomi` skill is up on its feet.** It's non-trivial: the developer skill is draft/beta, carries its own automation, and pulls from the developer docs — a scheduled mini-project, not a copy. (The README lists it as Planned; the rebuild brief §2 has the reasoning.)

## 5. Skill self-update mechanism (consumer side) — decide the model

Distinct from #3 (which *produces* new skill versions). Question to settle: how does an installed copy of the skill **learn it's out of date and update**? Today the skill carries a frontmatter `version` and is installable via skills.sh, so `npx skills update` works — but there's no runtime "check on invocation" authored in the skill (x0x's `SKILL.md` doesn't author one either; its always-latest behaviour is binary-side + the skills.sh version field). Decide: rely on skills.sh's update flow, and/or add an explicit self-check instruction. Note the skill already has a *resilience* mechanism — it tells the agent to verify commands against the installed `ant --help` and trust the tool over the docs — so a stale skill self-corrects on facts even before a version update lands.
