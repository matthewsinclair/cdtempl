---
verblock: "30 Jul 2026:v0.1: Matthew Sinclair - Port brief for the POP^UP^ART (snorkeltoast) design system"
---

# Port brief -- POP^UP^ART (snorkeltoast) design system into the Cdsync protocol

For the **POP^UP^ART** Claude Design session. This is the conversion round: your 30 July
export is installed, has been read directory by directory, and this brief is written against
what is actually in it rather than against a summary of it.

Everything below is measured. Where a count appears, it was taken from your tree.

## Why it is safe

Nothing here asks you to re-author agreed work. The documents you have are the documents
that ship; this round changes **where they sit and what travels with them**, so a tool can
read them. If a rule below would require rewriting a document, that rule is wrong and I
want to hear about it rather than have you comply.

## Where this lands, and it is identical for every project

Every project in this programme installs its drop at **one path, and the same path**:

```
<repo>/design/system/
```

So the zip you produce **is the contents of `design/system/`**, not a directory to be
placed inside it. `RETURN.md`, `index.md`, `kit/`, `assets/` and `notes/` sit at the top
level of the zip. `cdsync import` writes only those five paths; anything else already in the
target survives untouched, and anything else in the zip is reported and left on the floor.

- **Do not nest the drop under a project-named directory.** A zip whose top level is
  `snorkeltoast/` or `popupart/` imports as a single ignored path and delivers nothing.
- **No `docs/` tree at the top level.** Generated markdown belongs inside the asset it
  documents. A top-level `docs/` is not an owned path and would be discarded.
- **Your existing `assets/` collides with the protocol's `assets/`.** See directly below.

### The `assets/` collision -- read this twice

The drop contract owns `assets/`, and to it that word means **one directory per asset slug,
each carrying a `spec.md`**. Your tree already has an `assets/` meaning something else: four
loose files -- `mascot-snorkeltoast.png`, `mascot-snorkeltoast.svg`,
`wordmark-popupart.png`, `wordmark-popupart.svg`. The two cannot both be `assets/`.

Running our checker against your installed export reported `0 assets checked`: it looked in
`assets/`, found no slug directories, and had nothing to read. **Three of the four projects
in this programme collide the same way and each collides differently**, so this is a
property of the house shape rather than a mistake in yours.

Those four files are the identity marks. They belong to the **`logo-suite`** asset
(taxonomy 12), with copies in `kit/brand/` if the kit references them. Let `assets/` mean
only what the contract means by it, and record the move in `RETURN.md`.

**A related change on our side, so a failure reads honestly.** Until today our checker
reported `0 assets checked -- clean` and exited successfully, which is how a tree with no
assets at all passed. It now fails with exit 2 and says so. If you see that message it
means `assets/` did not end up holding slug directories -- not that your material is bad.

## What you are delivering

One zip. Its top level is exactly what lands in the target, so **the folder is the
specification**:

```
RETURN.md                     this drop's narrative -- mandatory
index.md                      manifest: every asset, its status, its spec version
kit/
  kit.md                      the kit written down
  tokens.css                  your seven token files, concatenated or imported
  tokens.json                 NEW -- the same values, parseable
  brand/                      the identity marks, if the kit references them
assets/
  <asset-slug>/               FLAT. no grouping, no nesting by kind
    spec.md                   REQUIRED FORMAT -- see below
    <name>.html               the canonical document, byte-for-byte unchanged
    img/                      only the images this document references
    exports/                  pdf, pptx, print variants, page captures
notes/
  laksa-handoff.md            durable thinking that is not an asset
```

`assets/` is flat on purpose. Grouping is an order in disguise and this structure must not
imply one. Grouping is real and useful and it lives in `index.md` as data.

## The asset map

**Read this section first, because it says the opposite of what the sibling projects were
told.**

Lamplight and Baize each hold **one** design document covering colour, type, grid,
components and states together, and both briefs tell them *not to split it*. **Yours is
already decomposed, and decomposed almost exactly along our taxonomy's lines.** So the rule
for you is the inverse: **do not merge.** Your `guidelines/` directory has already done the
work those two projects still owe.

Twelve assets, eleven of which land on a real taxonomy slug. **Use these slugs exactly.**

| Source in your tree | Asset slug | Taxonomy | Spec exists on our side? |
| ------------------- | ---------- | -------- | ------------------------ |
| `brand/design-system.html` | `design-system-index` | 28 | **yes** |
| `brand/components/` (5 cards + `pop-elements.js`) | `component-library` | 22 | **yes** |
| `brand/guidelines/brand-*.html` (6) | `brand-guidelines` | 18 | **yes** |
| `brand/guidelines/colors-*.html` (7) | `colour-system` | 13 | no |
| `brand/guidelines/type-*.html` (6) | `typography-system` | 14 | no |
| `brand/guidelines/spacing-*.html` (2) | `grid-and-layout` | 21 | no |
| `assets/` mascot + wordmark (4 files) | `logo-suite` | 12 | no |
| `print/` (5 pieces + 5 print variants) | `print-collateral` | **absent -- see below** | no |
| `social/` (`social-kit.html` + 6 ready-to-post images) | `social-and-ad-kit` | 39 | no |
| `email/` (3 templates) | `email-templates` | 38 | no |
| `venture/one-pager.html` | `product-one-pager` | 34 | **yes** |
| `venture/pitch-deck.html` | `pitch-deck` | 42 | **yes** |

**`print-collateral` has no slot in our taxonomy.** The word "print" does not appear in it
at all. Deliver the asset under that slug anyway -- an unspecified slug imports cleanly and
our checker reports it as *advisory*, not as a failure. It is pending a ruling on our side,
and **you are the second project to need it independently**, which is the strongest argument
for adding it. Name it in `RETURN.md` so the gap is recorded rather than inferred.

Where a spec already exists on our side, your asset will be checked against it for
staleness. Where none exists, it will not -- that is our gap, not yours, and it produces an
advisory rather than a failure.

## `spec.md` -- the one file with a required format

Each asset carries a `spec.md`: its definition of done, travelling with it. It is read by
machine as well as by people, so **it must open with a YAML front-matter block.**

An earlier round of this protocol rendered these fields as a markdown table and never said
they were machine-readable, so the drop reproduced the table and nothing could be read. That
fault was entirely ours. Front matter first, then the body:

```yaml
---
asset: print-collateral         # exactly the slug from the table above
name: Print collateral
spec_version: 1
kit_version: 1
form: C                         # A document / B structure / C built artefact / D spec only
tier: 3                         # your judgement -- see note below
group: 6                        # Group 6, customer-facing surfaces
classification: internal        # public | internal | confidential -- WHERE it may be shown
audience: [customer, printer]   # the copy actually made, not every copy possible
status: complete                # spec-only | draft | partial | complete
coverage:                       # only when status is partial: what is covered
inputs_missing: []              # facts this asset needed and this brief did not carry
depends_on:
  hard_facts: []
  hard_assets: []
  reciprocal: []
bundles: []
---
```

**`group` is a real dependency layer, not a label.** The library defines eight, each needing
the ones below it: 1 Foundations, 2 Verbal identity, 3 Visual identity, 4 Design system,
5 Product definition, 6 Customer-facing surfaces, 7 Investment, 8 Team & operating. Most of
your assets are Group 3 or 4; `print/`, `social/` and `email/` are Group 6; `pitch-deck` is
Group 7. For `print-collateral`, which has no taxonomy slot, `tier` is your judgement --
say why you chose it in `RETURN.md`.

**Do not declare `blanks`, `blanks_unique` or `blanks_source`.** Our tool computes them and
writes them in. Every hand-counted figure ever delivered here was wrong, which is why
counting stopped being anyone's job.

`index.md` is a manifest and a convenience. **It is not where state lives** -- a status
recorded only there is a status the checker cannot see.

Since this material is finished, most of these should be `status: complete`. Say so
honestly: if something has known gaps, `partial` plus `coverage` is the truthful answer and
nothing bad happens.

## The kit

**Your `brand/tokens/` is the kit, not an asset.** Taxonomy entry 20 is "Design tokens" and
its slug is literally `kit` -- so the seven files (`base`, `colors`, `components`, `fonts`,
`motifs`, `spacing`, `typography`) become `kit/tokens.css`, either concatenated or with the
existing import structure preserved. Say which you chose.

`kit/tokens.json` is new: the same values in parseable form. Our leak guard reads it to
check that every colour literal in the drop appears in the kit, and **without it that rule
cannot run at all** -- it reports a warning and stops checking, which is the failure
direction we care most about.

## Numbering: you have no series, so do not start one

You have **no ADRs and no steel threads** -- verified across your whole tree. This section
exists because a sibling project in this programme allocated ids from an assumption last
round, and repairing it cost a full export cycle on both sides.

**So: do not create an ADR, a steel thread or a work package in this round.** If the
conversion surfaces a decision worth recording, put it in `RETURN.md` under *"Decisions I
made that you did not ask me to make"* and it will be given a home on our side, with a
number that does not collide with anything.

## "Out of this round" means not converted -- never removed

**Read this before the table below, because the table is easy to misread.**

`design/system/` is the **output of your process and the whole of it is stored**: the venture
set, the generated markdown, the microsite, the prototypes, the handoff tree. It is checked
into the repository as **specification** -- the project does not run on any of it. The design
system the project actually runs is built separately, here, from your tree as requirements.
That is why every part of it has to survive.

So **"excluded from this round" means "not turned into a Cdsync asset yet"**. It never means
"drop it from the delivery" and it never means "delete it". Nothing in your tree should stop
existing because of this brief.

**Two practical consequences.**

- **Do not remove anything from your project to satisfy an exclusion below.** If a document
  is out of scope for conversion, it stays exactly where it is and keeps being delivered.
- **A converted drop is installed with `cdsync import`, not by unzipping over the tree.**
  Import writes only its five owned paths and leaves everything else standing, so the
  microsite, the venture set and the prototypes already installed survive untouched. **An
  as-is drop is the whole tree and gets replaced; a converted drop is a subset of it and must
  not be.** That difference is ours to get right, not yours -- it is recorded here so the
  reason the exclusions are safe is written down rather than assumed.

## What stays out of this round

| Excluded | Why |
| -------- | --- |
| `cdsync/` -- **all of it** | A retired plan for a protocol we then built differently. It contains `RETIRED.md`, `OUTBOX.md` and a fake `intent/whiteboard/` skeleton with `cc` and `cd` nodes in it. It is not design material and anything globbing for `intent/whiteboard` or reading `OUTBOX.md` must never reach it. **Delete it from the drop and note the deletion.** |
| `docs/site/` and the generated site | Our importer will not write it, so it would be discarded |
| `docs/pdf/`, `docs/pptx/`, `docs/brand/`, `docs/delivery/`, `docs/venture/` | Generated. The pieces that matter travel inside their asset's `exports/` |
| `_source/` | Working material -- `deck-scratchpad.md` and its uploads |
| `uploads/` | Source screenshots and the export brief itself |
| `prototypes/` -- `standalone/` and `website/` | An 18-file working website. Deliver as one asset if it has a definition of done; otherwise hold it for a later round. **Say which you chose** |
| `handoff/*.liquid` | Two Shopify templates. Implementation, not design |

## Classification, and the drop is now tracked in full

**Changed 30 July 2026, and it reverses what earlier briefs in this programme said.**

The drop used to be gitignored in the receiving repository, on the argument that every
drop carries internal material and no export has a leak guard that can tell a publishable
asset from an internal one. That argument was sound in the abstract and wrong in practice:
**the repository is read only by authorised people**, so the exclusion protected against a
reader who does not exist -- and the bookkeeping it demanded caused a worse problem, a
tracked *mirror* of the drop that silently went a version stale.

**So the whole drop is tracked now, venture trees included.** One exclusion remains and it
needs no defending: `_inbox/` is the drop-off point for delivery archives. They are ephemeral
transport -- dropped in, unpacked by Cdsync, regenerated whenever one is wanted again -- and
nothing is in them that is not already unpacked and tracked beside them.

Confidentiality is handled by **classification** instead. Three values, and they are an
axis of their own rather than a flavour of `audience`:

| Classification | Means |
| -------------- | ----- |
| `public` | May be shown externally |
| `internal` | Within Geodica or the venture only |
| `confidential` | Internal **and** behind access control -- the mechanism is project-specific and still to be defined |

**Everything is tracked regardless of classification.** Classification governs where
material may be *shown*, never whether it is committed. Do not use it to decide what to
deliver.

Carry it as its own field in each `spec.md`, beside `audience` and not inside it:

```yaml
classification: internal        # public | internal | confidential
audience: [customer, printer]   # who it is FOR, which is a different question
```

## `addenda/` -- the one directory you must never overwrite

`design/system/addenda/` is **repo-authored**. It is the single thing under the target that
does not come from an export: material the project writes *about* the design, where the
design has a gap -- copy for states the corpus does not carry, and the like. It flows the
other way, **back to you**.

Two rules follow:

- **An addendum retires when a drop absorbs its content.** That is the success condition: a
  gap made explicit so it can be closed at source. When you take one in, delete it from
  `addenda/` and say so in the drop's corrections file.
- **An addendum is not a place to design things.** It records a gap in the drop's own voice.
  Design belongs in the drop; ratified decisions belong in the repository's ADRs.

**Do not include `addenda/` in your zip unless you are retiring one**, and say so if you do.
`cdsync import` already leaves it standing, because it writes only its five owned paths. The
hazard is the other install path: an as-is dump gets unzipped over the tree wholesale, and
that replace destroys anything hand-added, silently. **That is exactly how a sibling project
lost a handoff file and eight ADR banners between two drops on 30 July**, noticed only
because the files were gone.

## The rules that decide the hard cases

1. **Your documents are plain `.html`, and that is fine.** The sibling projects use a
   `.dc.html` convention and you do not. Nothing in this round asks you to adopt it. The
   canonical file is whatever your document already is, **byte-for-byte unchanged**.
2. **Your print variants live in `pdf/` subdirectories, not beside their source.** A third
   variation on this pattern across three projects. Keep the relationship: each
   `pdf/<name>-print.html` goes into its asset's `exports/`, beside the source it renders.
3. **`print-collateral` is one asset, not five.** The five pieces share one definition of
   done -- printed, at size, on the right stock. Splitting by artefact would make five
   assets that are each meaningless alone.
4. **The `ready-to-post/` images are artefacts of `social-and-ad-kit`**, not a separate
   asset. They go in its `img/` or `exports/` as appropriate.
5. **Page captures and rendered output go in `exports/`.** Our checker skips that
   directory, which also keeps large binaries out of a text scan.
6. **Nothing is lost.** Every file in the source drop either lands somewhere in this zip or
   is listed in `RETURN.md` as deliberately omitted, with a reason. A file that is neither
   is a bug in this round.

## RETURN.md -- mandatory, at the top of the drop

```markdown
# Return -- POP^UP^ART port, round 1

## What is in this drop

## What I left out, and why

## Revisions to understanding

## Decisions I made that you did not ask me to make

## What I could not do, and why

## What I would do next
```

**One thing you should push back on.** If the eleven-asset map above splits something you
consider one thing, or merges two things you consider separate, say so. The map was derived
from your directory structure, and directory structure is evidence of intent but not proof
of it. You know which of those documents share a definition of done and I am inferring it.
