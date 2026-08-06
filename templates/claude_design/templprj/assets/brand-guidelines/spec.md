---
asset: brand-guidelines
name: Brand guidelines
spec_version: 1
kit_version: 1
form: C
tier: 1
group: 3
audience: [internal, public]
status: spec-only
inputs_missing:
  - "whether a mark exists, and in what formats"
  - "who else will use this document — an agency, a printer, a partner"
  - "typeface licences, and whether they cover web, print and embedding"
  - "the accent palette, or a licence to propose one"
depends_on:
  hard_facts: [mark-exists, typeface-licences]
  hard_assets: [logo-suite, colour-system, typography-system, voice-and-tone]
  reciprocal: [voice-and-tone, positioning-icp-personas]
bundles: [identity-set, rebrand-set]
blanks: 64
blanks_unique: 48
blanks_source: computed
---
# Brand guidelines — specification

## What it is

The assembled identity document — the thing you send a partner agency, a printer,
or a new designer, so that they can produce work that looks like yours without
asking.

It is an **assembly, not a source**. Every section restates a decision made in
another asset. That makes it the one document in the suite that is legitimately
duplicative, and it means it goes stale silently: a colour changed in the token
file does not change here. Version it, date it, and treat a mismatch as a defect.

## The standard shape

**Use the standard shape.** What a brand guidelines document contains is settled
practice; the only real variable is length, and it should be as short as the brand
actually is.

| Section | Carries |
|---|---|
| The brand in one page | Positioning, one-liner, and what the brand is not |
| Logo | Primary, secondary, mark-only, clear space, minimum sizes, misuse |
| Colour | The palette with roles, contrast pairings, light and dark behaviour |
| Typography | Faces, scale, weights, roles, line lengths, fallbacks, licences |
| Voice | How it sounds, with do/don't pairs and register by context |
| Imagery | Written art direction and a reference set |
| Layout | Grid, margins, and how much space the brand needs around it |
| Application | Real examples: a slide, a document, a social frame, a shopfront |
| Misuse | The specific things people do wrong, shown wrong |
| Contact | Who approves an exception |

Three sections that get dropped and should not be. **Misuse shown wrong** is the
one people actually read. **Clear space and minimum size** is what a printer asks
for first. And **who approves an exception** is what makes the document usable
rather than merely correct — a guideline with no exception path gets ignored
wholesale the first time it is inconvenient.

## Formats produced

- `Brand Guidelines.dc.html` — the source. Flowing document, running header and
  footer, paginating onto whatever paper the reader has.
- `exports/brand-guidelines.pdf` — the sendable version. This is the artefact that
  actually travels, so the PDF matters more here than for any other asset.

## Template form

**Form C — built artefact with placeholder content**, and the asset with the
highest ratio of placeholder to content in the suite, because almost everything in
it is a venture decision. The logo section is deliberately hatched: per the Form D
argument, a template mark is worse than no mark, and this document is exactly
where a placeholder mark would survive.

## Definition of done

1. **No hatched slot remains** in the logo, imagery or application sections.
2. **Clear space and minimum sizes are numeric**, not illustrative.
3. **Misuse is shown**, not described. Four examples minimum.
4. **Contrast pairings are stated** as pairs that pass, not as a target.
5. **Typeface licences are named**, with what they cover — web, print, embedding
   in a PDF. This is the section that causes a legal problem later.
6. **Every colour in the document matches `kit/tokens.json`.** Mechanically
   checked; a mismatch means one of the two is stale.
7. **The exception path names a person.**
8. **The version and date are on the cover**, because this document travels and
   copies of it will be in circulation.
9. **No blanks remain.**

## What the brief must carry

Beyond the universal header:

- Whether a mark exists, and in what formats. If it does not, this asset cannot be
  finished and should not be ordered yet.
- Who else will use the document. An agency needs production detail a new hire
  does not.
- Typeface licences.
- The accent palette, or a licence to propose one.

## Notes

Reciprocal with voice and tone, and with positioning: assembling the document is
what exposes a brand whose visual and verbal halves were decided separately. Expect
to revise those two rather than only quote them.
