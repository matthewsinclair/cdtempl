# cc -- 9 August 2026: the wind-back, and six WPs closing in a day

The morning arrived at "nothing is unblocked; everything waits on hv" and presented
the ruling queue. hv answered all of it in three exchanges, and by evening six of
eight work packages were closed, one was parked, and nothing was awaiting hv at all.

## The rulings, in the order they landed

1. **The wind-back** -- the day's biggest. The delivered projects are delivered; the
   cdsync loop earns its keep for a few rounds while a design system beds down, and
   after that the tree is a record of what was asked for. No more syncing to the four
   delivered projects; rare as-needed rounds only. Dissolved WP-04 (the transport
   queue died unsent), most of WP-06, and WP-07's Lamplight leg.
2. **`cdsync.json` lives at the design tree root, always** -- hv's answer dissolved a
   question WP-05 had framed as a choice. One home for `new` ventures and `init`
   projects alike; the `.target` field retired as circular.
3. **`spec_version` for a new asset** -- made precise as `unassigned` (per-slug,
   literal), with the round-level `spec_library_version` stamp the brief already
   carried. Confirmed after the two-counters-colliding hazard was laid out.
4. **WP-02: "Park."** Rule 4's three noise shapes stay recorded with recommendations.
5. **The staleness advisory: shape (a)** -- after two rounds of "I don't get it," the
   explanation that landed was the from-zero story (the snapshot, the high-water
   marks, the collision that cost an export cycle). A warning in `doctor` and
   `check`, never blocking; the regenerate-as-byproduct shape (b) was offered and
   declined.
6. **`formats_required`: advisory.** Queued into WP-03's version-bump pass.
7. **Baize's 96%/95% divergence: "leave it."** No addendum.

## What was built

**The WP-05 build** (commit `c92b83b`, 31 files): resolution probes
`design/system/` then `design/` and the file's own directory IS the target;
`config_path` became the single owner of the default chain after the helpers'
own `${2:-$PWD}` defaults silently overrode it (the brief cluster failing 39
tests at once is what surfaced it); `new` scaffolds `cdsync.json` into the tree
and `init` writes the stub -- which is what makes `brief` runnable for a project
Cdsync does not own; the file joined `CDSYNC_DROP_PROTECTED_PATHS` and the
refused-deliveries list; bootstrap's cold/warm measure and inventory learned to
skip it; a named in-taxonomy slug with no spec orders ahead of the library
(outside the taxonomy still refuses -- the taxonomy is the identity space);
rule 2 learned the whole `unassigned` lifecycle plus a non-numeric-stamp guard;
the brief now states `hard_facts` and bundle membership per specification -- the
two fields it asked back and never supplied.

**The staleness advisory** (commit `9e6b493`): `report_bootstrap_staleness` in
`lib/scan.sh`, one definition, called by `doctor`'s target section and `check`'s
preamble before the shape gate (the poster cases are the trees the asset walk
refuses). Repository-scoped; tracked and untracked-unignored files only, so
`_build/` churn cannot cry wolf. Deliberately not rule 7: the six rules judge
what Claude Design delivered, this judges Cdsync's own output.

**Field actions**: Intent issue `0016` filed and committed upstream (`95f4da2` in
Intent) for the `[[INTENT_HOME]]` absolute path baked into `.claude/settings.json`;
Baize's `BOOTSTRAP-CD.md` regenerated and committed (`7211fc1` in Baize, explicit
pathspec, hv's `mix.lock` untouched) -- which caught an unrecorded second drift,
the ADR series at 0035 against a recorded 0030. Acme migrated in its own nested
repository (`91e9408`, `adc50f2`): `cdsync.json` to `design/`, `.target` removed,
round-2 brief regenerated against library v3.

## Evidence discipline

Suite 342 -> 357 across the day, green at every commit; shellcheck clean. Five
mutation cycles, each with landing proof: the taxonomy gate, the rule-2
unassigned branch, the probe order, the protected list, and the staleness
probe's direction. **The staleness mutation refused to land twice first** --
once on the sed-`||`-delimiter trap and once on `$` read as a regex anchor,
both shapes already on the board's watch-out list; the awk-by-line-number +
`grep -F` form landed and killed exactly its test. ST0001's AT-01.2 was the one
contract citation the behaviour change invalidated; it carries a dated
supersession note pointing at the successor test.

## End state

ST0003: WP-01, 04, 05, 06, 07, 08 Done; WP-02 parked; WP-03 the one live edge,
every question it needs already ruled. Unpushed at fold: three commits in
Cdsync (`bcdddb2`, `c92b83b`, `9e6b493`), one in Baize, one in Intent, two in
Acme. Nothing awaits hv; the next thing that will is WP-03's version-bump pass,
whenever hv wants the library text moved.
