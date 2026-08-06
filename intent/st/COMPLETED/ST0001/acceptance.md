---
verblock: "02 Aug 2026:v0.2: matts - Ratified boundary written from the as-built at close-out"
st_id: ST0001
title: "Harvest template v0 from the three Claude Design projects -- acceptance contract"
---

# ST0001 Build the generic template suite and the four specifications -- Acceptance

> Canonical acceptance contract for ST0001. Acceptance Criteria (AC) are the ratified completeness boundary; Acceptance Tests (AT) are the small red-to-green tests that prove them. Real test code lives in the suite (paths cited below); this file is the contract plus the AC-to-AT coverage map plus live status. info.md / WP info.md reference this file and never restate ACs (one home).
>
> Done = every AC is covered by a GREEN AT, or (for a non-test AC) its named evidence is satisfied, AND the AC set is the ratified full boundary. Done is read from this map, never from a hand-ticked box.
>
> Change control: clarifying an AC or AT is verifier-and-builder; shrinking scope, or weakening an AT to make it pass, needs the owner.
>
> AT status vocabulary: to-write (red-first) | red | green | n/a (non-test: doc / eyeball / gate).
>
> Non-test ACs carry their state inline -- `-- evidence: <ref> -- satisfied: yes|no` on the AC line; test-backed ACs are satisfied by a green covering AT (computed, never written). Multi-AC coverage on an AT is comma-separated.

## The boundary, stated before the criteria

This thread's objective (`info.md`) is **four things**: the brief format, the output structure, the asset taxonomy, and the per-asset specification format with templates where a template makes sense.

**The library is a growing thing, and a full 52 specs was never the bar.** The ratified model, from `design.md`, is that *"the specs are a library and the brief is an order against it -- selection varies per venture; what a complete design system needs does not."* A spec is written when an order needs it. **27 of 52 slugs are specified**, and the remaining 25 are ordinary future work rather than this thread's debt. `pattern-library` is *blocked* rather than queued, deliberately: `specs/library.md` names it as the live exemplar of an unwritten slug and a test pins the same invariant, so writing it would make library text false.

**Explicitly outside this boundary, and carried forward rather than dropped:**

- The remaining 25 unspecified taxonomy slugs, `pattern-library` among them and blocked.
- Acme round two, assembled and unsent at `templates/_test/Acme/design/brief.md`; `round-5-answer.md` likewise. Transport is hv's.
- `Acme/cdsync.json` filling, and re-ordering four slugs.
- Cutting an actual release. `cdsync release` exists and works; `VERSION` is `0.1.0` and nothing has been released.

## Acceptance Criteria

### ST-level

- AC-00.1 (non-test) All four deliverables exist and have been exercised end to end by a real supplier round, not only by fixtures -- evidence: matthewsinclair and geodica went out cold on 1 Aug and returned Cdsync-shaped on 2 Aug; both installed and checked (`intent/whiteboard/cc/.history/20260802/wip.md`) -- satisfied: yes

### WP-01 -- The brief format (status: complete)

- AC-01.1 A brief is assembled from the spec library rather than hand-written, and names the specs it orders
- AC-01.2 An order naming a slug the library does not specify is refused, and a bundle reaching one declares it absent
- AC-01.3 (non-test) The brief that went to Claude Design is self-contained, because the supplier cannot read this repository -- evidence: `cd-brief.md`, and five completed rounds answered from it -- satisfied: yes

### WP-02 -- The output structure (status: complete)

- AC-02.1 The mandated layout has exactly one definition, and both install paths read it from there
- AC-02.2 `import` writes only the five owned paths and leaves everything else standing
- AC-02.3 `install` replaces the whole tree, prints every removal, and refuses over uncommitted content
- AC-02.4 A drop may not deliver `.gitignore`, and it is discarded by name rather than silently
- AC-02.5 (non-test) A supplier working only from the generated document produces the mandated shape -- evidence: two cold trees returned on 2 Aug with an identical drop root of `assets brief.md index.md kit notes RETURN.md` -- satisfied: yes

### WP-03 -- The asset taxonomy (status: complete)

- AC-03.1 The taxonomy is enumerable by the tool, and its numbering is identity rather than sequence
- AC-03.2 Bundles are defined over slugs, not taxonomy numbers

### WP-04 -- The per-asset specification (status: complete for the ratified boundary)

- AC-04.1 A spec's definition of done is machine-checkable, and `check` applies every rule it claims to
- AC-04.2 A rule that cannot run says so rather than reporting clean
- AC-04.3 A rule's published reach matches its implemented reach
- AC-04.4 (non-test) A template exists for each specified type where a template makes sense -- evidence: `templates/claude_design/templprj/`, the worked example carrying the neutral kit and Form C assets -- satisfied: yes
- AC-04.5 (non-test) The library is self-describing about its own gaps rather than silently short -- evidence: `specs/library.md` names `pattern-library` as the live exemplar of a real-but-unwritten slug; `cdsync doctor` prints spec, taxonomy and bundle counts -- satisfied: yes

## Acceptance Tests

> Every AT below names a test that exists. The first draft of this file cited
> eleven and **eight of them were invented** -- plausible names for tests that
> had never been written. They were caught by grepping the suite for each one
> before this file was committed. A contract citing a test that does not exist
> is worse than an empty contract, because it reads as covered.

### WP-01

- AT-01.1 test/cdsync.bats::"brief writes to the target and inlines the full specification" -- covers AC-01.1 -- status: green
- AT-01.2 test/cdsync.bats::"brief refuses a slug that has no spec in the library" -- covers AC-01.2 -- status: green
- AT-01.3 test/cdsync.bats::"brief orders what a partial bundle has and declares the rest absent" -- covers AC-01.2 -- status: green
- Coverage: AC-01.1 and AC-01.2 covered; AC-01.3 is non-test and carries its evidence inline.

### WP-02

- AT-02.1 test/cdsync.bats::"the protected declaration is what decides, not the owned list's silence" -- covers AC-02.1 -- status: green
- AT-02.2 test/cdsync.bats::"a target file absent from the drop survives the import" -- covers AC-02.2 -- status: green
- AT-02.3 test/cdsync.bats::"install replaces what the drop carries and removes what it does not" -- covers AC-02.3 -- status: green
- AT-02.4 test/cdsync.bats::"install dry-run names every removal and writes nothing" -- covers AC-02.3 -- status: green
- AT-02.5 test/cdsync.bats::"install refuses when BOOTSTRAP-CD.md is untracked under the target" -- covers AC-02.3 -- status: green
- AT-02.6 test/cdsync.bats::"install names each discarded .gitignore rather than removing it quietly" -- covers AC-02.4 -- status: green
- Coverage: AC-02.1 to AC-02.4 covered; AC-02.5 is non-test and carries its evidence inline.

### WP-03

- AT-03.1 test/cdsync.bats::"the taxonomy is wider than the library" -- covers AC-03.1 -- status: green
- AT-03.2 test/cdsync.bats::"a bundle expands to slugs" -- covers AC-03.2 -- status: green
- Coverage: every AC covered.

### WP-04

- AT-04.1 test/cdsync.bats::"the documented rule count matches the rules check implements" -- covers AC-04.1 -- status: green
- AT-04.2 test/cdsync.bats::"rule 4 says it cannot run when the kit holds no colour it can read" -- covers AC-04.2 -- status: green
- AT-04.3 test/cdsync.bats::"rule 4 says it cannot run when there is no tokens.json at all" -- covers AC-04.2 -- status: green
- AT-04.4 test/cdsync.bats::"help/check.md names every colour form the scanner reads" -- covers AC-04.3 -- status: green
- Coverage: AC-04.1 to AC-04.3 covered; AC-04.4 and AC-04.5 are non-test and carry their evidence inline.
