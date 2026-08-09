---
asset: positioning-icp-personas
name: Positioning, ICP and personas
taxonomy: [1, 3, 4]
spec_version: 3
kit_version: 1
form: A
tier: 1
group: 1
audience: [team, investor]
inputs_missing:
  - "the category you are claiming, or an explicit licence to propose one"
  - "any real customer evidence — interviews, wins, losses, support volume"
  - "the primary alternative you are displacing, including 'nothing' or a spreadsheet"
  - "whether personas are hypotheses or evidenced, and how many are real"
depends_on:
  hard_facts: [category-claim, customer-evidence]
  hard_assets: []
  reciprocal: [pitch-deck, landing-page, pricing-and-packaging, venture-thesis]
bundles: [founding-set]
---
# Positioning, ICP and personas — specification

## What it is

Three documents that only work together, so they are one asset. The positioning
statement says what you are and to whom; the ICP says which organisations that
describes; the personas say which humans inside them you are writing for. Split
apart, they drift within a quarter — the classic symptom being a positioning
statement aimed at one buyer and a landing page written for another.

It is the cheapest asset in Tier 1 and the one most other assets are waiting on.

## The standard shape

**The positioning statement uses the standard template.** This is settled
practice — Moore's, as refined by Dunford — and there is no value in a house
variant:

> For **[target customer]** who **[problem or need]**, **[venture]** is a
> **[market category]** that **[key benefit]**. Unlike **[primary alternative]**,
> we **[primary differentiator]**.

The template is easy and the discipline is hard. Three slots do the work and are
usually where a draft fails:

- **[market category]** — the shelf you are asking to be put on. Claiming a new
  category is expensive and usually wrong at seed stage. Claiming a familiar one
  makes the differentiator carry all the weight, which is where it belongs.
- **[primary alternative]** — most often a spreadsheet, an intern, or nothing.
  Naming a competitor here when the real alternative is inaction produces a
  positioning that wins arguments nobody is having.
- **[primary differentiator]** — must be something a customer can verify. "Better
  UX" is not a differentiator; "no implementation project" is.

**The ICP is firmographic and exclusionary.** The disqualifiers section is the
one that earns its keep: an ICP that cannot say who to walk away from is a
description of a market, not a target.

**Personas are labelled by evidence.** Every persona states whether it is
evidenced or hypothesised, and hypothesised personas are marked as such in the
artefact. An unlabelled persona becomes a fact within two months.

## Formats produced

- `positioning-icp-personas.md` — the source and the only artefact.

Form A: no rendered version, because nothing here benefits from one. If a
venture wants it presentable, it is a section of the brand guidelines rather than
a second copy of this file.

## Template form

**Form A — document with blanks.** Guidance travels inside the document as
indented notes under each blank, because a Form A artefact has no speaker-notes
channel and a separate guidance file would be deleted or ignored.

Blanks are square-bracketed and lower case; the bracket alone carries the
marking, since markdown has no colour. See `kit/kit.md`.

## Definition of done

1. **The positioning statement is one sentence** and survives being read aloud.
2. **The category is named**, and the choice to claim an existing one or a new
   one is stated with its reason.
3. **The primary alternative is honest**, including when it is inaction.
4. **The differentiator is verifiable** by a customer, not asserted.
5. **The ICP has disqualifiers**, and they exclude real revenue you could chase.
6. **Every persona is labelled** evidenced or hypothesised.
7. **The "what we are not" section is non-empty.** A positioning with no
   exclusions has not been decided.
8. **No blanks remain**, and `blanks: 0` is declared.

## What the brief must carry

Beyond the universal header:

- The category, or an explicit licence to propose one.
- Whatever customer evidence exists — interviews, closed-won reasons, closed-lost
  reasons, support volume. Without it this asset is entirely hypothesis and must
  say so throughout.
- The primary alternative, as observed rather than as assumed.
- How many personas are wanted. Two is usually right; more than three at seed
  stage means the ICP is too wide.

## Notes

Reciprocal with the pitch deck, the landing page, the pricing model and the
venture thesis. This is the asset those four are waiting on, which is why it is
first in the batch — but the loop runs both ways, and a drop that builds this
plus the deck should expect to revise this file rather than only write it.
