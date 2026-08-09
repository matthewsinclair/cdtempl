---
verblock: "02 Aug 2026:v0.1: matts - Initial version"
st_id: ST0003
title: "Post-release 0.1.0 clean-up -- acceptance contract"
---

# ST0003 Post-release 0.1.0 clean-up -- Acceptance

> Canonical acceptance contract for ST0003. Acceptance Criteria (AC) are the ratified completeness boundary; Acceptance Tests (AT) are the small red-to-green tests that prove them. Real test code lives in the suite (paths cited below); this file is the contract plus the AC-to-AT coverage map plus live status. info.md / WP info.md reference this file and never restate ACs (one home).
>
> Done = every AC is covered by a GREEN AT, or (for a non-test AC) its named evidence is satisfied, AND the AC set is the ratified full boundary. Done is read from this map, never from a hand-ticked box.
>
> Change control: clarifying an AC or AT is verifier-and-builder; shrinking scope, or weakening an AT to make it pass, needs the owner.
>
> AT status vocabulary: to-write (red-first) | red | green | n/a (non-test: doc / eyeball / gate).
>
> Non-test ACs carry their state inline -- `-- evidence: <ref> -- satisfied: yes|no` on the AC line; test-backed ACs are satisfied by a green covering AT (computed, never written). Multi-AC coverage on an AT is comma-separated.
>
> Exemption (ST0048): the close-gate is fail-by-default -- a unit with an empty or missing contract is refused. A unit that is deliberately AC-free (eg a pure content / authorial task) declares `acceptance: exempt` in the frontmatter above; the gate then passes and announces the exemption. Omit it (the default) and the contract is enforced. Never inferred from emptiness; always declared.

## Acceptance Criteria

### ST-level

Written at close on hv's authority ("close whatever can be closed"), from evidence measured before the criteria were phrased -- the same way WP-01, ST0001 and ST0002 closed. **Nothing here was satisfied by being written.**

**The bar is what this thread was FOR:** it was a holding pen with structure, opened so that what ST0001 and ST0002 carried forward would not live only in a fold document. So the bar is that every item reached a terminal state **on the record**, and not that every item was built.

**It is deliberately not "all eight work packages are Done".** WP-02 is parked by hv's ruling of 9 Aug, and WP-04, WP-06 and WP-07's Lamplight leg were dissolved by the wind-back rather than executed. A criterion demanding they be built would be this contract overruling the owner, at a close, which is precisely the shrink-scope-to-fit move the change-control note above forbids in the other direction.

- AC-00.1 (non-test) **Every work package this thread opened has reached a terminal state on the record, and its finding lives in its own `info.md` rather than in a snapshot** -- evidence: `intent wp list ST0003` shows seven Done and one Not Started; the one is WP-02, parked by hv on 9 Aug with its evidence and recommendations written up in `WP/02/info.md` -- satisfied: yes
- AC-00.2 (non-test) **Nothing in this thread is awaiting a ruling.** The state this thread sat in on 8 August -- every remaining item blocked on hv -- is cleared, not inherited by the next reader -- evidence: `intent/whiteboard/cc/wip.md` `## Wants hv` records both remaining asks answered on 9 Aug; no WP `info.md` names an open question -- satisfied: yes
- AC-00.3 (non-test) **The boundary is stated and the remainder is carried forward rather than dropped** -- evidence: WP-02 parked with the condition for re-opening named ("nothing moves until a live venture trips one"); `pattern-library`'s two-part dance recorded in `WP/03/info.md` against the day an order names it; the reciprocal asymmetry recorded in `specs/library.md` -- satisfied: yes
- AC-00.4 (non-test) **Four decisions this thread produced are written where the tool's readers will find them, not only in Intent** -- evidence: `cdsync.json`'s home and the `unassigned` lifecycle in `help/` and the generators; the staleness advisory in `doctor` and `check`; the edition-bump rule and `formats_required` in `specs/library.md` and `help/brief.md`; the last of these also in the brief the supplier reads -- satisfied: yes
- AC-00.5 (non-test) **The suite is green and shellcheck silent at the close**, and every behaviour this thread added is fenced by a test that fails without it -- evidence: 360 tests green, shellcheck clean at default severity; mutation cycles with landing proof recorded in WP-03, WP-05 and WP-08 -- satisfied: yes

### WP-03 -- Grow the spec library, and repair its text (status: complete)

- AC-03.1 **The shipped library states no count of itself.** The figure in `specs/kit.md` is inlined into every brief, so it went to the supplier every round while the 8 August guard reported the number settled -- that guard's sampling frame never included `specs/` -- covered by AT-03.1
- AC-03.2 **Every dependency the library names resolves in the taxonomy.** `check`'s rule 2 catches a dangling `depends_on` in a drop; nothing looked at the library, which is how three sat there from July -- covered by AT-03.2 and AT-03.4
- AC-03.3 **The supplier is told that `formats_required` is advisory**, in the brief and not only in the library. A ruling that never reaches the supplier changes nothing -- covered by AT-03.3
- AC-03.4 (non-test) **What a library edition bump means for already-stamped drops is decided and written where the library's readers find it** -- evidence: `specs/library.md` "What a library edition bump does, and does not do"; restated for the CLI reader in `help/brief.md`; the decision itself recorded in `WP/03/info.md` -- satisfied: yes
- AC-03.5 (non-test) **Exactly the specs whose text moved went stale, verified rather than asserted** -- evidence: `cdsync check --target templates/claude_design/templprj` reports `pitch-deck` and `positioning-icp-personas` stale against the new numbers and no asset stale that should not be; `cdsync doctor` reports library version 4 -- satisfied: yes
- AC-03.6 (non-test) **What was deliberately not done is named with its reason, so the next reader does not read it as an omission** -- evidence: `WP/03/info.md` "What was deliberately NOT done" covers `pattern-library` (no order needs one; the two-part dance recorded for the day one does), `templprj` (a delivery record, left as delivered), and the reciprocal asymmetry (flagged, not invented) -- satisfied: yes
- AC-03.7 (non-test) **Each new guard was proven able to fail, against a mutation proven to land** -- evidence: three mutants, each shown landed by diff and each killing exactly its own test; the harness's own inverted-`diff` bug caught and recorded -- satisfied: yes

### WP-01 -- Cut the 0.1.0 release (status: complete)

Written at close on hv's authority, from evidence measured before the criteria were phrased -- the same way ST0001 and ST0002 closed. Nothing here was satisfied by being written.

- AC-01.1 **The tool can cut the version a project is currently on.** Every bump part moves forward, so the first release of any project was unreachable through `cut` -- covered by AT-01.1 through AT-01.6
- AC-01.2 **The ceremony completes when `VERSION` does not change.** Cutting the version already held writes the same bytes, so there is nothing to commit; the tag goes on the commit that is already the release rather than on an empty one manufactured beside it -- covered by AT-01.7
- AC-01.3 (non-test) **`v0.1.0` exists as an annotated tag** on the release commit -- evidence: `git tag -l -n99 v0.1.0` reports an annotated tag object on `e54ebbc` -- satisfied: yes
- AC-01.4 (non-test) **All six release gates passed on the real cut**, not on a dry run -- evidence: working tree clean, on main, not behind upstream, doctor, shellcheck, tests -- all `ok` in the `cut 0.1.0` output -- satisfied: yes
- AC-01.5 (non-test) **The tarball carries the tool and nothing about how the tool is made**, verified against the artefact rather than against the intent -- evidence: `dist/cdsync-0.1.0.tar.gz`, 474,181 bytes, 140 entries; top level is `bin help lib specs templates VERSION README.md LICENSE.md`; each of `intent/`, `test/`, `.github/`, `.claude/`, `.gitattributes`, `AGENTS.md`, `CLAUDE.md`, `usage-rules.md`, `.intent_critic.yml`, `design/` confirmed absent by enumeration -- satisfied: yes
- AC-01.6 (non-test) **The tarball is built from the tag, not from the working tree** -- evidence: `release_package` runs `git archive` against the tag; `VERSION` inside the artefact reads `0.1.0` -- satisfied: yes
- AC-01.7 (non-test) **Both defects were found by running the tool for a real purpose, and each is fenced by a test that fails without its fix** -- evidence: four mutations (string-compare, refuse-equality, remove-the-case, remove-the-commit-guard), each confirmed landed by diff, each killing exactly the test meant to catch it -- satisfied: yes
- AC-01.8 (non-test) **Nothing was published.** `cut` stops after tagging unless `--push` is passed -- evidence: remote carries 0 tags and is 2 commits behind at close -- satisfied: yes

## Acceptance Tests

### WP-01

All seven were written red-first. Four went red immediately; **AT-01.3 and AT-01.5 passed before the fix for the wrong reason** -- the old code refused everything that was not a bump part, so a test asserting refusal could not tell a correct refusal from a blanket one. They gain their teeth only with the fix, and are recorded that way rather than counted as pre-existing green.

- AT-01.1 test/cdsync.bats::"release accepts an explicit target version, not only a bump part" -- covers AC-01.1 -- status: green
- AT-01.2 test/cdsync.bats::"release accepts the current version as an explicit target, so a first release can be cut" -- covers AC-01.1 -- status: green
- AT-01.3 test/cdsync.bats::"release refuses an explicit target older than the current version" -- covers AC-01.1 -- status: green
- AT-01.4 test/cdsync.bats::"release compares version components numerically, not as strings" -- covers AC-01.1 -- status: green
- AT-01.5 test/cdsync.bats::"release refuses an explicit target that is not bare semver" -- covers AC-01.1 -- status: green
- AT-01.6 test/cdsync.bats::"release cut plans the explicit version it was given" -- covers AC-01.1 -- status: green
- AT-01.7 test/cdsync.bats::"release commits a version change, and tags in place when VERSION is already correct" -- covers AC-01.2 -- status: green
- Coverage: AC-01.1 and AC-01.2 are test-backed and green. AC-01.3 through AC-01.8 are non-test and carry their evidence inline. No AC is uncovered.

**What no test covers, stated rather than left implied.** The `cut` ceremony cannot be exercised end to end in the suite: `release_gates` refuses to run inside bats, deliberately, because running the suite from inside the suite does not terminate. That is exactly why AC-01.2's defect reached a real cut with every gate green. AT-01.7 tests the extracted decision against a real repository, which is the closest the suite can get; the ceremony itself is covered by having been run.

### WP-03

- AT-03.1 test/cdsync.bats::"the shipped library states no taxonomy-wide count either" -- covers AC-03.1 -- status: green
- AT-03.2 test/cdsync.bats::"every dependency the spec library names is a slug the taxonomy holds" -- covers AC-03.2 -- status: green
- AT-03.3 test/cdsync.bats::"brief tells the supplier that formats are advisory" -- covers AC-03.3 -- status: green
- AT-03.4 test/cdsync.bats::"a bad dependency slug is declared as outside the taxonomy" -- covers AC-03.2 -- status: green
- Coverage: AC-03.1 through AC-03.3 are test-backed and green. AC-03.4 through AC-03.7 are non-test and carry their evidence inline. No AC is uncovered.

**AT-03.4 was green before this work and was green for the wrong reason.** It used the shipped library's own defect as its fixture -- `pitch-deck` really did name `positioning` -- so it could only pass while the library stayed broken, and repairing the library turned it red. It is recorded here as rewritten rather than as pre-existing green: it now runs against a doctored library, with an assertion that the doctoring landed. Same family as a test that asks the code under test for its own expected value, which this project has hit before.

**What no test covers, stated rather than left implied.** Nothing checks that `reciprocal` is symmetric, and the asymmetry between `positioning-icp-personas` and `pricing-and-packaging` is therefore invisible to the tool. That is deliberate: a check would have to decide which side is missing, and the library's position is that inventing the absent half is the drop-repair mistake one level up. It is recorded in `specs/library.md` where a reader meets it, which is the only place it can be caught -- by a person.
