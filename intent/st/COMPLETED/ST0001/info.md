---
verblock: "29 Jul 2026:v0.3: matts - Reframed again: build generic templates in a fresh CD project, retrofit after"
intent_version: 2.17.3
status: Completed
slug: harvest-template-v0-from-the-three-claude-design
created: 20260729
completed: 2026-08-02T09:54:45Z
---

# ST0001: Build the generic template suite and the four specifications

## Objective

Establish the four things Cdsync regularises, built generically in a fresh Claude Design project rather than derived from any existing venture:

1. **The brief format** -- what Claude Design receives at the start of every venture.
2. **The output structure** -- the mandated directory layout it delivers into, so every round lands identically and `cdsync import` can be mechanical.
3. **The asset taxonomy** -- the full list of design and venture asset types. Roughly twenty, not the three named as examples.
4. **The per-asset specification** -- what each type consists of: sections, formats, and a definition of done. Plus a built template for each, where a template makes sense.

The fourth is the main event. A taxonomy gives an asset a name; a specification lets someone say whether the thing that arrived is finished. That is where predictability comes from, and no amount of automation substitutes for it.

The brief to Claude Design is `cd-brief.md` in this directory. The work lands at `templates/claude_design/templprj/` -- a deliberately neutral placeholder venture that gives the templates something concrete to be templates of, and doubles as the worked example of the mandated output layout.

## Context

Cdsync regularises the Claude Design process for a set of problems that have recurred across several ventures. The goal is **regular and predictable** first, **automated** second -- the first matters considerably more, and the second is only worth doing because it is now cheap. If the whole process were executed by hand and never scripted, the regularity would still be most of the value. That ordering should drive the build order: specifications before machinery.

**Templates are built generically, in a fresh Claude Design project.** Building them inside a live venture would bake that venture's direction into everything produced afterwards, and the bias would be invisible by the time anyone noticed it. Retrofitting the finished process onto the existing ventures happens afterwards and is cheap.

Working assumption, stated for challenge: the specs are a **library** and the brief is an **order against it**. Selection varies per venture; what a complete design system needs does not. Improving a spec therefore improves every future venture without touching a single brief.

Full model in `design.md` alongside this file. The load-bearing parts:

- Claude Design is a **supplier working to a brief**, not a peer node. **It cannot read this repository at all** -- not by git, not by mount. Every input arrives as an upload from hv, so briefs must be self-contained; artefacts come back as a zip.
- **Cdsync never writes into the application.** The boundary is `$CDSYNC_TARGET`, defaulting to `design/`. Structure underneath it is standardised; the location is not.
- `$CDSYNC_TARGET` is the as-designed record; the app is the as-built. Keeping them apart is the point.

## Notes on execution

Claude Design works from a **fresh project**, receiving `cd-brief.md` as an upload from hv. It cannot read this repository, so the brief carries everything a round needs.

**Two rounds**, at `cd`'s proposal and hv's agreement. Round one is text only: taxonomy, priorities, per-asset specs, the neutral kit, the output structure proposal, dependencies, bundles, and what a brief must carry. Cheap enough to argue with. Round two builds the top handful into `templates/claude_design/templprj/` against whatever survives, and comes back as a zip. Splitting them matters because the build is expensive to redo if the specs turn out wrong.

There is no whiteboard node for `cd` and no inbox to post to. The `cd` node scaffolded on 2026-07-29 was retired to `intent/whiteboard/.archived/cd/` once the supplier model settled -- a board that never updates reads identically to a node that has not started, which caused a full round of confusion before the model was understood.

Superseded framings, recorded so the changes are legible rather than silent:

- `cd` owning a `template/` directory in this repo, with both parties committing to `main` and directory claims enforcing the split. `cd` cannot commit, so it was unenforceable as written.
- Imported artefacts fanned into `assets/`, `priv/static/`, and `lib/<app>_web/components/`. Rejected: it collapses as-designed into as-built, is unsafe against hand-edited components, and has no destination for artefacts that are not source code.
- Deriving the contracts by inventorying what the existing ventures shipped. Wrong target -- that reads what happened to land, not what the process should be. It also produced a detour into Laksa site config, which is downstream of this work entirely and not Cdsync's concern.

## Open questions

To be settled by Claude Design's answer, or shortly after:

1. What does "template form" mean per asset type? It will not be uniform -- some assets are documents with blanks, some are structures with placeholder values, and some may warrant a specification with no artefact at all.
2. Do the asset types cluster into orderable bundles -- a seed-raise set, a launch set, a rebrand set? With twenty-odd types, a brief listing each individually is unusable.
3. Where does "working on X changed my view of Y" belong in the return contract? The design and venture halves inform each other non-linearly, so a revised understanding is sometimes worth more than an artefact, and it currently has nowhere to go.
4. Is `$CDSYNC_TARGET/site/` delivered ready to serve, or built from markdown? The former would drop the only Node dependency in the design.
5. Does the target version in place, or accumulate side-by-side as-designed states? Git history plus `MANIFEST.md` answers "what did drop 2 change" without `v1/` and `v2/` directories.

## Acceptance

Acceptance Criteria and Acceptance Tests for this steel thread live in `acceptance.md` (the single source of truth). Do not restate ACs here -- see that file for the ratified completeness boundary and live status.

## Related Steel Threads

- None yet. `bin/cdsync` itself is downstream of this thread and will need its own.

## Context for LLM

This document represents a single steel thread - a self-contained unit of work focused on implementing a specific piece of functionality. When working with an LLM on this steel thread, start by sharing this document to provide context about what needs to be done.

### How to update this document

1. Update the status as work progresses
2. Update related documents (design.md, impl.md, etc.) as needed
3. Mark the completion date when finished
