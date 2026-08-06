---
node: cc
name: Control Claude
role: control
session_id: dc81d7ec-8e40-4353-8410-71d6499122ed
heartbeat_at: 2026-08-06T11:29Z
status: active
focus: "0.1.0 RELEASED and the repo is PUBLIC. ST0003 WIP, WP-01 closed 8/8; WP-07 and WP-08 unblocked and next. 335 tests, CI green all three jobs, all remotes at ahead=0. Localfolded for a compact -- session continues after the bounce"
claims: [ST0003]
---

# Control Claude (cc)

Completed narrative is archived per day at `.history/`; 6 August is the most recent. **This board is live state plus the two standing lists below, and nothing else.**

**Read `intent/docs/design-system-lifecycle.md` first. It is canon and outranks everything here.** Then `intent/restart.md`.

## Where things stand

**ST0003 is in flight, 1 of 8 work packages done.** ST0001 (16/16), ST0002 (12/12), ST0004 (11/11) and ST0003/WP-01 (8/8) all closed through the gate.

**0.1.0 is released and the repository is PUBLIC.** Tag `v0.1.0`, GitHub release published, the published asset downloaded and run to verify it. Published from a single root commit; the 135-commit history is retained privately on the mirror's `archive/pre-public-20260806` and in a bundle beside it.

**Next, both unblocked: WP-07 (integrate the original four, holding Lamplight's `ref`) and WP-08 (housekeeping).** Resuming after a compact, at hv's direction.

**The 6 August globalfold collapsed the live docs to one home per thing.** The rulings had been restated in four documents and the watch-outs in three -- the drift hazard this board keeps naming, committed by this board's own siblings. **`## Watch-outs` and `## Decisions` below are now the only copies.** `intent/wip.md` and `intent/restart.md` point here and do not restate.

## TODO

**All of it lives in ST0003, "Post-release 0.1.0 clean-up"** -- `intent/st/ST0003/`, eight work packages, each with its own `info.md` stating what blocks it. **The ordering is in `intent/restart.md`.** This board carries no second copy.

**Done:** WP-01, cut the release. **Unblocked:** WP-07 integrate the original four, WP-08 housekeeping.

## Wants hv

**Every ruling is held in ST0003 with its evidence** -- WP-02 (the two rule-4 rulings), WP-05 (`cdsync.json`'s home, `spec_version` for a new asset), WP-06 (round three's seven rulings plus finding 5).

**Off the list rather than settled, so do not re-open:** rule 5 shipped 1 August; rule 3 came off because its residual is mostly TRUE positives.

**Belonging to no WP:**

- **Transport of the six unsent documents** is WP-04, but the *decision* to send is hv's alone and nothing in the tool can prompt it.
- **Downloads housekeeping** -- four superseded drop directories, ~3G. **`baize-design-drops/` 441M stays**, the off-repo home named in Baize's own root `.gitignore`. **Six spent `_inbox/` directories**, and the two newest hold the Laksa theme packs, **which exist nowhere else**. Do not clear those two until Laksa has taken them.
- **No `hv` node here, by hv's ruling -- `cc` is the whole roster**, so rulings arrive in conversation and land in `## Decisions`. The whiteboard `README.md` roster stays deferred.

## Watch-outs

### Standing, and new on 6 August: THIS REPOSITORY IS PUBLIC

**Everything committed here is published the moment it is pushed** -- `intent/`, the steel threads, this board. There is no private tree to be careless in any more. No key, token, absolute path or real contact address belongs in a tracked file; two venture addresses were redacted immediately before publication and reintroducing one would undo that.

**The published history is a single root commit.** The 135-commit development history lives privately on the mirror's `archive/pre-public-20260806` and in a bundle beside it. **Do not try to recover it from the public repository** -- it is not there, and re-pushing it would undo a deliberate decision.

**A window closed here.** The rename was free only because it happened before the first release: no tag existed and no published artefact carried the old name. `v0.1.0` is out now, so the next rename of anything carries a published artefact with it.

### The recurring one

**A check that cannot see a thing does not fail -- it stops checking, and reports clean.** Always the dangerous direction. Full catalogue in history; the shapes are what matter. **Deliberately uncounted** -- this board has caught itself carrying a hand-maintained number that drifted, including one inside this very section.

- A probe answering about one corner, read as a verdict on the whole tree.
- **Two probes each assuming the other reported it**, so between them a thing vanishes.
- **A hand-maintained list drifting from its sibling.** **When a file carries two lists of the same kind of thing, that is the bug, not the style.** 2 August: the colour pattern was written out twice, once per scanner, and the gap existed on both sides because of it.
- **A uniform zero is a broken probe until proven otherwise -- real data is lumpy.**
- **A GENERATOR pointed at the wrong root reports an empty tree with total confidence.** 6 Aug: `bootstrap --stdout --target <repo>/design` said Lamplight had no assets; it has four, each with its `spec.md`, one level down at `design/system/`. The output was a well-formed document making a false claim, not an error. **Before believing a regenerated document, check it found something.**
- **A probe that cannot tell ABSENT from EMPTY.** `grep -c . || echo NONE` prints `0` *and* exits 1; `|| true` is the correct form.
- **A search whose reach is narrower than the thing it is searching for.**
- **A summary probe turning a hard refusal into a clean bill.** `grep -c 'rule-[0-9]'` counted zero findings on two trees that had ERRORED with `0 assets checked`.
- **`cmd | tail; echo $?` captures `tail`'s exit code, never `cmd`'s.** It reported shellcheck exit 0 over eight live findings.
- **A path constructed rather than found.** **`find` the file, then grep it.**
- **A case-sensitive `grep`** missing `Sixteen`, and a pattern requiring `` `--flag` `` unable to match `` `--target PATH` ``.

### Mutation testing has two failure modes, not one

**1. The mutation does not apply, and the test reports the reassuring answer.** Four times on 1 August: `sed 's|...||...|'` against a pattern containing `||`; `perl \Q...$var...\E` interpolating before quoting; `grep -v` on a literal, twice. **A fifth on 6 August, and it was the tool not the pattern: BSD `xargs` has no `-a`**, so a three-pass rename loop ran to completion having changed zero bytes while printing a tidy summary. **Print proof it landed.** `awk -v n="$LN" 'NR!=n'` by line number has not lied yet, and a before/after counter round the whole loop caught the `xargs` case immediately.

**2. The mutation applies perfectly and the test still passes, because it asserts at a layer the bug cannot reach.** New on 2 August, and it is the subtler one. Three colour tests piped straight into `normalise_colours`, whose fall-through `print value` passes an unrecognised string along unchanged -- so they produced the right answer with the bug still in place. The gap was one layer up, in the grep. **Check the test actually exercises the changed code path, not just that the mutation landed.**

**My own tests have been wrong rather than the code more often than the reverse.**

### Where a defect hides when the thing itself cannot be tested

**A DRY RUN CANNOT COVER THE WRITE PATH -- that is what makes it a dry run.** 6 Aug: `release cut 0.1.0 --dry-run` printed a perfect plan and passed every gate; the real run died at step 3. Everything after "write" is unexercised by definition, so a green dry run says nothing at all about it.

**A gate that deliberately refuses to run in the suite is exactly where a defect will sit.** `release_gates` refuses inside bats -- correctly, because running the suite from inside the suite does not terminate -- so the whole `cut` ceremony has no end-to-end test and never could. **When something is untestable by design, name the decision inside it and extract that decision to something testable.** `release_commit_version` takes its repository as an argument for precisely this reason.

**A command whose verbs presume a prior state cannot bootstrap.** `cut` took only `major|minor|patch`, all forward-moving, so the FIRST release of any project was unreachable. Nothing said a predecessor was required; the assumption was in the arithmetic. **Ask what a command does on its first run, with nothing behind it.**

**Every version component compares as a NUMBER.** Sorted as strings, `0.10.0` falls below `0.9.0` -- a bug that stays invisible for nine minor releases.

### A local pass does not predict CI, and both misses were shell-version deep

- **GitHub runs `shell: bash -e`.** `out="$(cmd)"` exits the whole script the moment cmd returns non-zero. Wrap the assignment in `if`. **The same class bit inside the tool on 2 August**: `kit_colours="$(each_kit_colour ...)"` killed `check` outright when the kit held no colour the scanner read.
- **macOS runners use bash 3.2, whose `-nt` compares whole SECONDS.** Anything choosing "the newest file" is undefined for same-second ties there.
- **`LC_ALL` overrides `LC_COLLATE`.** **Sort at the point of use.**
- **A test that does not control its own stdin asserts the ambient environment.** One hung the whole suite at test 183 for hv running bats from a terminal. **Reproduce with `script -q /dev/null bats ...`.**
- **Two of my own tools bit back.** `git reset --hard` discarded an unstaged edit; `pkill -f` reached another session. Both recovered; neither should have happened.

### One board-shaped version of the same error

**A measurement taken on one project, written down without its scope, and read later as a verdict on all four.** **Write the scope into the sentence, or the next reader inherits a generalisation nobody made deliberately.**

### The document is the instrument

**A generated document that explains a field and never states its value.** Three of four suppliers asked the same question in three shapes on one round -- **one defect in the document, not three mistakes by them.** It has now happened a fourth time, with `spec_version` for a NEW asset.

**An instruction that is complete on one tree and half-written on another.** Check whether an instruction still says anything on a tree that has already done part of it.

**A finding whose only remedy is an instruction nobody wrote** will report the same count every round forever. If a check does not move after a pass that obeyed the document, suspect the document.

**A published rule summary that over-promises its own reach.** *"Every colour literal must appear in `kit/tokens.json`"* was the whole description, and it said nothing about which forms are read -- so a kit written outside that set made the rule unrunnable with nothing to explain why. **A rule's reach is part of the rule.**

### Standing

- **A generated document is not a report -- it is an instruction the other side obeys.** **Read every generated document against the tree before it is sent.**
- **`BOOTSTRAP-CD.md` regenerates on sync and on nothing else.** Regenerate by hand after touching `addenda/` -- or after changing the generator, which stales every copy at once with no local symptom.
- **Two descriptions of one thing will disagree, and the terse one tends to survive.** **Structural tests now guard help files, the rule count, and every colour form the scanner reads.**
- **What matters is usually in Claude Design's tree, which this side cannot see.**
- **NEVER kill a process this session did not start.** Background jobs I start have task IDs; TaskStop is what they are for.
- **A file written into a repository another session is working in is not safe until it is committed.** The Laksa handoff note vanished between writing and updating it on 2 August.
- **Whether CD can read a repository is PER PROJECT, and reading is not writing.** **A drop can be AHEAD of its repository.**
- **Verify a correction by content, never by filename and never by a receipt.**
- **`assets/` is a name the drop contract owns, and three of four projects use it for something else.** The marker for an asset is its `spec.md`.
- **An exporter's wrapping is its habit, not a contract.** Two drops the same morning from the same supplier wrapped the identical tree to different depths.
- **`~/.gitignore_global:16` ignores `*.zip` machine-wide.** **An unanchored `.gitignore` rule matches at any depth.**
- **`intent critic shell` reports clean on unquoted `rm -rf $1/*` at every severity.** **A pass from the critic is no signal**; `--files` is SPACE-separated.
- **zsh aborts a whole loop on an unmatched glob** -- use `find`. **Shell cwd persists between tool calls** -- use absolute paths.
- **`templates/claude_design/_Archive/` and `_archive/` are hv's own rolling backups.** Do not touch. **No project should have `docs/design/`.**

## Decisions

Settled and not to be re-opened. Full reasoning in `intent/st/ST0001/design.md`.

**CANON, above every Decision below: `intent/docs/design-system-lifecycle.md`.**

- (2026-08-06) **0.1.0 is released, and the repository is public.** Published from a single root commit on hv's ruling; the full history is retained privately rather than rewritten in place, because a force-push does not scrub what GitHub keeps reachable through a PR ref. The repository was deleted and recreated to make it genuinely unreachable.
- (2026-08-06) **A release may land on an explicit version, and it may equal the current one.** All three bump parts move forward, which made the first release of any project unreachable. Whether a version has been RELEASED is a question about tags, not about `VERSION`, so it stays with the gate that finds the tag already exists rather than moving into the arithmetic.
- (2026-08-06) **When `VERSION` does not change, the tag goes on the commit that is already the release.** No empty commit is manufactured to sit beside it. `--allow-empty` would have silenced the failure and left a second commit claiming to be the same thing.
- (2026-08-06) **There is no forcing a close, and hv's authority is spent writing the contract rather than skipping it.** `wp done` offers only "define the criteria" or "declare `acceptance: exempt`", and exempt means deliberately AC-free -- applying it to real engineering would write a false label into the record. WP-01 closed 8/8 on a contract written at close from evidence measured before the criteria were phrased, which is what 4a1c3ff did for ST0001 and ST0002.
- (2026-08-06) **The tool is called Cdsync, and the former name survives nowhere it can be read.** 1420 occurrences here and 149 across four siblings, all gone, verified in every repository against a positive control equal to that repository's own pre-mutation baseline. **The former name is recoverable from git history, which is where superseded names belong** -- so nothing outside history preserves it, including ST0004's own documents, which name the outcome and the mechanism rather than both names. A thread titled after both cannot survive its own rename.
- (2026-08-06) **A rename is safe to do as a plain substitution only after enumerating what is adjacent to every match.** Not a word-boundary regex chosen on faith -- the actual set of preceding and following characters, checked. Here no alphanumeric ever touched a match, which is what made a bare replace provably unable to corrupt a neighbour. **Establish that first or the mechanism is a guess.**
- (2026-08-06) **Substitute over a superset, verify with a different probe than the one that chose the files.** A file list built from a probe inherits that probe's blind spots. In this repo the target set was every tracked text file; in the siblings, where sessions were live and needless mtime churn was the greater risk, it was the match-list -- and the verification was an independent disk-level sweep rather than the same `git grep`.

- (2026-08-02) **The wrapper descent stops at drop CONTENT, not at a depth.** An exporter may wrap a tree to any depth, and two drops the same morning proved it. Descend while the directory is a wrapper; stop the moment it names something the drop contract owns. Depth alone cannot terminate safely; content alone would not move off an empty wrapper.
- (2026-08-02) **A colour and its hex approximation are two different values to rule 4, deliberately.** The modern colour functions compare as normalised text and are NOT converted to hex: converting properly needs a colour-space transform, and converting approximately would make two distinct kit colours collide and report a leak that is not there. **Approximate agreement is worse than none for a leak guard.**
- (2026-08-02) **A rule with nothing to compare against is SKIPPED WITH A WARNING, never passed.** The missing-`tokens.json` branch already did this; a kit written in a space the scanner cannot read reaches the same condition by another route and now says so too.
- (2026-08-02) **A rule's published reach is part of the rule.** `help/check.md` names every colour form the scanner reads, guarded by a test against `CDSYNC_COLOUR_RE`, because a kit outside that set makes the rule unrunnable and the old one-line summary explained none of it.
- (2026-08-01) **A release carries the tool, and nothing about how the tool is made.** Pinned **positively** by a test -- a list of what must be absent cannot notice a new thing that should have been.
- (2026-08-01) **Pushing is opt-in.** `cdsync release cut` stops after tagging.
- (2026-08-01) **Ambiguity in `install` is refused, not guessed.**
- (2026-08-01) **A generated document is a function of the tree, not of the shell that ran it.** **An environment variable is the wrong place for determinism.**
- (2026-08-01) **`init` is for a design system in a project that already exists; `new` is for a venture.** Not a flag, because the question is what the new thing is.
- (2026-08-01) **The repo-owned `_inbox` guard lives in the target's PARENT.** Inside the target it would not survive the first `install`. It appends and never truncates.
- (2026-08-01) **Rule 5 does not demand `N/M` of a `partial` asset.** **A check must not contradict the document it ships beside.**
- (2026-07-30) **Two install paths, and there is no third.** An as-is export *is* the whole tree, so `install` replaces. A converted drop is a *subset*, so `import` merges. **Hand-unzipping is never correct.**
- (2026-07-31) **`design/system/` is the SSOT and Claude Design is a clamp-on tool.** **No cdsync protocol material belongs in a project.**
- (2026-07-31) **The drop is TRACKED IN FULL.** One exclusion, `/system/_inbox/`: delivery archives are ephemeral transport.
- (2026-07-31) **Seven things a drop may not deliver**, all unconditional: `addenda/`, `_inbox/`, the project's own `intent/` documents, Cdsync's protocol material, `.gitignore`, `BOOTSTRAP-CD.md` with its covering note, and **`scratch/` or any working directory of Claude Design's own**.
- (2026-07-31) **The project's `intent/` documents retire from the drop once actioned -- never more than one go-around.**
- (2026-07-31) **Cdsync never repairs a drop.** Record the gap in `addenda/` or refuse.
- (2026-07-31) **`spec_version` is the library's stamp, not a per-drop counter.** An asset's own progress is `status` and `coverage`.
- (2026-07-31) **The generated document carries the numbers, not just their meaning** -- and says to leave the field out where the library has no entry.
- (2026-07-31) **Removing the value from `audience` is part of declaring `classification`.** **`public` stays.**
- (2026-07-31) **Cold bootstrap is one generator with two outputs**, regenerated on every sync -- **across syncs only.**
- (2026-07-31) **A conversion is its own round and arrives with its own brief.**
- (2026-07-30) **Three classifications, an axis of their own:** `public` / `internal` / `confidential`. Governs where material may be shown, never whether it is committed. **Therefore rule 6 is advisory.**
- (2026-07-31) **`public` is a legitimate audience as well as a classification.**
- (2026-07-30) **`addenda/` is repo-authored and no install path may overwrite it.** An addendum retires when a drop carries its content -- **verified by reading, never by receipt.**
- (2026-07-30) **A drop's library-side spec and its drop-side `spec.md` are different documents.**
- (2026-07-30) **`print-collateral` is taxonomy 52, `cms-rollout-plan` 53, `go-to-market-plan` 54.** **The number is identity.**
- (2026-07-30) **`venture/` stays out of round one.** **`check` does not cross-reference `index.md`.**
- (2026-07-29) **Cdsync never writes into the application.** **`import` writes only `assets/`, `kit/`, `notes/`, `index.md`, `RETURN.md`.**
- (2026-07-29) **The composite test is "do the parts have different definitions of done?"**
- (2026-07-29) **Neutrality is a spec, not an instruction**, and `blanks` is computed.
- (2026-07-29) **An unspecified slug is refused when the order named it, and declared absent when a bundle reached it.**
- (2026-07-29) **Not yq.** **Shell is the declared language.**
