---
verblock: "07 Aug 2026:v1.1: Matthew Sinclair - Globalfold: the rename finished across two more repositories, WP-07 done for G&G, and the restated watch-outs cut back to one home"
---

# Work In Progress

Project-wide snapshot, folded at the end of 6 August's work. The live per-session channel is `intent/whiteboard/cc/wip.md`; this is the settled version. **Orientation, canon and the unblocked-work ordering are in `intent/restart.md` and are not restated here.**

## Where the project stands

**Cdsync v1 is released and public.** **Ten commands** -- `new`, `init`, `brief`, `bootstrap`, `install`, `import`, `check`, `site`, `release`, plus `doctor`. **335 tests, 0 failures.** Shellcheck silent at default severity. **CI success on hygiene, ubuntu-latest and macos-latest**, read per job. `README.md` and `LICENSE.md` (MIT). **Read the spec-library numbers from `cdsync doctor`, not from prose here** -- it prints specs, taxonomy slugs and bundles, and a hand-copied count is how this project has drifted before.

**The repository is public as of 6 August**, published from a single root commit. The 135-commit development history was truncated and retained privately at the Dropbox mirror on `archive/pre-public-20260806`, with a bundle beside it. **Everything committed here is published on push.**

**ST0003 is in flight**, 2 of 8 work packages moved. Every repository touched is clean and at `ahead=0` on every remote.

**Six projects hold a design system tree.** matthewsinclair and geodica completed round one on 2 August. Of the original four from round three, **Gyre & Gymble is integrated and now checked**; Baize and snorkeltoast are open, and Lamplight waits on WP-06's `ref` ruling. **hv is rolling both new design systems out in Laksa and fixing forward**; implementation is not this project's thread.

**0.1.0 is released.** Tag `v0.1.0` on `e54ebbc`, annotated; GitHub release published with `cdsync-0.1.0.tar.gz` (474,181 bytes, 140 entries). Verified by downloading the published asset, confirming its sha256 matched the local build byte for byte, extracting it and running it. `VERSION` stays `0.1.0` and is now a **released** version, so the next cut moves off it.

## Steel threads

| ID | Title | Status | Gate |
| -- | ----- | ------ | ---- |
| ST0001 | Harvest template v0 from the three Claude Design projects | Completed | 16/16 |
| ST0002 | Port four established projects to the Cdsync shape | Completed | 12/12 |
| ST0004 | Rename the tool to Cdsync | Completed | 11/11, plus a post-close note |
| ST0003 | Post-release 0.1.0 clean-up | **WIP** | WP-01 closed 8/8; WP-07 part done |

Each close went through `intent st done`, which refuses while a contract is BLOCKED, so each had to earn its number. `intent st list` shows nothing by default -- use `--status Completed`.

**All three closed threads state a boundary and carry the remainder forward** rather than dropping it. ST0001's bar was never "all 52 slugs specified" -- the library grows one order at a time. ST0002's was never "all four pass `check`" -- three carry a pre-Cdsync convention the checker cannot read. **ST0004's boundary was simply wrong**, and its contract now says so. **Read `acceptance.md` in any of them before assuming something was skipped.**

**ST0003 holds everything carried forward** -- eight work packages, most blocked on a ruling rather than on effort. Its contract is deliberately unwritten: an empty contract reads as BLOCKED, which is the gate working.

## The rename, finished 6 August

The tool was renamed to Cdsync. ST0004 closed 11/11 on a stated bar of **five repositories** and every criterion was satisfied as written. **The bar was wrong.** `Sites/gyreandgymble` and `Sites/snorkeltoast` also carried the name, and so did this repository's own gitignored `templates/_test/Acme/` -- where the stale filename was a live defect, because the tool resolves through `cdsync.json` now.

**Seven repositories carry the name today and all are at zero**, tracked, on disk and in filenames. Three on-disk occurrences remain deliberately: a dated backup, Laksa's `_build/` output, and base64 image data in a vendored dependency that matches only a case-insensitive probe.

**The one lesson worth carrying, and it is on the board rather than repeated here: a positive control validates the instrument, not the sampling frame.** Every control ST0004 ran was sound and the answer was still wrong.

**ST0004 stays closed.** The completion is a post-close note on its contract -- reopening would relitigate scope at a close, and a new thread would split the record.

## What the work packages found

**Not restated here.** WP-01's two defects in `release` itself are in `intent/st/ST0003/WP/01/info.md`; WP-07's finding that its own premise was false for Gyre & Gymble is in `WP/07/info.md`. **The standing hazards they taught are on the board, in one copy** -- this file previously carried a second, which is the drift it keeps naming.

## Structural guards, cumulative

- The front-page command table must list every command the dispatcher accepts.
- Every flag a command implements must be documented in its help file.
- The README's rule table must match `help/check.md`, its source.
- Every colour form in `CDSYNC_COLOUR_RE` must be named in `help/check.md`.
- The bootstrap inventory must be ordered by bytes, not by locale.
- No tracked file may carry an absolute home directory path.
- No test may hang on the install prompt.
- A release archive carries the tool and not how it is made, checked through `git archive` against the real `.gitattributes` rather than a restated list.
- Every acceptance contract in the repository, live or completed, must name tests that exist.

## Context for LLM

Start a session with `/in-session`. Read the canon first, then `intent/restart.md`, then the thread you are picking up. `intent/whiteboard/cc/wip.md` is the live board and is the one home for both the rulings and the watch-outs.
