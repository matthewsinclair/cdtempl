---
verblock: "08 Aug 2026:v0.3: matts - The spec_version ruling now blocks WP-08's second brief gap as well"
wp_id: WP-05
title: "Make scope durable: cdsync.json and spec_version"
scope: Medium
status: Done
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

**8 August: a fifth asker, and it is the tool rather than a supplier.** WP-08 carries a gap -- `brief` cannot order a slug the spec library does not hold, so a genuinely new asset type cannot be commissioned at all. Building that requires the brief to tell the round what `spec_version` to stamp on the asset it is creating, **which is exactly the question above.** So this ruling now blocks a second work package, and WP-08 recorded itself as depending on nothing until the chain was traced.

**Whatever is ruled here should be phrased so the generator can state it**, not only so a human can apply it. The recurring shape in this project is a document that explains a field and never supplies its value, and an answer that lives only in a ruling would be the fifth instance rather than the fix.

## Deliverables

- A ruling on where `cdsync.json` lives for a repository-owning venture, and `brief` reading it from there.
- `Acme/cdsync.json` filled, and the four slugs re-ordered.
- A ruling on `spec_version` for new assets, carried into the generator so the document states it rather than implying it.
- **Regenerate every project's `BOOTSTRAP-CD.md`** after any generator change. Regeneration fires on sync only, so a generator change stales every copy at once **with no local symptom**.

## Dependencies

Needs hv for both rulings. WP-03 benefits from the first being settled.

## Notes

geodica also asked, differently: its kit is prose only -- `tokens.md` and `primitives.md`, no `tokens.json` -- so rule 4 cannot run against it at all. Either request machine-readable tokens next round, or accept the rule is dark for that venture and say so. *(Under the 9 Aug wind-back this stays as record: no round is going back to geodica.)*

## Ruled and built, 9 August

Both rulings landed in conversation and the build shipped the same day. **Suite 353/353, shellcheck clean, the four core behaviours mutation-proven** (each mutant confirmed landed by diff and killed exactly its test).

- **`cdsync.json` lives at the design tree root, always** -- one home for `new` ventures and `init` projects alike. Resolution probes `design/system/` then `design/`; the file's own directory IS the target; the `.target` field is retired and a leftover one warns. The file joins `CDSYNC_DROP_PROTECTED_PATHS`, and a drop may not deliver one at any depth. `new` scaffolds it into the tree; **`init` writes the stub**, which is what makes `brief` runnable for a project Cdsync does not own -- the case where scope used to be supplied by hand.
- **`spec_version` for a new asset is the literal `unassigned`.** `brief` now orders a named in-taxonomy slug the library has not specified -- the round creates the asset, the document carries the contract its specification cannot, and the stamp is `unassigned` until the library gains an entry, at which point rule 2 asks for a rebuild. **Outside the taxonomy still refuses**: the taxonomy is the identity space. Bundle expansion unchanged. Both generators state the whole convention, so no supplier asks a sixth time -- and WP-08's order-an-unspecified-slug gap closed with it.
- **Acme migrated**: `cdsync.json` at `design/`, `.target` gone, brief regenerated against library v3 (`91e9408`, `adc50f2` in its own repository).
- **The regenerate-every-project step retired with the wind-back**: the four delivered projects' documents froze; generator changes regenerate live ventures only.
- Carried here from WP-06's dissolution: **the brief now states `hard_facts` and bundle membership per specification** and defines both in the contract block -- the two fields the document asked back and never supplied.
