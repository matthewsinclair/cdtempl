---
verblock: "02 Aug 2026:v0.2: matts - Filled from the ST0001/ST0002 close-out carry-forward"
wp_id: WP-02
title: "Rule 4 -- two rulings and what follows"
scope: Medium
status: Not Started
---

# WP-02: Rule 4 -- two rulings and what follows

## Objective

Rule 4, the colour leak guard, was taught the modern colour spaces on 2 August. The first real kit it could then read produced **15 blocking findings on matthewsinclair, and only 6 of them are leaks.** Two questions came out of that, and **neither was decided unilaterally** because both change what the rule means rather than what it can see.

Until they are settled, rule 4 is noisy on any kit that documents its own colours -- and **a guard people learn to ignore is worse than no guard.**

## The two questions

### 1. A hex tabulated beside its own token -- fourteen of the fifteen findings

`kit/colour.md` carries a table with an *Approx hex* column:

```
| Token    | oklch                 | Approx hex | Use                            |
| `--bone` | `oklch(96% 0.014 92)` | `#F5F0E4`  | Page ground. The default plane |
```

`tokens.json` publishes only the `oklch`. The check cannot tell the two spell one colour, and **deliberately does not try** -- comparing across colour spaces needs a transform, and approximating it would make two distinct kit colours collide and report a leak that is not there. That ruling stands and is not what is in question.

What is in question is which side moves:

- **`tokens.json` publishes the approximations too**, making them kit colours, and the finding disappears honestly. Costs a round with Claude Design.
- **The rule learns that a value tabulated beside a known kit colour is documentation of it.** Narrow, defensible, and a heuristic -- so it needs stating as a rule rather than sliding in as a fix.
- **The column goes.** Cheapest, and loses something a reader of the kit actually uses.

### 2. A colour named in order to forbid it

`kit/colour.md:31` reads *"Blue-shifted near-black, never `#000`"*. The kit names the colour **to prohibit it**, and rule 4 reports it as a leak.

`scan.sh` already met this shape twice and ruled both times -- `each_blank_in_file` skips code spans and fences, because a bracketed placeholder inside a "no blanks remain" checklist documents the marker rather than being an instance of it, and `each_metric_in_file` skips `<script>`.

**The analogy does not carry over unexamined, and that is the whole difficulty.** A colour inside a **fenced** block is usually a *declaration* -- CSS in a code example is exactly where a real leak would live. An **inline** code span in prose is far likelier to be naming than declaring. So the two may need different treatment, which neither existing exclusion gives them.

### 3. Vendored upstream material, and whose tokens a leak is measured against

Added 2 August, from G&G round 4. The drop now vendors the Organic system whole at
`kit/_ds/organic-22b2e68b-.../`, and `check` reports **8 blocking rule-4 findings, every one
of them inside that directory** -- `styles.css`, `theme.json`, `_ds_manifest.json`,
`readme.md`, and the deck/landing template runtimes.

None is a leak. **Organic's palette is upstream material and was never meant to be Gyre &
Gymble's token set** -- `kit/tokens.css` is precisely the override layer that retunes it, so
the two disagreeing is the design working rather than failing. Some of the reported values
are not even Organic's: `deck-stage.js` and `image-slot.js` carry the design tool's own
chrome colours.

So the question is **which tree rule 4 measures against**, and it is a third shape distinct
from the two above -- not documentation-versus-declaration, but **ours versus upstream**.
Candidates: rule 4 skips a vendored dependency directory; or `_ds/`-style vendor trees are
declared not-kit the way `addenda/` is declared protected; or the kit declares its own vendor
paths. **Not decided, and not guessed at.** Until it is, rule 4 blocks on any drop that
vendors what it depends on -- which is the shape round 4 was built to deliver.

## Deliverables

- A ruling on each, recorded on the `cc` board under `## Decisions` with its reasoning.
- Whatever implementation follows, with tests mutation-proven **and** confirmed to exercise the changed code path.
- `help/check.md` updated if the reach or the meaning moves. **A rule's published reach is part of the rule** -- guarded by a test against `CDSYNC_COLOUR_RE`.
- `check` re-run across all six trees afterwards, with the before/after recorded. This changes what a rule *means*, so the blast radius is the evidence.

## Dependencies

Needs hv. Both are scope questions about what the rule asserts, not bugs.

## Notes

The six genuine leaks are a separate matter and belong to the venture, not the tool: `oklch()` values in `accessibility.md`, `colour.md` and `components.md` that are not tokens in `tokens.json`, so there is nothing to implement them from. They are named in the Laksa handoff note. **Cdsync never repairs a drop.**
