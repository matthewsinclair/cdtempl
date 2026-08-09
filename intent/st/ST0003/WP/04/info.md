---
verblock: "02 Aug 2026:v0.2: matts - Filled from the ST0001/ST0002 close-out carry-forward"
wp_id: WP-04
title: "Transport, and the conversion round behind it"
scope: Medium
status: Done
---

# WP-04: Transport, and the conversion round behind it

## Objective

Several finished documents are **written and unsent**. Claude Design cannot read this repository -- not by git, not by mount -- so every input arrives as an upload from hv, and **a document nobody has sent has had no effect at all.**

This WP is that queue, plus the round that unblocks once the three port briefs land.

## What is waiting to be sent

| Document | Where | What it does |
| -------- | ----- | ------------ |
| `port-brief-lamplight.md` | ST0002 (COMPLETED) | Converts Lamplight into the checkable shape |
| `port-brief-baize.md` | ST0002 (COMPLETED) | Same, for Baize |
| `port-brief-snorkeltoast.md` | ST0002 (COMPLETED) | Same, for snorkeltoast |
| Acme round two | `templates/_test/Acme/design/brief.md` | The next round of the neutral test venture |
| `round-5-answer.md` | ST0001 (COMPLETED) | Answers round five's findings |
| Two protocol documents | `intent/docs/` | `claude-design-contract.md`, `receiving-a-design-system.md` -- both self-contained |

G&G needs no port brief. It is already Cdsync-shaped and checks clean.

## The round that follows

Three of the six trees currently refuse `check` with `0 assets checked`, because their tokens sit outside `kit/` and their assets are not `assets/<slug>/spec.md`. **That is the tool being honest about a tree it cannot read**, not a defect in the port -- ST0002 delivered the record, which was its bar.

Converting them is **its own round, by the 31 July ruling**: a conversion arrives with its own brief and is never ordered implicitly by a document describing a shape. The briefs exist for exactly that reason.

After the conversion lands: **clear the vestigial paths.** That sweep's precondition was "after each export is reviewed", which is satisfied.

## Deliverables

- The six documents sent.
- Three conversions installed and committed, each with its removals audited by `git status` rather than by the install plan.
- Vestigial paths cleared.
- `check` re-run across all six trees, results recorded as measured.

## Dependencies

**Blocked on hv for transport, and only on that.** A thread cannot be gated on transport it does not control -- which is exactly why ST0002 closed without this rather than waiting.

## Notes

- **Use `install`, not `import`, for an as-is export.** Opposite semantics; choosing wrong is the most destructive mistake in the tool.
- **Read the dry run first**, and remember the top-level plan is not the removal audit.
- Round three's precedent: every deletion matched a sentence in that project's own `RETURN.md` -- Lamplight 42, Baize 8, snorkeltoast 4 plus six renames, G&G 0. Expect to be able to say the same here.

## Closed 9 August, by the wind-back ruling

**hv ruled the delivered projects delivered**: no more syncing from here, the tree a record of what was asked for, further rounds rare and as-needed. The queue this WP *was* dissolves under that ruling. **The three port briefs and the round-5 answer die unsent** -- they existed to make the delivered trees checkable for future rounds that will not happen. The two protocol documents are simply published documents in `intent/docs/`, read when the next venture spins up. **Acme is Cdsync's own test fixture**, not a delivered project: its round two stays available as test apparatus, and its brief regenerated on 9 August against library v3 when `cdsync.json` moved to its tree root. Nothing was transported, nothing will be, and the conversion round and vestigial-path sweep die with the transport.
