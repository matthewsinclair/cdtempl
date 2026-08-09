# Restart -- Cdsync

Run `/in-session` first. Then `intent/docs/design-system-lifecycle.md` (canon), then `intent/restart.md`. **This file is the focus and the pointers, and nothing else** -- everything it used to restate is one click away and drifts the moment there are two copies.

## THE REPOSITORY IS PUBLIC

Since 6 August. **Everything committed here is published the moment it is pushed** -- `intent/`, the steel threads, the whiteboard, this file. There is no private tree to be careless in any more. **No key, token, absolute path or real contact address in a tracked file**; two venture addresses were redacted immediately before publication.

**The published history is a single root commit and the rest is not recoverable from here.** Why, and where it is kept, is in `intent/restart.md`.

## Nothing is open, and that is the finished state

ST0003 closed 20/20 on 9 August, and **every steel thread is now Completed**. Nothing is in flight and nothing awaits hv. **The next piece of work opens a thread** -- `intent st new` -- rather than resuming one.

**Read `intent/restart.md`'s carried-forward list before starting anything.** It records what ST0003 did not do, each item with the condition that would re-open it. **They are written down so they are not lost, not so they are picked up** -- do not treat that list as a queue.

**Unpushed work exists here and in three sibling repositories, and pushing is hv's.** **No count lives in this file, and none should**: two remotes sit at different positions and the board's two-remotes watch-out says what to ask instead.

## Where everything else lives

**One home per thing. If you are about to restate one of these somewhere, that is the bug.**

| What                                              | Where                                         |
| ------------------------------------------------- | --------------------------------------------- |
| Canon, which outranks everything                  | `intent/docs/design-system-lifecycle.md`      |
| Rulings, settled and not to be re-opened          | `intent/whiteboard/cc/wip.md` `## Decisions`  |
| Watch-outs, the standing hazards                  | `intent/whiteboard/cc/wip.md` `## Watch-outs` |
| What each work package found                      | `intent/st/COMPLETED/ST0003/WP/*/info.md`     |
| Orientation, and what was carried forward         | `intent/restart.md`                           |
| Threads, gates, release record, structural guards | `intent/wip.md`                               |

**No count of anything lives in this file.** Tests, work packages, specs, stale documents: every number this file has ever carried went stale, and two of them were being read as fact by the next session. `cdsync doctor` prints the library counts and the suite prints its own.

## The four that will cost you most

Stated in full where they live; named here only so you go and read them before acting.

- **`install` replaces and `import` merges.** Choosing wrong is the most destructive thing in the tool. `intent/restart.md` has the table.
- **A local pass has never predicted CI here**, and every miss has been shell-version deep. Read `gh run view --log-failed` rather than guessing. The board has them.
- **A check that cannot see a thing does not fail -- it reports clean.** The board's longest section, and it earns another entry most weeks. **Validate the instrument before believing the answer, and in both directions.**
- **A premise restated often enough starts reading as evidence.** Twice in ST0003, and the second time three documents agreed because one was the source of the other two. **Agreement between documents is not corroboration.** Check the claim against the code it describes.
