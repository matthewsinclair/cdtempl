# 8 August -- WP-07's premise, WP-08's drift, and a count that was wrong three times

Day record. The live board carries only the standing lists and current state; this is the narrative it does not need to hold.

## What happened, in order

1. **WP-07 finished for every project it could reach.** Baize and snorkeltoast were checked and both were **already integrated**, exactly as Gyre & Gymble had been. Three of three. Only Lamplight is left and it holds on WP-06.
2. **WP-08 was re-measured before being worked from**, and three of its six items had drifted. One had been silently done, one had undone its own fix, one had gone further than intended.
3. **hv ruled on the Downloads escalation** the same morning it was raised: all five directories cleared deliberately. The item closed and the standing "it stays" instruction was withdrawn rather than softened.
4. **The taxonomy count was computed rather than remembered**, after `brief`'s refusal was found telling users the wrong number.
5. **`brief` gained `round_job`**, so a repackaging round can be expressed at all.
6. **WP-08's remaining gap turned out to be blocked on WP-05**, which the WP had recorded as depending on nothing.
7. **Globalfold across every project doc.**

## WP-07: the premise was false three times out of three

The work package opened on "none has been built against". It was wrong for Gyre & Gymble on 6 August, and on 8 August it was wrong for both remaining projects too.

- **snorkeltoast** -- 41 of 41 hex literals from `design/system/brand/tokens/colors.css` are in `theme/theme.css`, which states its own provenance at line 9; `theme/layout.liquid:94` loads the build.
- **Baize** -- 45 of 46 `oklch()` values from `design/system/handoff/app.css.theme-blocks.css` are in `apps/rack/assets/css/app.css`, both theme blocks named at `:438` and `:489`, and the non-colour claims land too.

**The 46th value is a deliberate divergence, not drift.** The handoff specifies `oklch(96% 0.006 150)` for the gaffer theme's `--color-base-200` and `--color-secondary-content`; the app carries 95% for both, moved consistently. The app refined the specification. **That single divergence is also the proof the comparison could detect one** -- 46 of 46 would have been the suspicious answer.

**Why the premise was wrong, structurally:** it was written from the drop's side of a boundary a drop cannot see across. "Nothing downstream" was a statement about what the evidence could reach, read as a statement about the world.

**Three projects, three idioms, and none predicted the next.** G&G hex with no handoff directory; snorkeltoast hex with a handoff naming its provenance in the file; Baize `oklch()` exclusively with a handoff written as a drop-in for a file the app owns.

## The instrument failures, which were the day's real yield

**One probe per project.** The hex probe that confirmed snorkeltoast returns a confident `0/0` on Baize, which holds **zero hex literals**. Same question, same family of artefact, an instrument that answers one and is silent on the other without ever erroring.

**A path constructed rather than found.** Baize's app CSS is at `apps/rack/assets/`, so a root-level `find assets -name '*.css'` returns nothing at all. Its handoff document named the real path.

**A test that asks the code under test for its own expected value cannot fail.** Three new tests took the taxonomy count from `taxonomy_count()` and asserted the message matched it. Replacing that function's body with `echo 99` left all three green. They were pinning consistency, which was never in doubt. Rewritten to derive the count from `specs/library.md` by a different probe, they fail against the mutant and pass clean.

**A generalisation caught in a draft before it landed.** "All three integrated projects carry a `handoff/`" was written from the two that had been looked at. Gyre & Gymble has none and is integrated anyway.

**A sweep over a directory list nobody chose.** The hunt for hand-written taxonomy counts searched `bin/`, `lib/` and `help/`, found four, and reported no figure left in shipped text. The correction then said "a fifth copy survives" -- **also wrong**. A `git grep` over every tracked file found three files, and they are the ones that travel: `specs/kit.md`, inlined into every brief, and two under `templates/claude_design/templprj/`, scaffolded into every venture `cdsync new` creates. **The count of wrong counts was itself wrong, twice, before anyone swept properly.**

**The local shell is not the CI shell.** The hygiene job's own `check()` helper dies immediately under this machine's zsh -- `status` is read-only there -- so rehearsing it locally proved nothing until it was run under `bash` explicitly.

## WP-08: what a housekeeping list does when nobody reads it against the world

**Baize's `BOOTSTRAP-CD.md` was not left uncommitted** as recorded. It is in `4960f27`, titled *"docs: the design-system tool is now called Cdsync"* -- the rename swept it up, which is the *explicit file list is not an explicit pathspec* failure already on the board, recurring in another repository where no occurrence count existed to catch it.

**And it went stale again inside a day.** High-water `0024` against a tree now holding ST0025. **That killed the standing objection to the advisory staleness rule:** a hand-regeneration fixes the problem once, and the tree keeps moving.

**The rule's reach was settled by testing the proposal against the case.** Baize's `BOOTSTRAP-CD.md` *is* the newest file in `design/system/`, so a rule scoped to the design tree reports clean on a provably stale document. What staled it lives in `intent/st/`. The check's reach has to match the generator's, which roots on the repository.

## The globalfold

**`intent/llm/ARCHITECTURE.md` carried a dated Decision Log that was not a duplicate of the board so much as a fork of it.** Twelve of thirteen rows restated a board ruling; the thirteenth existed only there. Four had drifted into carrying *different* reasoning from the board's version of the same decision, each side holding something the other had lost -- and the table's last entry was 31 July while the board had gone on ruling for another week.

**That is the predicted failure arriving exactly as predicted:** two descriptions of one thing disagree, and the terse one survives. Everything unique was merged onto the board first; only then was the table replaced with a pointer.

**Counts came out rather than being corrected**, everywhere they appeared: the board's own "2 of 8", `.claude/restart.md`'s test count and its "four misses" (which the board's heading called "both"), `tasks.md`'s and WP-03's "25 of 52", restart.md's "four copies stale".

**`design.md` and `impl.md` were unfilled template boilerplate** in a public repository -- documents that look like a home for information and hold none. Both now say where their content actually lives.

**`tasks.md`'s dependency graph said `WP-01, WP-08 -> independent`.** WP-08 was not, and had not been for six days. **A dependency nobody has followed is not an absent dependency**, and that graph was the place that was supposed to know.

## Where it ended

**342 tests, 0 failures. CI success on hygiene, ubuntu-latest and macos-latest, read per job.** Every push green.

**Nothing in ST0003 is unblocked any more.** That is new as of today, and it is the single most useful thing for the next session to know.
