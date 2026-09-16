---
asset: whos-who-in-the-zoo
name: Who's who in the zoo
taxonomy: [47]
spec_version: 2
kit_version: 1
form: C
form_was: A
tier: 1
group: 8
audience: [team, investor]
inputs_missing:
  - "names, titles, and location for every person"
  - "what each person actually owns, as distinct from their title"
  - "headshots, or an explicit licence to leave slots hatched"
  - "whether this copy is internal or investor-facing"
  - "advisor commitments, stated honestly"
  - "the gaps, and when each gets hired"
depends_on:
  hard_facts: [team-roster, ownership-map, headshot-licence]
  hard_assets: [typography-system, colour-system]
  reciprocal: [hiring-plan]
bundles: [founding-set, seed-set]
---
# Who's who in the zoo — specification

## What it is

Who is here, what they own, and how to reach them. One page in most ventures,
three at most.

The name is not decoration: the useful version of this document answers "who do I
go to about X", which an org chart does not. Titles describe reporting; this
describes ownership, and they diverge almost immediately in a small company.

## Reclassified from Form A to Form C

Round one put this in Form A. That was wrong, and finding out why produced a rule
worth having.

**Form A is markdown, and markdown cannot hatch an image slot.** The kit defines
two kinds of blank — missing copy and missing imagery — and Form A can only carry
one of them. Any asset whose completeness depends on imagery is therefore **Form C
by construction**. A markdown zoo would either omit the headshots entirely, or
carry a line of text saying a photograph goes here, which is not a placeholder —
it is a note about a placeholder, and it does not look wrong when it is left in.

The rule generalises and belongs in the kit: apply the imagery test to every
asset before assigning it a form.

## The standard shape

There is no settled industry shape for this document, so this one is proposed
rather than inherited. Four sections plus contacts:

| Section | Carries |
|---|---|
| Leadership | The people who can commit the company to something |
| Team | Everyone else, ordered by what they own rather than by seniority |
| Advisors and board | Including the honest statement of commitment |
| Gaps | The roles not filled, who covers them today, and at what cost |
| How to reach us | Routing by topic, not by person |

Three deliberate choices in that shape:

- **Ordered by ownership, not seniority.** The document is used to find the right
  person, and seniority is not a useful index for that.
- **Gaps are a section, not an omission.** An acknowledged gap reads as
  self-awareness; a hidden one reads as a surprise later, usually in diligence.
- **"Where decisions are written down" is a routing entry.** It is the one
  question this document can answer that saves the most time, and it is almost
  always missing.

## Formats produced

- `Whos Who In The Zoo.dc.html` — the source. Flowing document; the print engine
  paginates onto whatever paper the reader has.
- `exports/whos-who-in-the-zoo.pdf` — generated. PDF is a print action taken on
  the Cdtempl side.

Flowing rather than explicitly paginated, because team size varies and a fixed
page count would be a lie the first time someone joins.

## Template form

**Form C — built artefact with placeholder content.** Person entries are
duplicated blocks; a venture adds or deletes them. Headshot slots are hatched 1:1
frames. Guidance is a bordered note at the top that the venture deletes, plus a
monospace line under each section heading.

## Definition of done

1. **Every person present is listed**, including part-time and contract, or the
   omission is stated.
2. **Every entry says what the person owns**, in words that are not their title
   restated.
3. **No hatched headshot remains**, or the decision to leave them is stated in
   `RETURN.md` — usually a licensing decision, and a legitimate one.
4. **Advisor commitments are honest.** An advisor who has had one call is a
   contact.
5. **The gaps section is non-empty**, or its emptiness is deliberate and stated.
6. **The routing table resolves to people who exist** and have agreed to it.
7. **It carries a review date and an owner.** A stale zoo is worse than none — it
   sends people to the wrong person with confidence.
8. **The audience is set.** Internal and investor copies differ: contact details
   belong in one and not the other.

## What the brief must carry

Beyond the universal header:

- The roster: names, titles, locations.
- What each person owns. This is the field that cannot be inferred and is the one
  most often missing.
- Headshots, or an explicit licence to leave the slots hatched. **Never a licence
  to substitute stock** — a photograph of a stranger is worse than an empty frame.
- Which copy this is: internal or investor-facing.
- Advisor commitments as they actually are.
- The gaps, and the trigger or quarter for each hire.

## Notes

Reciprocal with the hiring plan: the gaps section and the hiring plan are the same
information at two levels of detail, and they will contradict each other unless
one is derived from the other. Recommend deriving the zoo's gaps from the hiring
plan where both are ordered.
