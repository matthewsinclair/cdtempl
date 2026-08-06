---
verblock: "29 Jul 2026:v0.2: matts - Round five: the tool exists, and running it found eight things"
---
# Answer to round five -- for Claude Design

No new drop this round. The tool got built instead, which was the agreed next step,
and building it surfaced things no amount of further specification would have.

Eight findings. Two are defects in the specs as delivered, three are rules that
could not run as written, two are structural gaps on this side, and the last is a
behaviour change that alters what your bundle definitions mean in practice.

## What now exists

| Command | State |
|---|---|
| `cdsync new` | scaffolds a venture: git repo, `cdsync.json`, agent contract, target skeleton |
| `cdsync brief` | assembles a complete brief from the spec library |
| `cdsync import` | unpacks a drop, writing **only** the five paths you own |
| `cdsync check` | the six rules, with `blanks` computed |
| `cdsync site` | generates and serves a microsite over the target |

Plus `specs/` -- see finding 7.

## 1. Every declared blank count was wrong

Not close. Computed against the scope written in your own `kit.md`:

| Asset | Declared | Computed |
|---|---|---|
| `pitch-deck` | 64 / 45 | **70 / 47** |
| `positioning-icp-personas` | 58 / 54 | **72 / 39** |
| `whos-who-in-the-zoo` | 62 / 31 | **52 / 26** |

The `positioning` one is the interesting failure: 54 unique out of 58 occurrences
was already arithmetically implausible, and the real figure is 39 of 72. All ten
assets now carry computed counts with `blanks_source: computed`.

This is not a criticism -- it is the argument for the decision we already made,
arriving with evidence. Nobody counts 72 brackets correctly by hand, twice.

## 2. Rule 3 could not run as specified

First run against the ten assets produced six advisories. **Every single one was a
false positive.** Two exclusions are missing from the spec, and neither was
discoverable without executing it:

**A number inside a blank is not a claim.** `[svg, png at 1x/2x/3x, eps for print]`
and `determinate -- [00%]` are placeholders. They are already marked as the thing a
venture must replace, which is a stronger marking than `illustrative` would be.
Flagging them inverts the rule: it demands a claim-marker on the one construct that
is definitionally not a claim.

**A number in a stylesheet is not a metric.** Every percentage matched was a CSS
`width:` or `height:` in an inline style attribute -- `40%`, `60%`, `75%`, `90%`. A
rule that fires on `width: 40%` is a rule that gets switched off, and a check nobody
runs guards nothing.

With both exclusions the rule is silent across all ten assets, and it still catches
`$1.2M` and `340,000` in a document that does not say `illustrative`. Verified both
directions.

## 3. Rule 4 needs zero alpha excluded

`rgba(0,0,0,0)` appears in seven of the ten artefacts and in `tokens.css`. It is the
`transparent` keyword spelled long-hand: it carries no hue, so it has nothing to
leak, and the rule exists to catch a hue entering without passing through the kit.

Also settled while implementing: `rgb()` and `rgba()` now normalise to hex before
comparison, so a value written one way in the kit and another in an artefact still
compares equal, and alpha above zero is compared on hue alone -- the kit has no
alpha tokens, and opacity is a separate axis from palette.

With that, the leak guard passes clean across the whole drop while still catching
`#d97757` in either spelling. Your earlier verification held; this is a stricter scan
reaching the same verdict.

## 4. Two dependency slugs do not exist

Found by the tool on its first run, not by reading:

| Where | Names | Should be |
|---|---|---|
| `pitch-deck` → `hard_assets` | `positioning` | `positioning-icp-personas` |
| `pitch-deck` → `reciprocal` | `positioning` | `positioning-icp-personas` |
| `positioning-icp-personas` → `reciprocal` | `pricing` | `pricing-and-packaging` |

Left as delivered rather than silently corrected, because a silent correction is
exactly how a taxonomy drifts. Yours to fix or to tell me I have the canonical slug
wrong.

Worth noting what this rule deliberately does **not** flag: `component-library`
depending on `grid-and-layout`, which is real, correct to declare, and does not exist
yet. A dependency on an unbuilt asset is fine; a dependency on a name that is not in
the taxonomy at all is not.

## 5. Bundles had to be redefined over slugs

You defined the seven bundles over taxonomy numbers. They cannot stay that way,
because the mapping is not one-to-one: `positioning-icp-personas` is a single
deliverable covering numbers 1, 3 and 4.

A slug is the unit that gets ordered, delivered and counted, so a bundle has to be a
set of slugs or a brief cannot name one. Each library entry now records a `taxonomy:`
field naming the numbers it covers, so the mapping stays auditable.

**This changes counts you published.** `index.md` says `founding-set: 2 of 6`; over
slugs it is 2 of 4. Not a disagreement, just two different denominators, and the
slug one is the one the tool can act on.

## 6. `rebrand-set` as defined adds nothing

You defined it as "the identity set plus 19 plus an audit inventory of what changes".
But 19 is `brand-asset-kit`, which is already in the identity set by your own listing
(9, 12--19). So the bundle reduces to exactly the identity set.

The audit inventory is the real content of that bundle and **it is not in the
taxonomy at all.** That looks like a genuine gap rather than a bundle member: "an
inventory of what changes in a rebrand" is an asset with its own definition of done.
Flagged rather than invented -- if it should be asset 52, that is your call.

## 7. The spec library did not exist on this side

The biggest structural finding, and mine not yours.

The design has said since round one that the library lives here, version-controlled,
and that a drop carries a stamped copy whose version makes staleness detectable. But
the specs only ever existed at `templprj/assets/<slug>/spec.md`.

Which means **rule 2 could never have fired.** Comparing the drop against the library
was comparing the drop against itself. A staleness check with one copy of the thing is
not a check.

`specs/` now holds eleven entries -- your ten plus `kit` -- as the drop's spec minus
its per-drop state. `status`, `blanks`, `blanks_unique`, `blanks_source` and
`coverage` describe a delivery rather than an asset, so they do not belong in a
library. Everything else, including the whole body, is verbatim; a diff between an
entry here and the matching `spec.md` should show only those fields.

## 8. A partial bundle is now orderable, which changes what your bundles mean

Added after the findings above were written, because it bears directly on 5 and 6.

Every one of your seven bundles holds at least one slug the library has not specified
-- inevitably, since eleven of fifty-one exist. The tool originally refused any order
containing an unbriefable member, which meant **all seven bundles were unusable** and
the failure only appeared one command after the one that named them.

The rule now distinguishes how a slug was asked for:

| Asked for as | Unspecified | Why |
|---|---|---|
| a bare slug | **refused** | A particular thing was named. Trimming it would be the tool editing the order. |
| a bundle member | **omitted, and declared in the brief** | A group was named; its membership is the library's business, not the venture's. |

So `seed-set` today briefs three assets and states three as absent. What matters for
your side is the declaration: the brief carries a *Not in this drop, and asked for*
table naming each absent slug and the bundle that asked for it, plus an instruction to
leave the blank rather than let a neighbouring asset absorb it.

That instruction is the point. A partial seed set is a different ask from a whole one,
and a reader who is not told treats the gaps as deliberate scope and designs around
them -- an absent asset silently covered by its neighbour is the hardest kind of scope
drift to find later. **If a brief ever reaches you with that table in it, the set is
partial by circumstance, not by design.**

## Two things I would like from you, when convenient

**The scope answer in `kit.md` is what got implemented**, exactly as written,
including the code-span exclusion and `data-props` defaults counting. It produces
numbers that look right on inspection. If any of the ten computed figures looks wrong
to you, that is the cheapest possible moment to say.

**`invention` and `numbers` are new brief fields.** Gaps 8.3.1 and 8.3.3 are named in
your list as the two most expensive omissions, but neither was a field in the 8.1
header -- so a brief could satisfy the header and still leave both open. They are now
in `cdsync.json` and rendered into every brief as an explicit table, defaulting to
"leave blanks" and "treat as illustrative" when unstated. If that is the wrong
default, say so.

## What is next on this side

Run a real venture through the whole loop -- your recommendation from round four, and
still the right one. It now has something to run through.
