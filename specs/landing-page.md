---
asset: landing-page
name: Landing page
taxonomy: [35]
spec_version: 1
kit_version: 1
form: C
tier: 1
group: 6
audience: [public]
inputs_missing:
  - "the single conversion action"
  - "the traffic source — cold, referral, search, or a specific campaign"
  - "pre-launch or post-launch: a waitlist page and a product page differ throughout"
  - "proof assets: logos, quotes, numbers, and what may be named publicly"
  - "whether a product screenshot exists"
depends_on:
  hard_facts: [conversion-action, traffic-source, launch-state]
  hard_assets: [messaging-framework, colour-system, typography-system, component-library]
  reciprocal: [messaging-framework, positioning-icp-personas]
bundles: [launch-set]
---
# Landing page — specification

## What it is

The primary public surface. One page, one action, written and designed together —
this is not a design with copy dropped in afterwards, and treating it as one is why
most of them do not work.

## The standard shape

**The shape is settled practice.** Sections, in order, all optional except the
first and last:

| Section | Carries |
|---|---|
| Hero | The one-liner, a subhead that earns the click, the action, and a product shot |
| Problem | Named as the visitor would name it |
| What it does | Three capabilities, each with a concrete outcome |
| Proof | Logos, a quote, or a number — whichever is real |
| How it works | Three steps |
| Pricing | Or a link to it, or the honest reason it is not shown |
| Objections | The three reasons people do not sign up, answered |
| Close | The action again, identical to the hero's |

Two things that matter more than the section list. **The action is the same action
everywhere on the page** — same words, same outcome. A page with a "start free
trial" hero and a "get in touch" footer has two conversion paths and measures
neither. And **the objections section is the one that lifts conversion** and the one
most often left out, because writing it requires knowing why people say no.

## Pre-launch and post-launch are different pages

A waitlist page and a product page share a shell and differ in every section: the
first sells an idea and asks for an email; the second sells a product and asks for
a signup. The brief must say which. This asset should not be ordered before that is
decided.

## Formats produced

- `Landing Page.dc.html` — the source, responsive, at neutral-kit values.

No PDF. If a landing page needs printing, what is wanted is the one-pager.

## Template form

**Form C — built artefact with placeholder content.** Built from the component
library's components rather than one-off markup, so a venture replacing the kit gets
a corrected landing page for free. Where it needs a component the library does not
have, that is a finding for the library rather than a local exception.

## Definition of done

1. **One action, stated identically everywhere.**
2. **The hero says what it is** before it says why it is good.
3. **The proof section contains something real.**
4. **The objections section exists** and answers three real objections.
5. **It works at 360px** as well as at 1440.
6. **Every interactive element has a focus state** — this is the asset where focus
   states get removed for looking wrong.
7. **The launch state is declared** and the copy matches it.
8. **No blanks remain.**

## What the brief must carry

Beyond the universal header:

- The single conversion action.
- The traffic source. A page for cold search traffic and a page for a warm referral
  need different amounts of explanation.
- Pre-launch or post-launch.
- Proof assets, and what may be named publicly.
- Whether a product screenshot exists. If not the hero carries a hatched slot, and
  a hero with a hatched slot should not go live.

## Notes

Reciprocal with the messaging framework: the page is where you find out which
message pillars carry weight, because a pillar that cannot be written as a section
heading was not a pillar.
