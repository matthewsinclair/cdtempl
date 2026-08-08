# cdsync brief

Assemble the brief for Claude Design.

```
cdsync brief [--stdout] [--target PATH]
```

Reads the venture's facts from `cdsync.json`, expands the order, and assembles a
complete document: the header, the fixed/open lists, the output structure, every
ordered asset's **full specification**, the standing gaps, and the `RETURN.md`
contract. Written atomically to `$CDSYNC_TARGET/brief.md`.

## Options

| Option | Effect |
|---|---|
| `--stdout` | Also emit the brief on stdout, for pasting |
| `--target PATH` | Override the target for this invocation |

One generator, two outlets. Letting the paste path grow its own format would
produce two specifications that drift.

## The brief carries everything its round needs

That is the rule, and it is a principle rather than a workaround.

Claude Design is scoped to one directory and cannot read this repository. **That
scoping is deliberate.** If it could read the repo, briefs would drift toward being
thin and reference-rich — pointers to specs, to design docs, to steel threads. That
works now and breaks completely the day Claude Design is scoped to a real venture,
where Cdsync's internals genuinely are not visible.

So a pointer to a file the reader cannot open is a hole in the brief, not a
reference. Every ordered asset's full specification is inlined, **always, with no
shorter mode**. A brief that is complete only sometimes is a brief nobody can trust
without checking.

## cdsync.json

| Field | What it carries |
|---|---|
| `venture` | Required. The name |
| `target` | Where the design record lives. Defaults to `design` |
| `one_liner` | What it does, one sentence, for whom |
| `stage` | `pre-seed` / `seed` / `series-a` / `scaling` |
| `round` | Which drop this is |
| `round_job` | What this round is *for* — build, repackage, revise, extend. Free text |
| `order.bundles` | Bundle names — `seed-set`, `product-set`, … |
| `order.assets` | Individual slugs, beyond the bundles |
| `fixed` | Decided. Do not re-invent |
| `open` | Licensed to invent |
| `invention` | Whether facts may be invented, or blanks must be left |
| `numbers` | `real` or `illustrative` |
| `inherits_from` | `none`, a previous drop, or an existing brand |
| `locale`, `currency` | `en-AU`, `AUD` |
| `accessibility_target` | `WCAG 2.2 AA` |
| `formats_required` | `["pdf", "pptx"]` |
| `effort` | `one pass, argue-with-able` or `finished` |
| `changed_since_last` | What moved since the last round |

**`fixed` and `open` matter more than the rest combined.** Almost every failure in
this class of work is one of two things: something was invented that had already
been decided, or a blank was left where invention was expected. Those two lists
close both, and everything else is hygiene by comparison.

## What this round is for

Every brief this tool wrote used to say "build these", in that voice, with no way
to say anything else — so a **repackaging round**, one whose job is to reshape what
already exists, could not be expressed and had to be explained out of band.

`round_job` is free text, not an enum, matching `effort` and `inherits_from`.
Nobody has ordered a vocabulary of round types, and inventing one here would be the
tool deciding what kinds of round exist.

Beside it the brief states, **measured rather than declared, which of the ordered
assets are already in the target**. That is worth saying in every round, not only a
repackaging one: a supplier who orders a slug that already exists and is not told
will rebuild it from scratch, and the rebuild silently discards whatever the
existing one carried. The two facts are different in kind — a round's purpose is
not derivable from the tree, since revise, extend, repackage and correct all look
identical on disk.

`spec_library_version`, `target_structure_version` and `kit_version` are stamped by
the tool from the library, not declared here. That is what makes staleness
detectable.

## Refusals

An ordered slug with no entry in the spec library is a refusal, not a warning. The
taxonomy names many more assets than the library specifies, and only the specified
ones can be briefed, because a brief carries the specification itself. The refusal
prints the real figure, and `cdsync doctor` prints all three counts — neither is
written out here, because a count restated in prose drifts from the table it
describes.

## Why the write is atomic

The first reason given for this was that Claude Design reads the working tree live.
That was wrong and is withdrawn — it cannot read this repository at all, and every
input reaches it as an upload.

The behaviour stays because it costs nearly nothing, because handing a human a
half-written brief to upload is its own failure, and because that failure would be
silent.
