---
asset: logo-suite
name: Logo & mark suite
taxonomy: [12]
spec_version: 1
kit_version: 1
form: C
tier: 3
group: 3
audience: [public]
inputs_missing:
  - "whether a mark already exists, in what formats, and who owns it"
  - "the smallest place it will ever appear — a favicon, an avatar, a stitched label"
  - "whether the venture has sub-brands or divisions the mark must decompose into"
  - "whether it must work in one colour, and whether that includes reversed out"
  - "any registered or trademarked form that constrains what may change"
depends_on:
  hard_facts: [mark-exists]
  hard_assets: []
  reciprocal: [colour-system, brand-guidelines]
bundles: [identity-set, rebrand-set]
---
# Logo & mark suite — specification

## What it is

The mark, every form of it that ships, and the rules that stop it being misused. The
suite is not "the logo file" — it is the master mark, its variants, the sizes and
grounds each is cleared for, and the prohibitions.

**The rules are the deliverable as much as the files are.** A mark handed over as a
folder of PNGs will be stretched, tinted, shadowed and set on a photograph within a
month, and every one of those is a decision nobody made deliberately.

## The standard shape

| Part | Carries |
|---|---|
| Master mark | The primary form, and where it is mandatory |
| Variants | Sub-marks, single-colour, reversed, and what each is *for* |
| Minimum size | Stated for screen **and** print, with the reason |
| Clear space | Defined relative to a feature of the mark, never as an absolute |
| Grounds | Which backgrounds are permitted, and which are forbidden |
| Prohibitions | The list of things that will otherwise happen |

**Minimum size needs a reason attached.** "Never below 48px on screen or 12mm in print"
is followed; "use at a reasonable size" is not. State what breaks — the fine detail that
turns to mud, the counter that fills in — because the reason survives a redraw and the
number may not.

**Clear space is relative, not absolute.** Expressed as a feature of the mark itself —
the width of one element, the height of the counter — it scales correctly at every size.
Expressed in pixels it is wrong everywhere except the size it was measured at.

**Prohibitions are the load-bearing half.** Outline, drop shadow, gradient ground,
placement over a busy region of a photograph, mixing two sub-marks in one lockup, tilt
as a default. Each of these is something that will be done unless it is named.

## The render-construct trap

A mark recoloured on screen by a CSS mask, a filter, a blend mode or a currentColor fill
is **a construct that renders and then vanishes**. It exports from a PDF as nothing, or
as a black rectangle, and the failure appears only at the printer.

So: **the print set is its own set of files.** If any on-screen variant is produced by a
technique rather than by a file, say so explicitly and supply the flattened equivalent.
This is the single most expensive failure in this asset because it is invisible until the
job is at the printer.

## Formats produced

Vector master, and raster at the sizes actually used. A vector that exists only in one
colour is a partial delivery and should say so rather than imply completeness.

Favicon and avatar forms are usually **not** the master mark reduced — a mark that
decomposes should supply a single element in a filled shape instead. Reducing a detailed
mark to 32px produces a smudge that represents the venture badly in the place it appears
most often.

## Definition of done

- Every variant states what it is **for**, not merely that it exists.
- Minimum size is stated for screen and print, each with its reason.
- Clear space is relative to the mark.
- The prohibition list exists and is specific.
- Any on-screen variant produced by a render technique has a flattened file beside it.
- The smallest real use — favicon, avatar — is solved deliberately rather than by scaling.
- Every colour the mark uses appears in `kit/tokens.json`.

## What the brief must carry

- Whether a mark exists and who owns it. This is the one fact that cannot be designed around.
- The smallest place it will appear.
- Whether one-colour and reversed forms are required.
- Whether sub-brands exist.

## Notes

**On declaring `status: partial`.** This asset partials honestly more often than most: a
raster set complete for every current use, with a vector master that exists only in black,
is a real and common state. Saying so — and naming the three files a full handover would
want next — is more useful than a `complete` that is not.
