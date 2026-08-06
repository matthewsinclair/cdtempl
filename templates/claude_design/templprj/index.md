---
verblock: "29 Jul 2026:v3: claude-design - Round four: the composite split built out, ten assets present"
venture: templprj
round: 4
spec_library_version: 2
target_structure_version: 2
kit_version: 1
---
# Manifest

What is in this drop, and what state it is in. Read `RETURN.md` first.

## Assets

| Slug | Name | Form | Tier | Status | Spec | Waiting on |
|---|---|---|---|---|---|---|
| `pitch-deck` | Pitch deck | C | 1 | spec-only | 1 | 7 inputs |
| `positioning-icp-personas` | Positioning, ICP and personas | A | 1 | spec-only | 1 | 4 inputs |
| `whos-who-in-the-zoo` | Who's who in the zoo | C | 1 | spec-only | 2 | 6 inputs |
| `design-system-index` | Design system index | C | 1 | spec-only | 1 | 3 inputs |
| `component-library` | Component library | C | 1 | spec-only | 1 | 4 inputs |
| `states-and-interaction` | States and interaction | C | 1 | spec-only | 1 | 3 inputs |
| `brand-guidelines` | Brand guidelines | C | 1 | spec-only | 1 | 4 inputs |
| `product-one-pager` | Product one-pager | C | 1 | spec-only | 1 | 4 inputs |
| `landing-page` | Landing page | C | 1 | spec-only | 1 | 5 inputs |
| `investor-update` | Investor update | A | 1 | spec-only | 1 | 4 inputs |

**Ten of the eleven Tier 1 assets.** The eleventh is `kit/`, taxonomy asset 20,
which lives at the target root — see below.

`blanks` and `blanks_unique` are no longer declared per asset: they are computed
by `cdsync check` from the scope written into `kit/kit.md`. The three specs from
earlier rounds still carry estimates, marked `blanks_source: estimated`, and the
check overwrites them when it runs.

`status: spec-only` is correct for a template and is the state every asset in
`templprj` stays in.

## Kit

| File | What it is |
|---|---|
| `kit/kit.md` | The kit written down: ramp, type, the two blanks, blank-counting scope, prohibitions |
| `kit/tokens.css` | Custom properties, `REPLACE`/`KEEP` marked |
| `kit/tokens.json` | The same values, parseable |

`kit/` is taxonomy asset 20, design tokens, deliberately at the target root rather
than under `assets/` because it is the one thing every other asset imports. Named
as an exception rather than left to be discovered.

## Notes

| File | What it is |
|---|---|
| `notes/tokens-and-artefacts.md` | Why artefacts restate token values; the drift it creates; the check that closes it, with comment-scoped declaration exclusions |
| `notes/composite-assets.md` | Why `design-system` is a bundle rather than an asset, and the eight slugs it becomes |
| `notes/coverage-versus-status.md` | Why `component-library` does **not** split, and the one status value and one computed field it needs instead |

## The asset directory shape, v2

```
assets/<slug>/
  spec.md            definition of done, travelling with the artefact
  <artefact files>
  vendor/            regenerable runtime — not yours to maintain
  exports/           generated output — never hand-edited
  src/               working files, if any
```

Unchanged this round. Four of the ten assets carry a `vendor/`; the six that are
plain pages or markdown do not.

## Status values

| Value | Meaning |
|---|---|
| `spec-only` | A template. The state every `templprj` asset stays in. |
| `draft` | Started, incomplete, blanks remaining |
| `partial` | **New in round four.** Inventory declared, incompletely covered — for assets whose definition of done is coverage rather than completion. Pairs with a computed `coverage` field. |
| `complete` | Definition of done satisfied, `blanks: 0` |

## Grouping

| Bundle | Progress |
|---|---|
| `founding-set` | 2 of 6 |
| `identity-set` | 1 of 9 — `brand-guidelines` |
| `product-set` | 4 of 10 — `kit`, `design-system-index`, `component-library`, `states-and-interaction` |
| `seed-set` | 3 of 6 — `pitch-deck`, `whos-who-in-the-zoo`, `product-one-pager` |
| `launch-set` | 2 of 7 — `landing-page`, `product-one-pager` |
| `operating-set` | 1 of 5 — `investor-update` |

## Not yet present

Tier 2, in the order they would be built: `grid-and-layout`, `voice-and-tone`,
`messaging-framework`, `ux-writing-standards`, `accessibility-standard`,
`pattern-library`, `theming-spec`, `information-architecture`, `key-flows`,
`roadmap`, `pricing-and-packaging`, `executive-teaser`,
`financial-summary-cap-table`, `data-room-index`, `hiring-plan`,
`ways-of-working`.

Tier 3, on request: the remaining twenty-one, including the five Form D
specification-only assets.
