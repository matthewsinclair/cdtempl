# cc -- 2 August 2026, archived

The first real round for matthewsinclair and geodica, and the first exercise of the cold-start document. Archived verbatim at the 2 August globalfold. Live state moved to `intent/whiteboard/cc/wip.md`.

## The falsifiable question got a yes

**Both trees came back Cdsync-shaped.** Both archives held an identical drop root -- `assets brief.md index.md kit notes RETURN.md` -- so the cold-start document worked. The two bugs fixed in it on 1 August, never before tested against a real return, held: neither tree was told it was a resume, and both adopted the `assets/<slug>/` shape `check` requires.

The round-trip closed too. `BOOTSTRAP-CD.md` regenerated from *"The tree is empty. This is a cold start"* to *"The tree is populated. This is a resume -- do not start it again"*, now enumerating all 13 assets.

## Three bugs, none of them visible by reading

Every one was found by running the tool at a real drop for a real purpose. The through-line from 1 August held for a second day.

### The dry run earned its keep on the first command

The two archives held the same drop root and **disagreed about how deeply to wrap it**: geodica arrived as `design-system/`, matthewsinclair as `design/system/` -- that exporter having preserved the path the tree sits at in the receiving repository.

`stage_drop` descended exactly one wrapper, an `if` rather than a loop, so matthewsinclair resolved to `design/`. The plan said `add system` and `remove assets / kit / notes`. Installing it would have deleted the three real directories and written `design/system/system/`, and `check` would then have reported an empty tree -- **a wrong answer that reads as a supplier problem and is not one.**

The descent now runs WHILE the directory is a wrapper and stops the moment it holds drop content. Both conditions are needed: depth alone cannot terminate safely, and content alone would not move off an empty wrapper. The floor is `drop_root_is_shaped`, which asks the owned lists rather than carrying a second idea of the shape.

`stage_cleanup` was stranding wrappers -- it removed only what `stage_drop` returned, which is the DROP root -- so it now climbs back to the staging root, bounded by a named prefix rather than a count. The deeper descent had made a pre-existing leak worse.

### `check` failed silently, printing a header and nothing else

matthewsinclair's kit is defined entirely in `oklch()`. The scanner read `#hex`, `rgb()` and `hsl()`, so `grep` matched nothing and exited 1, `pipefail` propagated it to a bare command-substitution assignment, and `set -e` aborted the command. **No rules, no rows, no verdict, no error, exit 1.** The `bash -e` class again, this time inside the tool rather than in CI.

Surviving that was not enough on its own: an empty kit **silently skips rule 4** further down, both call sites guarding on `-n`, so the run would have come back clean having never looked.

### Rule 4 was blind to the colour space its kit was written in

`oklch()`, `oklab()`, `lch()`, `lab()` and `color()` are now read, compared as normalised TEXT rather than converted to hex. Converting properly needs a colour-space transform, and converting approximately is worse than not converting at all -- two distinct kit colours rounding to one hex value would report a leak that is not there.

**The pattern was written out twice, once per scanner, identical by hand rather than by construction.** That is how the gap came to exist on both sides, and a one-sided fix would have been *worse than none*: every kit colour unknown makes every artefact colour a leak, reported with confidence.

## The mutation test caught my own bad test, and this is the lesson worth keeping

**Three of the six new colour tests stayed GREEN against pre-fix code.** They piped straight into `normalise_colours`, whose fall-through `print value` passes an unrecognised string along unchanged -- so they produced exactly the right answer with the bug still in place.

The gap was one layer up, in the grep, and the tests never touched it. Retargeted through `each_colour_in_file` and `each_kit_colour`; all seven then went red on pre-fix code, with `scan.sh` proven byte-identical to `HEAD` first.

**New shape, and it is not the same as the four failures on 1 August.** Those were mutations that did not apply. This one applied perfectly -- the test simply asserted at a layer the bug could not reach. **A test can be green against broken code because it is testing the wrong thing, not because the mutation failed.** Print proof the mutation landed AND check the test actually exercises the changed code path.

## What rule 4 found once it could see

matthewsinclair went from a silently-skipped rule to **15 blocking**, all against `kit/` itself and none against a page or component. Classified individually rather than eyeballed:

| Count | What | Verdict |
| ----- | ---- | ------- |
| 6 | `oklch()` values in `accessibility.md`, `colour.md`, `components.md` absent from `tokens.json` | **Real.** No token to implement them from |
| 14 | The *Approx hex* column in `colour.md` -- `\| --bone \| oklch(96% 0.014 92) \| #F5F0E4 \|` | Not leaks. One colour, two spellings |
| 1 | `colour.md:31` -- *"Blue-shifted near-black, never `#000`"* | The kit names it **to forbid it** |

**Rule 4 was not changed again to suppress the last two.** The hex column is a question for the drop -- either `tokens.json` publishes the approximations or the column goes -- and canon says Cdsync never repairs a drop. The `#000` case is subtler than it looks: `scan.sh` already excludes code spans for *blanks*, but a colour inside a fenced block is a **declaration**, not documentation, so the analogy does not transfer. Both want a ruling; neither was mine to make unilaterally.

## Blast radius, measured rather than assumed

| Project | `cdsync check` | Affected |
| ------- | ------------- | -------- |
| matthewsinclair | 14 checked, **15 blocking**, 13 advisory | **Yes** -- the only oklch kit |
| geodica | 7 checked, clean, 6 advisory | No -- no `tokens.json` |
| gyreandgymble | 17 checked, clean, 20 advisory | No -- zero modern literals |
| Lamplight | 4 checked, clean, 5 advisory | No -- no `tokens.json` |
| Baize, snorkeltoast | refuse, 0 assets | Pre-existing; not Cdsync-shaped |

Only the project with an `oklch` kit moved. **Nothing that was clean became dirty.**

## Committed

| Repo | Commit | |
| ---- | ------ | --- |
| Cdsync | `9af7c13` | the three bugs |
| Cdsync | `a037009` | document which colour forms rule 4 reads |
| matthewsinclair | `7110576` | round one, installed |
| geodica | `cd4d4e2` | round one, installed |
| Laksa | `6c8c7297` | the handoff note |

**matthewsinclair was committed blocking, deliberately.** The findings are about the drop and belong with it in history; holding the tree back until they are resolved would lose the record of what arrived.

**Laksa was committed path-scoped to one file.** Eight other changes sit in that working tree, two of which appeared *while this session was working*. None were touched.

## The handoff note vanished once

It was written to `../Laksa/` and was **gone** when the time came to update it -- `intent/st/ST0084/` and a modified `steel_threads.md` had appeared in the interim. Rewritten and committed, so it now survives whatever removed it. **A file written into a repository another session is working in is not safe until it is committed.**

## Removal audit

Both site repos, identical in shape: 3 deletions, all `.gitkeep` placeholders from the cold init; `BOOTSTRAP-CD.md` modified; everything else new. **Nothing was lost.** `git status` was the audit, not the install plan.

## Numbers at the globalfold, midday

**325 tests** (from 314), 0 failures. Shellcheck silent at default severity. 9 new tests: 2 on the descent, 1 on the staging leak, 5 on the colour scanner, 1 tying `help/check.md` to `CDSYNC_COLOUR_RE`.

The afternoon below took it to 328.

---

## Afternoon: both threads closed, and a third created to hold what they carried

### The gate was doing its job, and neither thread could close

ST0001 and ST0002 both carried the **untouched acceptance template** -- no criteria, no tests, `intent ac status` reporting **0/0 BLOCKED** on each. The close-gate is fail-by-default, so `intent st done` refused both. Correct: a thread with no ratified boundary cannot be said to have reached one.

So the contracts were written from the as-built, each stating its **boundary before its criteria**, because in both cases the boundary was the whole question.

- **ST0001 closed 16/16.** Its bar was never "all 52 slugs specified" -- `design.md` ratifies the specs as a library and the brief as an order against it, so a spec is written when an order needs one. 27 written; `pattern-library` deliberately blocked.
- **ST0002 closed 12/12.** Its bar was never "all four pass `check`" -- three carry a pre-Cdsync convention the checker cannot read, so it refuses with `0 assets checked`. **That is the tool being honest about a tree it cannot read, not the port having failed.** Converting them is its own round by ruling; the briefs are written and transport is hv's.

Both contracts list what falls **outside** the boundary, so closing dropped nothing.

### I made the exact mistake the contract exists to prevent

The first draft of ST0001's contract cited **eleven acceptance tests and eight did not exist** -- plausible names for tests nobody had written. Caught by grepping the suite for each before committing.

**That is worse than an empty contract.** The gate counts AC-to-AT coverage and has no way to know whether the AT is real, so the thread would have closed on evidence that was never there. That half is now a test.

**And the guard itself went blind twice in one afternoon**, both times because `intent st` MOVES a thread's directory as its status changes. First it globbed only the live location and went empty the moment the two threads moved to `COMPLETED/` -- caught solely by its own total-is-nonzero assertion. Then ST0003 was created into `NOT-STARTED/`, a third location it still could not see. **A probe whose reach is narrower than the thing it searches for, twice, in the test written to stop exactly that.**

### Docs reconciled to as-built

- ST0001 said **"the five check rules"** against six implemented, and had **no Done entry for rule 6 at all**.
- Its status heading said *1 August* while carrying 2 August's numbers.
- **`round-5-answer.md` -- assembled and UNSENT -- would have gone to a supplier stating the wrong rule count.**
- The rule-4 cannot-run warning added that morning had **no test**. Now two, mutation-proven against `2671cf1`: the pre-fix assignment reproduces the original symptom exactly.

**Round-3 and round-4 answers say "five" too and were LEFT ALONE.** They are records of correspondence that was accurate when sent, and rewriting them would falsify the history rather than correct it. **Distinguish a historical record from a current-state claim before correcting either.**

### The stale-count sweep lied first time

The first sweep used `--include=*.md` unquoted. **zsh ate it as a glob, grep never ran, and the probe reported "none"** -- this board's own watch-out firing during the writing of the fold that records it. Quoted, given a positive control, and re-run, it found three real stale claims including the unsent one.

### ST0003 created to hold the carry-forward

**Eight work packages**, each with its own `info.md` rather than a line on a list, because several look smaller than they are. Three unblocked today -- WP-01 cut the release, WP-07 integrate the original four, WP-08 housekeeping. The rest wait on a ruling or on transport, and the thread says plainly not to start those by guessing.

**Its acceptance contract is deliberately left empty**, which reads as BLOCKED -- the gate working, and exactly what forced the other two to earn their closes.

The board's TODO list was **replaced by a pointer rather than duplicated**: when a file carries two lists of the same kind of thing, that is the bug, not the style.

### Noted, not worked around

**`intent st sync --write` forwards only `--width` to `list`**, so the generated index can only ever show WIP threads. With everything now Completed or Not Started, `steel_threads.md` renders empty. Upstream behaviour, and the file is generated, so it was left alone.

### Numbers at the close of the day

**328 tests** (from 314 at the start of the day), 0 failures. Shellcheck silent at default severity. **CI green at `30742404499`** on the globalfold commit; the commits after it are unpushed and have not been through CI.

### CI, confirmed per job

**Run `30743668444`, sha `aa987b0`: success on hygiene, ubuntu-latest and macos-latest.** The first run covering the rule-4 documentation, both thread closes and ST0003. Checked per job rather than read off the summary line -- `gh run list` prints one word for a run and this project has been bitten by summary probes that flattened a real failure.

hv's own `aa987b0` "EOD" regenerated `intent/todo.md` from the new thread state. Re-running `intent todo update` produces no diff, so the generated view is current, and it carries ST0003 with all eight work packages.

**One probe of mine was wrong again, in the fold that records probe failures.** Grepping `todo.md` for `WP-0` returned zero and I nearly wrote that the WPs were missing -- the file numbers them `01:` through `08:`, so the pattern could not match. **The file was right and the probe was not.** Same shape as every other entry in this section.
