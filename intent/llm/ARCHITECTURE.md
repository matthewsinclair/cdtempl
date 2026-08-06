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

Canon, above every entry here: `intent/docs/design-system-lifecycle.md`.

| Date | Decision | Rationale |
| ---------- | -------- | --------- |
| 2026-07-29 | Shell, not another language; not yq | Every field the tool decides on is a scalar |
| 2026-07-29 | Cdsync never writes into the application | The target is the entire output boundary |
| 2026-07-29 | `assets/` is flat | Grouping is an order in disguise, and eight asset types are genuinely both design and venture |
| 2026-07-29 | Neutrality is a spec, not an instruction | Remove the failure mode instead of asking for restraint; `blanks` is computed, never declared |
| 2026-07-30 | Two install paths and no third | An as-is export *is* the whole tree, so `install` replaces; a converted drop is a subset, so `import` merges. Hand-unzipping is never correct |
| 2026-07-30 | No backup directory | The tree is tracked in full, so git already holds every prior state. The job is to prove git's copy is complete -- hence the refusal over uncommitted content |
| 2026-07-30 | Classification is its own axis, and rule 6 is advisory | It governs where material may be shown, never whether it is committed; blocking would make it the delivery filter the ruling forbids |
| 2026-07-30 | `addenda/` is repo-authored and no install path may overwrite it | A name declared both owned and protected is an unsatisfiable contract, so both paths refuse rather than pick |
| 2026-07-31 | `design/system/` is the SSOT; Claude Design is clamp-on | Decides the target boundary, the drop contract, and the direction of truth |
| 2026-07-31 | The drop is tracked in full, `_inbox/` excluded | Delivery archives are ephemeral transport; the exclusion is a platform limit, not a policy |
| 2026-07-31 | `spec_version` is the library's stamp, not a per-drop counter | A number each side increments on its own schedule cannot measure a distance, because it never disagrees for a reason |
| 2026-07-31 | The generated document carries the numbers, not just their meaning | Claude Design holds a delivery and cannot read the library, so "copy the specification's version" is unusable alone |
| 2026-07-31 | Seven things a drop may not deliver, all unconditional | What matters is usually in Claude Design's tree, which this side cannot see -- a detector is worthless against material we cannot look at |
