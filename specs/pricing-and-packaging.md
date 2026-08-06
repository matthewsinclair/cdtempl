---
asset: pricing-and-packaging
name: Pricing & packaging
taxonomy: [33]
spec_version: 1
kit_version: 1
form: C
tier: 2
group: 5
audience: [team, customer]
inputs_missing:
  - "the actual prices, which no design process can invent"
  - "the currency, the tax treatment, and whether prices are shown inclusive"
  - "what a customer is buying a unit of — a seat, a job, a month, an outcome"
  - "what is deliberately not sold, and what is given away"
depends_on:
  hard_facts: [prices-set]
  hard_assets: []
  reciprocal: [venture-thesis, information-architecture, product-one-pager]
bundles: []
---
# Pricing & packaging — specification

## What it is

**What is sold, in what units, at what price, and what each package contains.**
Packaging is the harder half: the price is a number, but the decision about what
belongs in which tier is a claim about who the customer is and what they value.

It is the asset most often filled with plausible invention, because a pricing table
looks finished whether or not anyone has agreed the numbers. **Prices are a hard fact
and must arrive from the venture**, which is why this spec declares `prices-set` as a
hard fact dependency rather than something the round can supply.

## The standard shape

| Part | Carries |
|---|---|
| The unit | What a customer buys one of, stated before any number |
| Packages | Each tier, what it contains, and who it is for |
| Prices | The numbers, the currency, the period, and the tax treatment |
| Boundaries | What each tier deliberately excludes, and what triggers a move up |
| Not sold | What the venture will not sell, and what it gives away |
| Changes | How a price change reaches existing customers |

## The unit comes before the number

**Deciding what a customer buys one of is the whole design problem.** A seat, a job, a
month, a transaction, an outcome — the choice determines whether the pricing scales
with the customer's success or with their headcount, and it is very hard to change
afterwards.

**Tier boundaries are claims about customers.** "Up to five users" says the venture
believes there is a natural break at five. If nobody can say why, the tiers are
arbitrary and will be renegotiated per deal, which is the failure this asset exists
to prevent.

## Illustrative numbers must be marked in the artefact

Where a round produces a pricing page before the prices exist, every figure must carry
an explicit **illustrative** marker in the artefact itself, not merely in the covering
note. `cdsync check` rule 3 enforces this, and it enforces it here more than anywhere:
an unmarked example price has been quoted to a customer before now.

## Definition of done

- The unit is named and justified before any price appears
- Every tier states what it excludes as well as what it includes
- Prices carry currency, period and tax treatment — a bare number is ambiguous
- **What is not sold** is present, including anything given away free
- If any figure is illustrative, it is marked as such **in the artefact**

## What the brief must carry

The prices, or an explicit statement that they do not exist yet. This is not a
formality: a pricing asset built on invented numbers is indistinguishable from a real
one at a glance, and the invention is usually discovered by a customer.

Also the tax treatment and the currency. A price shown without them is wrong in at
least one jurisdiction the venture sells into.

## Notes

Reciprocal with `venture-thesis` — what you charge for is a restatement of what you
believe you are worth — and with `information-architecture`, because the packaging
decides how many purchase paths the site needs.

Classification is per instance and this asset is frequently the most sensitive one a
venture holds, but that is a fact about the instance and is declared on the drop's
`spec.md`.
