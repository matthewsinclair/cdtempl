# cc -- 9 August 2026: the library closes at edition 4, and ST0003 with it

The same day's second half. The morning's fold had left one live edge, WP-03,
waiting on hv's word to move the library text. hv's word was "close this thing
out", so it moved.

## What WP-03 turned out to be

The work package described three text inconsistencies and a two-part dance. Three
of its four premises did not survive being checked.

**The stale text was in six shipped files, not three.** A `git grep` over every
tracked file found them. Naming files rather than counting them is the discipline
the 8 August correction had already been forced to learn twice, and it paid again.

**`cdsync new` does not scaffold `templprj`.** The WP asserted the two template
files were "scaffolded into every venture `cdsync new` creates", and a
`lib/specs.sh` comment repeated it. `new` renders `templates/venture/*.tmpl` and
nothing else; **no code path reads `templates/claude_design/` at all.** The claim
came from `templprj/README.md`, written in round one when that was the plan, and
survived the plan changing. **A premise restated often enough starts reading as
evidence** -- the second time this thread has been bitten by it, after WP-07.

**The `positioning`/`pricing` problem was two problems.** The dangling slugs were
the known half. The half nobody had recorded: `positioning-icp-personas` declares
`pricing-and-packaging` reciprocal and `pricing-and-packaging` does not declare it
back. `reciprocal` is symmetric by its name, nothing enforces it, and no check can
see it.

**`pattern-library` did not need writing.** The ratified model is that a spec is
written when an order needs one, and the wind-back means no order is coming. So the
two-part dance was not performed -- it was recorded for the day an order names the
slug. Writing it in bulk would have contradicted the model to satisfy a checklist.

## The decisions

1. **A library edition bump restamps nothing and invalidates nothing.** A drop
   keeps the edition it was ordered against; staleness is per asset, via
   `spec_version`, and only for specs whose text actually moved. If an edition
   bump restamped everything, one editorial fix would make the whole world stale
   at once and the signal would mean nothing -- the G&G two-counters lesson
   applied to the other number.
2. **The dangling references are repaired rather than preserved.** They had been
   left as delivered so they would arrive as findings in the next round. **The
   wind-back spent that reason**: no round remains for the finding to reach, and a
   reference that can never resolve, kept for a report nobody will write, is worse
   than a repair with the finding recorded.
3. **The asymmetry is flagged, not invented.** Writing the missing half would be
   this library inventing a dependency Claude Design never declared -- the
   drop-repair mistake one level up.
4. **`templprj` is a delivery record and stays as delivered**, including its
   "fifty-one" and its `spec_library_version: 2`. Editing it would falsify the
   delivery it records, which is decision 1 applied to the tool's own worked
   example. Its README was corrected on the one point that was about the *tool*
   rather than the delivery.

## What was built

Library edition 4. `specs/kit.md` -- inlined into every brief, so its wrong figure
went to the supplier every round for six weeks -- states no figure. `specs/library.md`
lost both its counts and gained three sections: the edition-bump rule, the
`formats_required` ruling, and the repaired-and-recorded dangling references.
`formats_required` is stated as advisory in the library, in `help/brief.md`, **and in
the brief itself**, which is the only one of the three a supplier ever reads.

Three new guards, and two of them are watch-outs being closed rather than new ideas:

- **every dependency the library names resolves in the taxonomy.** `check`'s rule 2
  catches a dangling `depends_on` in a *drop*; nothing had ever looked at the
  *library*, which is how three sat there from July.
- **the shipped library states no taxonomy-wide count.** The 8 August guard swept
  `bin/`, `lib/` and `help/`, and nothing asked what had chosen those three.
  `specs/` was never searched and was the copy that travelled. **A positive
  control validates the instrument, not the sampling frame** -- this is that
  sentence turned into a test.
- **the brief tells the supplier formats are advisory.** A ruling that never
  reaches the supplier changes nothing.

## Two tests that were green for the wrong reason

**One was pinning the defect.** "a bad dependency slug is declared as outside the
taxonomy" used `pitch-deck`'s real `positioning` as its fixture, so it could only
pass while the library stayed broken. Repairing the library turned it red -- the
test reporting the fixture it had been depending on rather than the behaviour it is
named for. It runs against a doctored library now, with an assertion that the
doctoring landed.

**And the mutation harness lied again, in a new shape.** `if diff a b; then echo
"did not land"` inverts the test, because `diff` exits non-zero *when files
differ* -- so it announced "MUTATION DID NOT LAND" while printing the landed diff
directly above the claim. Third harness failure here and the first of this shape.
The standing instruction to print proof is the only reason it took one read.

## End state

Suite 357 -> 360, green at every commit; shellcheck clean; three mutation cycles
with landing proof, each killing exactly its own test. **ST0003 closed 20/20** on a
bar of *every work package reached a terminal state on the record*, not *every one
was built* -- the wind-back dissolved three and hv parked a fourth, and demanding
they be built would have been the contract overruling the owner at a close.

**All four steel threads are Completed and nothing is open.** The remainder --
WP-02, `pattern-library`'s dance, the reciprocal asymmetry -- is carried forward in
`intent/restart.md`, each with the condition that would re-open it, written down so
it is not lost rather than so it is picked up.
