---
asset: print-collateral
name: Print collateral
taxonomy: [52]
spec_version: 1
kit_version: 1
form: C
tier: 2
group: 6
audience: [customer, printer]
inputs_missing:
  - "which pieces, at which sizes, and what each one is for"
  - "the single action each piece exists to produce"
  - "where each is distributed — a letterbox, a counter, a wall, a hand"
  - "the printer's requirements, or a licence to assume house defaults"
  - "whether any content is variable — a rate, a number, a date — and where it is read from"
depends_on:
  hard_facts: [conversion-action]
  hard_assets: [brand-guidelines, logo-suite, colour-system, typography-system]
  reciprocal: []
bundles: []
---
# Print collateral — specification

## Status: admitted, 30 July 2026

**Taxonomy 52, Group 6 — customer-facing surfaces.** Admitted by hv.

It was found rather than designed: the word "print" appeared nowhere in the taxonomy's
51 entries, and **two ventures needed it independently** — one delivered fliers and a
postcard, the other five in-store pieces — with neither knowing about the other. Two
independent discoveries of the same gap is the strongest evidence a taxonomy slot is
missing, and it is worth more than the reasoning that failed to predict it.

**The number is 52 and not 42, and that is deliberate.** Group 6 ends at 41, so slotting
it in sequence would renumber 42 through 51 — ten published identifiers, every one of
them already cited in delivered drops. Renumbering a live identifier set is exactly what
cost a full export cycle on Lamplight in July 2026. **The number is identity; the table
position carries the grouping.** Do not "tidy" this into sequence.

## What it is

The physical pieces a venture puts into someone's hand, letterbox, or field of view. It is
one asset rather than one per piece, because the pieces share a definition of done —
printed, at size, on stock, legible at the distance they are read from — and each is
meaningless alone.

## One job per sheet

**A sheet does one thing.** One offer, one action, one route. Everything else belongs
somewhere with more room.

This is the failure that makes print collateral worthless: a leaflet listing five business
lines gets read as junk and binned, because a reader deciding whether to keep a piece of
paper gives it about a second. A piece that has not made its single case in that second has
not made it.

## The standard shape

| Part | Carries |
|---|---|
| The set | Each piece, its size, and the job it does |
| Trim and bleed | Margins per size, bleed distance, what the bleed extends |
| Safety | Clearance for anything that must not be trimmed off |
| Type minimums | Body and call-to-action sizes, per sheet size |
| Colour space | What is supplied to the printer, and in what profile |
| Variable content | Anything read at render rather than set in the file |

**Margins scale with the sheet.** A margin that is generous on A6 is mean on A4. State
them per size rather than once.

**Bleed extends a flat ground, never a photograph.** A photograph extended into the bleed
is a photograph cropped unpredictably by the guillotine. Extend a solid.

**Type minimums are per sheet size, and the call to action is larger than the body.** The
number someone has to read across a room is not the same size as the number they read in
their hand.

## Variable content is a staleness hazard

Where a rate, a phone number, a date or an offer is read at render rather than typed into
the file, **say so and say where it comes from**. Then the rule is: confirm the source is
current before anything goes to a printer. Print is the one medium with no recall.

## On exports, and why empty can be correct

**A stale PDF is worse than no PDF, because it is the one that gets emailed.** If the
canonical source can be re-rendered on demand, an empty `exports/` is a legitimate and
deliberate state — but it must be *declared* as deliberate in `RETURN.md` or in a note,
or the next person reads it as an omission and generates one.

Where a PDF does ship, it carries the date it was rendered and the version of the source it
came from. An undated export is the one nobody can tell is stale.

## Definition of done

- Every piece states its size, its distribution point, and its single action.
- Margins, bleed and safety are stated **per size**.
- Type minimums are stated per size, with the call to action distinguished.
- Any variable content names its source and carries the check-before-print rule.
- Exports are either present and dated, or absent and declared absent.
- Every colour appears in `kit/tokens.json`, and anything supplied to a printer states its
  colour space.

## What the brief must carry

- Which pieces, at which sizes, and what each is for.
- The single action per piece.
- Where each is distributed.
- Whether any content is variable, and its source of truth.

## Notes

**Why `tier: 2` rather than 1.** A venture with no physical presence needs none of this,
so it is not foundational. A venture with a counter, a letterbox route or a stand needs it
before almost anything else, which is why it is not tier 3 either.

**Why no `reciprocal`.** Print collateral consumes the identity and the offer; nothing
upstream changes because of it. Where a venture's go-to-market plan drives which pieces
exist, that relationship belongs on the plan.
