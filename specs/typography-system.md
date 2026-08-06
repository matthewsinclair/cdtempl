---
asset: typography-system
name: Typography system
taxonomy: [14]
spec_version: 2
kit_version: 1
form: B
tier: 3
group: 3
audience: [developer, team]
inputs_missing:
  - "typeface licences, and whether they cover web, print, embedding and app use"
  - "the longest thing anyone will actually read, and on what surface"
  - "whether a display or lettering face is wanted beside the reading face"
  - "the density requirement — a dense operator surface and a reading surface are different systems"
  - "the languages and scripts that must be supported"
depends_on:
  hard_facts: [typeface-licences]
  hard_assets: []
  reciprocal: [colour-system, brand-guidelines]
bundles: [identity-set, rebrand-set]
---
# Typography system — specification

## What it is

The set of type decisions made once so that no page has to make them again: which faces,
at what sizes, with what spacing, for what job. Like the colour system it is **a system of
roles rather than a list of values** — the output is that a designer knows which style to
reach for and a developer never invents a size.

The test of a type system is not how it looks on a specimen sheet. It is whether the
longest, dullest, densest thing in the product is comfortable to read.

## The standard shape

| Part | Carries |
|---|---|
| Faces | Each face, its licence coverage, and the job it does |
| Scale | The sizes, as an ordered ramp with named steps |
| Roles | Display, body, keyline, caption, code, and any lettering treatment |
| Line and measure | Line height per role, and the measure each role is set to |
| Weights | Which weights are licensed, loaded, and permitted |

**The scale is a ramp, and it is finite.** A system with an open set of sizes is not a
system. Name steps by position so a revision does not require renaming.

**Measure is part of the system, not a page-level choice.** A body role with no stated
measure will be set at whatever width its container happens to be, which is how a 140-character
line reaches production.

## Density is a real axis, and it is usually forgotten

One of the ventures measured against this spec runs two surfaces with genuinely different
density requirements — a reading surface consumed at arm's length, and a dense operator
console used behind a bar at speed. Another runs the same split between a reading light and
a paper-dense authoring tool.

**Density is not a smaller type scale.** It is a different relationship between size, line
height and spacing, and deriving the dense variant by multiplying the comfortable one by a
constant produces a surface that is cramped in the wrong places. If the venture has two
density requirements, say so, and set the second rather than scaling it.

**But density does not fork the scale.** As with colour modes: what varies is which step a
role resolves to, not the steps themselves. Two scales is two type systems.

## Formats produced

Values belong in the **kit** — `kit/tokens.css` and `kit/tokens.json`. This asset produces
the documentation: the faces and their licences, the scale rendered at real sizes, each role
shown at its real measure, and the weights that are actually loaded.

**Render the specimen at real size against real copy.** A scale shown as a list of numbers,
or set in lorem ipsum, hides the only failure that matters — that the body role is
uncomfortable in the thing people actually read.

## Template form

A page per concern works well: a page for the scale, one per role family (display, body,
keyline, lettering), one for the faces and licences. That is what the venture that had
already decomposed its system did, and each page is separately revisable.

## Definition of done

- Every role resolves to a named step in the scale. A role with a hardcoded size is the
  defect this asset exists to prevent.
- Every face carries its **licence coverage** stated per medium — web, print, embedding,
  app. A face in use beyond its licence is a legal problem, not a design one.
- Every weight shown is a weight actually licensed and loaded. A specimen showing a weight
  the product cannot serve is a promise that breaks at build time.
- Line height and measure are stated for every reading role.
- The body role is shown at real size against real copy, not against filler.
- Every size and family value appears in `kit/tokens.json`.

## What the brief must carry

- The licences, per medium. This is the one input that cannot be inferred or designed around.
- The longest thing anyone will read, and the surface they read it on.
- Whether there is a second density requirement, and what it is for.
- Whether a display or lettering face is wanted, and where it may not be used.

## Notes

**Why `audience: [internal]`.** The taxonomy marks this internal, and that is right: the
public sees the result, not the system. Where a venture publishes its type system as part of
a public brand guideline, that is `brand-guidelines` doing the publishing and this asset
feeding it.

**Reciprocal with colour.** Contrast targets constrain weight and size — a thin weight that
passes on white fails on a mid surface. Setting either without the other guarantees one gets
re-set.
