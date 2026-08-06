---
asset: imagery-direction
name: Imagery & illustration direction
taxonomy: [16]
spec_version: 1
kit_version: 1
form: C
tier: 3
group: 3
audience: [developer, printer, public]
inputs_missing:
  - "whether imagery is photographed, illustrated, stock, generated, or a mix"
  - "who owns or licenses what already exists, and on what terms"
  - "whether people appear, and if so who they are meant to represent"
  - "the budget and cadence for producing new images, which decides whether the direction is achievable"
depends_on:
  hard_facts: []
  hard_assets: [brand-guidelines]
  reciprocal: [colour-system]
bundles: []
---
# Imagery & illustration direction — specification

## What it is

**The rules that decide whether a picture belongs, before anyone has taken it.** Not a
mood board and not a folder of examples — a direction is what lets someone commission,
shoot, buy or reject an image the direction has never seen.

A venture accumulates images faster than any other asset class, from more sources, with
less deliberation. Without a direction the set drifts within a quarter and the drift is
invisible until someone puts twenty of them on one page.

## The standard shape

| Part | Carries |
|---|---|
| The subject | What is depicted, and what never is |
| Treatment | Colour, grade, contrast, grain, the wash the whole set shares |
| Composition | Crop, subject placement, negative space, where type is expected to sit |
| People | Whether they appear, who they represent, how they are framed |
| Sourcing | Photographed, illustrated, stock, generated — and the rules per source |
| Rejects | Real images that are *close but wrong*, each with the reason |

## The rejects are the deliverable

**A direction proves itself on the near misses.** Images that are obviously wrong teach
nobody; the useful examples are the ones a reasonable person would have accepted, with
the specific reason they do not belong. A direction without rejects will be interpreted
generously by everyone who uses it, in different directions.

**Name the treatment mechanically wherever possible.** "Warm and airy" is a mood;
a stated grade, a contrast range, a colour cast referred to the colour system's tokens
is a rule. Where a mechanical statement is not possible, say so rather than substituting
an adjective.

## Definition of done

- Subject rules state what is never depicted, not only what is
- Treatment is expressed against `kit/tokens.json` where it touches colour
- **At least three rejects**, each a plausible image with a stated reason
- The people question is answered explicitly, including "no people" if that is the answer
- Sourcing rules cover every source actually in use, including generated imagery and
  its disclosure

## What the brief must carry

What already exists and who owns it. Imagery is the asset most likely to arrive with
a licensing problem attached, and a direction that cannot be executed because the
existing set cannot be relicensed is a direction nobody will follow.

Also the production budget and cadence. A direction requiring commissioned photography
from a venture that will never commission any is a specification for a set that will
be quietly replaced with stock.

## Notes

Depends hard on `brand-guidelines` because the imagery has to sit inside an identity
that already exists. Reciprocal with `colour-system`: the grade and the palette
constrain each other, and a set graded outside the palette is the most common way a
carefully built colour system stops being true.
