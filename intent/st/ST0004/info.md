---
st_id: ST0004
title: Rename the tool to Cdsync
status: Completed
created: 2026-08-06
completed: 2026-08-06T09:03:27Z
---

# ST0004: Rename the tool to Cdsync

## Objective

Rename the tool to Cdsync ("Claude Design Sync") with **no remnant of the former name** -- filenames, code and docs -- across this repository and every sibling repository that carried it. The former name described bootstrapping a venture; the tool now syncs design systems, and the name had stopped matching the job.

**This document deliberately does not spell the former name.** A thread titled after both names cannot survive its own rename -- the substitution would render it "rename Cdsync to Cdsync" -- so the record names the outcome and the mechanism instead. That is the one place where "no remnant" and "an honest record" pulled against each other, and this is how it was resolved. The former name is recoverable from git history, which is where superseded names belong.

## Context

**The rename is free of published artefacts.** `git tag -l` was empty and nothing had ever been released, so no tarball, tag or release note carried the former name. This was the cheapest the rename would ever be, and the cost only rises from here.

### Baseline, recorded BEFORE any mutation

The number below is the evidence that the later zero came from a probe able to hit. A uniform zero is a broken probe until proven otherwise; this is the proof.

| Form of the former name | Occurrences | Becomes  |
| ----------------------- | ----------: | -------- |
| lowercase               |         653 | `cdsync` |
| capitalised             |         284 | `Cdsync` |
| uppercase               |         483 | `CDSYNC` |
| **Total**               |    **1420** |          |

Across **123 tracked files**, plus **6 filenames** -- the entry point under `bin/`, its help page, the test suite, the venture config template, and both logo assets.

Test baseline: **328 tests, 0 failures**. Tags: **0**.

**Confirmation after the passes: 1420 occurrences of the new name, reconciling exactly against the baseline total**, with zero of the former name remaining and zero filenames carrying it.

### Why a plain substitution was safe here

Every character adjacent to every one of the 1420 matches was enumerated before the mechanism was chosen. The only characters preceding a match were ``$ ` / " * ' _ - { . }`` and space; the only ones following were `_ . - ' / , " * ) } \ ;` and space. **No alphanumeric ever touched a match**, so the old token was never a substring of a larger word and a case-sensitive replace could not corrupt a neighbour. The underscore-prefixed hits were shell function names, all intended to change.

### Three mechanism decisions, all deliberate

**Substitute over ALL tracked text files, not over a match-list.** A file list built from a probe inherits that probe's blind spots, and this project has been bitten three times by exactly that shape. A superset has no blind spot. The two binaries -- the logo PDF and a template `.pptx` -- were excluded by `git grep -I`.

**Rename files with `git mv`,** so history follows the file rather than reading as an unrelated delete and add. All six were confirmed staged as `R`.

**Regenerate generated artefacts; never substitute them.** `AGENTS.md`, `intent/.treeindex/*` and `intent/todo.md` are generated. A sed against a generated file either reverts on the next generation or diverges from it silently.

### The first substitution attempt did not apply, and the proof caught it

BSD `xargs` has no `-a`, so the first pass silently changed nothing while the loop ran to completion. The before/after counters printed `before=654 after=654` and the run was rejected. **This is the standing reason every mutation prints proof it landed**: the failure mode is that the tool reports the reassuring answer. Nothing had partially applied, so there was nothing to unwind.

### One test failed for a reason that was not the rename

`a release archive carries the tool and not how it is made` builds its listing with `git archive HEAD` -- deliberately, so it pins the real `.gitattributes` export-ignore mechanism rather than a list restated in the module. It reads **committed** state, so it failed while the rename was staged but uncommitted, and passed once committed. The test was right; the working tree was simply ahead of `HEAD`.

### Cross-repository reach

**149 occurrences across 54 files in four sibling repositories.**

| Repo      | Files | Occurrences | Shape                                                           |
| --------- | ----: | ----------: | --------------------------------------------------------------- |
| Lamplight |    18 |          43 | generated `BOOTSTRAP-CD.md`, `RETURN.md`, ignore files, history  |
| Laksa     |    14 |          39 | closed ST0084 and whiteboard history only                        |
| Utilz     |    12 |          42 | docs, plus a whiteboard sender moniker in two inbox filenames     |
| Baize     |    10 |          25 | generated `BOOTSTRAP-CD.md`, `RETURN.md`, ignore files, history  |

**Utilz does not invoke the binary.** The initial reading of the risk was that it shelled out to the tool; it does not. Its exposure is a whiteboard sender moniker, which is a cross-repo routing key rather than a call.

**Lamplight and Baize carry generated `BOOTSTRAP-CD.md`.** Regeneration fires on sync only, so a generator change stales every copy at once with no local symptom. These are reconciled by regenerating with the renamed tool and diffing against the substituted text -- an empty diff proves the substitution matched what the generator now emits.

**Three of the four had live sessions running during this work**, with whiteboard heartbeats inside the hour and modified `wip.md` boards. Their dirty files were checked for overlap against the files this thread edits: none. Every sibling commit therefore uses an explicit pathspec and never `git add -A`.

### Two symlinks were already broken before this thread started

`~/.local/bin/` and `~/bin/` both pointed into the old project directory, which the earlier filesystem move had already destroyed. They are repointed at the renamed entry point as part of this work.

## Related Steel Threads

- ST0003 Post-release 0.1.0 clean-up -- WP-05 asks where the venture config file lives. This thread renames that file to `cdsync.json` and so settles half of WP-05 by side effect. Zero deployed instances existed in any sibling, so the wire-format change was free.

## Acceptance

Acceptance Criteria and Acceptance Tests are RENDERED into `acceptance.md`, which is a GENERATED VIEW -- a row authored there is discarded by the next sync. The contract is canon in this thread's model: change a state with the `intent ac` / `intent at` verbs, and mint or reword a row in `.canon/st/ST0004.json`, then `intent sync --to-store`. This cover never restates them.

---

_Generated by Intent v3.0.0 from `thread.json`. Do not edit this file -- it is rendered from the model, and `intent doctor` reports any hand-edit as skew._
