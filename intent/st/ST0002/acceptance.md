---
st_id: ST0002
title: Port four established projects to the Cdsync protocol
---

# ST0002: Port four established projects to the Cdsync protocol -- Acceptance

> **THIS FILE IS A GENERATED VIEW, AND A ROW AUTHORED HERE IS DISCARDED BY THE NEXT SYNC.** The acceptance contract is canon in the thread model; this file renders it. Acceptance Criteria (AC) are the ratified completeness boundary; Acceptance Tests (AT) are the small red-to-green tests that prove them.
>
> Done = every AC is covered by a GREEN AT, or (for a non-test AC) its named evidence is satisfied, AND the AC set is the ratified full boundary. Done is read from this map, never from a hand-ticked box.
>
> Test-backed satisfaction is COMPUTED from covering green ATs and never stored -- storing it would be double truth. An AC has four states, not two: beyond satisfied and unsatisfied, a requirement can be **descoped** to a named thread or **withdrawn** with its reason on the record. Both are non-blocking and both are reported separately, so a thread that descoped half its contract looks like one.

## Acceptance Criteria

### ST-level

- AC-00.1 (non-test) All four projects hold a design-system record at `design/system/`, installed by the tool rather than by hand, and committed -- evidence: Lamplight, Baize, gyreandgymble and snorkeltoast all installed and committed by 31 Jul; `intent/st/ST0002/tasks.md` carries the per-project table -- satisfied: yes
- AC-00.2 (non-test) **Nothing that already existed was lost.** Every deletion is accounted for against the supplier's own statement of what it delivered -- evidence: every deletion matched a sentence in that project's `RETURN.md` -- satisfied: yes

### Group 01

- AC-01.1 An install preserves anything the drop does not carry, so a port cannot silently drop pre-existing material -- satisfied: yes (computed)
- AC-01.2 Repo-authored material inside the target survives an install by declaration, not by luck -- satisfied: yes (computed)
- AC-01.3 A generated site is not eaten by the next round -- satisfied: yes (computed)
- AC-01.4 (non-test) The two projects that had never been extracted were extracted straight into Cdsync's shape, rather than extracted twice -- evidence: `extract-brief-gyreandgymble.md` and `extract-brief-snorkeltoast.md` were written before any extract ran, which was the stated precondition in `info.md` -- satisfied: yes

### Group 02

- AC-02.1 A design system tree renders to a browsable site from its own repository, without serving -- satisfied: yes (computed)
- AC-02.2 The generator refuses a target that is not a drop, rather than producing an empty site -- satisfied: yes (computed)
- AC-02.3 (non-test) Each of the four carries a manifest -- evidence: `index.md` landed in all four on 31 Jul; two had no manifest of any kind before it -- satisfied: yes

### Group 03

- AC-03.1 (non-test) `check` was run against all four and the results recorded as measured rather than as hoped -- evidence: `check-against-all-four-drops.md`; G&G clean, Lamplight clean, Baize and snorkeltoast refusing with `0 assets checked` -- satisfied: yes
- AC-03.2 A tree the checker cannot read is refused rather than passed, so `0 assets checked` can never read as a clean bill -- satisfied: yes (computed)
- AC-03.3 (non-test) The conversion needed to make the remaining trees checkable is specified and ready to send, not merely identified -- evidence: `port-brief-lamplight.md`, `port-brief-baize.md`, `port-brief-snorkeltoast.md`, all complete and unsent; G&G needs none -- satisfied: yes

## Acceptance Tests

### ST-level

_(no tests in this group)_

### Group 01

- AT-01.1 (legacy) test/cdsync.bats::"a target file absent from the drop survives the import" -- covers AC-01.1 -- status: green
- AT-01.2 (legacy) test/cdsync.bats::"import leaves an unmentioned path standing where install removes it" -- covers AC-01.1 -- status: green
- AT-01.3 (legacy) test/cdsync.bats::"a repo-authored addendum survives the import" -- covers AC-01.2 -- status: green
- AT-01.4 (legacy) test/cdsync.bats::"addenda is declared protected in the drop contract" -- covers AC-01.2 -- status: green
- AT-01.5 (legacy) test/cdsync.bats::"a generated site survives the import" -- covers AC-01.3 -- status: green

### Group 02

- AT-02.1 (legacy) test/cdsync.bats::"site --build generates a page without serving" -- covers AC-02.1 -- status: green
- AT-02.2 (legacy) test/cdsync.bats::"site refuses a target that is not a drop" -- covers AC-02.2 -- status: green
- AT-02.3 (legacy) test/cdsync.bats::"new, brief, import, check and site compose end to end" -- covers AC-02.1 -- status: green

### Group 03

- AT-03.1 (legacy) test/cdsync.bats::"check refuses a target that is not a drop" -- covers AC-03.2 -- status: green
- AT-03.2 (legacy) test/cdsync.bats::"check refuses when assets/ holds files rather than slug directories" -- covers AC-03.2 -- status: green
- AT-03.3 (legacy) test/cdsync.bats::"check refuses an assets/ that exists but is empty" -- covers AC-03.2 -- status: green

---

_Generated by Intent v3.0.0 from `thread.json`. Do not edit this file -- it is rendered from the model, and `intent doctor` reports any hand-edit as skew._
