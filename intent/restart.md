---
verblock: "09 Aug 2026:v1.3: Matthew Sinclair - The wind-back: delivered projects are delivered, WP-05 ruled and built, five WPs closed"
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

Cdsync has completed a **full cold round trip** -- initialise an empty tree, hand it to Claude Design, take the return back, check it -- for matthewsinclair and geodica. **Both came back Cdsync-shaped, so the cold-start document works.** **Ten commands; the bats suite is green end to end and prints its own count; CI success on hygiene, ubuntu-latest and macos-latest.** **ST0003 is nearly done**: six of eight WPs closed (WP-01 on 6 Aug; WP-04 through WP-08 on 9 Aug under the wind-back and its rulings), WP-02 parked by hv, WP-03 the one live remainder. ST0001 (16/16), ST0002 (12/12) and ST0004 (11/11) closed through the gate, which refuses a BLOCKED contract. **Six projects hold a design system tree** -- two spikes whose implementations hv is rolling out in Laksa, plus the original four, of which **three were already integrated and the fourth is unchecked by design.**

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

## The work, after the 9 August wind-back

**hv ruled the delivered projects delivered.** The cdsync loop earns its keep for a few rounds while a design system beds down; after that the tree is **a record of what was asked for**, not a living document -- no more syncing from here, rare as-needed rounds only, rollout the project's own work. That ruling collapsed ST0003 from a waiting list to a single live edge in one day. Each WP's `info.md` carries its own record; this is the ordering, not a second copy.

**Live -- one thing:**

**WP-03, the spec library.** The version-bump pass -- three text inconsistencies, the ruled-advisory `formats_required` text, `pattern-library`'s two-part dance -- plus specs as orders need them. Every question it needs is answered; it runs whenever hv wants the library text moved. **`pattern-library` stays a two-part job**: writing it without re-pointing the library's own exemplar text and its pinning test makes library text false. **`cdsync doctor` prints the counts and this file states none.**

**The staleness advisory shipped 9 Aug, shape (a)**: `doctor` and `check` both warn when a target's `BOOTSTRAP-CD.md` is older than the repository it describes -- repository-scoped, tracked-and-unignored files only, never blocking, not a numbered rule.

**Settled 9 August and built the same day -- the full record is WP-05's `info.md`:** `cdsync.json` lives at the design tree root for every project, its own location resolving the target and the `.target` field retired; a named in-taxonomy slug orders **ahead of the library** and stamps the literal `unassigned`, with rule 2 asking for a rebuild the day the library gains the entry; `init` writes the stub that makes `brief` runnable for a project Cdsync does not own. Suite green end to end, the core behaviours mutation-proven, Acme migrated and its round-two brief regenerated. **WP-02 is parked** -- rule 4's three noise shapes stay recorded with recommendations until a live venture trips one.

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

- **Acme round two is test apparatus, not a queue item** -- the wind-back retired the transport queue, and the round-5 answer died unsent with it. Acme's brief regenerated 9 Aug against library v3; that tree is a nested git repository, gitignored from this one.
- **geodica's kit is prose only** -- no `kit/tokens.json` -- so rule 4 is dark there. Stays as record; no round is going back.
- **The four delivered projects' `BOOTSTRAP-CD.md` copies froze on 9 August.** Baize's was regenerated and committed that morning (`7211fc1` in Baize) under hv's stale-is-never-accepted ruling -- it also caught an unrecorded ADR drift, 0030 to 0035. snorkeltoast's copy stays stale as part of the frozen record unless hv says otherwise -- and staleness is *detectable* now: `doctor` and `check` both warn, advisory, since 9 Aug.
- **Spent transport sits in six `_inbox/` directories.** All gitignored and local-only; **the two newest hold the Laksa theme packs, which exist nowhere else.** Do not clear those two until Laksa has taken them.
- **Intent's template absolute-path defect is reported upstream as Intent issue `0016`** (9 Aug). Baize's and Lamplight's copies stay as they are until Intent ships the fix.
