# cdsync brief

Assemble the brief for Claude Design.

```
cdsync brief [--stdout] [--target PATH]
```

Reads the venture's facts from `cdsync.json` at the design tree root, expands the
order, and assembles a complete document: the header, the fixed/open lists, the
output structure, every ordered asset's **full specification**, the standing gaps,
and the `RETURN.md` contract. Written atomically to `$CDSYNC_TARGET/brief.md`.

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

**It lives at the design tree root** — `design/cdsync.json`, or
`design/system/cdsync.json` where the tree sits one level down — one home for
`new` ventures and `init` projects alike. Target resolution probes those two
locations, so the file's own directory *is* the target; a tree kept anywhere
else needs `--target` or `$CDSYNC_TARGET` on every command. There is no
`.target` field any more — a file inside the tree pointing at the tree would be
circular, and a leftover one is ignored with a warning. No install path may
overwrite the file, and a drop may not deliver one.

| Field | What it carries |
|---|---|
| `venture` | Required. The name |
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
| `formats_required` | `["pdf", "pptx"]` — advisory; see below |
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

`spec_library_version` is the library's **edition**, and a drop keeps the edition it
was ordered against — it is never restamped when the library moves. Staleness is per
asset and is `spec_version`'s job. `specs/library.md` states both, and why treating
the edition as a staleness measure would make the signal mean nothing.

**`formats_required` is advisory.** It says which renderings the venture would like;
it is not part of the definition of done, and no rule in `cdsync check` reads it. An
asset is complete when its specification is satisfied and its blanks are closed, so
a missing PDF does not hold it open. The brief says so to the supplier, because two
read it the other way and held finished work back.

## Ordering ahead of the library, and the one refusal left

A named slug the taxonomy holds may be ordered **before the library specifies
it**. The round creates the asset: the brief carries a section stating the
contract its specification cannot, and the asset stamps `spec_version:
unassigned` — the literal word — until the library gains an entry, at which
point `check` rule 2 asks for a rebuild against it. That is the intended
lifecycle, not an error.

A named slug **outside the taxonomy** is still a refusal. The taxonomy is the
identity space — a new asset *type* is added to the library, never invented by
an order. The refusal prints the taxonomy's real size, and `cdsync doctor`
prints all three counts — neither is written out here, because a count restated
in prose drifts from the table it describes.

An **unspecified bundle member** is a third case: omitted and declared as
deliberately absent, because the venture did not name it.

## Why the write is atomic

The first reason given for this was that Claude Design reads the working tree live.
That was wrong and is withdrawn — it cannot read this repository at all, and every
input reaches it as an upload.

The behaviour stays because it costs nearly nothing, because handing a human a
half-written brief to upload is its own failure, and because that failure would be
silent.
