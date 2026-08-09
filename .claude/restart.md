# Restart -- Cdsync

Run `/in-session` first. Then `intent/docs/design-system-lifecycle.md` (canon), then `intent/restart.md`. **This file is the focus and the pointers, and nothing else** -- everything it used to restate is one click away and drifts the moment there are two copies.

## THE REPOSITORY IS PUBLIC

Since 6 August. **Everything committed here is published the moment it is pushed** -- `intent/`, the steel threads, the whiteboard, this file. There is no private tree to be careless in any more. **No key, token, absolute path or real contact address in a tracked file**; two venture addresses were redacted immediately before publication.

**The published history is a single root commit and the rest is not recoverable from here.** Why, and where it is kept, is in `intent/restart.md`.

## Picked up: one live edge, and it is unblocked

ST0003 "Post-release 0.1.0 clean-up" is **WIP with six of eight WPs closed** -- 9 August was the day hv's wind-back and rulings landed all at once. **The delivered projects are delivered: the loop does not run back to Claude Design for them**, and the tree in each is a record of what was asked for.

**The one live thing is WP-03, the spec-library pass, and every question it needs is already ruled** -- it runs when hv says. `intent/st/ST0003/tasks.md` is the flat view; the day's story is `intent/whiteboard/cc/.history/20260809/`.

**WP-02 is parked by hv.** Do not pick it up unless hv re-opens it. **Nothing is awaiting hv.**

**Unpushed at the 9 Aug fold**: three commits here, one in Baize, one in Intent, two in Acme's nested repo. Pushing is hv's.

## Where everything else lives

**One home per thing. If you are about to restate one of these somewhere, that is the bug.**

| What | Where |
| ---- | ---- |
| Canon, which outranks everything | `intent/docs/design-system-lifecycle.md` |
| Rulings, settled and not to be re-opened | `intent/whiteboard/cc/wip.md` `## Decisions` |
| Watch-outs, the standing hazards | `intent/whiteboard/cc/wip.md` `## Watch-outs` |
| What is open, and its record | `intent/st/ST0003/WP/*/info.md` |
| Orientation, state, and the live edge | `intent/restart.md`, `intent/wip.md` |

**No count of anything lives in this file.** Tests, work packages, specs, stale documents: every number this file has ever carried went stale, and two of them were being read as fact by the next session. `cdsync doctor` prints the library counts and the suite prints its own.

## The three that will cost you most

Stated in full where they live; named here only so you go and read them before acting.

- **`install` replaces and `import` merges.** Choosing wrong is the most destructive thing in the tool. `intent/restart.md` has the table.
- **A local pass has never predicted CI here**, and every miss has been shell-version deep. Read `gh run view --log-failed` rather than guessing. The board has them.
- **A check that cannot see a thing does not fail -- it reports clean.** The board's longest section, and it earns another entry most weeks. **Validate the instrument before believing the answer, and in both directions.**
