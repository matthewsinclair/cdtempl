# cdtempl check

Hold a drop against its own specifications.

```
cdtempl check [--target PATH] [--no-write]
```

Walks every asset in the target, computes what can be computed, and applies six
rules. Exits non-zero if any blocking rule fails.

## Options

| Option | Effect |
|---|---|
| `--target PATH` | Check this target instead of the resolved one |
| `--no-write` | Report only; do not stamp computed counts back into each `spec.md` |

## What it computes

`blanks` and `blanks_unique`, written back into each asset's `spec.md` unless
`--no-write` is given.

These are **never read as declared**. They were declared by hand twice and were
wrong both times, in three different ways, by someone with every incentive to get
them right — including one `blanks_unique` that was arithmetically impossible
against its own document. A hand-maintained count of a mechanically countable
property will always drift, so the tool owns it.

`blanks` counts occurrences, because that is the number of substitutions a person
faces. `blanks_unique` counts distinct strings, because that is the number of
decisions. Neither alone is honest.

The scope it counts over is written in the drop's own `kit/kit.md`, not here. The
placeholder treatment is what changes, so the spec lives with the treatment.

## The six rules

| # | Rule | Severity |
|---|---|---|
| 1 | `status: complete` alongside non-zero blanks is a contradiction | **blocking** |
| 2 | A drop's stamped `spec_version` against the library, to detect staleness | advisory |
| 3 | Illustrative numbers must be visibly marked in the artefact | advisory |
| 4 | Every colour literal must appear in `kit/tokens.json` | **blocking** |
| 5 | `status: partial` requires `coverage`; `complete` requires it to be total | advisory |
| 6 | `classification` is declared, is a known value, and is not conflated with `audience` | advisory |

Only 1 and 4 block. Rule 4 is the leak guard — it is what makes neutrality a
property of the repository rather than of whoever last touched a file — and rule 1
is a drop lying about its own state. The rest are worth knowing and not worth
stopping for.

Rule 2 also reports a dependency naming a slug that is not in the taxonomy. A
dependency on an asset that is real but **unbuilt** is correct and is not flagged:
`component-library` requires `grid-and-layout`, which is first in Tier 2.

Rule 2 knows the `unassigned` convention: an asset ordered ahead of the library
stamps the literal word, which is **silent while the library holds no entry** and
becomes an advisory — rebuild against the new specification — the day it gains
one. A number on a library-less asset is flagged as a number nobody issued, and a
stamp that is neither a number nor `unassigned` is named rather than compared.

## The document staleness advisory

Before any rule runs — and even when the tree refuses the asset walk — `check`
warns if the target's `BOOTSTRAP-CD.md` is older than the repository it
describes. **Repository-scoped**, because what stales the document (a new steel
thread, an ADR) usually lives outside the design tree; over **tracked and
untracked-unignored files only**, so build churn cannot make it cry wolf. It is
a warning and never blocks, and it is deliberately not a numbered rule: the six
rules judge what Claude Design delivered, this judges Cdtempl's own output.
`doctor` prints the same line. The remedy is always to regenerate — a stale
snapshot hands Claude Design numbers the tree has moved past, and the last such
collision cost a full export cycle.

**Rule 6 cannot block, and that is forced rather than chosen.** Classification governs
where material may be shown, never whether it is committed, and it "is not a delivery
filter and must not be used as one" — so a blocking rule here would refuse a drop on the
strength of a classification, which is precisely the use the ruling forbids.

Its second half catches the conflation: `internal` or `confidential` sitting in
`audience`. Neither says anything about who a thing is *for*, so both can only have
arrived in that field by conflation. **`public` is never flagged** — the general public
genuinely is who a landing page is for, so the word appearing in `audience` proves
nothing.

## What rule 4 skips, and why by declaration

Files that declare themselves generated **in a comment near the top** —
`@generated`, `GENERATED`, `do not edit`, `Copied … starter`.

Not by path. The first design excluded `vendor/` by path and was wrong:
`support.js` cannot be moved there, because the authoring runtime emits it as a
sibling of every `.dc.html` and that path is not the author's to set. A path rule
therefore needs `support.js` named as a special case — which is exactly the
maintained exception list that the whole prohibitions-over-instructions approach
exists to avoid, reintroduced by the fix meant to prevent it.

Comment-scoped on purpose: a `README.md` that says "generated" in prose is prose,
and gets checked like anything else.

Fully transparent values are not colours. `rgba(0,0,0,0)` is the `transparent`
keyword spelled long-hand and carries no hue, so it has nothing to leak. Values
with alpha above zero are compared on hue alone, because the kit has no alpha
tokens and opacity is a separate axis from palette.

### What counts as a colour literal

`#hex` in three, six or eight digits, `rgb()`, `rgba()`, `hsl()`, `hsla()`,
`oklch()`, `oklab()`, `lch()`, `lab()` and `color()`.

`rgb()` and `rgba()` collapse to hex, so a value written one way in the kit and
another in an artefact still compares equal. **The modern functions do not.**
They are compared as normalised text — same colour, same spelling, whatever the
spacing — because converting them to hex properly needs a colour-space transform,
and converting them approximately is worse than not converting at all: two
distinct kit colours that round to one hex value would report a leak that is not
there.

The consequence is worth stating plainly. **A colour and its hex approximation
are two different values to this rule.** A kit that publishes
`oklch(96% 0.014 92)` in `tokens.json` and documents `#F5F0E4` beside it as a
convenience will have that hex reported as absent from the kit, because as far as
this rule can tell, it is.

A function whose arguments are identifiers rather than numbers — `rgb(r, g, b)`,
`oklch(l c h)` — is a colour being computed, not a colour being declared, and is
skipped. A colour-space converter is code, not a palette.

### When rule 4 cannot run

The rule needs both sides. If `kit/tokens.json` is missing, or carries no colour
in any form above, there is nothing to compare against and **the rule is skipped
with a warning rather than passed**. A kit defined entirely in a colour space the
scanner does not read is invisible to it, and a leak in that space would go
unreported — so the run says so rather than reporting a clean rule it never
executed.

## Exit codes

| Code | Meaning |
|---|---|
| 0 | No blocking failures. Advisories may still be present |
| 1 | At least one blocking failure |
| 2 | Usage error, or no drop at the target |

A checker that passes on an empty directory is worse than no checker, so a target
with no `assets/` and no `kit/` is a failure rather than a clean report.
