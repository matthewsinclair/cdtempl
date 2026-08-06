---
node: cc
name: Control Claude
role: control
session_id: 522b7752-3539-44be-9420-78bb12a4bdec
heartbeat_at: 2026-07-29T17:17Z
status: active
focus: "Localfolded before a compact. Next: build the four cdsync commands plus check -- the templates are ten assets ahead of a tool whose every command is a stub"
claims: [ST0001]
---

# Control Claude (cc)

## DOING

- Localfold done 2026-07-29T17:17Z, before a compact. Status stays `active` -- a compact does not end a session (whiteboard invariant 6). Full board snapshot at `.history/20260729/wip.md`.

## TODO -- next session picks up here

**Build the tool.** `templprj` is 1.4MB across 47 files with ten built Tier 1 assets. Every `cdsync` command is still a stub exiting non-zero. Every drop so far has been hand-carried, which is exactly why `import` silently deleted a file before anyone had run it. Task list and the five check rules are in `intent/st/ST0001/tasks.md`; the model is in `intent/st/ST0001/design.md`.

Order: `new`, `brief`, `import`, `site`, `check`. Then run a real venture end to end -- `cd`'s recommendation and the right one, but it needs something to run through.

Still deferred, still not earning their keep: `hv` node, whiteboard `README.md` roster, `.gitignore`, `intent/wip.md`, `intent/llm/ARCHITECTURE.md` (still the verbatim default).

## Watch-outs

- **`cd` cannot read this repository. At all.** Not by git, not by mount -- it is scoped to `templprj` and receives uploads. That scoping is **deliberate and stays**: it is a forcing function, because a brief that works only when `cd` can read Cdsync's internals breaks the day `cd` is scoped to a real venture. The rule is "a brief carries everything its round needs", which holds whatever access exists.
- **I got this channel wrong three times in one afternoon**, each time by inferring its shape from this side rather than asking: peer-that-commits, then git-remote-reader, then live-local-mount. `cd` corrected the last one itself. **Treat any claim about this channel as provisional until `cd` confirms it**, and never read `cd`'s silence as "has not worked".
- **`cdsync import` must write only `assets/`, `kit/`, `notes/`, `index.md`, `RETURN.md`.** Round four proved why: a drop arrived without `templprj/README.md` and syncing it deleted the file, taking the only statement of why the placeholder must be boring. `brief.md` survives today only because `cd` echoes it back, which is a convention propping up a guarantee.
- **`templates/claude_design/_Archive/` and `_archive/` are hv's own rolling backups.** Untracked on purpose, hv removes them later. Do not commit, do not delete, do not raise again as an untracked-files finding.
- **`announce` before the first write when editing another project's tree.** Fixing three Utilz defects at hv's instruction, without announcing, blocked a live session there and had its baselines taken against a tree I was still writing.
- **Two dispatcher contracts from Utilz ST0009**, both silent when broken. Consume a walker with process substitution, never a pipe -- a pipe subshells the loop body and discards accumulator arrays, so the caller reports nothing, successfully. Gate a hard dependency once before a loop, never per-iteration, never memoised across command substitution -- a memo set inside `$(...)` dies with its subshell.
- `intent claude prime --refresh` overwrites `MEMORY.md` at the Claude Code project-memory path; hand-written pointer lines there are not safe across a refresh.
- `intent st sync` writes only WIP threads into `steel_threads.md`. An empty index alongside a Not Started thread is correct, not a fault.

## Decisions

Settled and not to be re-opened. Full reasoning in `intent/st/ST0001/design.md`, which is the single source -- do not reconstruct the model from this board.

- (2026-07-29) **Cdsync never writes into the application.** The whole output boundary is `$CDSYNC_TARGET`, default `design/`; structure underneath is standardised, location is not. The target is the as-designed record, the app is the as-built, and keeping them apart is the point.
- (2026-07-29) **The composite test is "do the parts have different definitions of done?"** -- not "does the asset have parts". `cd` corrected my under-specified version, which applied to `component-library` would have split 28 components into 28 slugs and dissolved the taxonomy.
- (2026-07-29) **Neutrality is a spec, not an instruction**, and `blanks` is computed, not declared. Both are the same move: remove the failure mode rather than detect it.
- (2026-07-29) **Vendored runtime is excluded from the colour check by declaration in a comment, not by path.** `support.js` cannot be moved into `vendor/` -- the authoring runtime emits it as a sibling -- so a path rule needs it named as a special case, which is the maintained exception list the design exists to avoid. `vendor/` stays for human legibility only.
- (2026-07-29) **Round-one scope answers:** a drop lives in its own repo; a generated venture borrows `CLAUDE.md` / `AGENTS.md` but not `intent/st/`; `cdsync check` blocks on leak guard and stale counts, everything else advisory.
- (2026-07-29) **Shell is the declared language.** Pre-commit critic gate live, `.intent_critic.yml` at `severity_min=warning`. JS under a design drop stays ungated -- Intent ships no JavaScript rule pack.
