# Control Claude (cc) -- archived DONE content, 30 July 2026

Rolled out of the live board at the 30 Jul localfold. Append-only; not reloaded on pickup.

## Carried over from 29 July, completed

- **The loop ran end to end on a real venture.** `Acme` round one imported clean; `import` wrote only the five owned paths, `check` passed every rule on a drop it did not produce. Committed in Acme at `3639f62`; the zip is still in that tree, untracked.
- **Four of `cd`'s eight findings applied** (`fa1baa9`, `b81a865`): currency blanks now counted, the kit inlined in every brief, unmet hard dependencies declared, `brief.md` no longer echoed back. 143/143.
- Pre-build board snapshot at `.history/20260729/wip-prebuild.md`.

## 30 July -- the four exports landed and were installed

- **All four exports unzipped by hand into `<repo>/design/system/`** (~09:15Z). Not `cdsync import`. Counts verified against each archive manifest: Lamplight 705, Baize 416, G&G 142, snorkeltoast 200. Pre-flight on every archive first -- no absolute paths, no `..` traversal, no symlinks, no case-collisions, integrity verified.
- **Lamplight aligned to upstream at 704 files.** `BAIZE-CLOSEOUT.md` was vestigial; hv removed it from the CD project after the export was built, and the CD session removed both `INVENTORY.md` references. Local matched: file deleted, both references removed.
- **Two of the five vestigial paths cleared (~11:30Z).** `Lamplight/intent/_inbox/lamplight-design-system/` (376M, 708 files) and `Baize/intent/_inbox/baize-design-system/` (224M, 415) moved to `~/Downloads/backup/{lamplight,baize}/design/system/20260729/`, original directory names kept. Both were an **earlier failed import pre-dating Cdsync**, not a copy of the export. Fully untracked, so git saw nothing. Still unswept and not asked for: the three `~/Downloads/` items.

## The gitignore decision, made and then reversed

- Morning: hv set `design/system/**` **tracked**, `design/system/_inbox/` ignored.
- **~13:00Z reversed:** `design/system/` gitignored in all four repos via `design/.gitignore` holding `/system/`. The reason is **confidentiality, not size** -- every drop carries material that must not reach a repo that gets pushed and runs CI. Cdsync has no leak guard, so the safe default is that none of it is tracked. Reversible: each drop is reproducible from its zip.
- **Nothing was ever exposed.** Index, staging and full history checked in all four before writing: zero files under `design/system` in any of them, ever.

## The renumbering round trip

- **Both `vc` audits completed.** Lamplight: real collisions, repaired in the delivered copy. Baize: **no collisions at all** -- its ids were already the repo's canon, and applying Lamplight's mapping would have *created* the collision that did not exist.
- **Notes written back to both CD sessions**, self-contained because CD cannot read the repositories: `~/Downloads/note-for-cd-in-{lamplight,baize}.md`, plus `note-for-cd-in-lamplight-addendum.md`.
- **Lamplight's CD re-exported at 14:41 with corrections at source.** The hybrid tree (vc's in-place fixes plus regenerated PDFs) was backed up to `~/Downloads/backup/lamplight/design/system/20260730-vc-corrected/` and replaced. **706 files, verified.** Nothing lost: the only files not carried forward were the transient audit (already backed up) and three ADR filenames the corrections themselves renamed.
- **CD cleared every check the audit predicted would fail.** Class-1 ids all still cited including `ST0333`; the irregular slash-lists (`ADR-0014/0015/0016`, `ADR-0014/15/16/17/18`) converted head **and** tail; zero old-band residue bar one legitimate citation. It also did the half that mattered -- ADR-0013 rewritten with **both superseded versions named in its frontmatter**, ST0336 WP-09 restored with AC-09.6, "Ash policy" back from zero to 14. **No reset needed.**

## G&G and snorkeltoast read

- Both read, verified against their trees, and distilled into `ST0002/read-gyreandgymble-and-snorkeltoast.md`. Every structural claim measured; every apparent delta reconciled to zero.

## `check` against the first real drop Cdsync did not produce

- **`4 blocking, 52 advisory` -> `clean, 35 advisory`.** All 21 eliminated findings were bugs in the tool, not defects in the drop. Five fixed across `lib/scan.sh` and `lib/frontmatter.sh`; written up in `ST0002/first-check-against-a-real-drop.md`. **163 tests, 0 failures** (was 153), shell critic clean.

---

# Second half, 30 July -- rolled out at the 17:02Z localfold

## Both CD sessions returned and both were verified

- **Lamplight round three** (`...-1527.zip`, 707 files). Pre-flight and integrity clean. The count went 706 -> 707 and the extra file is our own addendum note coming back in `uploads/`, so **every correction was a content change inside an existing file** -- a name-level diff would have verified nothing. Five files differed. Every addendum ask checked individually: ADR-range typo fixed at source in both places; the three held questions still open and flagged in three places each with a *"do not answer it here by accident"* guard; ST0337 WP-06 and `acceptance.md` AC-06 both still marked pending. **CD could not regenerate `wrighter-frontdesk/img/05-page.png`** -- cached render, four selectors, screen and print -- and left the 28 July image rather than shipping a wrong one, reaching *stale beats plausible-but-wrong* on its own. Two self-initiated corrections it was not asked for: the WP count (ST0334–ST0337, 28 files; the old 27 was verified wrong on disk) and the ADR table recording ADR-0013's supersession. Installed by **replace**, old tree backed up to `~/Downloads/backup/lamplight/design/system/20260730-round-two/`, with `design/system/.gitignore` preserved through the swap because it is dormant-but-load-bearing if the gitignore decision is ever reversed.
- **Baize round two** (`...-1629.zip`, 437 files), extracted by hv as an **overlay** and verified here: 443 installed = 437 + 4 `.DS_Store` + `.gitignore` + one hand-placed PDF, zero missing, zero orphans. Its receipt is `handoff/CORRECTIONS-2026-07-30.md`, 213 lines, ten corrections **at source**, including a rejected delivery model swept across 29 dependent sites in ten files.

## The sixth bug, and the first to reach the verdict

- **`check` reported `0 assets checked -- clean`, exit 0**, on two drops that are not drops. `drop_looks_valid` was wired in all along and proves only that `assets/` *exists*. Fixed at the verdict rather than the entry: `count == 0` is now exit 2. Three tests. **166 tests, 0 failures.** Written up in `ST0002/check-against-all-four-drops.md`.
- Gyre & Gymble was unaffected and re-ran unchanged at 17 assets, clean.

## Both remaining inventories read

- Distilled into `ST0002/read-lamplight-and-baize.md`. The shared eleven-path skeleton is real; **the claim that it made ST0002 one conversion three times was not**, and the correction is recorded there rather than quietly dropped.

## Three conversion briefs

- `port-brief-{lamplight,baize,snorkeltoast}.md`. Lamplight's and Baize's **revised, not rewritten**; snorkeltoast's written new. All three gained the `assets/` collision and numbering high-water marks. G&G deliberately got none.

## The spec library, 10 -> 17

- All seven of snorkeltoast's missing slugs written; three harvested from G&G's supplier-written specs rather than invented. **G&G's advisories fell 35 -> 32.** One test's exemplar moved from `grid-and-layout` (now specified) to `pattern-library`, with a comment explaining how to choose the next one.

## Four commits

`2913af0` the sixth bug · `88ecb54` the three briefs · `f060087` the seven specs · plus `cc7a04a` from the morning fold. **All four unpushed at the fold** -- both remotes still at `b5dac7c`.

---

# Third part, 30 July -- rolled out at the 17:58Z localfold

Two hv notes arrived after the 17:02Z fold and between them they reversed a Decision made
that morning and established the project's canon.

## The repo-setup note, and the reversal

- **The drop is TRACKED IN FULL**, venture trees included. The confidentiality argument that
  gitignored it was sound in the abstract and wrong in practice -- the repository is read
  only by authorised people, and the in/out bookkeeping it demanded is what produced Baize's
  duplicated `docs/design/` mirror. One exclusion remains, `/system/_inbox/`, and it is a
  **platform limit** (GitHub refuses files over 100MB), which has to be said in the comment
  or it gets re-litigated as confidentiality.
- **Classification replaces the leak-guard argument:** `public` / `internal` / `confidential`,
  an axis of its own. **This is also the answer to finding 6** -- `audience` was three fields
  wearing one name. Carried as its own field, and put in the `spec.md` **example** in all
  three briefs rather than only described near it, because these briefs already record a
  round lost to a supplier reproducing an example verbatim.
- **`addenda/` declared protected** in `lib/drop.sh` as `CDSYNC_DROP_PROTECTED_DIRS`, with two
  tests. **The note's ask was already satisfied** -- `import` writes five owned paths and
  leaves everything else standing. What destroyed Baize's addenda was the hand-unzip replace.
  The real gap is that there is **no safe as-is install**: import protects addenda and
  discards the dump, a replace preserves the dump and destroys addenda, and there is no third.

## The correction that ran all day, in four places

- **`Baize/docs/design/` WAS vestigial.** The board, `tasks.md` and both restart files said
  the opposite -- "129 tracked files, the promoted design system, do not move". Baize
  checksummed it: **111 of 131 byte-identical to the drop, and every one of the 20 that
  differed was the OLDER version**, including the three documents the corrections had just
  changed at source. Three citations pointed at a directory that never existed. **The error
  was reading tracked-and-cited as canonical.** A stale mirror looks exactly like a current
  one; only a checksum against the drop separates them, and it was never run.

## The canon

- **`intent/docs/design-system-lifecycle.md`.** `design/system/` is the **output of Claude
  Design, managed in and out by Cdsync, and it is specification -- not running code**. The
  whole deliverable is stored and tracked; **the app never reads from it**. The running
  design system is **built separately here** from that tree as requirements. It is tracked so
  the implementation can be diffed against the spec. It is an **end-state view**, so a gap
  between it and the app is expected and never a defect. It changes only through an iteration
  with CD mediated by Cdsync.
- **Confirming it exposed two of my own contradictions.** The briefs' "what stays out" table
  read as licence to delete -- a brief may scope what is *converted*, never what is *stored*.
  And the `docs/site/` exclusion gave a wrong reason: import discards what is in the **zip**
  and unowned, not what is in the target, so an installed microsite survives untouched.
- **It settles the install question with an inversion worth remembering.** An as-is drop *is*
  the whole tree, so it is installed by replace. A converted drop is a **subset**, so it must
  be installed with `import` and never by replace -- replacing would destroy the venture set,
  the microsite and the prototypes.

## Three more commits

`8670283` the protocol · `5dbc950` the canon · and this fold. **168 tests.**

---

# Fourth part, 30 July -- rolled out at the end-of-day globalfold

The session after the third localfold built the second install path, answered hv's question about what to tell eight recipients, and took three rulings.

## The safe as-is install, built

- **`cdsync install` exists.** Three commits: `d0b9cc6` pre-flight, `c91ff1d` the command, `007dbf8` the declaration's reader. **168 -> 197 tests.**
- **Pre-flight was a hand ritual the tool did not perform.** Four exports were checked by hand on 30 July -- absolute paths, `..` traversal, symlinks, case-collisions, integrity -- while `stage_drop` called `unzip -q` straight at the archive. `lib/archive.sh` now owns pre-flight AND staging in one pair, so a drop cannot be staged without being pre-flighted.
- **Three defects the fixtures found rather than the design.** An empty archive was refused for failing a CRC check, when it fails the index listing -- a refusal with the wrong reason sends someone re-downloading a file that arrived intact. Empty and unreadable were merged into one refusal deliberately, because separating them means matching the literal string "Empty zipfile." and a verdict turning on an unzip build's wording is the same environment-decides-the-answer trap as the currency matcher. And the offender list truncating at five SIGPIPEd the grep behind it, so `pipefail` reported 141 and `set -e` aborted the refusal before its return -- visible only past the fifth offender, so never on a one-entry fixture.
- **No backup directory, and that is the design.** The tree is tracked in full, so git holds every prior state; the job is to prove that copy is complete, not to make another. Hence the refusal over uncommitted or untracked content. The hand process's 376MB in `~/Downloads/backup/` is the clutter the sweep exists to clear.
- **Two survival rules kept distinct in the output** so neither is re-litigated as the other: `addenda/` because it is repo-authored and declared, anything gitignored because git cannot restore what it never tracked. `_inbox/` is the live second case -- replacing over it destroys the only copy of the thing being installed.
- **`CDSYNC_DROP_PROTECTED_DIRS` had no reader for a day.** `import` protected addenda only because its owned list happened not to name it. `drop_path_is_protected` is now THE reader and `drop_guard_contract` refuses to write while a name is declared both owned and protected.
- **Building the install exposed a silent discard in it.** A drop carrying `addenda/` was copied in and then blown away by the restore, saying nothing -- and with no addenda in the target there was nothing to hold aside, so the drop's copy survived. The same archive installing differently in two repositories depending on prior state. A protected path now never arrives from a drop either way.

## Two honesty fixes, both found by running against a real drop

- **`describe_target` collapsed three states into two and lied.** Run against Lamplight from here it announced that a tree with 708 tracked files "does not version with the project". It now names the other repository. This one matters beyond tidiness: the canon rests on the drop being tracked, so telling someone their tracked drop is unversioned contradicts the one thing they must believe.
- **A missing `spec.md` was reported as a broken asset** in drops with no manifest to say whether it was an asset at all. Lamplight's `assets/` holds media directories, so four walked as assets and the report read "4 blocking". Fixed by wording, not by redesigning asset detection.

## What to tell eight recipients

- **Two standing documents rather than eight notes.** `intent/docs/claude-design-contract.md` and `intent/docs/receiving-a-design-system.md`, both self-contained. `ST0002/dispatch.md` says who gets what.
- **Writing the dispatch corrected the board on Lamplight**, in the opposite direction to the morning's error. The board said Lamplight, G&G and snorkeltoast all still carried the old exclusion. Measured: **Lamplight is converted and the most thorough of the four**; Baize tracks 442 but has no `design/.gitignore` at all; **G&G and snorkeltoast track zero**.

## Three rulings, recorded at source

- **`print-collateral` admitted as taxonomy 52**, Group 6. Out of sequence deliberately -- slotting it at 42 would renumber ten published identifiers, which is the mistake that cost the Lamplight export cycle.
- **`venture/` stays out of round one.** Both briefs said "hv's call" and now say RULED -- recording it only on the board would have left two documents about to be SENT still posing the question.
- **`check` will not cross-reference `index.md`.**

## The numbering scan, and the bug inside the fix for itself

- **`cdsync brief` now carries high-water marks** (`a4c0c6f`), the gap that let CD allocate ids blind. Both the project and the drop are scanned, because Lamplight's own series ended at ADR-0007 while the drop held ADR-0008 to ADR-0020.
- **The first version reproduced the exact bug it exists to prevent.** It matched `ADR-[0-9]+` and reported Baize as having NO ADRs -- confidently, in a table headed *"so you never have to infer it"*. Baize has 33, named `adr0001-...` where Lamplight writes `ADR-0003 ...`. Caught only by running it against both real projects rather than the one it was written against. Verified after: Lamplight ADR 0020 -> 0021 and ST 0341 -> 0342, both exactly matching the hand-verified table.

## Ten commits

`d0b9cc6` `c91ff1d` `007dbf8` `832e365` `3ac0c04` `834b11c` `2088d6b` `a4c0c6f` plus this fold. **205 tests, 0 failures.** All unpushed; both remotes still at `b5dac7c`.
