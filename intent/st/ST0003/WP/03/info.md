---
wp_id: WP-03
title: Grow the spec library, and repair its text
scope: L
status: Done
---

# WP-03: Grow the spec library, and repair its text

## Objective

**Most of the taxonomy has no spec** -- **`cdsync doctor` prints both figures, and this file states neither**, because a count copied into prose stops tracking the table it describes. That gap is not debt from ST0001: the ratified model is that the specs are a library and a brief is an order against it, so a spec gets written when an order needs one.

It also carried known inconsistencies in library *text*, left alone deliberately, because editing library text silently changes what its `spec_version` means -- so they had to move together behind one `spec_library_version` bump.

**Closed 9 Aug 2026 at library edition 4.**

## What the bump means -- the decision this WP existed to make

`spec_library_version` is the library's **edition**. A brief stamps it into every round, so a drop records which edition it was ordered against.

- **A bump restamps nothing and invalidates nothing.** A drop stamped against an earlier edition stays correctly stamped; raising the number afterwards would falsify the one fact the stamp records.
- **Staleness is per asset, and it is `spec_version`'s job.** A spec whose *text* moves raises its own `spec_version`; `check` then reports only the assets built from that spec.
- **If an edition bump restamped everything, one editorial fix would make the whole world stale at once and the signal would mean nothing** -- two counters that never disagree for a reason cannot measure a distance, which is the G&G lesson applied to the other number.

Edition 4 moved exactly three specs: `kit` 3->4, `pitch-deck` 1->2, `positioning-icp-personas` 2->3. **Verified rather than asserted**: `check` against `templprj` reports those three stale and nothing else.

The rule is now stated in `specs/library.md` ("What a library edition bump does, and does not do") and in `help/brief.md`. It is the library's, not this file's -- this is the record of the decision, not a second copy of it.

## The text repairs, behind the one bump

**The WP named three sites. A `git grep` over every tracked file found six**, and naming files rather than counting them is what the 8 August correction had already been forced to learn twice.

- `specs/kit.md` said "fifty-one artefacts" against a taxonomy of a different size. **The copy that mattered most**: the kit spec is inlined into every brief whether or not the kit was ordered, so this figure went to the supplier every round for six weeks *while the guard added on 8 August reported the number settled*. It now states no figure.
- `specs/library.md` said "32 of the 50", and separately opened its taxonomy section with a spelled-out total. Both gone; the table is the only record of its own size, and prose that wants the number says to run `cdsync doctor`.
- `lib/specs.sh` and `test/cdsync.bats` carried comments describing the unfixed state, including the stale figure itself. Corrected.

## Three dangling references, repaired rather than preserved

`pitch-deck` named `positioning` in `hard_assets` and `reciprocal`; `positioning-icp-personas` named `pricing` in `reciprocal`. No such slugs -- the assets are `positioning-icp-personas` and `pricing-and-packaging`.

The library had recorded them as known-and-deliberate, "left as delivered because they belong in the next round's findings". **The wind-back spent that reason**: there is no round left for the finding to reach. A reference that can never resolve, preserved for a report that will never be written, is worse than a repair with the finding kept -- so the library's own section now records what was found, when, and why it was finally fixed.

**A fourth thing surfaced and was flagged rather than invented.** `positioning-icp-personas` declares `pricing-and-packaging` reciprocal and `pricing-and-packaging` does not declare it back. `reciprocal` is symmetric by its name, nothing enforces that, and no check can see it. Writing the missing half would be this library inventing a dependency Claude Design never declared -- the drop-repair mistake one level up. Recorded, not resolved.

## `formats_required`, ruled advisory by hv on 9 Aug

Written into `specs/library.md` and `help/brief.md`, **and into the brief itself**, which is the only one of the three the supplier ever reads. Two suppliers independently held finished assets back for a rendering nobody was blocking on; that is the document-as-instrument failure for the fourth time in this project, and the misreading is expensive in one direction only.

## What was deliberately NOT done, and why

- **`pattern-library` was not written.** The ratified model is that a spec is written when an order needs one, and the wind-back means no order is coming. Writing it in bulk would contradict the model, and it would have forced the two-part exemplar dance for no gain. It stays the live exemplar of a slug that is real, in the taxonomy, and unwritten -- true today, and the test that pins it stays green as-is. **If an order ever names it, the dance is still required**: write the spec and re-point the exemplar and its test in the same change.
- **`templates/claude_design/templprj/` was left as delivered**, including its "fifty-one" and its `spec_library_version: 2`. It is a worked example of a delivered drop, and a drop keeps the edition it was ordered against. Editing it would falsify the delivery it records, and would be the same error as restamping a venture's tree. Its README now says so.
- **No new specs were written.** No order needs one.

## Two premises that were false, both inherited

**`cdsync new` does not scaffold `templprj`.** This WP asserted the two template files were "scaffolded into every venture `cdsync new` creates", and a `lib/specs.sh` comment repeated it. The as-built renders `templates/venture/*.tmpl` and nothing else; **no code path reads `templates/claude_design/` at all.** The claim came from `templprj/README.md`, written in round one when that *was* the plan, and it survived the plan changing. Checked against `cmd_new.sh`, not against the sentence. **A premise restated often enough starts reading as evidence** -- the second time this thread has been bitten by exactly that, after WP-07.

**A test was pinning the defect.** "a bad dependency slug is declared as outside the taxonomy" used `pitch-deck`'s real `positioning` as its fixture, so it could only pass while the library stayed broken. Repairing the library turned it red -- the test reporting the fixture it had been depending on rather than the behaviour it is named for. It runs against a doctored library now, with a guard that the doctoring landed.

## Evidence

Suite 357 -> 360, green; shellcheck clean. Three new guards, each mutation-proven with landing proof by diff and each killing exactly its own test:

- **every dependency the library names resolves in the taxonomy** -- the guard that did not exist. `check`'s rule 2 catches a dangling `depends_on` in a *drop*; nothing looked at the *library*, which is how three sat there from July. Mutant: reintroduce `positioning`.
- **the shipped library states no taxonomy-wide count** -- **the 8 August guard's sampling frame widened.** That sweep searched `bin/`, `lib/` and `help/`, and nothing asked what had chosen those three; `specs/` was never searched and was the copy that travelled. Narrower pattern than the help-file guard on purpose, because `library.md` carries two legitimate *subset* counts the broad pattern matches. `templates/claude_design/` is out of scope by the ruling above. Mutant: restore "fifty-one artefacts".
- **the brief tells the supplier formats are advisory** -- a ruling that never reaches the supplier changes nothing. Mutant: truncate the sentence.

**The verification probe modified the thing it was verifying.** `cdsync check` is not read-only -- it recomputes `blanks` and `blanks_unique` and writes them back into every `spec.md` in the drop it walks. Running it against `templprj` to confirm AC-03.5 silently changed eight tracked files, **in the same breath as this WP ruling that directory a delivery record not to be edited.** Caught by `git status` at commit time and nothing in the run; reverted, and causation established by reverting and re-running rather than assumed. On the board now: **a probe with a side effect is still a side effect.** Worth hv's attention as a possible `--no-write` or a rename, which is not a call to make at a close.

**The mutation harness lied once, in a new way.** `if diff a b; then echo "did not land"` inverts the test -- `diff` exits non-zero *when files differ* -- so it reported "MUTATION DID NOT LAND" while printing the landed diff directly above the claim. Third harness failure in this project and the first of this shape; the standing instruction to print proof is what made it obvious in one read.

## Notes

`cdsync doctor` prints spec, taxonomy and bundle counts. **Read the counts from it rather than from any document**, including this one.

## Acceptance

Acceptance Criteria for this work package are RENDERED into `ST0003/acceptance.md`, under the `WP-03` heading. THAT FILE IS A GENERATED VIEW -- a row authored there is discarded by the next sync. The contract is canon in the thread's model: change a state with the `intent ac` / `intent at` verbs, and mint or reword a row in `.canon/st/ST0003.json`, then `intent sync --to-store`. This cover never restates them.

---

_Generated by Intent v3.0.0 from `the thread canon`. Do not edit this file -- it is rendered from the model, and `intent doctor` reports any hand-edit as skew._
