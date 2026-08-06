---
verblock: "29 Jul 2026:v0.1: matts - Round three review: composite split accepted, exclusion reversal accepted, blanks moves to computed"
---
# Answer to round three -- for Claude Design

Stopping at the break rather than working around it was the right call and the argument was worth the round. Both of your changes are accepted, one of them a reversal of a decision I made.

## What I verified rather than took on trust

| Check | Result |
| ----- | ------ |
| **Colour check, declaration-based exclusion** | **passes** -- four runtime files skipped, five artefacts checked, zero unmatched literals |
| Zoo renders | correct: running header sits above the H1, so the `doc-page` fix holds |
| Zoo prohibitions | zero radius, zero shadow, no webfont, four gradients all hatch |
| `pitch-deck` blanks | **64 / 45 -- exact**, fixed from last round |

## Accepted: `design-system` is a bundle

Not close, on your reasoning. The break is not the directory, it is the front matter: one `status`, one `blanks`, one `inputs_missing`, against nine things with independent readiness. A venture with a finished component library and no data-visualisation standard cannot be described by one status field, and `blanks: 300` across nine documents estimates nothing. The composite defeats the mechanism, and the mechanism is the point.

That it invents nothing is what settles it. The taxonomy already had them separate; round one collapsed them for Tier 1 convenience, and the structure is rejecting the convenience rather than the design.

Both consequences accepted. **Tier 1 goes to eleven**, and the five parts dropping to Tier 2 and 3 is more honest than a composite that hid them. **`kit/` is asset 20 at the target root**, named as a deliberate exception -- you are right that this is better stated than discovered.

Round four proceeds on your revised order: `design-system-index`, `component-library`, `states-and-interaction`, then the four held behind the stop.

## Accepted: declaration-based exclusion, and my decision was wrong

You turned my own argument back on me correctly. `support.js` cannot move, because the authoring runtime emits it as a sibling and that path is not yours to set -- so a path-based rule needs `support.js` named as a special case, which is the maintained exception list that prohibitions-over-instructions exists to avoid, arriving one level down. Exactly the failure I was trying to prevent, reintroduced by my own fix.

`vendor/` stays for legibility, on your reasoning: a directory says "not yours" to a human at a glance, where a comment in line one of a 136KB minified file does not. The check simply must not depend on it.

**One precision fix.** The pattern matches prose *about* generated things, not only generated files. `exports/README.md` is currently excluded because its first line reads "Generated. Never hand-edited." Harmless today -- READMEs carry no colour -- but as written, any file that discusses generation exempts itself from a check it should pass. Tighten it: require the marker inside a comment (`//`, `<!--`, `#`) rather than anywhere in the first ten lines. That keeps every real case and drops the documentation false-positive.

## `blanks` moves from declared to computed

This is the one thing I am changing rather than accepting.

| Asset | You declare | I count |
| ----- | ----------- | ------- |
| `pitch-deck` | 64 / 45 | 64 / 45 |
| `positioning-icp-personas` | 58 / **54** | 76 / 43 |
| `whos-who-in-the-zoo` | 62 / 31 | 54 / 28 |

**`blanks_unique: 54` for positioning cannot be right under any counting convention.** Sixteen placeholders repeat, accounting for 33 repeat occurrences -- `[value]` nine times, `[yes/no]` six, `[role]` five. Declaring 54 unique out of 58 requires four repeats in the whole document.

The other gaps run in opposite directions per asset, so a single convention gap does not explain them either.

That is two rounds in which these numbers have been wrong, in three different ways, by someone with every incentive to get them right. The conclusion I draw is not that the counting needs specifying harder. It is that **a hand-maintained count of a mechanically countable property will always drift**, and the check should not be verifying it.

So: **`cdsync check` computes `blanks` and `blanks_unique` and writes them.** You declare what needs judgement -- `status`, `inputs_missing`, `spec_version` -- and the tool computes what is fact. The failure mode is removed rather than detected, which is the same move as enforcing neutrality with a kit instead of asking for restraint.

You still need to answer one question, because the tool cannot guess it: **what is in scope for the count?** Specifically, do these count -- frontmatter placeholders like `[date]` in a verblock; literal examples in backticks such as the `` `[bracketed]` `` in a completion checklist; placeholders inside `spec.md` itself; placeholders inside a `data-props` script block? Write the answer into `kit.md` beside the placeholder treatment and I will implement exactly that.

Until it is computed, leave the fields in and treat them as an estimate rather than a claim.

## Two smaller things

**The `doc-page` timing note is the right kind of finding to record.** Invisible in the source, not asset-specific, and it lands in `vendor/README.md` where the next person to mount `doc-page` will actually be. Nothing to change; worth saying it was the right call, because that class of finding is easy to fix silently and never write down.

**`_Archive/templprj-1729` is left untracked.** A 560KB snapshot of round two is what git history already is, so the drop does not need to carry its own. Not deleted, just not committed -- say if you want it kept for a reason I am not seeing.

## Round four

Proceed on your order. Two things to carry in:

- The tightened exclusion pattern, if you agree with the comment-scoped version.
- The `blanks` scope answer in `kit.md`.

Same instruction as last time, which earned its keep: if `component-library` breaks the shape -- and as the largest single artefact in the taxonomy it is the next most likely to -- stop and say so rather than working around it.
