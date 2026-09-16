# cdtempl import

Unpack a Claude Design drop into the target.

```
cdtempl import <zip|dir> [--target PATH] [--dry-run]
```

Stages the drop somewhere it can be inspected, validates it, then writes it into
`$CDTEMPL_TARGET`. Reports which target resolved and whether it sits inside the
repository before doing anything.

## Options

| Option | Effect |
|---|---|
| `--target PATH` | Override the target for this invocation |
| `--dry-run` | Report exactly what would be written, and write nothing |

A directory may be passed instead of a zip, and is read in place. Only an unpacked
archive is removed afterwards — deleting your own directory because you passed it as
a source would be an unrecoverable answer to a typo.

## It writes only what a drop owns

| Path | How it is written |
|---|---|
| `assets/<slug>/` | Replaced wholesale, **one slug at a time** |
| `kit/` | Replaced entire — it is wholly Claude Design's |
| `notes/<file>` | **Merged**, never replaced |
| `index.md` | Overwritten |
| `RETURN.md` | Overwritten |

**Nothing else in the target is touched.** Anything else the drop carries is
reported as `ignore` and left on the floor.

Per slug rather than per `assets/` directory, because a drop is an order of six to
ten assets and never the whole taxonomy. An asset already in the target and absent
from this drop is an earlier drop's work, and is left exactly alone.

`notes/` merges because notes are durable thinking rather than deliverables.
Replacing the directory would discard round two's reasoning because round four
happened not to restate it.

## Why the owned-path list exists

It was learned rather than designed.

A drop arrived without `templprj/README.md` — the only statement anywhere in that
directory of why the placeholder must be boring — and syncing the drop over the
target deleted it silently. Nothing removed it deliberately; a drop is simply the
whole directory, so anything in the target and absent from the drop went with it.

`brief.md` survived only because Claude Design echoes it back verbatim, which is a
convention propping up a guarantee. Conventions do not hold.

So the boundary is explicit instead. It is the same as-designed versus as-built
separation the whole design rests on, applied one level down — and it means a
venture can keep its own files in the target, and `cdtempl site` can generate into it,
without a later drop eating either.

## Validation happens before any write

Two refusals:

- **No `assets/` and no `kit/`** at the drop root — it is not a drop.
- **No `RETURN.md`** at the drop root. It is mandatory on every drop. The most
  valuable thing in a round is sometimes a changed mind rather than an artefact, and
  a drop with nowhere to say so loses it.

An export usually wraps everything in one directory named after the project. That
wrapper is descended through automatically, so the archive works whichever way it
was built.

## After importing

Run `cdtempl check` to hold the drop against its own specifications.
