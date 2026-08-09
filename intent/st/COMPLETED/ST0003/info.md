---
verblock: "02 Aug 2026:v0.2: matts - Filled from the ST0001/ST0002 close-out carry-forward"
intent_version: 2.18.0
status: Completed
slug: post-release-0-1-0-clean-up
created: 20260802
completed: 2026-08-09T12:20:51Z
---

# ST0003: Post-release 0.1.0 clean-up

## Objective

Hold everything that ST0001 and ST0002 carried forward when they closed on 2 August, plus the questions the first real cold round trip raised, so that **none of it lives only in a fold document.**

This thread is deliberately a **holding pen with structure**, not a plan. Its work packages are independent by design: each can be taken alone, in any order, and most of them are waiting on a ruling rather than on effort.

## Context

ST0001 and ST0002 both closed at 2 August on contracts written from the as-built, each of which **states its boundary explicitly and lists what falls outside it.** That was the honest way to close them -- neither had been abandoned, and neither had done everything anyone might have wanted.

What fell outside was real work, and closing the threads left it with nowhere to live. Recording it in `intent/wip.md` was not enough: **a fold document is a snapshot, and a snapshot is not a commitment.**

Two things are worth knowing before picking anything up.

**Most of this is blocked on a ruling, not on effort.** WP-02, WP-05 and WP-06 are all questions with their evidence already gathered, waiting on hv. They are cheap to answer and cheap to leave; what they are not is cheap to guess at, which is why they were not guessed at when they arose.

**The naming stopped being aspirational on 6 August.** WP-01 closed 8/8: `v0.1.0` is tagged, packaged, pushed and published, so this really is post-release clean-up now. Running `cdsync release` for real found two defects in it, neither visible from reading the code -- see WP-01's `info.md`.

**A work package's stated premise is not evidence.** WP-07 opened on "none has been built against" and that was false for the first project it named. **Check the world before recording what it is** -- and if a premise turns out wrong, correct it in the WP rather than working around it.

## The work packages

| WP | Title | State |
| -- | ----- | ----- |
| WP-01 | Cut the 0.1.0 release | **Done 6 Aug, 8/8** |
| WP-02 | Rule 4 -- two rulings and what follows | **Parked by hv, 9 Aug.** Evidence and recommendations on record |
| WP-03 | Grow the spec library, and repair its text | **Done 9 Aug, 7/7** -- library edition 4; two inherited premises found false |
| WP-04 | Transport, and the conversion round behind it | **Done 9 Aug** -- dissolved by the wind-back; nothing was or will be sent |
| WP-05 | Make scope durable: `cdsync.json` and `spec_version` | **Done 9 Aug** -- both ruled and built the same day |
| WP-06 | Settle round three's outstanding rulings | **Done 9 Aug** -- dissolved to two survivors; the record stands as delivered |
| WP-07 | Integrate the original four | **Done 9 Aug** -- closed on the finding; Lamplight unchecked by design |
| WP-08 | Housekeeping and small gaps | **Done 9 Aug** -- all six items done or declined on the record; the staleness advisory built as shape (a) |

**The 8 August state -- nothing unblocked, everything on hv -- lasted one day.** On 9 August hv ruled the wind-back (the delivered projects are delivered; the loop does not run back to Claude Design for them), ruled `cdsync.json`'s home, `spec_version`, the staleness advisory and `formats_required`, and parked WP-02. Six WPs closed that day, WP-03 the same evening, and **this thread closed 20/20 with it.**

**The bar was that every work package reached a terminal state on the record, not that every one was built.** Three were dissolved by the wind-back rather than executed and hv parked a fourth, so a criterion demanding they be built would have been the contract overruling the owner at a close. `acceptance.md` states that boundary; `intent/restart.md` carries the remainder forward with the condition that would re-open each item.

## Acceptance

Acceptance Criteria and Acceptance Tests for this steel thread live in `acceptance.md` (the single source of truth). Do not restate ACs here -- see that file for the ratified completeness boundary and live status.

**The contract is deliberately unwritten while this thread is Not Started.** `intent st done` refuses to close a thread whose contract is BLOCKED, and an empty contract counts as BLOCKED -- which is the gate working. Write the ACs when the scope is real, not now, and **do not write ACs to match what happens to have been done.** Shrinking scope needs the owner.

## Related Steel Threads

- **ST0001** (Completed 2026-08-02) -- the generic template suite and the four specifications. Its `acceptance.md` lists what it carried forward into here.
- **ST0002** (Completed 2026-08-02) -- porting four established projects. Same.

Both are at `intent/st/COMPLETED/`. `intent st list` shows nothing by default; use `--status Completed`.

## Context for LLM

**Read `intent/docs/design-system-lifecycle.md` first.** It is canon and outranks every document in this thread.

Then read the `## Decisions` and `## Watch-outs` sections of `intent/whiteboard/cc/wip.md`. Several items here look like small fixes and are not -- `pattern-library` cannot be written without re-pointing the library text that names it as unwritten, and the three library-text inconsistencies cannot be repaired individually because editing library text changes what its `spec_version` means.

**Nothing in this thread should be started by guessing at a ruling.** If a WP says it is blocked on hv, it is blocked on hv.
