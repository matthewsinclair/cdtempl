# ARCHITECTURE.md

System architecture and design decisions for Cdsync.

## System Overview

Cdsync regularises the Claude Design process for the problems that recur across ventures. It is a bash CLI that assembles briefs from a spec library, receives what Claude Design sends back, and holds the result against its own specifications. **The goal is regular and predictable first, automated second** -- if the whole process were run by hand and never scripted, the regularity would still be most of the value.

## The inversion everything else follows from

**`design/system/` is the single source of truth for a project's design system, and Claude Design is a clamp-on tool used to work on it.** Not the other way round. A project using cdsync has exactly one concern -- that tree -- and no cdsync protocol material belongs inside it.

That single claim decides most of the design below: why the target is the whole output boundary, why the drop is tracked in full, why there are two install paths rather than one, and why a generated document is treated as an instruction rather than a report.

## Key Patterns

**Thin coordinator.** `bin/cdsync` resolves home, sources the shared primitives, parses the command and delegates. It holds no business logic. Command modules are sourced **on demand** -- exactly one `cmd_*.sh` is ever loaded -- which is why no command module may read another's constants; anything two commands need moves to `lib/common.sh`.

**One owner per concern, declared in the file.** Most modules open with `THE reader of...` or `THE walker of...`. `intent/llm/MODULES.md` collects those declarations; the header is the source of truth.

**One walker per directory.** A second walker over the same directory is the defect. `cmd_bootstrap.sh` once carried three skip lists that disagreed, and the disagreement was the bug: a tree could be called warm on the strength of a file the inventory then never mentioned.

**Process substitution, never a pipe**, when consuming a walker. A pipe subshells the loop body and discards whatever it accumulates, so the caller reports nothing -- successfully.

**Everything a scan cannot classify gets named.** Silence is the failure this project keeps rediscovering: a report that covers what it understood and says nothing about the rest reads as complete. So the rule is inverted -- list everything unless another section already accounts for it.

## Module Layout

```
.
├── bin/cdsync      # thin dispatcher
├── lib/           # sourced modules: shared primitives + one cmd_*.sh per command
├── help/          # one markdown file per command, rendered by --help
├── specs/         # THE spec library: definition of done per asset, plus library.md
├── templates/     # scaffolding copied by `cdsync new`
├── test/          # bats suite
└── intent/        # steel threads, docs, whiteboard, project artefacts
```

Full per-module ownership: `intent/llm/MODULES.md`.

## Data Flow

```
cdsync new        scaffold a venture
cdsync bootstrap  target state           -> BOOTSTRAP-CD.md into the target
cdsync brief      specs/ + cdsync.json    -> a brief, for a human to carry across
                 (Claude Design works, exports a zip; every lane passes through a human)
cdsync install    as-is export (whole)   -> REPLACES the target
cdsync import     converted drop (subset)-> MERGES into the five owned paths
cdsync check      target vs specs/       -> findings, blocking or advisory
cdsync site       target                 -> a microsite to look at it
```

**The whole output boundary is `$CDSYNC_TARGET`.** No command writes outside it. The target is the as-designed record; the application is the as-built, and a gap between them is expected and is not a defect.

## Decision Log

**It is not here. Every ruling lives in `intent/whiteboard/cc/wip.md` `## Decisions`, and canon outranks all of them: `intent/docs/design-system-lifecycle.md`.**

This file carried a dated table of thirteen decisions until 8 August, and **it was not a duplicate of the board so much as a fork of it.** Twelve of the thirteen restated a board ruling; the thirteenth -- no backup directory -- existed only here. Four rows had drifted into carrying *different* reasoning from the board's version of the same decision, each side holding something the other had lost. And the table's last entry was 31 July while the board had gone on ruling for another week, so the copy a reader met first was the stale one.

**That is the predicted failure, arrived at exactly as predicted:** two descriptions of one thing disagree, and the terse one survives. Everything unique to the table was merged onto the board before the table was removed, which is the only reason removing it was safe.

**Architecture decisions are rulings.** They belong where the rulings are, and there is no second list here to fall behind.
