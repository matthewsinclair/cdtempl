---
verblock: "30 Jul 2026:v0.1: matts - Export brief: finish outstanding work, then export everything as-is"
---
# Export brief -- Baize design system

## What tonight is

**Finish your own outstanding work, then export everything you hold, exactly as it is.**

That is the whole job. One complete zip, in your current shape, with nothing reorganised.

## What tonight is NOT

**Do not restructure anything.** Not into a new directory layout, not into anyone else's
convention, not into the Cdsync asset shape. If you have seen a brief from me describing
`assets/<slug>/` directories with a `spec.md` front-matter block -- **ignore it for this
round.** That brief was written before we agreed the order of work, and it asked for the
restructure too early.

The reason is simple: I have not seen your current state, and I was writing blind. A
restructure designed from a description rather than from the material is a restructure
done twice. So tonight we get the material onto disk, we look at it, and *then* I write
you a precise conversion brief against what actually exists rather than what I imagined.

**Nothing you deliver tonight will be thrown away.** It becomes the input to the
conversion, and the conversion is a later round.

## One thing to change: where your documents say the drop lives

Every project in this programme now installs at **one path, and the same path**, in its
own repository:

```
<repo>/design/system/
```

No exceptions, in any project. Your own guides currently point somewhere else --
`intent/_inbox/lit-pool/` and similar -- and those references become wrong the moment
this lands.

So: **sweep your own documentation and re-point every local path reference to
`design/system/`.** `START-HERE.md`, `README.md`, `CLAUDE.md`, `HOWTO.md`, `RELEASE.md`,
build scripts, anything that names a destination. Relative paths *inside* the drop stay
exactly as they are -- those are correct and must not move. It is only the statements
about where the drop as a whole belongs that need changing.

If you cannot find them all, say so in the manifest rather than guessing.

## Your outstanding items

From your own last summary, two scripts have never actually been run and one thing has
never been looked at:

- **`node docs/bin/build-docs.mjs`** -- run it for real. You expect 105 sections and both
  checks clean. If the count or the checks disagree with that, the disagreement is the
  most interesting thing in tonight's delivery.
- **`docs/bin/build-team-site.sh`** -- run it for real. You expect `clean. N files.` The
  leak guard has been logic-verified but never executed, and an unexecuted guard is not a
  guard.
- **Serve the site and look at it.** `python3 -m http.server 8000`, then
  `localhost:8000/docs/site/`. Nobody has seen it rendered.

Two things to record rather than act on:

- **ADRs 0021-28 are unratified**, and you have said **ADR-0021 overturns ST0009's
  Highlander rule** while 0022 changes what the player surface reads. Do not act on them.
  Put them in the manifest as awaiting my ratification, with a line each on what changes
  if they are accepted.
- **The release you describe as complete has never reached my disk.** What I have is the
  28 July snapshot. Tonight's export is the first time your current state lands here, so
  treat it as a first delivery rather than an update.

## What the export must contain

Everything. Sources, generated markdown, page captures, the reading room, PDFs, PPTX,
prototypes, handoff material, build scripts, your own guides. If it is in the project, it
goes in the zip.

Do not curate, do not trim to what seems relevant, and do not leave out something because
it looks like an intermediate artefact. Disk space is not a constraint -- I have been told
explicitly not to optimise for it. **A file you leave out is a file I cannot see, and I am
writing the conversion brief from what I can see.**

The one exception is genuine scratch: if something is a dead end you would not want
preserved, leave it out and name it in the manifest so the omission is a decision rather
than a gap.

## `INVENTORY.md` at the root of the zip

This is the most valuable file in the delivery. It is what I read first and what the
conversion brief gets written from.

```markdown
# Inventory -- Baize design system

## What this project is
[One paragraph. Assume I know nothing.]

## The shape
[Your top-level directories, and what each holds. A tree is ideal.]

## Every document
[A table: name, what it is, its state -- agreed, provisional, draft, stale --
 and whether anything generated from it is now out of date.]

## Canonical versus generated
[Which files are sources and which are derived from them. If a generated
 output disagrees with its source, say which wins.]

## Confidential material
[Anything that must never reach a public or team-wide surface, named file by
 file or directory by directory.]

## What I finished tonight
[The outstanding items below, and their outcome.]

## What remains outstanding, and whose call it is
[Especially anything waiting on a decision from me.]

## What I left out of this zip, and why
```

## The three rules for tonight

1. **As-is beats tidy.** A faithful dump of a messy tree is worth more than a clean one
   that has been quietly rearranged. I need to see what is really there.
2. **Say what state things are in.** Half-finished, superseded, stale, never-run: all of
   that is useful and none of it is embarrassing. A drop that presents everything as
   finished is a drop I will misread.
3. **Flag anything waiting on me.** If a decision of mine is blocking you, name it in
   the manifest. Several of those are already outstanding and I would rather have the
   list than discover it later.

## If something here does not make sense

Say so in `INVENTORY.md` and do the sensible thing. This brief was written quickly, by
someone who has read a summary of your project but not its contents, at the end of a long
day. The export matters more than any instruction in it.
