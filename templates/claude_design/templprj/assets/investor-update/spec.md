---
asset: investor-update
name: Investor update
spec_version: 1
kit_version: 1
form: A
tier: 1
group: 7
audience: [investor]
status: spec-only
inputs_missing:
  - "the period this covers"
  - "the metric set — and it must be the same set every period"
  - "the actual numbers, including the ones that went the wrong way"
  - "the asks, specific enough to act on"
depends_on:
  hard_facts: [period-metrics, asks]
  hard_assets: []
  reciprocal: [roadmap, hiring-plan]
bundles: [operating-set]
blanks: 38
blanks_unique: 16
blanks_source: computed
---
# Investor update — specification

## What it is

The recurring one. Sent monthly or quarterly, in a fixed shape, so that the
recipient can read it in two minutes and compare it against the last one without
re-learning the format.

**The fixed shape is the entire value.** An update whose sections move each period
cannot be compared, and an update that cannot be compared is a newsletter. This is
the one asset where consistency matters more than quality.

## The standard shape

Settled practice, and short:

| Section | Carries |
|---|---|
| Headline | One sentence: the period in a line |
| Metrics | The same table every period, with last period beside it |
| What went well | Two or three things, specific |
| What did not | Two or three things, equally specific |
| Asks | What you need, named, with who could provide it |
| Runway | Months remaining, and the date that number is calculated from |
| What is next | The one thing the next period turns on |

**Three sections are load-bearing and get softened.** *What did not* — an update
without misses reads as marketing and trains the recipient to discount the rest.
*Asks* — a vague ask is not an ask; "intros to heads of finance at Series B SaaS
companies" is, "any intros welcome" is not. *Runway* — omitting it is read as bad
news, always, and usually correctly.

## Formats produced

- `investor-update.md` — the source and the only artefact.

Form A because an investor update is sent as an email or a plain document, and a
designed one signals effort spent in the wrong place.

## Template form

**Form A — document with blanks**, and the most repeatedly-used template in the
suite: it is filled in every period rather than once. That changes what a good
template is — the structure must survive twelve fillings-in without anyone wanting
to restructure it, so it stays short and the metric table stays fixed.

## Definition of done

1. **The metric table matches the previous period's** exactly, row for row. A
   changed row is a decision to be stated, not a formatting choice.
2. **Last period's number is beside this period's.**
3. **The misses section is non-empty**, and as specific as the wins.
4. **Every ask is actionable** by a named kind of person.
5. **Runway is stated**, with the date it is calculated from.
6. **It fits on one screen** without scrolling twice.
7. **Every number is real.** Illustrative numbers do not belong in this asset at
   all — mark them or remove them, and prefer removing them.
8. **No blanks remain.**

## What the brief must carry

Beyond the universal header:

- The period.
- The metric set — fixed at the first update and changed only deliberately.
- The numbers, including the ones that went the wrong way.
- The asks.
- The runway figure and its as-at date.

## Notes

Reciprocal with the roadmap and the hiring plan: the *what is next* section and the
roadmap's *now* column are the same claim, and they will contradict each other
unless one is derived from the other.
