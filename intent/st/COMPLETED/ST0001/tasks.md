# Tasks - ST0001: Build the generic template suite and the four specifications

## Status -- 2 August 2026, end of day

**The tool is complete and v1 is closed out.** Ten commands, 328 tests, CI green on ubuntu-latest and macos-latest, shellcheck silent at default severity, and a `README.md` and MIT `LICENSE.md` that did not exist before.

Two commands were added on 1 August. **`cdsync init`** starts a design system in a repository that already exists -- the case `new` cannot serve, because `new` scaffolds a venture with its own repository and an agent contract the canon forbids inside a project. **`cdsync release`** versions, tags and packages, with pushing opt-in and the tarball built by `git archive` from the tag.

**Nothing has been released.** `VERSION` is `0.1.0`; a clean-tree `cdsync release cut minor --dry-run` passes every gate.

**2 August closed the loop the thread was built to serve.** Two cold trees went out to Claude Design and came back, and installing them exercised the whole contract end to end for the first time -- brief, output structure, taxonomy and per-asset specs, all four of this thread's deliverables, against real returns rather than fixtures. **Both came back in the mandated shape**, which is the strongest evidence the output structure is expressible by a supplier working only from the generated document.

**Deferred to a successor thread, not abandoned:** Acme round two is assembled and unsent at `templates/_test/Acme/design/brief.md`, as is `round-5-answer.md`. `Acme/cdsync.json` wants filling and four slugs re-ordering. And **25 of 52 taxonomy slugs have no spec** -- `pattern-library` is blocked rather than queued, because `specs/library.md` names it as the live exemplar of an unwritten slug and a test pins the same invariant, so writing it makes library text false. **The spec library is designed to grow one order at a time; a full 52 was never this thread's bar** -- see `acceptance.md`, which ratifies the boundary.

## Done

- [x] Settle the model: two asymmetric surfaces, brief out, zip back, `$CDSYNC_TARGET` as the whole output boundary
- [x] Write the brief to Claude Design (`cd-brief.md`), self-contained
- [x] Round one -- taxonomy (51 types, grouped by precondition), priorities, per-asset specs, the neutral kit, output structure, dependencies, bundles, brief contract
- [x] `bin/cdsync` skeleton: dispatcher, `lib/` modules, real target resolution, real `doctor`, `atomic_write`
- [x] Round two -- the probe: neutral kit plus one Form C asset (pitch deck), structure validated end to end
- [x] Round three -- `vendor/`, declaration-based exclusion, two more assets, stopped correctly at the composite break
- [x] Round four -- seven assets built; ten of eleven Tier 1 assets present, the eleventh being `kit/`
- [x] Five `cdsync check` rules settled, every one earned by a real failure rather than imagined
- [x] **Rule 6, `classification`, added 31 July** -- advisory by ruling, because blocking would make it the delivery filter the classification ruling forbids. Six rules now; 1 and 4 block
- [x] **`cdsync init` and `cdsync release`** (1 Aug), taking the command set to ten
- [x] **Rule 4 taught the modern colour spaces** (2 Aug) -- `oklch()`, `oklab()`, `lch()`, `lab()`, `color()`, compared as normalised text and deliberately not converted to hex. A kit it cannot read makes the rule unrunnable, and it now says so rather than reporting clean
- [x] **`specs/` -- the spec library, on this side.** The structural gap: specified since round one, but it had only ever existed inside `templprj`
- [x] **The five commands, all real.** `new`, `brief`, `import`, `check`, `site` -- every one was a stub exiting non-zero
- [x] Round five findings back to Claude Design (`round-5-answer.md`)
- [x] **Both defects the first real run found.** Partial bundles are orderable and
      declare their own gaps; `cdsync new` commits the scaffold

## As built

Five shared modules, each with exactly one job, because more than one command
needs each of them:

| Module | Owns |
| ------ | ---- |
| `lib/frontmatter.sh` | THE front-matter reader: `fm_get` / `fm_list` / `fm_has` / `fm_set` |
| `lib/config.sh` | THE `cdsync.json` reader -- `target.sh` no longer parses it itself |
| `lib/specs.sh` | The spec library: its walker, the bundles, the taxonomy |
| `lib/drop.sh` | The shape of a drop; the owned-path list has its single definition here |
| `lib/scan.sh` | Blank counting and colour scanning -- the facts the rules are applied to |

`lib/cmd_check.sh` applies the rules and renders. It computes nothing itself.

Deliberately not yq. Every field the tool decides on is a scalar, and the only
nested structure -- `depends_on` -- is read for reporting rather than for control
flow. A hard dependency on yq to parse what awk handles in twenty lines would buy
nothing and cost an install step on every machine that runs `check`.

## Gates, as of 2026-07-29

| Gate | Result |
| ---- | ------ |
| `bats test/cdsync.bats` | **143 / 143** (was 28) |
| `intent critic shell --files lib/*.sh bin/cdsync test/cdsync.bats` | clean, 15 files |
| `cdsync doctor` | clean |
| `cdsync check --target templates/claude_design/templprj` | 11 assets, clean, 3 advisory |

The 143 includes one test that chains `new` -> `brief` -> `import` -> `check` ->
`site` through a scaffolded venture, an assembled brief and a real drop.

**The suite once reported 54 failures that were one bug.** `run_lib` sourced its
libraries through a path in single quotes, so the loop variable never expanded and
every library silently failed to load -- which reads exactly like 54 broken
functions. Worth remembering next time a whole category of tests goes red at once:
suspect the harness before the code.

That run also contained a false pass. `a target that walks out of the repo is
reported as outside it` asserts a non-zero status, and a broken `run_lib` returned
non-zero for the wrong reason. A test that passes because its harness is broken is
worse than one that fails.

## What running it found

Six things, none of which more specification would have produced.

1. **All three hand-declared blank counts were wrong.** 70/47 not 64/45. 72/39 not
   58/54. 52/26 not 62/31. The `positioning` one was already arithmetically
   implausible on its face -- 54 unique out of 58 occurrences -- and is really 39 of
   72.
2. **Rule 3 was unrunnable as specified.** Six advisories on first run, all six
   false positives. Two exclusions were missing: a number inside a blank is not a
   claim, and a number in a stylesheet is not a metric.
3. **Rule 4 needed alpha zero excluded.** `rgba(0,0,0,0)` is `transparent` spelled
   long-hand, carries no hue, and appears in seven of the ten artefacts.
4. **Two declared dependency slugs do not exist** -- `positioning` and `pricing`.
   Found by the tool on its first run, not by anyone reading.
5. **`is_generated_file` accepted a bare `*` as a comment opener**, which silently
   re-exempted the two READMEs the round-three fix had just started checking. Found
   by reading, not by running -- the tests agreed with the bug.
6. **The bundles had to be redefined over slugs**, because `positioning-icp-personas`
   is one deliverable covering taxonomy numbers 1, 3 and 4.

## The loop ran end to end, on a real venture

`Acme` round one is in and imported. The tool held: `import` wrote only the five
owned paths, `check` passed every rule on a drop it did not produce, and the one
deletion was `design/kit/.gitkeep` giving way to a real kit.

**The drop contains almost nothing about Acme, and Claude Design named that as the
finding rather than the failure.** `cdsync.json` still carried the placeholder
`one_liner` with `fixed` and `open` empty, and `invention: leave blanks`, so the only
honest deliverable was the template suite with Acme's name on it -- 212 blanks. It
built that anyway to find out what `import` and `check` do with a drop they did not
produce, which was the right call: eight findings came back, most of them defects
here rather than in the drop.

### Four applied, no ruling needed

1. **A blank beginning with a currency symbol was invisible to the check.** Six in
   the pitch deck -- TAM, SAM, SOM, CAC, traction, the ask -- so `blanks: 0` was
   declarable while the four numbers most likely to be acted on were placeholders.
   Rule 1 passed the asset *because* the check could not see what it exists to see.
   The symbol set now matches the one rule 3's metric matcher already used, so the
   two rules in `scan.sh` agree; before, `[$0.0m]` was invisible to one while
   `$1.2M` was visible to the other.
2. **The brief now carries the kit in full, ordered or not.** It promised nothing in
   it points at a file the reader cannot open, then required `kit/kit.md` and
   inlined it only when `kit` happened to be ordered -- so `kit_version` was a stamp
   with nothing behind it. Claude Design complied only because it still holds the
   library. An instance holding just the brief would have invented a kit, which is
   the artefact whose whole purpose is preventing invention. Where the target has
   `tokens.json` the real values go in, so later rounds restate rather than reinvent.
3. **Unmet hard dependencies are declared**, extending the partial-bundle rule one
   level up: satisfied by the order, present in the target, or stated in the brief.
   Declared rather than refused -- what an asset inherits absent a colour system is
   the neutral kit, and that has to be a choice rather than a default nobody noticed.
4. **The structure no longer asks for `brief.md` to be echoed back.** It was
   requested eleven lines above the statement that `brief.md` is not a path a drop
   owns, so `import` discarded it -- correctly, since the venture wrote it and a
   second copy of the order can disagree with the first.

### Still open

- [ ] **Finding 3 -- the counts disagree by one.** Claude Design gets 71/48 on the
      unmodified round-four deck against 70/47 here. The currency fix adds six to
      both readings, so the disagreement stands. Its full ordered 71-item list is in
      `Acme/design/RETURN.md`; diff it against ours and the culprit falls out. This
      matters more than its size: a computed count is only canonical if the rule has
      exactly one reading, and this one has at least two
- [ ] **Finding 5 -- `formats_required` can contradict a definition of done.**
      `[pdf]` against the deck's DoD item 7, which requires both exports to
      regenerate. Either it narrows the DoD -- and `check` has to know it does, or
      rule 1 fails an asset for obeying its brief -- or it is advisory and should not
      sit in the header looking binding. **hv ruling needed**
- [ ] **Finding 6 -- `audience` is two fields wearing one name.** The library's
      "which audiences can this serve" versus the venture's "which copy am I
      making". Both `whos-who-in-the-zoo` and `product-one-pager` name
      producing-one-for-both as their characteristic failure, and the brief orders
      exactly that. **hv ruling needed**
- [ ] **Finding 8 -- `support.js` is regenerable runtime outside `vendor/`.** The
      exception is forced: the runtime must be a sibling of the `.dc.html` that loads
      it. Mostly a wording fix in Claude Design's `kit.md`
- [x] **Fill `Acme/cdsync.json` and re-order the same four slugs.** Done, and it is the
      result this thread was for: **212 blanks with placeholder facts, 73 with real
      ones.** Same four assets, same tool, same supplier. Statuses stopped being
      uniform too -- `positioning` complete with 2 blanks, the zoo template complete
      but roster-blocked, the deck a 30-blank draft. The brief carries a venture
- [ ] **Send Acme round two.** Assembled and unsent at
      `templates/_test/Acme/design/brief.md`, 1104 lines. It states the `spec.md`
      front-matter contract and carries round one's kit as authoritative. Round one's
      drop is committed as it arrived, so the diff measures whether the contract took

### Round one's own findings, four applied

Claude Design returned eight findings, most of them defects here rather than in the
drop. Applied: the currency-symbol blind spot in the blank scanner; the kit inlined
into every brief; unmet hard dependencies declared; `brief.md` no longer echoed back.
Then a second pass closed the round trip -- **the brief demanded a `spec.md` front
matter it had never stated, and could not have, because its own rendering strips the
front matter it requires back.** `check` also no longer dies on a spec it cannot
stamp, and the neutral ramp became a default rather than a constraint so a decided
brand colour belongs in the kit. Fixing that last one exposed that rule 2 had never
run on the kit at all.
- [ ] Send round five (`round-5-answer.md`, unsent; transport is hv)
- [ ] `grid-and-layout` -- first in Tier 2, and a declared hard dependency of
      `component-library`

### Two defects found by the first real run, both now closed

**A partial bundle is orderable, and says so.** Every one of the seven bundles holds
at least one unspecified slug, so under the old refusal all seven failed -- the tool
advertised options that broke one command later.

The rule now distinguishes how a slug was asked for, because the two cases are not
the same ask:

| Asked for as | Unspecified in the library | Why |
| ------------ | -------------------------- | --- |
| a bare slug in `.order.assets` | **refused** | You named a particular thing that cannot be briefed. Trimming it would be the tool editing your order. |
| a member of a bundle | **omitted, and declared in the brief** | You named a group; its membership is the library's business, not yours. Refusing punishes you for the library being incomplete. |

The declaration is the load-bearing half. A partial seed set is a different ask from
a whole one, and a reader who is not told infers the absences were deliberate scope
and designs around them -- so the brief carries a *Not in this drop, and asked for*
table plus the instruction to leave the blank rather than let a neighbouring asset
absorb it. An absent asset silently covered by its neighbour is the hardest kind of
scope drift to find later.

Making that decidable is why `expand_order` emits `slug<TAB>origin` rather than a
bare slug list. The library knows which of the two ways a slug arrived; only the
command can rule on what to do about it. Attribution deliberately does **not** use
first-reached: bundles expand before bare assets, so a slug the venture named itself
would be credited to whichever bundle got there first and quietly dropped -- the
exact failure the origin field exists to prevent. It is pinned by test.

`new` now reports `complete` / `partial` / `empty` per bundle with counts, so the
choice is made with the numbers in view. All seven currently read partial.

**`cdsync new` commits the scaffold.** `git init` alone leaves an unborn HEAD, so
`git log`, `git diff` and `git show` all failed in a fresh venture -- the first thing
anyone runs made the scaffold look broken. It is also the commit worth having: the
boundary between what the tool wrote and what the venture decided, which is the diff
a round-one review actually wants.

Identity is deliberately not forced. Overriding `user.name` to get the commit through
would attribute a venture's first commit to a fabricated author, so a failure warns
and leaves the scaffold staged for the human. The test suite supplies its own
identity through `GIT_AUTHOR_*` rather than relying on the machine's global config,
which also stops a real name landing in throwaway commits.

## The six check rules

1. `status` against blank count -- `complete` with non-zero blanks is a contradiction. **Blocking**
2. Stamped `spec_version` against the library, to detect staleness
3. Illustrative numbers visibly marked **in the artefact**, not merely understood in conversation
4. Every colour literal, excluding files declaring themselves generated **in a comment**, must appear in `kit/tokens.json`. **Blocking**
5. `status: partial` requires `coverage`; `complete` requires coverage to be total
6. `classification` is declared, and not conflated with `audience`

Only 1 and 4 block. Rule 4 is the leak guard -- it makes neutrality a property of
the repository rather than of whoever last touched a file -- and rule 1 is a drop
lying about its own state. The rest are worth knowing and not worth stopping for.

**Rule 4's reach is part of the rule**, and the published one-line summary above
does not carry it. It reads `#hex`, `rgb()`, `rgba()`, `hsl()`, `hsla()`,
`oklch()`, `oklab()`, `lch()`, `lab()` and `color()`. `rgb()` collapses to hex;
the modern functions compare as normalised text and are deliberately **not**
converted, because approximate agreement is worse than none for a leak guard.
A kit carrying no form on that list does not pass rule 4 -- **it makes the rule
unrunnable, and the run says so rather than reporting clean.** Full statement in
`help/check.md`, guarded by a test against `CDSYNC_COLOUR_RE`.

`blanks` and `blanks_unique` are **computed by the tool, not declared**. Scope is
written in `templprj/kit/kit.md`, and implemented exactly as written.

## Dependencies

`check` needs `jq`, `import` needs `unzip`, `site` needs `python3`. All three are
gated once in `doctor` and once more at the point of use, never per-iteration.
