---
verblock: "08 Aug 2026:v0.3: matts - Re-measured against the world: three items had drifted, one is an escalation"
wp_id: WP-08
title: "Housekeeping and small gaps"
scope: Small
status: WIP
---

# WP-08: Housekeeping and small gaps

## Objective

The small things that are individually not worth a work package and collectively worth one. Each is independent; none blocks anything.

**8 August: the list was re-measured against the world before anything was actioned, and three of its six items had drifted** -- one had been silently done, one had been done and undone itself, and one had quietly gone further than anyone intended. **A housekeeping list is exactly the kind of document that rots**, because nothing depends on it and so nothing catches it. **Measure this list before working from it, every time.**

## The list

### Baize's `BOOTSTRAP-CD.md` is genuinely stale

Steel-thread high-water 23 against a tree at 24. **Not noise** -- the other projects regenerate byte-identical, so this one is a real difference. It was regenerated and deliberately left uncommitted, because that repository carries hv's own uncommitted work and committing over it was not mine to do.

**8 August, and both halves of that sentence have stopped being true.**

**It was committed, and not deliberately.** It is in `4960f27` (6 Aug), a commit titled *"docs: the design-system tool is now called Cdsync"*. **The rename swept it up.** That is the *explicit file list is not an explicit pathspec* failure the board already records against this repository, happening a second time in another one -- and this time nothing caught it, because there was no occurrence count to reconcile against.

**And it is stale again already.** It states steel-thread high-water `0024`, next free `0025`; Baize's tree now holds **ST0025**, so the next free is `0026`. The regeneration fixed 23 against 24 and the tree walked past it.

**That is the whole argument for the item below**, and it is now a stronger one than when it was written: the objection to an advisory staleness rule was that a hand-regeneration fixes the problem. **It does not. It fixes the problem once, and the tree keeps moving.**

### Two gaps in `cdsync brief`

Both recorded against `brief` and neither addressed:

- **It cannot express a repackaging round** -- a round whose job is to reshape what already exists rather than build something new.
- **It cannot order a slug the library does not hold.** Correct as a refusal, but it means a genuinely new asset type cannot be ordered at all until WP-03 writes its spec, which is a chicken-and-egg for anything novel.

### Should a stale generated document be detectable?

An advisory rule comparing `BOOTSTRAP-CD.md`'s mtime against the newest file in the tree.

**Every instance, with its detail -- this is the only place that now carries it**, because the board was holding a hand-maintained count of exactly the kind it warns against, and that count was the thing drifting:

| When | Copy | What was stale | Now |
| ---- | ---- | -------------- | --- |
| -- | Baize | Steel-thread high-water 23 against a tree at 24 | **Regenerated, then stale again at `0024` against ST0025** |
| -- | All four at once | A generator change staled every copy **with no local symptom at all** -- they were regenerated only because the board said to | Regenerated |
| 6 Aug | Gyre & Gymble | Inventory missing `business/`, and it embedded a **superseded revision of its own addendum** | Fixed 6 Aug |
| 6 Aug | snorkeltoast | `docs/` 92 against 93, `email/` 3 against 7, **one whole section absent** | **Not fixed** -- a live session was in that tree |
| 8 Aug | Baize | High-water `0024`, tree at ST0025 | **Open** |

**Two copies are stale right now: snorkeltoast's and Baize's.** The first was left because another session held the tree; the second because a hand-fix does not survive the tree moving.

Cheap to build. **Still not built, because it is unasked scope**, and this project has a standing preference for not inventing rules nobody ordered. **It should be ordered or declined rather than carried a sixth time.**

**One design constraint, found by testing the proposal against the case above rather than assuming it.** *"The newest file in the tree"* is the wrong reach, and it fails in the dangerous direction:

- Baize's `BOOTSTRAP-CD.md` is 6 Aug 09:46. **It is the newest file in `design/system/`** -- tied with `index.md` and `RETURN.md`, which the same sync wrote.
- What staled it is `intent/st/ST0025`, 7 Aug 17:38, **outside that tree entirely.**
- **So a rule scoped to the design tree reports CLEAN on a document that is provably stale.** Scoped to the repository, it flags it by 1.3 days.

The generator already reads outside the design tree -- the numbering scan roots on the target's *repository*, pinned by a test (`test/cdsync.bats:3983`). **The check's reach has to match the generator's reach**, or it is another instrument that cannot see the thing it is looking for. **A rule's published reach is part of the rule**, and this one has two candidate reaches that disagree on the only case anyone has tested.

### Intent's template bakes an absolute path

`[[INTENT_HOME]]` is substituted into `.claude/settings.json` at install time, so every project built from the template carries an absolute path to one machine. **Cdsync's is fixed** and a test guards it. **Baize's and Lamplight's still carry theirs.** Upstream issue, worth reporting to Intent rather than patching per project forever.

**Re-measured 8 August and unchanged:** Cdsync 0, Baize 2, Lamplight 2. **This item stands exactly as written**, which is worth saying out loud on a list where three neighbours had drifted.

### Downloads housekeeping

All optional and **none of it vestigial** -- this is the 31 July consolidation, not junk. **8 August: every one of these is now absent from `~/Downloads`, including the one that was to stay.**

| Directory | Size | 8 Aug |
| --------- | ---- | ----- |
| `claude-design-superseded-rounds-202607/` | 1.3G | Gone |
| `lamplight-design-drops/` | 1.1G | Gone |
| `Lamplight Design System/` | 281M | Gone |
| `baize-repo-snapshots-202606-202607/` | 233M | Gone |
| **`baize-design-drops/`** | **441M** | **Gone, and it was to STAY** |

**The four superseded ones going is the item being done**, whoever did it. `baize-design-drops/` is the one that matters.

**It held a generation of a drop that exists nowhere else.** Baize's own whiteboard history (`intent/whiteboard/vc/.history/20260730/wip.md:30`) records that the two delivery zips moved there at 219MB + 222MB when `design/.gitignore` was deleted, and that the superseded 09:49 zip was **archived rather than discarded specifically because git never held that generation.** The current one was proved redundant first -- all 437 files were already tracked -- so **only the superseded generation was unique, and only it is unrecoverable.**

**This is hv's to answer and has been escalated:** cleared deliberately, moved elsewhere, or lost. **Nothing here should act on it either way.**

Correction while here: the board called that directory *"the off-repo home named in Baize's own root `.gitignore`"*. The `.gitignore` carries the residual-risk narrative; **the path itself is named only in that whiteboard history.** Two documents, one slightly wrong, exactly as the standing watch-out predicts.

**Six spent `_inbox/` directories, and the count reconciles exactly** -- Baize, Lamplight, gyreandgymble, geodica, snorkeltoast, matthewsinclair, one apiece under `design/system/`. All gitignored and local-only, and the two newest hold the Laksa theme packs, **which exist nowhere else** -- do not clear those two until Laksa has taken them.

### The whiteboard roster

`intent/whiteboard/README.md` is still deferred. **No `hv` node here, by hv's ruling -- `cc` is the whole roster in Cdsync for now**, so the roster document has had nothing to say.

## Deliverables

Each item either done, or explicitly declined with a reason. **An item declined on the record is finished; an item that quietly stays on a list forever is not.**

Where the six stand after the 8 August re-measurement:

| Item | State |
| ---- | ----- |
| Baize's `BOOTSTRAP-CD.md` | **Needs a decision, not a regeneration.** Regenerating it by hand is what did not hold |
| Two gaps in `cdsync brief` | **The only real tool work left here.** Untouched, unblocked, not started |
| Stale-document rule | **Ordered or declined by hv.** Its reach is now a settled question either way |
| Intent's absolute path | Stands as written. Upstream report, not a per-project patch |
| Downloads | Four done. **The fifth is escalated to hv and nothing acts on it** |
| Whiteboard roster | Deliberately deferred, and still correctly so |

## Dependencies

None -- **but three of the six now need an hv ruling rather than effort**, which was not true when this WP was written.
