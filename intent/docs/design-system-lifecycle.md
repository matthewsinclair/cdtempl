---
verblock: "31 Jul 2026:v0.2: Matthew Sinclair - The tree is the SSOT and Claude Design is a tool; the loop, and never repairing a drop"
status: Canon
---

# The design system lifecycle

**This is project-management canon for Cdtempl and for every project that uses it.** Stated by
hv on 2026-07-30. Everything else in this repository defers to it -- if a brief, a spec or a
board entry disagrees with this document, this document is right and the other is a defect.

## The one paragraph

`design/system/` is the **output of the Claude Design process**, managed in and out of a
project by Cdtempl. The whole deliverable lives there -- venture documents, the markdown, the
microsite, the lot -- and it is **checked into the repository with the rest of the project**.
Nothing in the application runs on any of it. It is **specification**: requirements, and
information. The design system that the project actually runs is **built separately, here,
in project-specific technology**, by taking that tree as the spec and rolling it out as makes
sense.

## The tree is the source of truth, and Claude Design is a tool

`design/system/` is the **single source of truth** for the project's design system. Claude
Design is a **clamp-on tool** used to work on it, not the place it lives.

That inverts how this started, and it is deliberate. While the authoritative copy lived
inside a Claude Design project, the source of truth was somewhere that **cannot be diffed,
reviewed or reverted** -- and every hard-won caution in this repository is a symptom of that
one fact. Corrections had to be hand-carried into a chat session and hoped for. A drop could
be *ahead* of its repository as easily as behind it, with truth flowing differently per
document. Identifiers were allocated blind because no brief carried the project's high-water
marks, and it cost a full export cycle. Two copies with no authority between them produced a
stale mirror that looked exactly like a live one.

With the tree authoritative: a correction is a commit, the high-water marks are in the
material, and truth has one direction with a rest point where the repository always wins.

**What the project then does with the design system is entirely the project's business.** A
project using Cdtempl has exactly one concern -- `design/system/` -- and Cdtempl's whole job is
syncing that in and out of Claude Design. No Cdtempl protocol material belongs inside a
project's tree: no outbox, no whiteboard, no handover scaffolding. If Cdtempl needs a sample or
a template, it lives in Cdtempl.

## The loop

The working relationship is a **long-running Claude Design project**, synced each round:

1. Cdtempl creates `design/system/` and generates `BOOTSTRAP-CD.md` -- over an empty tree, the
   instructions telling a cold Claude Design project what to build and how.
2. Claude Design runs a round and exports what it holds as an archive.
3. The archive lands in `_inbox/`, and Cdtempl unpacks it into `design/system/`.
4. Cdtempl checks the result against the process. **Gaps are recorded in `addenda/`, never
   repaired in place.**
5. Cdtempl generates the delta back out, and the next round starts from it.

**A cold start is the same generator, not a second mechanism.** Run over an empty tree it
yields the initial instructions; run over a populated tree it yields everything a fresh
Claude Design project needs to resume where the last one stopped. Two documents built
separately drift, and hand-authored drift is the defect already recorded three times against
`cdtempl brief`.

**Bootstrap is an invariant before it is a workflow.** Its value is that it states the SSOT
claim in testable form: if a cold Claude Design project can be reconstructed from
`design/system/` alone, then nothing important is hiding in a chat log. So it must be
*exercised*, not merely provided -- an unexercised guarantee is a claim, and this project has
shipped bugs whose synthetic fixtures agreed with every one of them. `BOOTSTRAP-CD.md` is
therefore regenerated as a byproduct of every sync rather than by a command someone remembers
to run: its use stays rare, its currency is continuous.

**Across syncs. Not across repo-side edits, and that gap has bitten once.** Retiring an
addendum is a repo-side edit -- no install, no import, nothing to hang the regeneration on --
so Baize's document went on quoting two addenda for the five hours between their retirement
and the next regeneration. Had it gone out in that state it would have handed Claude Design
two gaps it had already closed, in the receiving project's own voice, to be absorbed and
retired a second time: exactly the failure the addenda protocol exists to prevent, produced
by the mechanism meant to prevent it. **Regenerate after touching `addenda/`, and read a
generated document against the tree before sending it** -- which is the standing rule, and it
is the one that caught this.

`BOOTSTRAP-CD.md` is declared in `CDTEMPL_DROP_PROTECTED_PATHS` alongside `addenda/`. It is
Cdtempl's output living inside Claude Design's tree, so without that an export overwrites it.

## Cdtempl does not repair a drop

When a check finds a problem there are two honest outcomes, and repair-in-place is not one:

- **Record the gap in `addenda/`**, in the drop's own voice, so it flows back to Claude
  Design and retires when a later drop absorbs it.
- **Refuse**, and send it back to Claude Design to be fixed at source.

If Cdtempl edits drop content, the tree stops being what Claude Design produced and a re-export
diff stops meaning *the design changed* -- the same reason `.prettierignore` excludes the
tree. An addendum is therefore **the artefact itself, not a changelog of an edit made
elsewhere**.

## Two artefacts, two lifecycles

| | `design/system/` | The rolled-out design system |
| - | ---------------- | ---------------------------- |
| What it is | The delivered specification | The running implementation |
| Who authors it | Claude Design | This project |
| How it changes | An iteration with CD, mediated by Cdtempl | Ordinary development |
| Hand-edited? | **Never** -- except `addenda/` | Continuously |
| Does the app read it? | **No. Not ever.** | It *is* the app |

**The app must never read from `design/system/` at runtime.** If an import path, a build
step or a stylesheet ever reaches into it, that is a defect in the project, not a
convenience. The tree is a reference, and a reference the runtime depends on has stopped
being a reference.

## Why it is tracked rather than excluded

**So the specification can be diffed against the implementation.** That is the whole reason.
Treating the design system as requirements only works if the requirements are in the
repository, versioned alongside the code they are meant to govern, at the revision the code
was at.

An excluded drop cannot serve that purpose, and the bookkeeping an exclusion demands
produces something worse: a tracked *subset* of the drop, landed into `docs/` so it travels
with the repo, which then goes silently stale. Baize had exactly that and deleted it on
30 July -- 111 of 131 files byte-identical to the drop, and every one of the 20 that differed
was the older version.

One exclusion remains and it needs no defending: `design/system/_inbox/` is the drop-off
point for delivery archives. They are ephemeral transport -- dropped in, unpacked by Cdtempl,
regenerated from Claude Design whenever one is wanted again. Nothing is in them that is not
already unpacked and tracked beside them. This used to be written up as a platform limit,
with GitHub's 100MB refusal and blobs stuck in published history; that framing produced
45-line `.gitignore` comments defending a one-line rule, and it is retired. There is nothing
to track, and that is the whole of it.

## A copy of the project's own documents is a one-round delivery

The same failure as `docs/design/` above, running the other way. That was a copy of the
drop landed in the repository; this is a copy of the repository landed in the drop, and it
goes stale by exactly the same mechanism.

Both app projects carry one at `design/system/handoff/intent/`, and measuring them on
31 July 2026 showed they are **opposite cases with the same remedy**. Neither content site
has one at all.

| | Baize -- **28 files** | Lamplight -- **58 files** |
| - | --------------------- | ------------------------- |
| What it holds | Copies of threads the repository owns, ST0016 to ST0023 | Nine threads **Claude Design authored**, ST0334 to ST0342 |
| In the repository? | 19 of 28 at their own path | **None.** Its high-water is ST0330 |
| Which way truth flows | Given to CD to read, then edited by it | Drafted by CD for the project to adopt |
| To retire it | Carry CD's edits back into `intent/st/` | **Adopt the nine threads** into `intent/st/` |

Baize's had already drifted in two dimensions at once. **Content:**
`intent/st/ST0016/acceptance.md` is 129 lines in the repository and 237 in the copy, because
Claude Design rewrote AC-04.6 and added AC-04.8 there. **Structure:** the nine with no
counterpart are not additions -- the repository moved those threads under
`intent/st/NOT-STARTED/` and the copy still has them flat.

So it is not merely a duplicate, it is a **second and differently-wrong answer** to what
ST0016 requires -- and the install widens the gap rather than closing it, because the drop's
copy is replaced and the repository's is not.

Lamplight's is the same hazard before it has had a chance to bite: nine steel threads that
exist in exactly one place, and that place is a directory the next export overwrites.

**The rule (hv, 31 July 2026): the project's `intent/` documents may be handed to Claude
Design for a round, and they retire from the drop once actioned. They must not persist for
more than one go-around.** Claude Design can be told they have been actioned -- for these
projects it can read the repository directly, so it does not need the copy to see them.

Which is the general principle restated: **material whose home is the repository is
borrowed by the drop, never housed in it.** The one direction that is not borrowing is
`addenda/`, and that is repo-authored *about* the design rather than a copy of anything.

## Classification governs display, never tracking

Three values, an axis of their own and not a flavour of `audience`:

| Classification | Means |
| -------------- | ----- |
| `public` | May be shown externally |
| `internal` | Within Geodica or the venture only |
| `confidential` | Internal **and** behind access control; the mechanism is project-specific and still to be defined |

**Everything is tracked regardless of classification.** Classification answers *where may
this be shown*, never *should this be committed*. It is not a delivery filter and must not
be used as one.

### Declaring the field is only half of separating the axes

The other half is taking the value **out of `audience`**, and leaving it there keeps the two
conflated in the one place the conflation began. `audience` answers *who a thing is for* --
`printer`, `developer`, `investor`, a named person -- so `audience: ["internal", "jen"]`
becomes `audience: ["jen"]` once `classification` carries the rest.

**`public` is the exception and a real one.** It is a legitimate answer to both questions: the
general public genuinely is who a landing page is for, and that is independent of where the
page may be shown. Only `internal` and `confidential` can reach `audience` by conflation,
because neither says anything about who a thing is *for*.

This was learned by watching the instruction fail. Three projects adding classification for
the first time did the whole job, because on a tree carrying the field nowhere, "declare it"
is a complete instruction. **The fourth already carried it on all sixteen assets and still
carried `internal` in `audience` on eleven** -- so a pass that did exactly as it was told
moved the finding count not at all. A rule that can only be satisfied by an instruction nobody
wrote is a defect in the document, not in the supplier.

## `spec_version` is the library's stamp, not a per-drop counter

**It records which version of the library specification an asset was built from**, copied
unchanged into the drop's `spec.md`. Claude Design does not increment it. A new draft of the
same asset against the same specification carries the same number as the last one, and that
is correct.

The comparison is the entire reason it is stamped: the library here is the source of truth,
the drop carries a duplicate, and `check` rule 2 measures the distance between them. **A
number each side increments on its own schedule cannot measure a distance**, because it
never disagrees for a reason. An asset's own progress is `status` and `coverage`; that is
where a round's work shows up.

Both readings shipped at once, which is how this got settled. The field was asked for by
name in the brief and read by name by `check`, and **nothing anywhere said what it counted**
-- so Claude Design supplied the only reading available to it and bumped all sixteen of Gyre
& Gymble's assets to 2 on the round that added classification. Fourteen were flagged. The
two that were not are the ones worth remembering: their library entries happened to also be
at 2, so the check stayed silent over two assets stamped exactly as wrongly as the fourteen.
**Two unrelated counters colliding reads as agreement.**

The remedy was not to pick the reading the tool already assumed. It was to say so in the
generated documents, because an undefined field is answered by whoever reads it next.

`kit_version` works the same way, against the kit.

### Saying what it means is not enough -- the document carries the numbers

Defining the field settled what the stamp *was* and left the drop no way to obtain it. **Claude
Design cannot read the library.** It holds a delivery, and the library lives here, so an
instruction to copy the specification's version is unusable on its own.

That surfaced the round after, in three different shapes at once: one project asked for the
numbers by name, one left every stamp unset and said why in its return note, and one reset
sixteen assets to 1 against a library holding two of them at 2. **All three were reasoning
correctly from a document that had withheld the one fact they needed.**

So `BOOTSTRAP-CD.md` now states them -- a table of every asset in the tree against the version
the library holds for it, generated at the moment the document is written, plus `kit_version`
for the whole library.

**And it answers for an asset the library does not hold, which is the commoner case rather than
the edge.** Only one of the four trees in round one was built from taxonomy slugs at all. For
the rest the honest number is no number, so the document says to leave the field out and not
invent one -- because an absent stamp is a correct answer, and a self-chosen number is the
revision counter this whole section exists to stop.

## The design system is an end-state view

The project will not arrive there in one jump. It takes development, iteration, refinement.

**So a gap between `design/system/` and the application is expected and is not a defect.**
Any check comparing the two reports *distance from the end state*, which is information, not
a failure. Nothing should ever block because the app has not caught up with the spec.

## How it changes

Through **an iteration with Claude Design, mediated by Cdtempl**. Not by editing the tree.

The single sanctioned exception is `addenda/`: repo-authored material *about* the design,
written where the design has a gap, which flows **back** to Claude Design and **retires when
a drop absorbs it**. It is declared in `lib/drop.sh` as `CDTEMPL_DROP_PROTECTED_PATHS` and no
install path may overwrite it. An addendum records a gap in the drop's own voice; it is not
a place to design things.

## Two install paths, and choosing wrong is the most destructive thing here

**Cdtempl's owned-path contract is narrower than the deliverable.** `import` writes exactly
`assets/`, `kit/`, `notes/`, `index.md` and `RETURN.md`. The deliverable is the *whole tree*
-- and this canon says Cdtempl manages that tree in and out. So there are two commands, and
they are not variants of each other:

| The artefact | The command | What it does |
| ------------ | ----------- | ------------ |
| An **as-is export** -- the whole tree | `cdtempl install` | Replaces. What the drop does not carry is **removed**, and every removal is printed |
| A **converted drop** -- a subset, the five owned paths | `cdtempl import` | Merges. What the drop does not carry **survives** |

**An as-is export is the whole tree, so it is installed. A converted drop is a subset of it,
so it is imported.** Reach for the wrong one and either the venture set, the microsite and
the prototypes are deleted, or nine-tenths of the drop is reported as `ignore` and dropped
on the floor.

`cdtempl install` was built on 30 July 2026 and closed the gap this section used to describe:
before it, `import` protected repo-authored work but could deliver only five paths, a
hand-unzip replace delivered the whole tree but destroyed anything repo-authored, and there
was no third option. **Hand-unzipping a drop is now never correct.**

It refuses over a target holding uncommitted or untracked content, because the tree being
tracked in full is what makes a replace reversible -- git holds every prior state, so the
tool's job is to prove that copy is complete rather than to make another one. `addenda/`
and anything gitignored survive regardless.

**The synced loop retires this choice, and that is the point of it.** Choosing between the
two is a human reading an archive and inferring whether it is a whole tree or a subset -- and
this section calls getting it wrong the most destructive mistake available here. A Claude
Design project synced from `design/system/` always holds the whole tree, so it always exports
the whole tree, so `install` is always correct. `import` remains for the subset case that
predates the loop; it is not the road forward. **A judgement that cannot be made wrong beats
a judgement documented well.**

## Consequences for anything written before this

- A brief may scope what is **converted** in a round. It may not scope what is **stored** --
  storage is the whole deliverable, always.
- "Excluded from this round" therefore means "not turned into an asset yet", never "removed
  from `design/system/`".
- No project should have a `docs/design/` mirror. If one exists it is stale.
- `.prettierignore` excludes `design/system/`, and that stays. It is about byte fidelity
  across re-exports: a re-export diff must mean "the design changed", not "the formatter
  ran".
