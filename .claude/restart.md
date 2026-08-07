# Restart -- Cdsync

Run `/in-session` first. Then `intent/docs/design-system-lifecycle.md` (canon), then `intent/restart.md`. **This file is the focus and the pointers, and nothing else** -- everything it used to restate is one click away and drifts the moment there are two copies.

## THE REPOSITORY IS PUBLIC

Since 6 August. **Everything committed here is published the moment it is pushed** -- `intent/`, the steel threads, the whiteboard, this file. There is no private tree to be careless in any more. **No key, token, absolute path or real contact address in a tracked file**; two venture addresses were redacted immediately before publication.

**The published history is a single root commit and the rest is not recoverable from here.** Why, and where it is kept, is in `intent/restart.md`.

## Picked up, and mid-flight

ST0003 "Post-release 0.1.0 clean-up" is **WIP**, 2 of 8 work packages moved. **335 tests, 0 failures. CI success on all three jobs. Every repository clean and at `ahead=0`.**

**Next, both unblocked:**

- **WP-07 -- Baize and snorkeltoast.** **Gyre & Gymble is done, and its premise was wrong: it was already integrated.** Ask the same of these two before recording that they build against nothing. Lamplight holds for WP-06's `ref` ruling.
- **WP-08 -- housekeeping.** Nothing in it waits on anyone.

**Blocked on hv, and do not start one by guessing at its ruling:** WP-02, WP-03, WP-04, WP-05, WP-06. Each says what it waits for in its own `info.md`.

## Where everything else lives

**One home per thing. If you are about to restate one of these somewhere, that is the bug.**

| What | Where |
| ---- | ---- |
| Canon, which outranks everything | `intent/docs/design-system-lifecycle.md` |
| Rulings, settled and not to be re-opened | `intent/whiteboard/cc/wip.md` `## Decisions` |
| Watch-outs, the standing hazards | `intent/whiteboard/cc/wip.md` `## Watch-outs` |
| What is open, and what blocks it | `intent/st/ST0003/WP/*/info.md` |
| Orientation, state, and where the work is | `intent/restart.md`, `intent/wip.md` |

## The two that will cost you most

Both are stated in full where they live; named here only so you go and read them before acting.

- **`install` replaces and `import` merges.** Choosing wrong is the most destructive thing in the tool. `intent/restart.md` has the table.
- **A local pass has never predicted CI here** -- four misses, every one shell-version deep. Read `gh run view --log-failed` rather than guessing. The board has the four.
