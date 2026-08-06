---
verblock: "29 Jul 2026:v1: claude-design - The neutral kit, as specified in round one and built in round two"
kit_version: 1
---
# The neutral kit

The single file every template imports. Neutrality lives here, so "is this too
charming" is one question about one file rather than a judgement call across
fifty-one artefacts.

Asking for restraint across fifty-one artefacts is asking someone to fight a
tendency, and tendencies win eventually. This is the mechanism instead.

## What the kit is not

The kit is **not a starting palette.** It is a deliberately unfinished one, and a
venture's first design act is to replace it. The kit's job is to make that
replacement obvious and cheap, and to make forgetting to do it visible.

Values in `tokens.css` are marked `REPLACE` or `KEEP`:

- **REPLACE** — the accent, the faces, radius, elevation. The seams. A venture
  fills these from its brand.
- **KEEP** — the ramp steps, the scale, the space steps, the floors. Structural.
  These survive into a real venture unless there is a reason to move them.

## Colour

Twelve steps, pure greyscale, named by number and never by role. Role names like
`--color-primary` are where taste re-enters, because naming something primary is
deciding that it matters.

Chroma is exactly zero. Any tint — a warm white, a blue-black — is an aesthetic
decision, and a decision made in the kit is a decision inherited by every
venture without anyone choosing it. That is the failure mode the kit exists to
prevent, so the kit must not commit it.

One accent slot exists and resolves to grey, so templates can reference
`--accent` wherever a real venture will want colour. Nothing looks designed, but
the seams are in the right places.

### Contrast pairings

Stated, not left to be worked out. Target is WCAG 2.2 AA.

| Context | Use |
|---|---|
| Body text on `grey-0`/`grey-50` | `grey-700` and darker |
| Secondary text on light | `grey-600` |
| Body text on `grey-900` | `grey-0`, `grey-50`, `grey-100` |
| Carries text at any size | never lighter than `grey-600` on light |

## Type

Two stacks, two weights, one scale. No webfont and no `<link>` to a font
service: a loaded typeface is a brand decision and would be inherited silently.

Weights 400 and 600 only. No display face, no letterspacing, no small caps, no
italics except in prose quotation.

Scale is ratio 1.25 on a 16px base — `13 / 16 / 20 / 25 / 31 / 39 / 49` — and
continues at the same ratio for slide contexts: `61 / 76 / 95 / 119`.

Two floors override the scale, from standing practice rather than preference:

- **24px minimum** for anything on a 1920x1080 slide.
- **12pt minimum** for anything printed.

Where a floor conflicts with the ramp, the floor wins.

## Space, radius, line

- Space, 4px base: `4 / 8 / 12 / 16 / 24 / 32 / 48 / 64 / 96`.
- **Radius 0.** Rounded corners are a style decision.
- **No shadow.** One hairline instead: `1px solid var(--line)`. Elevation is a
  style decision too, and shadow is where templates get pretty first.
- Prose line length: 68 characters maximum.

## The two kinds of blank

They must look different, because they fail differently.

### Missing imagery

Diagonal hairline hatch on `--grey-100`, a `--grey-300` hairline border, and a
centred monospace caption in `--grey-600` naming exactly what belongs there:
`product shot 16:9`, `founder headshot 1:1`, `team photo`.

Never a drawn SVG scene, never stock, never a gradient blend. **The caption is
the art direction in miniature** — it is the useful part, so it is specific
about ratio and subject.

### Missing copy

Monospace, `--grey-600`, square-bracketed, lower case:

```
[venture name]
[one-line description — what it does, for whom]
[ARR, with units]
```

Bracketed and monospace makes an unfilled blank both visually obvious in a
screenshot and greppable in a diff, which is what stops a half-filled template
shipping. Where the blank benefits from guidance, the guidance goes inside the
brackets after an em dash.

**In Form A artefacts the bracket carries it alone.** Markdown has no colour and
no monospace outside code spans, and wrapping every blank in backticks makes a
document unreadable. The square bracket is sufficient: it is as greppable as the
rendered treatment, which is the property the check depends on. The monospace and
colour rules apply to rendered artefacts — Forms B and C.

### Counting blanks — what is in scope

`blanks` and `blanks_unique` are computed by `cdsync check`, not declared. This is
the scope it computes over. It is written here rather than in the check because it
is a property of the placeholder treatment, and the treatment is what changes.

**Which files count.** Only artefact files — the files a venture edits to finish
the asset. In scope: `.dc.html` artefacts, `.md` artefacts, and `kit/tokens.*`.
Out of scope: `spec.md`, `index.md`, `RETURN.md`, any `README.md`, `notes/**`,
`vendor/**`, `exports/**`.

The line is not "files containing brackets", it is **files a venture fills in**. A
`spec.md` describes the work; it is not the work. Counting its blanks would make
every asset permanently unfinishable, since specs are meant to keep their
placeholders.

**What counts inside an in-scope file.** A blank is `[...]` where the content
begins with a lower-case letter or digit, contains no line break, and is at most
eighty characters. Lower-case initial is what separates a blank from prose that
happens to use brackets. Four exclusions:

1. **Anything inside a code span or fenced code block.** Literal examples of the
   treatment — the `[bracketed]` in a "no blanks remain" checklist — are
   documentation of the marker, not instances of it. This is the exclusion most
   likely to be forgotten, and it is why a completion checklist can safely name
   the thing it is checking for.
2. **Markdown links.** `[...]` immediately followed by `(` is a link, not a blank.
3. **The `verblock:` line.** Its placeholders are stamped by tooling, not filled
   by a person, so they are not work remaining.
4. **Nothing else.** In particular, front-matter values other than the verblock
   **do** count, and so do `data-props` defaults — a venture really does replace
   `"default": "[venture name]"`, and the props panel is usually where it does so
   first. Excluding them would undercount the primary edit site.

**Occurrences and unique.** `blanks` counts occurrences, because that is the
number of substitutions a person faces. `blanks_unique` counts distinct strings
after trimming interior whitespace, because that is the number of decisions.
Neither alone is honest: 62 and 31 is a materially different picture from either
number by itself.

**A note on why this is computed.** These numbers were declared by hand twice and
were wrong both times, in three different ways, by someone with every incentive to
get them right. The conclusion is not that the convention needs specifying harder
— it is that a hand-maintained count of a mechanically countable property will
always drift. Removing the failure mode is the same move as enforcing neutrality
with a kit rather than asking for restraint. Any spec still carrying a declared
count carries `blanks_source: estimated` beside it, and the check overwrites both
fields when it runs.

**A consequence worth stating, because it reclassifies assets.** Form A can
carry only one of the two kinds of blank. Markdown cannot hatch an image slot,
so any asset whose completeness depends on imagery is **Form C by construction**,
not Form A. That moved `whos-who-in-the-zoo` out of Form A, and the same test
should be applied to the rest of the taxonomy when each is templated.

## The illustrative marker

Gap 8.3.3 from round one: illustrative numbers must be **visibly marked in the
artefact**, not merely understood in conversation. The marker is:

- Monospace, `--floor-slide` size in slide contexts, `--text-xs` in documents.
- `--grey-100` fill, `--grey-300` hairline, `--grey-700` text, radius 0.
- The literal word `illustrative`, lower case, adjacent to the number it
  qualifies — not in a footnote, and not once per page for many numbers.

An unmarked number in a delivered artefact is a claim. This is a safety
property, which is why it belongs in `cdsync check` rather than in a habit.

## The prohibitions

The kit's teeth. Templates may not contain:

1. Colour-transition gradients.
2. Border radius.
3. Box shadows.
4. Any hue at all.
5. A webfont.
6. More than two weights.
7. Drawn illustration.
8. Photography.
9. Icons beyond geometric primitives — square, circle, triangle, line, chevron,
   cross, tick.
10. Animation beyond a 120ms opacity or position change.
11. More than one background value per page.
12. Letterspacing, small caps, or italics outside prose quotation.

Each of these is a thing that gets drifted into, and each is a thing a venture
inherits invisibly. The list is the mechanism, not a statement of taste.

**One stated exception.** The placeholder hatch is built from a repeating
hard-edged pattern, which is a gradient function but not a colour transition.
Prohibition 1 is about blends. The hatch is the sole exception and there are no
others.

## How artefacts consume the kit

`tokens.css` and `tokens.json` are the machine-readable record — the thing a
Phoenix/Tailwind theme and a build both read.

**Built HTML artefacts restate the values literally rather than importing the
stylesheet**, so they open standalone and paint immediately. That creates a
drift risk between the kit and the artefacts, which is a real cost and is
handled by a check rather than by care. See `notes/tokens-and-artefacts.md`.
