---
verblock: "06 Aug 2026:v1.0: Matthew Sinclair - Globalfold: ST0004 renamed the tool to Cdsync across five repositories, and the live docs collapsed to one home per thing"
---

# Work In Progress

Project-wide snapshot, folded at the end of 6 August. The live per-session channel is `intent/whiteboard/cc/wip.md`; this is the settled version. **Orientation, canon and the unblocked-work ordering are in `intent/restart.md` and are not restated here.**

## Where the project stands

**Cdsync v1 is closed out and public-ready.** **Ten commands** -- `new`, `init`, `brief`, `bootstrap`, `install`, `import`, `check`, `site`, `release`, plus `doctor`. **328 tests, 0 failures.** Shellcheck silent at default severity. **CI green on hygiene, ubuntu-latest and macos-latest.** A spec library of 27 against a 52-slug taxonomy, plus 7 bundles. `README.md` and `LICENSE.md` (MIT).

**Nothing is in flight and no thread is open.** All five repositories are pushed and at `ahead=0` on every remote.

**Six projects hold a design system tree.** matthewsinclair and geodica completed round one on 2 August; the original four -- Lamplight, Baize, snorkeltoast, Gyre & Gymble -- are from round three and await integration. **hv is rolling both new design systems out in Laksa and fixing forward**; implementation is not this project's thread.

**Nothing has ever been released.** `VERSION` is `0.1.0` and no tag exists.

## Steel threads

| ID | Title | Status | Gate |
| -- | ----- | ------ | ---- |
| ST0001 | Harvest template v0 from the three Claude Design projects | Completed | 16/16 |
| ST0002 | Port four established projects to the Cdsync shape | Completed | 12/12 |
| ST0004 | Rename the tool to Cdsync | Completed | 11/11 |
| ST0003 | Post-release 0.1.0 clean-up | Not Started | contract deliberately unwritten |

Each close went through `intent st done`, which refuses while a contract is BLOCKED, so each had to earn its number. `intent st list` shows nothing by default -- use `--status Completed`.

**ST0001 and ST0002 both state their boundary explicitly and carry the remainder forward** rather than dropping it. ST0001's bar was never "all 52 slugs specified" -- the library is designed to grow one order at a time, and 27 are written. ST0002's was never "all four pass `check`" -- three carry a pre-Cdsync convention the checker cannot read, and converting them is its own round by ruling. **Read `acceptance.md` in either before assuming something was skipped.**

**ST0003 holds everything carried forward** -- eight work packages, most blocked on a ruling rather than on effort. **WP-01, WP-07 and WP-08 are unblocked.** Its contract is deliberately unwritten: an empty contract reads as BLOCKED, which is the gate working.

## What ST0004 did, 6 August

The tool was renamed to Cdsync across **five repositories** -- this one plus Utilz, Laksa, Lamplight and Baize. **1569 occurrences and 8 filenames, zero remnant anywhere it can be read**, each repository verified against a positive control equal to its own pre-mutation baseline. It was free: no tag existed and nothing had ever been released, so no published artefact carried the old name.

Three things it taught, all now standing watch-outs on the board:

- **A rename is safe as a plain substitution only after enumerating what is adjacent to every match** -- the actual character set, not a word-boundary regex chosen on faith.
- **The first substitution pass applied nothing at all** and the loop ran to completion looking fine. BSD `xargs` has no `-a`. The before/after counters caught it.
- **A generator pointed at the wrong root reports an empty tree with total confidence.** It did not error; it produced a well-formed document falsely claiming Lamplight has no assets.

## Structural guards, cumulative

- The front-page command table must list every command the dispatcher accepts.
- Every flag a command implements must be documented in its help file.
- The README's rule table must match `help/check.md`, its source.
- Every colour form in `CDSYNC_COLOUR_RE` must be named in `help/check.md`.
- The bootstrap inventory must be ordered by bytes, not by locale.
- No tracked file may carry an absolute home directory path.
- No test may hang on the install prompt.
- A release archive carries the tool and not how it is made, checked through `git archive` against the real `.gitattributes` rather than a restated list.

## Context for LLM

Start a session with `/in-session`. Read the canon first, then `intent/restart.md`, then the thread you are picking up. `intent/whiteboard/cc/wip.md` is the live board and is the one home for both the rulings and the watch-outs.
