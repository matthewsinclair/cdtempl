# Tasks - ST0003: Post-release 0.1.0 clean-up

## Status

Created 2 August at the close-out of ST0001 and ST0002, to hold what those threads carried forward plus what the first cold round trip raised. **In flight since 6 August; six of eight WPs closed on 9 August**, when hv's wind-back and rulings landed in one day.

**This file is the flat view and the sequencing. Every "why" lives in the work package's own `info.md`** -- if a line here needs a reason, the reason belongs there and this line should point at it.

## Start here, if picking this up cold

**One thing is live: WP-03.** Every question it needs is already ruled; it runs whenever hv wants the library text moved. WP-02 is parked by hv and is not to be picked up without hv re-opening it. Everything else is closed, with its record in its own `info.md`.

## Tasks

### Done

- [x] **WP-01 -- Cut 0.1.0.** Done 6 Aug, 8/8. Running it for real found two defects in `release` itself
- [x] **WP-04 -- Transport.** Closed 9 Aug by the wind-back: the queue died unsent, deliberately
- [x] **WP-05 -- `cdsync.json` and `spec_version`.** Ruled and built 9 Aug: the tree-root home, the `unassigned` lifecycle, ordering ahead of the library
- [x] **WP-06 -- Round three's rulings.** Dissolved 9 Aug to two survivors: `hard_facts`/bundles built into the brief; `formats_required` ruled advisory and queued into WP-03
- [x] **WP-07 -- Integrate the original four.** Closed 9 Aug on its finding: three of three checkable projects were already integrated; Lamplight unchecked by design
- [x] **WP-08 -- Housekeeping.** Closed 9 Aug: all six items done or declined on the record, the staleness advisory (shape (a)) the last to land

### Parked

- [ ] **WP-02 -- Rule 4's three noise shapes.** Parked by hv 9 Aug; evidence and recommendations on record in its `info.md`. Nothing moves until a live venture trips one

### Live

- [ ] **WP-03 -- The spec library.** The version-bump pass: three text inconsistencies, the ruled-advisory `formats_required` text, `pattern-library` written with its exemplar re-pointed in the same change. Plus specs as orders need them. **Runs on hv's word; nothing blocks it**

### Then

- [ ] **Write this thread's acceptance contract from the evidence and close it.** The contract stays deliberately unwritten until WP-03 lands -- an empty contract reads as BLOCKED, which is the gate working
