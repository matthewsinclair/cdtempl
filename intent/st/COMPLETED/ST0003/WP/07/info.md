---
verblock: "08 Aug 2026:v0.3: matts - Premise corrected: three of three checkable projects were already integrated"
wp_id: WP-07
title: "Integrate the original four"
scope: Medium
status: Done
---

# WP-07: Integrate the original four

## Objective

This work package opened on a premise: that Lamplight, Baize, snorkeltoast and Gyre & Gymble each hold a design-system record and **none has been built against.**

**The premise was false, and not once but in every project it could be checked against.** Gyre & Gymble on 6 August, then Baize and snorkeltoast on 8 August: **three of three already integrated.** Only Lamplight is unchecked, and it is held on WP-06.

**The objective was written from the drop's side of a boundary the drop cannot see across.** An integration is invisible from there -- a drop cannot see an application -- so "nothing downstream" was a statement about what the evidence could reach, read as a statement about the world. Three projects then contradicted it in three different idioms. **Check what the application does before recording that it does nothing.**

**The deliverable of this WP is therefore the finding, not four integrations performed.** What remains is Lamplight, and it waits on a ruling.

## What was actually found

| Project | `check` says | What the application does | Verdict |
| ------- | ------------ | ------------------------- | ------- |
| **Gyre & Gymble** | Clean at 17 assets | `theme/theme.css` carries the whole Oat & Olive palette; `theme/layout.liquid:92` loads the compiled result | **Integrated** (6 Aug) |
| **snorkeltoast** | Refuses, `0 assets checked` | 41 of 41 hex literals in `design/system/brand/tokens/colors.css` are in `theme/theme.css`, which states its own provenance at line 9; `theme/layout.liquid:94` loads the build | **Integrated** (8 Aug) |
| **Baize** | Refuses, `0 assets checked` | 45 of 46 `oklch()` values in `design/system/handoff/app.css.theme-blocks.css` are in `apps/rack/assets/css/app.css`, both theme blocks named at `:438` and `:489`, and the non-colour claims land too | **Integrated** (8 Aug) |
| **Lamplight** | Clean at 4 assets | Unchecked | **Held** on WP-06's `ref` ruling |

**`check` refusing says nothing about whether a project is integrated.** It refused on both projects checked on 8 August and both were integrated. It is a check on a drop's *shape*, and three of these carry a convention older and more elaborate than anything Cdsync models. **Cdsync has no application-side check, by design** -- the tree is an end-state view, and a gap between it and the app is expected and never a defect.

**Baize's one divergence is deliberate, not drift.** The handoff specifies `oklch(96% 0.006 150)` for the gaffer theme's `--color-base-200` and `--color-secondary-content`; the app carries `oklch(95% 0.006 150)` for both. One percentage point of lightness, moved consistently in both places it appears. **The app refined the specification.** By canon that is not a defect -- but it is what `addenda/` exists to carry back, and it is unwritten.

**No two of these could be checked with the same probe.** G&G and snorkeltoast are hex; Baize is `oklch()` exclusively, with **zero hex literals**, so the probe that answered snorkeltoast reports a confident `0/0` on Baize. **A colour probe is per-project until proven otherwise.**

## Deliverables

- **Done:** each of the three checkable projects asked what its application does, by content and never by filename, with the probe validated in both directions before its answer was believed.
- **Done:** the premise corrected here rather than worked around.
- **Open, and hv's to release:** Baize's 96%/95% divergence recorded in **Baize's** `design/system/addenda/`. Nothing was written into that repository this session -- it carries hv's own uncommitted work.
- **Open:** Lamplight, once WP-06 rules on `ref`.

## Dependencies

Lamplight waits on WP-06's `ref` ruling. **The other three waited on nothing and are resolved.**

**This WP cannot close while Lamplight is held.** Its criteria stay unwritten until then, and they will not be written to match what happens to have been done.

## Notes

- **The app never reads from `design/system/`.** It is specification, not running code. Anything the application needs at runtime is delivered separately, exactly as the two Laksa theme packs were -- and in Baize's case as `handoff/app.css.theme-blocks.css`, which is a drop-in for a file the app owns.
- After touching `addenda/`, **regenerate `BOOTSTRAP-CD.md` by hand.** Regeneration fires on sync only, so a repo-side edit has nothing to hang it on.
- **`handoff/` is where an integration leaves its fingerprints, when there is one.** **Two of the three carry one -- Baize and snorkeltoast. Gyre & Gymble has none and is integrated anyway**, so a handoff directory is evidence of an integration and never a requirement for one. Where it exists it names the application-side path the drop itself could not reach: Baize's names `apps/rack/assets/css/app.css`, one level deeper than the repository root suggests. **Read the handoff for the path rather than constructing it** -- a root-level `find assets -name '*.css'` on Baize returns nothing at all.
- **Three projects, three integration idioms.** G&G hex with no handoff; snorkeltoast hex with a handoff naming its provenance in the file itself; Baize `oklch()` with a handoff written as a drop-in for a file the app owns. **Nothing about the shape of one predicted the next.**

## Closed 9 August

**The deliverable was the finding, and the finding is complete**: three of three checkable projects were already integrated, in three different idioms, with every probe validated in both directions, and the premise corrected here rather than worked around. The fourth leg dissolved with hv's wind-back: **integration is the application's business** -- canon already said the tool has no application-side check -- so **Lamplight is recorded unchecked by design, not pending.** The `ref` ruling it waited on dissolved with WP-06. Baize's 96%/95% divergence: hv ruled **"leave it"** on 9 August -- no addendum, consistent with the wind-back.
