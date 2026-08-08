# Tasks - ST0003: Post-release 0.1.0 clean-up

## Status

Created 2 August at the close-out of ST0001 and ST0002, to hold what those threads carried forward plus what the first cold round trip raised. **In flight since 6 August.**

**This file is the flat view and the sequencing. Every "why" lives in the work package's own `info.md`** -- if a line here needs a reason, the reason belongs there and this line should point at it.

## Start here, if picking this up cold

**Nothing here is unblocked.** As of 8 August every remaining item waits on an hv ruling or on transport, and **guessing at a ruling is how this project has generated its worst work.**

## Tasks

### Done

- [x] **WP-01 -- Cut 0.1.0.** Done 6 Aug, 8/8. Running it for real found two defects in `release` itself
- [x] **WP-07 -- Gyre & Gymble, Baize and snorkeltoast.** All three were **already integrated**, in three different idioms. The premise was false in every project it could be checked against
- [x] **WP-08 -- Downloads.** All five directories cleared deliberately; hv ruled 8 Aug and the "it stays" instruction is withdrawn
- [x] **WP-08 -- `brief` cannot express a repackaging round.** Closed by `round_job` plus a measured list of which ordered assets the target already holds
- [x] **WP-08 -- The taxonomy count in `brief`'s refusal.** It said fifty-one against a taxonomy of 52; computed now, and stated in no prose anywhere

### Waiting on a ruling from hv

- [ ] **WP-08 -- `brief` cannot order a slug the library does not hold.** **Blocked on WP-05**, not unblocked as this file said until 8 Aug: the round must be told what `spec_version` to stamp on an asset it is creating
- [ ] **WP-08 -- Decide on the stale-document advisory rule.** Unasked scope, so it needs asking for or declining on the record. **Its reach is already settled either way** -- scoped to the design tree it reports clean on a provably stale document
- [ ] **WP-08 -- Baize's `BOOTSTRAP-CD.md`.** Not the commit it once needed -- it was swept into the rename commit and has gone stale again. **Needs a decision, because regenerating by hand is what did not hold**

- [ ] **WP-02 -- Rule 4, twice:** the hex-approximation question, and a colour named in order to forbid it
- [ ] **WP-05 -- Where a venture's `cdsync.json` lives**, and **`spec_version` for a NEW asset**. Asked by four projects in four shapes
- [ ] **WP-06 -- Lamplight `ref` splitting.** The only open ruling that could move paths; **gates Lamplight in WP-07**
- [ ] **WP-06 -- The other six round-three rulings**, plus finding 5: is `formats_required` a narrowing of done, or advisory?

### Waiting on transport from hv

- [ ] **WP-04 -- Six documents written and unsent:** three port briefs, Acme round two, `round-5-answer.md`, and the two protocol documents
- [ ] **WP-04 -- Install the three conversions** once they return, then clear the vestigial paths
- [ ] **WP-05 -- Regenerate every `BOOTSTRAP-CD.md`** after any generator change from the rulings above

### Not on this list

- **WP-08 -- Report Intent's baked absolute path** in `.claude/settings.json`. **An upstream issue against Intent, not work in this thread**, and it will sit here forever if it stays on a Cdsync list

### The library

- [ ] **WP-03 -- Write specs as orders need them.** **`cdsync doctor` prints how many are unspecified; this line does not**
- [ ] **WP-03 -- `pattern-library`: the spec AND the exemplar re-pointed in one change**, or library text goes false and a test goes red
- [ ] **WP-03 -- Repair the three library-text inconsistencies together**, behind a `spec_library_version` bump
- [ ] **WP-03 -- Decide what a library-version bump means** for drops already stamped against the old one

## Dependencies

```
WP-01                           ->  independent, and done
WP-07  --(Lamplight only)-->        WP-06 ruling
WP-08  --(one gap only)-->          WP-05 spec_version ruling
WP-08  --(two items)-->             hv, to order or decline
WP-03  --(ordering mechanism)-->    WP-05
WP-04  --(transport)-->             hv
WP-02, WP-05, WP-06  -->            hv rulings
```

**`WP-01, WP-08 -> independent` is what this graph said until 8 August, and WP-08 was not.** Its `brief` gap needs the round told what `spec_version` to stamp on an asset it is creating, which is WP-05's ruling exactly. **Nothing had traced it**, so the item read as unblocked for six days. **A dependency nobody has followed is not an absent dependency** -- and this graph is the place that was supposed to know.

## Task Notes

**Do not write the acceptance contract yet.** An empty contract reads as BLOCKED and `intent st done` refuses to close on it -- that is the gate working, and it is what forced ST0001 and ST0002 to earn their closes. Write the ACs when the scope is real, and **never write ACs to match what happens to have been done**: shrinking scope needs the owner.

**When ATs are written, verify each named test exists.** ST0001's first draft cited eleven and eight were invented. A contract naming a missing test is worse than an empty one, because the gate counts it as covered. `test/cdsync.bats` now guards this for every contract in the repository.

**A stated boundary is not a checked one.** ST0004 closed 11/11 on a bar naming "the four siblings that carried the name" and two more carried it. **When an AC names a set, say what enumerated the set.**
