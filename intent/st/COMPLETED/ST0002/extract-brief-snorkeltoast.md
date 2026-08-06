---
verblock: "30 Jul 2026:v0.1: matts - Extract brief: inventory and package the Snorkel Toast design system"
---
# Extract brief -- POP^UP^ART by snorkeltoast.com

## Read this before anything else: one thread in this project is retired

This project has been used as a coordination channel for the Cdsync tool, and that
conversation is **out of date**. It describes a handover protocol -- `template/**`
scaffolding, an `OUTBOX.md` bundle, a minted URL, `cdsync pull`, an allow-list, a commit
sha acknowledged back through `intent/whiteboard/cc/inbox.cd.md`, and "the eight
rulings".

**None of that exists.** I checked the repository and its full history: there is no
`cdsync pull` subcommand, no `template/` directory, no `intent/docs/handover-protocol.md`,
no commit `8b4f3bb4e18e`, and no `cc/inbox.cd.md`. The `cd` whiteboard node is
**archived** -- paused at 09:46 on 29 July with the focus *"new workstream, not yet
started"*. That channel was retired the same day when the tool moved to a
brief-out/zip-back model, which is the model this document is written in.

So: **do not resume that work, and do not reconcile this brief against it.** Nothing is
owed to it and nothing depends on it. If any instruction there conflicts with this
document, this document wins. Say in `RETURN.md` if that leaves you holding work you
think should not be dropped -- but do not act on the old protocol.

This is a design brief. Two jobs, in this order. **Do the first before the second**,
because the second is worth much less without it.

## Job one -- tell me what you have

Everything I know about Snorkel Toast from outside this project is in these
fourteen lines, and it is nearly nothing:

| Fact | Value |
| --- | --- |
| Title | Snorkel Toast |
| Domain | `snorkeltoast.com` |
| Site description | `45h` -- which is placeholder text, not a description |
| Theme description | *"Vibrant minimal shingle site theme"* |
| From address | *[address redacted for publication]*. No reply-to is set |
| Assets in the repository | favicon, apple-touch icon, 192 and 512 icons, `icon.svg`, **six numbered "Snorkel Toast Logo" variants** in PNG and SVG, and two **"Unicorn Farting a Rainbow"** PNGs |
| Pages | one, eight lines, a single content placeholder |

The repository is a holding page. **You hold the design system and the venture
understanding; the repository holds neither.**

One thing I need clearing up before anything else: this project has been referred to on
my side as **"Snorkeltoast Pop-Up Art"**. The repository says only "Snorkel Toast" and
gives no hint of what it sells or does. If pop-up art is the venture, say so plainly in
job one -- and if it is not, correct me, because I have no way to tell from here.

So before anything is packaged, write me an inventory. This is the highest-value part
of the session:

1. **The venture, in your words.** What is Snorkel Toast, in one sentence, for whom?
   Then: what has been *decided* about it, and what is still open? I need this because
   the next round's brief is assembled from those two lists, and a brief with a
   placeholder in place of them has been measured on another venture to produce
   **212 blanks where real facts produced 73**. I would rather ask you than invent it.
2. **Every artefact you hold.** Name, what it is, what state it is in, and whether it
   is agreed or provisional.
3. **The six logo variants.** Six numbered logos is a set nobody has chosen from, or a
   family with six uses. Which is it, and is one of them primary?
4. **The design tokens.** Colours, type, spacing, radius -- whatever exists. The theme
   calls itself *vibrant* while the repository holds a black-and-white favicon set and
   a unicorn; tell me what the palette actually is.
5. **What a complete design system for this venture would need that you do not yet
   have.** The gap list matters as much as the inventory.

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

## Job two -- package what you have

Then, and only then, deliver a zip whose top level is exactly this:

```
RETURN.md                     the narrative, including the whole of job one
index.md                      manifest: every asset, its status, its spec version
kit/
  kit.md                      the kit written down
  tokens.css                  custom properties
  tokens.json                 the same values, parseable -- the file the checker reads
assets/
  <asset-slug>/               FLAT. no grouping
    spec.md                   REQUIRED FORMAT -- see below
    <artefact files>          the design itself
    exports/                  pdf, png -- generated, never hand-edited
notes/
  <topic>.md                  durable thinking that is not an asset
```

**Package everything you hold.** I am told that is a lot. An empty asset directory is
worse than an absent one and a plausible invented artefact is worse than either -- but
do not read those cautions as a licence to deliver a subset. If you hold twelve
finished things, deliver twelve assets.

### Choosing slugs

Pick from this list wherever something fits. These are the asset types the tooling
knows:

```
accessibility-standard   brand-asset-kit          brand-guidelines
case-study-template      colour-system            competitive-landscape
component-library        customer-journey-map     data-room-index
data-visualisation-standard  decision-log         demo-video-storyboard
design-system-index      email-templates          executive-teaser
financial-summary-cap-table  grid-and-layout      hiring-plan
iconography              imagery-direction        information-architecture
investor-update          job-description-template key-flows
kit                      landing-page             launch-kit
logo-suite               messaging-framework      motion-principles
naming-and-nomenclature  pattern-library          pitch-deck
positioning-icp-personas pricing-and-packaging    problem-and-opportunity
product-one-pager        product-principles       roadmap
sales-deck               social-and-ad-kit        states-and-interaction
theming-spec             typography-system        ux-writing-standards
venture-thesis           voice-and-tone           ways-of-working
whos-who-in-the-zoo
```

If something you hold has no slot in that list, **deliver it under a slug you propose
and name it in `RETURN.md` as unmapped.** Do not force a bad fit -- the gap is more
useful to me than a wrong label.

### `spec.md` -- the one file with a required format

Each asset carries its definition of done, travelling with it. It is read by machine as
well as by people, so **it must open with a YAML front-matter block:**

```yaml
---
asset: logo-suite               # exactly the slug
name: Logo suite
spec_version: 1
kit_version: 1
form: C                         # A document / B structure / C built artefact / D spec only
tier: 1
group: 4
audience: [customer]            # the copy actually made, not every copy possible
status: draft                   # spec-only | draft | partial | complete
coverage:                       # only when status is partial
inputs_missing:                 # facts the asset needs that NOBODY has -- see below
depends_on:
  hard_facts: []
  hard_assets: []
  reciprocal: []
bundles: []
---
```

**Do not declare `blanks`, `blanks_unique` or `blanks_source`.** The tool computes them.
Every hand-counted figure ever delivered here was wrong, which is why counting stopped
being anyone's job.

**`inputs_missing` means facts nobody has, not facts this brief lacks.** This is the
distinction that matters most in the whole document. This brief carries almost no
venture facts -- but **you hold them**, and a fact you already know is not missing. Use
what you have, and reserve `inputs_missing` for genuine unknowns: things neither of us
has decided. If it comes back long, I will read it as the venture being underspecified
rather than as the brief being thin, so only put real gaps in it.

## Standing rules

- **Use the venture facts you hold; do not invent new ones.** You know this venture and
  this brief does not. Work from what you know. But where something has genuinely never
  been decided, leave a visible blank and name it in `inputs_missing` rather than
  filling it plausibly -- an invented fact survives into something someone acts on, and
  an obvious blank does not.
- **Write the facts down.** Whatever you know about this venture that is not in this
  brief needs to reach `RETURN.md`, because it gets transcribed into the venture's own
  `cdsync.json` and becomes the basis of every future round. Facts that live only in
  this conversation are facts the next round loses.
- **Numbers: illustrative, and visibly marked as such in the artefact** -- not merely
  understood in this conversation. Our checker enforces the marking.
- **Every colour literal in the drop must appear in `kit/tokens.json`**, or the drop is
  blocked. That includes anything in a stylesheet or an inline style.
- **Nothing is lost.** Anything you hold that is not in the zip gets listed in
  `RETURN.md` under *what I left out, and why*.

## RETURN.md

```markdown
# Return -- Snorkel Toast, round 1

## The inventory
[Job one, in full. This is the most important section in the document.]

## The venture as I understand it
[One sentence. Then: decided, and open.]

## What is in this drop
[every asset, with status]

## What I left out, and why

## Revisions to understanding
[Mandatory. Present-but-empty when there is nothing.]

## Decisions I made that you did not ask me to make
[Every place a gap was filled. The list that gets audited.]

## What I could not do, and why

## What I would do next
```

## Why job one comes first even though job two is the deliverable

I cannot see this project. I tried: the browser I drive is signed into a different
account, and the share links returned *project not found*. So the inventory is not
box-ticking -- it is the only way the facts you hold reach the repository, and until
they do, every future round starts from a holding page that says "Coming soon!".

If the packaging runs out of time, **the inventory is the thing to finish.** A complete
inventory with half the assets packaged is a good session. A full set of assets with no
inventory leaves me exactly where I started, holding artefacts I cannot brief against.
