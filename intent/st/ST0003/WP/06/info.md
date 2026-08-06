---
verblock: "02 Aug 2026:v0.2: matts - Filled from the ST0001/ST0002 close-out carry-forward"
wp_id: WP-06
title: "Settle round three's outstanding rulings"
scope: Medium
status: Not Started
---

# WP-06: Settle round three's outstanding rulings

## Objective

Round three returned four real drops and raised questions the tool cannot answer for itself. Each has its evidence gathered and is waiting on hv. **None of them blocks any of the others**, so they can be taken in any order or in one sitting.

Two items came *off* this list rather than being settled, and are recorded so they are not re-opened: **rule 5 shipped on 1 August**, and **rule 3 came off** because read properly its residual is mostly true positives -- exactly one of six findings is noise, and suppressing `alt` text to clear it was not worth it.

## The rulings

### Per project

- **Lamplight -- does `ref` want splitting?** `gn/` is licensed, `art/` and `gwidget/` are not, so as one asset the whole thing goes confidential. **Is classification per asset, or below it?** This is the only open ruling that could move paths, so hold Lamplight integration until it lands.
- **Lamplight -- seven working check renders** inside `portraits/`/`shots/` plus `docs/investor/*/_out/`. Flagged rather than deleted, deliberately.
- **snorkeltoast -- no `spec.md` exists anywhere.** Classification went into `index.md` per asset and `build-docs.mjs` per tree, rather than into 66 section frontmatters. **Ratify or redirect.**
- **G&G -- `hard_facts` and `bundles` are `[]` on all sixteen** because the bootstrap never defines them. One line each and they populate next round.
- **G&G -- `print-collateral` complete to partial.** Three documents say a trust band appears on the fliers and none carries it. **Ratify the downgrade.**
- **Baize -- `tiles/` has no consumer.** 25 photographs of a real table that nothing in the tree uses, kept as source material.
- **Baize -- eight ADRs stay**, each carrying a frozen-plan banner naming the ratified copy.

### Cross-cutting

- **Finding 5: is `formats_required` a narrowing of done, or advisory?** It appears in none of G&G's sixteen specs, and **two suppliers independently concluded an asset can be complete without its formats.** Two independent agreements is evidence about the document.

## Deliverables

- A ruling on each, recorded on the `cc` board under `## Decisions` with its reasoning, so none is re-litigated from memory.
- Any that change tool behaviour implemented with tests; any that change library text folded into WP-03's version bump rather than done separately.

## Dependencies

**Needs hv.** Every item is a scope or policy question with its evidence already gathered.

## Notes

The Lamplight `ref` ruling gates WP-07 for Lamplight only. The rest of WP-07 is unblocked.
