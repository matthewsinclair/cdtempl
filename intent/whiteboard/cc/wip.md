---
node: cc
name: Control Claude
role: control
session_id: e2036be7-6243-4da5-97a5-985cfaddc2bc
heartbeat_at: 2026-08-09T16:15Z
status: paused
focus: "Globalfolded 9 Aug. Every steel thread Completed; nothing open, nothing claimed, nothing awaits hv. The next piece of work opens a thread. Unpushed work in four repositories -- ask git, two remotes disagree"
claims: []
---

# Control Claude (cc)

**This board is live state plus the two standing lists below, and nothing else.** Day narrative is archived per day at `.history/`; 9 August is the most recent, and it has two entries.

**Read `intent/docs/design-system-lifecycle.md` first. It is canon and outranks everything here.** Then `intent/restart.md`.

## Where things stand

**Nothing is open, nothing is claimed, and nothing awaits hv.** Every steel thread is Completed.

**This board deliberately holds no second copy of the state.** Threads, gates, the release record and the structural guards are in `intent/wip.md`; orientation, the install/import table and what was carried forward are in `intent/restart.md`; each work package's finding is its own `info.md`. **The 9 August rulings are in `## Decisions` below, which is their one home.**

**Unpushed work exists here, in Baize (`7211fc1`), in Intent (`95f4da2`) and in Acme's nested repository. Pushing is hv's, and this repository publishes on push.** **No count for this repository is written anywhere** -- the two-remotes watch-out below says why, and what to ask instead.

## TODO

**Nothing.** No open thread, and that is the finished state rather than an invitation. **The next piece of work opens one** (`intent st new`), and `intent/restart.md`'s carried-forward list is what to read first -- recorded so it is not lost, which is the opposite of a queue.

## Wants hv

**Nothing awaits hv, and nothing is open to want it.** Every ask was answered on 9 August. **The next thing that will want hv is whatever hv brings next.**

**Standing:**

- **Of the six spent `_inbox/` directories, the two newest hold the Laksa theme packs, which exist nowhere else.** Do not clear those two until Laksa has taken them.
- **No `hv` node here, by hv's ruling -- `cc` is the whole roster**, so rulings arrive in conversation and land in `## Decisions`. The whiteboard `README.md` roster stays deferred.

## Watch-outs

### Standing, and new on 6 August: THIS REPOSITORY IS PUBLIC

**Everything committed here is published the moment it is pushed** -- `intent/`, the steel threads, this board. There is no private tree to be careless in any more. No key, token, absolute path or real contact address belongs in a tracked file; two venture addresses were redacted immediately before publication and reintroducing one would undo that.

**The published history is a single root commit, and the development history before it is not in this repository at all.** **Do not try to recover it from the public repository** -- it is not there, and re-pushing it would undo a deliberate decision. Where it *is* kept is recorded once, in `intent/wip.md`, and see the two-remotes entry below for why that copy is not as current as it looks.

**A window closed here.** The rename was free only because it happened before the first release: no tag existed and no published artefact carried the old name. `v0.1.0` is out now, so the next rename of anything carries a published artefact with it.

### The recurring one

**A check that cannot see a thing does not fail -- it stops checking, and reports clean.** Always the dangerous direction. Full catalogue in history; the shapes are what matter. **Deliberately uncounted** -- this board has caught itself carrying a hand-maintained number that drifted, including one inside this very section.

- A probe answering about one corner, read as a verdict on the whole tree.
- **Two probes each assuming the other reported it**, so between them a thing vanishes.
- **A hand-maintained list drifting from its sibling.** **When a file carries two lists of the same kind of thing, that is the bug, not the style.** 2 August: the colour pattern was written out twice, once per scanner, and the gap existed on both sides because of it. **8 August, the same shape in a NUMBER and it reached users**: the taxonomy's size was written out by hand in four places and disagreed three ways, and the copy inside `brief`'s refusal message -- the one a user actually reads -- was among the wrong ones. **Computed now, one function, two callers.** A count restated in prose has no way to notice the table moved.
- **A uniform zero is a broken probe until proven otherwise -- real data is lumpy.**
- **A GENERATOR pointed at the wrong root reports an empty tree with total confidence.** 6 Aug: `bootstrap --stdout --target <repo>/design` said Lamplight had no assets; it has four, each with its `spec.md`, one level down at `design/system/`. The output was a well-formed document making a false claim, not an error. **Before believing a regenerated document, check it found something.**
- **A probe that cannot tell ABSENT from EMPTY.** `grep -c . || echo NONE` prints `0` *and* exits 1; `|| true` is the correct form.
- **A search whose reach is narrower than the thing it is searching for.**
- **A summary probe turning a hard refusal into a clean bill.** `grep -c 'rule-[0-9]'` counted zero findings on two trees that had ERRORED with `0 assets checked`.
- **`cmd | tail; echo $?` captures `tail`'s exit code, never `cmd`'s.** It reported shellcheck exit 0 over eight live findings.
- **A path constructed rather than found.** **`find` the file, then grep it.** 8 Aug: Baize's app CSS is at `apps/rack/assets/`, so a root-level `find assets -name '*.css'` returns **nothing at all** -- a clean empty answer to the wrong question. Its handoff document names the real path. **When a drop carries a `handoff/`, read the path out of it rather than guessing where an app keeps its assets.**
- **ONE PROBE PER PROJECT, for anything written in a notation.** 8 Aug: the hex-literal probe that confirmed snorkeltoast at 41 of 41 reports a confident **`0/0` on Baize**, whose theme blocks are `oklch()` exclusively and hold **zero hex literals**. Same question, same family of artefact, same author -- and an instrument that answers one and is silent on the other **without ever erroring.** **Establish the notation before choosing the probe, and never reuse a colour probe across projects on the strength of it having worked.**
- **A case-sensitive `grep`** missing `Sixteen`, and a pattern requiring `` `--flag` `` unable to match `` `--target PATH` ``.
- **A SWEEP OVER A DIRECTORY LIST NOBODY CHOSE DELIBERATELY, AND THEN A CORRECTION MADE THE SAME WAY.** 8 Aug, *inside the fix for the drift hazard above*. The hunt for hand-written taxonomy counts searched `bin/`, `lib/` and `help/`, found four, and reported no figure left in shipped text. **`specs/` and `templates/` were never searched.** The correction then announced "a fifth copy survives" -- **also wrong**, because it counted rather than swept. **The real answer was three files, and they are the ones that travel**: `specs/kit.md` is inlined into every brief, and two under `templates/claude_design/templprj/` are scaffolded into every venture `cdsync new` creates. **Sweep every tracked file and name what you find. A count of wrong counts is still a count**, and this one was wrong twice before a `git grep` over the whole repository settled it.
- **A POSITIVE CONTROL VALIDATES THE INSTRUMENT, NOT THE SAMPLING FRAME.** Every control ST0004 ran was sound and the answer was still wrong: they proved each probe could hit *inside the repository it was pointed at*, and nothing asked what enumerated the repositories. Two were missing, carrying 54 occurrences. **Ask separately what chose the set.** A phrase like "the four siblings *that carried the name*" is a claim about the world, not about the four it then checks.

### Mutation testing has two failure modes, not one

**1. The mutation does not apply, and the test reports the reassuring answer.** Four times on 1 August: `sed 's|...||...|'` against a pattern containing `||`; `perl \Q...$var...\E` interpolating before quoting; `grep -v` on a literal, twice. **A fifth on 6 August, and it was the tool not the pattern: BSD `xargs` has no `-a`**, so a three-pass rename loop ran to completion having changed zero bytes while printing a tidy summary. **Print proof it landed.** `awk -v n="$LN" 'NR!=n'` by line number has not lied yet, and a before/after counter round the whole loop caught the `xargs` case immediately.

**2. The mutation applies perfectly and the test still passes, because it asserts at a layer the bug cannot reach.** New on 2 August, and it is the subtler one. Three colour tests piped straight into `normalise_colours`, whose fall-through `print value` passes an unrecognised string along unchanged -- so they produced the right answer with the bug still in place. The gap was one layer up, in the grep. **Check the test actually exercises the changed code path, not just that the mutation landed.**

**8 August, and the cleanest example yet: a test that ASKS THE CODE UNDER TEST FOR ITS OWN EXPECTED VALUE cannot fail.** Three new tests took the taxonomy count from `taxonomy_count()` and then asserted the message matched it. Replacing that function's whole body with `echo 99` left all three green -- they were pinning consistency, which was never in doubt, rather than correctness. **Derive the expected value by a different probe than the one under test**, which is the sampling-frame rule applied to one's own tests. Both rewritten tests fail against the mutant and pass clean.

**3. The mutation lands, the test is fine, and THE HARNESS MISREADS ITS OWN PROOF.** New on 9 August. `if diff a b; then echo "MUTATION DID NOT LAND"` inverts the check, because **`diff` exits non-zero when the files DIFFER** -- so the harness announced the mutation had not landed while printing the landed diff directly above the claim. Two lines of output contradicting each other, and only the standing "print proof it landed" rule made it a one-read fix instead of a wrong conclusion. **The instrument that validates the instrument is also an instrument.**

**A TEST CAN BE GREEN BECAUSE THE CODE IS RIGHT, OR BECAUSE THE DATA IS WRONG.** 9 August: "a bad dependency slug is declared as outside the taxonomy" used the shipped library's own defect as its fixture -- `pitch-deck` really did name `positioning` -- so it could only pass for as long as the library stayed broken, and **repairing the library turned it red.** A test whose fixture is live data is pinned to that data's defects. Give it a fixture it owns, and assert the doctoring landed.

**My own tests have been wrong rather than the code more often than the reverse.**

### Where a defect hides when the thing itself cannot be tested

**A DRY RUN CANNOT COVER THE WRITE PATH -- that is what makes it a dry run.** 6 Aug: `release cut 0.1.0 --dry-run` printed a perfect plan and passed every gate; the real run died at step 3. Everything after "write" is unexercised by definition, so a green dry run says nothing at all about it.

**A gate that deliberately refuses to run in the suite is exactly where a defect will sit.** `release_gates` refuses inside bats -- correctly, because running the suite from inside the suite does not terminate -- so the whole `cut` ceremony has no end-to-end test and never could. **When something is untestable by design, name the decision inside it and extract that decision to something testable.** `release_commit_version` takes its repository as an argument for precisely this reason.

**A command whose verbs presume a prior state cannot bootstrap.** `cut` took only `major|minor|patch`, all forward-moving, so the FIRST release of any project was unreachable. Nothing said a predecessor was required; the assumption was in the arithmetic. **Ask what a command does on its first run, with nothing behind it.**

**Every version component compares as a NUMBER.** Sorted as strings, `0.10.0` falls below `0.9.0` -- a bug that stays invisible for nine minor releases.

### A local pass does not predict CI, and every miss has been shell-version deep

**Deliberately uncounted.** This heading said "both" while `.claude/restart.md` said "four" -- one count, two documents, two answers, neither checked. The shapes below are what matter.

- **GitHub runs `shell: bash -e`.** `out="$(cmd)"` exits the whole script the moment cmd returns non-zero. Wrap the assignment in `if`. **The same class bit inside the tool on 2 August**: `kit_colours="$(each_kit_colour ...)"` killed `check` outright when the kit held no colour the scanner read.
- **macOS runners use bash 3.2, whose `-nt` compares whole SECONDS.** Anything choosing "the newest file" is undefined for same-second ties there.
- **`LC_ALL` overrides `LC_COLLATE`.** **Sort at the point of use.**
- **The interactive shell here is zsh and CI is bash, so a CI script cannot be rehearsed by pasting it.** 8 Aug: the hygiene job's own `check()` helper dies immediately under zsh -- **`status` is a read-only variable there** -- so running it locally proved nothing about the thing being tested. **Run a CI recipe under `bash` explicitly**, and prefer running the workflow's exact command over an approximation of it.
- **A test that does not control its own stdin asserts the ambient environment.** One hung the whole suite at test 183 for hv running bats from a terminal. **Reproduce with `script -q /dev/null bats ...`.**
- **Two of my own tools bit back.** `git reset --hard` discarded an unstaged edit; `pkill -f` reached another session. Both recovered; neither should have happened.

### One board-shaped version of the same error

**A measurement taken on one project, written down without its scope, and read later as a verdict on all four.** **Write the scope into the sentence, or the next reader inherits a generalisation nobody made deliberately.**

### The document is the instrument

**A generated document that explains a field and never states its value.** Three of four suppliers asked the same question in three shapes on one round -- **one defect in the document, not three mistakes by them.** It has now happened a fourth time, with `spec_version` for a NEW asset.

**An instruction that is complete on one tree and half-written on another.** Check whether an instruction still says anything on a tree that has already done part of it.

**A finding whose only remedy is an instruction nobody wrote** will report the same count every round forever. If a check does not move after a pass that obeyed the document, suspect the document.

**A PREMISE RESTATED OFTEN ENOUGH STARTS READING AS EVIDENCE.** Twice in this thread. WP-07 opened on "none has been built against" and it was false for the first project it named. **9 August, and this one had spread**: `templprj/README.md` claimed `cdsync new` draws from that directory -- true as a round-one *plan*, never true of the as-built -- and the claim was then copied into a work package and into a `lib/specs.sh` comment, so three documents agreed and none of them had opened `cmd_new.sh`. **Agreement between documents is not corroboration when one is the other's source.** Check the claim against the code it describes, not against the sentence.

**A published rule summary that over-promises its own reach.** *"Every colour literal must appear in `kit/tokens.json`"* was the whole description, and it said nothing about which forms are read -- so a kit written outside that set made the rule unrunnable with nothing to explain why. **A rule's reach is part of the rule.**

### Standing

- **A generated document is not a report -- it is an instruction the other side obeys.** **Read every generated document against the tree before it is sent.**
- **`BOOTSTRAP-CD.md` regenerates on sync and on nothing else.** Regenerate by hand after touching `addenda/` -- or after changing the generator, which stales every copy at once with no local symptom. **Assume stale and diff, rather than reading it.** **A hand-regeneration does not hold, either**: Baize's went stale again inside a day, because the fix is a snapshot and the tree keeps moving. **Which copies, and how the rule that would catch them must be scoped, live in WP-08** -- this board deliberately carries no count of them.
- **Two descriptions of one thing will disagree, and the terse one tends to survive.** **Structural tests now guard help files, the rule count, and every colour form the scanner reads.**
- **What matters is usually in Claude Design's tree, which this side cannot see.**
- **NEVER kill a process this session did not start.** Background jobs I start have task IDs; TaskStop is what they are for.
- **A file written into a repository another session is working in is not safe until it is committed.** The Laksa handoff note vanished between writing and updating it on 2 August. **6 August, the other direction: a live session in snorkeltoast COMMITTED four files this session had just edited**, into a commit of its own called *"Content for new laksa release"*. The work survived and is mislabelled, so **the hazard is not only loss** -- check the reflog before assuming a clean tree means your edit failed.
- **An explicit FILE LIST is not an explicit pathspec.** It governs which files move, not which hunks inside them. 6 August: staging six named files swept 20 lines of unrelated uncommitted work into a commit labelled a rename. **The arithmetic is what caught it** -- every other file reconciled exactly against its occurrence count and one did not. ST0004's AC-00.10 names the discipline; obeying its letter with `git add -A <list>` is not obeying it.
- **Whether CD can read a repository is PER PROJECT, and reading is not writing.** **A drop can be AHEAD of its repository.**
- **Verify a correction by content, never by filename and never by a receipt.**
- **`assets/` is a name the drop contract owns, and three of four projects use it for something else.** The marker for an asset is its `spec.md`.
- **An exporter's wrapping is its habit, not a contract.** Two drops the same morning from the same supplier wrapped the identical tree to different depths.
- **THERE ARE TWO REMOTES AND THEY ARE NOT AT THE SAME PLACE.** `upstream` is the public GitHub repository, which `main` tracks; `local` is the Dropbox mirror, and **it holds the only copy of the truncated pre-public history**. 9 August: every document had recorded a single hand-written "unpushed" figure, which was right for GitHub and **six commits wrong for the mirror** -- the backup was further behind than the thing it backs up, and nothing said so. **There is also no `origin`**, so the reflexive `origin/main..main` fails outright rather than answering wrongly, which is the one mercy here. **Name the remote, ask both, and never write the answer down:** `git log --oneline upstream/main..main` for the public repository and `git log --oneline local/main..main` for the mirror. `upstream/main` is only as fresh as the last fetch, so a zero there means "nothing since the last fetch", not "nothing".
- **`cdsync check` IS NOT READ-ONLY.** It recomputes `blanks` and `blanks_unique` and **writes them back into every `spec.md` in the drop it walks** -- by design, since hand-counted figures were always wrong, but the verb does not say so. 9 August: running `check` against `templprj` purely as a *verification probe* silently modified eight tracked files, in the same breath as ruling that directory a delivery record not to be edited. **Caught by `git status` at commit time, not by anything in the run.** Before pointing `check` at a tracked tree you are not intending to change, know that you are changing it -- and check `git status` afterwards. **A probe with a side effect is still a side effect.**
- **`~/.gitignore_global:16` ignores `*.zip` machine-wide.** **An unanchored `.gitignore` rule matches at any depth.**
- **`intent critic shell` reports clean on unquoted `rm -rf $1/*` at every severity.** **A pass from the critic is no signal**; `--files` is SPACE-separated.
- **zsh aborts a whole loop on an unmatched glob** -- use `find`. **Shell cwd persists between tool calls** -- use absolute paths.
- **`templates/claude_design/_Archive/` and `_archive/` are hv's own rolling backups.** Do not touch. **No project should have `docs/design/`.**

## Decisions

Settled and not to be re-opened. Full reasoning in `intent/st/ST0001/design.md`.

**CANON, above every Decision below: `intent/docs/design-system-lifecycle.md`.**

- (2026-08-09) **A library edition bump restamps nothing and invalidates nothing.** `spec_library_version` is the library's edition, stamped into every round, and a drop keeps the edition it was ordered against -- raising the number afterwards would falsify the one fact the stamp records. **Staleness is per asset and is `spec_version`'s job**: only a spec whose text actually moved raises its own, and `check` then reports only the assets built from it. If an edition bump restamped every drop, one editorial fix would make the whole world stale at once and the signal would mean nothing, which is the two-counters lesson applied to the other number. Stated in `specs/library.md`; edition 4 moved exactly three specs, verified against `templprj` rather than asserted.
- (2026-08-09) **The library's dangling references are repaired, and the finding is kept in prose rather than in the defect.** They had been left as delivered so they would arrive as findings in a later round; **the wind-back spent that reason**, because no round remains for the finding to reach. A reference that can never resolve, preserved for a report nobody will write, is worse than a repair with the finding recorded.
- (2026-08-09) **An asymmetry between two delivered specs is flagged, never invented away.** `positioning-icp-personas` declares `pricing-and-packaging` reciprocal and is not declared back; writing the missing half would be this library inventing a dependency Claude Design never declared, which is the drop-repair mistake one level up. **No check can see it -- a person is the only instrument**, which is why it is written where a reader meets it.
- (2026-08-09) **`templates/claude_design/templprj/` is a delivered drop and is read as a record, not as live text.** Its `spec_library_version: 2` and its taxonomy figure stay as delivered; editing them would falsify the delivery it records. That is the edition-bump ruling applied to the tool's own worked example. **It is also not what `cdsync new` draws from** -- `new` renders `templates/venture/*.tmpl` and no code path reads that directory at all, which its own README had claimed since round one and which two later documents inherited.
- (2026-08-09) **A spec is written when an order needs one, and `pattern-library` therefore stays unwritten.** No order is coming under the wind-back, so writing it in bulk would contradict the ratified model to satisfy a checklist. It stays the live exemplar of a slug that is real, in the taxonomy and unwritten. **The two-part dance still binds the day an order names it**: write the spec and re-point the exemplar and its pinning test in the same change.
- (2026-08-09) **The delivered projects are delivered, and the loop does not run back to Claude Design for them.** The cdsync process earns its keep for a few rounds while a design system beds down; after that the tree is a **record of what was asked for**, not a living document. Further rounds are rare, project-specific and as-needed; rollout is the project's own work, and nothing in the four delivered projects needs anything more from here. **The map was confirmed the same day**: WP-04 closed unsent, WP-06 dissolved to its two survivors, WP-07 closed on its finding, the sibling regeneration sweep retired.
- (2026-08-09) **`spec_version` for a new asset is `unassigned`, stamped by instruction rather than invented by the supplier.** Confirmed by hv on the precise reading: the per-slug field takes the literal `unassigned` when the library holds no specification for the slug; the round already carries `spec_library_version` (the brief stamps every order with it); the generators state both so no supplier has to ask. Rule 2 treats `unassigned` with no library entry as the correct state, and flags the asset for rebuild once the library gains the entry. A library-wide number never goes into the per-slug field -- two unrelated counters colliding is the G&G lesson.
- (2026-08-09) **A slug the venture names may be ordered without a specification if it is in the taxonomy; outside the taxonomy stays refused.** Implementation boundary under the ruling above: the old refusal existed only because the brief could not say what to stamp, and `unassigned` says it. The taxonomy stays the identity space -- a genuinely new asset TYPE is library work, not an order. Bundle expansion is unchanged: an unspecified bundle member stays declared-absent, because the venture did not name it.
- (2026-08-09) **WP-02 is parked, not ruled.** Rule 4's three noise shapes stay recorded with their evidence and recommendations; nothing changes in the rule until a live venture trips one.
- (2026-08-09) **The staleness advisory is built, shape (a): a warning, never blocking, and not a numbered rule.** `doctor` and `check` both warn when a target's `BOOTSTRAP-CD.md` is older than the repository it describes -- repository-scoped to match the generator's reach, over tracked and untracked-unignored files so build churn cannot cry wolf, printed before check's shape gate because the poster cases are the trees the asset walk refuses. Not rule 7: the six rules judge what Claude Design delivered, this judges Cdsync's own output. The (b) shape -- check regenerating as a byproduct -- was offered and declined by hv.
- (2026-08-09) **`formats_required` is advisory.** An asset can be complete without its formats; two suppliers independently read it so and hv ruled it. The library text stating it lands with WP-03's version-bump pass, never alone.
- (2026-08-09) **`cdsync.json` lives at the design tree root, always -- one home for `new` ventures and `init` projects alike.** The WP-05 framing had invented a choice; hv's answer is that there is nowhere else it could sensibly live. Consequences carried into implementation: the file joins `CDSYNC_DROP_PROTECTED_PATHS`, a drop may never deliver it, and its `.target` field retires as circular once the file sits inside the tree it points at.
- (2026-08-09) **A stale generated document is never accepted -- regenerate it.** And a staleness check that reports clean on a provably stale document is the wrong check, so any such check scopes to the repository, matching the generator's own reach.
- (2026-08-09) **Baize's 96%/95% refinement stays unrecorded -- "leave it."** No addendum. Consistent with integration being the application's business, and with the wind-back above.
- (2026-08-08) **A round's PURPOSE is declared and what the target already holds is MEASURED, and the two must not be collapsed.** `round_job` is free text, matching `effort` and `inherits_from`, because repackage, revise, extend and correct are four different jobs with **one filesystem signature** -- no amount of looking at the tree distinguishes them. What is already present is the opposite: the tool can see it, so asking the venture to declare it would be asking for something it can get wrong. **Free text rather than an enum, because nobody ordered a vocabulary of round types and inventing one would be the tool deciding what kinds of round exist.**
- (2026-08-08) **A count belongs in one function, never in prose.** The taxonomy's size was hand-written in four places, disagreed three ways, and the wrong copy was the one in a message users read. Prose that wants a number says to run `cdsync doctor`. **This extends the existing ruling about the spec-library counts to every count the tool knows.**
- (2026-08-06) **0.1.0 is released, and the repository is public.** Published from a single root commit on hv's ruling; the full history is retained privately rather than rewritten in place, because a force-push does not scrub what GitHub keeps reachable through a PR ref. The repository was deleted and recreated to make it genuinely unreachable.
- (2026-08-06) **A release may land on an explicit version, and it may equal the current one.** All three bump parts move forward, which made the first release of any project unreachable. Whether a version has been RELEASED is a question about tags, not about `VERSION`, so it stays with the gate that finds the tag already exists rather than moving into the arithmetic.
- (2026-08-06) **When `VERSION` does not change, the tag goes on the commit that is already the release.** No empty commit is manufactured to sit beside it. `--allow-empty` would have silenced the failure and left a second commit claiming to be the same thing.
- (2026-08-06) **There is no forcing a close, and hv's authority is spent writing the contract rather than skipping it.** `wp done` offers only "define the criteria" or "declare `acceptance: exempt`", and exempt means deliberately AC-free -- applying it to real engineering would write a false label into the record. WP-01 closed 8/8 on a contract written at close from evidence measured before the criteria were phrased, which is what 4a1c3ff did for ST0001 and ST0002.
- (2026-08-06) **The tool is called Cdsync, and the former name survives nowhere it can be read.** 1420 occurrences here and 149 across four siblings, all gone, verified in every repository against a positive control equal to that repository's own pre-mutation baseline. **The former name is recoverable from git history, which is where superseded names belong** -- so nothing outside history preserves it, including ST0004's own documents, which name the outcome and the mechanism rather than both names. A thread titled after both cannot survive its own rename.
- (2026-08-06) **A rename is safe to do as a plain substitution only after enumerating what is adjacent to every match.** Not a word-boundary regex chosen on faith -- the actual set of preceding and following characters, checked. Here no alphanumeric ever touched a match, which is what made a bare replace provably unable to corrupt a neighbour. **Establish that first or the mechanism is a guess.**
- (2026-08-06) **A closed thread whose BOUNDARY turns out to be too narrow stays closed, and the completion is a post-close note on its contract.** ST0004 did what it declared; the declaration is what was wrong. Reopening would relitigate scope at a close, and a new thread for the same work would split its record in two. **The note names what the boundary missed and why no criterion in the file could have caught it** -- otherwise the next reader inherits the wrong bar from a contract that reads as satisfied.
- (2026-08-06) **A check that an application still agrees with its design system belongs to the APPLICATION.** Corollary of Cdsync having no application-side check: `design/system/` is specification, and the gap between a specification and an app is expected rather than a defect. It also follows that **a drop's own drift record cannot see a consumer outside the drop** -- G&G's kit correctly names the pitch deck as a second copy of the palette and structurally cannot know the site theme is a third. **The repo builds the check the drop cannot.**
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
- (2026-07-31) **`spec_version` is the library's stamp, not a per-drop counter.** An asset's own progress is `status` and `coverage`. **A number each side increments on its own schedule cannot measure a distance, because it never disagrees for a reason.**
- (2026-07-31) **The generated document carries the numbers, not just their meaning** -- and says to leave the field out where the library has no entry. **Claude Design holds a delivery and cannot read the library**, so "copy the specification's version" is an instruction it has no way to follow.
- (2026-07-31) **Removing the value from `audience` is part of declaring `classification`.** **`public` stays.**
- (2026-07-31) **Cold bootstrap is one generator with two outputs**, regenerated on every sync -- **across syncs only.**
- (2026-07-31) **A conversion is its own round and arrives with its own brief.**
- (2026-07-30) **Three classifications, an axis of their own:** `public` / `internal` / `confidential`. Governs where material may be shown, never whether it is committed. **Therefore rule 6 is advisory** -- blocking on it would make classification the delivery filter this ruling exists to say it is not.
- (2026-07-31) **`public` is a legitimate audience as well as a classification.**
- (2026-07-30) **`addenda/` is repo-authored and no install path may overwrite it.** An addendum retires when a drop carries its content -- **verified by reading, never by receipt.** **A name declared both owned and protected is an unsatisfiable contract**, so both install paths refuse rather than pick a winner.
- (2026-07-30) **There is no backup directory, by design.** The tree is tracked in full, so **git already holds every prior state** and a second copy would only be a state nothing verifies. The job is therefore to prove git's copy is complete before replacing anything -- which is exactly what `install`'s refusal over uncommitted or untracked content does. **The refusal is the backup.**
- (2026-07-30) **A drop's library-side spec and its drop-side `spec.md` are different documents.**
- (2026-07-30) **`print-collateral` is taxonomy 52, `cms-rollout-plan` 53, `go-to-market-plan` 54.** **The number is identity.**
- (2026-07-30) **`venture/` stays out of round one.** **`check` does not cross-reference `index.md`.**
- (2026-07-29) **Cdsync never writes into the application.** **`import` writes only `assets/`, `kit/`, `notes/`, `index.md`, `RETURN.md`.**
- (2026-07-29) **The composite test is "do the parts have different definitions of done?"**
- (2026-07-29) **Neutrality is a spec, not an instruction**, and `blanks` is computed.
- (2026-07-29) **An unspecified slug is refused when the order named it, and declared absent when a bundle reached it.**
- (2026-07-29) **Not yq.** **Shell is the declared language.**
