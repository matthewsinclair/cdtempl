---
verblock: "29 Jul 2026:v1: claude-design - Why the composite split does not recurse"
---
# Coverage versus status: why `component-library` does not split

Round four's instruction was the same as round three's: if `component-library`
breaks the uniform shape — and as the largest single artefact in the taxonomy it was
the next most likely to — stop and say so.

**It does not break.** But it came close enough that the reason is worth writing
down, because the reason is what stops the composite split from recursing forever.

## The near miss

Applying round three's own test to it looks damning. The uniform shape carries one
`status` per asset directory. A component library is twenty-eight components with
independent readiness: button done, data table not started. One status field cannot
say that. That is word for word the argument that split `design-system`.

If that argument holds here, it holds for every asset with parts, and the taxonomy
dissolves into a flat list of a thousand slugs. So either the argument was wrong
in round three, or there is a distinction. There is.

## The distinction

`design-system`'s parts were **already separate taxonomy entries with separate
definitions of done.** An accessibility standard and a data-visualisation standard
are different kinds of thing that happened to be adjacent; each has its own spec,
its own inputs, its own finished state. Collapsing them was a convenience.

A component library's parts are **instances of one specification.** There is one
definition of done here — anatomy, variants, states, usage, token-driven — applied
twenty-eight times. Nothing about a checkbox needs a different spec from a badge.

So the test is not "does this asset have parts". It is:

> **Do the parts have different definitions of done?**
>
> If yes, they are separate assets and the composite is hiding them.
> If no, they are one asset with coverage.

That test is cheap to apply, and it is the one to apply to every future asset that
looks composite. `pattern-library` passes it the same way `component-library` does.
`brand-guidelines` is the interesting near-case: its sections *do* have different
definitions of done, but it is explicitly an **assembly** of assets that already
exist separately in the taxonomy, so it is one asset whose done-ness is "every
section reflects its source". That is a third category and it has exactly one
member.

## What the shape needs instead

Two additions, and they do not bend anything.

**One new `status` value: `partial`.** For an asset whose inventory is declared and
incompletely covered. Distinct from `draft`, which means started-and-unfinished
with no declared scope to measure against.

**One computed field: `coverage`.** `"12/28"`, read from the inventory table in the
artefact — not from the front matter. The table is where per-component state
belongs, because it sits next to the components. This follows the same reasoning as
moving `blanks` from declared to computed: a hand-maintained count of a
mechanically countable property will drift.

That gives `cdsync check` a fifth rule, and it is nearly free:

> **`status: partial` requires a `coverage` field, and `status: complete` requires
> coverage to be total.**

A library declaring twenty-eight components and rendering twelve cannot claim to be
finished, which is the specific way this asset lies.

## Why the inventory lives in the artefact

Worth stating because the alternative is tempting. Nested front matter —
`components: [{name: button, status: complete}, …]` — would make the check simpler
to write and the asset harder to use. The person deciding whether the button is
done is looking at the button. Putting that judgement in a metadata block twenty
lines above it guarantees the two disagree.
