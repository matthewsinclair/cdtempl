---
asset: venture-thesis
name: Venture thesis
taxonomy: [2]
spec_version: 1
kit_version: 1
form: C
tier: 3
group: 1
audience: [team, investor]
inputs_missing:
  - "what the venture believes that the market does not yet"
  - "the wedge — the narrow thing it does first, and why that one"
  - "what has to be true for the thesis to hold, stated so it could be falsified"
  - "the timeframe the thesis is claimed over"
depends_on:
  hard_facts: []
  hard_assets: []
  reciprocal: [positioning-icp-personas, pricing-and-packaging, ways-of-working]
bundles: [founding-set]
---
# Venture thesis — specification

## What it is

**The argument for why this venture should exist, written so it can be wrong.** Not a
description of the product and not a summary of the market — a claim about the world
that the venture is betting on, and the reasoning that gets from that claim to this
particular business.

It is the document every other founding artefact is downstream of. Positioning says
who it is for; pricing says what it costs; the thesis says **why any of it is worth
doing**, and it is the one that changes least often and costs most when it is wrong.

## The standard shape

| Part | Carries |
|---|---|
| The claim | What the venture believes that the market does not yet act on |
| Why now | What changed that makes this possible or necessary, and recently |
| The wedge | The narrow first thing, and why starting there rather than broader |
| The path | How the wedge widens, without which the wedge is just a small business |
| What must be true | The conditions the thesis depends on, each falsifiable |
| What would kill it | The disconfirming evidence, named in advance |

## The two failures

**A thesis that cannot be wrong is not a thesis.** "People want better software" is
unfalsifiable and therefore carries no information. Every claim in the document should
be one a reasonable person could dispute with evidence.

**A thesis that is really a product description.** If the document could be rewritten
as a feature list without losing anything, it has no thesis in it. The test is whether
a reader could disagree with the *reasoning* rather than merely prefer a different
product.

## Definition of done

- The claim is stated in one sentence, and it is disputable
- **Why now** names something that changed, with a date or a trend, not a mood
- The wedge is narrow enough that a reader can picture the first customer
- **What must be true** is a list, and each item could be tested
- **What would kill it** is present and is not a straw man

## What the brief must carry

The venture's own account of what it believes and why. This asset cannot be inferred
from a market, a competitor set or a product — it is the one place where the founders'
judgement is the input, and a design process that invents it has invented the venture.

Where the belief is not yet articulated, say so. A thesis marked absent is a real
finding; a thesis composed from general market observations is a defect that survives
several rounds because it reads plausibly.

## Notes

Classified per instance, and usually the most sensitive document a venture holds —
it names the bet and the conditions under which it fails. That is a fact about the
instance rather than about the asset, so it is declared on the drop's `spec.md` and
never here.
