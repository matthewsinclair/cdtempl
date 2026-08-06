---
verblock: "30 Jul 2026:v0.1: Matthew Sinclair - What a Claude Design session needs to know about the Cdsync contract"
status: Protocol
---

# The Claude Design contract

**For a Claude Design session producing drops that land in a Cdsync-managed project.** Self-contained: you do not need the Cdsync repository to follow it.

This is not a brief. A brief orders a specific round; this is the standing contract every round is written against.

## What happens to what you export

Your export lands in `<project>/design/system/`, **checked into the project's repository in full**, and is treated as **specification**. Nothing in the application runs on it. The project builds its own design system separately, in its own technology, taking your tree as requirements.

Three consequences that change how you should work:

- **It is versioned alongside the code it governs**, so the project can diff its implementation against your specification at any revision. Byte fidelity between re-exports matters: a diff should mean "the design changed", not "the formatter ran".
- **It is never hand-edited by the project.** The only way it changes is another round with you. So anything wrong in a drop stays wrong until you fix it.
- **It is an end-state view.** The project will not get there in one jump, and the gap is expected. You are not describing what exists; you are describing what should.

## Two export shapes, and the brief says which

| Shape | Top level | Installed by |
| ----- | --------- | ------------ |
| **As-is** | Everything you have -- venture docs, the markdown, the microsite, prototypes, handoff | `cdsync install`, which replaces the tree |
| **Converted** | Exactly `assets/ kit/ notes/ index.md RETURN.md` | `cdsync import`, which merges into the tree |

**Do not guess which one is wanted.** A conversion brief asks for the second and says so; an export brief asks for the first. Emitting an as-is tree when a conversion was ordered, or the reverse, is not a formatting difference -- the two are installed by different commands with opposite semantics.

## `classification` on every asset -- this is new

Every `spec.md` carries a `classification` field. Three values, and it is an axis of its own rather than a flavour of `audience`:

| Value | Means |
| ----- | ----- |
| `public` | May be shown externally |
| `internal` | Within Geodica or the venture only |
| `confidential` | Internal **and** behind access control; the mechanism is project-specific and still to be defined |

**It governs where material may be shown, never whether it is committed.** Everything is tracked regardless of classification. Do not treat it as a delivery filter and do not omit material because of it.

This field exists because `audience` was doing three jobs at once. `audience` keeps the "who is this written for" job.

## Never allocate a number blind

ADR, ST and WP numbers are allocated in the project's repository, not in yours. Allocating one blind produces a collision that costs a full export cycle to unpick -- it cost exactly that on Lamplight in July 2026.

**Every brief carries the project's current high-water marks in a table.** Allocate above them. If a brief reaches you without that table, **ask for it before you allocate anything**; do not infer the next number from what you can see, because you cannot see the project.

## Corrections land at source, never only in the delivery

A fix applied to a delivered artefact does not propagate back into whatever generated it, so **the next export reverts it**. Lamplight's July renumbering was corrected in the delivery, under a heading reading "do not re-derive", and the next export reverted both it and a ratified decision in one step.

When you are told something is wrong, change the thing that produces it.

## `addenda/` flows back to you

`addenda/` is repo-authored material *about* the design, written by the project where the design has a gap -- copy for a state your corpus does not carry, and the like. It is the one thing under the target that does not come from you.

- It is **protected**: no install path overwrites it, and a drop that carries one has it discarded.
- It flows **back**. Treat an addendum as an input: it names a gap in your own voice.
- It **retires when a drop absorbs it**. When you have covered the gap, say so in `RETURN.md` and the project removes the addendum.

## `RETURN.md` is mandatory, and so is its empty section

Every drop carries `RETURN.md` at its root with a **`revisions to understanding`** heading -- present even when there is nothing to say.

Design and venture work inform each other reciprocally and non-linearly, so the most valuable thing in a round is sometimes a changed mind rather than an artefact. An optional section for that would be empty every time.

## Say what you could and could not see

Two things that vary per round and that the project cannot determine from this side:

- **Whether your session could read the project's repository is per project, not universal.** Baize's session had its repo attached and read `docs/adr/` directly; Lamplight's did not, which is why its notes had to be self-contained. **Say which applied**, in `RETURN.md`. The project has assumed wrong in both directions.
- **A drop can be ahead of its repository, not only behind it.** Baize's ADR-0025 carried decisions settled the same day; the repo's copy was two days older with zero mentions. So there is no one-directional merge rule -- truth flows differently **per document**. Name the documents where your copy is the current one.

## The two `spec.md` documents are not the same document

- The **drop-side** `spec.md` says what *this venture* delivered: `status`, `coverage`, and blanks that are computed rather than declared.
- The **library-side** spec says what *done* means for the class: `taxonomy`, and `inputs_missing` phrased as questions to ask any venture.

Harvesting one into the other is generalisation and it needs judgement. Do not copy a venture's specifics into a library spec.

## If you regenerate something, say so -- and if you cannot, say that too

A generated artefact rendered outside your project picks up different fonts and may paginate differently, so page 5 might not be page 5. **Stale beats plausible-but-wrong.** Lamplight's session reached this rule on its own in July, leaving a two-day-old page capture rather than shipping a wrong one, and that was the right call.

## Still unruled, so do not assume either way

**Is `formats_required` a narrowing of what "done" means, or advisory?** It appears in none of Gyre & Gymble's 16 specs, and two suppliers independently concluded an asset can be complete without its formats. Until it is ruled, do not treat a missing format as incompleteness, and do not treat the field as decorative. Flag it and carry on.
