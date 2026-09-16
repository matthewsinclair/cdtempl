---
asset: design-system-index
name: Design system index
taxonomy: [28]
spec_version: 2
kit_version: 1
form: C
tier: 1
group: 4
audience: [developer, team]
inputs_missing:
  - "which of the design-system assets this venture is actually ordering"
  - "the target stack, so the tokens section can name the files it feeds"
  - "who owns the system, and how a change to it gets proposed"
depends_on:
  hard_facts: [target-stack, system-owner]
  hard_assets: [kit]
  reciprocal: [component-library, states-and-interaction]
bundles: [product-set]
---
# Design system index — specification

## What it is

The front door. What exists, where it lives, how to use it, and what version it
is at.

It exists because the design system split into eight sibling assets, and eight
siblings with no index is a directory listing. As a sub-directory of a composite
this was redundant with the composite's own `spec.md`; as a sibling of eight
slugs it is the asset that makes them navigable.

**It is a map, not a container.** The index does not restate the tokens, the
components or the standards — it points at them and says what state each is in.
Restating is how an index becomes a second source of truth and then the wrong one.

## The standard shape

There is no settled industry shape, so this is proposed. Five sections:

| Section | Carries |
|---|---|
| Status | Version, owner, what changed last, how to propose a change |
| Inventory | Every design-system asset, its state, and a link |
| Foundations at a glance | The ramp, the scale, the space steps — shown, not described |
| The rules that are not negotiable | The prohibitions, and the accessibility target |
| How this reaches the application | Which files the venture's build consumes |

Two deliberate choices. **Foundations are shown rather than listed**, because a
greyscale ramp printed as twelve labelled swatches is checkable at a glance and a
table of hex values is not. And **"how this reaches the application" is a section**,
because the as-designed/as-built distinction only holds if someone can see where
the boundary is.

## Formats produced

- `Design System Index.dc.html` — the source and the only artefact. A page, not a
  document: it is read on screen and never printed.

## Template form

**Form C — built artefact with placeholder content.** The foundations sections are
real: they render the actual kit values, so the index is a live check on the kit
rather than a description of it. Everything venture-specific is bracketed.

## Definition of done

1. **Every design-system asset the venture ordered is in the inventory**, with a
   state that matches that asset's own `spec.md`.
2. **Nothing in the inventory is missing a link.**
3. **The foundations render the venture's tokens**, not the neutral kit's.
4. **The owner is a person**, not a team name.
5. **"How to propose a change" resolves to a real process.** A design system with
   no change process is a snapshot.
6. **The application-boundary section names real files** in the venture's repo.
7. **No blanks remain.**

## What the brief must carry

Beyond the universal header:

- Which design-system assets are in scope. The index is the one asset that needs
  to know what the rest of the order was.
- The target stack, specifically the files the tokens feed.
- The system's owner, and how a change gets proposed.

## Notes

Reciprocal with everything it indexes: each sibling asset's status is authoritative
in that asset's `spec.md`, and the index mirrors it. That mirroring is a drift
risk of exactly the kind `notes/tokens-and-artefacts.md` describes, and the same
answer applies — it should be computed by `cdtempl check` from the sibling specs
rather than maintained by hand. Recommend that as a fifth check rule once the
design-system assets exist to be counted.
