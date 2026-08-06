# Tasks - ST0002: Port four established projects to the Cdsync protocol

## Status -- 1 August 2026, end of day

**Supersedes every status block below, including 31 July's.**

**Two projects were added to the thread and are already running.** matthewsinclair and geodica are existing Laksa content sites; both were initialised with the new `cdsync init`, both hold a cold `design/system/` tree with a current `BOOTSTRAP-CD.md`, both are committed, and **both are live in Claude Design**. Their documents were verified byte-identical to a regeneration, so those sessions are obeying the right instructions.

| Project | State |
| ------- | ----- |
| matthewsinclair | `init` + `bootstrap`, committed `409d823`, running in CD |
| geodica | `init` + `bootstrap`, committed `7b0a4cc`, running in CD |

**They needed a command that did not exist.** `bootstrap` refused over an absent tree and advised `cdsync new`, which for an existing project would create a second git repository inside the first and write three files the canon forbids there. That is the tell for a missing command rather than a missing flag, and `cdsync init` is it.

**Scope is the one thing still open for them.** `BOOTSTRAP-CD.md` gives Claude Design the shape and the rules but not which assets to build, and the taxonomy has 52 slugs. hv supplied scope by hand this round; the durable answer is a `cdsync.json` per venture, which **cannot live in the site** by canon, so where it lives is undecided.

**Baize's `BOOTSTRAP-CD.md` is regenerated but uncommitted** -- its steel-thread high-water read 23 against a tree at 24. The other three regenerate byte-identical. It was left alone because that repository carries hv's own uncommitted work.

## Status -- 31 July 2026, late afternoon

**Superseded by the block above.** Three Claude Design rounds ran and installed clean; the protocol they ran against is `design/system/BOOTSTRAP-CD.md`, generated per project and committed in all four.

| Project | Tracked | State |
| ------- | ------- | ----- |
| Baize | 418 | Installed 31 Jul. §07 landed, `index.md` is the programme's first manifest, both addenda retired on content -- which is the 420 minus 2 |
| Gyre & Gymble | 144 | Installed 31 Jul. Classification on all 16, 5/4/7. Every asset now resolves in the library |
| snorkeltoast | 196 | Installed 31 Jul. The fake `cdsync/` protocol tree is gone from Claude Design's side |
| Lamplight | 692 | **Document generated, committed and UNSENT.** Has never run a round under this protocol |

**Both round checks passed.** `handoff/intent/` did not return to Baize; `design/system/cdsync/` did not return to snorkeltoast.

**The spec library resolves everything Gyre & Gymble holds.** Nine specs written and two slugs admitted -- `cms-rollout-plan` 53, `go-to-market-plan` 54. "No entry in the spec library" and "not in the taxonomy" are both now zero, from five and three.

**`check` rule 6 shipped** after its deliberate one-round wait, and found the conflation in this project's own library legend.

### The four-way round trip is BACK and installed

**All four drops installed, audited and committed on 31 July.** Tracked under `design/system/` after: Lamplight **656**, Baize **410**, snorkeltoast **193**, Gyre & Gymble **144**.

**Zero unexplained deletions across four repositories.** Every removal matched a sentence in that project's `RETURN.md`:

| Project | Deleted | What |
| ------- | ------- | ---- |
| Lamplight | 42 | 39 `scratch/` PNGs plus three covering notes -- the seventh not-yours rule on its first outing |
| Baize | 8 | `BAIZE-CLOSEOUT.md` and seven working screenshots |
| snorkeltoast | 4 (+6 renamed) | the deck scratchpad and three screenshots; `_source/uploads/` promoted to `_source/artwork/` |
| Gyre & Gymble | 0 | thirty files modified, none lost |

**Baize's arithmetic is the keeper.** Claude Design reported nine files deleted and eight landed -- the ninth was `BOOTSTRAP-CD.md`, which the installer preserved as repo-authored. The protection is visible in the discrepancy.

**The top-level install plan is not the removal audit.** It lists top-level paths only, so a file deleted inside a replaced directory never appears there. `git status` after the install is where these 54 were actually read.

### Both falsifiable predictions missed

Measured in a scratch worktree against the pre-install tree, rather than taken from the board.

| rule | before | after | predicted |
| ---- | ------ | ----- | --------- |
| rule-2 | 15 | **3** | 1 |
| rule-3 | 12 | **7** | -- |
| rule-5 | 5 | **6** | -- |
| rule-6 | 11 | **11** | 0 |
| total | **43** | **27** | -- |

**Missing high on rule-2 was the finding.** The two extras are exactly the two the rule had been silent on: their library entries sit at 2, so resetting the drop to 1 exposed real staleness that two unrelated counters colliding had been masking. Fifteen wrong findings became three right ones.

**Missing entirely on rule-6 was a defect in the document.** Three projects were *adding* classification and did the whole job. The fourth already carried the field on all sixteen assets and still carried `internal` in `audience` on eleven -- because nothing had ever said to take it back out. A pass that obeyed the document could not have moved that number.

**rule-5 went up, and the supplier was right.** `print-collateral` came back with prose coverage naming exactly what is missing; rule 5 rejected it for not being `N/M`. All six of that shape sit on `status: partial`, so the fix is precisely targeted -- and wants hv.

### The three gaps, shipped as `90747b5`

1. **The document now carries the version numbers**, not only their meaning. Claude Design holds a delivery and cannot read the library, so "copy the specification's version" was unusable alone. It also says to **leave the field out** where the library has no entry -- the commoner case, since only Gyre & Gymble is built from taxonomy slugs.
2. **The de-conflation instruction**, so declaring `classification` includes removing the value from `audience`.
3. **Rule 2 names the remedy** -- rebuild against the newer spec, do not raise the stamp on its own.

All four `BOOTSTRAP-CD.md` regenerated by hand afterwards: **a generator change stales every project's copy at once, and nothing detects it.**


**`spec_version` ruled by hv, 31 July (`35cc22c`).** It is the library's stamp -- which version of the library specification an asset was built from, copied unchanged -- and never a per-drop counter. The field was asked for by name in the brief and read by name by `check`, and said what it counted nowhere, so Claude Design supplied the only reading available to it. It is now stated in canon, the library, the brief's spec contract and `BOOTSTRAP-CD.md`. Rule 2's "the library needs updating" is gone: it was the prescription in all fourteen findings the rule has ever raised, and wrong in all fourteen.

**A stale document was found while regenerating the four.** Baize's still quoted two addenda it had retired five hours earlier, because retiring one is a repo-side edit and regeneration only hangs off a sync. Unread, it would have handed Claude Design two closed gaps to close again.

### Open

- **Finding 5**, `formats_required`: narrowing of done, or advisory?
- **32 of 54 taxonomy slugs have no spec.** 26 written.
- **11 rule-6 findings on Gyre & Gymble** -- `audience` still carries `internal` on 11 of 16. The systematic pass is what clears them.



## As-built status, 31 July 2026 -- supersedes the 30 July block below

**All four repositories now track their drop in full, with a tracked, byte-identical repo-owned `design/.gitignore`.** That was three separate jobs and they are done: gyreandgymble `0ac28d5` (144 files, 19MB), snorkeltoast `d7fbfde` (197 files, 22MB), Baize `c8f7341` (guard restored), Lamplight `4e21713e8` (comment cut).

**The loop ran end to end on Lamplight, first try.** Claude Design exported the whole tree against the marks the brief carried; the archive landed in `_inbox/`; `cdsync install` found it with no argument; the dry run gated it at **one removal**; `BOOTSTRAP-CD.md` regenerated itself. Committed at `7792fc786`, **750 tracked**, target clean. ADR-0021, ADR-0022 and ST0342 were allocated against our marks and confirmed before allocation.

**`cdsync bootstrap` exists** (`35c1e01`) and replaces hand-written notes: one generator, cold over an empty tree and warm over a populated one, regenerated by every sync. **Lamplight's note was the last hand-written one** -- `note-lamplight-storystyles-round.md` says so in the file.

**Remaining on this thread: Baize, then G&G, then snorkeltoast**, in hv's stated order, so all four land in the same state before Lamplight integration work begins.

**The vestigial sweep is DONE** (31 Jul) and the table below is superseded. Nothing was deleted; everything was moved. Of 2607 files in `~/Downloads/backup/`, **2287 were recoverable from the projects' own git object databases** and the 320 that were not were intermediate round snapshots never committed. Renamed to `~/Downloads/claude-design-superseded-rounds-202607/` with a README. `Irina's Secret.mp4` (398M) went to Dropbox as venture source material -- which is the still-open "name a home for venture-owned source assets" item, answered once by hand rather than by protocol. Lamplight's `_inbox/` archives (1.1G) moved to `~/Downloads/lamplight-design-drops/`, matching Baize's existing convention.

**Corrected at source:** finding 3 below describes **Gyre and Gymble** as holding `venture/ + brand/ + print/ + social/ + prototypes/ + lib/`. Measured on disk, that is **snorkeltoast's** shape. G&G is `assets/` 131, `notes/` 6, `kit/` 3 -- textbook Cdsync shape, consistent with it needing no conversion. The finding predates the exports landing.

## As-built status, end of 30 July 2026

**All four exports landed, current and verified. All four inventories read. Three conversion briefs written; G&G needs none. Two standing protocol documents written. What remains is transport, and it is hv's.**

`dispatch.md` is the shortest path to what is actually outstanding -- eight recipients, who gets what, and the per-project delta measured on disk.

Three questions that stood open all day were **ruled on 30 July** and are recorded at source rather than only here: `venture/` stays out of round one, `print-collateral` is admitted as taxonomy 52, and `check` will not cross-reference `index.md`.

**The tooling gap that shaped this thread is closed.** `cdsync install` exists, so an as-is export is installed by the tool rather than by hand -- and `cdsync brief` now carries numbering high-water marks, which is the gap that let Claude Design allocate ids blind and cost a full export cycle.

**Still open on this thread:** the vestigial sweep (unblocked, not started -- three `~/Downloads/` items below), converting G&G and snorkeltoast to the tracked-in-full layout, and giving Baize a repo-owned `design/.gitignore`.

**Measured, and it corrects what the tables below assume:** Lamplight is converted and the most thorough of the four; Baize tracks 442 files but has no `design/.gitignore` at all; **G&G and snorkeltoast track zero**.

## Done

- [x] Survey all four repositories: size, HEAD, cleanliness, what `design/` holds,
      where the design system actually lives. Full table in `design.md`
- [x] Find and read the existing convention -- `docs/README.md` and `START-HERE.md`
      in both delivered drops. Three representations, one source
- [x] Establish that Group A and Group B are different jobs, and that **the brief
      must precede the Group B extract**
- [x] Verify the five blockers against code and filesystem rather than by inference
- [x] Measure the binary colour-scan false positive rather than assume it

## DECISION 1 IS SETTLED BY MEASUREMENT

Recorded 30 Jul, late, after the fold. The topology question turned out to be much
smaller than `design.md` states, and the measurement settles it.

**Every canonical document inlines its own tokens.** One `<style>` block each; the
only `<link>` elements are external Google Fonts. So Cdsync's rule -- that an artefact
restates token values literally rather than linking `../../kit/tokens.css` -- **is
already satisfied by the existing documents.** That rule is about token values in
text, and I had wrongly read it as requiring megabytes of shared imagery to be
duplicated.

What each document actually needs from outside its own directory:

| Document | Parent refs | Distinct images |
| -------- | ----------- | --------------- |
| Baize, all eight | 2 to 4 | **exactly 1** each |
| Lamplight `design-system` | 6 | 5 |
| Lamplight `gwidget` | 8 | 7 |
| Lamplight `storyfield-surfaces` | 8 | 7 |
| Lamplight `storyfield-ios`, `wrighter-frontdesk` | 4 | 3 |
| Lamplight `acton-index` | 3 | 1 |

**So per-asset self-containment costs one to seven image copies per document**, plus a
runtime script that Cdsync already expects as a sibling -- the documented `support.js`
exception. The 376M is dominated by imagery used by the generated site and the venture
tree, not by the design canon.

**Ruling: map onto Cdsync's per-asset shape.** Tool unchanged, cost measured and small,
nothing agreed gets re-authored. The two remaining options in `design.md` are dropped.

Decision 3 is taken as **design tree only** for the first round -- the safe option,
needing no leak guard, and reversible since venture can be a later round.

**Decision 2 remains genuinely open**, but it no longer blocks: a drop carrying
venture-specific slugs imports fine and `check` reports `no entry in the spec library`
as an *advisory*, not a block. So the port can proceed and the taxonomy question can be
settled on the evidence of a real drop.

### Decision 2 -- taxonomy, still open

### Decision 2 -- taxonomy

Nine venture-specific surface documents have no slot in the 49-slug taxonomy, and
one agreed 877-line document spans five slugs. Three candidates:

| Option | What it costs |
| ------ | ------------- |
| **Per-venture spec library overlay** at `design/system/specs/` | A real new feature in `specs.sh` and `brief`. Preserves every agreed document intact as a first-class asset. |
| **Map onto generic types with `coverage`** | No tool change, but five documents share one slug -- and slugs collide, so only one can exist. Probably fatal on inspection. |
| **Extend the global taxonomy past 51** | Simplest change. Pollutes a deliberately generic library with Baize- and Lamplight-specific concepts. |

### Decision 3 -- scope and confidentiality (taken: design tree only, round one)

Lamplight's venture set carries a live raise figure and an explicit do-not-name-the-IP
constraint. Cdsync has no leak guard.

| Option | What it costs |
| ------ | ------------- |
| **Design tree only** | Nothing confidential enters a Cdsync target, so no leak guard is needed. Venture documents stay untouched and unported. |
| **Design plus venture, leak guard first** | Makes Cdsync responsible for material it has no way to protect. Needs `confidential:` in `spec.md`, `site` exclusion, and a `check` rule. |
| **Design now, venture as a later round** | Same first step as design-only, keeps venture explicitly on the roadmap rather than dropped. |

## The four Claude Design projects, read directly 30 Jul

hv supplied share links and re-authenticated the browser, so all four projects were read
first-hand rather than guessed at. This is the mapping to verify against:

| Claude Design project | Project id | Local repo |
| --------------------- | ---------- | ---------- |
| Baize Design System | `edd66a31-171d-44f2-aa92-f0dc4997a0b1` | `~/Devel/prj/Baize` |
| Lamplight Design System | `1f158de5-4597-4c1a-bc57-e8fac35f4954` | `~/Devel/prj/Lamplight` |
| Gyre and Gymble Design System | `51d14afe-2d41-45a8-9943-4eb411432c5f` | `~/Devel/prj/Sites/gyreandgymble` |
| POP^UP^ART by SNORKELTOAST.COM | `ea8102d8-7b7c-488d-84d7-cc417fca467f` | `~/Devel/prj/Sites/snorkeltoast` |

**Each session had invented its own destination**, which is the thing hv asked to be
normalised: Baize expects `intent/_inbox/lit-pool/`, Lamplight `intent/_inbox/acton/`.
All four briefs now carry an identically-worded block putting every drop at
`design/system/`, inserted from one source so they cannot drift.

Five findings, each of which changed a brief:

1. **Baize has a newer release that has never been downloaded.** `lit-pool/`: 105
   markdown sections, 92 captures at 2x, seven design PDFs, four venture PDFs, three
   decks, a `RELEASE.md`. Absent from the repository and from `~/Downloads`. The asset
   map in `port-brief-baize.md` was derived from the 28 July `baize-design-system/`
   snapshot and may be behind it; the brief now says so and asks for the differences.
   **It also carries ADRs 0021-28 awaiting ratification, and ADR-0021 overturns
   ST0009's Highlander rule** -- which may bear on this port.
2. **Lamplight already has a leak guard.** It built "a self-checking team-only static
   site that refuses to publish confidential material". `design.md` records Cdsync as
   having none, which is true of Cdsync but wrong about the existing tooling -- so
   decision 3 has more prior art than the survey credits. Lamplight's drop *is*
   downloaded, just under a different name than CD expects.
3. **Gyre and Gymble is not a shingle and is a third topology.** Nine documents, 73
   markdown sections, a reading room with search, a 31-slide deck, and `venture/` +
   `brand/` + `print/` + `social/` + `prototypes/` + `lib/` -- not the `design-system/`
   shape decision 1 was measured against. `products.json` drives live pricing across
   every document and export. Its `docs/pdf/` and `docs/pptx/` hold only READMEs.
4. **snorkeltoast is POP^UP^ART, and its project is running a retired Cdsync plan.** The
   live conversation describes a handover protocol -- `template/**`, `OUTBOX.md`, a
   minted URL, `cdsync pull`, an allow-list, a commit sha acknowledged through
   `cc/inbox.cd.md`, and "the eight rulings". **None of it exists**, in the tree or
   anywhere in history; the `cd` whiteboard node is archived, paused 09:46 on 29 July
   at "new workstream, not yet started". Its brief now opens by retiring that thread
   explicitly, because otherwise the session will try to reconcile the two.
5. **The venture facts are held by CD, not by the repositories.** Which inverts the
   `inputs_missing` field: it means facts *nobody* has, not facts the brief lacks. Both
   extract briefs were corrected, and both now require the facts to reach `RETURN.md`
   so they can be transcribed into `cdsync.json` and survive the round.

## THE PLAN CHANGED, AND FOR THE BETTER -- read this before using any brief

hv reordered the work late on 30 Jul, and the new order is right:

1. **Tonight.** Each CD project finishes its own outstanding items and exports
   **everything it holds, as-is**. No restructuring.
2. **Morning.** Each zip is unzipped **by hand** into `<repo>/design/system/`. Not with
   `cdsync import` -- import writes only five owned paths and would discard most of an
   as-is dump.
3. **Then.** Review what is actually there, and only then write a precise conversion
   brief per project, against the real material.
4. **Finally.** Convert, and clear the vestigial directories.

Why this beats the original sequencing: the port briefs described a target shape derived
from a *summary* of each project rather than from its contents. A restructure designed
that way is a restructure done twice. This way the conversion brief is written against
ground truth.

**So the four `export-brief-*.md` documents are what goes to CD tonight.** They tell CD
explicitly to ignore the earlier port brief if it has seen one, and that nothing delivered
tonight is wasted -- it becomes the conversion's input.

`port-brief-lamplight.md` and `port-brief-baize.md` are **kept as drafts for step 3**, not
sent. `extract-brief-*.md` are superseded: their inventory sections folded into the export
briefs, and their Cdsync-shape sections belong to step 3.

One consequence to settle in the morning: an as-is dump at `design/system/` is large
(Lamplight's is 376M) and both existing `intent/_inbox/` drops are **untracked**, so
nothing duplicates in git and the vestigial directories clear cleanly. Baize already
gitignores `design/stock/` by size, so there is precedent for how to treat it.

## Clearing the vestigial directories -- AFTER the exports are verified, not before

hv proposed moving the duplicated drops to `~/Downloads/20260730/` to get them out of the
way. Right idea, wrong moment: **do it after each export has landed and been reviewed.**
Until then those directories are the only copies of roughly 600M of agreed design work,
they are untracked, and git is not holding them either. Moving them before the replacement
exists inverts the standing constraint for no gain. They are a `mv` away whenever we want.

The list is narrower than "whatever else is not needed" suggests. Verified 30 Jul:

**SUPERSEDED -- the sweep was done on 31 July. See the 31 July status block at the top of this file.** The list below was wrong in three ways and is kept only as the record: the two `intent/_inbox/` rows were **already gone** by 31 July; `~/Downloads/backup/` was **1.3G rather than 376MB**; and it omitted `baize-design-drops/` (441M), which is the deliberate off-repo home named in Baize's own root `.gitignore` and must **never** be swept.

| Path | Size | 31 Jul outcome |
| ---- | ---- | -------------- |
| `Lamplight/intent/_inbox/lamplight-design-system/` | 376M, 708 files | already gone |
| `Baize/intent/_inbox/baize-design-system/` | 224M, 415 files | already gone |
| `~/Downloads/Baize Design System Refresh.zip` | 219M | parked, harmless |
| `~/Downloads/Baize Design System/` | 87M | parked, harmless |
| `~/Downloads/Lamplight Design System/` | 281M | parked, harmless |

**Do NOT move. All tracked, all live:**

| Path | Why |
| ---- | --- |
| ~~`Baize/docs/design/`~~ | **WRONG, corrected 30 Jul evening. It WAS a stale mirror and Baize has deleted it.** This row said "129 files, tracked, cited by four places -- the promoted design system, not a copy". The checksum says otherwise: **111 of 131 byte-identical to the drop, and all 20 that differed were the OLDER version**, including the three documents the 30 Jul corrections changed at source. Three citations pointed at a directory that never existed. **Tracked-and-cited was read as canonical; only a checksum against the drop distinguishes a stale mirror from a live one.** |
| `Lamplight/design/` | 151 files tracked. Licensed fonts and five product logo sets. Not regenerable. |
| `Baize/design/` | Licensed stock photography, partly gitignored by size. Not regenerable. |

`lit-pool` needs no action: it has never existed locally.

## Four documents written and ready to hand to Claude Design

Written 30 Jul, late, so four CD sessions can run overnight. **None of them is
`cdsync brief` output** -- `brief` refuses a slug the library does not hold, which is
decision 2 biting, and there is no notion of a repackaging round in the tool at all.
Hand-authored, self-contained, one per session.

| Document | Session | Deliverable |
| -------- | ------- | ----------- |
| `port-brief-lamplight.md` | Lamplight | A Cdsync-shaped zip. Repackage only |
| `port-brief-baize.md` | Baize | A Cdsync-shaped zip. Repackage only |
| `extract-brief-gyreandgymble.md` | Gyre and Gymble | **Inventory first**, then package what exists |
| `extract-brief-snorkeltoast.md` | Snorkel Toast | Same, plus confirm what the venture actually is |

The asymmetry is deliberate. Group A can be packaged tonight because the material is
known, agreed, and authored by the supplier. **Group B cannot**, because the
repositories carry no venture facts at all -- `gyreandgymble` says "Coming soon!" and
`snorkeltoast`'s description is the literal string `45h`. Writing a `fixed` list for
either would be inventing the venture, which Acme round one measured at 212 blanks
against 73. So those two briefs ask CD for the facts instead of supplying them, and
explicitly permit stopping after the inventory.

That each brief had to be hand-written is itself a finding: **`cdsync brief` cannot
express a repackaging round, and cannot order a slug the library does not hold.** Both
are real gaps, and the four documents are the evidence for what the fix has to cover.

## 30 July, afternoon -- what actually happened

All four exports landed, were unzipped by hand into `<repo>/design/system/`, and are
now **gitignored** for confidentiality (see `design/.gitignore` in each repo). Full
record in the `cc` board's history at `intent/whiteboard/cc/.history/20260730/wip.md`.

Three documents came out of it, and they are the ones to read:

| Document | What it holds |
| -------- | ------------- |
| `read-gyreandgymble-and-snorkeltoast.md` | Both inventories read and verified against their trees. The evidence that settles findings 5 and 6 and shrinks Decision 2 |
| `first-check-against-a-real-drop.md` | `check` against G&G: `4 blocking, 52 advisory` -> `clean, 35 advisory`. All 21 eliminated findings were tool bugs |
| `~/Downloads/note-for-cd-in-*.md` | The correction notes returned to both CD sessions, self-contained because CD cannot read these repositories |

**The renumbering round trip is the story of the day.** Claude Design allocated ADR / ST
/ WP numbers without knowing either project's high-water marks, because **no brief ever
carried them**. Lamplight collided and was repaired; Baize did not collide at all and a
renumber there would have *created* the collision. Both `vc` audits found something
larger than the numbering underneath -- a reverted ratified decision in Lamplight, a
rejected authorization model still specified as live design in Baize.

**That is a third gap against `cdsync brief`**, alongside the two already recorded: it
cannot express a repackaging round, cannot order a slug the library does not hold, and
**carries no numbering high-water marks**.

## Then, in this order

- [x] **Fix the binary colour scan.** Done 30 Jul, and it grew: five bugs fixed across
      `lib/scan.sh` and `lib/frontmatter.sh`, all of them found only by running against
      material Cdsync did not produce. 163 tests, 0 failures, critic clean. Written up in
      `first-check-against-a-real-drop.md`
- [ ] Whatever Decision 1 and 2 imply for `lib/drop.sh`, `lib/specs.sh` and
      `lib/cmd_brief.sh`, with tests
- [ ] Decide where the generated reading room lands, given `site` does not produce
      one and `import` will not write `docs/`
- [ ] Name a home in the protocol for venture-owned source assets -- fonts, licensed
      stock, logos. They survive today by accident, not by design
- [ ] `cdsync new`-equivalent seeding for four existing repositories: `cdsync.json`
      with `target: design/system`, and `design/system/` created without disturbing
      `design/`
- [ ] Author `fixed` and `open` per project. Lamplight's derives from
      `handoff/venture-source-brief.md`, 164 lines of locked answers, terminology
      and wording rules -- it is close to a ready-made `fixed` list. **Confidential**
- [x] Four briefs, then four CD sessions -- done overnight 29/30 Jul, all four returned
- [ ] **Two conversion briefs, blocked on Decision 2** -- and it is now a three-slug
      question, not a twenty-two-slug one. G&G needs **no conversion** (it arrived
      already in Cdsync shape); snorkeltoast is the real restructure, organised by medium,
      and its brief *is* the taxonomy mapping. Lamplight and Baize wait on their CD
      sessions returning the corrected exports
- [ ] Read Lamplight's and Baize's `INVENTORY.md` -- held through the renumbering, and
      Lamplight's is now the round-two version
- [x] Import, check, and serve each returned zip -- `check` done for G&G and clean

## Watch-outs carried into this thread

- **All four repositories were clean at survey.** Verify that again before the first
  write. It is the whole safety net.
- **`Lamplight/content/` is symlinks into `~/Devel/prj/Wrightings`**, a separate
  2.6G repository. `find` without `-L` reports it as empty. Out of scope, and do not
  let a glob wander into it.
- **`design/fonts/` and `design/stock/` are licensed and not regenerable.** They sit
  outside the chosen target and must stay outside it.
- **Baize has already promoted its design system to `docs/design/`;** Lamplight has
  not, and is still in `intent/_inbox/`. The two are not symmetrical, and a script
  that assumes they are will miss half of Baize or clobber it.
- **`products.json` and both Laksa design systems exist only inside CD.** The
  repositories cannot be the source of truth for Group B.

## 30 July, evening -- steps 1 to 3 complete

Both Claude Design sessions returned corrected exports and both corrected **at source**.
All four drops are installed, current and verified. Everything below is done and committed.

| Step | State |
| ---- | ----- |
| 1. Unzip by hand into `design/system/` | **Done, all four.** Lamplight 707 (round three), Baize 437 (round two), G&G 142, snorkeltoast 200 |
| 2. Read every `INVENTORY.md` | **Done, all four.** Two write-ups: `read-gyreandgymble-and-snorkeltoast.md`, `read-lamplight-and-baize.md` |
| 3. Write the conversion briefs | **Done.** `port-brief-{lamplight,baize,snorkeltoast}.md`, all **unsent** -- transport is hv. G&G needs none |
| 4. Convert, then clear the vestigial paths | Waits on the briefs being sent. **The sweep itself is now unblocked** -- its precondition was "after each export is reviewed" |

**`check` now runs against all four**, and the results are honest rather than flattering:
G&G `17 assets, clean, 32 advisory` exit 0; snorkeltoast and Baize `0 assets checked` exit 2;
Lamplight `4 assets, 4 blocking` exit 1. Written up in `check-against-all-four-drops.md`.

**The spec library went 10 to 17**, which moved G&G's advisories from 35 to 32. Three of the
seven were harvested from G&G's own supplier-written specs rather than invented.

## Dependencies -- no longer blocking

**The three decisions above no longer block this thread.** Decision 2 shrank to a
three-slug question and then to one word: `print-collateral` is now specified
(`specs/print-collateral.md`), declares itself pending admission, and proposes Group 6.
Two projects need it independently.

What remains is **hv transport** (sending the three briefs) and **six hv rulings**, none of
which blocks the others. All six are on the `cc` board with their evidence.

The one unblocked code job is making `cdsync brief` carry numbering high-water marks --
the gap that cost a full export cycle on Lamplight, now hand-patched into three briefs.

ST0001 is unblocked and independent -- Acme round two is assembled and unsent.

## Two cold spikes, and the first full round trip the tool has done (2 August)

**matthewsinclair and geodica** were initialised cold on 1 August, ran in Claude Design, and their
returns were installed, checked and committed on 2 August. This is different in kind from the four
conversions above: those started from an existing tree, **these started from nothing**, so between
them they exercise the cold generator end to end for the first time.

**Both came back Cdsync-shaped**, carrying an identical drop root of `assets brief.md index.md kit
notes RETURN.md`. The cold-start document works. `BOOTSTRAP-CD.md` regenerated from cold-start to
resume on both.

| Project | `cdsync check` | Kit |
| ------- | ------------- | --- |
| matthewsinclair | 14 checked, **15 blocking**, 13 advisory | `tokens.json`, entirely `oklch()` |
| geodica | 7 checked, **clean**, 6 advisory | prose only -- rule 4 cannot run |

**The 15 blocking are all rule 4 and all against `kit/` itself.** Six are real -- `oklch()` values
absent from `tokens.json`, so there is nothing to implement them from. Fourteen are the *Approx hex*
column, one colour spelled twice. One is a colour named in order to **forbid** it. Committed blocking
deliberately: the findings describe what arrived, and Cdsync does not repair a drop.

**Doing this found three bugs in the tool**, none visible by reading -- the two-deep wrapper descent,
`check` dying silently on a kit it could not read, and rule 4 being blind to that kit's colour space.
All fixed, all mutation-proven, suite 314 -> 325.

**Implementation is hv's, in Laksa**, with a handoff note committed at
`../Laksa/HANDOFF-design-systems-20260802.md`. Not this thread.
