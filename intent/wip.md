---
verblock: "06 Aug 2026:v1.0: Matthew Sinclair - Globalfold: ST0004 renamed the tool to Cdsync across five repositories, and the live docs collapsed to one home per thing"
---

# Work In Progress

Project-wide snapshot, folded at the end of 6 August. The live per-session channel is `intent/whiteboard/cc/wip.md`; this is the settled version. **Orientation, canon and the unblocked-work ordering are in `intent/restart.md` and are not restated here.**

## Where the project stands

**Cdsync v1 is released and public.** **Ten commands** -- `new`, `init`, `brief`, `bootstrap`, `install`, `import`, `check`, `site`, `release`, plus `doctor`. **335 tests, 0 failures.** Shellcheck silent at default severity. **CI green on hygiene, ubuntu-latest and macos-latest.** A spec library of 27 against a 52-slug taxonomy, plus 7 bundles. `README.md` and `LICENSE.md` (MIT).

**The repository is public as of 6 August**, published from a single root commit. The 135-commit development history was truncated and retained privately at the Dropbox mirror on `archive/pre-public-20260806`, with a bundle beside it. **Everything committed here is now published on push.**

**ST0003 is in flight**, 1 of 8 work packages done. All five repositories are pushed and at `ahead=0` on every remote.

**Six projects hold a design system tree.** matthewsinclair and geodica completed round one on 2 August; the original four -- Lamplight, Baize, snorkeltoast, Gyre & Gymble -- are from round three and await integration. **hv is rolling both new design systems out in Laksa and fixing forward**; implementation is not this project's thread.

**0.1.0 is released.** Tag `v0.1.0` on `e54ebbc`, annotated; GitHub release published with `cdsync-0.1.0.tar.gz` (474,181 bytes, 140 entries). Verified by downloading the published asset, confirming its sha256 matched the local build byte for byte, extracting it and running it. `VERSION` stays `0.1.0` and is now a **released** version, so the next cut moves off it.

## Steel threads

| ID | Title | Status | Gate |
| -- | ----- | ------ | ---- |
| ST0001 | Harvest template v0 from the three Claude Design projects | Completed | 16/16 |
| ST0002 | Port four established projects to the Cdsync shape | Completed | 12/12 |
| ST0004 | Rename the tool to Cdsync | Completed | 11/11 |
| ST0003 | Post-release 0.1.0 clean-up | **WIP** | WP-01 closed 8/8; 7 remain |

Each close went through `intent st done`, which refuses while a contract is BLOCKED, so each had to earn its number. `intent st list` shows nothing by default -- use `--status Completed`.

**ST0001 and ST0002 both state their boundary explicitly and carry the remainder forward** rather than dropping it. ST0001's bar was never "all 52 slugs specified" -- the library is designed to grow one order at a time, and 27 are written. ST0002's was never "all four pass `check`" -- three carry a pre-Cdsync convention the checker cannot read, and converting them is its own round by ruling. **Read `acceptance.md` in either before assuming something was skipped.**

**ST0003 holds everything carried forward** -- eight work packages, most blocked on a ruling rather than on effort. **WP-01, WP-07 and WP-08 are unblocked.** Its contract is deliberately unwritten: an empty contract reads as BLOCKED, which is the gate working.

## What ST0004 did, 6 August

The tool was renamed to Cdsync across **five repositories** -- this one plus Utilz, Laksa, Lamplight and Baize. **1569 occurrences and 8 filenames, zero remnant anywhere it can be read**, each repository verified against a positive control equal to its own pre-mutation baseline. It was free: no tag existed and nothing had ever been released, so no published artefact carried the old name.

Three things it taught, all now standing watch-outs on the board:

- **A rename is safe as a plain substitution only after enumerating what is adjacent to every match** -- the actual character set, not a word-boundary regex chosen on faith.
- **The first substitution pass applied nothing at all** and the loop ran to completion looking fine. BSD `xargs` has no `-a`. The before/after counters caught it.
- **A generator pointed at the wrong root reports an empty tree with total confidence.** It did not error; it produced a well-formed document falsely claiming Lamplight has no assets.

## What WP-01 did, 6 August

**0.1.0 is cut and shipped, and getting there needed two fixes to the release command itself.** Neither was visible from reading it; both showed up the first time anyone tried to release anything.

- **`cut` could not tag the version a project is on.** It took only `major|minor|patch`, all of which move forward -- so the version a first release needs was unreachable, for every project. Both verbs now also take a bare semver. Equality with the current version is allowed deliberately; whether a version has been *released* is a question about tags, answered by the gate that finds the tag already exists.
- **The ceremony then died one step later.** Cutting the version already in `VERSION` writes the same bytes, so `git commit` had nothing to commit. Every gate went green and step 3 failed. The tag now goes on the commit that is already the release rather than on an empty one manufactured beside it.

**Three reasons nothing caught the second one, all of them on the board's watch-out list:** a dry run stops before writing; the six new unit tests asserted one layer above where it lived; and the ceremony is untestable end to end here on purpose, because `release_gates` refuses to run inside bats.

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
