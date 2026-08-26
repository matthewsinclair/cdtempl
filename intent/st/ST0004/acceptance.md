---
st_id: ST0004
title: Rename the tool to Cdsync
---

# ST0004: Rename the tool to Cdsync -- Acceptance

> **THIS FILE IS A GENERATED VIEW, AND A ROW AUTHORED HERE IS DISCARDED BY THE NEXT SYNC.** The acceptance contract is canon in the thread model; this file renders it. Acceptance Criteria (AC) are the ratified completeness boundary; Acceptance Tests (AT) are the small red-to-green tests that prove them.
>
> Done = every AC is covered by a GREEN AT, or (for a non-test AC) its named evidence is satisfied, AND the AC set is the ratified full boundary. Done is read from this map, never from a hand-ticked box.
>
> Test-backed satisfaction is COMPUTED from covering green ATs and never stored -- storing it would be double truth. An AC has four states, not two: beyond satisfied and unsatisfied, a requirement can be **descoped** to a named thread or **withdrawn** with its reason on the record. Both are non-blocking and both are reported separately, so a thread that descoped half its contract looks like one.

## Acceptance Criteria

### ST-level

- AC-00.1 (non-test) **No occurrence of the former name remains in this repository** in tracked content, in any filename, or on disk including untracked and ignored files -- evidence: `git grep -oi` = 0, `git ls-files | grep -ic` = 0, `grep -ril` over the working tree = 0 files -- satisfied: yes
- AC-00.2 (non-test) **The probe reporting that zero is proven able to hit**, by a positive control reconciling exactly against the pre-mutation baseline -- evidence: baseline 653 + 284 + 483 = 1420 recorded in `info.md` before any mutation; post-substitution count of the new name = 1420, exact -- satisfied: yes
- AC-00.3 **The tool still does what it did**, under the new name, with no test weakened or removed to achieve it -- covered by AT-00.1; test count must remain 328 -- satisfied: yes (computed)
- AC-00.4 (non-test) **Static analysis stays silent and the tool's own self-check passes** -- evidence: `shellcheck bin/cdsync lib/*.sh` silent at default severity; `cdsync doctor` passes -- satisfied: yes
- AC-00.5 (non-test) **CI is green on every job, read per job rather than off the summary line** -- evidence: run `31086141984` on PR #1, `success` on hygiene, `tests (ubuntu-latest)` and `tests (macos-latest)`, read from `gh run view --json jobs` per job -- satisfied: yes
- AC-00.6 (non-test) **The six file renames preserve history** rather than reading as unrelated deletes and adds -- evidence: all six staged as `R` in `git status --porcelain` -- satisfied: yes
- AC-00.7 (non-test) **No occurrence of the former name remains in the four sibling repositories**, each verified with the same paired positive control -- evidence: Utilz, Laksa, Lamplight and Baize all at 0 tracked, 0 filenames and 0 on disk; each one's positive control equals its own pre-mutation baseline exactly (42, 39, 43, 25) -- satisfied: yes
- AC-00.8 (non-test) **Both user-level symlinks resolve** to the renamed entry point, having been left dangling by the earlier directory move -- evidence: the two dangling links were removed and replaced; `~/bin/cdsync` and `~/.local/bin/cdsync` each execute and report `cdsync 0.1.0` -- satisfied: yes
- AC-00.9 (non-test) **Every generated document carrying the name agrees with what the renamed generator now emits**, rather than merely having been substituted to look right -- evidence: both regenerated with the renamed tool via `bootstrap --stdout` and diffed against the substituted text; **zero name-related differences** in either. The residual diff is pre-existing numbering drift (Lamplight's steel-thread count, Baize's ADR and steel-thread counts) that predates this thread and is those projects' own to reconcile -- satisfied: yes
- AC-00.10 (non-test) **Nothing was swept up from a sibling repository's uncommitted work.** Three of the four had live sessions with modified boards while this ran -- evidence: overlap computed with `comm -12` between each repo's dirty set and this thread's target set before any mutation, empty in all three; every sibling commit made with `git commit --only` and an explicit pathspec, never `git add -A`; after each commit their modified boards remained unstaged (Laksa 4, Lamplight 5, Baize 4) -- satisfied: yes
- AC-00.11 (non-test) **The AC-00.9 reconciliation was itself run against a target proven able to see the tree.** The first attempt pointed at `design/` rather than `design/system/` and reported 0 assets for a tree that has four, each with its `spec.md`. It did not error -- it produced a well-formed document making a false claim. A zero from a generator is not evidence until the generator is shown able to find something -- evidence: re-run against `design/system/` reports `**4 assets**` for Lamplight, matching the document it was being diffed against -- satisfied: yes

## Acceptance Tests

### ST-level

- AT-00.1 `test/cdsync.bats` -- covers AC-00.3 -- status: green -- whole suite, 328 tests
- AT-00.2 (legacy) test/cdsync.bats::"a release archive carries the tool and not how it is made" -- covers AC-00.3 -- status: green -- called out separately because it builds its listing with `git archive HEAD` and so failed until the rename was committed; it reads committed state by design, which is what makes it the honest check of the packaging contract

---

_Generated by Intent v3.0.0 from `thread.json`. Do not edit this file -- it is rendered from the model, and `intent doctor` reports any hand-edit as skew._
