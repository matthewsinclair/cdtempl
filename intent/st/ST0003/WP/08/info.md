---
verblock: "08 Aug 2026:v0.4: matts - Re-measured; Downloads closed, repackaging round built, second brief gap found blocked"
wp_id: WP-08
title: "Housekeeping and small gaps"
scope: Small
status: WIP
---

# WP-08: Housekeeping and small gaps

## Objective

The small things that are individually not worth a work package and collectively worth one. Each is independent; none blocks anything.

**8 August: the list was re-measured against the world before anything was actioned, and three of its six items had drifted** -- one had been silently done, one had been done and undone itself, and one had quietly gone further than anyone intended. **A housekeeping list is exactly the kind of document that rots**, because nothing depends on it and so nothing catches it. **Measure this list before working from it, every time.**

## The list

### Baize's `BOOTSTRAP-CD.md` is genuinely stale

Steel-thread high-water 23 against a tree at 24. **Not noise** -- the other projects regenerate byte-identical, so this one is a real difference. It was regenerated and deliberately left uncommitted, because that repository carries hv's own uncommitted work and committing over it was not mine to do.

**8 August, and both halves of that sentence have stopped being true.**

**It was committed, and not deliberately.** It is in `4960f27` (6 Aug), a commit titled *"docs: the design-system tool is now called Cdsync"*. **The rename swept it up.** That is the *explicit file list is not an explicit pathspec* failure the board already records against this repository, happening a second time in another one -- and this time nothing caught it, because there was no occurrence count to reconcile against.

**And it is stale again already.** It states steel-thread high-water `0024`, next free `0025`; Baize's tree now holds **ST0025**, so the next free is `0026`. The regeneration fixed 23 against 24 and the tree walked past it.

**That is the whole argument for the item below**, and it is now a stronger one than when it was written: the objection to an advisory staleness rule was that a hand-regeneration fixes the problem. **It does not. It fixes the problem once, and the tree keeps moving.**

**9 August: ruled and done.** hv ruled that a stale document is never accepted -- regenerate. Regenerated against the live tree and committed in Baize as `7211fc1`, via explicit pathspec with hv's uncommitted `mix.lock` left untouched. The regeneration caught what the 8 August measurement had not: **the ADR series had drifted too**, recorded 0030 against a tree at 0035 -- a second series moving on a list whose whole lesson is that lists rot. Whether staleness becomes *detectable* is the rule item below.

### Two gaps in `cdsync brief`

Both recorded against `brief` and neither addressed:

- **It cannot express a repackaging round** -- a round whose job is to reshape what already exists rather than build something new.
- **It cannot order a slug the library does not hold.** Correct as a refusal, but it means a genuinely new asset type cannot be ordered at all until WP-03 writes its spec, which is a chicken-and-egg for anything novel.

**8 August: the second one is BLOCKED, and this WP said the whole package depended on nothing.** That was written before anyone traced it.

Follow the chain and it ends on a ruling that has not been made:

1. Order a slug the library has no spec for.
2. The brief must still carry everything the round needs, so it carries the `spec.md` contract -- which `brief_spec_contract` already emits, so far so good.
3. That contract requires `spec_version: <n>`, described in the brief as *"copied from the specification below"*.
4. **For a new asset there is no specification below.** So what does the round stamp?
5. **That is WP-05 section 2, word for word** -- and four ventures have now asked it, with matthewsinclair's thirteen assets sitting at `spec_version: unassigned` because the supplier correctly refused to invent one.

**So building this would mean choosing WP-05's answer by implementing it**, which is the one thing this thread says not to do. The refusal stays until WP-05 rules.

**9 August: WP-05 ruled, and the gap closed the same day.** A named in-taxonomy slug now orders ahead of the library -- the brief carries the contract its specification cannot, the asset stamps the literal `unassigned`, and rule 2 asks for a rebuild the day the library gains the entry. Outside the taxonomy still refuses, because the taxonomy is the identity space. The build is WP-05's; this item just stopped being blocked by it.

**The first gap is genuinely unblocked** -- a repackaging round reshapes assets that already exist, so every one of them already has a spec and a `spec_version`, and step 4 never arises. **It is now closed.**

`cdsync.json` takes an optional **`round_job`**: free text, one line, what this round is *for*. Free text rather than an enum, matching `effort` and `inherits_from`, **because nobody ordered a vocabulary of round types and inventing one would be the tool deciding what kinds of round exist.**

Beside it the brief now states, **measured rather than declared, which ordered assets are already in the target.** Two different kinds of fact, and the distinction is the design:

- **A round's purpose is not derivable from the tree.** Repackage, revise, extend and correct are four different jobs with one filesystem signature.
- **What is already present is not worth asking the venture to declare**, because the tool can see it -- `brief_prerequisites` has tested that same path all along and simply never said so.

**The second half earns its place in every round, not just a repackaging one.** A supplier who orders a slug that already exists and is not told will build it from scratch, and **what it delivers replaces what is there** -- so the rebuild silently discards whatever the existing asset carried, with neither side seeing it happen.

**What was done instead, because it was in the refusal message this item is about:** the message told users *"the taxonomy names fifty-one assets"* and the taxonomy names 52. The figure was hand-written in four places across `lib/` and `help/` and disagreed **three ways** -- fifty-one, fifty-two, and fifty in a test comment. It is computed from the manifest now, by one function with two callers, and no count is written out in `lib/` or `help/`. **A count restated in prose drifts from the table it describes**, which is on the watch-out list by name.

**COPIES SURVIVE, AND THEY ARE THE ONES THAT TRAVEL.** Named rather than counted, because counting them is what went wrong twice:

| File | How it travels |
| ---- | -------------- |
| `specs/kit.md:72` | Ships in the tarball, and **the kit spec is inlined into every brief whether or not the kit was ordered** |
| `templates/claude_design/templprj/kit/kit.md:9,11` | Scaffolded into every venture `cdsync new` creates |
| `templates/claude_design/templprj/brief.md:15` | Same, and it says it twice in one sentence |

**None is fixed here.** Library text cannot move piecemeal -- changing it changes what its `spec_library_version` means -- so the known inconsistencies go together behind one bump. **WP-03 owns them.**

**How this was missed, and then missed again.** The sweep that found the four in `lib/` and `help/` searched `bin/`, `lib/` and `help/`, and **nothing asked what had chosen those three directories** -- the sampling-frame error the board already names, committed inside the fix for the drift hazard it also names. The first correction then announced *"a fifth copy survives"*, which was also wrong, because it counted instead of sweeping. **A count of wrong counts is still a count.** The sweep that finally worked ran over every tracked file and named the results.

### Should a stale generated document be detectable?

An advisory rule comparing `BOOTSTRAP-CD.md`'s mtime against the newest file in the tree.

**Every instance, with its detail -- this is the only place that now carries it**, because the board was holding a hand-maintained count of exactly the kind it warns against, and that count was the thing drifting:

| When | Copy | What was stale | Now |
| ---- | ---- | -------------- | --- |
| -- | Baize | Steel-thread high-water 23 against a tree at 24 | **Regenerated, then stale again at `0024` against ST0025** |
| -- | All four at once | A generator change staled every copy **with no local symptom at all** -- they were regenerated only because the board said to | Regenerated |
| 6 Aug | Gyre & Gymble | Inventory missing `business/`, and it embedded a **superseded revision of its own addendum** | Fixed 6 Aug |
| 6 Aug | snorkeltoast | `docs/` 92 against 93, `email/` 3 against 7, **one whole section absent** | **Not fixed** -- a live session was in that tree |
| 8 Aug | Baize | High-water `0024`, tree at ST0025 | **Open** |

**Two copies are stale right now: snorkeltoast's and Baize's.** The first was left because another session held the tree; the second because a hand-fix does not survive the tree moving.

Cheap to build. **Still not built, because it is unasked scope**, and this project has a standing preference for not inventing rules nobody ordered. **It should be ordered or declined rather than carried a sixth time.**

**One design constraint, found by testing the proposal against the case above rather than assuming it.** *"The newest file in the tree"* is the wrong reach, and it fails in the dangerous direction:

- Baize's `BOOTSTRAP-CD.md` is 6 Aug 09:46. **It is the newest file in `design/system/`** -- tied with `index.md` and `RETURN.md`, which the same sync wrote.
- What staled it is `intent/st/ST0025`, 7 Aug 17:38, **outside that tree entirely.**
- **So a rule scoped to the design tree reports CLEAN on a document that is provably stale.** Scoped to the repository, it flags it by 1.3 days.

The generator already reads outside the design tree -- the numbering scan roots on the target's *repository*, pinned by a test (`test/cdsync.bats:3983`). **The check's reach has to match the generator's reach**, or it is another instrument that cannot see the thing it is looking for. **A rule's published reach is part of the rule**, and this one has two candidate reaches that disagree on the only case anyone has tested.

### Intent's template bakes an absolute path

`[[INTENT_HOME]]` is substituted into `.claude/settings.json` at install time, so every project built from the template carries an absolute path to one machine. **Cdsync's is fixed** and a test guards it. **Baize's and Lamplight's still carry theirs.** Upstream issue, worth reporting to Intent rather than patching per project forever.

**Re-measured 8 August and unchanged:** Cdsync 0, Baize 2, Lamplight 2. **This item stands exactly as written**, which is worth saying out loud on a list where three neighbours had drifted.

**9 August: reported upstream on hv's instruction -- Intent issue `0016`** (`intent/issues/OPEN/0016/` in the Intent repository), carrying the measurement, the root cause (`lib/templates/.claude/settings.json:9,21` substituted at install time), and a runtime-resolution fix proposed. Baize's and Lamplight's copies stay as they are until Intent ships it; no per-project patching.

### Downloads housekeeping

All optional and **none of it vestigial** -- this is the 31 July consolidation, not junk. **8 August: every one of these is now absent from `~/Downloads`, including the one that was to stay.**

| Directory | Size | 8 Aug |
| --------- | ---- | ----- |
| `claude-design-superseded-rounds-202607/` | 1.3G | Gone |
| `lamplight-design-drops/` | 1.1G | Gone |
| `Lamplight Design System/` | 281M | Gone |
| `baize-repo-snapshots-202606-202607/` | 233M | Gone |
| **`baize-design-drops/`** | **441M** | **Gone, and it was to STAY** |

**Escalated to hv on 8 August and ruled the same day: all five were cleared deliberately, `baize-design-drops/` included. This item is DONE.**

**The instruction that it stays is withdrawn, and is deleted rather than softened wherever it appeared** -- on the board and here. It was written on 31 July when that directory was the off-repo home for two delivery zips (219MB + 222MB), and it outlived the reason for it. **A standing "do not delete" left lying around after its owner has deleted the thing is worse than no note at all**: the next reader finds an instruction contradicted by the world and cannot tell which one is stale.

For the record of what went, since nothing else now holds it: Baize's own whiteboard history (`intent/whiteboard/vc/.history/20260730/wip.md:30`) records that the zips moved there when `design/.gitignore` was deleted, that the current generation was proved redundant first -- **all 437 files already tracked** -- and that the superseded 09:49 generation was kept because git never held it. **That superseded generation is the only thing that was unique, and it is gone by decision.**

Correction while here: the board called that directory *"the off-repo home named in Baize's own root `.gitignore`"*. The `.gitignore` carries the residual-risk narrative; **the path itself was named only in that whiteboard history.** Two documents, one slightly wrong, exactly as the standing watch-out predicts.

**Six spent `_inbox/` directories, and the count reconciles exactly** -- Baize, Lamplight, gyreandgymble, geodica, snorkeltoast, matthewsinclair, one apiece under `design/system/`. All gitignored and local-only, and the two newest hold the Laksa theme packs, **which exist nowhere else** -- do not clear those two until Laksa has taken them.

### The whiteboard roster

`intent/whiteboard/README.md` is still deferred. **No `hv` node here, by hv's ruling -- `cc` is the whole roster in Cdsync for now**, so the roster document has had nothing to say.

## Deliverables

Each item either done, or explicitly declined with a reason. **An item declined on the record is finished; an item that quietly stays on a list forever is not.**

Where the six stand after the 8 August re-measurement:

| Item | State |
| ---- | ----- |
| Baize's `BOOTSTRAP-CD.md` | **Done 9 Aug.** hv ruled stale is never accepted; regenerated and committed in Baize (`7211fc1`), which also caught the ADR series at 0035 against a recorded 0030 |
| Two gaps in `cdsync brief` | **Both DONE.** Repackaging round 8 Aug (`round_job` plus the measured already-present list); ordering an unspecified slug 9 Aug, with WP-05's `unassigned` ruling |
| Stale-document rule | **Reach ruled 9 Aug** -- repository-scoped, because clean-on-stale is the wrong answer. Whether the rule is built awaits hv's word |
| Intent's absolute path | **Done 9 Aug.** Reported upstream as Intent issue `0016` |
| Downloads | **Done.** All five cleared by hv deliberately; the "stays" instruction is withdrawn |
| Whiteboard roster | Deliberately deferred, and still correctly so |

## Dependencies

None -- the one thing left waiting on hv is whether the stale-document rule is built. The roster item stays deliberately deferred.
