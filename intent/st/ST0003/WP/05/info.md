---
verblock: "02 Aug 2026:v0.2: matts - Filled from the ST0001/ST0002 close-out carry-forward"
wp_id: WP-05
title: "Make scope durable: cdsync.json and spec_version"
scope: Medium
status: Not Started
---

# WP-05: Make scope durable: cdsync.json and spec_version

## Objective

Two questions that have each been asked by more than one venture and answered by hand every time. Both are places where **the generated document explains a field and never supplies its value** -- the failure shape this project has now hit four times.

## 1. Where scope comes from

`BOOTSTRAP-CD.md` gives Claude Design the shape and the rules but **not which assets to build.** On a 52-slug taxonomy that invites sprawl, and on two simple content sites it very nearly did. hv supplied scope by hand for both spikes.

Scope properly comes from `cdsync brief`, which orders against the spec library. `brief` needs a `cdsync.json` -- and **that file cannot live in the site**, by canon: an existing project must never get the `new` treatment, no `cdsync.json`, no agent contract, no nested repository. `cdsync init` exists precisely because of that boundary.

**So the open question is where a venture's `cdsync.json` lives when the venture is a repository Cdsync does not own.** Options not yet weighed properly: alongside the Cdsync install, in a per-venture directory under `templates/`, or somewhere new. The same question blocks `Acme/cdsync.json`.

## 2. `spec_version` for a new asset

**Four projects have now asked this in four shapes.** The bootstrap supplies a number for assets the library already specifies. It supplies nothing for an asset the round is *creating*, and the round is correctly refusing to invent one -- **matthewsinclair's thirteen assets all carry `spec_version: unassigned`.**

That is the right behaviour from the supplier and the wrong state to leave the field in. Needs one of:

- A number to stamp on anything new.
- Confirmation that a new asset inherits the kit's.
- A declared convention that `unassigned` is the correct permanent answer until the library gains an entry.

**Three suppliers asking the same question is one defect in the document, not three mistakes by them.** It is four now.

## Deliverables

- A ruling on where `cdsync.json` lives for a repository-owning venture, and `brief` reading it from there.
- `Acme/cdsync.json` filled, and the four slugs re-ordered.
- A ruling on `spec_version` for new assets, carried into the generator so the document states it rather than implying it.
- **Regenerate every project's `BOOTSTRAP-CD.md`** after any generator change. Regeneration fires on sync only, so a generator change stales every copy at once **with no local symptom**.

## Dependencies

Needs hv for both rulings. WP-03 benefits from the first being settled.

## Notes

geodica also asked, differently: its kit is prose only -- `tokens.md` and `primitives.md`, no `tokens.json` -- so rule 4 cannot run against it at all. Either request machine-readable tokens next round, or accept the rule is dark for that venture and say so.
