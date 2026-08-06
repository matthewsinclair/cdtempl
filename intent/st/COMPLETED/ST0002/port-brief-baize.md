---
verblock: "30 Jul 2026:v0.1: matts - Port brief: repackage the Baize design system into the Cdsync protocol"
---
# Port brief -- Baize design system into the Cdsync protocol

**This is a repackaging job, not a design job.** Every design decision in the Baize
design system is agreed and final. Nothing in this round changes a colour, a
component, a word of argument or a page of layout. What changes is the *shape of the
directory* the work is delivered in, so a tool can read it.

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
something else entirely: seven loose brand files -- the brand mark, the app icon, and
five product screenshots. The two cannot both be `assets/`.

This was found by running our checker against your installed 16:29 export. It reported
`0 assets checked`, because it looked in `assets/`, found no slug directories, and had
nothing to read. **Three of the four projects in this programme collide the same way and
each collides differently**, so this is a property of the house shape rather than a
mistake in yours.

What to do: the seven brand files are **shared material, not an asset**. Put them in
`kit/brand/` alongside the tokens, and let `assets/` mean only what the contract means by
it. Record the move in `RETURN.md`. If any of the five screenshots is referenced by a
document, its copy belongs in that asset's `img/` instead -- a referenced image travels
with the document that references it.

**A related change on our side, so a failure reads honestly.** Until today our checker
reported `0 assets checked -- clean` and exited successfully, which is how a tree with no
assets at all passed. It now fails with exit 2 and says so. If you see that message, it
means `assets/` did not end up holding slug directories -- not that your material is bad.

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
    support.js                the runtime, as a sibling. it must stay a sibling
    <slug>.md                 the document's table of contents
    NN-<section>.md           the chapter files, interlinked relatively
    img/                      only the images this document references
    exports/                  pdf, pptx, and the 2x page captures
notes/
  <topic>.md                  durable thinking that is not an asset
```

`assets/` is flat on purpose. Grouping is an order in disguise, and this structure
must not imply one. Grouping is real and useful and it lives in `index.md` as data.

## The asset map

**This map is measured, not inferred.** The earlier draft of this brief carried a caveat
saying your newer release had never been downloaded. That is no longer true: your
**16:29 export of 30 July** is installed and its tree has been read file by file, along
with `CORRECTIONS-2026-07-30.md`. The map below is what is actually on disk.

Where your latest state differs from it -- a document added, renamed, split or dropped --
follow your latest and **record every difference in `RETURN.md`**. Do not silently
reconcile: the map is what the tooling on this side expects, so a divergence I do not
hear about becomes a failed import rather than a discussion.

**Nine** canonical documents, one asset each. **Use these slugs exactly.**

| Existing document | Asset slug | Note |
| --- | --- | --- |
| `index.dc.html` | `design-system-index` | This one has a specification in our library already -- taxonomy asset 30 |
| `design-system.dc.html` | `design-system` | Spans colour, type, grid, components and states. **Do not split it.** See below |
| `player-surfaces.dc.html` | `player-surfaces` | |
| `operator-surfaces.dc.html` | `operator-surfaces` | |
| `notifications.dc.html` | `notifications` | |
| `the-way-in.dc.html` | `the-way-in` | |
| `party-handshake.dc.html` | `party-handshake` | **Added 30 July**, after the earlier draft of this brief. Six sections, six captures. Carries D6 and D7 |
| `darts-spike.dc.html` | `darts-spike` | A spike finding, not a standing asset. Flag it -- see below |
| `spikes-trivia-poker-cards.dc.html` | `spikes-trivia-poker-cards` | Same |

**One inventory line to fix at source while you are here.** `INVENTORY.md` line 42 reads
`design-system/ 9 — the 8 canonical design documents (.dc.html) + support.js`. The
directory holds **ten** files: **nine** documents plus `support.js`. Line 56 (*"9
documents as markdown"*) and line 210 (*"party-handshake adds a 13th document"*) are both
right, so one line is out of step with two others -- the party-handshake addition never
reached the shape block.

**On not splitting `design-system`.** Our asset taxonomy would normally treat the
colour system, type system, grid, components and states as five separate assets. Your
`design-system.dc.html` is one agreed 877-line document covering all five. Splitting
it would mean re-authoring agreed work, which is forbidden this round. Deliver it
whole, as one asset, and say in `RETURN.md` which taxonomy concerns it covers so the
mapping is recorded rather than inferred.

**On the two spikes.** A spike is a finding, not a standing artefact, and our
protocol has a `notes/` directory for exactly that. But your spikes carry chapters and
page captures, and a note is a single flat file, so they cannot go there. They are
delivered as assets, and both are recorded in `RETURN.md` as having no home in the
taxonomy. That is a real gap on our side and your naming it helps close it.

## `spec.md` -- the one file with a required format

Each asset carries a `spec.md`: its definition of done, travelling with it. It is read
by machine as well as by people, so **it must open with a YAML front-matter block.**

This is where the last round went wrong, and the fault was entirely ours: our brief
rendered these fields as a markdown table and never said they were machine-readable,
so the drop reproduced the table. Front matter first, then the body:

```yaml
---
asset: player-surfaces          # exactly the slug from the table above
name: Player surfaces
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
recorded only there is a status the checker cannot see. That is also last round's
lesson.

Since this material is finished and agreed, most of these should be
`status: complete`. Say so honestly: if a document has known gaps, `partial` plus
`coverage` is the truthful answer and nothing bad happens.

## The kit

`kit/tokens.css` is your existing `assets/tokens.css`, unchanged.

`kit/tokens.json` is **new and required**. It is the file our checker reads, and it
enforces the rule that every colour literal in the drop appears in the kit. A colour
in a document but not in `tokens.json` blocks the drop.

Two things to get right:

1. **Every colour used anywhere in the design system must be in it** -- including
   `trust-strata.css` and the theme blocks. If a hue exists in a document and not in
   the kit, the drop will not pass.
2. Baize has decided brand colours. **They belong in the kit.** Our neutral greyscale
   ramp is a default for a venture that has not decided, and Baize has decided.

`kit/kit.md` is the kit written down: the ramp, the type, the two kinds of blank, the
blank-counting scope, the illustrative marker, the prohibitions. If that document
already exists in your material, deliver it as is.

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
| `venture/` and everything generated from it | **Scope, not secrecy -- and the reason changed on 30 July.** This round is the design system; venture is a later round, deliberately. The *original* reason given here was that our tool has no leak guard so confidential material must not enter a Cdsync target. **That reason is now dead** -- see "Classification" below -- and it is recorded rather than deleted so nobody re-derives it. **RULED by hv, 30 July: venture stays out of round one.** Round one's job is to prove the conversion works at all, and converting venture as well would mean declaring what *done* means for a pitch deck at this venture -- a materially bigger round. It is round two. This does not touch **storage**: the whole venture tree stays installed and tracked regardless, per the canon. Out of this round means "not turned into an asset yet", never "removed". |
| `docs/site/` and the reading room | Not converted to an asset this round. **It stays in your delivery and stays installed** -- `import` leaves it standing. The limitation is that import cannot *update* it, which is a gap on our side. See the note below. |
| `handoff/` implementation material | Component catalogue goes to `notes/`; ADRs and steel threads are the venture's own records and stay where they are. |
| `prototypes/` | Deliver as an asset if it has a definition of done; otherwise hold it for a later round and say which you chose. |

### Numbering, carried here so you never have to infer it

You are not delivering ADRs or steel threads this round. This section exists because a
sibling project in this programme allocated ids from an assumption last round, and
repairing it cost a full export cycle on both sides. **If you allocate any id for any
reason, allocate from here:**

| Series | In this drop | High-water | Next free |
| ------ | ------------ | ---------- | --------- |
| ADR | `ADR-0021`–`ADR-0028` | `ADR-0030` | **`ADR-0031`** |
| Steel thread | `ST0016`–`ST0023` | `ST0023` | **`ST0024`** |

Note the ADR row: the drop carries `0021`–`0028`, but the high-water is `ADR-0030`,
because `ADR-0029` and `ADR-0030` exist in the repository and were absorbed rather than
restated. **The drop's range and the repository's high-water are not the same number**, and
taking the drop's alone would collide.

These figures are yours -- `CORRECTIONS-2026-07-30.md` states them, and an independent
audit of the repository reached the same answer. **Nothing was renumbered in Baize because
nothing needed to be**, which is worth saying plainly: your ids were already the
repository's canon.

**This is a gap on our side, not yours.** `cdsync brief` cannot yet carry high-water marks,
so no brief in this programme has ever stated them. Until it can, they are stated by hand,
here.

**On the reading room.** The requirement is that the installed result can be served
locally and browsed with interlinks and tables of contents. That is met differently
this round: each asset carries its own `<slug>.md` table of contents and its
`NN-*.md` chapters with **relative links between them**, so serving the target gives a
navigable tree. Relative links inside one asset directory survive; anything reaching
out of it does not. The search-and-index reading room is a later round.

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
   output disagrees with its source, the source wins -- including the PDFs.
2. **An accepted ADR outranks a design document.** That rule stands. Where an ADR has
   overtaken a document, do not edit the document: note the conflict in `RETURN.md`.
3. **Markdown carries argument. The source carries drawing.** Your rule, and it is
   right. The chapters aggregate the argument; the `.dc.html` holds the drawing.
4. **`support.js` stays a sibling of the `.dc.html` that loads it.** Do not move it to
   a subdirectory -- the runtime resolves it as a sibling and our colour check exempts
   it by the comment it carries, not by where it sits.
5. **Page captures go in `exports/`.** They are generated output, and our checker skips
   that directory -- which also keeps a large binary out of a text scan.
6. **Nothing is lost.** Every file in the source drop either lands somewhere in this
   zip or is listed in `RETURN.md` as deliberately omitted, with a reason. A file that
   is neither is a bug in this round.

## RETURN.md -- mandatory, at the top of the drop

Fixed headings, so it cannot degrade into a changelog.

```markdown
# Return -- Baize design system port, round 1

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

Two things we specifically want your view on, in *decisions* or *revisions*:

- **Which taxonomy concerns `design-system` covers.** We need the mapping recorded.
- **Whether the two spikes should be assets at all.** We think our protocol is missing
  a shape for a finding that carries chapters. Tell us if you agree.

## One thing you should push back on

If any instruction here would require changing an agreed design decision, **stop and
say so in `RETURN.md` rather than complying.** The repackaging is worth doing; it is
not worth one altered colour value. This brief was written by someone who has read
your material but did not design it.
