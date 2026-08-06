---
verblock: "29 Jul 2026:v0.4: matts - Round one, text only; self-contained after cd confirmed it cannot read the repo"
---
# Brief for Claude Design -- round one: the specifications

## What this is

Cdsync regularises the way we work together. The same kinds of problem have recurred across several ventures, and the goal is to make the process **regular and predictable** first, and **automated** second. The first matters considerably more; the second is only worth doing because it is now cheap.

This is co-authorship, not extraction. You know what a complete design system or pitch deck needs to contain better than anyone here does. The point is to write that down once, so it comes out the same way every time.

**This brief is self-contained by design.** You are scoped to `templprj` and nothing else, deliberately -- in production you will be scoped to a venture's design directory, where Cdsync's internals genuinely are not visible. Holding that constraint now keeps the brief format correct for then. So nothing here points at a file you do not have, and if a later round needs a spec, that spec travels with it.

That is also the answer to your first question. You are not getting the technical design document, because a brief that needs it would be a brief with a hole in it. What it would have told you is below instead.

## Round one is text only

Your proposal, accepted. This round produces **no built artefacts**. Taxonomy, priorities, specifications, the output structure proposal, the dependency graph, the bundles, and the neutral kit -- all as text, all arguable before anything expensive gets made. Round two builds the top handful against whatever survives.

## What you need to know, since you cannot read it

- Your output lands in a single directory in the venture repo, `$CDSYNC_TARGET`, which defaults to `design/` but may point anywhere. What is standardised is the structure **underneath** it, never the location.
- **Cdsync never writes into the application.** Import unpacks into that directory and stops. It does not fan artefacts out into a Phoenix tree. The venture project takes what it needs, by hand, with judgement.
- That directory is the **as-designed** record; the application is the **as-built**. Keeping them apart is the point -- it lets someone hold intent against implementation, and it means a later drop cannot clobber work built on an earlier one.
- Delivery is by zip. There is no write path from your side.

## Four of your points, adopted

**The mandated layout is the folder, not a document describing it.** You build a directory whose top level is exactly what drops into `$CDSYNC_TARGET`, and hand it over as a zip. Import becomes an unzip. Nothing to keep in sync, because there is no second description to drift from.

**The spec library lives here, version-controlled.** Your deliverable is spec text that gets committed into Cdsync, plus `templprj` as the worked example. Two artefacts, two homes. You are right that specs living only in your output would fork the first time one was edited here.

**Neutrality is a spec, not an instruction.** This is the best correction in your reply. Asking you to stay restrained across twenty artefacts is asking you to fight a tendency, and tendencies win eventually. So: **one neutral kit that every template imports.** Greyscale ramp, one system font stack, no accent hue, visible placeholder treatment for imagery. Then "is this too charming" is a question about one file rather than a judgement call across twenty. Specifying that kit is a round-one deliverable.

**`RETURN.md` is mandatory, at the top of every zip.** With a required *revisions to understanding* heading, present-but-empty when there is nothing to say. You are right that an optional section would be empty every time, and that this is precisely the part that does not survive chat.

## Scope

**Every asset in a complete design system**, plus **the typical candidate set of early venture documents**. The "roughly twenty" in the previous version of this brief was a made-up number -- ignore it, and let the real answer be whatever it turns out to be.

To your question: yes, cap table narrative, hiring plan and ICP definition are in scope. Anything you would normally call out for an early venture belongs in the candidate set. Propose the set; none of it is owned elsewhere.

## What round one asks for

### 1. The taxonomy

Every design and venture asset type. For each: a name, one line on what it is, and who it is for -- investor, customer, internal, team, public.

Group them however they genuinely cluster. Design and venture is the obvious first cut; do not force it if the real structure differs. If something is genuinely both, say so rather than picking a side.

### 2. Priorities

Which types recur across most ventures, and which are occasional? The recurring handful is what round two builds.

### 3. Per-asset specifications

For each: what a **complete** one contains. Sections or components, formats produced, and the definition of done -- what distinguishes a finished one from a draft.

This is the bulk of the round and the part most worth your judgement. Where an asset has a standard shape that good practice already dictates, use it and say so; there is no value in a house variant of something that already has a right answer.

### 4. The neutral kit

Specify it: the ramp, the font stack, the placeholder treatment, and whatever else carries the restraint. This is the file every template imports, and the single place neutrality is enforced.

### 5. The output structure

Propose the directory layout you would deliver into. It becomes the mandate, so it should be your natural shape made explicit rather than one imposed from here.

Say what "template form" means per asset type while you are at it -- it will not be uniform. Some assets are documents with blanks, some are structures with placeholder values, and some may warrant a specification with no artefact at all, where the content is wholly venture-specific and a template would hinder rather than help. Call those out rather than forcing an artefact into existence.

### 6. Dependencies

Which assets need which others to exist first? A deck presumably needs the brand; a zoo needs team information that no design process can invent. This determines ordering, and what a brief must supply up front.

### 7. Bundles

Do these cluster into groupings ordered together -- a seed-raise set, a launch set, a rebrand set? If so, name them and say what is in each. A brief listing every type individually will be unusable.

### 8. What the brief must carry

For each asset: what does a brief need to state so you can produce it **without a round of clarifying questions**?

This is how the brief format gets derived -- from the union of what the specs need as input. Include what past asks have left out and you have had to infer or invent. Those gaps are the highest-value part of this request: they are exactly what a template exists to stop happening.

## Where round two lands

`templates/claude_design/templprj/` in the Cdsync repo. `templprj` is the placeholder venture -- a deliberately neutral fictional company that exists so the templates have something concrete to be templates *of*.

It must be boring on purpose. Every venture built from these templates inherits whatever character `templprj` has, and character inherited by default is character nobody chose. If it looks like a real brand you would be pleased with, it is wrong. The neutral kit is how that gets enforced rather than merely hoped for.

## One thing to keep in view

Design and venture assets inform each other reciprocally and non-linearly -- how it looks and how it works are not a pipeline. So the output structure must not imply an order of production, and a brief carries both framings even when the ask is mostly design.

## How to reply

Text. It comes back by hv pasting it, so no attachments this round.

Completeness matters more than brevity: a genuinely complete taxonomy is worth more than a tidy summary that is not. But this round is meant to be cheap enough to argue with, so do not gold-plate the prose.
