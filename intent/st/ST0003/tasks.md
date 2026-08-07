# Tasks - ST0003: Post-release 0.1.0 clean-up

## Status

Created 2 August at the close-out of ST0001 and ST0002, to hold what those threads carried forward plus what the first cold round trip raised. **In flight since 6 August.**

**This file is the flat view and the sequencing. Every "why" lives in the work package's own `info.md`** -- if a line here needs a reason, the reason belongs there and this line should point at it.

## Start here, if picking this up cold

**Unblocked right now: the rest of WP-07, and all of WP-08.** Everything else waits on a ruling from hv or on transport, and **guessing at a ruling is how this project has generated its worst work.**

## Tasks

### Unblocked

- [x] **WP-01 -- Cut 0.1.0.** Done 6 Aug, 8/8. Running it for real found two defects in `release` itself
- [x] **WP-07 -- Gyre & Gymble.** Done 6 Aug. **Already integrated**; what was missing was a check that the theme still agrees with the kit. 61 of 62 tokens, zero disagreements
- [ ] **WP-07 -- Baize and snorkeltoast**, both by reading. `check` refuses on both because their tokens sit outside `kit/`; expected, not a blocker
- [ ] **WP-08 -- Commit Baize's regenerated `BOOTSTRAP-CD.md`** once that repository's own uncommitted work is clear
- [ ] **WP-08 -- Report Intent's baked absolute path** in `.claude/settings.json` upstream
- [ ] **WP-08 -- Decide on the stale-document advisory rule.** Unasked scope, so it needs asking for or declining on the record. **Now earned four times, not two**
- [ ] **WP-08 -- The two gaps recorded against `brief`:** it cannot express a repackaging round, and it cannot order a slug the library does not hold

### Waiting on a ruling from hv

- [ ] **WP-02 -- Rule 4, twice:** the hex-approximation question, and a colour named in order to forbid it
- [ ] **WP-05 -- Where a venture's `cdsync.json` lives**, and **`spec_version` for a NEW asset**. Asked by four projects in four shapes
- [ ] **WP-06 -- Lamplight `ref` splitting.** The only open ruling that could move paths; **gates Lamplight in WP-07**
- [ ] **WP-06 -- The other six round-three rulings**, plus finding 5: is `formats_required` a narrowing of done, or advisory?

### Waiting on transport from hv

- [ ] **WP-04 -- Six documents written and unsent:** three port briefs, Acme round two, `round-5-answer.md`, and the two protocol documents
- [ ] **WP-04 -- Install the three conversions** once they return, then clear the vestigial paths
- [ ] **WP-05 -- Regenerate every `BOOTSTRAP-CD.md`** after any generator change from the rulings above

### The library

- [ ] **WP-03 -- Write specs as orders need them.** 25 of 52 slugs unspecified
- [ ] **WP-03 -- `pattern-library`: the spec AND the exemplar re-pointed in one change**, or library text goes false and a test goes red
- [ ] **WP-03 -- Repair the three library-text inconsistencies together**, behind a `spec_library_version` bump
- [ ] **WP-03 -- Decide what a library-version bump means** for drops already stamped against the old one

## Dependencies

```
WP-01, WP-08                    ->  independent
WP-07  --(Lamplight only)-->        WP-06 ruling
WP-03  --(ordering mechanism)-->    WP-05
WP-04  --(transport)-->             hv
WP-02, WP-05, WP-06  -->            hv rulings
```

## Task Notes

**Do not write the acceptance contract yet.** An empty contract reads as BLOCKED and `intent st done` refuses to close on it -- that is the gate working, and it is what forced ST0001 and ST0002 to earn their closes. Write the ACs when the scope is real, and **never write ACs to match what happens to have been done**: shrinking scope needs the owner.

**When ATs are written, verify each named test exists.** ST0001's first draft cited eleven and eight were invented. A contract naming a missing test is worse than an empty one, because the gate counts it as covered. `test/cdsync.bats` now guards this for every contract in the repository.

**A stated boundary is not a checked one.** ST0004 closed 11/11 on a bar naming "the four siblings that carried the name" and two more carried it. **When an AC names a set, say what enumerated the set.**
