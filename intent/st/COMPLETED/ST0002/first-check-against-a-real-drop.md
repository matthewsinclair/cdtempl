---
verblock: "30 Jul 2026:v0.1: matts - What check found, and what found check, on the first real non-Acme drop"
intent_version: 2.18.0
---

# The first `check` against a real drop that Cdsync did not produce

Run 30 July against Gyre and Gymble's export, which arrived already in Cdsync shape. This is the measurement ST0002 said would settle the open questions "on the evidence of a real drop", and it did more than that: **the drop was clean, and every blocking finding was a bug in the tool.**

| Run | Result | What changed |
| --- | ------ | ------------ |
| 1 | `error 17 assets checked -- 4 blocking, 52 advisory` | as found |
| 2 | `ok 17 assets checked -- clean, 52 advisory` | binary, script-block and colour-function fixes |
| 3 | `ok 17 assets checked -- clean, 35 advisory` | currency and frontmatter-quoting fixes |

Four blocking findings. Four false positives. Seventeen more false advisories underneath them. **The drop never had a defect.**

Every one of the 35 that remain is legitimate, and accounted for exactly: 12 + 5 + 12 + 5 + 1.

## The root cause, three times over

Every one of the failures below is the same sentence: **the check's verdict depended on the environment rather than on a decision the code made.** Three different rules, three different environmental accidents, one shape.

### 1. Binary files were skipped by grep's heuristic, not by us -- FIXED

`each_scannable_file` emitted every file including photographs, and `each_colour_in_file` grepped them. A 2.4M JPEG in Baize's drop carries **eleven** byte runs matching the hex pattern. BSD grep suppresses all eleven because it sniffs binary content itself; force it through as text with `grep -a` and every one surfaces as *blocking*.

So the check passed on this machine by luck. A grep build that does not suppress, a `--binary-files=text` anywhere in the environment, or a photograph whose first block carries no NUL, and the identical drop fails.

**Fix:** `is_binary_file` in `lib/scan.sh` makes the decision explicitly, by content -- a NUL byte in the first 8000 bytes, the same heuristic git uses, the same answer on every platform. Deliberately not an extension list: that is a maintained exception list that goes stale the first time an unlisted format arrives, and it fails in the direction that silently stops checking.

### 2. Two scanners over the same markup disagreed about what prose is -- FIXED

Three assets were blocked with `status: complete but N blanks remain`, on these "blanks":

    pitch-deck              [0]
    pricing-and-packaging   [k]
    product-one-pager       n('kit'), n('product')

All JavaScript, inside `<script>` blocks in `.dc.html` files. `const parts=[]; if(n("product")) parts.push(...)`.

**The neighbouring rule in the same file already knew better.** `each_metric_in_file` strips `<style>` before looking for metrics, because a width is not a claim. `each_blank_in_file` stripped fenced blocks, `` `code` ``, `<code>` and `<pre>` -- but not `<script>`. Two scanners reading the same markup with different ideas of what counts as content.

That is precisely the failure the `[$0.0m]` currency bug came from, recorded in the board watch-outs as **"when adding a rule, check what the neighbouring rule in the same file already believes"**. It recurred because nobody checked.

**Fix:** `each_blank_in_file` now strips `<script>` blocks, scoped to the block rather than the file, so prose beside a script is still checked. Pinned by a test.

### 3. A colour function is not a colour -- FIXED

Rule 4 blocked `imagery-direction` for carrying colours absent from the kit:

    hsl(d[i], d[i + 1], d[i + 2])    rgb(p, q, t)    rgb(h, Math.min(1, s)

`gg-wash.js` is a colour-space converter. Eight matches, not one a literal. The last one is matched with its parenthesis unbalanced, which is the tell that the pattern was reading code.

Skipping `.js` would be wrong twice: a real `#d97757` in a script is a genuine leak and the module says so, and a path rule is the exception list this file already refuses once.

**Fix:** `normalise_colours` now tests whether a colour function's arguments are numbers. An argument beginning with a digit, sign or point is a number; anything else is a name. `120`, `50%`, `.5`, `-3` pass; `r`, `p`, `d[i`, `Math.min(1` do not.

### 4. The currency matcher matched half a letter -- FIXED

Rule 3 reported prices with the pound sign shattered. Checked at the byte level rather than by eye, because a replacement character in a terminal can be a display artefact: the output genuinely held a **lone `A3`** (`a3 31 32`), not the valid `C2 A3`. Real corruption, not rendering.

`each_metric_in_file` matched `[$£€¥]`, a bracket expression holding multibyte characters. Under a C locale that class is a set of **bytes**, and `£` is two of them. The class therefore matches the *second* byte on its own and starts the match mid-letter, dropping the first. This machine runs `LC_ALL=C`, so that was the default behaviour here, not an edge case.

**Fix:** alternation, `(\$|£|€|¥)`, which matches each symbol as a complete sequence and so cannot begin inside one.

**Rule 1 already had this right.** `each_blank_in_file` strips a leading currency symbol using alternation, for precisely this reason. Two rules in one file, one concept, two spellings, one of them wrong -- the third instance of that exact shape in this session. The fix carries a note that if they ever disagree again they should become one shared definition rather than a third careful copy.

### 5. The frontmatter parser kept quotes on all but the first list element -- FIXED

`fm_scalar` trimmed surrounding whitespace **after** deciding whether a value was quoted. The second and later elements of an inline list arrive carrying the space that followed the comma, so ` "social-and-ad-kit"` never matched the quoted pattern and kept its quotes for the rest of its life.

Rule 2 then compared `"brand-guidelines"` against the taxonomy and reported a slug that **is** in the library as absent from it. The first element of every list was clean while the rest were not -- an asymmetry that reads as a data problem and is a parser one.

**Fix:** trim before classifying, then trim again after stripping a trailing comment. **17 of the 22 dependency advisories disappeared**, and the remaining 5 are correct.

## Tests

**163 passing, 0 failures** -- 153 baseline plus 10 new. Shell critic clean on both changed modules.

Covering: a binary file carrying hex bytes is not scanned; a *text* file with a binary-looking extension still is (pins content-over-extension); `is_binary_file` decides by content; a bracket in a script block is not a blank; a blank in prose beside a script block still is; a colour function with named arguments is not a colour; one with numeric arguments still is; `fm_scalar` strips quotes from a value with leading whitespace; `fm_list` returns every element of an inline list unquoted; a currency symbol is matched whole rather than by its second byte, under `LC_ALL=C`.

## What the 35 surviving advisories say

All 35 are legitimate. The 17 that vanished were the parser bug.

| Cause | Count | Verdict |
| ----- | ----- | ------- |
| `no entry in the spec library` | 12 | **Legitimate.** Decision 2 evidence -- 12 of 16 slugs sit outside the built library, reported as advisory rather than blocking, exactly as designed |
| dependency `not in the taxonomy` | 5 | **Legitimate**, and see below -- the tool and the supplier independently agree |
| rule-3 metrics with no `illustrative` marker | 12 | Now rendering correctly. Mostly `100%`, `3%`, `7%` -- widths and opacities in prose and markup. Worth a separate look |
| rule-5 `coverage ... is not in N/M form` | 5 | **The finding, not a bug.** See below |
| `kit: no spec_version stamped` | 1 | Legitimate and trivial |

### The tool and the supplier independently agree on the taxonomy gap

The 5 surviving dependency advisories name exactly three distinct slugs:

    cms-rollout-plan     go-to-market-plan     print-collateral

Those are **precisely** the three that G&G's `RETURN.md` declares under *"Three proposed slugs ... not in your list"*, each with its refused near-miss recorded in `notes/slugs-and-what-they-do-not-cover.md`. The supplier said which three it invented; the check found the same three from the other direction, without being told.

That is worth more than either statement alone. It corroborates the supplier's account of its own work, and it demonstrates the rule doing the job it exists for once the parser stopped drowning it in false positives. **Decision 2 is now a three-slug question, not a twenty-two-slug one.**

### `coverage` in N/M form is the wrong shape, and the drop proves it

Five assets were flagged because their `coverage` is prose rather than `N/M`. But the prose is the good part:

> Nine screens, desktop and mobile, with a working basket including free-post logic, a booking flow, a gallery of eight collections and an enquiry path for one-of-one work. No payment, no routing, no stock decrement.

`9/9` would carry none of that. Decision 2's second option was "map onto generic types with `coverage`" -- and here is a real supplier using `coverage` exactly that way, unprompted, and the rule rejecting it. **The rule should accept prose, or the field needs splitting into a count and a statement.**

## What this changes

- **`check` is now usable against a real drop.** It was not before: any drop containing a photograph or a script was at the mercy of the local grep and locale.
- **G&G passes clean.** Its 16 assets, 11 complete and 5 partial, survive every rule the tool has. That is a real result about the drop and about the tool.
- **Three of the four bugs were found only by running against material Cdsync did not produce.** The templates and Acme never exercised a photograph, a colour-space converter, or a document with a script block in it. Synthetic fixtures agreed with the bugs.
