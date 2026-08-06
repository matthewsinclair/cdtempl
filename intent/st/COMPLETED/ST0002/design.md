# Design - ST0002: Port four established projects to the Cdsync protocol

## What this thread is

Four existing projects get a design-system record under the Cdsync protocol,
delivered by Claude Design as a downloadable zip per project and installed with
`cdsync import`. The end state is that each project has a browsable design system --
interlinks and tables of contents, servable locally -- inside its own repository.

**Nothing that already exists may be lost.** Two of the four carry a complete,
agreed, delivered design programme. That constraint outranks every convenience
below it.

## The two halves, which are not alike

The first thing that turned out to matter, and it inverts the obvious order of work.

| | Projects | Where the design lives | Job |
| --- | --- | --- | --- |
| **A** | Lamplight, Baize | Extracted; drop landed in `intent/_inbox/` | **Port** -- re-express agreed work in the Cdsync protocol |
| **B** | gyreandgymble, snorkeltoast | Designed inside Claude Design, **never extracted** | **Extract straight into Cdsync's shape** |

Group B is the easy half **only if the brief is written before the extract**. An
extract run today produces the Group A shape, and the number of ports goes from two
to four. hv asked whether to extract first; the answer is no, and this table is the
reason.

## Survey, 30 Jul 2026

All four repositories were clean at survey time, which is the safety net for
everything that follows.

| | Lamplight | Baize | gyreandgymble | snorkeltoast |
| --- | --- | --- | --- | --- |
| Size | 34G | 1.8G | 596K | 83M |
| HEAD | `5fde625c0` | `34443ad` | `9d6c11a` | `0f7582c` |
| `design/` holds | fonts + five product logo sets, 153 files, 26M | 3 logos + 7 licensed stock, 14 files, 21M | 6 icons | 6 logo variants + 2 images |
| Design system | **Acton**, 6 documents | 8 documents | none locally | none locally |
| Venture documents | 16 `.dc.html`, confidential | 4 `.dc.html`, confidential | -- | -- |
| Delivered drop | 708 files, **376M** | 415 files, **224M** | -- | -- |
| Promoted into repo | no, still `_inbox` | **yes**, `docs/design/` | -- | -- |
| Generated markdown | 149 files | 123, plus 129 in `docs/design/` | -- | -- |
| PDF / PPTX | 16 / 7 | 11 / 3 | -- | -- |
| Site content | reading room, 128 sections | reading room | 8-line page | 8-line page |
| Currency | **GBP** | -- | -- | -- |

Three things corrected during the survey, each by hv:

- **`Lamplight/content/` is not empty.** It is a directory of symlinks into
  `~/Devel/prj/Wrightings` -- 2.6G, 2373 markdown files, clean, a separate
  repository. It is story content, not design content, and is **out of scope**
  unless ruled otherwise.
- **`products.json` is not in the gyreandgymble repository.** It exists on the
  Claude Design side -- the first evidence that CD holds material the repositories
  do not.
- **The two Laksa sites are genuinely 8-line shingles.** Their design systems exist
  only inside CD.

## The convention that already exists

Recorded in each drop's `docs/README.md` and `START-HERE.md`. It is more mature than
anything Cdsync currently models, and it is the thing being preserved.

**Three representations, one source.**

| | Where | Role |
| --- | --- | --- |
| Source | `design-system/`, `venture/`, `prototypes/` at drop root | The designed artefact. **Canonical.** |
| Markdown | `docs/<tree>/<doc>/NN-*.md` plus 2x page captures in `img/` | Reading, search, reuse, ingestion by a coding agent |
| Site | `docs/site/`, including `site/read/` | Browsing, and the reading room |

Its standing rules, which the port must not contradict:

- **Markdown carries argument. The source carries drawing.**
- The `.dc.html` files are canonical; where a generated output disagrees, **the
  source wins** -- including the PDFs and PPTX.
- **An accepted ADR outranks a design document.** That settles
  ruling-versus-recommendation, where the source-wins rule settles
  source-versus-generated.
- Confidentiality splits at `venture/`, `site/venture/`, `pdf/venture/`. The design
  tree is internal but not sensitive.

## Five things that block a brief

Each verified against the code or the filesystem, not inferred.

### 1. `import` cannot receive this shape

The owned-path list is `assets/ kit/ notes/ index.md RETURN.md`, defined once in
`lib/drop.sh`. The drops contain `design-system/ venture/ prototypes/ docs/
handoff/ lib/ uploads/ tiles/ CLAUDE.md START-HERE.md`. **Every one of those is
reported `ignore` and left on the floor.** A faithful port is un-importable today.

### 2. Two opposite conventions for surviving a move

| | Says |
| --- | --- |
| Cdsync | Each asset directory is the unit of portability. An artefact restates token values literally rather than linking `../../kit/tokens.css`, because a path two levels up does not survive the directory being moved. |
| The drops | The sources live at the drop root because they reference `assets/`, `tiles/`, `uploads/` and `lib/` relatively. Move them and every document loses its images. |

The same problem, solved oppositely.

**SETTLED LATER THE SAME DAY, AND THIS SECTION OVERSTATES IT.** Measuring the documents
collapsed the conflict: every canonical document already inlines its tokens in a single
`<style>` block, so Cdsync's rule is satisfied as things stand. That rule is about token
values in text, and it is read above as though it demanded shared imagery be duplicated.
Each document needs one to seven images from outside its own directory -- Baize needs
exactly one apiece. See the ruling and the measurements in `tasks.md`.

Kept rather than rewritten, because the shape of the mistake is worth having on record: a
rule was read as more expansive than its own words, and two minutes of measurement
settled what an afternoon of reasoning had called a blocker.

### 3. The taxonomy is organised by artefact type; the documents by surface

`player-surfaces`, `operator-surfaces`, `notifications`, `the-way-in`,
`darts-spike`, `storyfield-surfaces`, `wrighter-frontdesk`, `gwidget` and
`acton-index` appear nowhere in the 49-slug taxonomy, and `brief` refuses a slug the
library does not hold.

Worse than a naming gap: one agreed `design-system.dc.html` of 877 lines contains
the colour system, the type system, the grid, the components **and** the states --
five taxonomy slugs in one document. Splitting it to fit means re-authoring agreed
work, which the standing constraint forbids.

### 4. `cdsync site` is not the reading room

`site` emits a single greyscale index over `assets/<slug>/`. The requirement --
serve the zip, with interlinks and tables of contents -- is the existing
`docs/site/` plus `site/read/`, which Claude Design generates and `import` will not
write. Either the generated site lands somewhere owned, or `site` grows by an order
of magnitude.

### 5. Cdsync has no notion of confidentiality

Lamplight's venture set carries a live raise figure and an explicit instruction not
to name the licensed IP. The existing tooling has a leak guard in
`build-team-site.sh`; `check` and `site` have none, and `site` would publish
whatever sits in the target.

## A sixth, smaller, and measured

**Rule 4 finds phantom colours in binary files.** `each_scannable_file` filters only
`exports/`, never by type. Measured: a 428K PNG yields zero matches, a 2.4M JPEG
yields **one** -- which surfaces as a *blocking* finding. Across 376M of portraits,
shots, tiles and page captures that is potentially hundreds of false blocks. The
scan is fast enough at 0.11s on 2.4M, so correctness is the problem, not performance.

Small fix, and it must land before either large drop is checked.

## Design Decisions

**The target is `design/system/`, and for a better reason than tidiness.** It keeps
`design/fonts/` and `design/stock/` *outside* the target, so `import` can never
reach them. Those are licensed fonts and licensed photography, and neither is
regenerable. Had the target been `design/`, a drop replacing `assets/` wholesale
would have been one command from destroying them.

**Cdsync has no home for venture-owned source assets.** The protocol describes only
what a supplier delivers. Fonts, licensed stock and logos are *inputs*. They survive
today by accident -- because they happen to sit outside the target -- rather than by
design. Named as a gap rather than left as luck.

## Alternatives Considered

**Do the port locally with a script, no Claude Design round.** Tempting, because
Group A's design work is already agreed and a transformation needs no designer.
Rejected on three counts: CD holds material the repositories do not
(`products.json`, and both Laksa design systems); the markdown-and-capture
extraction is explicitly a browser pass rather than a shell one, per the drops' own
`docs/README.md`; and the two shingle sites need a design system built rather than
moved.

**One brief for all four.** Rejected. Group A and Group B are different jobs -- one
preserves an agreed corpus, the other creates one -- and the `fixed` list for
Lamplight alone derives from a 164-line source brief. Four briefs, and the two
groups will not share a shape.

**Extract Group B first, then design the protocol around what comes back.**
Rejected, and it is the trap this thread exists to avoid. An extract today emits the
Group A shape, converting two ports into four.
