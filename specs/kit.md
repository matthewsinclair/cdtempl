---
asset: kit
name: The neutral kit
taxonomy: [20]
spec_version: 3
kit_version: 1
form: B
tier: 1
group: 4
audience: [developer]
root: true
inputs_missing:
  - "nothing — the kit is deliberately answerable without any venture facts"
depends_on:
  hard_facts: []
  hard_assets: []
  reciprocal: [colour-system, typography-system]
bundles: [product-set]
---
# The neutral kit — specification

## What it is

Taxonomy asset 20, design tokens. The single file set every other artefact
imports: a twelve-step greyscale ramp at exactly zero chroma, two font stacks, two
weights, one scale, radius 0, no shadow, and a list of prohibitions.

It is **not a starting palette**. It is a deliberately unfinished one, and a
venture's first design act is to replace it. The kit's job is to make that
replacement obvious and cheap, and to make forgetting to do it visible.

## The neutral ramp is a default, not a constraint

**Where the brief fixes a colour, the kit carries that colour.** Neutrality is what
the kit falls back to when nobody has decided yet — a venture that has already
decided its hue has performed the replacement this asset exists to invite, and the
kit's job is then to record the decision rather than to argue with it.

So `tokens.json` holds the decided value, `tokens.css` marks it `KEEP` rather than
`REPLACE`, and the ramp is built around it. Greyscale at zero chroma applies only
where `fixed` says nothing about colour.

This was learned the expensive way. A round arrived with a brand colour in `fixed`,
a strictly neutral kit built to the letter of the paragraph above, and that colour
used throughout the artefacts. Both halves were defensible alone and together they
were a contradiction: `cdsync check` rule 4 requires every colour literal in the drop
to appear in `kit/tokens.json`, so the drop blocked in six places over a colour the
venture had already decided.

Rule 4 is right and stays. The reading of neutrality was what needed fixing —
the alternative, artefacts staying greyscale until a `colour-system` is ordered,
means a venture cannot use its own colour for three rounds.

**A colour in `fixed` still does not license a palette.** Take the decided hue, and
leave everything derived from it — tints, shades, accents, semantic colours — to the
`colour-system` asset. If a derived value is unavoidable, it goes in the kit too, so
that the check can see it, and it is named in `RETURN.md` as a decision nobody asked
for.

## Where it lives, and why that is an exception

`kit/` sits at the **target root**, not under `assets/`. Every other asset is
`assets/<slug>/`; this one is not, because it is the one thing every other asset
imports and burying it a level down under the things that depend on it reads
backwards.

Named here as a deliberate exception rather than left to be discovered as an
inconsistency. It is the only one.

## Why the kit exists at all

Asking for restraint across fifty-one artefacts is asking someone to fight a
tendency, and tendencies win. One neutral kit that every template imports turns
"is this too charming" into a question about one file rather than a judgement call
across the whole suite.

The same reasoning governs the placeholder treatment and the prohibitions:
**remove the failure mode rather than detect it.** A rule that has to be
remembered on every artefact is a rule that will be forgotten on one.

## Files produced

| File | What it is |
|---|---|
| `kit/kit.md` | The kit written down: ramp, type, the two kinds of blank, blank-counting scope, the illustrative marker, the prohibitions |
| `kit/tokens.css` | Custom properties, every value marked `REPLACE` or `KEEP` |
| `kit/tokens.json` | The same values, parseable — the file `cdsync check` reads |

Form B: a structure with placeholder values, where the structure is the deliverable
and the values are meant to be replaced.

## Definition of done

1. **Chroma is exactly zero** across every colour value. Any tint — a warm white,
   a blue-black — is an aesthetic decision, and one made in the kit is inherited by
   every venture without anyone choosing it.
2. **Every value is marked `REPLACE` or `KEEP`.** REPLACE is a seam: the accent,
   the faces, radius, elevation. KEEP is structural: the ramp steps, the scale, the
   space steps, the floors.
3. **Colour names are numbers, never roles.** `--color-primary` is where taste
   re-enters, because naming something primary decides that it matters.
4. **`tokens.json` and `tokens.css` carry identical values.** `tokens.json` is what
   the colour check reads, so a value present in only one of them is a hole in the
   check rather than a formatting difference.
5. **Contrast pairings are stated**, not left to be worked out, against WCAG 2.2 AA.
6. **The two kinds of blank look different** — hatched slot for missing imagery,
   bracketed monospace for missing copy — because they fail differently.
7. **The prohibitions are present and complete.** Twelve of them, with the single
   stated exception for the placeholder hatch, which is a hard-edged repeating
   pattern rather than a colour transition.
8. **No webfont and no `<link>` to a font service.** A loaded typeface is a brand
   decision and would be inherited silently.

## What the kit is not

Not a design system, not a starting point for one, and not a statement of taste.
It is scaffolding with the seams put in the right places, so that what replaces it
lands where a venture's real decisions belong.

Where a prohibition forces a component into an unusual shape — radius 0 produces a
square radio button, the motion rule forbids a spinner — **the component must say
so in the artefact**, or the next venture inherits the workaround as a style.
