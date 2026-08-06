---
verblock: "06 Aug 2026:v1.0: Matthew Sinclair - Globalfold: renamed to Cdsync across five repositories, and the live docs cut to one home per thing"
---

# Restart Context

Read the canon first, then this, then the thread you are picking up.

## One home per thing

The 2 August fold left the rulings restated in four documents and the watch-outs in three. That is the drift hazard this project keeps re-learning, so this fold collapsed them. **If you are about to restate one of these somewhere else, that is the bug, not the style.**

| What | Where |
| ---- | ----- |
| Canon, which outranks every other document | `intent/docs/design-system-lifecycle.md` |
| Rulings, settled and not to be re-opened | `intent/whiteboard/cc/wip.md` `## Decisions` |
| Watch-outs, the standing hazards | `intent/whiteboard/cc/wip.md` `## Watch-outs` |
| What is open, and what blocks each item | `intent/st/NOT-STARTED/ST0003/WP/*/info.md` |
| What a Claude Design session needs | `intent/docs/claude-design-contract.md` |
| What a receiving project needs | `intent/docs/receiving-a-design-system.md` |

## The one-paragraph version

Cdsync has completed a **full cold round trip** -- initialise an empty tree, hand it to Claude Design, take the return back, check it -- for matthewsinclair and geodica. **Both came back Cdsync-shaped, so the cold-start document works.** **Ten commands, 328 tests, a spec library of 27 against a 52-slug taxonomy, CI green on ubuntu-latest and macos-latest.** **Nothing is in flight and no thread is open**: ST0001 (16/16), ST0002 (12/12) and ST0004 (11/11) all closed through the gate, which refuses a BLOCKED contract. **Six projects hold a design system tree** -- the original four awaiting integration, plus the two spikes, whose implementations hv is rolling out in Laksa and fixing forward.

**The tool was renamed from its former name to Cdsync on 6 August** across five repositories, with zero remnant anywhere it can be read. It was free, and only because it was done before the first release: no tag existed and no published artefact carried the old name. **That window has now closed** -- `v0.1.0` is released, so any future rename carries a published artefact with it.

**The repository went public the same day**, from a single root commit. The 135-commit development history was truncated and retained privately at the Dropbox mirror on `archive/pre-public-20260806`, with a bundle beside it. **Everything committed here is published on push** -- no key, token, absolute path or real contact address belongs in a tracked file.

## Canon, and it outranks this file

`design/system/` is the **single source of truth** for a project's design system, and Claude Design is a **clamp-on tool** used to work on it. The tree is **specification, not running code**; it is stored and tracked in full, and **the app never reads from it**. It is an **end-state view**, so a gap between the tree and the app is expected and is **never a defect**. It changes only through an iteration with Claude Design mediated by Cdsync -- never by hand-editing -- with `addenda/` the one sanctioned way to write into it.

## Two install paths, and picking wrong is the worst mistake in the tool

| The artefact | The command | What it does |
| ------------ | ----------- | ------------ |
| An **as-is export** -- the whole tree | `cdsync install` | **Replaces.** What the drop does not carry is removed, and every removal is printed |
| A **converted drop** -- a subset, the five owned paths | `cdsync import` | **Merges.** What the drop does not carry survives |

**Hand-unzipping a drop is never correct.** `install` refuses over a target holding uncommitted or untracked content, because the tree being tracked in full is what makes a replace reversible. There is **no backup directory** by design.

**The top-level plan is not the removal audit.** It lists top-level paths only, so a file deleted *inside* a replaced directory never appears in it. **`git status` after the install is where the removals actually are** -- that is how round three's 54 deletions were read.

## The unblocked work, in order

Full statements and their blockers live in each WP's own `info.md`. This is the ordering, not a second copy of the contents.

1. **WP-02, two rulings on rule 4** -- the hex-approximation case (fourteen of matthewsinclair's fifteen findings) and a colour named in order to forbid it. Both raised by real findings; neither to be taken unilaterally.
2. **WP-05, scope for the next round** -- `cdsync.json`'s home, and `spec_version` for a NEW asset, now asked by a fourth project.
3. **WP-07, integrate the original four** -- unblocked and independent of everything above. Hold Lamplight's `ref`, the only open ruling that could move paths.
4. ~~**WP-01, cut the release**~~ -- **DONE 6 August, 8/8.** `v0.1.0` is tagged, pushed and published.
5. **WP-03, grow the spec library.** 25 of 52 slugs have no spec. **`pattern-library` is blocked, not queued** -- `specs/library.md` names it as the live exemplar of "real, in the taxonomy, and unwritten" and a test pins the same invariant, so writing it makes library text false.

## Where the work is

| Path | What |
| ---- | ---- |
| `bin/cdsync`, `lib/*.sh` | The tool. The dispatcher plus one module per job |
| `test/cdsync.bats` | The contract. Several tests are structural rather than behavioural: help files, the front-page table, documented flags, the rule count, and every colour form in `CDSYNC_COLOUR_RE` being named in `help/check.md` |
| `specs/` | 27 specs against a 52-slug taxonomy, plus 7 bundles. **`cdsync doctor` prints all three, so read them from it rather than from here** |
| `intent/llm/MODULES.md` | Per-module ownership, written from the code's own headers |
| `intent/llm/ARCHITECTURE.md` | As-built architecture and the dated decision log |
| `.github/workflows/ci.yml` | bats and shellcheck on ubuntu-latest and macos-latest, plus a hygiene job |
| `.gitattributes` | What a release tarball may not carry, read by `git archive` |
| `intent/whiteboard/cc/wip.md` | The live board: the rulings and the watch-outs both live there |

## Loose ends

- **Acme round two is assembled and unsent**, at `templates/_test/Acme/design/brief.md`, as is `intent/st/COMPLETED/ST0001/round-5-answer.md`. Transport is hv's.
- **geodica's kit is prose only** -- no `kit/tokens.json` -- so rule 4 cannot run against it. A request back to Claude Design, not a defect here.
- **Lamplight's and Baize's `BOOTSTRAP-CD.md` carry pre-existing numbering drift** (a steel-thread count, an ADR count). Confirmed on 6 August to be unrelated to the rename: both regenerate with zero name-related differences.
- **Spent transport sits in six `_inbox/` directories.** All gitignored and local-only; **the two newest hold the Laksa theme packs, which exist nowhere else.** Do not clear those two until Laksa has taken them.
- **Intent's template bakes an absolute path into `.claude/settings.json`.** Cdsync's is fixed; Baize's and Lamplight's still carry theirs.
