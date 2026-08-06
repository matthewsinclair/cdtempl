---
verblock: "02 Aug 2026:v0.2: matts - Filled from the ST0001/ST0002 close-out carry-forward"
intent_version: 2.18.0
status: Not Started
slug: post-release-0-1-0-clean-up
created: 20260802
completed:
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

**The naming is aspirational.** Nothing has been released. `VERSION` is `0.1.0` and `cdsync release` has never been run for real -- WP-01 is that act, and the thread is named for the state it will put the project in rather than the state it is in now.

## The work packages

| WP | Title | Blocked on |
| -- | ----- | ---------- |
| WP-01 | Cut the 0.1.0 release | **Nothing** |
| WP-02 | Rule 4 -- two rulings and what follows | hv |
| WP-03 | Grow the spec library, and repair its text | Partly WP-05 |
| WP-04 | Transport, and the conversion round behind it | **hv transport** |
| WP-05 | Make scope durable: `cdsync.json` and `spec_version` | hv |
| WP-06 | Settle round three's outstanding rulings | hv |
| WP-07 | Integrate the original four | **Nothing**, except Lamplight on WP-06 |
| WP-08 | Housekeeping and small gaps | Nothing |

**Three of the eight are unblocked right now**: WP-01, WP-07 and WP-08.

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
