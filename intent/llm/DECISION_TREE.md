# Decision Tree - Where Does This Code Belong?

> Use this tree when you're about to write new code. Walk through the questions to find the right location.
> Always cross-reference MODULES.md -- if a module already owns that concern, put the code there.

Cdsync's declared language is **shell**, and this tree is written for it. A module is a file under `lib/` sourced by `bin/cdsync`.

## Step 1: Is it a new command, or part of one that exists?

**A new user-facing command** -> `lib/cmd_<name>.sh`, plus a dispatch arm in `bin/cdsync` and a `help/<name>.md`. All three, or the command is undiscoverable.

**Behaviour inside an existing command** -> that command's own `cmd_*.sh`. Do not reach into another command's module: `bin/cdsync` sources exactly one `cmd_*.sh` per invocation, so a cross-module reference resolves to an unset variable at runtime rather than failing at load.

## Step 2: Who else needs it?

**Only this command** -> keep it in that command's module. `lib/common.sh` holds what every command needs and nothing one command needs.

**Two or more commands** -> hoist it to the right shared primitive:

| It concerns | THE module |
| ----------- | ---------- |
| `cdsync.json` | `lib/config.sh` |
| Resolving `$CDSYNC_TARGET` | `lib/target.sh` |
| Reading or writing YAML front matter | `lib/frontmatter.sh` |
| The shape of a drop -- owned, protected, refused paths | `lib/drop.sh` |
| Getting an archive onto disk | `lib/archive.sh` |
| The spec library under `specs/` | `lib/specs.sh` |
| Counting or normalising file content | `lib/scan.sh` |
| Logging, colours, shared vocabulary | `lib/common.sh` |

**A constant two commands must agree on** -> `lib/common.sh`, always. This is not a style preference: on-demand sourcing means the second command literally cannot see the first one's copy, so the alternative is two definitions that drift. `CDSYNC_CLASSIFICATION_ONLY` moved there for exactly this reason -- `check` validates the words `bootstrap` instructs on.

## Step 3: Is it a walk over a directory?

**Does a walker already exist for that directory?** `each_spec` owns `specs/`, `each_drop_asset` owns `assets/`, `each_addendum` owns `addenda/`, `each_taxonomy_slug` owns the taxonomy tables. **Use it.** A second walker over the same directory is the defect -- `cmd_bootstrap.sh` once carried three skip lists that disagreed, and a tree could be called warm on the strength of a file the inventory then never mentioned.

**Consume it with process substitution, never a pipe.** `while IFS= read -r x; do ... done < <(each_spec)`. A pipe subshells the loop body, so every counter and array it accumulates is discarded and the caller reports nothing -- successfully, which is what makes it expensive to find.

## Step 4: Does a module already own this?

1. Check `MODULES.md`.
2. If yes: add the code to that module.
3. If no: register it in `MODULES.md` first, then create the file, and open the file with the `THE <concern>` declaration the registry quotes.

## Step 5: Anti-patterns

| Temptation | Correct location |
| ---------- | ---------------- |
| Business logic in `bin/cdsync` | The command's `cmd_*.sh`. The dispatcher parses and delegates, nothing else |
| A command module sourcing another command module | Hoist the shared part to a primitive. On-demand sourcing means the reference would be unset at runtime |
| A second glob over a directory a walker already owns | Use the walker |
| Piping a walker into `while` | Process substitution -- the pipe discards what the loop accumulates |
| A second copy of a constant two commands share | `lib/common.sh` (Highlander Rule) |
| `cmd \|\| true` to quiet a failure | Surface it. `\|\| true` is legitimate only where the failure is genuinely benign, eg `grep -c` returning 1 on zero matches |
| A check reporting clean on something it could not read | Report what it could not see. A check that cannot see a thing must not return a verdict on it |
| Writing anything outside `$CDSYNC_TARGET` | Nowhere. The target is the entire output boundary |
| Editing a generated file by hand | Change the generator, then regenerate. `BOOTSTRAP-CD.md` regenerates on sync only, so a generator change needs a manual regeneration pass |

## Step 6: Does it need a test?

Yes. The suite is `test/cdsync.bats`.

**Assert on a substring that cannot span a line wrap.** Generated markdown wraps at ~78 characters, and an assertion straddling a break fails against output that is correct. This has cost real time more than once.

**Prove the test can fail.** Break the code, watch the test go red, restore it. Several tests in this project have been wrong rather than the code they guarded -- asserted strings that never existed, a `refute_contains` too blunt to tell a bullet from a lead line, a bare `run_lib` leaving `$status` unset.
