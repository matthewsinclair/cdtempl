# Restart -- Cdsync

Run `/in-session` first. Then `intent/docs/design-system-lifecycle.md` (canon), then `intent/restart.md`. **This file is the focus and the pointers, and nothing else** -- everything it used to restate is one click away and drifts the moment there are two copies.

## THE REPOSITORY IS PUBLIC

Since 6 August. **Everything committed here is published the moment it is pushed** -- `intent/`, the steel threads, the whiteboard, this file. There is no private tree to be careless in any more. **No key, token, absolute path or real contact address in a tracked file**; two venture addresses were redacted immediately before publication.

**The published history is a single root commit and the rest is not recoverable from here.** Why, and where it is kept, is in `intent/restart.md`.

## Picked up, and there is nothing to pick up

ST0003 "Post-release 0.1.0 clean-up" is **WIP**, and as of 8 August **every remaining item waits on an hv ruling.** That was not true before, and it is the one thing worth knowing on arrival: **do not go hunting for something unblocked, because there isn't any.**

**`intent/restart.md` has the waiting list in the order it is worth answering.** WP-05 is first, because it blocks two work packages rather than one.

**Do not start a blocked item by guessing at its ruling.** Each `info.md` says what it waits for. Guessing is how this project has generated its worst work, and one gap spent a day looking unblocked because nobody had traced what it depended on.

## Where everything else lives

**One home per thing. If you are about to restate one of these somewhere, that is the bug.**

| What | Where |
| ---- | ---- |
| Canon, which outranks everything | `intent/docs/design-system-lifecycle.md` |
| Rulings, settled and not to be re-opened | `intent/whiteboard/cc/wip.md` `## Decisions` |
| Watch-outs, the standing hazards | `intent/whiteboard/cc/wip.md` `## Watch-outs` |
| What is open, and what blocks it | `intent/st/ST0003/WP/*/info.md` |
| Orientation, state, and the waiting list | `intent/restart.md`, `intent/wip.md` |

**No count of anything lives in this file.** Tests, work packages, specs, stale documents: every number this file has ever carried went stale, and two of them were being read as fact by the next session. `cdsync doctor` prints the library counts and the suite prints its own.

## The three that will cost you most

Stated in full where they live; named here only so you go and read them before acting.

- **`install` replaces and `import` merges.** Choosing wrong is the most destructive thing in the tool. `intent/restart.md` has the table.
- **A local pass has never predicted CI here**, and every miss has been shell-version deep. Read `gh run view --log-failed` rather than guessing. The board has them.
- **A check that cannot see a thing does not fail -- it reports clean.** The board's longest section, and it earns another entry most weeks. **Validate the instrument before believing the answer, and in both directions.**
