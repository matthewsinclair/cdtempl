---
verblock: "02 Aug 2026:v0.2: matts - Ratified boundary written from the as-built at close-out"
st_id: ST0002
title: "Port four established projects to the Cdsync protocol -- acceptance contract"
---

# ST0002 Port four established projects to the Cdsync protocol -- Acceptance

> Canonical acceptance contract for ST0002. Acceptance Criteria (AC) are the ratified completeness boundary; Acceptance Tests (AT) are the small red-to-green tests that prove them. Real test code lives in the suite (paths cited below); this file is the contract plus the AC-to-AT coverage map plus live status. info.md / WP info.md reference this file and never restate ACs (one home).
>
> Done = every AC is covered by a GREEN AT, or (for a non-test AC) its named evidence is satisfied, AND the AC set is the ratified full boundary. Done is read from this map, never from a hand-ticked box.
>
> Change control: clarifying an AC or AT is verifier-and-builder; shrinking scope, or weakening an AT to make it pass, needs the owner.
>
> AT status vocabulary: to-write (red-first) | red | green | n/a (non-test: doc / eyeball / gate).
>
> Non-test ACs carry their state inline -- `-- evidence: <ref> -- satisfied: yes|no` on the AC line; test-backed ACs are satisfied by a green covering AT (computed, never written). Multi-AC coverage on an AT is comma-separated.

## The boundary, stated before the criteria

This thread's objective (`info.md`) is that four established projects each **hold a design-system record under the Cdsync protocol at `design/system/`**, delivered by Claude Design and installed by the tool, browsable and servable locally -- under one constraint that outranks everything else in the thread: **nothing that already exists may be lost.**

That is what is being ratified. It is deliberately **not** the same as "every one of the four passes `check` with zero findings", and the distinction is load-bearing rather than convenient:

- **`check` is a check on a DROP's shape**, and three of the four carry a design convention that predates Cdsync and is more mature than anything Cdsync models -- three representations from one canonical source, with a reading room and a confidentiality split. Their tokens sit outside `kit/` and their assets are not `assets/<slug>/spec.md`, so `check` refuses with `0 assets checked`. **That is the tool being honest about a tree it cannot read, not the port having failed.**
- **Converting those trees into the checkable shape is its own round**, by the 31 July ruling that *a conversion is its own round and arrives with its own brief*. The three briefs are written. Sending them is hv's, and a thread cannot be gated on transport it does not control.

**Explicitly outside this boundary, and carried forward rather than dropped:**

- Sending `port-brief-lamplight.md`, `port-brief-baize.md` and `port-brief-snorkeltoast.md`. Written and unsent; transport is hv's.
- The conversion itself, and clearing the vestigial paths afterwards. Blocked on the above.
- Six hv rulings listed on the `cc` board under `## Wants hv`, none of which blocks the others.
- Integration -- the projects building against their design systems. Unblocked and independent; Cdsync has no application-side check by design.

## Acceptance Criteria

### ST-level

- AC-00.1 (non-test) All four projects hold a design-system record at `design/system/`, installed by the tool rather than by hand, and committed -- evidence: Lamplight, Baize, gyreandgymble and snorkeltoast all installed and committed by 31 Jul; `intent/st/ST0002/tasks.md` carries the per-project table -- satisfied: yes
- AC-00.2 (non-test) **Nothing that already existed was lost.** Every deletion is accounted for against the supplier's own statement of what it delivered -- evidence: every deletion matched a sentence in that project's `RETURN.md` -- Lamplight 42, Baize 8, snorkeltoast 4 plus six renames, G&G 0; read from `git status` after each install rather than from the install plan -- satisfied: yes

### WP-01 -- Deliver the record (status: complete)

- AC-01.1 An install preserves anything the drop does not carry, so a port cannot silently drop pre-existing material
- AC-01.2 Repo-authored material inside the target survives an install by declaration, not by luck
- AC-01.3 A generated site is not eaten by the next round
- AC-01.4 (non-test) The two projects that had never been extracted were extracted straight into Cdsync's shape, rather than extracted twice -- evidence: `extract-brief-gyreandgymble.md` and `extract-brief-snorkeltoast.md` were written before any extract ran, which was the stated precondition in `info.md` -- satisfied: yes

### WP-02 -- Make it browsable (status: complete)

- AC-02.1 A design system tree renders to a browsable site from its own repository, without serving
- AC-02.2 The generator refuses a target that is not a drop, rather than producing an empty site
- AC-02.3 (non-test) Each of the four carries a manifest -- evidence: `index.md` landed in all four on 31 Jul; two had no manifest of any kind before it -- satisfied: yes

### WP-03 -- Hold the result honestly (status: complete)

- AC-03.1 (non-test) `check` was run against all four and the results recorded as measured rather than as hoped -- evidence: `check-against-all-four-drops.md`; G&G clean, Lamplight clean, Baize and snorkeltoast refusing with `0 assets checked` -- satisfied: yes
- AC-03.2 A tree the checker cannot read is refused rather than passed, so `0 assets checked` can never read as a clean bill
- AC-03.3 (non-test) The conversion needed to make the remaining trees checkable is specified and ready to send, not merely identified -- evidence: `port-brief-lamplight.md`, `port-brief-baize.md`, `port-brief-snorkeltoast.md`, all complete and unsent; G&G needs none -- satisfied: yes

## Acceptance Tests

> Every AT below names a test that exists, verified against the suite before this
> file was committed. ST0001's first draft cited eleven and eight were invented.

### WP-01

- AT-01.1 test/cdsync.bats::"a target file absent from the drop survives the import" -- covers AC-01.1 -- status: green
- AT-01.2 test/cdsync.bats::"import leaves an unmentioned path standing where install removes it" -- covers AC-01.1 -- status: green
- AT-01.3 test/cdsync.bats::"a repo-authored addendum survives the import" -- covers AC-01.2 -- status: green
- AT-01.4 test/cdsync.bats::"addenda is declared protected in the drop contract" -- covers AC-01.2 -- status: green
- AT-01.5 test/cdsync.bats::"a generated site survives the import" -- covers AC-01.3 -- status: green
- Coverage: AC-01.1 to AC-01.3 covered; AC-01.4 is non-test and carries its evidence inline.

### WP-02

- AT-02.1 test/cdsync.bats::"site --build generates a page without serving" -- covers AC-02.1 -- status: green
- AT-02.2 test/cdsync.bats::"site refuses a target that is not a drop" -- covers AC-02.2 -- status: green
- AT-02.3 test/cdsync.bats::"new, brief, import, check and site compose end to end" -- covers AC-02.1 -- status: green
- Coverage: AC-02.1 and AC-02.2 covered; AC-02.3 is non-test and carries its evidence inline.

### WP-03

- AT-03.1 test/cdsync.bats::"check refuses a target that is not a drop" -- covers AC-03.2 -- status: green
- AT-03.2 test/cdsync.bats::"check refuses when assets/ holds files rather than slug directories" -- covers AC-03.2 -- status: green
- AT-03.3 test/cdsync.bats::"check refuses an assets/ that exists but is empty" -- covers AC-03.2 -- status: green
- Coverage: AC-03.2 covered; AC-03.1 and AC-03.3 are non-test and carry their evidence inline.
