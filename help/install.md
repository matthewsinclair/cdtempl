# cdsync install

Replace the target with an as-is Claude Design drop, preserving what a drop cannot supply.

```
cdsync install <zip|dir> [--target PATH] [--dry-run] [--yes] [--force]
```

## install or import?

They are not variants of each other. They take different artefacts and have opposite
semantics, and picking the wrong one is the single most destructive mistake available
in this tool.

| | `import` | `install` |
|---|---|---|
| Takes | A **converted** drop — a subset, the five owned paths | An **as-is** export — the whole tree |
| Does | Merges. Anything in the target and absent from the drop **survives** | Replaces. Anything in the target and absent from the drop is **removed** |
| Wrong tool damage | Delivers a tenth of the drop; reports the rest as `ignore` | Deletes the venture set, the microsite, the prototypes |

**An as-is export is the whole tree**, so it is installed. **A converted drop is a
subset of it**, so it is imported. See `intent/docs/design-system-lifecycle.md`.

## Options

| Option | Effect |
|---|---|
| `--target PATH` | Override the target for this invocation |
| `--dry-run` | Print the plan and write nothing |
| `-y`, `--yes` | Skip the confirmation prompt |
| `--force` | Proceed over a target git could not restore. Not recoverable |

Without `--yes` it asks you to type `replace`. Non-interactively it refuses rather
than assuming consent.

## It refuses unless git can give the target back

There is no backup directory, on purpose.

`design/system/` is tracked in full, so **git already holds every previous state of
it**. The job is therefore not to make a copy — it is to guarantee the copy git holds
is complete before destroying anything. So the install refuses when the target carries
uncommitted or untracked content, because that is exactly what git could not return.

Commit it, stash it, or — if it is repo-authored material about the design — move it
into `addenda/`, which every install path preserves.

The hand process this replaces copied each target to `~/Downloads/backup/` first, and it
sat there for weeks because nobody remembered whether it was the only copy. Swept on
31 July 2026: **1.3GB, 2607 files, of which 2287 were recoverable from the projects' own
git object databases.** The 320 that were not were intermediate round snapshots that had
never been committed. So it was 96% redundant and 4% irreplaceable, mixed together with
nothing to tell the two apart -- which is the failure mode, rather than the size.

## What survives a replace

| Kept | Why |
|---|---|
| `addenda/` | Declared in `CDSYNC_DROP_PROTECTED_PATHS`. Repo-authored, flows **back** to Claude Design, never arrives from an export |
| Anything gitignored | Git cannot restore what it never tracked, so the recoverability argument above does not cover it |

`_inbox/` is the live second case: it is the drop-off point for delivery archives,
which are ephemeral transport and so are not tracked, and replacing over it would
destroy the archive you are installing from.

Everything else under the target is replaced or removed, and **every removal is
printed**. A replace that silently drops what the new tree happens not to mention is
the failure this command exists to end.

## What a drop may not deliver

`.gitignore`, at any depth. It is discarded from the staged drop before the plan is
built, and **each one is named** -- in a `--dry-run` too.

`.gitignore` decides what is *tracked*, and the tree is tracked so the specification can
be diffed against the implementation. A drop-carried one is therefore uncontrolled input
that changes what the repository records about itself: one saying `docs/` or `*.pdf`
would silently stop part of the deliverable being tracked, and nothing would report it --
the tree would simply get smaller.

Today's drops ship one saying `_inbox/`, which agrees with the repo-owned
`design/.gitignore`. That agreement is an accident, not a design, and it is not reliable:
Lamplight's 31 July 2026 export shipped no `.gitignore` at all, while Baize had deleted
its repo-owned guard the day before on the reasoning that the drop's copy made it
redundant.

So the rule is about direction rather than content. **Tracking policy flows from the
repository outward and never from a drop inward.** This is the mirror of the protected
paths above: those declare what a drop may not overwrite, this declares what it may not
deliver. Declared in `CDSYNC_DROP_REFUSED_FILES`.

The repo-owned `design/.gitignore` sits *outside* the target and is untouched by any of
this -- which is exactly why it survives a replace and the drop's copy does not.

## There is no shape check, and that is a fact about the artefact

An as-is export has no contract. The four exports of 30 July 2026 carry
`design-system/`, `venture/`, `handoff/`, `prototypes/` and a microsite, and **not one
of them satisfies the drop contract** — which is why `cdsync check` correctly refuses
three of the four.

So nothing here validates a shape; inventing one would refuse real drops. Safety comes
from the three things around it instead: the archive is pre-flighted, the target is
proven recoverable, and the plan is shown before anything is written. The only source
this refuses is an empty one.

## After installing

`cdsync check` holds a drop against its specifications, but an as-is export is not
Cdsync-shaped and will be refused — correctly. Check runs after a **conversion** round,
on the drop `import` delivers.
