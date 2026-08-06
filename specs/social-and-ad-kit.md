---
asset: social-and-ad-kit
name: Social & ad kit
taxonomy: [39]
spec_version: 1
kit_version: 1
form: C
tier: 3
group: 6
audience: [public]
inputs_missing:
  - "which platforms, and which placements on each"
  - "who is producing the posts after handover, and with what tools"
  - "whether photography exists, and who owns it"
  - "what the venture will not say — the claims, tones and tactics that are off-limits"
  - "the cadence the account can actually sustain"
depends_on:
  hard_facts: []
  hard_assets: [brand-guidelines, logo-suite, colour-system, typography-system, voice-and-tone]
  reciprocal: [messaging-framework]
bundles: [launch-set]
---
# Social & ad kit — specification

## What it is

The tiles, templates and rules that let someone who is not a designer post for months
without the account drifting. It is judged by what it looks like **after** the designer
has gone.

## The profile is seen as a block, not as a post

This is the insight that changes the design. Nobody encounters a single post first — they
arrive at a profile and see nine or twelve tiles at once, as a grid. **So the unit of
design is the rhythm of the grid, not the individual tile.**

That produces rules a per-tile brief never generates: alternate photograph and type tiles
rather than stacking two of a kind; cap how many tiles in a row may use the strongest
ground; make sure any three consecutive tiles read as a set. A kit of individually
excellent tiles that produces a mottled grid has failed at the only view most people see.

## Type is set for the size it is *viewed* at

A square tile is designed at full size and viewed at roughly a third of it. **Set type at
around three times what the on-screen size suggests** — a headline that looks absurdly
large in the artboard is correct in the feed, and one that looks right in the artboard is
unreadable.

Story and vertical placements go larger again, and must keep clearance at top and bottom
for the platform's own furniture, which changes without notice and covers whatever is
underneath it.

## Nothing dated, or the account looks abandoned

**A tile with a date on it gets deleted the day after.** Worse, a dated tile left up ages
the venture: an event that happened last September, still pinned to the top of a grid, says
more about the account's neglect than the event ever said about the venture.

So the kit carries **evergreen tiles by design** — pieces with no month, no date, no
countdown — so the grid stays respectable through a quiet fortnight. That is a
specification requirement, not a nicety, and it is the difference between a kit that
survives a busy period and one that does not.

## The prohibitions are half the asset

A kit handed over without a "what not to post" list will be used to post the things the
venture has decided not to say. The list is derived from `voice-and-tone` and made
concrete: the claims that may not be made, the urgency tactics that are off-limits, the
imagery that may not be used, and the consent rules for anyone identifiable.

## The standard shape

| Part | Carries |
|---|---|
| Placements | Each size, for each platform, and what it is for |
| Grid rhythm | How tiles sequence, and what may not sit beside what |
| Type treatment | Sizes per placement, set for viewed size |
| Safe zones | Platform furniture clearance, per placement |
| Evergreen set | The undated tiles, and why they exist |
| Prohibitions | What not to post |

## Definition of done

- Every placement is a real, current platform size, and states what it is for.
- The grid rhythm is stated as a rule someone can follow without judgement.
- Type sizes are given per placement and reflect **viewed** size.
- Safe zones are stated for every vertical placement.
- At least one evergreen tile exists per content type, and is marked as evergreen.
- A prohibition list exists and is specific enough to act on.
- Every colour appears in `kit/tokens.json`.

## What the brief must carry

- Which platforms and placements.
- Who posts after handover, and with what tools. A kit needing design software is a kit
  that stops being used.
- Whether photography exists and who owns it.
- What the venture will not say.

## Notes

**Why `audience: [public]`.** Everything here is seen publicly. That makes the prohibition
list a risk control as much as a brand one — an unconsidered claim posted from a template
is still a claim the venture made.

**Reciprocal with the messaging framework.** Tiles are where messaging meets a character
limit, and the compression usually reveals which lines actually work. What survives on a
tile tends to feed back into the framework.
