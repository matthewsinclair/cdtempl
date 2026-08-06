---
verblock: "29 Jul 2026:v1: claude-design - The design-system stop, per round two's instruction"
---
# `design-system` is not an asset, it is a bundle

Round two said: if `design-system` breaks the uniform asset shape, stop and say
so rather than working around it. It does. This is the stop.

## The break

It is not mechanical. This works fine as a directory:

```
assets/design-system/
  spec.md
  index.dc.html
  component-library.dc.html
  patterns.dc.html
  states.dc.html
  grid.md
  accessibility.md
  theming.md
  data-visualisation.md
  vendor/
  exports/
```

"Artefact files" is plural and permissive, so nothing in the layout objects.

**The break is in the front matter, and it is a check problem.** The uniform shape
carries one `status`, one `blanks`, one `inputs_missing` per asset directory. A
design system is eight or nine distinct things with independent readiness. A real
venture will have a component library at `complete` and a data-visualisation
standard not started, and one status field cannot say that. `blanks: 300` across
nine documents estimates nothing. `inputs_missing` becomes a list nobody can act
on because it does not say which document is waiting.

That is precisely the contradiction `cdsync check` exists to catch, so the
composite defeats the mechanism you just committed to building. Working around it
would mean either nested per-part front matter — a second, different shape for
one asset — or giving up on checking the largest asset in the taxonomy.

## The fix, and it is a simplification

**Split it into flat slugs, one per taxonomy entry.** The taxonomy already had
them separate; round one collapsed them into one Tier 1 line for convenience, and
the structure is now rejecting that convenience.

`design-system` becomes a **bundle name**, which is where groupings were already
agreed to live. Nothing new is invented.

| Slug | Taxonomy | Form | Tier |
|---|---|---|---|
| — (`kit/`) | 20 Design tokens | B | 1 |
| `grid-and-layout` | 21 Grid, layout & responsive | B | 2 |
| `component-library` | 22 Component library | C | 1 |
| `states-and-interaction` | 23 States & interaction | C | 1 |
| `pattern-library` | 24 Pattern library | C | 2 |
| `accessibility-standard` | 25 Accessibility standard | A | 2 |
| `theming-spec` | 26 Theming spec | B | 2 |
| `data-visualisation-standard` | 27 Data visualisation | B | 3 |
| `design-system-index` | 28 Design system index | C | 1 |

Three consequences, and the second is the one to decide on.

**1. Asset 20 is `kit/`, not an asset directory.** In `templprj` the kit is the
neutral kit; in a venture it is that venture's tokens with the `REPLACE` values
filled. It is the same artefact either way, and it already sits outside
`assets/` because every asset depends on it. Worth naming as a deliberate
exception rather than leaving it as an inconsistency someone finds: **one asset
lives at the target root, because it is the one thing everything else imports.**

**2. Tier 1 goes from eight assets to eleven.** The four Tier 1 members of the old
composite are `kit` (built), `component-library`, `states-and-interaction` and
`design-system-index`. The other five drop to Tier 2 and 3, which is a more
honest reading — a venture at seed does not need a data-visualisation standard,
and pretending the design system is atomic is what hid that.

Net effect on round three's remaining work: **eight assets rather than five**, but
three of the eight are the ones the old composite was hiding, and two of the five
Tier 2 items come off the critical path entirely.

**3. `design-system-index` earns its place.** With the parts split, something has
to be the front door that says what exists and where. As a sub-directory of a
composite it was redundant with the composite's own `spec.md`; as a sibling of
eight slugs it is the asset that makes them navigable.

## What I have not done

I have not built any of the eight, and I have not built the four remaining Tier 1
assets that come after `design-system` in the batch order. Round two's
instruction was to stop at the break rather than work around it, and the shape is
cheaper to settle now than after four more assets are built against it.
