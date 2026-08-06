---
verblock: "06 Aug 2026:v0.2: matts - Real contract written against the proven ST0002 format"
st_id: ST0004
title: "Rename the tool to Cdsync -- acceptance contract"
---

# ST0004 Rename the tool to Cdsync -- Acceptance

> Canonical acceptance contract for ST0004. Acceptance Criteria (AC) are the ratified completeness boundary; Acceptance Tests (AT) are the small red-to-green tests that prove them. Real test code lives in the suite (paths cited below); this file is the contract plus the AC-to-AT coverage map plus live status. info.md / WP info.md reference this file and never restate ACs (one home).
>
> Done = every AC is covered by a GREEN AT, or (for a non-test AC) its named evidence is satisfied, AND the AC set is the ratified full boundary. Done is read from this map, never from a hand-ticked box.
>
> Change control: clarifying an AC or AT is verifier-and-builder; shrinking scope, or weakening an AT to make it pass, needs the owner.
>
> AT status vocabulary: to-write (red-first) | red | green | n/a (non-test: doc / eyeball / gate).

## The boundary, stated before the criteria

**The bar is "no remnant of the former name anywhere it can be read", not "the tool still builds".** A rename that leaves the suite green but leaves the old brand in a help page, an ignore-file comment or a sibling repository's generated document has not done the job.

**"Anywhere it can be read" is scoped to five repositories** -- this one and the four siblings that carried the name. It is not scoped to git history, which is where superseded names are supposed to live, nor to the logo artwork, which is vector art this thread can rename but cannot redraw.

**A zero from a probe is not evidence until the probe is shown able to hit.** Every zero below is paired with a positive control on the same probe, reconciled against a count taken before any mutation. This is the project's most-repeated failure shape and the contract refuses to restate it as a bare zero.

## Acceptance Criteria

### ST-level

- AC-00.1 (non-test) **No occurrence of the former name remains in this repository** in tracked content, in any filename, or on disk including untracked and ignored files -- evidence: `git grep -oi` = 0, `git ls-files | grep -ic` = 0, `grep -ril` over the working tree = 0 files -- satisfied: yes
- AC-00.2 (non-test) **The probe reporting that zero is proven able to hit**, by a positive control reconciling exactly against the pre-mutation baseline -- evidence: baseline 653 + 284 + 483 = 1420 recorded in `info.md` before any mutation; post-substitution count of the new name = 1420, exact -- satisfied: yes
- AC-00.3 **The tool still does what it did**, under the new name, with no test weakened or removed to achieve it -- covered by AT-00.1; test count must remain 328
- AC-00.4 (non-test) **Static analysis stays silent and the tool's own self-check passes** -- evidence: `shellcheck bin/cdsync lib/*.sh` silent at default severity; `cdsync doctor` passes -- satisfied: yes
- AC-00.5 (non-test) **CI is green on every job, read per job rather than off the summary line** -- evidence: run `31086141984` on PR #1, `success` on hygiene, `tests (ubuntu-latest)` and `tests (macos-latest)`, read from `gh run view --json jobs` per job -- satisfied: yes
- AC-00.6 (non-test) **The six file renames preserve history** rather than reading as unrelated deletes and adds -- evidence: all six staged as `R` in `git status --porcelain` -- satisfied: yes
- AC-00.7 (non-test) **No occurrence of the former name remains in the four sibling repositories**, each verified with the same paired positive control -- evidence: Utilz, Laksa, Lamplight and Baize all at 0 tracked, 0 filenames and 0 on disk; each one's positive control equals its own pre-mutation baseline exactly (42, 39, 43, 25) -- satisfied: yes
- AC-00.8 (non-test) **Both user-level symlinks resolve** to the renamed entry point, having been left dangling by the earlier directory move -- evidence: the two dangling links were removed and replaced; `~/bin/cdsync` and `~/.local/bin/cdsync` each execute and report `cdsync 0.1.0` -- satisfied: yes
- AC-00.9 (non-test) **Every generated document carrying the name agrees with what the renamed generator now emits**, rather than merely having been substituted to look right -- evidence: both regenerated with the renamed tool via `bootstrap --stdout` and diffed against the substituted text; **zero name-related differences** in either. The residual diff is pre-existing numbering drift (Lamplight's steel-thread count, Baize's ADR and steel-thread counts) that predates this thread and is those projects' own to reconcile -- satisfied: yes
- AC-00.10 (non-test) **Nothing was swept up from a sibling repository's uncommitted work.** Three of the four had live sessions with modified boards while this ran -- evidence: overlap computed with `comm -12` between each repo's dirty set and this thread's target set before any mutation, empty in all three; every sibling commit made with `git commit --only` and an explicit pathspec, never `git add -A`; after each commit their modified boards remained unstaged (Laksa 4, Lamplight 5, Baize 4) -- satisfied: yes
- AC-00.11 (non-test) **The AC-00.9 reconciliation was itself run against a target proven able to see the tree.** The first attempt pointed at `design/` rather than `design/system/` and reported 0 assets for a tree that has four, each with its `spec.md`. It did not error -- it produced a well-formed document making a false claim. A zero from a generator is not evidence until the generator is shown able to find something -- evidence: re-run against `design/system/` reports `**4 assets**` for Lamplight, matching the document it was being diffed against -- satisfied: yes

## Acceptance Tests

The rename is verified by probes rather than by new tests: the existing suite is the regression gate that the tool still works, and the zero-remnant criteria are measurements, not behaviours. No new test is written, because there is no new behaviour -- adding one would assert that a string is absent, which the probe already does more thoroughly than a bats case could.

### ST-level

- AT-00.1 test/cdsync.bats (whole suite, 328 tests) -- covers AC-00.3 -- status: green
- AT-00.2 test/cdsync.bats::"a release archive carries the tool and not how it is made" -- covers AC-00.3 -- status: green -- called out separately because it builds its listing with `git archive HEAD` and so failed until the rename was committed; it reads committed state by design, which is what makes it the honest check of the packaging contract

## Post-close note -- 6 August 2026: the boundary was too narrow, and the remainder is now done

**Every criterion above was satisfied as written. The bar they were measured against was wrong**, and this note exists so the next reader does not inherit it.

The boundary at the head of this file scopes the work to *"five repositories -- this one and the four siblings **that carried the name**"*. The italicised clause is a claim about the world; the five names after it are the set that was actually checked. **`~/Devel/prj/Sites/gyreandgymble` and `~/Devel/prj/Sites/snorkeltoast` also carried the name** -- 28 and 26 occurrences -- and were never in the set, because the survey that drew it up enumerated `~/Devel/prj/*` and did not descend into `Sites/`.

**No control could have caught this.** AC-00.2 and AC-00.7 each proved a probe able to hit inside the repository it was pointed at, which is a statement about the instrument. Nothing anywhere in this contract asked what enumerated the repositories. That distinction is now on the board's watch-out list as its own shape.

**AC-00.1 was also false for this repository**, in the narrow region it explicitly claimed: `templates/_test/Acme/` is gitignored, so a sweep working from tracked content never saw it. It held 30 occurrences and a `vboot.json` -- and the filename was the live defect, because the tool resolves through `cdsync.json` now, so `cdsync brief` there would have reported *"no cdsync.json here"* with the configuration beside it under its old name.

**All three are now at zero** -- tracked, on disk, and in filenames -- each with the same paired positive control (28, 26 and 30 against their own pre-mutation baselines), and adjacency enumerated before substitution in every case. `design/.gitignore` gives the strongest available check and passes: the four repositories hold a byte-identical repo-owned copy, the rename had split them into two pairs, and all four now hash to `d230e257` again.

**Three on-disk occurrences remain across the family and are deliberate**: a dated backup under `Utilz/.backup/` (editing inside a backup corrupts it), Laksa's `_build/` release output (regenerates), and a base64 image fixture in a vendored dependency of Lamplight whose bytes happen to contain the letters -- it matches only a case-INSENSITIVE probe, and this thread's substitution was case-sensitive.

**This thread stays closed.** It did what it said within the boundary it declared; the boundary is what failed, and a close is not the place to relitigate scope. The completion above is recorded here rather than in a new thread because it is the same work, finished.
