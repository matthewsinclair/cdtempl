---
asset: states-and-interaction
name: States and interaction
taxonomy: [23]
spec_version: 2
kit_version: 1
form: C
tier: 1
group: 4
audience: [developer]
inputs_missing:
  - "which page-level states the product actually has — permissions, offline, trial expiry"
  - "the empty-state copy voice, or the voice guide to derive it from"
  - "latency expectations: what is fast enough to need no loading state at all"
depends_on:
  hard_facts: [permission-model, latency-budget]
  hard_assets: [kit, component-library]
  reciprocal: [component-library, ux-writing-standards]
bundles: [product-set]
---
# States and interaction — specification

## What it is

Every state a thing can be in, and what it looks like in each. Two levels:
**component states** — focus, hover, active, disabled, invalid, loading — and
**page states** — loading, empty, error, partial, permission-denied, offline.

## Why it is a separate asset

Because it is the one that gets skipped. A component library shows components
working; the states are what happen the other ninety percent of the time, and a
product whose empty states were never designed is a product that looks unfinished
exactly when a new user arrives.

Separating it also stops the component library doubling in size. Twenty-eight
components times seven states is a matrix nobody will read component by component
— it is legible as a matrix and illegible as 196 examples.

## The standard shape

**Component states** — a matrix. Rows are states, columns are a representative
component from each group. The matrix is the artefact; exhaustive per-component
enumeration is not.

| State | Applies to | Must be distinguishable without colour |
|---|---|---|
| default | all | — |
| hover | interactive | yes |
| focus-visible | interactive | **yes, and never removed** |
| active | interactive | yes |
| disabled | interactive | yes |
| invalid | inputs | yes |
| loading | actions, containers | yes |
| selected | inputs, navigation, rows | yes |
| read-only | inputs | yes |

**Page states** — full panels, one per state, because each is a small piece of
design rather than a variant.

| State | The question it answers |
|---|---|
| loading | Is anything happening, and roughly how long |
| empty — first run | What is this, and what do I do first |
| empty — no results | Did I filter wrongly, or is there nothing |
| error — recoverable | What failed, and what do I do |
| error — unrecoverable | What failed, and who do I tell |
| partial | What loaded, and what did not |
| permission-denied | Why not, and who can grant it |
| offline | What still works |

Two distinctions that are usually collapsed and should not be. **First-run empty
and no-results empty are different designs** — one is an invitation and the other
is a correction. **Recoverable and unrecoverable errors are different designs** —
one offers an action and the other offers an escape route and a reference.

## Formats produced

- `States And Interaction.dc.html` — the source: the matrix and the panels, live.

## Template form

**Form C — built artefact with placeholder content.** The matrix is real and
complete at kit values. The page-state panels carry bracketed copy, because
empty-state and error copy is the most voice-dependent writing in a product and a
neutral version of it would be actively misleading.

## Definition of done

1. **Focus-visible is never removed**, and is distinguishable at every state
   combination including disabled-looking ones.
2. **Every state is distinguishable without colour.** With a greyscale kit this is
   automatic; with a venture's palette applied it is the thing that breaks first,
   which is why the kit is greyscale.
3. **Every page state has copy**, not a placeholder. Empty-state copy is design
   work, not filler.
4. **First-run and no-results empties are separate designs.**
5. **Recoverable and unrecoverable errors are separate designs**, and the
   unrecoverable one carries a reference a support conversation can use.
6. **Loading has a threshold.** Below it, show nothing — a spinner that flashes is
   worse than no spinner. The threshold is stated.
7. **Partial is designed, not an error.** Products that treat partial data as
   failure lose their most common good case.
8. **No blanks remain.**

## What the brief must carry

Beyond the universal header:

- Which page states the product actually has. Permission-denied and offline are
  not universal, and designing states a product cannot enter is waste.
- The voice guide, or the empty-state copy directly. This asset cannot be finished
  without one of the two.
- The latency budget: what is fast enough that no loading state is needed.

## Notes

Reciprocal with the component library and with UX writing standards. The matrix is
where the component library's claims get tested — a variant that has no sensible
disabled state is usually a variant that should not exist.
