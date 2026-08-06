---
verblock: "02 Aug 2026:v0.2: matts - Filled from the ST0001/ST0002 close-out carry-forward"
wp_id: WP-03
title: "Grow the spec library, and repair its text"
scope: Large
status: Not Started
---

# WP-03: Grow the spec library, and repair its text

## Objective

**25 of 52 taxonomy slugs have no spec.** That is not debt from ST0001 -- the ratified model is that the specs are a library and a brief is an order against it, so a spec gets written when an order needs one. This WP is where those orders get served.

It also carries three known inconsistencies in library *text* that were deliberately left alone, and the reason they were left alone is the reason they need doing together rather than piecemeal.

## The blocked one, and why it is blocked rather than queued

**`pattern-library` cannot simply be written.** `specs/library.md` names it as the live exemplar of a slug that is *real, in the taxonomy, and unwritten*, and `test/cdsync.bats` pins the same invariant. **Writing the spec makes that library text false and turns the test red.**

So `pattern-library` is a two-part job: write the spec, and simultaneously re-point the exemplar and its test at another genuinely-unwritten slug. Doing the first without the second breaks the library's own description of itself.

## The three text inconsistencies, left alone deliberately

**Do not fix these individually.** Editing library text silently changes what its `spec_version` means, so every one of them needs a `spec_library_version` bump and a decision about what that does to already-stamped drops.

- `specs/kit.md` says **"fifty-one artefacts"** against a 52-slug taxonomy.
- `specs/library.md` says **"32 of the 50"**, where the truth is 27 of 52.
- The `positioning` and `pricing` entries disagree with each other in a way recorded on the board.

## Deliverables

- Specs for the slugs that orders actually need, written when needed rather than in bulk.
- `pattern-library` written **and** the exemplar re-pointed, in one change, with the test updated to match.
- The three text inconsistencies repaired together, behind a `spec_library_version` bump.
- A decision on what a library-version bump means for drops already stamped against the old one. **`spec_version` is the library's stamp, not a per-drop counter** -- so this is a real question, not bookkeeping.

## Dependencies

Depends on WP-05 for the ordering mechanism if scope moves to `cdsync.json`. Otherwise independent.

## Notes

`cdsync doctor` prints spec, taxonomy and bundle counts. **Read the counts from it rather than from any document**, including this one -- a hand-maintained count in a doc has drifted more than once in this project, twice inside a warning about drifting counts.
