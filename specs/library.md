---
spec_library_version: 4
target_structure_version: 2
kit_version: 1
bundles:
  founding-set: [positioning-icp-personas, venture-thesis, problem-and-opportunity, whos-who-in-the-zoo]
  identity-set: [voice-and-tone, logo-suite, colour-system, typography-system, iconography, imagery-direction, motion-principles, brand-guidelines, brand-asset-kit]
  product-set: [ux-writing-standards, kit, grid-and-layout, component-library, states-and-interaction, pattern-library, accessibility-standard, design-system-index, information-architecture, key-flows]
  seed-set: [pitch-deck, executive-teaser, financial-summary-cap-table, data-room-index, whos-who-in-the-zoo, product-one-pager]
  launch-set: [messaging-framework, landing-page, email-templates, social-and-ad-kit, launch-kit, demo-video-storyboard, product-one-pager]
  rebrand-set: [voice-and-tone, logo-suite, colour-system, typography-system, iconography, imagery-direction, motion-principles, brand-guidelines, brand-asset-kit]
  operating-set: [investor-update, hiring-plan, job-description-template, ways-of-working, decision-log]
---
# The spec library

The source of truth for what every asset is and what finished means for it. A
drop carries a stamped copy of each spec it delivers; this is the original those
copies are stamped from, and the version difference between the two is what makes
staleness detectable.

`cdsync brief` assembles from here. `cdsync check` compares a drop against here.
Nothing else reads it.

## Why the library is not the drop

Claude Design authored these specs, and until now they existed only inside
`templates/claude_design/templprj/assets/<slug>/spec.md`. That made the drop its
own source of truth, which cannot work: a drop is a delivery, and a delivery
records how far along one copy got.

So a library entry is the drop's spec **minus the per-drop state** — `status`,
`blanks`, `blanks_unique`, `blanks_source` and `coverage` are all facts about a
delivery rather than about the asset. Everything else, including the whole body,
is verbatim. A diff between an entry here and the matching `spec.md` in a drop
should show only those fields.

**`spec_version` is stamped from here and incremented only here.** It says which
version of a specification a drop was built from, so a drop never raises its own —
a redraft of the same asset against the same spec carries the number it carried
before. It is `status` and `coverage` that record how far a delivery got, which is
exactly why they are the fields a library entry drops. Both readings of the field
shipped simultaneously in July 2026, because nothing on either side had said which
it was.

## What a library edition bump does, and does not do

`spec_library_version` in the front matter above is the library's **edition**.
`cdsync brief` stamps it into every round, so a drop records which edition it was
ordered against. **It is not a staleness measure, and nothing is restamped when it
moves.**

**A drop stamped against an earlier edition stays correctly stamped.** It was
ordered against that edition, and raising the number afterwards would falsify the
one fact the stamp exists to record. `templates/claude_design/templprj` is the
worked example, and it still reads `spec_library_version: 2` for precisely this
reason — that is the stamp being right, not the example being stale.

**Staleness is per asset, and it is `spec_version`'s job.** An edition bump makes
nothing stale by itself. A spec whose *text* moves raises its own `spec_version`,
and `cdsync check` then reports only the assets built from that spec. Edition 4
moved three specs — `kit`, `pitch-deck` and `positioning-icp-personas` — so those
three are what went stale, and nothing else did.

If an edition bump restamped every drop, one editorial fix would make the whole
world stale at once and the signal would mean nothing. **Two counters that never
disagree for a reason cannot measure a distance**, which is the lesson recorded
one section above, applied to the other of the two numbers.

## `formats_required` is advisory, and does not bear on completeness

A brief may carry `formats_required` — `["pdf", "pptx"]` and the like — declaring
which renderings the venture would like to end up with. **It is a request, not part
of the definition of done.** An asset is complete when its specification is
satisfied and its blanks are closed; a missing PDF does not hold it open, and no
rule in `cdsync check` reads the field.

Ruled 9 Aug 2026, after two suppliers independently read it this way and were right
to. It is written down because the alternative reading is expensive in one direction
only: a supplier who believes formats are mandatory holds back an otherwise-finished
asset, and nothing in the round reveals why.

## Bundles

Seven, in the front matter above, where they are machine-readable. A bundle is a
name a brief can use instead of a list, and a **view rather than a partition** —
`product-one-pager` is in both the seed and launch sets, `whos-who-in-the-zoo` in
both founding and seed. `index.md` tracks each asset once however many bundles
asked for it.

Two things to know about how the bundles are recorded here.

**They are defined over slugs, not over taxonomy numbers.** Claude Design defined
them over numbers, and the two do not map one-to-one: `positioning-icp-personas`
is a single deliverable covering taxonomy 1, 3 and 4. A slug is the unit that gets
ordered, delivered and counted, so a bundle has to be a set of slugs or a brief
cannot name one. The `taxonomy:` field on each entry records which numbers it
covers, so the mapping stays auditable rather than becoming folklore. Where a
count here differs from `templprj/index.md` — founding-set is four slugs there
against six numbers — this is why.

**A spec's own `bundles:` field is an echo, not a second source.** The table above
decides membership. Two records of one fact is the drift this library exists to
remove, and the echo stays only because it is useful when reading a spec alone.

**`rebrand-set` is the identity set exactly.** Claude Design defined it as "the
identity set plus 19 plus an audit inventory of what changes" — but 19,
`brand-asset-kit`, is already in the identity set, and the audit inventory is not
a taxonomy asset at all. So the bundle as written adds nothing, and the audit
inventory is a genuine gap in the taxonomy rather than a member of this bundle.
Flagged rather than invented.

## The taxonomy

Grouped by **what has to be true before the asset is writable** rather than by
design-versus-venture. That cut kept failing: a colour system is design, a pitch
deck is venture, and a messaging framework is both. The precondition is what
actually clusters, and it implies no order of production, because several groups
can be worked at once.

**The table below is where the taxonomy's size is recorded, and this document
writes no figure for it.** Numbers and slugs do not count the same — a number is
identity, a slug is what gets ordered, and `positioning-icp-personas` is one slug
covering three numbers. `cdsync doctor` reports both figures. A count restated in
prose drifts from the table it describes, which is how this very file came to
contradict its own table twice over — once on the taxonomy's size, and once on how
much of it had been written.

**For** is the audience — who the asset is written for. **INV** investor,
**CUS** customer, **TEAM** the venture's own people, **DEV** the people building
it, **PRN** printer, **PUB** the general public.

**It is not a classification.** This legend used to carry `INT internal`, and
that is an answer to *where may this be shown* sitting in a column headed *who
is this for* — which is how the two stopped being distinguishable, in twelve of
this library's own entries. Classification is its own axis with its own three
values, `public` / `internal` / `confidential`, declared per asset on its
`spec.md` and never here: the same slug classifies differently in different
ventures, so it is a per-instance fact and the library has no business asserting
one. `PUB` survives because the general public genuinely is an audience, and it
means that rather than "may be shown externally".

A slug in backticks with a `*` has an entry in this library. The rest are named
and numbered but not yet specified — the taxonomy is the menu, and no drop ever
contains all of it.

### Group 1 — Foundations (need only facts about the venture)

| # | Asset | Slug | Tier | For |
|---|---|---|---|---|
| 1 | Positioning statement | `positioning-icp-personas` * | 1 | TEAM |
| 2 | Venture thesis | `venture-thesis` * | 3 | TEAM,INV |
| 3 | ICP definition | `positioning-icp-personas` * | 1 | TEAM |
| 4 | Personas | `positioning-icp-personas` * | 1 | TEAM |
| 5 | Problem & opportunity statement | `problem-and-opportunity` | 3 | TEAM |
| 6 | Competitive & category landscape | `competitive-landscape` | 3 | TEAM,INV |
| 7 | Product principles | `product-principles` | 3 | TEAM |
| 8 | Naming & nomenclature | `naming-and-nomenclature` | 3 | TEAM,PUB |

### Group 2 — Verbal identity (needs Group 1)

| # | Asset | Slug | Tier | For |
|---|---|---|---|---|
| 9 | Voice & tone guide | `voice-and-tone` * | 2 | TEAM |
| 10 | Messaging framework | `messaging-framework` | 2 | TEAM,CUS |
| 11 | UX writing standards | `ux-writing-standards` | 2 | TEAM |

### Group 3 — Visual identity (needs Groups 1–2)

| # | Asset | Slug | Tier | For |
|---|---|---|---|---|
| 12 | Logo & mark suite | `logo-suite` | 3 | PUB |
| 13 | Colour system | `colour-system` | 3 | DEV,PUB |
| 14 | Typography system | `typography-system` | 3 | DEV |
| 15 | Iconography | `iconography` | 3 | DEV |
| 16 | Imagery & illustration direction | `imagery-direction` * | 3 | PUB |
| 17 | Motion principles | `motion-principles` | 3 | DEV |
| 18 | Brand guidelines | `brand-guidelines` * | 1 | DEV,PUB |
| 19 | Brand asset kit | `brand-asset-kit` | 3 | DEV,PUB |

### Group 4 — Design system (needs Group 3)

| # | Asset | Slug | Tier | For |
|---|---|---|---|---|
| 20 | Design tokens | `kit` * | 1 | DEV |
| 21 | Grid, layout & responsive spec | `grid-and-layout` | 2 | DEV |
| 22 | Component library | `component-library` * | 1 | DEV |
| 23 | States & interaction spec | `states-and-interaction` * | 1 | DEV |
| 24 | Pattern library | `pattern-library` | 2 | DEV |
| 25 | Accessibility standard | `accessibility-standard` | 2 | DEV |
| 26 | Theming spec | `theming-spec` | 2 | DEV |
| 27 | Data visualisation standard | `data-visualisation-standard` | 3 | DEV |
| 28 | Design system index | `design-system-index` * | 1 | DEV |

### Group 5 — Product definition (needs Groups 1 and 4, reciprocally)

| # | Asset | Slug | Tier | For |
|---|---|---|---|---|
| 29 | Information architecture & sitemap | `information-architecture` * | 2 | TEAM |
| 30 | Key flows | `key-flows` * | 2 | TEAM |
| 31 | Customer journey map | `customer-journey-map` | 3 | TEAM |
| 32 | Roadmap | `roadmap` | 2 | TEAM,INV |
| 33 | Pricing & packaging | `pricing-and-packaging` * | 2 | TEAM,CUS |
| 53 | CMS rollout plan | `cms-rollout-plan` * | 2 | DEV,TEAM |

### Group 6 — Customer-facing surfaces (needs Groups 2–4)

| # | Asset | Slug | Tier | For |
|---|---|---|---|---|
| 34 | Product one-pager | `product-one-pager` * | 1 | CUS, INV |
| 35 | Landing page | `landing-page` * | 1 | PUB |
| 36 | Sales deck & demo script | `sales-deck` | 3 | CUS |
| 37 | Case study template | `case-study-template` | 3 | CUS, PUB |
| 38 | Email templates | `email-templates` | 3 | CUS |
| 39 | Social & ad kit | `social-and-ad-kit` | 3 | PUB |
| 40 | Launch kit | `launch-kit` | 3 | PUB |
| 41 | Demo video storyboard | `demo-video-storyboard` | 3 | CUS |
| 52 | Print collateral | `print-collateral` | 2 | CUS |

**52 sits here out of sequence on purpose.** It was admitted on 30 July 2026, after
1–51 were published and cited in delivered drops. Slotting it in at 42 would have
renumbered ten live identifiers, which is the mistake that cost a full export cycle on
Lamplight. The number is identity; this table's grouping carries the meaning. Do not
tidy it into sequence.

### Group 7 — Investment (needs Groups 1, 3 and real numbers)

| # | Asset | Slug | Tier | For |
|---|---|---|---|---|
| 42 | Pitch deck | `pitch-deck` * | 1 | INV |
| 43 | Executive teaser | `executive-teaser` | 2 | INV |
| 44 | Financial summary & cap table | `financial-summary-cap-table` | 2 | INV |
| 45 | Data room index | `data-room-index` | 2 | INV |
| 46 | Investor update | `investor-update` * | 1 | INV |

### Group 8 — Team & operating (needs facts no design process can invent)

| # | Asset | Slug | Tier | For |
|---|---|---|---|---|
| 47 | Who's who in the zoo | `whos-who-in-the-zoo` * | 1 | TEAM, INV |
| 48 | Hiring plan & role scorecards | `hiring-plan` | 2 | TEAM |
| 49 | Job description template | `job-description-template` | 3 | PUB |
| 50 | Ways of working | `ways-of-working` * | 2 | TEAM |
| 51 | Decision log | `decision-log` | 3 | TEAM |
| 54 | Go-to-market plan | `go-to-market-plan` * | 2 | TEAM,INV |

## Eight assets are genuinely both design and venture

Named rather than picked between: `messaging-framework` (10), `landing-page` (35),
`product-one-pager` (34), `pitch-deck` (42), `sales-deck` (36), `launch-kit` (40),
`customer-journey-map` (31), `naming-and-nomenclature` (8).

Each is unbuildable without both framings, which is the strongest argument for
grouping by precondition and for `assets/` staying flat.

## Three dangling references, found in the specs as delivered and repaired here

All three were one fault: a dependency naming a slug that does not exist, so it
could never resolve.

- `pitch-deck` named `positioning` in both `depends_on.hard_assets` and
  `depends_on.reciprocal`. No such slug; the asset is `positioning-icp-personas`.
- `positioning-icp-personas` named `pricing` in `depends_on.reciprocal`. No such
  slug; the asset is `pricing-and-packaging` (33). **Found 30 Jul 2026**, and not
  recorded until later, which is why this section once said "one".

**They were left as delivered until 9 Aug 2026, deliberately, so that they would
arrive as findings in the next round rather than being silently corrected. That
reason is now spent.** The delivered projects are delivered and the loop does not
run back to Claude Design for them, so no round remains for the finding to reach.
A reference that can never resolve, preserved for a report that will never be
written, is worse than a repair with the finding kept — which is what this section
now is. The two specs each moved a `spec_version`, so `cdsync check` reports the
drops built from the old ones as stale, advisory, with the remedy named.

**A fourth thing surfaced during the repair, and is flagged rather than invented.**
`positioning-icp-personas` declares `pricing-and-packaging` reciprocal, and
`pricing-and-packaging` does not declare it back. `reciprocal` is symmetric by its
name, nothing enforces that, and no check can see it — so this is a real
disagreement between two delivered specs rather than a typo. Writing the missing
half would be this library inventing a dependency Claude Design never declared,
which is the drop-repair mistake one level up. Recorded, not resolved.

Distinguish all of these from a dependency that is legitimately **not built yet**,
which is correct to declare and reports the same way. `component-library` requires
`pattern-library`: real, in the taxonomy, and unwritten. `cdsync check` reports both
cases as advisory, which is right — the difference is that one will resolve when the
spec is written and the other never could.

`grid-and-layout` held that example until it was specified on 30 Jul, along with
`colour-system`, `typography-system`, `logo-suite`, `print-collateral`,
`social-and-ad-kit` and `email-templates`. **Most of the taxonomy is still
unwritten, and `cdsync doctor` says how much** — no figure is recorded here, for
the reason given under the taxonomy above.
