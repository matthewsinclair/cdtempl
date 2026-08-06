---
verblock: "30 Jul 2026:v0.1: matts - Port brief: repackage the Acton design system into the Cdsync protocol"
---
# Port brief -- Acton (Lamplight) design system into the Cdsync protocol

**This is a repackaging job, not a design job.** Every design decision in Acton is
agreed and final. Nothing in this round changes a colour, a component, a word of
argument or a page of layout. What changes is the *shape of the directory* the work is
delivered in, so a tool can read it.

Read that twice, because the single way this round can fail is by improving something.

## Why it is safe

The existing drop stays exactly where it is and is not touched. This round produces a
**new zip**, which gets installed at a path that does not exist yet. Nothing is moved,
so nothing can be lost. If this round is wrong, we throw the zip away and the
originals are untouched.

## Where this lands, and it is identical for every project

Every project in this programme installs its drop at **one path, and the same path**:

```
<repo>/design/system/
```

This replaces the per-project convention each session grew its own version of --
`intent/_inbox/lit-pool/`, `intent/_inbox/acton/`, and others. Those differ in every
repository, which is exactly the problem being fixed: four projects, four destinations,
four sets of assumptions about what lands where. From now there is one answer.

So the zip you produce **is the contents of `design/system/`**, not a directory to be
placed inside it. `RETURN.md`, `index.md`, `kit/`, `assets/` and `notes/` sit at the top
level of the zip. `cdsync import` unpacks it there and writes only those five paths;
anything else already in the target survives untouched, and anything else in the zip is
reported and left on the floor.

Three consequences worth stating plainly:

- **Do not nest the drop under a project-named directory.** A zip whose top level is
  `lit-pool/` or `acton/` imports as a single ignored path and delivers nothing at all.
- **`design/` already exists in some of these repositories**, holding licensed fonts,
  logos and stock photography. It sits *outside* the target and the importer cannot
  reach it -- which is deliberate, because none of it is regenerable. Do not deliver
  anything intended to land there.
- **No `docs/` tree at the top level.** The generated markdown belongs inside the asset
  it documents. A top-level `docs/` is not an owned path and would be discarded.
- **Your existing `assets/` collides with the protocol's `assets/`.** This is the one
  most likely to go wrong, and it is described in full immediately below.

### The `assets/` collision -- read this twice

The drop contract owns `assets/`, and to it that word means **one directory per asset
slug, each carrying a `spec.md`**. Your tree already has an `assets/`, and it means
something else entirely: four directories of raw material -- `brand/`, `portraits/`,
`ref/` and `shots/`. The two cannot both be `assets/`.

Yours collides in the more dangerous direction than the other projects in this
programme. Because your four are *directories*, our checker walks them as though they
were assets, finds no `spec.md` in any, and reports **four blocking findings** -- so the
output reads as "four broken assets" when the truth is "zero assets and four media
folders". A reader of that report would draw entirely the wrong conclusion about what
this project contains. **Three of the four projects here collide the same way and each
collides differently**, so this is a property of the house shape, not a mistake in yours.

What to do: `brand/` is shared material -- put it in `kit/brand/` alongside the tokens.
`portraits/`, `ref/` and `shots/` are source imagery; any image a document actually
references travels into that asset's `img/`, and anything unreferenced stays out of this
round and is listed in `RETURN.md`. Let `assets/` mean only what the contract means by it.

**A related change on our side, so a failure reads honestly.** Until today our checker
reported `0 assets checked -- clean` and exited successfully, which is how a tree with no
assets at all passed. It now fails with exit 2 and says so.

## What you are delivering

One zip. Its top level is exactly what lands in the target, so **the folder is the
specification**:

```
RETURN.md                     this drop's narrative -- mandatory
index.md                      manifest: every asset, its status, its spec version
kit/
  kit.md                      the kit written down
  tokens.css                  the existing token file, unchanged
  tokens.json                 NEW -- the same values, parseable
assets/
  <asset-slug>/               FLAT. no grouping, no nesting by kind
    spec.md                   REQUIRED FORMAT -- see below
    <name>.dc.html            the canonical document, byte-for-byte unchanged
    <name>-print.dc.html      the print variant, same asset, same directory
    support.js                the runtime, as a sibling. it must stay a sibling
    <slug>.md                 the document's table of contents
    NN-<section>.md           the chapter files, interlinked relatively
    img/                      only the images this document references
    exports/                  pdf, pptx, and the 2x page captures
notes/
  component-catalog.md        durable thinking that is not an asset
```

`assets/` is flat on purpose. Grouping is an order in disguise, and this structure must
not imply one. Grouping is real and useful and it lives in `index.md` as data.

## The asset map

Six canonical documents, one asset each. **Use these slugs exactly.** Each print
variant belongs to the same asset as its screen document -- one asset, two files.

| Existing document | Asset slug | Note |
| --- | --- | --- |
| `acton-index.dc.html` | `design-system-index` | This one has a specification in our library already -- taxonomy asset 30 |
| `design-system.dc.html` | `design-system` | Spans colour, type, grid, components and states. **Do not split it.** See below |
| `storyfield-surfaces.dc.html` | `storyfield-surfaces` | 7 referenced images -- the largest set |
| `storyfield-ios.dc.html` | `storyfield-ios` | |
| `wrighter-frontdesk.dc.html` | `wrighter-frontdesk` | |
| `gwidget.dc.html` | `gwidget` | 7 referenced images |

**On not splitting `design-system`.** Our asset taxonomy would normally treat the
colour system, type system, grid, components and states as five separate assets. Yours
is one agreed document covering all five, in **two lighting models**. Splitting it
would mean re-authoring agreed work, which is forbidden this round. Deliver it whole,
as one asset, and say in `RETURN.md` which taxonomy concerns it covers so the mapping
is recorded rather than inferred.

**On the two lighting models.** The reading light and the working light are one system,
not two. They stay in one asset and one kit. Everything outside the two
`[data-theme]` blocks is shared and must stay shared -- type scale, space, radius,
motion, targets.

## `spec.md` -- the one file with a required format

Each asset carries a `spec.md`: its definition of done, travelling with it. It is read
by machine as well as by people, so **it must open with a YAML front-matter block.**

This is where the last round of this protocol went wrong, and the fault was entirely
ours: our brief rendered these fields as a markdown table and never said they were
machine-readable, so the drop reproduced the table. Front matter first, then the body:

```yaml
---
asset: storyfield-surfaces      # exactly the slug from the table above
name: Storyfield surfaces
spec_version: 1
kit_version: 1
form: C                         # A document / B structure / C built artefact / D spec only
tier: 1
group: 4
classification: internal        # public | internal | confidential -- WHERE it may be shown
audience: [player]              # the copy actually made, not every copy possible
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

**Do not declare `blanks`, `blanks_unique` or `blanks_source`.** Our tool computes them
and writes them in. Every hand-counted figure ever delivered here was wrong, which is
why counting stopped being anyone's job.

`index.md` is a manifest and a convenience. **It is not where state lives** -- a status
recorded only there is a status the checker cannot see.

Since this material is finished and agreed, most of these should be `status: complete`.
Say so honestly: if a document has known gaps, `partial` plus `coverage` is the truthful
answer and nothing bad happens.

**One known conflict to record rather than fix.** `storyfield-surfaces` still shows
chronicles as public by default, and ADR-0013 ruled the other way. Do not edit the
document. Set `status: partial`, say so in `coverage`, and name it in `RETURN.md`. An
accepted ADR outranks a design document, but that is a ruling to record here, not a
redesign to perform.

## The kit

`kit/tokens.css` is your existing `handoff/assets/tokens.css`, unchanged. It is already
exactly what we need: extracted, labelled, exact, with nothing inferred.

`kit/tokens.json` is **new and required**. It is the file our checker reads, and it
enforces the rule that every colour literal in the drop appears in the kit. A colour in
a document but not in `tokens.json` blocks the drop.

Three things to get right:

1. **Every colour in both lighting models must be in it.** Also `beat-taxonomy.css`
   and both `theme-blocks.css` files. A hue in a document and not in the kit fails.
2. **Acton has decided colours. They belong in the kit.** Our neutral greyscale ramp is
   a default for a venture that has not decided, and Lamplight has decided.
3. **Two themes need a representation.** `tokens.json` is flat and parseable, and your
   source has two `[data-theme]` blocks over a shared base. Propose a shape -- nested
   by theme, or prefixed keys -- and say in `RETURN.md` which you chose and why. We
   have no opinion yet and yours will become the convention.

`kit/kit.md` is the kit written down: the ramp, the type, the two kinds of blank, the
blank-counting scope, the illustrative marker, the prohibitions.

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
| --- | --- |
| `venture/` -- all 16 documents -- and everything generated from it | **Scope, not secrecy -- and the reason changed on 30 July.** This round is the design system; venture is a later round, deliberately. The *original* reason given here was that our tool has no leak guard so confidential material must not enter a Cdsync target. **That reason is now dead** -- see "Classification" below -- and it is recorded rather than deleted so nobody re-derives it. **RULED by hv, 30 July: venture stays out of round one.** Round one's job is to prove the conversion works at all, and converting venture as well would mean declaring what *done* means for a pitch deck at this venture -- a materially bigger round. It is round two. This does not touch **storage**: the whole venture tree stays installed and tracked regardless, per the canon. Out of this round means "not turned into an asset yet", never "removed". |
| `docs/site/` and the reading room | Not converted to an asset this round. **It stays in your delivery and stays installed** -- `import` leaves it standing. The limitation is that import cannot *update* it, which is a gap on our side. See the note below. |
| `handoff/docs/adr/` and `handoff/intent/st/` | The 13 ADRs and 8 steel threads are Lamplight's own project records, not design-system artefacts. They stay where they are. |
| `handoff/component-catalog.md` | Goes to `notes/`. It is the most useful file in the drop and it is not a design artefact -- it is an implementation map. |
| `scratch/` | Unless you say otherwise. |
| `prototypes/` | Deliver as an asset if it has a definition of done; otherwise hold for a later round and say which you chose. |

### Numbering, carried here so you never have to infer it

You are not delivering ADRs or steel threads this round. This section exists because the
last round allocated ids anyway, from an assumption, and repairing it cost a full export
cycle on both sides. **If you allocate any id for any reason, allocate from here:**

| Series | Existing in this drop | High-water | Next free |
| ------ | --------------------- | ---------- | --------- |
| ADR | `ADR-0008`–`ADR-0020`, 13, no gaps | `ADR-0020` | **`ADR-0021`** |
| Steel thread | `ST0334`–`ST0341`, 8, no gaps | `ST0341` | **`ST0342`** |

`ADR-0007` is the last of Lamplight's pre-existing series and `ST0333` is a *completed*
thread, not a free slot. Both figures are yours, read from your own drop -- you assigned
`ADR-0008`–`ADR-0020` from the real mark rather than from a guess, and `handoff/README.md`
records that. This table is that reasoning written down so the next round inherits it
instead of re-deriving it.

**This is a gap on our side, not yours.** `cdsync brief` cannot yet carry high-water marks,
so no brief in this programme has ever stated them. Until it can, they are stated by hand,
here.

**On the reading room.** The requirement is that the installed result can be served
locally and browsed with interlinks and tables of contents. That is met differently
this round: each asset carries its own `<slug>.md` table of contents and its `NN-*.md`
chapters with **relative links between them**, so serving the target gives a navigable
tree. Relative links inside one asset directory survive; anything reaching out of it
does not. The 128-section search-and-index reading room is a later round, and we know
we are giving something up.

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

1. **The `.dc.html` files are canonical and unchanged.** Byte-for-byte. If a generated
   output disagrees with its source, the source wins -- including the PDFs and PPTX,
   which are a 28 July snapshot.
2. **An accepted ADR outranks a design document.** Where an ADR has overtaken a
   document, do not edit the document: record the conflict.
3. **Markdown carries argument. The source carries drawing.** Your rule, and it is
   right.
4. **`support.js` stays a sibling of the `.dc.html` that loads it.** Do not move it to
   a subdirectory -- the runtime resolves it as a sibling and our colour check exempts
   it by the comment it carries, not by where it sits.
5. **Page captures go in `exports/`.** They are generated output, and our checker skips
   that directory -- which also keeps a large binary out of a text scan.
6. **Nothing is lost.** Every file in the source drop either lands somewhere in this
   zip or is listed in `RETURN.md` as deliberately omitted, with a reason. A file that
   is neither is a bug in this round.

## RETURN.md -- mandatory, at the top of the drop

```markdown
# Return -- Acton port, round 1

## What is in this drop
[every asset, with status]

## What I left out, and why
[Every file in the source drop that is not in this zip. This is the section that
 proves nothing was lost.]

## Revisions to understanding
[Mandatory. Present-but-empty when there is nothing.]

## Decisions I made that you did not ask me to make
[Every place a gap was filled. The list that gets audited.]

## What I could not do, and why

## What I would do next
```

Three things we specifically want your view on:

- **The `tokens.json` shape for two themes.** Yours becomes the convention.
- **Which taxonomy concerns `design-system` covers.** We need the mapping recorded.
- **Whether one asset per surface is the right grain**, given `storyfield-surfaces`
  and `storyfield-ios` are arguably one asset in two form factors.

## One thing you should push back on

If any instruction here would require changing an agreed design decision, **stop and
say so in `RETURN.md` rather than complying.** The repackaging is worth doing; it is
not worth one altered token value. This brief was written by someone who has read your
material but did not design it.
