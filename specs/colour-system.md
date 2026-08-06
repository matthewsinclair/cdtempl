---
asset: colour-system
name: Colour system
taxonomy: [13]
spec_version: 2
kit_version: 1
form: B
tier: 3
group: 3
audience: [developer, team, public]
inputs_missing:
  - "whether the venture runs one mode or more than one, and what each is for"
  - "the surface each mode is read on — a phone in a dim room and a laptop behind a bar are different problems"
  - "an accessibility target, as a level and not as an aspiration"
  - "whether the mark's colours are fixed, or may be drawn from the palette"
  - "any colour that is legally or contractually constrained — a licensor's, a partner's"
depends_on:
  hard_facts: [mark-exists]
  hard_assets: [logo-suite]
  reciprocal: [typography-system, brand-guidelines]
bundles: [identity-set, rebrand-set]
---
# Colour system — specification

## What it is

The set of colour decisions a venture makes once, so that nothing downstream has to make
them again. It is a **system of roles, not a list of values**: the useful output is that a
designer knows which colour to reach for, and a developer never picks one.

A palette is what this looks like when nobody has done the work. A palette answers "what
are our colours". A colour system answers "what is this colour *for*, and what happens to
it when the surface changes".

## Modes are first-class, not a later addition

**Two of the three real ventures measured against this spec shipped two modes**, and both
treated the pair as one system rather than two palettes:

- One ran a dark reading light for consumption and a paper-dense working light for
  authoring tools.
- One ran a dark room lit by a hard cone of light and a paper daylight surface for staff
  behind a bar.
- The third ran a single bright mode with three signature hues and an ink ramp.

So a colour system that assumes one mode is wrong more often than it is right, and one that
treats a second mode as a later inversion of the first produces a second-class surface.
Decide the number of modes at the start and say what each is *for*. "Dark mode" is not a
purpose; "read in a dim pub, at arm's length, one-handed" is.

**What is shared across modes must stay shared.** Type scale, spacing, radius, motion and
hit targets are not colour and do not fork per mode. Only the colour roles resolve
differently. A system where a mode changes the type scale is two design systems wearing one
name.

## The standard shape

| Part | Carries |
|---|---|
| Ramps | Each hue as an ordered scale, with steps named by position rather than by feeling |
| Semantic roles | `surface`, `text`, `border`, and the states: success, warning, danger, info |
| Signature colours | The one to three that make the venture recognisable, and where they may not be used |
| Mode resolution | For each mode, what each semantic role resolves to |
| Contrast record | Measured pairs, not claimed ones |

**Name steps by position, not by feeling.** `blue-500` survives a palette revision;
`blue-primary` becomes a lie the first time the primary changes and nobody renames the
token. A ramp with named-by-feeling steps has to be re-authored to be changed.

**Signature colours need a prohibition, not just a permission.** The most common failure is
a signature hue used for body text or for a large surface, where it stops being signature
and becomes noise. Say where it may not go.

## Formats produced

The values themselves belong in the **kit**, not in this asset — `kit/tokens.css` and
`kit/tokens.json`, which is the file the leak guard reads. This asset produces the
*documentation* of the system: the ramps rendered, the roles named, the modes shown side by
side, and the contrast table.

A colour system delivered only as a token file is not done. A token file with no document
is a set of values nobody can reason about; the document is where the "what is this for"
lives.

## Template form

One page per concern reads better than one page for the whole system: a page per ramp, a
page for the semantic roles, a page for the signature set. That decomposition is not
required, but it is what the venture that had already decomposed it got right — each page
is separately revisable, and a ramp revision does not touch the semantic page.

## Definition of done

- Every semantic role resolves in **every** declared mode. A role that resolves in one mode
  and not another is the defect this asset exists to prevent.
- Every ramp step appears in `kit/tokens.json`. A colour in the documentation that is not in
  the kit will be reported by the leak guard, and it is right to report it.
- Contrast is **measured and recorded**, as pairs and numbers, against a stated level. An
  unmeasured claim of accessibility is worse than no claim.
- The signature colours carry both a permitted and a prohibited use.
- No colour literal appears anywhere in this asset that is absent from the kit.

## What the brief must carry

- How many modes, and what each is for — as a reading situation, not as a name.
- The accessibility target as a level.
- Whether the mark is fixed or may be recoloured from the palette.
- Any colour the venture does not own outright.

## Notes

**Why `form: B`.** A colour system is a structure, not a rendered artefact. What ships is a
set of resolved decisions plus the document that explains them; the rendering is the kit's
job and the design system index's.

**Reciprocal with typography.** The two are decided together in practice — contrast targets
constrain type weight and size, and a type scale set without knowing the surface colour gets
re-set. Declaring them reciprocal is honest about that rather than pretending one precedes
the other.
