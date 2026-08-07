# 6 August, second half -- the rename's missing two, and G&G turns out to be integrated

Day record, continuing `release-0.1.0-and-going-public.md`. The live board carries the shapes; this is the narrative behind them.

## What happened

Picked up to start WP-07 and did not get there before finding that **the rename of 6 August had missed two repositories entirely**: `~/Devel/prj/Sites/gyreandgymble` and `~/Devel/prj/Sites/snorkeltoast`, 28 and 26 occurrences. Both were then completed, as was a third miss inside this repository. Only afterwards was WP-07 taken, and its premise turned out to be wrong for the project it named first.

## The finding that matters most

**A positive control validates the INSTRUMENT, not the SAMPLING FRAME.**

ST0004 closed 11/11 on a bar of *"five repositories -- this one and the four siblings that carried the name"*. Every criterion was satisfied as written, each with a paired positive control reconciling exactly against a pre-mutation baseline. The controls were sound. Each one proved a probe could hit **inside the repository it was pointed at**, which is a statement about the instrument.

**Nothing in that contract asked what enumerated the repositories.** The survey that drew up the list walked `~/Devel/prj/*` and never descended into `Sites/`. The italicised clause is a claim about the world; the five names after it are the set actually checked, and the gap between those two is invisible to every control in the file.

The same blind spot recurred in this session's own first survey, which reported both repositories as MISSING before the search was widened -- so it is not a one-off slip in the enumeration but a property of where those two projects sit.

## The third miss, inside this repository

`templates/_test/Acme/` is gitignored, so a sweep working from tracked content never saw it. 30 occurrences and a `vboot.json`. **The filename was the live defect**: the tool resolves through `cdsync.json` now, so `cdsync brief` run there would have reported *"no cdsync.json here"* with the configuration sitting beside it under its old name. ST0001's Acme round two is assembled and unsent in that tree, so it is live working material.

AC-00.1 claimed zero on disk *"including untracked and ignored files"* for this repository. It was false in exactly the region it named.

## How the completion was verified

- **Adjacency enumerated before substituting**, in all three cases. Every character adjacent to every match, checked for alphanumerics -- none, so no word is broken by a plain replacement.
- **Before/after counters round the whole pass.** 50 to 0 across eight files in the two siblings, reconciling file by file; 30 to 0 in Acme.
- **The strongest available check, and it was free**: the four repo-owned `design/.gitignore` copies were made byte-identical, and the rename had split them into two pairs -- Baize and Lamplight at `d230e257`, the two missed ones at `8492d034`. All four hash to `d230e257` again. **Byte-identity restored is a stronger statement than "the string is gone".**
- **`BOOTSTRAP-CD.md` regenerated with the renamed tool and diffed**, rather than trusted after substitution, and pointed at `design/system/` rather than `design/`. G&G reports `**17 assets**`, matching its own index -- the control that the generator found the tree. Zero name-related differences.

## Three on-disk occurrences remain, deliberately

A dated backup under `Utilz/.backup/` -- editing inside a backup corrupts it. Laksa's `_build/` release output -- regenerates. And a base64 image fixture in a vendored dependency of Lamplight whose bytes happen to contain the letters; **it matches only a case-INSENSITIVE probe**, and the substitution is case-sensitive.

## Two failures of this session's own, recorded rather than smoothed over

**A live session in snorkeltoast committed four files this session had just edited**, into a commit of its own called *"Content for new laksa release"* at 12:56. The work survived and is mislabelled. The tree read *clean* immediately afterwards, which looked at first like the edits having failed to apply -- the reflog is what settled it. **The write-into-another-tree hazard is not only loss.**

**An AC-00.10 violation, committed here.** Staging six named files in the Acme fixture swept 20 lines of unrelated uncommitted work -- a generated numbering block -- into a commit labelled a rename. **An explicit FILE LIST is not an explicit pathspec**: it governs which files move, not which hunks inside them. The arithmetic is what caught it, every other file reconciling exactly against its occurrence count and one not. The commit message was amended to say so rather than left misdescribing itself.

## WP-07, and a premise that was false

WP-07 opened on *"none has been built against"*. **For Gyre & Gymble that was wrong.** `theme/theme.css` carries the entire Oat & Olive palette and `theme/layout.liquid:92` loads the compiled result. The premise was written from the drop's side of a boundary where an application is invisible -- and a drop cannot see an application, by the same ruling that says Cdsync has no application-side check.

What was actually missing was the link back. The palette is a **hand transcription across three naming conventions** -- the kit's own, daisyUI's semantic slots, Tailwind v4's namespaces -- with nothing holding it to `kit/tokens.json`. The kit names this exact shape as a defect for the pitch deck under `drift.deck_redeclares_the_palette`; **the site theme is a third copy, and a drop's drift record only scans the drop.**

**61 of 62 tokens carried, zero disagreements.** 61 + 1 = 62 closes exactly; the 62nd is `--color-write`, print-only and correctly absent from a web theme.

**Agreement is not equality throughout, and that rule was written down nowhere.** The kit publishes `64px` where the theme publishes `clamp(40px, 2.86vw + 28.6px, 64px)`, in five places. The kit's value is the theme's **ceiling**. A theme that stopped reaching it would look reasonable at every viewport width and be wrong at all of them.

`tools/check-theme-against-kit.py` went into G&G rather than here, because whether an application still agrees with its specification is the application's business. Four planted faults -- a colour changed, a ceiling lowered, a token deleted, a token added to the kit -- all detected, and the script refuses to report if one is missed.

**Caught while writing it:** the first version counted theme-to-kit *pairs* and would have generated a document claiming *"67 of the kit's 62 tokens"*. Several theme names map to one kit token. A generated document making a false claim is this project's most-repeated shape, and it nearly went into one written to prevent exactly that.

## Staleness, now four copies

The regeneration diff found both `BOOTSTRAP-CD.md` files stale for reasons unrelated to the rename. G&G's inventory was missing `business/` (11 files) and it was embedding a **superseded revision** of its own 4 August addendum. snorkeltoast's had `docs/` at 92 against 93 and `email/` at 3 against 7, and was missing a whole section. With Baize's steel-thread high-water that is **four**, against the two WP-08 records -- the advisory staleness rule has now been earned four times over.
