---
asset: pitch-deck
name: Pitch deck
taxonomy: [42]
spec_version: 1
kit_version: 1
form: C
tier: 1
group: 7
audience: [investor]
inputs_missing:
  - "round size, pre/post money"
  - "use of funds, split by category"
  - "traction metrics with dates, and whether real or illustrative"
  - "named comparables for the competition slide"
  - "the one thing you want remembered"
  - "length ceiling, if it is not 13 slides"
  - "team facts: names, roles, headshots or a licence to hatch them"
depends_on:
  hard_facts: [round-size, use-of-funds, traction, team]
  hard_assets: [positioning, colour-system, typography-system, logo-suite]
  reciprocal: [positioning, venture-thesis]
bundles: [seed-set]
---
# Pitch deck — specification

## What it is

The raise narrative, in slides. Sent ahead of a meeting and presented in it, so
it must survive being read alone and being talked over. Those are different
documents in most hands, and the standard shape below is the compromise that
works for both.

## The standard shape

Thirteen slides. **This is not a house variant** — the seed deck sequence is
settled practice, and there is no value in inventing an alternative. Deviate
only for a reason you can state.

| # | Slide | Carries |
|---|---|---|
| 1 | Cover | Name, one-liner, stage, date, confidentiality |
| 2 | Problem | Who hurts, how much, how you know |
| 3 | Why now | What changed, and why this was not possible before |
| 4 | Solution | What it is, in one sentence, then shown |
| 5 | How it works | Three steps, maximum |
| 6 | Market | TAM/SAM/SOM with the derivation, not just the number |
| 7 | Business model | What you charge, for what, and the unit economics |
| 8 | Go-to-market | The channels, and which one is proven |
| 9 | Traction | The metrics, dated, with the trend |
| 10 | Competition | The honest frame, and your axis |
| 11 | Team | Why these people, specifically |
| 12 | The ask | Round size, use of funds, milestones it buys |
| 13 | Close | The one thing to remember, and contact |

Two notes on the sequence. **Why now** (3) is the slide most often missing and
the one that most often decides the meeting. **Traction** (9) sits after the
model deliberately: a metric means nothing until the reader knows what is being
sold.

## Formats produced

- `Pitch Deck.dc.html` — the source. Navigates, prints, carries speaker notes.
- `exports/pitch-deck.pdf` — the send-ahead version. Generated, never hand-edited.
- `exports/pitch-deck.pptx` — editable, for a venture that needs to take it over.

The HTML is the source of truth; both exports regenerate from it. A hand-edited
export is a fork, and the fork wins by accident.

## Template form

**Form C — built artefact with placeholder content.** The craft is real: it
navigates, it prints, the type respects the 24px slide floor, the layouts vary
with intent. The content is bracketed monospace blanks and hatched imagery.

Guidance about what makes each slide good lives in `data-speaker-notes`, which
is the right home for three reasons: it is where a presenter looks anyway, it
travels with the slide when slides are reordered, and it does not have to be
deleted before the deck is shown.

## Definition of done

A finished deck, as distinct from a draft:

1. **No bracketed blanks remain.** Greppable, and reported as `blanks: 0`.
   `blanks` counts occurrences, because that is the number of substitutions a
   human faces; `blanks_unique` counts distinct blanks, because that is the
   number of decisions. Both are declared: they answer different questions and
   one without the other misleads.
2. **No hatched placeholders remain**, or each surviving one is deliberate and
   named in `RETURN.md`.
3. **Every number is dated and sourced**, and every illustrative number carries
   the visible `illustrative` marker. An unmarked number is a claim.
4. **It reads alone.** Someone who was not in the room reaches slide 13 and can
   state the ask and the reason for it.
5. **It fits the ceiling.** Thirteen slides, or a stated reason.
6. **Nothing below 24px**, at 1920x1080.
7. **Both exports regenerate cleanly** from the source, and the PPTX opens with
   text as text rather than as images.
8. **The ask is specific.** A round size without a use of funds is not an ask,
   and it is the most common way a deck arrives unfinished.

## What the brief must carry

Beyond the universal header:

- Round size, pre or post money, and whether the number is firm.
- Use of funds, split by category, and the milestones it buys.
- Traction metrics with dates, and **explicitly** whether they are real or
  illustrative.
- Named comparables, and the axis you want to be compared on.
- The one thing you want remembered.
- Length ceiling if not thirteen.
- Team facts, or a licence to leave them hatched.

## Notes

The deck is in a reciprocal loop with the positioning statement and the venture
thesis. Making the deck is how positioning gets tested — nothing exposes a weak
position faster than trying to put it on a slide — so a drop containing this
asset should expect to write something under *revisions to understanding*.
