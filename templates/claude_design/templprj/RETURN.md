---
verblock: "29 Jul 2026:v3: claude-design - Round four: the split built out, seven assets, one near-miss reported"
venture: templprj
round: 4
supersedes: "round 3 RETURN.md"
---
# Return — templprj, round 4

## What is in this drop

Both accepted changes applied, and **seven assets built** — the three from the
composite split plus the four held behind round three's stop. Ten of the eleven
Tier 1 assets are now present; the eleventh is `kit/`.

| What | Status |
|---|---|
| Comment-scoped exclusion pattern | Applied in `notes/tokens-and-artefacts.md` |
| `blanks` scope for the computed check | Written into `kit/kit.md` |
| Existing declared counts | Marked `blanks_source: estimated` |
| `assets/design-system-index/` | Form C, built |
| `assets/component-library/` | Form C, built — 28 components, the largest artefact in the suite |
| `assets/states-and-interaction/` | Form C, built |
| `assets/brand-guidelines/` | Form C, built — flowing document |
| `assets/product-one-pager/` | Form C, built — explicitly paginated, one page |
| `assets/landing-page/` | Form C, built |
| `assets/investor-update/` | Form A, built |
| `notes/coverage-versus-status.md` | The near-miss, and the test that stops the split recursing |

## Revisions to understanding

**`component-library` did not break the shape, but it came close enough that the
reason matters.** This is the report you asked for either way.

Applying round three's own test to it looks damning: one `status` per asset
directory, versus twenty-eight components with independent readiness. That is word
for word the argument that split `design-system`. And if it holds here it holds for
every asset with parts, and the taxonomy dissolves into a thousand slugs.

The distinction, which I did not have in round three and which is the durable part:
`design-system`'s parts were **already separate taxonomy entries with separate
definitions of done**. A component library's parts are **instances of one
specification** — one definition of done applied twenty-eight times. So the test is
not "does this asset have parts" but:

> Do the parts have different definitions of done? If yes, they are separate assets
> and the composite is hiding them. If no, they are one asset with coverage.

Cheap to apply, and it is what should be applied to every future composite-looking
asset. `pattern-library` passes the same way. `brand-guidelines` is a third
category with one member — its sections *do* have different definitions of done, but
it is explicitly an assembly of assets that exist separately, so its own done-ness
is "every section reflects its source".

What the shape needs is two things that bend nothing: a new `status` value
`partial`, and a computed `coverage` field read from the inventory table in the
artefact rather than from front matter. That is a fifth check rule and it is nearly
free: `partial` requires `coverage`, and `complete` requires coverage to be total.
A library declaring twenty-eight components and rendering twelve cannot claim to be
finished, which is the specific way this asset lies. Full argument in
`notes/coverage-versus-status.md`.

**The neutral kit makes two decisions it has no business making, and they only
surfaced once components existed.** Radius 0 means a radio button cannot be round —
it is a square distinguished from a checkbox by fill rather than by shape. And the
motion rule, one 120ms opacity or position change, forbids a rotating spinner
outright, so the kit's loading affordance is an indeterminate bar.

Neither is wrong as a placeholder, and both are exactly what the kit is for. But
they are *design decisions that look like conventions*, which is the failure mode
the kit exists to prevent, arriving from inside the kit. So both are called out in a
visible note at the top of the component library and marked as venture decisions.
The general rule: where a prohibition forces a component into an unusual shape, the
component must say so, or the next venture inherits the workaround as a style.

**Greyscale turned out to be load-bearing for states, not just for neutrality.**
Round one justified the zero-chroma ramp on inheritance grounds. Building
`states-and-interaction` showed a second reason that is arguably stronger: with no
hue available, every state *has* to be distinguishable by weight, border, fill or
position. So the matrix is automatically colour-blind-safe, and the moment a venture
applies a palette, the matrix is the artefact that tells them what broke. The kit is
not only preventing inherited taste — it is enforcing an accessibility property that
would otherwise be a review item.

## Decisions I made that you did not ask me to make

1. **The standard 28-component inventory**, in six groups, presented as settled
   practice rather than a house set. Subtracting from it is worth arguing about;
   inventing an alternative is not.
2. **States live in one matrix, not per component.** 28 × 9 is legible as a matrix
   and illegible as 252 examples. The component library points at it rather than
   restating it.
3. **First-run and no-results empties are separate designs**, and so are recoverable
   and unrecoverable errors. Both pairs are routinely collapsed; one is an
   invitation and the other a correction, one offers an action and the other an
   escape route.
4. **`product-one-pager` is explicitly paginated; `brand-guidelines` is flowing.**
   The one-pager's page count is the point, so it gets a fixed page box designed to
   fill letter and A4 alike. Guidelines vary in length, so a fixed count would be a
   lie.
5. **The landing page is built from the component library's vocabulary**, not
   one-off markup — so replacing the kit corrects the landing page for free. Where
   it needs something the library lacks, that is a finding for the library.
6. **The landing page's action is a single prop** writing to all three buttons. The
   most common failure with the asset is two different actions on one page, and this
   makes that structurally awkward rather than merely discouraged.
7. **`investor-update` stays Form A.** A designed investor update signals effort
   spent in the wrong place, and it is filled in every period rather than once — so
   the template's job is to survive twelve fillings-in without anyone wanting to
   restructure it.
8. **Every spec now names which of its sections are load-bearing and get softened.**
   Misses in the update, objections on the landing page, proof on the one-pager, why
   now in the deck. A definition of done that only lists sections does not stop the
   section arriving empty.

## What I could not do, and why

- **No PDFs.** All four printable assets are print-ready; PDF is a print action on
  your side. `brand-guidelines` and `product-one-pager` are the two where the PDF is
  the artefact that actually travels.
- **No PPTX regeneration for the deck.** Unchanged since round two, so the existing
  export is still current.
- **No logo, no photography, no illustration**, in any of the seven. Hatched slots
  with named subjects and ratios instead. `brand-guidelines` has the most of them,
  which is correct: it is the asset most dependent on a mark existing.
- **Coverage is declared as `0/28` rather than computed**, because the check does
  not exist yet. Marked as such.

## What I would do next

Nothing is blocked. Three options, in the order I would take them:

1. **Stop building and use it.** Ten Tier 1 assets plus the kit is enough to run a
   real venture, which was the round-one scope note's own bar. The most valuable
   next thing is a real venture drop exposing what the specs get wrong — that will
   teach more than four more templates.
2. **Build `cdsync check`.** It now has five rules, all of them earned by a real
   failure rather than imagined: colour literals against the token file; status
   against blanks; spec version against the library; illustrative markers present;
   coverage against status. Two of the five were failures I committed myself.
3. **Batch Tier 2**, in the order listed in `index.md`. `grid-and-layout` first,
   because `component-library` declares a dependency on it that does not yet exist —
   the one loose end in this drop.
