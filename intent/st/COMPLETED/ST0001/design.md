# Design - ST0001: Build the generic template suite and the four specifications

## Approach

Cdsync regularises the Claude Design process for problems that have recurred across several ventures. **Regular and predictable** first, **automated** second -- the first matters considerably more, and the second is only worth doing because it is now cheap. If the whole process were executed by hand and never scripted, the regularity would still be most of the value. That ordering drives the build order: specifications before machinery.

Four things get specified:

1. **The brief format** -- what Claude Design receives at the start of every venture.
2. **The output structure** -- the mandated directory layout it delivers into.
3. **The asset taxonomy** -- every design and venture asset type.
4. **The per-asset specification** -- what each type consists of, and its definition of done.

The fourth is the main event. A taxonomy gives an asset a name; a specification lets someone say whether the thing that arrived is finished. That is where predictability comes from, and no amount of automation substitutes for it.

**Two rounds.** Round one is text only -- taxonomy, priorities, specs, the neutral kit, the output structure proposal, dependencies, bundles, and what a brief must carry. Cheap enough to argue with. Round two builds the top handful into `templates/claude_design/templprj/`. The split matters because the build is expensive to redo if the specs turn out wrong.

**Built generically, in a fresh Claude Design project.** Building templates inside a live venture would bake that venture's direction into everything produced afterwards, and the bias would be invisible by the time anyone noticed. Retrofitting the finished process onto existing ventures comes later and is cheap.

## Design Decisions

### Claude Design is a supplier, not a peer

`cd` has no session loop in this repo, no heartbeat, and no ability to commit. Modelling it as a whiteboard node produces a board that never updates, which reads identically to a node that has not started work -- a misreading that cost a full round of confusion before the model settled. The `cd` node scaffolded on 2026-07-29 was retired to `intent/whiteboard/.archived/cd/`.

### Briefs are self-contained -- as a principle, not a workaround

`cd` is scoped to `templprj` and cannot see the rest of this repository. **That scoping is deliberate**, and it is a forcing function rather than a limitation to design around.

If `cd` could read the repo, briefs would drift toward being thin and reference-rich -- pointers to specs, to design docs, to steel threads. That would work now and break completely the day `cd` is scoped to a real venture, where Cdsync's internals genuinely are not visible. Holding the tighter constraint during bootstrap makes the brief format correct by construction.

It also defines what `cdsync brief` is actually for: **assembling a complete document from the spec library**, rather than emitting a list of pointers and hoping. With repo access it could be lazy in a way that would not survive production.

So the rule is not "cd cannot read" -- that is a fact about today's setup. The rule is "a brief carries everything its round needs," which holds whatever access happens to exist.

Getting this wrong three times in one afternoon is worth recording: `cd` was assumed first to be a peer that could commit, then a git-remote reader, then a live local mount. Each was inferred from this side rather than asked. **Treat any claim about this channel as provisional until `cd` confirms it.**

### Transport

Every lane passes through hv. There is no automated path in either direction.

| Direction | Payload | Mechanism |
| --------- | ------- | --------- |
| cdsync -> cd | the brief, plus whatever specs that round needs | hv supplies it |
| cd -> cdsync | taxonomy, specs, findings | copy/paste; hv pastes to `cc`, which files it |
| cd -> cdsync | artefacts (pdf, pptx, images) | zip export, download, `cdsync import` |

**Steady state differs from bootstrap.** In production `cd` is attached to a venture's `$CDSYNC_TARGET`, which contains `brief.md` -- so it reads the brief from the directory it is scoped to, and there is no upload step. Still self-contained: `cd` sees inside the target, never outside it. That is also why `cdsync brief` writes into the target rather than only emitting to stdout. The current upload is a bootstrap workaround, because today's "venture" is `templprj` sitting inside Cdsync.

### The mandated layout is a folder, not a description of one

`cd` builds a directory whose top level is exactly what drops into `$CDSYNC_TARGET`, and delivers it as a zip. `import` becomes an unzip. There is no second description of the shape and therefore nothing that can drift from it. (`cd`'s proposal.)

### The spec library lives on this side, version-controlled

`cd` authors the spec text; it is committed into Cdsync. Specs living only in `cd`'s output would fork the first time one was edited here -- and being scoped away from the repo, `cd` could never see that they had. (`cd`'s proposal.)

### Neutrality is enforced by a spec, not requested by an instruction

Asking `cd` to stay restrained across twenty artefacts is asking it to fight a tendency, and tendencies win. Instead: **one neutral kit that every template imports** -- greyscale ramp, one system font stack, no accent hue, visible placeholder treatment. "Is this too charming" becomes a question about one file rather than a judgement call across twenty. (`cd`'s proposal, and better than what was here first.)

The same reasoning applies to `templprj` itself: it must be boring on purpose. Every venture built from these templates inherits whatever character it has, and character inherited by default is character nobody chose.

### RETURN.md is mandatory at the top of every drop

With a required *revisions to understanding* heading, present-but-empty when there is nothing to say. Design and venture work inform each other reciprocally and non-linearly, so the most valuable thing in a round is sometimes a changed mind rather than an artefact. An optional section for it would be empty every time. (`cd`'s proposal.)

The same reciprocity is why the output structure must not imply an order of production, and why a brief carries both framings even when the ask is mostly design.

### Cdsync never writes into the application

The single most important structural rule. The entire output boundary is `$CDSYNC_TARGET`. If a step copies a design artefact into `assets/`, `priv/static/`, or `lib/<app>_web/`, it is wrong -- see Alternatives Considered.

### A venture lives in its own repo

`cdsync new <name>` creates it. A generated venture is not an Intent project in the full sense: it borrows `CLAUDE.md` / `AGENTS.md` as the agent contract but does not inherit `intent/st/`. A design drop has documents, not steel threads.

## Architecture

### The target boundary

`$CDSYNC_TARGET` defaults to `design/` but may point anywhere. **What is standardised is the structure underneath it, never the location.**

```
$CDSYNC_TARGET/
  RETURN.md              this drop's narrative -- mandatory
  brief.md               the order this drop answers, copied in verbatim
  index.md               manifest: every asset present, its status, its spec version
  kit/                   the neutral kit: kit.md, tokens.css, tokens.json
  assets/
    <asset-slug>/        FLAT -- no grouping
      spec.md            what complete means for this asset, travelling with it
      <artefact files>
      exports/           pdf, pptx, png -- generated, never hand-edited
      src/               working files, if any
      vendor/            third-party runtime an artefact needs to render
  notes/
    <topic>.md           optional; durable thinking that is not an asset
```

Settled at `cd`'s round-one proposal. It replaces an earlier provisional layout that had `assets/` and `venture/` as siblings -- incoherent once the taxonomy is cut by precondition rather than by discipline, because eight asset types are genuinely both.

**The composite test: do the parts have different definitions of done?** If yes, they are separate assets and the composite is hiding them. If no, they are one asset with `coverage`.

Round three reached this by halves. `design-system` was correctly split -- the break was not the directory but the front matter, which carries one `status`, one `blanks` and one `inputs_missing` against nine taxonomy entries with independent readiness. But the test recorded at the time was "one status versus N parts", and round four showed that is wrong: applied to `component-library` it splits twenty-eight components into twenty-eight slugs, and the taxonomy dissolves. `cd` caught it and supplied the distinction -- `design-system`'s parts were *already separate taxonomy entries with separate definitions of done*, where a component library's parts are *one specification applied twenty-eight times*.

A third category exists with one member: `brand-guidelines` is an assembly of assets that exist separately, so its own done-ness is "every section reflects its source".

Assets with parts but one definition of done take `status: partial` and a computed `coverage` read from the artefact's own inventory, which is the fifth check rule. A library declaring twenty-eight components and rendering twelve cannot claim to be finished, and that is the specific way that asset lies.

The fix invents nothing. The taxonomy already listed those nine separately; Tier 1 collapsed them for convenience, and the structure rejected the convenience rather than the design. So: one flat slug per taxonomy entry, and `design-system` becomes a bundle name -- which is where groupings were already agreed to live. Tier 1 goes from eight assets to eleven, and asset 20 is `kit/`, which means one asset legitimately lives at the target root rather than under `assets/`. That is a deliberate exception, named here rather than left to be discovered as an inconsistency.

**`assets/` is flat, deliberately.** Four reasons, in ascending order of force: grouping is an order in disguise and the structure must not imply one; eight assets are genuinely both design and venture, so any grouping forces a lie about them; retrofitting an existing venture becomes `mkdir` and `mv`, one asset at a time, rather than requiring the whole taxonomy be settled before the first file moves; and **no drop ever contains the whole taxonomy** -- fifty-one is the menu, a drop is an order of six to ten, so the scanning problem grouping would solve does not arise. A fifth from the tooling side: flat keeps `import` dumb, because validating a flat slug list is a set-membership test, where a grouped tree would force the importer to carry the taxonomy's structure and be updated whenever it moved.

Grouping is real and useful; it lives in `index.md` and in the bundles, as data rather than as a directory someone has to be right about.

**`spec.md` travels with each asset**, carrying `status`, `spec_version`, `blanks` and `inputs_missing` in its front matter. The library here stays the source of truth; the copy in the drop is a stamped duplicate whose version makes staleness detectable. A drop reports its own incompleteness rather than leaving it to be discovered.

Resolution order, following the house pattern set by `$UTILZ_HOME` and `$INTENT_HOME`: CLI flag, then `$CDSYNC_TARGET`, then the `cdsync.json` field, then the built-in `design/`. Relative targets resolve against the project base rather than `$PWD`, so running from a subdirectory lands in the same place.

Because the target may sit outside the repo, every command that resolves one reports which it got and whether it sits inside the repository. A target outside the repo does not version with the project -- correct for a shared or confidential drop, and a trap if it happens by accident.

### Import writes only what `cd` owns

`cdsync import` writes `assets/`, `kit/`, `notes/`, `index.md` and `RETURN.md`, and **never touches anything else in the target**.

Learned the hard way in round four. A drop arrived without `templprj/README.md` -- the only statement anywhere in that directory of why the placeholder must be boring -- and syncing the drop over the target deleted it silently. `cd` did not remove it deliberately; the drop is simply the whole directory, so anything present in the target and absent from the drop went with it.

`brief.md` survives that only because `cd` echoes it back verbatim, which is a convention propping up a guarantee. Conventions do not hold.

So the boundary is explicit: `cd` owns a named set of paths in the target and import writes only those. It is the same as-designed versus as-built separation the whole design rests on, applied one level down -- and it means a venture can keep its own files alongside a drop without a later drop eating them.

### As-designed vs as-built

`$CDSYNC_TARGET` holds what was **designed**. The application holds what was **built**. Keeping them apart is the point:

- You can hold one against the other and see where implementation diverged from intent.
- You can return to the as-designed state and recover what was being aimed at.
- Re-importing a later drop cannot clobber application work, because import touches nothing outside the target.

The venture project pulls from the target on its own terms. That is application work done with judgement, not a mechanical copy.

### Where the knowledge lives

| Command | Job | Knows about |
| ------- | --- | ----------- |
| `cdsync new <name>` | scaffold the venture | Intent, Elixir / Phoenix / Ash, Laksa. **All application knowledge is confined here.** |
| `cdsync brief` | assemble and write the brief | the spec library |
| `cdsync import <zip>` | unpack into the target | only the target |
| `cdsync site` | stand up the microsite | only the target |

`import` and `site` know nothing about Phoenix, Ash, or Laksa. That confinement is what lets the target stay self-contained and the microsite stay independent of the application it describes. It also keeps `import` dumb, which is what keeps it safe.

`build` and `publish` were sketched early and remain unbuilt until something concrete demands them.

**`cdsync check` is no longer speculative.** Four rules, all of them earned rather than invented:

1. `status` against blank count: `status: complete` alongside non-zero blanks is a contradiction.
2. A drop's stamped `spec_version` compared against the library here, to detect staleness.
3. Illustrative numbers must be *visibly marked in the artefact*, not merely understood in conversation. A safety property: `cd` reports it as a failure that recurs and has the worst consequences, which is why it belongs in a check and not a habit.
4. **Every colour literal in an asset, excluding vendored runtime, must appear in `kit/tokens.json`.** `cd`'s proposal, and the one it argues to build first if only one gets built. It catches drift in both directions -- an artefact holding a value the kit no longer has, and a hue entering an artefact without passing through the kit. The second is what makes neutrality a property of the repository rather than of whoever last touched a file. Verified working in round three: run against the drop it skips four runtime files and clears five artefacts.

**`blanks` is computed, not declared.** Two rounds produced wrong counts in three different ways, including a `blanks_unique` that was arithmetically impossible against its own document. The conclusion is not that the counting convention needs specifying harder -- it is that a hand-maintained count of a mechanically countable property will always drift. So `cd` declares what needs judgement (`status`, `inputs_missing`, `spec_version`) and `cdsync check` computes what is fact. Same move as enforcing neutrality with a kit rather than asking for restraint: remove the failure mode instead of detecting it. What remains for `cd` to answer is scope -- whether frontmatter placeholders, backticked examples, `spec.md` itself and `data-props` blocks are in or out -- because the tool cannot guess that.

**Vendored runtime is excluded by declaration, not by path.** Built HTML artefacts ship a rendering runtime -- in the round-two probe, 205KB against a 40KB deck, carrying its authoring environment's brand colours, which would fail rule 4 on every run.

The first attempt excluded `vendor/` by path. That was wrong: `support.js` cannot be moved there, because the authoring runtime emits it as a sibling of every `.dc.html` and that path is not the author's to set. A path rule therefore needs `support.js` named as a special case -- which is precisely the maintained exception list that prohibitions-over-instructions exists to avoid, reintroduced by the fix meant to prevent it.

So the rule skips any file declaring itself generated -- `GENERATED`, `do not edit`, `Copied ... starter`, `@generated` -- in a comment near the top. Correctness then does not depend on anyone having filed a file correctly, it covers runtime that cannot be moved, and newly vendored files arrive already exempt. `vendor/` still exists, for legibility rather than for the check: a directory says "not yours" to a human at a glance, where a comment on line one of a 136KB minified file does not.

The unit of portability is therefore the **asset directory**, not the artefact file. An artefact restates token values literally rather than linking `../../kit/tokens.css`, because a path two levels up does not survive the directory being moved -- but same-directory siblings do.

### Implementation notes

Bash, following the dispatcher pattern shared by Utilz and Intent. `shell` is the declared language; `critic-shell` and the pre-commit gate are live. Bash 3.2 is the floor, since that is what macOS ships.

Two contracts inherited from Utilz ST0009, both of which fail silently when broken:

- **Consume a walker with process substitution, never a pipe**: `while IFS= read -r name; do ...; done < <(each_utility)`. A pipe subshells the loop body, so accumulator arrays are discarded when it ends and the caller reports nothing, successfully.
- **Gate a hard dependency once before a loop**, never per-iteration, and never memoised across command substitution -- a memo set inside `$(...)` dies with its subshell.

Reasoning for both: `../Utilz/intent/st/COMPLETED/ST0009/design.md`.

`cdsync brief` writes atomically -- composed to a temporary file, then moved into place. The reason first given for this was that `cd` reads the working tree live, which was wrong and is withdrawn. The behaviour stays because it costs nearly nothing, because handing a human a half-written brief is its own failure, and because that failure would be silent.

## As built (2026-07-29)

All five commands are real. `bats` 118/118, `critic-shell` clean across 15 files,
`doctor` clean, `check` on `templprj` reporting eleven assets with three advisories,
all three of them genuine defects in the specs as delivered.

Five shared modules carry the work, each owning one concern because more than one
command needs it: `frontmatter.sh` (the front-matter reader), `config.sh` (the
`cdsync.json` reader), `specs.sh` (the library, its walker, bundles, taxonomy),
`drop.sh` (the shape of a drop, and the single definition of the owned-path list),
`scan.sh` (blank counting and colour scanning). `cmd_check.sh` applies rules and
renders; it computes nothing.

**Not yq.** Every field the tool decides on is a scalar; the only nested structure,
`depends_on`, is read for reporting rather than control flow. A hard dependency to
parse what awk handles in twenty lines would buy nothing and cost an install step on
every machine that runs `check`.

### The spec library did not exist, and rule 2 could never have fired

The most important thing the build found, and it was a hole in this document rather
than in Claude Design's work.

The library has been specified here since round one: it lives on this side, it is
version-controlled, a drop carries a stamped copy, and the version difference is
what makes staleness detectable. Every one of those sentences was written down and
agreed. But the specs only ever existed at
`templates/claude_design/templprj/assets/<slug>/spec.md`.

So the drop was its own source of truth, and check rule 2 -- the staleness check --
would have been comparing a drop against itself. **A staleness check with one copy of
the thing is not a check.** It would have passed, silently and permanently, and
nothing about the codebase or this document would have looked wrong.

Everyone involved, including whoever wrote the sentences above, talked about the
library as though it were there. That is the failure mode worth naming: a design
document describing a component convincingly enough that its absence stops being
visible. `specs/` now holds eleven entries -- the ten authored plus `kit` -- as each
drop spec minus its per-drop state, since `status`, `blanks`, `blanks_unique`,
`blanks_source` and `coverage` describe a delivery rather than an asset.

### Two exclusions the check rules needed, discoverable only by running them

Rule 3 produced six advisories on its first run and **all six were false positives.**
A number inside a blank is not a claim -- `[svg, png at 1x/2x/3x, eps for print]` is
already marked as the thing a venture must replace, which is stronger marking than
`illustrative` would be, so flagging it demands a claim-marker on the one construct
that is definitionally not a claim. And a number in a stylesheet is not a metric:
every percentage matched was a CSS `width:` or `height:`. A rule that fires on
`width: 40%` gets switched off, and a check nobody runs guards nothing.

Rule 4 needed fully transparent values excluded. `rgba(0,0,0,0)` is the `transparent`
keyword spelled long-hand: it appears in seven of the ten artefacts and in
`tokens.css`, carries no hue, and therefore has nothing to leak. `rgb()` and `rgba()`
now normalise to hex before comparison, and alpha above zero is compared on hue
alone, because the kit has no alpha tokens and opacity is a separate axis from
palette.

Neither exclusion was an oversight in the specification. Both are the kind of thing
that only exists once code meets the corpus.

### The declaration rule got re-broken by its own fix

`is_generated_file` first accepted a bare `*` as a comment opener. That exempted
`vendor/README.md` and `exports/README.md`, because `- **Do not edit these files.**`
and `| **not generated** |` each carry an asterisk ahead of the marker -- silently
re-exempting the two files the round-three fix had just started checking.

This is the third time this particular rule has been got wrong in the same direction,
and the pattern is now clear enough to state: **every loose version of the comment
test degenerates into a path-based exemption wearing a different hat.** The fix
anchors the opener to the start of the line and tightens "near the top" from twenty
lines to five. Either alone would have caught the two READMEs; both are applied
because a false exemption is the dangerous direction -- it does not fail the check,
it stops checking.

Found by reading, not by running. The tests agreed with the bug, which is its own
lesson about writing tests from the same understanding that produced the code.

### Bundles are defined over slugs, not taxonomy numbers

Claude Design defined the seven bundles over taxonomy numbers, and the mapping is not
one-to-one: `positioning-icp-personas` is a single deliverable covering 1, 3 and 4.
A slug is the unit that gets ordered, delivered and counted, so a bundle has to be a
set of slugs or a brief cannot name one. Each library entry records a `taxonomy:`
field naming the numbers it covers, so the mapping stays auditable rather than
becoming folklore.

This changes published counts: `templprj/index.md` says `founding-set: 2 of 6`, which
over slugs is 2 of 4. Two denominators, not a disagreement.

`rebrand-set` turns out to reduce to exactly `identity-set` -- its extra member, 19,
is already in the identity set, and its real content, an audit inventory of what
changes, is not in the taxonomy at all. Flagged as a probable gap rather than
invented as asset 52.

### Two brief fields added beyond the round-one header

`invention` and `numbers`. Gaps 8.3.1 and 8.3.3 are named as the two most expensive
omissions in this class of work, but neither was a field in the 8.1 header -- so a
brief could satisfy the header completely and still leave both open. They default to
"leave blanks" and "treat as illustrative" when unstated, and render into every brief
as an explicit table rather than as prose that can be skimmed past.

## Alternatives Considered

**`cd` as a peer node with directory ownership.** `cd` would own `template/` in this repo, `cc` everything else, both committing to `main` with claims enforcing the split. Rejected once it emerged that `cd` cannot commit at all, which made the split unenforceable as written.

**Fanning imported artefacts into the application.** Tokens to `assets/vendor/`, imagery to `priv/static/images/`, components to `lib/<app>_web/components/`. Rejected: it collapses the as-designed and as-built records into one, is unsafe against hand-edited components, and has no destination for artefacts that are not source code at all -- a PPTX deck has no home in `lib/`.

**Deriving the contracts by inventorying what existing ventures shipped.** Rejected as the wrong target: it reads what happened to land, not what the process should be. It also produced a detour into Laksa site config, which is downstream of this work entirely.

**`drops/<name>/` inside Cdsync instead of a repo per venture.** Rejected: it would couple every venture's confidential tree to one repository and make per-venture access impossible.

**Granting `cd` access to the whole repo.** Rejected deliberately. The narrower scope is a forcing function that keeps briefs self-contained and therefore correct when `cd` is later scoped to a real venture.

**Thin, reference-rich briefs.** Rejected as a consequence of the above -- a pointer to a file `cd` cannot open is a hole in the brief, not a reference.
