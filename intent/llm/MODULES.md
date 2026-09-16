# Module Registry - Cdtempl

> **The Highlander Rule**: There can be only one module per concern.
> ALWAYS check this file before creating a new module. If a module already owns that concern, use it.
> When you must create a new module, register it here FIRST, then create the file.

Cdtempl is bash. A "module" is a file under `lib/` sourced by `bin/cdtempl`, and the concern it owns is declared in its own header -- most of them literally open with `THE reader of...` or `THE walker of...`. This table is that declaration collected in one place; **the file's header is the source of truth and this table follows it**, never the other way round.

## Registry

### Entry point

| Concern | THE Module | Notes |
| ------- | ---------- | ----- |
| Dispatch | `bin/cdtempl` | Thin coordinator: resolve home, source the shared primitives, parse the command, delegate. Sources `cmd_*.sh` **on demand** -- only one is ever loaded, so no command module may read another's constants |

### Shared primitives -- sourced for every command

| Concern | THE Module | Notes |
| ------- | ---------- | ----- |
| Logging, colours, the classification vocabulary | `lib/common.sh` | Holds what every command needs and nothing one command needs. `CDTEMPL_CLASSIFICATION_ONLY` lives here because `check` validates the words `bootstrap` instructs on |
| `cdtempl.json` | `lib/config.sh` | THE reader. Nothing else runs jq against that file |
| `$CDTEMPL_TARGET` resolution | `lib/target.sh` | THE resolver. Every command that touches the target calls `resolve_target` |
| YAML front matter, read and written | `lib/frontmatter.sh` | THE accessor. Every module reading a `spec.md`, an `index.md` or the library manifest goes through it |
| The shape of a drop | `lib/drop.sh` | Owns the drop contract: owned paths, protected paths, refused files, and the walker over `assets/` |
| Getting an archive safely onto disk | `lib/archive.sh` | Shared by both install paths |
| The spec library | `lib/specs.sh` | THE reader of `specs/`. `brief` assembles from here, `check` compares against here, nothing else touches it |
| File-level computations | `lib/scan.sh` | THE colour normaliser and the counters `check` runs over a drop |
| Diagnostics | `lib/doctor.sh` | Sourced only by `cdtempl doctor` |

### Commands -- one module each, sourced on demand

| Concern | THE Module | Notes |
| ------- | ---------- | ----- |
| Scaffold a venture | `lib/cmd_new.sh` | **All** application knowledge lives here. New *venture*: its own repository, `cdtempl.json`, agent contract, skeleton |
| Start a design system in an existing repository | `lib/cmd_init.sh` | New *design system*, project already there. The skeleton, the `cdtempl.json` stub at the tree root (hv, 9 Aug 2026), and the one file written outside the target -- no agent contract, no nested repository |
| The repo-owned `_inbox` ignore rule | `lib/target.sh` | `write_target_inbox_gitignore`. Lives in the target's PARENT, because `install` replaces the target. Appends, never truncates |
| Hand the design system to Claude Design | `lib/cmd_bootstrap.sh` | Generates `BOOTSTRAP-CD.md`. One generator, two shapes; cold or warm is measured, never declared |
| Assemble the brief | `lib/cmd_brief.sh` | The brief carries everything its round needs |
| **Replace** the target with an as-is export | `lib/cmd_install.sh` | The second install path. Refuses over content git cannot give back |
| **Merge** a converted drop into the target | `lib/cmd_import.sh` | Writes only the five owned paths and nothing else, anywhere |
| Hold a drop against its specs | `lib/cmd_check.sh` | Six rules; 1 and 4 block, the rest advise |
| Stand up the microsite | `lib/cmd_site.sh` | Only the target |
| Version and release | `lib/cmd_release.sh` | `VERSION` is the only place the version appears. Tarball built by `git archive` from the tag; what it may not carry is declared in `.gitattributes`, not listed in the module |

## The two rules this registry exists to keep

**One walker per directory.** `each_spec` is the only thing that globs `specs/`; `each_drop_asset` is the only thing that walks `assets/`; `each_addendum` is the only thing that walks `addenda/`. A second walker over the same directory is the defect, not a convenience -- `cmd_bootstrap.sh` once carried three skip lists that disagreed, and the disagreement was the bug.

**Consume a walker with process substitution, never a pipe.** `while ... done < <(each_spec)`, not `each_spec | while ...`. A pipe subshells the loop body, so any counter or array it accumulates is discarded and the caller reports nothing -- successfully, which is what makes it expensive to find.

## How to Use This File

1. **Before creating a new module**: search this table. If the concern is listed, use that module.
2. **When adding a new module**: add a row here first, then create the file, and open the file with the `THE <concern>` declaration this table quotes.
3. **When refactoring**: update this table to reflect the new ownership.
4. **When removing a module**: remove its row.

Violations of the Highlander Rule (duplicate modules for the same concern) are the #1 source of code quality debt.
