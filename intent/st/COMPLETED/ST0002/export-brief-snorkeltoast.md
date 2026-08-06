---
verblock: "30 Jul 2026:v0.1: matts - Export brief: finish outstanding work, then export everything as-is"
---
# Export brief -- POP^UP^ART by snorkeltoast.com

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
`intent/_inbox/the flat layout/` and similar -- and those references become wrong the moment
this lands.

So: **sweep your own documentation and re-point every local path reference to
`design/system/`.** `START-HERE.md`, `README.md`, `CLAUDE.md`, `HOWTO.md`, `RELEASE.md`,
build scripts, anything that names a destination. Relative paths *inside* the drop stay
exactly as they are -- those are correct and must not move. It is only the statements
about where the drop as a whole belongs that need changing.

If you cannot find them all, say so in the manifest rather than guessing.

## First: one thread in this project is retired

This project has also been used as a coordination channel for the Cdsync tool, and that
conversation is **out of date**. It describes a handover protocol -- `template/**`
scaffolding, an `OUTBOX.md` bundle, a minted URL, `cdsync pull`, an allow-list, a commit sha
acknowledged through `intent/whiteboard/cc/inbox.cd.md`, and "the eight rulings".

**None of that exists.** I checked the repository and its full history: no `cdsync pull`
subcommand, no `template/` directory, no `intent/docs/handover-protocol.md`, no commit
`8b4f3bb4e18e`, no `cc/inbox.cd.md`. The `cd` whiteboard node is archived -- paused at
09:46 on 29 July, focus *"new workstream, not yet started"*. That channel was retired the
same day when the tool moved to the brief-out, zip-back model this document uses.

**Do not resume it and do not reconcile this brief against it.** Nothing is owed to it. If
that leaves you holding work you think should not be dropped, name it in `INVENTORY.md` --
but do not act on the old protocol.

## Your outstanding items

I know least about this project of the four, so I am not going to invent a list. **Tell me
what is outstanding** in the manifest, finish what you can, and flag the rest.

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
# Inventory -- POP^UP^ART by snorkeltoast.com

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

## The venture facts -- only you have these

This is the other half of tonight's value, and it is the half the repository cannot
supply.

The repository for this project is a holding page. It carries no statement of what the
venture is, who it is for, what has been decided, or what is still open. **You hold all of
that** and it currently exists nowhere else.

So `INVENTORY.md` must also carry:

- **What this venture is, in one sentence, for whom.**
- **What has been decided** and must not be reinvented. Be specific and be generous --
  this becomes the `fixed` list every future round is assembled from.
- **What is still open** and legitimately available to invent.
- **Locale, currency, and any regulatory or market scope** that has been settled.

Why this matters more than it looks: a brief assembled with placeholders in place of those
two lists was measured on another venture at **212 blanks, against 73 for the same four
assets with real facts**. Facts that live only in a conversation are facts the next round
loses.

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
