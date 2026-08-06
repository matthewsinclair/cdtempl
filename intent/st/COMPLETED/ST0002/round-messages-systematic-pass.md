---
verblock: "31 Jul 2026:v0.1: cc - Covering notes for the four-way systematic pass"
status: Draft
---

# Covering notes — the systematic pass

Four messages for hv to send. **Each one accompanies that project's own `design/system/BOOTSTRAP-CD.md`, uploaded as a file.** The document carries the substance; these are covering notes and are deliberately short.

**Send order: Lamplight, then the other three in any order.** Lamplight has never run under this protocol, so it is the only cold read available and the only one whose result says anything about a reader coming to the document fresh. The other three have already been shaped by it.

## What these notes deliberately do not say

**No note names a known finding.** Gyre & Gymble carries 15 rule-2 and 11 rule-6 findings right now, and every one of them should be cleared by a reader who takes the document seriously and applies it to everything. **Naming them would clear the findings and prove nothing** — the question this round asks is whether the generated document works on material nobody pointed at, and a hint is the one thing that cannot be un-given.

So the expected result is **1 and 0** — the surviving 1 being `kit`, which has no library entry to copy a stamp from. If it comes back at 15, the document was not read or was not believed, and that is a more useful answer than a clean run.

Same discipline as the two library inconsistencies held back for the next round's findings: a quiet correction destroys the finding.

## What every note carries

Four things, and the notes differ only in what surrounds them.

Checked against the trees before sending: **Lamplight has neither `index.md` nor `RETURN.md`, snorkeltoast has `RETURN.md` but no `index.md`**, and Baize and G&G have both. So only Baize and G&G are asked to *keep* a manifest.

**No note asks the other two to build one, because their document already does** — the inventory reports the absence and says "Producing one is part of the next round", which is in Lamplight's and snorkeltoast's copies today. Repeating it here would be a second instruction that can drift from the first. The pass produces both manifests without any note mentioning them.

1. The attached document supersedes the one they hold, and **has gained sections** — read in full, not against memory.
2. **The job is a systematic pass**: every rule against every asset, not the ones that happen to come up.
3. **Systematic means coverage, not reorganisation** — a guard against this note's own wording, since "apply systematically" could be read as "systematise the tree". The shapes are right as they are.
4. Export the whole tree as one archive, with a `RETURN.md` naming what changed file by file.

---

## 1. Lamplight — first, and the only cold read

> **A change in how this design system is exchanged, and then a round of work.**
>
> The attached `BOOTSTRAP-CD.md` will be new to you. It is generated from the tree as it actually stands in Lamplight's repository rather than written by hand, so it describes what is there instead of what anyone remembers being there. **Please read it in full before anything else** — this is the first round this project has run under it.
>
> The one thing it changes, from which the rest follows: **the tree is the single source of truth for the design system, and Claude Design is a tool that works on it.** That includes a list of things which arrive in your tree and are not yours to send back.
>
> **This round's job is a systematic pass.** Take every rule in that document and apply it to **every asset you hold** — all of them, not the ones that happen to come up. Most of those rules have never met most of your material, and that is exactly the point of the exercise.
>
> **Systematic means coverage, not reorganisation.** The shape of your tree is right as it is; the document describes what a drop is, not a layout to convert to.
>
> **Nine steel threads you authored have been taken into the project.** ST0334 to ST0342, 58 files, formerly at `handoff/intent/`. They are now in Lamplight's own `intent/st/_inbox/` awaiting triage. **Please delete `handoff/intent/` from your tree and do not export it.** Until today those nine existed in exactly one place, and that place was a directory every export overwrites — nothing was lost, but that was luck. The attached document explains the standing rule. **The rest of `handoff/` is design material and stays.**
>
> Then **export the whole tree as one archive** — everything, including what you did not touch this round. Not a delta. The receiving side replaces what it holds with what you send, so anything left out reads as a deletion of it.
>
> **Please include a `RETURN.md` naming what changed, file by file.** Installing the drop updates your side and never the project's, so a change you do not name is one nobody on this side can see.

---

## 2. Baize

> **A systematic pass, please.**
>
> The attached `BOOTSTRAP-CD.md` supersedes the one you read this morning. It is regenerated from the tree on every sync and **has gained sections since**, so please read it in full rather than against your memory of the last one.
>
> **Both addenda are retired.** Your round absorbed them, and it was verified by reading the content rather than by taking the receipt — `player-typed-states.md` into §07, and `st0018-divergences` by dissolving, since the copy of ST0018 it existed to reconcile is one you no longer hold. The document's addenda section now correctly says none are waiting.
>
> **This round's job is a systematic pass.** Take every rule in that document and apply it to **every asset you hold** — all of them, not the ones that happen to come up. Several of those rules have only ever been applied to the one asset that surfaced them.
>
> **Systematic means coverage, not reorganisation.** The shape of your tree is right as it is.
>
> Then **export the whole tree as one archive** — everything, including what you did not touch. Please keep `index.md` and `RETURN.md` in it.
>
> **Have `RETURN.md` name what changed, file by file.** Installing replaces what the project holds, so a change you do not name is one nobody on this side can see.

---

## 3. snorkeltoast

> **A systematic pass, please.**
>
> The attached `BOOTSTRAP-CD.md` supersedes the one you read this morning. It is regenerated from the tree on every sync and **has gained sections since**, so please read it in full rather than against your memory of the last one.
>
> **This round's job is a systematic pass.** Take every rule in that document and apply it to **every asset you hold** — all of them, not the ones that happen to come up. Most of those rules have never met most of your material.
>
> **Systematic means coverage, not reorganisation.** Your tree is organised by medium and that shape is right as it is; the document describes what a drop is, not a layout to convert to.
>
> Then **export the whole tree as one archive** — everything, including what you did not touch — with a `RETURN.md` naming what changed, file by file. Installing replaces what the project holds, so a change you do not name is one nobody on this side can see.

---

## 4. Gyre & Gymble

> **A systematic pass, please.**
>
> The attached `BOOTSTRAP-CD.md` supersedes the one you read this morning. It is regenerated from the tree on every sync and **has gained sections since**, so please read it in full rather than against your memory of the last one.
>
> **This round's job is a systematic pass.** Take every rule in that document and apply it to **all sixteen assets** — every one, not the ones that happen to come up. Every rule so far has been applied to the asset that surfaced it, and this is the first time they meet the other fifteen.
>
> **Systematic means coverage, not reorganisation.** The shape of your tree is right as it is.
>
> Then **export the whole tree as one archive** — everything, including what you did not touch — keeping `index.md` and `RETURN.md` in it.
>
> **Have `RETURN.md` name what changed, file by file.** Installing replaces what the project holds, so a change you do not name is one nobody on this side can see.

---

## The return leg

Per project, once the archive is downloaded:

1. Drop it in `<project>/design/system/_inbox/`. All four inboxes exist and all four are empty, so there is nothing for the newest-by-mtime selection to disambiguate.
2. `cdsync install --target <project>/design/system` — with no archive named it takes the newest in `_inbox/`. **`install` for all four, and the reason is canon's, not a judgement per project**: a Claude Design project synced from `design/system/` holds the whole tree, so it exports the whole tree, so `install` is always correct. Being Cdsync-shaped does not make G&G the `import` case; a *subset* would, and none of these are.
3. Read the removals it prints. A tracked path disappearing is the export having left something out.
4. Commit, then `cdsync check` on Gyre & Gymble for the two numbers.

The install refuses over uncommitted or untracked content **under the target path only**, so work in flight elsewhere in those repositories does not block it. All four were clean as of 14:30 on 31 July.
