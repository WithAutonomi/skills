# Next phase — parked workstreams

> Captured 2026-06-25 (Jim). The skill is intentionally at "usable shape." These are the threads that come next — **not** blockers for the current review.

## 1. UX & model-interpretation tuning

The skill is built to the quality bar, but it hasn't been tuned against **how different models read it** and how they translate it back to the human (the agent→human register). Next-phase work: run the skill across several models, observe where interpretation diverges or the human-facing translation misses, and tune wording/structure accordingly. A lightweight, repeatable eval harness (fixed prompts + a rubric, per model) would make this systematic rather than anecdotal. Not yet started.

## 2. Resource-sizing specifics — pending upstream spec

The skill currently carries the **~20 GB/node** minimum as *team-confirmed, pending source*, and treats **bandwidth / memory / CPU** as human judgement with **no source numbers** ("keep the host responsive"). We need real upstream specifics to firm these up:

- **Confirm the disk figure and its semantics.** Is ~20 GB **per node** — additive, so N nodes on one drive want ~20 GB × N (what the skill currently assumes) — or a **shared pool**? **How is the budget managed when multiple nodes share one drive?** This directly affects the capacity math and the `--data-dir-path` placement guidance.
- **Bandwidth, memory, CPU** thresholds / guidance to replace the current judgement-only language.

These belong in the **upstream repos** as the authoritative SOP, with the skill **source-binding** to them (same pattern as commands and flags). Full set of questions for that document: **`planning/node-resource-spec-brief.md`**. Until then, the figures stay flagged as team-confirmed. Tied to the body of work following the **2026-06-24 team call**.

## 3. Skill release automation (from source-bindings)

Not started — deliberately deferred until the skill is usable and in the right shape. The foundation is already here: `source-bindings/` binds every command and figure to upstream code at a pinned commit. The automation (per the rebuild brief's freshness model) watches upstream vs. the manifest → regenerates `SKILL.md`/`references/` → re-releases a versioned snapshot. Jim has prior art from the Docs repo to draw on. Owner: TBD, after the skill settles. **See also #5 (consumer-side delivery), which this produces versions *for*.**

## 4. Consolidate the developer skill into this repo

Move **`autonomi-developer`** (build *on* Autonomi) into `skills/` here, so the repo is the org's single first-party skills home. **Wait until the base `autonomi` skill is up on its feet.** It's non-trivial: the developer skill is draft/beta, carries its own automation, and pulls from the developer docs — a scheduled mini-project, not a copy. (The README lists it as Planned; the rebuild brief §2 has the reasoning.)

## 5. Skill updates (consumer side) — channel-owned

**Decided in Proposed ADR-0013 after a 5 September 2026 review of current first-party skills.** Installed-skill updates belong to the channel that installed the copy, or to deliberate reinstall for a manual copy. The skill makes no first-use network request to check its own version and never modifies its own files. The bundle keeps its resilience mechanism — learn the tool from `ant --help` and trust the tool over the skill — while task-specific, source-bound facts remain separate from self-version checking. ADR-0013's bounded live advisory for typed volatile values (mechanism 4) is still a later protocol/spec.
