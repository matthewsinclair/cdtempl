---
asset: component-library
name: Component library
taxonomy: [22]
spec_version: 2
kit_version: 1
form: C
tier: 1
group: 4
audience: [developer]
inputs_missing:
  - "the actual inventory needed, or an explicit 'start from the standard set'"
  - "the target stack, and whether an existing product must be matched or replaced"
  - "density requirements — is this a data-dense product or a marketing surface"
  - "whether dark mode is in scope now or later"
depends_on:
  hard_facts: [target-stack, density-requirement]
  hard_assets: [kit, grid-and-layout]
  reciprocal: [states-and-interaction, pattern-library, key-flows]
bundles: [product-set]
---
# Component library — specification

## What it is

The inventory of components, each shown with its anatomy, variants, sizes and
usage rules. The largest single artefact in the taxonomy, and the one the venture's
application actually consumes.

## The standard shape

**Use the standard inventory.** What a component library needs to contain is
settled practice, and a house variant of the set is a cost with no benefit. The
standard set, twenty-eight components in six groups:

| Group | Components |
|---|---|
| Actions | button, icon button, link, menu, toolbar |
| Inputs | text input, textarea, select, checkbox, radio group, toggle, slider, date input |
| Display | badge, tag, avatar, card, table, list, key-value pair |
| Feedback | alert, toast, tooltip, progress, spinner, skeleton |
| Navigation | tabs, breadcrumb, pagination |
| Overlay | modal, drawer |

A venture adds to this and rarely subtracts. **Subtracting is worth arguing about
when it happens** — a product with no table is usually a product that has not yet
found its data.

Each component entry contains, in this order:

1. **The component**, rendered, in every variant and size it has.
2. **Anatomy** — the named parts, so a conversation about it can be specific.
3. **Variants and sizes** — what exists, and the token that drives each.
4. **Usage** — when to use it, and the one case where people reach for it wrongly.
5. **States** — a pointer to `states-and-interaction`, not a restatement.

## On readiness, and why this is one asset rather than twenty-eight

The composite argument that split `design-system` does not apply here, and the
distinction is worth stating because it is the one that stops the split
recursing.

`design-system`'s parts were **already separate taxonomy entries**, each with its
own definition of done — an accessibility standard and a data-visualisation
standard are different kinds of thing that happen to be adjacent. Components are
**instances within one asset** whose definition of done is *coverage of a declared
inventory*. There is one specification here, applied twenty-eight times.

So readiness is expressed as **coverage, not status**:

- `status: partial` — a new value, for an asset whose inventory is declared and
  incompletely covered.
- `coverage: "12/28"` — computable from the inventory table in the artefact.
- The **inventory table is part of the artefact**, not the front matter, so
  per-component state lives next to the components without nesting front matter
  or inventing a second shape.

That extension is the whole accommodation. It does not bend the uniform shape; it
adds one status value and one computed field.

## Formats produced

- `Component Library.dc.html` — the source: a browsable gallery, every component
  in every variant, live.

No PDF. A component library is read on screen, at width, and a printed one is a
picture of a tool.

## Template form

**Form C — built artefact with placeholder content**, but the least placeholdered
asset in the suite: the components themselves are real and complete at neutral-kit
values. What is bracketed is the usage guidance, which is venture-specific, and
the inventory's coverage column.

This is the asset where the kit does the most work. Every component is greyscale,
radius 0, hairline-bordered, two weights — so a venture replacing the kit sees the
whole library change at once, which is the point of having one.

## Definition of done

1. **Every component in the declared inventory is rendered**, and `coverage`
   reaches `28/28` or the inventory is explicitly reduced with reasons.
2. **Every component shows every variant and size it claims to have.** A variant
   named in the table and not rendered is the most common way this asset lies.
3. **Anatomy parts are named** for every component with more than one part.
4. **Usage says when not to**, not only when to. Guidance that only encourages is
   not guidance.
5. **Nothing restates states** — they point at `states-and-interaction`.
6. **Every component maps to a token**, never a literal. A component with a
   hard-coded value will not follow the venture's brand.
7. **Accessibility is per component**, not a general claim: keyboard model, focus
   treatment, and the roles each component needs.
8. **No blanks remain.**

## What the brief must carry

Beyond the universal header:

- The inventory, or "start from the standard set".
- The target stack, and whether an existing product is being matched or replaced.
  Matching is a much larger job and is often not stated.
- Density. A data-dense product and a marketing surface need different sizes of the
  same components, and this is decided once here or repeatedly forever.
- Whether dark mode is in scope now. Retrofitting it costs more than including it.

## Notes

Reciprocal with `states-and-interaction` and with key flows: flows demand
components and components constrain flows. Build the flows against this rather than
before it, and expect the flows to add two or three components nobody listed.
