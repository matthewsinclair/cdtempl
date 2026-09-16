---
verblock: "31 Jul 2026:v0.2: Matthew Sinclair - Your only concern is design/system/; the tree is the SSOT and Claude Design is a tool"
status: Protocol
---

# Receiving a design system

**For a Claude Code session in a project that receives Claude Design drops through Cdtempl** -- Lamplight, Baize, Gyre & Gymble, snorkeltoast, and anything after them. Self-contained: you do not need Cdtempl's repository to follow it.

The companion document is `intent/docs/design-system-lifecycle.md` in the Cdtempl repo, which is canon. This is the operational half.

## What `design/system/` is

It is the **output of the Claude Design process**, managed in and out of your project by Cdtempl. The whole deliverable lives there -- venture documents, the markdown, the microsite, the prototypes, the lot -- and it is **checked into your repository with the rest of the project**.

**Nothing in your application runs on any of it.** It is specification: requirements, and information. The design system your project actually runs is **built separately, by you, in your own technology**, by taking that tree as the spec and rolling it out as makes sense.

If an import path, a build step or a stylesheet ever reaches into `design/system/` at runtime, that is a defect in the project. A reference the runtime depends on has stopped being a reference.

## Your only concern is `design/system/`

**That directory is the whole of your relationship with Cdtempl.** It is the **single source of truth** for your design system; Claude Design is a clamp-on tool used to work on it, not the place it lives. Cdtempl's entire job is syncing that one tree in and out of Claude Design, at the checkpoints where you ask it to. Everything else -- how you roll the design system out, in what technology, at what pace, in what order -- is **entirely yours**, and Cdtempl has no opinion about it and never writes outside the target.

**So no Cdtempl protocol material belongs in your tree.** No outbox, no whiteboard, no handover scaffolding, no sample or template project. If a drop ever arrives carrying any of it, that is the export being wrong: delete it, and say so back to Claude Design so it stops being emitted. snorkeltoast's 30 July export carried a `design/system/cdtempl/` tree -- a `RETIRED.md`, an `OUTBOX.md` and a fake `intent/whiteboard/` skeleton with `cc` and `cd` nodes in it -- for a protocol that was designed, never built and then abandoned. It was deleted on 31 July. Anything globbing for `intent/whiteboard/` or reading an `OUTBOX.md` must never reach material like that.

## Getting a drop in: two commands, and picking wrong is the worst mistake available

| The artefact | The command | What it does |
| ------------ | ----------- | ------------ |
| An **as-is export** -- the whole tree, everything Claude Design has | `cdtempl install <zip>` | **Replaces.** What the drop does not carry is removed, and every removal is printed |
| A **converted drop** -- a subset, just `assets/ kit/ notes/ index.md RETURN.md` | `cdtempl import <zip>` | **Merges.** What the drop does not carry survives untouched |

An as-is export **is** the whole tree, so it is installed. A converted drop is a **subset** of it, so it is imported. Reach for the wrong one and you either delete the venture set, the microsite and the prototypes, or you take delivery of a tenth of the drop and see the rest reported as `ignore`.

**Do not hand-unzip a drop.** That instruction was correct until 30 July 2026, when `install` did not exist and `import` would have discarded most of an as-is dump. It is now never correct. A hand replace is what destroyed Baize's repo-authored work between two drops on that day -- a handoff file and eight ADR banners, noticed only by someone seeing they were gone.

Both paths pre-flight the archive before unpacking: absolute paths, `..` traversal, symlinks, entries differing only in case, and integrity. All five were a hand ritual until the same day.

## Commit before you install

`cdtempl install` **refuses over a target holding uncommitted or untracked content**, and `--force` overrides it while saying plainly that it is not recoverable.

This is not fussiness. There is no backup directory anywhere in this design, deliberately -- `design/system/` is tracked in full, so **git already holds every prior state of it**. The tool's job is therefore not to make another copy but to prove the copy git holds is complete before destroying anything. Uncommitted work is exactly what git could not give back.

If the refusal names something repo-authored, it belongs in `addenda/` (below), not loose in the tree.

## What survives a replace

| Kept | Why |
| ---- | --- |
| `addenda/` | Repo-authored. Declared protected; no install path may overwrite it |
| Anything gitignored | Git cannot restore what it never tracked, so the argument above does not cover it |

`_inbox/` is the live second case. It holds the delivery archives themselves, and replacing over it would destroy the only copy of the thing being installed.

## `addenda/` is the one sanctioned way to write into the tree

The design system changes **only through an iteration with Claude Design, mediated by Cdtempl**. Not by hand-editing.

The single exception is `addenda/`: repo-authored material *about* the design, written where the design has a gap -- copy for a state the design corpus does not carry, and the like. It flows **back** to Claude Design and **retires when a drop absorbs it**. An addendum records a gap in the drop's own voice; it is not a place to design things.

A drop never supplies `addenda/`. If one arrives carrying it, both install paths discard it and say so.

## Tracked in full

Everything under `design/system/` is committed. One exclusion remains and it needs no defending: `design/system/_inbox/` is the drop-off point for delivery archives. They are ephemeral transport -- dropped in, unpacked by Cdtempl, regenerated from Claude Design whenever one is wanted again. Nothing is in them that is not already unpacked and tracked beside them.

The correct form is a tracked `design/.gitignore` holding `/system/_inbox/` and nothing else. If yours still holds `/system/`, it is the superseded version -- and if that file is itself untracked, it does not travel to a clone and `git clean -xfd` deletes the thing protecting the tree.

**A drop carries its own `design/system/.gitignore` with `_inbox/` in it, and that is not a substitute -- keep both.** The overlap looks like a duplicate and is not: the drop's copy is *drop content*, replaced wholesale by every export, so it is only ever as reliable as the last export happened to be. On 31 July 2026 Lamplight's export **dropped that file entirely** -- no `.gitignore` anywhere in a 382MB archive. Lamplight was unharmed because its repo-owned guard sits outside the target and survives a replace. Baize had deleted its own the day before, on the reasoning that the rule was redundant, and had to have it restored. **Do not tidy the duplicate away.**

One trap when you check this: `git check-ignore -v` reports the *deepest* matching rule, so while the drop-carried file exists it will name that one and tell you nothing about whether your repo-owned rule works. Test it with the drop's copy absent, in a scratch repository, or you have proved nothing.

Keep the comment short. This rule was once written up as a platform limit, with GitHub's 100MB refusal and blobs stuck in published history, and the result was 45-line comments defending one line. There is nothing to track. That is the whole of it.

## Classification governs display, never tracking

Three values, an axis of their own:

| Classification | Means |
| -------------- | ----- |
| `public` | May be shown externally |
| `internal` | Within Geodica or the venture only |
| `confidential` | Internal **and** behind access control; mechanism is project-specific and still to be defined |

**Everything is tracked regardless.** Classification answers *where may this be shown*, never *should this be committed*. It is not a delivery filter and must not be used as one.

## Rolling it out is your job, and the gap is not a defect

Take the tree as requirements and implement it in your own technology, at your own pace. It is tracked precisely so your implementation can be **diffed against the specification** at the revision your code was at.

**The design system is an end-state view.** The project will not arrive there in one jump. So a gap between `design/system/` and the application is **expected and is never a defect** -- any check comparing the two reports distance from the end state, which is information. Nothing should ever block because the app has not caught up with the spec.

## If you have these, they are stale

- **`docs/design/`** -- no project should have one. Baize's looked canonical: 129 tracked files, cited by its own `wip.md`, `restart.md`, `DECISION_TREE.md` and whiteboard node. It was checksummed on 30 July: **111 of 131 files byte-identical to the drop, and every one of the 20 that differed was the older version**. Three of its citations pointed at a directory that had never existed. It is deleted. A stale mirror looks exactly like a current one, so scrutiny does not separate them -- only a checksum against the drop does.
- **`design/.gitignore` holding `/system/`** -- superseded. See above.
- **Any backup of the tree under `~/Downloads/`** -- the hand process made these. Git holds the history now.

## What `cdtempl check` will and will not tell you

`check` holds a drop against its own specifications. **An as-is export is not Cdtempl-shaped and `check` will refuse it -- correctly.** Three of the four 30 July drops are refused this way; only Gyre & Gymble passes, because it is already Cdtempl-shaped.

A refusal reading `0 assets checked` means the tree has an `assets/` that holds no asset slugs. Three of the four projects use `assets/` for something else entirely -- loose brand files in Baize and snorkeltoast, media *directories* in Lamplight. That collision is real and it is on the project side; the drop contract owns the name `assets/`.
