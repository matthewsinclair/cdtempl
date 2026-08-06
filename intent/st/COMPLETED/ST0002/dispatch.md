---
verblock: "30 Jul 2026:v0.1: Matthew Sinclair - Who gets what: eight recipients, two audiences"
---

# Dispatch

Eight recipients, two audiences, one shared substrate each. Written 30 July 2026 after `cdsync install` landed, which changed the instruction every prior note carried.

**Transport is hv.** Nothing here sends itself.

## The two standing documents

| Audience | Document | Purpose |
| -------- | -------- | ------- |
| Claude Design sessions | `intent/docs/claude-design-contract.md` | The standing contract every round is written against. Not a brief |
| Cdsync-using projects | `intent/docs/receiving-a-design-system.md` | How to get a drop in and what to do with it. Self-contained |

Both are self-contained on purpose: a Claude Design session generally cannot read the Cdsync repository, and a project session should not need to.

## (a) The four Claude Design sessions

Each gets **`claude-design-contract.md`**, plus:

| Session | Also send | Why |
| ------- | --------- | --- |
| Lamplight | `ST0002/port-brief-lamplight.md` | Conversion round one. Carries the numbering high-water marks by hand |
| Baize | `ST0002/port-brief-baize.md` | Same. Its drop is currently ahead of the repo on ADR-0025 |
| snorkeltoast | `ST0002/port-brief-snorkeltoast.md` | Same, but the opposite instruction on the central point -- see below |
| Gyre & Gymble | *nothing else* | Already Cdsync-shaped. It is the only drop `check` passes |

**Three things in the contract document are new to all four**, and are the reason G&G gets a note despite needing no conversion:

- **`classification` on every `spec.md`** -- `public` / `internal` / `confidential`, an axis of its own rather than a flavour of `audience`. It governs where material may be shown, never whether it is committed.
- **Never allocate an ADR/ST/WP number blind.** The brief carries the project's high-water marks. If a brief arrives without them, ask before allocating.
- **Corrections land at source.** A fix in a delivery is reverted by the next export.

**snorkeltoast's brief says the opposite of the other two on the central point.** Lamplight and Baize each hold one document spanning colour, type, grid, components and states, and are told **not to split it**. snorkeltoast is already decomposed along the taxonomy's lines, so its rule is **do not merge**. Do not send these three as though they were one instruction in three envelopes.

**Still unruled and named as such in the contract: finding 5** -- whether `formats_required` narrows the definition of done. It appears in none of G&G's 16 specs and two suppliers independently concluded an asset can be complete without its formats.

## (b) The four projects

Each gets **`receiving-a-design-system.md`**, plus a per-project delta. **The headline for all four is the same and it reverses a standing instruction:**

> **Do not hand-unzip a drop, and do not `cdsync import` an as-is export.** `cdsync install` now exists. As-is export -> `install` (replaces). Converted drop -> `import` (merges). It refuses over uncommitted work, so commit first.

Per-project state, measured on disk 30 July rather than taken from the board:

| Project | `design/.gitignore` | Tracked under `design/system/` | Delta to send |
| ------- | ------------------- | ------------------------------ | ------------- |
| Lamplight | Tracked, `/system/_inbox/` | 708 | **Converted already, and its comment is better than ours.** Nothing to change. Outstanding: `wrighter-frontdesk/img/05-page.png` still needs a hand pass **inside CD's project** |
| Baize | **Absent** | 442 | **Its `_inbox/` guard is the export's own `design/system/.gitignore` and nothing else.** One export that drops that line makes 200MB archives committable and the remote unpushable. Add a repo-owned `design/.gitignore` holding `/system/_inbox/` |
| Gyre & Gymble | **Untracked**, `/system/` | **0** | Not converted. Full conversion needed |
| snorkeltoast | **Untracked**, `/system/` | **0** | Not converted. Full conversion needed. Its export also contains a **fake Cdsync protocol tree** at `design/system/cdsync/` -- `RETIRED.md`, `OUTBOX.md`, an `intent/whiteboard/` skeleton. Anything globbing for `intent/whiteboard` or reading `OUTBOX.md` must not reach it |

**The board was wrong about Lamplight** and this table corrects it: it said Lamplight, G&G and snorkeltoast all still carried the old exclusion. Lamplight was converted after hv passed it the note, and did a more thorough job -- its comment records the negation trap, that git cannot re-include a path whose parent directory is excluded, so `/system/` could never have grown a `!/system/addenda/` companion.

**Two of the four are the real work.** G&G and snorkeltoast track nothing at all, and their `design/.gitignore` is itself untracked -- so it does not travel to a clone, and `git clean -xfd` deletes the only file protecting the tree.

## What is not in either document

Three of the four open questions were ruled on 30 July and are folded into the material above:

- **`venture/` stays out of round one.** Converted, not stored -- the canon already settles that the whole deliverable is stored and tracked regardless. Both briefs now say RULED rather than "hv's call".
- **`print-collateral` is admitted**, as taxonomy **52** in Group 6. Out of numeric sequence deliberately: Group 6 ends at 41, and slotting it in would renumber ten published identifiers already cited in delivered drops.
- **`check` will not cross-reference `index.md`.** That redesigns asset detection rather than fixing a bug, and only one of the four drops has an `index.md`. The misleading report was fixed by wording instead: with no manifest present, a missing `spec.md` now says so rather than declaring the asset broken.

Still open, and deliberately absent rather than forgotten:

- **`cms-rollout-plan` and `go-to-market-plan`** -- the other two Decision 2 candidates. Neither is specified yet.
- **Finding 5** -- whether `formats_required` narrows the definition of done. Named as unruled inside the CD contract, so nobody assumes either way.
