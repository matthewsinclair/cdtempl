---
verblock: "09 Aug 2026:v1.4: Matthew Sinclair - ST0003 closes 20/20 at library edition 4; every steel thread is Completed"
---

# Work In Progress

Project-wide snapshot, updated 9 August. The live per-session channel is `intent/whiteboard/cc/wip.md`; this is the settled version. **Orientation, canon and the live edges are in `intent/restart.md` and are not restated here.**

## Where the project stands

**Cdsync v1 is released and public.** **Ten commands** -- `new`, `init`, `brief`, `bootstrap`, `install`, `import`, `check`, `site`, `release`, plus `doctor`. **The bats suite is green end to end and prints its own count** -- a hand-copied test count in this file drifted within a day of being written, which is the standing counts ruling applying to one more number. Shellcheck silent at default severity. **CI success on hygiene, ubuntu-latest and macos-latest**, read per job. `README.md` and `LICENSE.md` (MIT). **Read the spec-library numbers from `cdsync doctor`, not from prose here.**

**The repository is public as of 6 August**, published from a single root commit. The 135-commit development history was truncated and retained privately at the Dropbox mirror on `archive/pre-public-20260806`, with a bundle beside it. **Everything committed here is published on push.**

**ST0003 closed 20/20 on 9 August, and the wind-back is why it could.** hv ruled the delivered projects delivered -- the loop does not run back to Claude Design for them; the tree is a record of what was asked for. That dissolved three work packages rather than executing them, hv parked a fourth, and the last live edge closed the same day. **The thread's bar was that every work package reached a terminal state on the record, not that every one was built** -- the alternative would have been this contract overruling the owner at a close.

**The day's builds**: `cdsync.json` at the design tree root for every project; `spec_version: unassigned` and ordering ahead of the library; the staleness advisory in `doctor` and `check` (shape (a) -- a warning, never blocking); and **the spec library at edition 4** -- three dangling dependencies repaired, every count out of library prose, `formats_required` written up as advisory in the library and in the brief the supplier reads. **A library edition bump restamps nothing**: a drop keeps the edition it was ordered against, and staleness is per asset via `spec_version`.

**Nothing is open.** What was carried forward, and the condition that would re-open each item, is in `intent/restart.md`.

**Six projects hold a design system tree.** matthewsinclair and geodica completed round one on 2 August. Of the original four from round three, **three are integrated and were already integrated before anyone checked** -- Gyre & Gymble, Baize and snorkeltoast, in three different idioms. **Lamplight is unchecked by design** -- integration is the application's business, and nothing here needs the answer. **hv is rolling both new design systems out in Laksa and fixing forward**; implementation is not this project's thread.

**0.1.0 is released.** Tag `v0.1.0` on `e54ebbc`, annotated; GitHub release published with `cdsync-0.1.0.tar.gz` (474,181 bytes, 140 entries). Verified by downloading the published asset, confirming its sha256 matched the local build byte for byte, extracting it and running it. `VERSION` stays `0.1.0` and is now a **released** version, so the next cut moves off it.

## Steel threads

| ID | Title | Status | Gate |
| -- | ----- | ------ | ---- |
| ST0001 | Harvest template v0 from the three Claude Design projects | Completed | 16/16 |
| ST0002 | Port four established projects to the Cdsync shape | Completed | 12/12 |
| ST0004 | Rename the tool to Cdsync | Completed | 11/11, plus a post-close note |
| ST0003 | Post-release 0.1.0 clean-up | Completed | 20/20, closed 9 Aug on a contract written at close from evidence |

Each close went through `intent st done`, which refuses while a contract is BLOCKED, so each had to earn its number. `intent st list` shows nothing by default -- use `--status Completed`.

**All three closed threads state a boundary and carry the remainder forward** rather than dropping it. ST0001's bar was never "all 52 slugs specified" -- the library grows one order at a time. ST0002's was never "all four pass `check`" -- three carry a pre-Cdsync convention the checker cannot read. **ST0004's boundary was simply wrong**, and its contract now says so. **Read `acceptance.md` in any of them before assuming something was skipped.**

**ST0003 held everything carried forward** -- eight work packages, most blocked on a ruling rather than on effort. Its contract stayed deliberately unwritten until the scope was real, because an empty contract reads as BLOCKED and that is the gate working; it was then written at close from evidence measured before the criteria were phrased. **All four threads state a boundary and carry their remainder forward**; ST0003's is in `intent/restart.md`, each item with the condition that would re-open it.

## The rename, finished 6 August

The tool was renamed to Cdsync. ST0004 closed 11/11 on a stated bar of **five repositories** and every criterion was satisfied as written. **The bar was wrong.** `Sites/gyreandgymble` and `Sites/snorkeltoast` also carried the name, and so did this repository's own gitignored `templates/_test/Acme/` -- where the stale filename was a live defect, because the tool resolves through `cdsync.json` now.

**Seven repositories carry the name today and all are at zero**, tracked, on disk and in filenames. Three on-disk occurrences remain deliberately: a dated backup, Laksa's `_build/` output, and base64 image data in a vendored dependency that matches only a case-insensitive probe.

**The one lesson worth carrying, and it is on the board rather than repeated here: a positive control validates the instrument, not the sampling frame.** Every control ST0004 ran was sound and the answer was still wrong.

**ST0004 stays closed.** The completion is a post-close note on its contract -- reopening would relitigate scope at a close, and a new thread would split the record.

## What the work packages found

**Not restated here.** They are all under `intent/st/COMPLETED/ST0003/WP/*/info.md`. WP-01's two defects in `release` itself are in `WP/01`. **WP-07's finding that its own premise was false -- in every project it could be checked against -- is in `WP/07`**. WP-05's as-built -- the tree-root `cdsync.json`, the `unassigned` lifecycle, the ordered-ahead brief -- is in `WP/05`. WP-06's dissolution and its two survivors are in `WP/06`. **WP-03's is in `WP/03`, and it names two inherited premises that were false**, one of which had been repeated in a source comment and a work package before anyone read the code it described. **The standing hazards they taught are on the board, in one copy** -- this file previously carried a second, which is the drift it keeps naming.

## Structural guards, cumulative

- The front-page command table must list every command the dispatcher accepts.
- Every flag a command implements must be documented in its help file.
- The README's rule table must match `help/check.md`, its source.
- Every colour form in `CDSYNC_COLOUR_RE` must be named in `help/check.md`.
- The bootstrap inventory must be ordered by bytes, not by locale.
- No tracked file may carry an absolute home directory path.
- No test may hang on the install prompt.
- A release archive carries the tool and not how it is made, checked through `git archive` against the real `.gitattributes` rather than a restated list.
- Every acceptance contract in the repository, live or completed, must name tests that exist.
- The taxonomy's size is computed and stated nowhere in prose. `brief`'s refusal and `doctor` must both report it, and the two help files that once carried a stale figure must carry no figure at all.
- **The shipped spec library states no taxonomy-wide count either.** The guard above searched `bin/`, `lib/` and `help/`, and nothing asked what had chosen those three -- so `specs/` kept shipping the wrong figure inside every brief for six weeks while the guard reported it settled. The frame is widened; `templates/claude_design/` is out of scope by ruling, being a delivery record.
- **Every dependency the spec library names must resolve in the taxonomy.** `check` catches a dangling `depends_on` in a drop; nothing looked at the library, which is how three sat in it from July.
- The brief must tell the supplier that `formats_required` is advisory. A ruling that never reaches the supplier changes nothing.

## Context for LLM

Start a session with `/in-session`. Read the canon first, then `intent/restart.md`, then the thread you are picking up. `intent/whiteboard/cc/wip.md` is the live board and is the one home for both the rulings and the watch-outs.
