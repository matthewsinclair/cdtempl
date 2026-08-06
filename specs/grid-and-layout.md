---
asset: grid-and-layout
name: Grid, layout & responsive spec
taxonomy: [21]
spec_version: 2
kit_version: 1
form: B
tier: 2
group: 4
audience: [developer]
inputs_missing:
  - "the real surfaces — a phone held one-handed and a console behind a bar are different problems"
  - "the narrowest and widest viewport that must be supported properly, not merely not break"
  - "whether any surface has a density requirement distinct from the others"
  - "whether the product is read, operated, or both"
  - "the minimum hit target the venture is committing to"
depends_on:
  hard_facts: [density-requirement]
  hard_assets: [typography-system]
  reciprocal: [component-library]
bundles: [product-set]
---
# Grid, layout & responsive spec — specification

## What it is

The spatial system: the space scale, the grid, the breakpoints, and the rules for how
layout changes across them. Every component sits on it, which is why it comes first —
`component-library` declares this asset as a hard dependency, and components built before
the space scale exists encode their own spacing and have to be redone.

**It is first in Tier 2 for that reason.** Nothing else in the design system group can be
built correctly without it.

## The standard shape

| Part | Carries |
|---|---|
| Space scale | An ordered ramp, named by position, with the base unit stated |
| Radius scale | The same, and its relationship to the space scale |
| Grid | Columns, gutters and margins, per breakpoint |
| Breakpoints | Where layout changes, and **why** it changes there |
| Hit targets | The minimum, and where it is enforced |
| Containers | Maximum measures for readable content |

**The base unit is a decision, and it must be stated.** A 4px base and an 8px base produce
different systems; a system with no stated base produces arbitrary values that look
approximately right and never align.

**Breakpoints are chosen by content, not by device.** A breakpoint set at a device width
is obsolete when the device is, and it will not be where the layout actually breaks. Set
them where the content stops working and say what stops working there.

## Space, radius and targets do not fork per mode

Three real ventures were measured against this spec. Two run two visual modes each — a
dark reading surface and a paper working surface — and **both keep the entire spatial
system shared across modes**. Only colour resolves differently.

That is the rule: **a mode changes what things look like, never where they are.** A system
where the dark mode has different spacing is two design systems sharing a name, and every
component then needs building twice.

The same applies to density. A dense operator surface and a comfortable reading surface may
resolve a role to *different steps on the scale* — they do not get different scales.

## Density is a real axis

Where a venture runs both a consumption surface and an operational one, they have genuinely
different spatial requirements: a console used at speed behind a counter needs more
information per screen than a page read at arm's length.

**Do not derive the dense variant by multiplying.** Scaling a comfortable system by a
constant produces something cramped in the wrong places — hit targets shrink below the
minimum while whitespace that was doing real work disappears. Set the dense variant, then
express it as which step each role resolves to.

## Hit targets are a floor, not a guideline

State the minimum and state where it is enforced. This is the rule most often stated and
least often checked, and it is the one that fails on the surface that matters most — a
phone, one-handed, in poor light, by someone in a hurry.

A target smaller than the minimum is a defect even when the visual element is smaller: the
*target* may extend beyond the visible control.

## Formats produced

The values belong in the **kit** — `kit/tokens.css` and `kit/tokens.json`. This asset
produces the documentation: the scale rendered, the grid drawn at each breakpoint, the
behaviour at each transition shown rather than described, and the hit-target rule with its
enforcement point.

**Show the breakpoint transitions, do not list them.** A table of breakpoints does not
reveal that a three-column grid becomes unreadable at the second one; a rendering does.

## Definition of done

- The base unit is stated, and every step on the space and radius scales derives from it.
- Breakpoints are justified by content, with the failure at each one named.
- The grid is specified per breakpoint — columns, gutters, margins.
- The minimum hit target is stated **and** its enforcement point named.
- Container measures are stated for readable content.
- Where modes exist, the spec states explicitly that the spatial system is shared.
- Where a density variant exists, it is set rather than derived, and expressed as role
  resolution.
- Every value appears in `kit/tokens.json`.

## What the brief must carry

- The real surfaces, described as situations rather than device names.
- The narrowest and widest viewport that must work properly.
- Whether there is a second density requirement.
- The hit-target commitment.

## Notes

**Why `form: B`.** Like the colour and typography systems, this is a structure: a set of
resolved decisions plus the document explaining them. The rendering belongs to the design
system index.

**Reciprocal with the component library.** Components are the first real test of a spatial
system, and building them always reveals a step the scale is missing. Declaring the
relationship reciprocal is honest about that; declaring it one-directional pretends the
scale can be finished before anything sits on it.
