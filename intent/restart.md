---
verblock: "07 Aug 2026:v1.1: Matthew Sinclair - Globalfold: corrected four claims this file was making that had stopped being true"
---

# Restart Context

Read the canon first, then this, then the thread you are picking up.

## One home per thing

The 2 August fold left the rulings restated in four documents and the watch-outs in three. That is the drift hazard this project keeps re-learning, so the 6 August fold collapsed them and this one finished the job. **If you are about to restate one of these somewhere else, that is the bug, not the style.**

| What | Where |
| ---- | ---- |
| Canon, which outranks every other document | `intent/docs/design-system-lifecycle.md` |
| Rulings, settled and not to be re-opened | `intent/whiteboard/cc/wip.md` `## Decisions` |
| Watch-outs, the standing hazards | `intent/whiteboard/cc/wip.md` `## Watch-outs` |
| What is open, and what blocks each item | `intent/st/ST0003/WP/*/info.md` |
| What a Claude Design session needs | `intent/docs/claude-design-contract.md` |
| What a receiving project needs | `intent/docs/receiving-a-design-system.md` |

## The one-paragraph version

Cdsync has completed a **full cold round trip** -- initialise an empty tree, hand it to Claude Design, take the return back, check it -- for matthewsinclair and geodica. **Both came back Cdsync-shaped, so the cold-start document works.** **Ten commands, 335 tests, CI success on hygiene, ubuntu-latest and macos-latest.** **ST0003 is in flight**, 2 of 8 work packages moved; ST0001 (16/16), ST0002 (12/12) and ST0004 (11/11) closed through the gate, which refuses a BLOCKED contract. **Six projects hold a design system tree** -- two spikes whose implementations hv is rolling out in Laksa, plus the original four, of which Gyre & Gymble is now integrated.

**The tool was renamed to Cdsync on 6 August.** It was free, and only because it happened before the first release: no tag existed and no published artefact carried the old name. **That window has closed** -- `v0.1.0` is released, so any future rename carries a published artefact with it. **The rename's own contract shipped a boundary that was too narrow and missed two repositories**; that is finished now, and the lesson is on the board.

**The repository went public the same day.** **Everything committed here is published on push** -- no key, token, absolute path or real contact address belongs in a tracked file. What happened to the pre-public history, and where it is kept, is in `intent/wip.md`; do not try to recover it from here.

## Canon, and it outranks this file

`design/system/` is the **single source of truth** for a project's design system, and Claude Design is a **clamp-on tool** used to work on it. The tree is **specification, not running code**; it is stored and tracked in full, and **the app never reads from it**. It is an **end-state view**, so a gap between the tree and the app is expected and is **never a defect** -- which is also why Cdsync has no application-side check, and why a check that an application still agrees with its design system belongs to the application. It changes only through an iteration with Claude Design mediated by Cdsync -- never by hand-editing -- with `addenda/` the one sanctioned way to write into it.

## Two install paths, and picking wrong is the worst mistake in the tool

| The artefact | The command | What it does |
| ------------ | ----------- | ------------ |
| An **as-is export** -- the whole tree | `cdsync install` | **Replaces.** What the drop does not carry is removed, and every removal is printed |
| A **converted drop** -- a subset, the five owned paths | `cdsync import` | **Merges.** What the drop does not carry survives |

**Hand-unzipping a drop is never correct.** `install` refuses over a target holding uncommitted or untracked content, because the tree being tracked in full is what makes a replace reversible. There is **no backup directory** by design.

**The top-level plan is not the removal audit.** It lists top-level paths only, so a file deleted *inside* a replaced directory never appears in it. **`git status` after the install is where the removals actually are** -- that is how round three's 54 deletions were read.

## The unblocked work, in order

Full statements and their blockers live in each WP's own `info.md`. This is the ordering, not a second copy of the contents.

1. **WP-07, the rest of the original four** -- Baize and snorkeltoast, both by reading. **Gyre & Gymble is done, and its premise was false: it was already integrated.** Ask the same of the other two before recording that they build against nothing. Hold Lamplight's `ref`, the only open ruling that could move paths.
2. **WP-08, housekeeping** -- entirely unblocked, nothing in it waits on anyone.
3. **WP-02, two rulings on rule 4** -- the hex-approximation case and a colour named in order to forbid it. Both raised by real findings; neither to be taken unilaterally.
4. **WP-05, scope for the next round** -- `cdsync.json`'s home, and `spec_version` for a NEW asset, now asked by a fourth project.
5. **WP-03, grow the spec library.** 25 of 52 slugs have no spec. **`pattern-library` is blocked, not queued** -- `specs/library.md` names it as the live exemplar of "real, in the taxonomy, and unwritten" and a test pins the same invariant, so writing it makes library text false.

## Where the work is

| Path | What |
| ---- | ---- |
| `bin/cdsync`, `lib/*.sh` | The tool. The dispatcher plus one module per job |
| `test/cdsync.bats` | The contract. Several tests are structural rather than behavioural: help files, the front-page table, documented flags, the rule count, every colour form in `CDSYNC_COLOUR_RE`, and that every acceptance contract names tests that exist |
| `specs/` | The spec library. **`cdsync doctor` prints the counts, so read them from it rather than from here** |
| `intent/llm/MODULES.md` | Per-module ownership, written from the code's own headers |
| `intent/llm/ARCHITECTURE.md` | As-built architecture and the dated decision log |
| `.github/workflows/ci.yml` | bats and shellcheck on ubuntu-latest and macos-latest, plus a hygiene job |
| `.gitattributes` | What a release tarball may not carry, read by `git archive` |
| `intent/whiteboard/cc/wip.md` | The live board: the rulings and the watch-outs both live there |

## Loose ends

- **Acme round two is assembled and unsent**, at `templates/_test/Acme/design/brief.md`, as is `intent/st/COMPLETED/ST0001/round-5-answer.md`. Transport is hv's. That tree is a nested git repository, gitignored from this one.
- **geodica's kit is prose only** -- no `kit/tokens.json` -- so rule 4 cannot run against it. A request back to Claude Design, not a defect here.
- **`BOOTSTRAP-CD.md` is known stale in four copies, not two.** Baize's steel-thread high-water; G&G's inventory and its embedded addendum, both fixed 6 August; snorkeltoast's file counts and a missing section, not yet written because a live session was in that tree. **Assume stale and diff rather than reading it.**
- **Spent transport sits in six `_inbox/` directories.** All gitignored and local-only; **the two newest hold the Laksa theme packs, which exist nowhere else.** Do not clear those two until Laksa has taken them.
- **Intent's template bakes an absolute path into `.claude/settings.json`.** Cdsync's is fixed; Baize's and Lamplight's still carry theirs.
