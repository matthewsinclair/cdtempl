# Restart -- Cdsync

Run `/in-session` first. Then `intent/docs/design-system-lifecycle.md` (canon), then `intent/restart.md`. This file is only the focus.

## Nothing to pick up

**Cdsync is finished and in bed.** hv put it away on 2 August and it has not been taken out since. **Do not start a work package unasked.**

**No steel thread is open.** ST0001 (16/16), ST0002 (12/12) and ST0004 (11/11) all closed through `intent st done`, which refuses a BLOCKED contract, so each earned it. They live at `intent/st/COMPLETED/`; `intent st list` shows nothing by default -- use `--status Completed`. **Do not go looking for half-finished work.**

**ST0003 "Post-release 0.1.0 clean-up" holds everything carried forward** -- eight work packages at `intent/st/NOT-STARTED/ST0003/`, each with its own `info.md` stating what blocks it. **WP-01 (cut the release), WP-07 (integrate the original four) and WP-08 (housekeeping) are unblocked.** The rest wait on a ruling from hv or on transport. **Do not start a blocked WP by guessing at its ruling.**

## State, 6 August

**Green everywhere.** 328 tests, 0 failures. Shellcheck silent at default severity. **CI success on hygiene, ubuntu-latest and macos-latest**, read per job. All five repositories pushed and at `ahead=0` on every remote.

**The tool was renamed to Cdsync on 6 August** (ST0004), across this repository and Utilz, Laksa, Lamplight and Baize -- 1569 occurrences, zero remnant, verified in each against a positive control equal to its own pre-mutation baseline. The former name is recoverable from git history and survives nowhere else.

**Nothing has ever been released.** `VERSION` is `0.1.0`, no tags exist, and `cdsync release cut` will not push without `--push`.

## Where everything else lives

**One home per thing. If you are about to restate one of these somewhere, that is the bug.**

| What | Where |
| ---- | ----- |
| Rulings, settled and not to be re-opened | `intent/whiteboard/cc/wip.md` `## Decisions` |
| Watch-outs, the standing hazards | `intent/whiteboard/cc/wip.md` `## Watch-outs` |
| Canon | `intent/docs/design-system-lifecycle.md` |
| What is open, and what blocks it | `intent/st/NOT-STARTED/ST0003/WP/*/info.md` |
| Orientation, and where the work is | `intent/restart.md` |

## The two that will cost you most

**`install` replaces, `import` merges, and hand-unzipping is never correct.** An as-is export is the whole tree; a converted drop is a subset. Choosing wrong is the most destructive thing in the tool.

**A local pass has never predicted CI here** -- four misses now, every one shell-version deep. Read `gh run view --log-failed` rather than guessing.
