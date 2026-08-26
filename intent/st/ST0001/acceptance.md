---
st_id: ST0001
title: Build the generic template suite and the four specifications
---

# ST0001: Build the generic template suite and the four specifications -- Acceptance

> **THIS FILE IS A GENERATED VIEW, AND A ROW AUTHORED HERE IS DISCARDED BY THE NEXT SYNC.** The acceptance contract is canon in the thread model; this file renders it. Acceptance Criteria (AC) are the ratified completeness boundary; Acceptance Tests (AT) are the small red-to-green tests that prove them.
>
> Done = every AC is covered by a GREEN AT, or (for a non-test AC) its named evidence is satisfied, AND the AC set is the ratified full boundary. Done is read from this map, never from a hand-ticked box.
>
> Test-backed satisfaction is COMPUTED from covering green ATs and never stored -- storing it would be double truth. An AC has four states, not two: beyond satisfied and unsatisfied, a requirement can be **descoped** to a named thread or **withdrawn** with its reason on the record. Both are non-blocking and both are reported separately, so a thread that descoped half its contract looks like one.

## Acceptance Criteria

### ST-level

- AC-00.1 (non-test) All four deliverables exist and have been exercised end to end by a real supplier round, not only by fixtures -- evidence: matthewsinclair and geodica went out cold on 1 Aug and returned Cdsync-shaped on 2 Aug; both installed and checked (`intent/whiteboard/cc/.history/20260802/wip.md`) -- satisfied: yes

### Group 01

- AC-01.1 A brief is assembled from the spec library rather than hand-written, and names the specs it orders -- satisfied: yes (computed)
- AC-01.2 An order naming a slug the library does not specify is refused, and a bundle reaching one declares it absent -- satisfied: yes (computed)
- AC-01.3 (non-test) The brief that went to Claude Design is self-contained, because the supplier cannot read this repository -- evidence: `cd-brief.md`, and five completed rounds answered from it -- satisfied: yes

### Group 02

- AC-02.1 The mandated layout has exactly one definition, and both install paths read it from there -- satisfied: yes (computed)
- AC-02.2 `import` writes only the five owned paths and leaves everything else standing -- satisfied: yes (computed)
- AC-02.3 `install` replaces the whole tree, prints every removal, and refuses over uncommitted content -- satisfied: yes (computed)
- AC-02.4 A drop may not deliver `.gitignore`, and it is discarded by name rather than silently -- satisfied: yes (computed)
- AC-02.5 (non-test) A supplier working only from the generated document produces the mandated shape -- evidence: two cold trees returned on 2 Aug with an identical drop root of `assets brief.md index.md kit notes RETURN.md` -- satisfied: yes

### Group 03

- AC-03.1 The taxonomy is enumerable by the tool, and its numbering is identity rather than sequence -- satisfied: yes (computed)
- AC-03.2 Bundles are defined over slugs, not taxonomy numbers -- satisfied: yes (computed)

### Group 04

- AC-04.1 A spec's definition of done is machine-checkable, and `check` applies every rule it claims to -- satisfied: yes (computed)
- AC-04.2 A rule that cannot run says so rather than reporting clean -- satisfied: yes (computed)
- AC-04.3 A rule's published reach matches its implemented reach -- satisfied: yes (computed)
- AC-04.4 (non-test) A template exists for each specified type where a template makes sense -- evidence: `templates/claude_design/templprj/`, the worked example carrying the neutral kit and Form C assets -- satisfied: yes
- AC-04.5 (non-test) The library is self-describing about its own gaps rather than silently short -- evidence: `specs/library.md` names `pattern-library` as the live exemplar of a real-but-unwritten slug; `cdsync doctor` prints spec, taxonomy and bundle counts -- satisfied: yes

## Acceptance Tests

### ST-level

_(no tests in this group)_

### Group 01

- AT-01.1 (legacy) test/cdsync.bats::"brief writes to the target and inlines the full specification" -- covers AC-01.1 -- status: green
- AT-01.2 (legacy) test/cdsync.bats::"brief still refuses a named slug outside the taxonomy" -- covers AC-01.2 -- status: green -- **Superseded in part, 9 Aug 2026**: hv ruled an in-taxonomy slug may be ordered ahead of the library (`spec_version: unassigned`), so the refusal this AT pinned now applies only outside the taxonomy. The original test was renamed to "an ordered-ahead slug gets the contract section, not an invented spec"; the refusal boundary lives in the test named here.
- AT-01.3 (legacy) test/cdsync.bats::"brief orders what a partial bundle has and declares the rest absent" -- covers AC-01.2 -- status: green

### Group 02

- AT-02.1 (legacy) test/cdsync.bats::"the protected declaration is what decides, not the owned list's silence" -- covers AC-02.1 -- status: green
- AT-02.2 (legacy) test/cdsync.bats::"a target file absent from the drop survives the import" -- covers AC-02.2 -- status: green
- AT-02.3 (legacy) test/cdsync.bats::"install replaces what the drop carries and removes what it does not" -- covers AC-02.3 -- status: green
- AT-02.4 (legacy) test/cdsync.bats::"install dry-run names every removal and writes nothing" -- covers AC-02.3 -- status: green
- AT-02.5 (legacy) test/cdsync.bats::"install refuses when BOOTSTRAP-CD.md is untracked under the target" -- covers AC-02.3 -- status: green
- AT-02.6 (legacy) test/cdsync.bats::"install names each discarded .gitignore rather than removing it quietly" -- covers AC-02.4 -- status: green

### Group 03

- AT-03.1 (legacy) test/cdsync.bats::"the taxonomy is wider than the library" -- covers AC-03.1 -- status: green
- AT-03.2 (legacy) test/cdsync.bats::"a bundle expands to slugs" -- covers AC-03.2 -- status: green

### Group 04

- AT-04.1 (legacy) test/cdsync.bats::"the documented rule count matches the rules check implements" -- covers AC-04.1 -- status: green
- AT-04.2 (legacy) test/cdsync.bats::"rule 4 says it cannot run when the kit holds no colour it can read" -- covers AC-04.2 -- status: green
- AT-04.3 (legacy) test/cdsync.bats::"rule 4 says it cannot run when there is no tokens.json at all" -- covers AC-04.2 -- status: green
- AT-04.4 (legacy) test/cdsync.bats::"help/check.md names every colour form the scanner reads" -- covers AC-04.3 -- status: green

---

_Generated by Intent v3.0.0 from `thread.json`. Do not edit this file -- it is rendered from the model, and `intent doctor` reports any hand-edit as skew._
