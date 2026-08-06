---
verblock: "29 Jul 2026:v0.1: matts - Round four review: composite test refined, README loss, stop building agreed"
---
# Answer to round four -- for Claude Design

Ten of eleven Tier 1 assets, both requested changes applied, and a refinement to a rule I had already accepted. Agreeing to stop, with one correction to what comes next.

## Verified

| Check | Result |
| ----- | ------ |
| **Colour check, comment-scoped, all ten assets** | **passes** -- eight artefacts carry literals, all clean; nine runtime files skipped |
| The comment-scoping fix | works: `exports/README.md` and `vendor/README.md` are now *checked* rather than exempted |
| `blanks_source: estimated` | applied to all three prior assets |
| `blanks` scope | written into `kit.md` -- `spec.md`, `index.md`, `RETURN.md`, `README.md`, `notes/**` out of scope |
| `component-library` renders | yes, and the two-decisions callout is visibly in the artefact |
| `coverage` | present: `0/28 specified in the standard inventory` |

## Accepted: your refinement of the composite test, which corrects mine

> Do the parts have different definitions of done?

That is better than what I accepted in round three, and you are right that mine was under-specified in a way that would have done damage. "One `status` versus N parts with independent readiness" applied to a component library dissolves the taxonomy into a thousand slugs, and I would not have noticed until it had.

The distinction is the durable part: `design-system`'s parts were already separate taxonomy entries with separate definitions of done; a component library's parts are one specification applied twenty-eight times. Adopted as the test for every composite-looking asset from here.

`brand-guidelines` as a third category -- an assembly whose own done-ness is "every section reflects its source" -- is a real category and worth having named before something else lands in it.

`status: partial` plus computed `coverage` accepted as the fifth check rule. Your framing of what it catches is the right one: a library declaring twenty-eight components and rendering twelve cannot claim to be finished, and that is the specific way this asset lies.

## The two kit decisions are the best finding in the drop

Radius 0 forcing a square radio, and the motion rule forbidding a spinner, are *design decisions that look like conventions* -- the kit's own failure mode arriving from inside the kit. That is a genuinely uncomfortable finding to report about your own proposal and you reported it plainly.

The generalisation you drew is the part worth keeping: **where a prohibition forces a component into an unusual shape, the component must say so, or the next venture inherits the workaround as a style.** That should go into `kit.md` as a standing rule rather than living only in this asset's callout, because the next prohibition-driven distortion will be in a different artefact.

Greyscale being load-bearing for states is the good kind of accident. The states matrix being the artefact that tells a venture what broke when they apply a palette is worth stating in its own spec -- it changes what the asset is *for*, not just how it looks.

`grid-and-layout` as a declared dependency that does not exist yet: noted, correct to declare, and it is first in Tier 2 where you put it. Not a problem, just a real edge for the fifth check rule -- `depends_on.hard_assets` will need to tolerate a named asset that is legitimately absent.

## One finding: `templprj/README.md` was deleted, silently

It is not in the drop, and `RETURN.md` does not mention it. With it went the only statement anywhere in `templprj` of why the placeholder must be boring:

> Every venture built from these templates inherits whatever character `templprj` has, and character inherited by default is character nobody chose. **If it looks like a real brand you would be pleased with, it is wrong.**

Nothing in the directory says that now. I have restored it from git.

I do not think you deleted it deliberately -- I think the drop is simply the whole directory, and anything in the target that was not in the drop went with it. Which is the actually important part, because it is not about a README:

**This is `cdsync import`'s central design question, and the incident answered it.** If import unpacks a drop over the target, everything in the target that Cdsync or a human put there is destroyed. `brief.md` survives today only because you echo it back verbatim -- which is a convention holding up a guarantee, and conventions do not hold.

So: import will write **only** the paths you own -- `assets/`, `kit/`, `notes/`, `index.md`, `RETURN.md` -- and will never touch anything else in the target. Same as-designed versus as-built boundary the whole design rests on, applied one level down. Nothing changes for you; it means a venture can keep its own files in the target without a drop eating them.

## Agreed: stop building templates. One correction to what comes next.

You are right, and for the reason you give: ten Tier 1 assets plus the kit was round one's own bar for enough, and a real drop will teach more about what the specs get wrong than four more templates will.

Your ordering has it as run-a-venture first, `cdsync check` second. Both are blocked on something neither of us has said out loud:

**The tool does not exist.** `templprj` is 1.4MB across 47 files with ten built assets. Meanwhile `cdsync new`, `cdsync brief`, `cdsync import` and `cdsync site` are all still stubs that exit non-zero. Every drop so far has been hand-carried and hand-synced. The import path -- the one that just silently deleted a file -- has never been executed, which is precisely why the failure showed up as a surprise rather than as a caught regression.

So the next round is mine, not yours: build the four commands, with `check` alongside them since all five rules are now earned by real failures rather than imagined ones. Then run a real venture through the whole loop, which is your recommendation and remains the right one -- it just needs something to run through.

Two things I will want from you when that happens, but not before:

- The scope answer already in `kit.md` is what `check` will implement for `blanks`. If it is wrong, now is the cheap time to say.
- When a real venture drop happens, `RETURN.md`'s *decisions I made that you did not ask me to make* becomes load-bearing in a way it has not been yet -- for `templprj` those decisions were about a fiction, and for a venture they will be about someone's actual company.
