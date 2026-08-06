---
verblock: "02 Aug 2026:v1.0: Matthew Sinclair - Archived from the cc board at the 1 August localfold"
---

# Control Claude (cc) -- 1 August 2026, archived

The day's completed work, moved off the live board so it stays readable. Nothing here is outstanding.

## DOING -- nothing is in flight

**v1 is closed out and public-ready (1 August). 313 tests, 0 failures. Shellcheck silent at default severity** across `bin/`, `lib/` and `.claude/scripts/`. **CI green on ubuntu-latest and macos-latest.** Everything is pushed and `main` tracks `upstream/main`. Do not go looking for half-finished work.

### The second half of the day: CI, release, licence, and going public

**`cdsync release`** versions, tags and packages. Pushing is opt-in, the tarball is built by `git archive` **from the tag** rather than the working tree, and what it may not carry lives in `.gitattributes` -- data read by the tool doing the work, not a second list. Nothing has been released: `VERSION` is `0.1.0` and a clean-tree dry run passes every gate.

**CI runs bats and shellcheck on both platforms**, and caught two bugs no local run could:

- **GitHub runs `shell: bash -e`**, where `out="$(cmd)"` exits the script the moment cmd returns non-zero. So the hygiene check's NO-MATCH case -- the one it exists to find -- killed the run silently: exit 1, no output. **I had tested that script with plain `bash`.**
- **macOS runners use bash 3.2, whose `-nt` compares whole seconds.** Two archives dropped into `_inbox/` in the same second tied, and `install` kept the alphabetically first -- in the command that **replaces the whole tree**. Ubuntu and a brewed bash resolve nanoseconds and passed. It now refuses and names both.

**The locale residual bit exactly where it was written down.** `LC_ALL` overrides `LC_COLLATE`, so the dispatcher's export did not survive a runner that sets it. **An environment variable was the wrong place for determinism** -- the inventory now sorts itself. And the test asserted through `LC_COLLATE`, which the dispatcher already handled, so it could never have caught this.

**Public-readiness came out clean.** No keys, credentials, tokens, IPs or hostnames anywhere in 113 commits -- checked across all history, because making a repository public exposes the whole of it. The one finding was three absolute paths to a local Intent install in `.claude/`, which is two bugs at once: it publishes the author's layout and it does not work on anyone else's machine. **Intent's own template bakes them in at install time, so Baize and Lamplight carry the same three.** Fixed here by pointing at the copies the repository already carried, and guarded by a test whose first version failed on its own positive control.

**hv ruled the venture names are not sensitive**, so no scrubbing was done and none is needed.

### The day in one line: everything real was found by running the tool for a live purpose, not by reading it

Rule 5 and the `help/check.md` count came out of reading. **Every one of the four bugs after that came out of generating a document for a round hv was about to send**, and each was invisible from the code alone.

| Found | What it was | How it surfaced |
| ----- | ----------- | --------------- |
| `cdsync init` missing | `bootstrap` refused over an absent tree and advised `cdsync new`, which would `git init` a second repo inside the project and write three files the canon forbids there | Trying to do the thing for a real site |
| Cold read as warm | `new`/`init` create the skeleton, `bootstrap_state` counted any top-level entry, so **every scaffolded tree measured warm and the cold document was unreachable through any sequence of the tool's own commands** | Reading the generated document |
| Cold given the as-is contract | The shape probe asks "does the tree hold an asset with a `spec.md`" -- no, on an empty tree -- so a cold start was told **"this document is not asking you to adopt"** the shape `check` then requires | Reading the generated document again, after the first fix |
| Document depended on locale | `for entry in "$target"/*` orders by collation, so the same tree yielded different documents under C and UTF-8, and all four projects reported stale against a no-op regeneration | Regenerating to check staleness |

**A tool giving the only advice it has, and that advice being wrong, is the tell for a missing command rather than a missing flag.**

### The tests were the weak link twice, in the same way

`init leaves a tree bootstrap accepts` asserted the document had been **written**, not what it **said** -- so it passed over "the design system already exists, do not start it again" across three empty directories. `bootstrap over an empty target reports a cold start` passed throughout because it used a **bare** empty directory rather than a scaffolded one, and the gap between those two is exactly where the bug lived.

**What a generated document SAYS is the product. That it exists is not the claim worth pinning.**

### Guards added, because fixing each once is not the point

- The front-page command table must list every command the dispatcher accepts. The old guard checked a help **file** existed, which `init` had, so it passed while the table was wrong.
- Every flag a command implements must be documented in its help file.
- The README's rule table must match `help/check.md`, which is its source.
- The bootstrap inventory must be ordered by bytes, not by locale.

### Shellcheck was never clean, and this board said it was

Eight findings, all pre-dating the day: two genuinely dead locals (`known`, `line`), one locale-exposed `tr`, five false positives. **The claim survived because the probe was `shellcheck ... | tail -5; echo $?`, which reports `tail`'s exit code and is therefore 0 whatever shellcheck found.**

### Also shipped

**`README.md`**, which did not exist. **`cdsync init`**, with the repo-owned `_inbox` guard now written by both `init` and `new` -- all four ported projects carried that file by hand, which is the definition of a rule that eventually gets missed, and what it stops being committed is a 600MB archive.

**matthewsinclair and geodica are initialised, cold, and committed** (`409d823`, `7b0a4cc`). Their trees match the house pattern byte for byte.

**Shellcheck was never clean, and the board said it was.** Eight findings, all pre-dating today: two genuinely dead locals (`known`, `line`), one locale-exposed `tr`, and five false positives. **The claim survived because the probe was `shellcheck ... | tail -5; echo $?`, which reports `tail`'s exit code and therefore always 0.** Run the command bare when its exit code is the thing being asked about.

**Rule 5, as shipped.** The N/M demand lived in exactly one place, `lib/cmd_check.sh`, and in **no document at all** -- while `cmd_brief.sh` asks suppliers for `coverage: <what is covered, when status is partial>`. **The check was rejecting what the document asked for.** It is now gated on `status == complete`, where prose genuinely cannot be measured against a claim of totality, and reworded to report what it cannot see rather than a format. It touches no generator, so **no `BOOTSTRAP-CD.md` went stale.**

Both predictions hit exactly, measured before and after against the real trees: **Lamplight 8 -> 5, G&G 27 -> 21.** The single surviving rule-5 finding is `Lamplight/portraits`, the one asset claiming `complete` -- the half with teeth landing on the right target.

## TODO -- in this order

0. **Scope for matthewsinclair and geodica -- and they are ALREADY RUNNING**, so this is about the next round rather than this one. `BOOTSTRAP-CD.md` gives Claude Design the shape and the rules but **not which assets to build**, and on a 52-slug taxonomy that invites sprawl on two simple content sites. hv supplied scope by hand this round. Scope properly comes from `cdsync brief`, which needs a `cdsync.json` **that cannot live in the site** by canon -- so where it lives is the open question, and it is the same question as ST0001's `Acme/cdsync.json`.
1. **Baize's `BOOTSTRAP-CD.md` is genuinely stale** -- its steel-thread high-water reads 23 against a tree at 24. Not generator noise; the other three regenerate byte-identical. **Left alone deliberately: Baize's repo carries hv's uncommitted work** (`.tool-versions`, `apps/rack/mix.exs`, `bin/baize_check`, `bin/baize_help`, `intent/todo.md`).
2. **Round four**, and it may be superseded. The three shipped fixes are **hypotheses until a round tests them**, but the two new spikes exercise the cold-start generator on fresh trees, which is the stronger test of the same claim -- and it has already paid, having produced four bugs in a day. **Wants hv:** run round four, fold it into the spikes, or drop it.
2. **The remaining rulings** in `## Wants hv`, now nine rather than eight -- rule 5 is off the list and **rule 3 is on it**.
3. **25 of 52 taxonomy slugs have no spec.** **`pattern-library` is blocked, not merely queued** -- see below.
4. **ST0001:** fill `Acme/cdsync.json`, re-order the same four slugs.

### `pattern-library` is blocked by the do-not-edit-library-text ruling

It looked like the obvious next spec and it is not available. `specs/library.md:226` names it *by name* as the live exemplar of "real, in the taxonomy, and unwritten", and `test/cdsync.bats:618` pins the same invariant with the same slug -- with a comment saying the exemplar already moved once, off `grid-and-layout`. **Writing the spec makes that library sentence false**, and repairing it is a library-text edit, which silently changes what `spec_version` means. It is also implicated in **no finding on any of the four trees** -- verified, not assumed.

**So it needs a ruling, not an afternoon.** Either the exemplar moves first (to a slug some written spec actually depends on and that is itself unwritten), or the library text is edited with an explicit version bump.

### Round four's falsifiable numbers, restated off the post-rule-5 baseline

**The old numbers were measured before rule 5 changed and are void.** Running a round against them would measure a code change and a supplier change at once and could attribute neither -- two unrelated counters colliding, read as agreement, which is already on the list below.

| Measure | Was | Now, post rule 5 | Expected back |
| ------- | --- | ---------------- | ------------- |
| G&G rule-2 | 3 | **3** | **0** -- two rebuild against spec 2, `kit` copies the 3 the document now states |
| G&G rule-6 | 11 | **11** | **0** -- the de-conflation instruction exists now |
| G&G rule-3 | 7 | **7** | **7 -- it cannot move.** See the ruling below |
| G&G total | 27 | **21** | **7**, and the 7 are rule 3 |
| Lamplight total | 8 | **5** | **5.** Its 4 rule-2 are "no entry in the spec library" -- bespoke slugs outside the taxonomy, which no round clears |

**"G&G below 20" is retired as a prediction.** It was satisfied by the rule 5 change alone, before any round ran, which makes it unfalsifiable rather than generous.

**And the other three cannot be measured this way at all.** Only Lamplight and G&G are walkable. **Baize and snorkeltoast return `error 0 assets checked`** -- their `assets/` holds no slug directories, and the tool says outright that zero checked is a failure rather than a clean bill. For those two the only signal is **stamps staying absent**, and it must be read, not checked.

### Two restart-doc items that are already done

The `check` rule for `classification` was **built** and carries six tests -- 2026 was the round it waited for. And the **vestigial sweep completed on 31 July**: nothing deleted, 2607 files consolidated after 2287 were proved recoverable from the projects' own git object databases.

**637MB of spent transport is what today actually made vestigial** -- the four installed archives still in `_inbox/`. Lamplight's and Baize's have an off-repo home (`~/Downloads/*-design-drops/`); G&G and snorkeltoast have none. Wants hv.

### Integration is unblocked, and independent of round four

hv can start the projects building against their design systems. **Today is the first day that is true**, because `index.md` landed in all four and two of them had no manifest before it. G&G unreservedly -- Cdsync-shaped, `kit/tokens.json`, **zero blocking findings**. The other three integrate by reading, not by checking: their tokens sit at `handoff/assets/tokens.css` or `styles.css`, so `check` refuses and rule 4 cannot run at all. **Cdsync has no application-side check, by design**, so nothing reports drift once integration is live. Hold Lamplight's `ref` -- the only open ruling that could move paths. Everything else outstanding is metadata, which application code does not consume.

