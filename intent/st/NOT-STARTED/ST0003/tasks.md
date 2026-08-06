# Tasks - ST0003: Post-release 0.1.0 clean-up

## Status -- created 2 August 2026, not started

Created at the close-out of ST0001 and ST0002 to hold what those threads carried forward, plus what the first real cold round trip raised. **Detail lives in each work package's `info.md`; this file is the flat view and the sequencing.**

## Start here, if picking this up cold

**Three work packages are unblocked and can be started today**: WP-01 (cut the release), WP-07 (integrate the original four), WP-08 (housekeeping). Everything else is waiting on a ruling or on transport, and **guessing at a ruling is how this project has generated its worst work**.

## Tasks

### Unblocked

- [ ] **WP-01 -- Cut 0.1.0.** `cdsync release` has never been run for real. Dry run passes every gate; `cut` will not push without `--push`
- [ ] **WP-07 -- Integrate Gyre & Gymble.** Cdsync-shaped, `tokens.json`, `check` clean at 17 assets. Nothing in the way; do it first so any process problem surfaces cheaply
- [ ] **WP-07 -- Integrate Baize and snorkeltoast** by reading. `check` refuses on both because their tokens sit outside `kit/`; that is expected, not a blocker
- [ ] **WP-08 -- Commit Baize's regenerated `BOOTSTRAP-CD.md`** once that repository's own uncommitted work is clear
- [ ] **WP-08 -- Report Intent's baked absolute path** in `.claude/settings.json` upstream. Cdsync's is fixed and guarded; Baize's and Lamplight's still carry theirs
- [ ] **WP-08 -- Decide on the stale-document advisory rule.** It has bitten twice, once with no local symptom at all. Cheap. Unasked scope, so it needs asking for or declining on the record

### Waiting on a ruling from hv

- [ ] **WP-02 -- Rule 4, the hex-approximation question.** Fourteen of matthewsinclair's fifteen findings. Either `tokens.json` publishes the approximations, or the rule learns that a value tabulated beside its token is documentation, or the column goes
- [ ] **WP-02 -- Rule 4, a colour named in order to forbid it.** `colour.md:31`, *"never `#000`"*. Note the fence-versus-inline-span distinction before reaching for the existing code-span exclusion
- [ ] **WP-05 -- Where a venture's `cdsync.json` lives** when Cdsync does not own the repository. Blocks scope coming from `brief` rather than by hand, and blocks `Acme/cdsync.json`
- [ ] **WP-05 -- `spec_version` for a NEW asset.** Asked by four projects in four shapes. matthewsinclair's thirteen assets all carry `unassigned`
- [ ] **WP-06 -- Lamplight `ref` splitting.** The only open ruling that could move paths; **gates Lamplight integration in WP-07**
- [ ] **WP-06 -- The other six round-three rulings.** snorkeltoast classification placement, G&G `hard_facts`/`bundles`, G&G `print-collateral` downgrade, Baize `tiles/`, Baize ADRs, Lamplight working renders
- [ ] **WP-06 -- Finding 5:** is `formats_required` a narrowing of done, or advisory? Two suppliers independently concluded an asset can be complete without its formats

### Waiting on transport from hv

- [ ] **WP-04 -- Send the three port briefs** (Lamplight, Baize, snorkeltoast). Written and complete. G&G needs none
- [ ] **WP-04 -- Send Acme round two** and `round-5-answer.md`, both assembled and unsent
- [ ] **WP-04 -- Send the two protocol documents**, both self-contained
- [ ] **WP-04 -- Install the three conversions** once they return, then clear the vestigial paths
- [ ] **WP-05 -- Regenerate every `BOOTSTRAP-CD.md`** after any generator change from the rulings above

### The library

- [ ] **WP-03 -- Write specs as orders need them.** 25 of 52 slugs unspecified; the library grows one order at a time by ratified design
- [ ] **WP-03 -- `pattern-library`: write the spec AND re-point the exemplar in one change.** `specs/library.md` names it as the live example of an unwritten slug and a test pins the same invariant, so writing it alone makes library text false and turns the test red
- [ ] **WP-03 -- Repair the three library-text inconsistencies together**, behind a `spec_library_version` bump: `specs/kit.md` "fifty-one artefacts", `specs/library.md` "32 of the 50", and the `positioning`/`pricing` disagreement
- [ ] **WP-03 -- Decide what a library-version bump means** for drops already stamped against the old one

### Gaps recorded against `brief`

- [ ] **WP-08 -- `brief` cannot express a repackaging round**
- [ ] **WP-08 -- `brief` cannot order a slug the library does not hold.** Correct as a refusal, but it means a genuinely novel asset type cannot be ordered until WP-03 specifies it

## Dependencies

```
WP-01  ---------------------------------->  independent
WP-07  --(Lamplight only)--> WP-06 ruling
WP-08  ---------------------------------->  independent
WP-03  --(ordering mechanism)--> WP-05
WP-04  --(transport)--> hv
WP-02, WP-05, WP-06  --> hv rulings
```

**Nothing in this thread blocks the release.** WP-01 can happen first and probably should, because everything else is easier to reason about against a fixed baseline than against a moving `main`.

## Task Notes

**Do not write the acceptance contract yet.** An empty contract reads as BLOCKED and `intent st done` refuses to close on it -- that is the gate working, and it is what forced ST0001 and ST0002 to earn their closes. Write the ACs when the scope is real, and **never write ACs to match what happens to have been done**: shrinking scope needs the owner.

**When ATs are written, verify each named test exists.** ST0001's first contract draft cited eleven and eight of them were invented. A contract naming a missing test is worse than an empty one, because the gate counts it as covered. `test/cdsync.bats` now guards this for every contract in the repository, live or completed.
