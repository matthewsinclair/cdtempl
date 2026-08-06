---
asset: cms-rollout-plan
name: CMS rollout plan
taxonomy: [53]
spec_version: 1
kit_version: 1
form: C
tier: 2
group: 5
audience: [developer, team]
inputs_missing:
  - "which CMS, and whether that is already decided or still open"
  - "who edits content after launch, and what they are comfortable with"
  - "what content already exists and in what form it has to be migrated from"
  - "whether anything must go live in stages, and what forces the staging"
depends_on:
  hard_facts: []
  hard_assets: [information-architecture]
  reciprocal: [brand-guidelines]
bundles: []
---
# CMS rollout plan — specification

## What it is

**How the content model reaches a system that real people can edit, and who edits it.**
The information architecture says what content types exist; this says how they are
represented in a specific tool, how existing content gets there, and what happens on
the day the people who will maintain it take over.

It is the asset that decides whether a site is still accurate in six months. A design
system delivered without one produces a site that is correct at launch and frozen
afterwards, because nobody can change it without the people who built it.

## The standard shape

| Part | Carries |
|---|---|
| The model | Each content type as the CMS represents it — fields, types, required-ness |
| Relationships | How types reference each other, and what happens when a reference breaks |
| Migration | What exists now, where it comes from, and how it is transformed |
| Editing | Who edits what, with what permissions, and what they can break |
| Staging | What goes live when, and what forces anything to be sequenced |
| Handover | The point at which the venture can change the site without help |

## The editor is the constraint

**Model for the person who will actually edit, not for the person who built it.** A
content type with eighteen optional fields and no guidance is a type that will be
filled in three incompatible ways within a month. Fewer fields with stated rules beat
more fields with flexibility.

**What an editor can break is part of the specification.** If deleting a category
orphans forty pages, that is a design decision to make deliberately — cascade, prevent,
or orphan visibly — rather than a behaviour to discover in production.

## Definition of done

- Every content type from the architecture appears, with fields and required-ness
- Reference behaviour is stated for every relationship, including the delete case
- Migration names the source of existing content, or states that there is none
- Permissions are per role and say what each role **cannot** do
- The handover point is named, with what has to be true before it happens

## What the brief must carry

Which CMS, or an explicit statement that it is undecided. A rollout plan written
against an unnamed system is a content model with rollout language attached, and it
will need rewriting once a tool exists.

Also who edits after launch and what they are comfortable with. A model designed for a
developer and handed to a non-technical owner is the most common reason a site stops
being updated.

## Notes

Admitted to the taxonomy as **53**, out of numeric sequence and in Group 5
deliberately: the number is identity and the grouping carries the meaning, which is
the rule `print-collateral` established at 52. Renumbering a live identifier set is
what cost an export cycle on both sides once already.

Hard-depends on `information-architecture` because there is nothing to model until
the content types exist. Reciprocal with `brand-guidelines` only where the CMS
constrains what the identity can do — a template system that cannot express a rule
makes that rule untrue in practice.
