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

[The "whole steel thread is done" bar, or "none -- WP-distributed".]

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
