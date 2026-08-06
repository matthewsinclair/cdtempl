# cc -- 31 July 2026, archived

Completed work. The live board carries only what is still open.

## The day in one line

**The SSOT inverted, and then the loop ran three times in one afternoon.** `design/system/` became the single source of truth and Claude Design became a clamp-on tool -- then `BOOTSTRAP-CD.md` was built, exercised against four real trees, corrected eight times, and finally read by three Claude Design projects that exported against it and installed clean.

## Committed -- 26 in Cdsync, 12 across the four projects

| Commit | What |
| ------ | ---- |
| `795540d` | Canon: the tree is the SSOT, the loop, never repair a drop |
| `35c1e01` | `cdsync bootstrap` -- one generator, cold and warm, protected, `--delta` |
| `f15f766` | The Lamplight storystyles note, recorded as having no successor |
| `a69b09a` | Why the duplicate `_inbox` guard is deliberate, and the `check-ignore` trap |
| `dd9acdc` | A drop may not deliver a `.gitignore`. `CDSYNC_DROP_REFUSED_FILES` |
| `b81568a` | The backup anecdote replaced with what the sweep measured |
| `d4ddef0` | Localfold before the first compact |
| `34a51d2` | **List every path** -- the document is what the export obeys |
| `9030968` | `addenda/README.md` documents the directory, it is not an addendum |
| `4681fe4` | Name the scan roots, never path them |
| `45d59c2` | Stop asking for a file the install refuses |
| `aa1b5bf` | **Stop ordering a restructure of a tree that is not Cdsync-shaped** |
| `6a8f973` | A directory called `assets/` is not the Cdsync shape |
| `75b658a` | Name what the drop borrowed from the project, and send it back |
| `6862178` | State the borrowed-material rule unconditionally |
| `f60bcc9` | `help` only pages at a terminal; refuse Cdsync's protocol material |
| `2d1856a` | The document excludes itself, and the note that carries it |
| `e3dcb4e` `52a43cb` `8c405a0` | The three covering notes, and their two corrections |
| `06a29ca` | **`check` rule 6, classification** -- and the conflation this library declared |
| `e834989` | **Nine missing library specs; `cms-rollout-plan` 53 and `go-to-market-plan` 54 admitted** |

Per project: Baize `c8f7341` `2fd3fd3` `a6d78de` `3cf34a1` `bca87d8` `97253cb` `40ae63f` `689806a`; Lamplight `4e21713e8` `7792fc786` `5f0ccfedb`; G&G `0ac28d5` `e8d9772`; snorkeltoast `d7fbfde` `90ea966`.

**205 tests -> 264, 0 failures** throughout.

## The three rounds, end to end

CD read the document for the first time ever -- Lamplight's earlier round predated it -- and all three exported against it and installed clean.

| | Tracked | The check | Result |
| - | ------- | --------- | ------ |
| **Baize** | 415 -> 420 | `handoff/intent/` must not return | **gone** |
| **snorkeltoast** | 196 | `design/system/cdsync/` must not return | **gone** |
| **G&G** | 144 | -- | `check` 17 clean, 43 advisory |

Landed: **§07 and its page capture** (the addendum's gap, closed at source, four typed states with structural `data-state` values), **`index.md` -- the first manifest this programme has had**, and **classification on all sixteen G&G assets**, 5 confidential / 4 internal / 7 public.

**Baize's addenda retired**, both verified by content rather than by CD's receipt. `player-typed-states.md` absorbed into §07. `st0018-divergences` absorbed **by dissolving** -- its job was to make CD's copy of ST0018 match ours, and we then ruled CD should hold no copy at all.

## Eight defects in one generator, and who found them

Five by reading its output against a real tree, three by its actual reader.

1. **`assets/` unlisted when it holds flat files** rather than `<slug>/` subdirectories. Baize 7 files, snorkeltoast 4. The table found nothing, the listing skipped the directory assuming the table had it, and **seven tracked files -- a logo and an app icon -- appeared nowhere in a document that says "export every path listed here"**.
2. **`kit/` and `notes/` enumerated by nothing at all.** G&G's exposure.
3. **Top-level dotfiles never scanned.** `.thumbnail`, tracked in three of four.
4. **`addenda/README.md` counted and quoted as an addendum.**
5. **Every generated document named the filesystem it was generated on.** One line, `brief_numbering` echoing `git rev-parse --show-toplevel`.
6. **The contract section ordered a restructure.** *"Cdsync owns exactly these paths... What you export is unpacked into them"* over an as-is tree is an order, not a reference -- and three of four are as-is. **CD-in-Baize worked out it would break every relative pointer across 442 files and refused.** A less careful reader converts.
7. **The branch's first discriminator was wrong** and put Lamplight on the shaped side; its `assets/` holds four subdirectories and **not one carries a `spec.md`**. The trap inside the fix for the trap.
8. **The step list told three of four projects to absorb addenda they do not have.**

Plus `cdsync help` shelling out to `glow`, which pages -- so `cdsync help import | grep x` hung, **intermittently**, passing in the foreground and stalling at test 4 in the background.

## The borrowed material, and hv's ruling

**Both app projects carried a copy of their own `intent/` inside the drop** -- the `docs/design/` failure running the other way. Opposite cases, same remedy:

| | Baize -- 28 files | Lamplight -- 58 files |
| - | ----------------- | --------------------- |
| Held | Copies of threads it owns, ST0016-ST0023 | Nine threads **CD authored**, ST0334-ST0342 |
| In the repo? | 19 of 28 at their own path | **None.** High-water ST0330 |

Baize's had drifted twice over -- `ST0016/acceptance.md` **129 lines in the repo, 237 in the copy**, and nine at paths the repo had moved under `NOT-STARTED/`. Lamplight's was the same hazard before it bit: **nine steel threads existing in exactly one place, and that place a directory every export overwrites.**

Moved to `intent/st/_inbox/` in both, with triage READMEs (`3cf34a1`, `5f0ccfedb`). **`intent/.gitignore` was `_inbox/` unanchored** and silently caught the destination -- the threads survived because they arrived by `git mv`, but the README would not have reached a clone.

## Classification, and the defect at home

Rule 6 shipped after its deliberate one-round wait. **Advisory, and not a judgement call**: classification "is not a delivery filter and must not be used as one", so blocking would be using it as exactly that.

Running it found the fault at home. **`specs/library.md` declared the conflation in its own legend** -- `INT internal` in a column headed "For". Twelve of nineteen specs and 33 of 52 taxonomy rows inherited it. Fixed at source: legend split, `DEV`/`PRN` added, taxonomy remapped by group, nine frontmatters given a real audience, `spec_library_version` 2 -> 3.

**`public` is not flagged**, which the first cut of the rule got wrong. It is a real answer to both questions.

## The sweep

`Baize/.backup/` -- 233MB, 1654 files, gitignored and invisible to `git status` -- moved to `~/Downloads/baize-repo-snapshots-202606-202607/`. **1491 of 1654 recoverable from Baize's own git objects, 163 not.** 90% redundant and 10% irreplaceable with nothing to tell them apart, the same shape as the earlier `~/Downloads/backup/` sweep.

## The one I caused

`pkill -9 -f bats`, meant for my own stalled test runs, **killed all three of Lamplight's Claude Code sessions.** `-f` matches the whole command line as an unanchored substring. No files were lost -- git state is on disk and survived, including two untracked new files and a stash -- and hv restarted them. Entirely avoidable: background jobs I start have task IDs, and TaskStop is what those are for.

---

# After the compact -- the afternoon, and the round trip going out

Seven more Cdsync commits and eight across the four projects. **269 tests, 0 failures.** The four requests were sent at the end of it.

| Commit | What |
| ------ | ---- |
| `35cc22c` | **`spec_version` ruled: the library's stamp**, said in all four places a reader could reach it |
| `c8a24fc` | ST0002 -- the round trip made falsifiable, two numbers that move on their own |
| `db2e991` | Pickup; two counts that had drifted |
| `7aa9801` | **Absent is not empty** -- a probe must be able to say which |
| `58b379d` | The four covering notes |
| `fc23ca8` | The manifests are ordered by the document, not deferred |
| `16129b7` | **Seventh not-yours rule: a working directory is not deliverable** |

## The ruling, and the shape of what it caught

`spec_version` is **which version of the library specification an asset was built from**, copied unchanged. Not a per-drop counter. Only that reading makes rule 2's comparison mean anything: a number each side increments on its own schedule never disagrees for a reason.

**The field was asked for by name in the brief, read by name by `check`, and defined nowhere.** So Claude Design supplied the only reading available to it and bumped all sixteen of Gyre & Gymble's assets on the round that added classification. Fourteen flagged.

**The two that did not flag are the finding.** Their library entries happened to have also reached 2, so the check went quiet over two assets stamped exactly as wrongly as the fourteen. **Two unrelated counters colliding reads as agreement** -- the recurring failure in a form not seen before, and one no amount of care in the rule itself would have caught.

Rule 2's message said **"the library needs updating"** in all fourteen findings it has ever raised, and was wrong in all fourteen: the library was right and the drop had invented a number. It now states the disagreement and the rule and names no culprit it cannot see, pinned by a test that asserts the old sentence is gone.

## A stale document, found by regenerating rather than by looking

Regenerating the four turned up Baize's at **-166 lines**: it still quoted the two addenda retired five hours earlier in `40ae63f`.

**Regeneration hangs off install and import. Retiring an addendum is a repo-side edit, so nothing fired.** Sent unread it would have handed Claude Design two gaps it had already closed, in Baize's own voice, to be absorbed and retired a second time -- the failure the addenda protocol exists to prevent, produced by the mechanism meant to prevent it. It was one of the four documents about to go out.

Canon's "currency is continuous" now says **across syncs**, and both the doc and the generator carry the gap explicitly.

## The probe error, reported to hv before it was caught

Told hv that Lamplight had no `design/system/_inbox`. **It has one and it is empty.** `grep -c . || echo NONE` prints `0` *and* exits 1, so the fallback appended rather than replaced and the value became `0\nNONE`, split across two lines in the output. Visible, and read past.

Swept the shipped code: all ten uses are `grep -c . || true`, which keeps the zero and drops the status. **No instance of the appending form in `lib/` or `bin/`** -- the bug was only in the ad-hoc probe.

## Readiness, measured rather than remembered

Every gate checked against the real trees before saying the round trip could run:

- Four documents current and committed; four `design/system` trees clean.
- **The install refusal is scoped to the target path**, not the repository -- so in-flight work in Lamplight's and Baize's own sessions does not block it. This was the one that could have stopped everything.
- Archive selection is newest-by-mtime over a `*.zip` glob, so the `.DS_Store` in three inboxes cannot be chosen. hv then binned the spent zips, leaving all four empty and nothing to disambiguate.
- Tracked in full and `design/.gitignore` repo-owned in all four -- the two conversions the earlier restart notes flagged as missing are done.
- **No `intent/` directory and no `ST####` anywhere in any of the four drops.** The borrowed-material purge held on both sides.

## The covering notes, and one correction to them

Four notes at `intent/st/ST0002/round-messages-systematic-pass.md`, each accompanying that project's own document as an upload. Lamplight first: the only project that has never run under this protocol, so the only cold read available.

**No note names a known finding**, deliberately -- naming them clears them and proves nothing.

The correction: the first draft said no note asks for an `index.md` because ordering one would turn a coverage test into a build. **Wrong reason.** The inventory already prints *"Producing one is part of the next round"* whenever `index.md` is absent, and that sentence is in Lamplight's and snorkeltoast's copies. The pass produces both manifests on its own; repeating it in a note would be a second instruction that can drift.

## Why the four trees differ, which hv asked

Three kinds, and only one was drift:

1. **G&G is converted, the other three are as-is.** G&G's tree is exactly the five Cdsync-owned paths plus the two protocol files. The others are Claude Design's whole project directory -- `START-HERE.md`, `lib/`, `uploads/`, `venture/`. Deliberate: converting breaks every relative pointer across hundreds of files.
2. **Within the as-is three, the layout is whatever that Claude Design session built.** snorkeltoast by medium, Lamplight and Baize by `design-system/` + `prototypes/`. Content organisation, and canon says keep it.
3. **`index.md` and `RETURN.md` are not content** -- they are two of the five contract paths, and their presence tracked *how many rounds each project had run*, nothing about the projects. Already closing by itself, per above.

## The seventh not-yours rule

hv ruled `scratch/` out of the export. **Lamplight's holds 39 tracked PNGs** -- trial renders and screenshots taken to look at something once -- which an as-is export carried in and the repository has since tracked, diffed and presented as deliverable. Only Lamplight has one.

Written with a promotion path rather than a bare prohibition: if something in it matters, move it to a real path and name it in `RETURN.md`. **Lamplight's next install will remove all 39 and print every one.**

The count moved six to seven in both places that carry it -- the hand-maintained-list drift this project keeps finding in itself, caught this time by looking for it before writing.

---

# The evening -- round three came back, and what it proved

## The return leg, and both predictions missing

All four drops installed, audited and committed. **Zero unexplained deletions across four repositories**: Lamplight 42 (39 `scratch/` plus three covering notes), Baize 8, snorkeltoast 4 with six renames, G&G 0. Every one matched a sentence in that project's `RETURN.md`.

Baize's arithmetic is the one worth keeping. CD reported nine files deleted and eight landed -- the ninth was `BOOTSTRAP-CD.md`, which the installer preserved as repo-authored. **The protection is visible in the discrepancy**, which is a better proof than a passing test.

The scare that wasn't: Lamplight's `handoff` said `replace` while CD had withheld `handoff/intent/`, 58 files. Checked before running -- the path does not exist in the repo at all, and the nine threads were long since actioned into `intent/st/_inbox/` as ST0334-ST0342. The one-go-around rule had already run its course.

**Measured before and after against the pre-install tree in a scratch worktree**, rather than trusting the board's remembered numbers:

| rule | before | after | predicted |
| ---- | ------ | ----- | --------- |
| rule-2 | 15 | **3** | 1 |
| rule-3 | 12 | **7** | -- |
| rule-5 | 5 | **6** | -- |
| rule-6 | 11 | **11** | 0 |
| total | **43** | **27** | -- |

**rule-2 missing high was the finding.** The two extras are `brand-guidelines` and `design-system-index` -- precisely the two the rule had been silent on. Before: drop stamped 2, library at 2, agreement, silent. After: drop stamped 1, library at 2, **stale, and true**. Nine library specs sit at version 2 and G&G holds exactly those two. So fifteen wrong findings became three right ones, and the sixteenth watch-out form resolved itself in the open.

**rule-5 going UP was CD being right and the rule being wrong.** `print-collateral` gained prose coverage naming exactly what is missing -- the trust band three documents claim appears on the fliers and none carries. Rule 5 rejected it for not being `N/M`. All six of that shape sit on `partial`.

## The three gaps, and the shape they share

Every one is the same instrument: **the generated document is an instruction the other side obeys, so a gap in it is a defect that reports as supplier error.**

1. **A field explained, its value withheld.** `spec_version` was defined precisely and the number never stated -- and CD holds a delivery, not the library. Three of four projects asked the same question in three shapes on one round. Three suppliers asking the same question is **one** defect in the document.
2. **An instruction complete on one tree and a no-op on another.** "Declare `classification`" is a whole job where the field is absent and nothing where it is present. The one project that needed the second half was the one project never told about it.
3. **A finding whose only remedy is an instruction nobody wrote.** Rule 6 would have reported eleven every round forever.

## The documentation audit, and what it found

`help/cdsync.md` -- the top-level help, the first page anyone reads -- documented **neither `install` nor `bootstrap`**. Its loop ran the export straight into `cdsync import`, the dangerous half of a pair with opposite semantics. Meanwhile `usage()` inside `bin/cdsync` had been kept current the whole time: **two descriptions of one thing, and the fuller one was wrong.**

`help/check.md` documented five rules where six exist -- missing rule 6, the one that fired eleven times that same afternoon.

`cdsync help doctor` failed while `usage()` advertises `doctor` and promises `cdsync help <command>`. **Seven of eight honoured a promise made for all eight**, which is exactly the ratio nobody notices by hand.

`MODULES.md` was an empty registry carrying Elixir placeholders -- `MyApp.Auth.Guardian`, Swoosh, Oban -- in a shell project whose sixteen modules each declare their concern in their own header, while `CLAUDE.md` tells every agent to consult it before creating a module. `ARCHITECTURE.md` was an unfilled template. `DECISION_TREE.md` was Ash and LiveView.

Left alone on purpose: `specs/kit.md` says "fifty-one artefacts" against a taxonomy of fifty-two. It is library text at `spec_version: 3`, and editing it silently changes what that stamp means.

## Probes that lied, three of them in one session

- **`find -maxdepth 4`** found two of the four `_inbox/` directories. The others are a level deeper under `Sites/`. It reported success.
- **`each_spec` returned 0** with `CDSYNC_HOME` unset in the subshell, so the library resolved to `/specs`. Every row zero at once.
- **`grep -cE '^\| [0-9] \|'`** counted the exit-code table as rules and reported nine documented where six exist -- inside the test written to stop exactly that drift.

All three caught by re-probing rather than by reading. **A uniform zero is a broken probe until proven otherwise; real data is lumpy.**

## Integration

hv asked whether the four projects can start building against their design systems. **Yes, and today is the first day that is true** -- because `index.md` landed in all four, and before this morning two of them had no manifest, so an integrator could see files but not tell complete from partial.

G&G unreservedly: Cdsync-shaped, `kit/tokens.json`, zero blocking findings. The other three integrate by reading rather than by checking -- their tokens sit at `handoff/assets/tokens.css` or `styles.css`, so `check` refuses and rule 4, the blocking colour guard, cannot run at all.

**Cdsync has no application-side check, by design**, so nothing will report drift once integration is live. Held back: Lamplight's `ref`, the only open ruling that could move paths.
