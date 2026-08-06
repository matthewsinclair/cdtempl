---
asset: information-architecture
name: Information architecture & sitemap
taxonomy: [29]
spec_version: 1
kit_version: 1
form: C
tier: 2
group: 5
audience: [developer, team]
inputs_missing:
  - "every page or screen that must exist, including the ones nobody demos"
  - "what is navigable versus what is only reachable by link"
  - "which content is managed and by whom, which decides what the CMS must model"
  - "the URL or route scheme, and whether existing addresses must survive"
depends_on:
  hard_facts: []
  hard_assets: []
  reciprocal: [key-flows, pricing-and-packaging, cms-rollout-plan]
bundles: []
---
# Information architecture & sitemap — specification

## What it is

**The complete set of places a person can be, and how they are organised.** The sitemap
is the visible half; the architecture is the model underneath — what kinds of thing
exist, how they relate, and which of those relationships a reader can actually traverse.

It is the asset that decides how much of everything else is possible. A flow cannot
route through a page the architecture does not have, and a CMS cannot manage a content
type nobody modelled.

## The standard shape

| Part | Carries |
|---|---|
| Content types | The kinds of thing that exist, and what each one holds |
| The map | Every page or screen, nested as the reader experiences it |
| Navigation | What appears in primary, secondary and footer, and what appears nowhere |
| Routes | The URL or route scheme, and any addresses that must survive a change |
| Access | What is public, what needs an account, what needs a role |
| States per page | Empty, error, loading and unauthorised — where they differ from the norm |

## Navigable is not the same as existing

**The commonest defect is a map that lists only what is in the menu.** Confirmation
pages, error states, legal pages, unsubscribe endpoints, the page a failed payment
lands on — none are navigable and all must exist. A map missing them looks complete and
sends implementers to invent them one at a time.

**Access is architecture, not a later concern.** Whether a page is public decides its
route, its indexability, its empty state and whether it can be linked. Deciding it
afterwards means rebuilding those four things.

## Definition of done

- Every content type names its fields, including the ones only used in one place
- The map includes **non-navigable pages** — confirmations, errors, legal, transactional
- Navigation states explicitly what does *not* appear in it
- Access is marked per page, with public as an explicit choice rather than a default
- Where addresses already exist, the map says which survive and which redirect

## What the brief must carry

Everything that already exists, including the pages nobody mentions. An architecture
drawn from a demo will omit precisely the pages that carry the legal and transactional
obligations, and those are the expensive ones to retrofit.

Also who manages what. An architecture that models content the venture has no way to
edit is a specification for a site that goes stale in its first month.

## Notes

Reciprocal with `key-flows` and never prior to it: a flow discovers pages the map
missed, and a map constrains what a flow can do. Reciprocal with `cms-rollout-plan`
for the same reason — the content model and the tool that manages it settle together.
