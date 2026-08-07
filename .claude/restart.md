# Restart -- Cdsync

Run `/in-session` first. Then `intent/docs/design-system-lifecycle.md` (canon), then `intent/restart.md`. This file is only the focus.

## THE REPOSITORY IS PUBLIC

Since 6 August. **Everything committed here is published the moment it is pushed** -- `intent/`, the steel threads, the whiteboard, this file. There is no private tree to be careless in any more.

The published history is a **single root commit**; the 135-commit development history was truncated and is retained privately at the Dropbox mirror on `archive/pre-public-20260806`, plus a bundle beside it. **Do not try to recover it from the public repository -- it is not there**, and re-pushing it would undo a deliberate decision.

Two venture contact addresses were redacted before publication. **Do not reintroduce a real contact address, key, token or absolute path into any tracked file.**

## Picked up, and mid-flight

ST0003 "Post-release 0.1.0 clean-up" is **WIP**, 2 of 8 work packages moved.

**Next, and both unblocked:**

- **WP-07 -- the rest of the original four.** **Gyre & Gymble is done** (6 Aug), and its premise was wrong: it was already integrated, and what was missing was a check that its theme still agrees with its kit. **Ask the same of Baize and snorkeltoast before recording that they build against nothing.** Hold Lamplight's `ref`: it is the one open ruling that could still move paths.
- **WP-08 -- housekeeping and small gaps.**

**The rename is finished for real.** It had missed `Sites/gyreandgymble`, `Sites/snorkeltoast` and this repo's gitignored `templates/_test/Acme/`. All at zero; ST0004 stays closed with a post-close note.

**Blocked on hv, and do not start one by guessing at its ruling:** WP-02 (two rule-4 rulings), WP-05 (`cdsync.json`'s home, `spec_version` for a new asset), WP-06 (round three's seven rulings), WP-03 (partly on WP-05), WP-04 (transport, which only hv can decide to send).

## State, 6 August

**0.1.0 is RELEASED.** Tag `v0.1.0` on `e54ebbc`, annotated, pushed. GitHub release published with `cdsync-0.1.0.tar.gz` (474,181 bytes, 140 entries), verified by downloading the published asset and running it. **`VERSION` is `0.1.0` and it is now a released version** -- the next cut moves off it.

**335 tests, 0 failures.** Shellcheck silent at default severity. **CI success on hygiene, ubuntu-latest and macos-latest.** All five repositories at `ahead=0`.

**Closed:** ST0001 16/16, ST0002 12/12, ST0004 11/11 (the rename), ST0003/WP-01 8/8.

## Where everything else lives

**One home per thing. If you are about to restate one of these somewhere, that is the bug.**

| What | Where |
| ---- | ----- |
| Rulings, settled and not to be re-opened | `intent/whiteboard/cc/wip.md` `## Decisions` |
| Watch-outs, the standing hazards | `intent/whiteboard/cc/wip.md` `## Watch-outs` |
| Canon | `intent/docs/design-system-lifecycle.md` |
| What is open, and what blocks it | `intent/st/ST0003/WP/*/info.md` |
| Orientation, and where the work is | `intent/restart.md` |

## The two that will cost you most

**`install` replaces, `import` merges, and hand-unzipping is never correct.** An as-is export is the whole tree; a converted drop is a subset. Choosing wrong is the most destructive thing in the tool.

**A local pass has never predicted CI here** -- four misses, every one shell-version deep. Read `gh run view --log-failed` rather than guessing.
