---
asset: key-flows
name: Key flows
taxonomy: [30]
spec_version: 1
kit_version: 1
form: C
tier: 2
group: 5
audience: [developer, team]
inputs_missing:
  - "which journeys matter enough to be drawn, and who decided"
  - "what happens when each one fails, at every step it can fail at"
  - "whether a flow crosses a system boundary — payment, email, a third party"
  - "what the reader is assumed to have already done before the flow starts"
depends_on:
  hard_facts: []
  hard_assets: [brand-guidelines]
  reciprocal: [information-architecture, pricing-and-packaging]
bundles: []
---
# Key flows — specification

## What it is

**The journeys that have to work, drawn end to end including the ways they fail.** A
flow is not a sequence of happy screens. It is the decision points, the branches, and
what a person sees when the thing they attempted does not happen.

Most flow documentation covers the path where everything works, which is the path that
needs the least design. **The failure branches are the deliverable**, because they are
where a person decides whether to trust the product.

## The standard shape

| Part | Carries |
|---|---|
| Entry | Where the flow begins, and what the reader is assumed to have done already |
| Steps | Each screen or state, in order, with what changes between them |
| Branches | Every decision point, with both sides drawn |
| Failures | Per step: what can fail, what the reader sees, and what they can do next |
| Boundaries | Where the flow leaves the product — payment, email, a third party |
| Exit | What "done" looks like, and where the reader is left |

## Failure is per step, not per flow

**A single "error state" at the end of a flow is the defect this asset exists to
prevent.** Each step fails differently: a declined card is not a network timeout is not
an expired session, and a reader who is told only that "something went wrong" has been
given no way to act.

**System boundaries are where flows break in production.** Any step that leaves the
product — a payment processor, an email that must arrive, an external identity provider
— needs its own failure treatment, because the product does not control whether it
succeeds and often does not learn quickly that it did not.

## Definition of done

- Every step names what can fail at it and what the reader sees when it does
- Both sides of every branch are drawn — an undrawn branch is an invented one later
- **Boundary steps are marked**, with the timeout or failure behaviour stated
- Entry states what is assumed already true, so the flow cannot be read out of context
- Exit says where the reader is left, which is where the next flow starts

## What the brief must carry

Which journeys matter, chosen by the venture rather than inferred. A flow set drawn
from a product tour covers what the product demonstrates well and omits the recovery
paths, which is the opposite of useful.

Where a flow crosses into a system nobody has specified yet, say so. A flow drawn
through an unbuilt payment integration is a plan, and marking it as one is information.

## Notes

Reciprocal with `information-architecture` — a flow routes through pages the map
must contain, and drawing the flow is how the map's gaps are found. Reciprocal with
`pricing-and-packaging` wherever money changes hands, because the packaging decides
how many branches the purchase flow has.
