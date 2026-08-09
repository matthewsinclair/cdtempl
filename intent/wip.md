---
verblock: "09 Aug 2026:v2.0: Matthew Sinclair - Globalfold: the settled ledger only; orientation and narrative move out"
---

# Work In Progress

**There is none.** Every steel thread is Completed and nothing is open -- so this file is no longer a snapshot of work in flight. It is the **settled ledger**: the threads and their gates, the release record, and the cumulative structural guards.

**Everything else has one home elsewhere, and this file points rather than restates.** It previously carried a second copy of the orientation, the rename story and the day's builds, which is the drift hazard this project keeps naming. Orientation is `intent/restart.md`. Rulings and watch-outs are `intent/whiteboard/cc/wip.md`. What each work package found is its own `info.md`.

## Steel threads

| ID     | Title                                                     | Status    | Gate                          |
| ------ | --------------------------------------------------------- | --------- | ----------------------------- |
| ST0001 | Harvest template v0 from the three Claude Design projects | Completed | 16/16                         |
| ST0002 | Port four established projects to the Cdsync shape        | Completed | 12/12                         |
| ST0004 | Rename the tool to Cdsync                                 | Completed | 11/11, plus a post-close note |
| ST0003 | Post-release 0.1.0 clean-up                               | Completed | 20/20                         |

Each close went through `intent st done`, which refuses while a contract is BLOCKED, so **each had to earn its number**. `intent st list` shows nothing by default -- use `--status Completed`.

**Every one of them states a boundary and carries its remainder forward** rather than dropping it, and the boundary is the part worth reading. ST0001's bar was never "the whole taxonomy specified" -- the library grows one order at a time. ST0002's was never "all four pass `check`" -- three carry a pre-Cdsync convention the checker cannot read. **ST0004's boundary was simply wrong, and its contract now says so.** ST0003's bar was that every work package reached a terminal state **on the record**, not that every one was built -- the wind-back dissolved three and hv parked a fourth. **Read `acceptance.md` before assuming something was skipped.**

## The release record

**0.1.0 is released.** Tag `v0.1.0` on `e54ebbc`, annotated; GitHub release published with `cdsync-0.1.0.tar.gz` (474,181 bytes, 140 entries). **Verified by downloading the published asset**, confirming its sha256 matched the local build byte for byte, extracting it and running it. `VERSION` stays `0.1.0` and is now a **released** version, so the next cut moves off it.

**The repository is public as of 6 August**, published from a single root commit. **The 135-commit development history was truncated and is retained privately at the Dropbox mirror** on `archive/pre-public-20260806`, with a bundle beside it. That mirror is the only copy. **Everything committed here is published on push.**

## Structural guards, cumulative

Each one exists because the thing it guards went wrong at least once.

- The front-page command table must list every command the dispatcher accepts.
- Every flag a command implements must be documented in its help file.
- The README's rule table must match `help/check.md`, its source.
- Every colour form in `CDSYNC_COLOUR_RE` must be named in `help/check.md`.
- The bootstrap inventory must be ordered by bytes, not by locale.
- No tracked file may carry an absolute home directory path.
- No test may hang on the install prompt.
- A release archive carries the tool and not how it is made, checked through `git archive` against the real `.gitattributes` rather than a restated list.
- Every acceptance contract in the repository, live or completed, must name tests that exist.
- The taxonomy's size is computed and stated nowhere in prose -- `brief`'s refusal and `doctor` must both report it, and the help files that once carried a stale figure must carry none.
- **The shipped spec library states no taxonomy-wide count either.** The guard above swept `bin/`, `lib/` and `help/`, and nothing asked what had chosen those three; `specs/` was never searched and was the copy that travelled inside every brief. `templates/claude_design/` is out of scope by ruling, being a delivery record.
- **Every dependency the spec library names must resolve in the taxonomy.** `check` catches a dangling `depends_on` in a drop; nothing looked at the library, which is how three sat in it from July.
- The brief must tell the supplier that `formats_required` is advisory. A ruling that never reaches the supplier changes nothing.

## Context for LLM

Start a session with `/in-session`. Read the canon first, then `intent/restart.md`. **`intent/whiteboard/cc/wip.md` is the one home for both the rulings and the watch-outs** -- read them before acting, not after.
