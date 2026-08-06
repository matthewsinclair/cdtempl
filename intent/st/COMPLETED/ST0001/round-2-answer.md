---
verblock: "29 Jul 2026:v0.1: matts - Round two review: probe passed, four findings"
---
# Answer to round two -- for Claude Design

**The probe passed.** The structure survived one asset end to end, and the remaining seven Tier 1 assets are batch work against a proven shape. Your amendment is accepted: do `design-system` third rather than last, for exactly the reason you give -- it is the asset most likely to force a structural change, and the argument for probing early does not stop applying because the first probe passed.

Everything below is either a finding or a decision. Nothing here reopens round one.

## What I verified rather than took on trust

Worth saying explicitly, because it is the standard the check rules are meant to automate:

| Check | Result |
| ----- | ------ |
| Hues in the deck artefact | **zero** |
| `border-radius`, `box-shadow` | zero, zero |
| Webfont or `@import` | none |
| Font weights outside 400/600 | none |
| Gradients | 5, all `repeating-linear-gradient` -- the hatch, matching your narrowing of prohibition 1 |
| Slide type floor | honoured; smallest is exactly 24px |
| Slide count | 13, as declared |
| PPTX | real: 87-part archive, native structure |
| Illustrative marker | specified in `kit.md` **and** used in the deck |

It renders, and it is genuinely boring. The hatched mark slot on the cover is the right call and the reasoning holds -- a placeholder mark is the thing that survives.

## Finding 1: 84% of the artefact is vendor runtime, and it carries hue

This is the significant one.

`deck-stage.js` is 136KB and `support.js` is 69KB, against the deck's 40KB. Both describe themselves: *"GENERATED from dc-runtime/src/*.ts -- do not edit"*, and *"Copied omelette starter. Re-running copy_starter_component with this kind overwrites this file."* One carries `@ds-adherence-ignore`.

Between them they contain `#d97757`, `#f0eee6`, `#c96442`, `#b5563a`, `#b00020` and several coloured `rgba()` values. The orange renders visibly in the thumbnail rail.

I ran your check rule #4 before building it. It fails -- but not on the deck. Every unmatched literal is in the runtime.

Four consequences:

1. **The rule is unbuildable as written.** "Every colour literal in any artefact must appear in `tokens.json`" fails on every run, and a check that always fails gets switched off in week two -- your own argument about blocking checks, applied to itself.
2. **The asset shape has no slot for this.** `spec.md`, artefact files, `exports/`, `src/` -- runtime is none of those. It is not a working file and it is not an export.
3. **`templprj` is supposed to be boring on purpose**, and it currently ships 205KB of another product's branded UI that every venture will inherit.
4. **It is marked as regenerable and overwritable**, so copies go stale silently -- the same drift the note is about, arriving by yet another door.

**Decision: `vendor/` is added to the asset directory shape.** Runtime goes there, and the check rule excludes it structurally rather than by a maintained exception list. That is your own reasoning about prohibitions over instructions, applied here: an exception list is a thing someone has to keep right, and a directory is not.

The rule becomes: *every colour literal in an asset directory, excluding `vendor/`, must appear in `kit/tokens.json`.*

Two things I want your view on:

- **Should the runtime ship at all?** The deck does not render without it, so I assume yes. But if there is a build that inlines it, or a smaller runtime, that is worth knowing -- 205KB inherited by every venture forever is a real cost even when it is quarantined.
- **`vendor/README.md` stating what it is, where it comes from, and that it is regenerable.** Otherwise the first person to find 205KB of minified JS in a design drop will reasonably assume it is theirs to maintain.

## Finding 2: the blanks count is wrong

Declared `blanks: 47`. Actual: **64 occurrences, 45 unique.** Neither number is 47.

Minor on its own, and I would not mention it except for what it demonstrates: this is precisely the contradiction you proposed the check to catch, failing in the very first drop. That is the strongest possible argument that the rule is needed, so take it as confirmation rather than as criticism.

It also exposes an ambiguity that has to be settled before the rule can be written: **occurrences or unique?** I would take occurrences, because that is the number of edits a human has to make, and the count is only useful if it estimates work remaining. `[venture name]` appearing eleven times is eleven substitutions even if a control writes them all at once.

If you prefer unique because the tweakable props collapse several, say so -- but then `blanks` needs a companion field, because the two numbers answer different questions.

## Finding 3: "standalone" is overstated, and the fix is to the wording

Your justification for restating token values was that an artefact must open from a zip on a laptop with no server, and that a linked `../../kit/tokens.css` is a blank page the moment the file is moved.

The deck does `<script src="./support.js">` and imports `./deck-stage.js`. So it is **directory-portable, not file-portable.** Emailed on its own it breaks in exactly the way the argument warns about.

The inlining conclusion survives intact -- same-directory siblings travel when the asset directory is zipped, and a path two levels up does not. Only the claim needs narrowing, in `notes/tokens-and-artefacts.md`: the unit of portability is the asset directory, not the file. Worth fixing because the note is otherwise going to be the reference someone cites later.

## Finding 4: `exports/README.md` lists a file that is not there

The table lists `pitch-deck.pdf` as "the send-ahead version". Only the PPTX is present.

You explained the reason in `RETURN.md` and it is accepted -- PDF is a print action for this side. But the README describes a directory that does not exist as described, which is the exact failure `index.md` exists to prevent, one level down. Either mark it as not-yet-generated, or drop the row until it is.

## Round three

Batch the remaining seven Tier 1 assets in your proposed order, with `design-system` third.

Two things to carry in:

- `vendor/` in the asset shape, wherever runtime appears.
- The `blanks` definition, once settled.

If `design-system` breaks the uniform asset shape -- and it is the one most likely to, being a directory of many files rather than one -- stop at that point and say so rather than working around it. The shape is cheaper to change now than after four more assets are built against it.
