---
verblock: "15 Sep 2026:v2.2: Matthew Sinclair - CI green on the pushed port; treeindex pruned; vc holds the Decisions; devbin 0069 filed"
---

# Restart Context

**Read the canon first, then this.** This file is orientation and pointers. It states nothing that has a home elsewhere, because a fact written twice is a fact that will disagree with itself -- the 2 August fold left the rulings in four documents and the watch-outs in three, and this project has been paying that down ever since.

## One home per thing

**If you are about to restate one of these somewhere else, that is the bug, not the style.**

| What                                              | Where                                         |
| ------------------------------------------------- | --------------------------------------------- |
| Canon, which outranks every other document        | `intent/docs/design-system-lifecycle.md`      |
| Rulings, settled and not to be re-opened          | `intent/whiteboard/cc/wip.md` `## Decisions`  |
| Watch-outs, the standing hazards                  | `intent/whiteboard/cc/wip.md` `## Watch-outs` |
| Threads, gates, release record, structural guards | `intent/wip.md`                               |
| What each work package found                      | ST0003's WP info (`intent wp list ST0003`)    |
| What a Claude Design session needs                | `intent/docs/claude-design-contract.md`       |
| What a receiving project needs                    | `intent/docs/receiving-a-design-system.md`    |
| The refocus proposal and hv's six open decisions  | `intent/docs/refocus-proposal.md`             |

## Where the project is

**Cdsync v1 is released, public, and every steel thread is Completed.** Ten commands. The bats suite is green end to end and prints its own count -- run it as `bin/devbin test all`, whose verdict is a sealed file under `tmp/test/` -- and shellcheck is silent at default severity. **CI ran green on 15 September** on the push that carried the Intent v3 port and ST0005's repairs of what it broke -- both OS test jobs and the hygiene job, read per job rather than from the run's summary. ST0005 found one break of each kind: a guard the suite failed on as soon as anyone ran it, and two CI steps naming files the port removed, which only CI's own steps could see. **Read the spec-library numbers from `cdsync doctor`**, never from prose.

It has completed a **full cold round trip** -- initialise an empty tree, hand it to Claude Design, take the return back, check it -- for matthewsinclair and geodica. **Both came back Cdsync-shaped, so the cold-start document works.** **Six projects hold a design system tree**: those two, whose rollout hv is doing in Laksa, plus the original four, of which three were already integrated before anyone checked and **Lamplight is unchecked by design**.

**Nothing is open. One question awaits hv**: whether Cdsync should stop being a way to sync a design system with Claude Design and become a way to bootstrap a venture's design system from a family of tried assets, now that design work happens inside Claude Code. hv raised it on 15 September; **the proposal and the six decisions it waits on are in `intent/docs/refocus-proposal.md`**, and hv takes them up next. **No thread is open for it, and nothing in the transport is retired until hv rules.** The next piece of work opens a thread (`intent st new`) rather than resuming one -- and the carried-forward list below is what to read first.

**The tool was renamed to Cdsync on 6 August, and the window that made it free has closed**: no tag existed then, and `v0.1.0` is out now, so the next rename of anything carries a published artefact with it. ST0004's contract has the verification and the post-close note; the lesson is on the board.

**The repository went public the same day. Everything committed here is published on push** -- no key, token, absolute path or real contact address belongs in a tracked file. The pre-public history is not recoverable from here; where it is kept is in `intent/wip.md`.

## Canon, and it outranks this file

`design/system/` is the **single source of truth** for a project's design system, and Claude Design is a **clamp-on tool** used to work on it. The tree is **specification, not running code**; it is stored and tracked in full, and **the app never reads from it**. It is an **end-state view**, so a gap between the tree and the app is expected and is **never a defect** -- which is why Cdsync has no application-side check, and why checking that an application still agrees with its design system belongs to the application. It changes only through an iteration with Claude Design mediated by Cdsync -- never by hand-editing -- with `addenda/` the one sanctioned way to write into it.

**Since the 9 August wind-back, the delivered projects are delivered.** The loop earns its keep for a few rounds while a design system beds down; after that the tree is **a record of what was asked for**, not a living document. Rare, project-specific rounds only; rollout is the project's own work.

## Two install paths, and picking wrong is the worst mistake in the tool

| The artefact                                           | The command      | What it does                                                                        |
| ------------------------------------------------------ | ---------------- | ----------------------------------------------------------------------------------- |
| An **as-is export** -- the whole tree                  | `cdsync install` | **Replaces.** What the drop does not carry is removed, and every removal is printed |
| A **converted drop** -- a subset, the five owned paths | `cdsync import`  | **Merges.** What the drop does not carry survives                                   |

**Hand-unzipping a drop is never correct.** `install` refuses over a target holding uncommitted or untracked content, because the tree being tracked in full is what makes a replace reversible. There is **no backup directory** by design -- the refusal is the backup.

**The top-level plan is not the removal audit.** It lists top-level paths only, so a file deleted *inside* a replaced directory never appears in it. **`git status` after the install is where the removals actually are** -- that is how round three's 54 deletions were read.

**`cdsync check` is not read-only either.** It rewrites computed `blanks` into every `spec.md` in the drop it walks. Pointing it at a tracked tree changes that tree; check `git status` afterwards.

## Where the work is

| Path                         | What                                                                                             |
| ---------------------------- | ------------------------------------------------------------------------------------------------ |
| `bin/cdsync`, `lib/*.sh`     | The tool. The dispatcher plus one module per job                                                 |
| `bin/devbin`, `bin/.devbin/` | The dev launcher, vendored from devbin: not the tool, not in a release, its manifest gitignored  |
| `test/cdsync.bats`           | The contract. Several tests are structural rather than behavioural -- `intent/wip.md` lists them |
| `specs/`                     | The spec library, at edition 4. **`cdsync doctor` prints the counts**                            |
| `intent/llm/MODULES.md`      | Per-module ownership, written from the code's own headers                                        |
| `intent/llm/ARCHITECTURE.md` | As-built architecture and the dated decision log                                                 |
| `.github/workflows/ci.yml`   | bats and shellcheck on ubuntu-latest and macos-latest, plus a hygiene job                        |
| `.gitattributes`             | What a release tarball may not carry, read by `git archive`                                      |

## Carried forward, and what would re-open each

**This is where the remainder went when ST0003 and ST0005 closed.** None of it is queued. **Do not pick one up because it is written down** -- it is recorded so it is not lost, which is the opposite of a queue.

- **WP-02, rule 4's three noise shapes.** Parked by hv, evidence and recommendations on record in the store (`intent wp list ST0003`). **Nothing moves until a live venture trips one.**
- **`pattern-library` stays unwritten.** A spec is written when an order needs one, and none does -- so it remains the live exemplar of a slug that is real, in the taxonomy and unwritten. **If an order ever names it: write the spec and re-point the exemplar and its pinning test in the same change**, or the library's description of itself becomes false.
- **`reciprocal` is not symmetric between `positioning-icp-personas` and `pricing-and-packaging`.** One declares the other and is not declared back. Flagged in `specs/library.md` rather than invented, because writing the missing half would be this library inventing a dependency Claude Design never declared. **No check can see it; a person is the only instrument.**
- **devbin records a home directory in its manifest.** `devbin install` and `devbin upgrade` write `# source: <absolute path>` into `bin/.devbin/manifest.sha256`, and every sibling estate checked that tracks the manifest carries the line. Here the manifest is gitignored, and a test pins that, rather than edited. Filed in devbin's own tracker as issue `0069`. **Re-open when devbin records its source without a home directory** -- then track the manifest again and retire that test.
- **Intent v3 cannot read a citation the port carried over from v2.** `intent at lint` examines none of ST0001 to ST0004's legacy rows and still says `ok`; the suite's contract guard is what checks them. **Re-open if Intent learns to read `legacy.raw`**, and drop the guard's legacy half then, rather than keep two checks of one thing.
- **Intent renders an empty note as a trailing separator.** A test row whose note is the empty string ends its line in the realised `acceptance.md` with ` -- `, and CI's hygiene job fails on the trailing space; an absent note renders cleanly, and `intent at edit` has no way back to absent. ST0005 hit it by clearing notes and fixed forward by giving each row the evidence of its red. **Re-open when Intent renders an empty note the way it renders an absent one.**
- **Two files describe a test layout this project does not have.** `AGENTS.md`, which is generated, says `bats -r tests/`, and `intent/llm/ARCHITECTURE-shell.md`, Intent's shell seed, says tests live under `tests/unit/`; the suite is `test/cdsync.bats`. **Re-open when either is next touched** -- `AGENTS.md` through `intent agents sync`, never by hand.

## Loose ends

- **Unpushed work exists in four repositories and pushing is hv's. Never write the count down** -- there are two remotes that need not stand at the same place, and **the mirror holds the only copy of the pre-public history**. The board's two-remotes watch-out has the commands and the reason.
- **Acme round two is test apparatus, not a queue item.** The wind-back retired the transport queue and the round-5 answer died unsent with it. That tree is a nested git repository, gitignored from this one.
- **geodica's kit is prose only** -- no `kit/tokens.json` -- so rule 4 is dark there. Stays as record; no round is going back.
- **The four delivered projects' `BOOTSTRAP-CD.md` copies froze on 9 August.** Baize's was regenerated and committed that morning under hv's stale-is-never-accepted ruling, which also caught an unrecorded ADR drift. snorkeltoast's stays stale as part of the frozen record unless hv says otherwise -- and staleness is *detectable* now: `doctor` and `check` both warn, advisory.
- **Spent transport sits in six `_inbox/` directories.** All gitignored and local-only; **the two newest hold the Laksa theme packs, which exist nowhere else.** Do not clear those two until Laksa has taken them.
- **Intent's template absolute-path defect is reported upstream as Intent issue `0016`.** Baize's and Lamplight's copies stay as they are until Intent ships the fix.
