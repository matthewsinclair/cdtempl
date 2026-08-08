---
verblock: "08 Aug 2026:v1.2: Matthew Sinclair - No unblocked engineering left in ST0003; the BOOTSTRAP-CD count points rather than counts"
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

Cdsync has completed a **full cold round trip** -- initialise an empty tree, hand it to Claude Design, take the return back, check it -- for matthewsinclair and geodica. **Both came back Cdsync-shaped, so the cold-start document works.** **Ten commands, 342 tests, CI success on hygiene, ubuntu-latest and macos-latest.** **ST0003 is in flight**, with WP-01 closed and WP-07 and WP-08 both WIP; ST0001 (16/16), ST0002 (12/12) and ST0004 (11/11) closed through the gate, which refuses a BLOCKED contract. **Six projects hold a design system tree** -- two spikes whose implementations hv is rolling out in Laksa, plus the original four, of which **three are now known to be integrated and the fourth is unchecked rather than unintegrated.**

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

## The work, and there is no unblocked engineering left

**Everything remaining in ST0003 waits on hv.** That became true on 8 August and had not been true before, so do not go looking for something to pick up. Full statements and their blockers live in each WP's own `info.md`; this is the ordering, not a second copy.

**Closed out, and both WPs are WIP rather than Done:**

- **WP-07** -- **the premise was false in all three projects it could be checked against.** G&G, Baize and snorkeltoast were each already built against their design system, in three different idioms. Only **Lamplight** is left and it holds on WP-06's `ref` ruling, which is the one open ruling that could move paths.
- **WP-08** -- Downloads closed by hv's ruling, the repackaging round built, the taxonomy count computed rather than remembered. What is left is three items needing a ruling and one upstream report.

**Waiting on hv, in the order they are worth answering:**

1. **WP-05, and it now blocks two work packages rather than one.** `spec_version` for a NEW asset is what stops `brief` ordering a slug the library has no spec for -- **WP-08 recorded that gap as depending on nothing until the chain was traced.** Also `cdsync.json`'s home for a venture Cdsync does not own.
2. **WP-06's `ref` ruling** -- the only thing between Lamplight and WP-07 closing.
3. **WP-02, two rulings on rule 4** -- the hex-approximation case and a colour named in order to forbid it. Both raised by real findings; neither to be taken unilaterally.
4. **WP-08's stale-document rule** -- ordered or declined. **Its reach is already settled either way**: scoped to the design tree it reports clean on a provably stale document, because the document is the newest file in its own tree.
5. **WP-03, grow the spec library.** Most of the taxonomy has no spec; **`cdsync doctor` prints both figures and this file states neither**, which is the same ruling now applied inside the tool. **`pattern-library` is blocked, not queued** -- `specs/library.md` names it as the live exemplar of "real, in the taxonomy, and unwritten" and a test pins the same invariant, so writing it makes library text false.

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
- **`BOOTSTRAP-CD.md` goes stale routinely, and a hand-regeneration does not hold** -- Baize's went stale again inside a day of being fixed. **Assume stale and diff rather than reading it.** **Which copies, and how a rule that would catch them must be scoped, are in WP-08**, which is the one place that carries them; no count is kept here, because a hand-maintained number is the thing that keeps drifting.
- **Spent transport sits in six `_inbox/` directories.** All gitignored and local-only; **the two newest hold the Laksa theme packs, which exist nowhere else.** Do not clear those two until Laksa has taken them.
- **Intent's template bakes an absolute path into `.claude/settings.json`.** Cdsync's is fixed; Baize's and Lamplight's still carry theirs.
