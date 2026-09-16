# Restart -- Cdtempl

**This file is where to start and where everything lives, and nothing else.** It holds no state: no focus, no work in flight, no count. What is open and what awaits hv are in `intent/restart.md`, and a second copy of either here is the drift this project keeps paying down.

## Start here

1. **Run `/in-session`.** It loads the skills, releases the prompt gate and picks up your whiteboard node; `intent wb status` lists the nodes.
2. **Read the canon**, `intent/docs/design-system-lifecycle.md`. It outranks every other document.
3. **Read `intent/restart.md`** for orientation: what is open, what awaits hv, and what was carried forward.
4. **Read the rulings and the watch-outs on cc's board before acting, not after.**

## Where everything lives

**One home per thing. If you are about to restate one of these somewhere, that is the bug.**

| What                                              | Where                                         |
| ------------------------------------------------- | --------------------------------------------- |
| Canon, which outranks everything                  | `intent/docs/design-system-lifecycle.md`      |
| Rulings, settled and not to be re-opened          | `intent/whiteboard/cc/wip.md` `## Decisions`  |
| Watch-outs, the standing hazards                  | `intent/whiteboard/cc/wip.md` `## Watch-outs` |
| Orientation, and what was carried forward         | `intent/restart.md`                           |
| Threads, gates, release record, structural guards | `intent/wip.md`                               |
| What a work package found                         | its own record, `intent wp list <thread>`     |
| The live channel between sessions                 | the whiteboard, `intent wb status`            |

**No count of anything lives in this file.** Every number it has carried went stale, and two were read as fact by the next session. `cdtempl doctor` prints the library counts and the suite prints its own.

## What will cost you most

Named here so you read them before acting. Each is stated in full where it lives.

- **The repository is public: everything committed is published on push, and pushing is hv's.** No key, token, absolute path or real contact address in a tracked file. The watch-outs have the rest, including the two remotes.
- **`install` replaces and `import` merges.** Choosing wrong is the most destructive thing in the tool. `intent/restart.md` has the table.
- **A local pass has never predicted CI here**, and every miss has been shell-version deep. Read `gh run view --log-failed` rather than guessing.
- **A check that cannot see a thing does not fail -- it reports clean.** Validate the instrument before believing the answer, and in both directions.
- **A premise restated often enough starts reading as evidence.** Agreement between documents is not corroboration. Check the claim against the code it describes.
