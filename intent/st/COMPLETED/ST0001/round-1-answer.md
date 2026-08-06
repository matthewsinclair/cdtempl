---
verblock: "29 Jul 2026:v0.1: matts - Answer to cd's round one; three arguments settled, round two scoped"
---
# Answer to round one -- for Claude Design

Round one accepted. The taxonomy, the kit, the forms, the dependencies, the bundles and the brief contract are adopted as delivered unless contradicted below.

One thing before the three arguments: **grouping by precondition is a better axis than the one the brief gave you.** The brief offered design-versus-venture and said not to force it if the real structure differed. It did differ, you found the better cut, and "what has to be true before this is writable" is the right organising idea because it is the one that predicts what a brief must carry. That propagates -- it is why the dependency section works and why the bundles are coherent.

## The three arguments

### 1. Flat `assets/` -- agreed, and there is a fourth reason stronger than your three

Your three reasons hold. The fourth, which you could not have known: **no drop ever contains the whole taxonomy.** Fifty-one is the menu; a drop is an order. A Seed set drop is six assets, the Product set is ten. The scanning problem that grouping would solve only exists if you picture all fifty-one in one directory, and that never happens.

So flat is not a cost accepted for good reasons -- at drop scale it has no meaningful cost at all.

A fifth, from this side: it keeps `cdsync import` dumb, which is a stated design principle here. Validating a flat slug list is a set-membership test. Validating a grouped tree means the importer has to know which group each slug belongs to -- it would have to carry the taxonomy's structure, not just its vocabulary, and would need updating every time the taxonomy moved.

Grouping lives in `index.md` and the bundles, as you proposed. Settled.

### 2. Browsable HTML plus tokens, not Figma -- agreed, and you are underselling it

You framed this as "arguably more useful, but a choice." It is more than defensible; it is the right answer here, for two reasons you cannot see from where you are.

**The target stack.** Ventures are built on Elixir / Phoenix / Ash, with Tailwind and daisyUI. The reference application keeps its theme in `assets/vendor/*-theme.js` and its styles in `assets/css/`. CSS custom properties plus JSON feed that directly. A Figma library would have to be hand-translated into -- precisely the custom properties you would have produced anyway. HTML plus tokens is not a compromise, it is the shorter path to the same place.

**The design record has to be a file.** The target directory is the *as-designed* record and the application is the *as-built*, and the entire point is being able to hold one against the other. That requires the design record to be diffable, greppable, reviewable in a pull request, and committed alongside the code. A token file is all of those. A Figma library is none of them -- it lives in Figma, cannot be committed, and cannot be diffed against what was built. Choosing Figma would quietly break the architecture rather than merely change the medium.

Your proposed caveat stands: if a venture needs a Figma library for a human designer to work in, that is a hand-conversion from the tokens and the gallery, and the spec should say so plainly rather than imply the drop contains one.

### 3. Form D -- agreed on three, disagree on two, and the two do not matter yet

**Agreed without reservation: 12 logo, 16 imagery direction, 51 decision log.**

"A template mark is worse than no mark -- I would be handing over something that must be thrown away, and templates get kept" is the sharpest line in your response. It is the `templprj` argument one level down, and it generalises: the cost of a bad template is not the effort to make it, it is that it survives.

**Disagree on 40 launch kit and 41 demo storyboard.** Both look like Form A to me rather than Form D. A launch sequence has invariant structure -- announcement, press note, FAQ, and the order they go out in -- and a shot list has invariant columns: shot, on-screen copy, narration, duration. Those are shapes, not content, and a shape with blanks is exactly Form A. Your objection is that they would be "filled in against their own grain," which I think is an argument about bad launches rather than about templates.

**But both are Tier 3, so neither is built in round two or three.** I am recording the disagreement rather than settling it. Decide it when they are actually templated, when you will know more than either of us does now. Not worth a round.

## The addition you asked for -- accepted, and it costs nothing

Previous `RETURN.md` travelling with the next brief: yes. Your reasoning is right -- a promotion rule with no owner does not happen, and per-drop returns are perishable by construction.

It is cheaper than you think. `RETURN.md` already sits at the top of the target directory from the previous drop, so `cdsync brief` includes it **by construction**. No one has to remember, because nobody is doing it. That also means the promotion job you volunteered for gets its input automatically rather than by request.

"Decisions I made that you did not ask me to make" is adopted too. You are right that it is close in value to the revisions heading -- it turns invention from something discoverable by reading everything into something auditable in one place.

## Two things you have changed on this side

**`spec.md` front matter has un-parked a command.** `blanks:` and `inputs_missing:`, plus your observation that `status: complete` with `blanks: 4` is a contradiction a script can catch, is the first concrete justification for `cdsync check`. It had been sketched early and deliberately left unbuilt for want of anything real to check. It now has three rules: status against blank count, declared spec version against the library, and gap 8.3.3 -- illustrative numbers must be *visibly marked in the artefact*, not merely understood. That last one is a safety property, and the fact that it recurs is exactly why it belongs in a machine check rather than a habit.

**The target layout is replaced by yours.** The provisional structure here had `assets/` and `venture/` as siblings, which your precondition cut makes incoherent. Yours supersedes it.

## Round two, and a proposal about its shape

Tier 1's eight is accepted, including the reasoning that it exercises all four forms -- that is the right test.

But by your own cost analysis, five of the eight are Form C, and Form C is where the time goes. The reason round one was split from round two was that a build is expensive to redo if the specs turn out wrong. That logic does not stop applying at the round boundary.

So: **build the kit plus one Form C asset first, and stop.** My suggestion is the pitch deck, because it exercises the most of the structure -- `exports/` for both PDF and PPTX, the slide type floor, hatched imagery, bracketed copy, and a `spec.md` with real `inputs_missing`. If the structure survives one asset end to end, the remaining seven are batch work against a proven shape. If it does not, we have spent one asset finding out instead of five.

If you think a different asset is the better probe, say which and why -- you know the costs better than I do.
