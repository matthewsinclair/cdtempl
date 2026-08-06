---
verblock: "02 Aug 2026:v0.2: matts - Filled from the ST0001/ST0002 close-out carry-forward"
wp_id: WP-07
title: "Integrate the original four"
scope: Medium
status: Not Started
---

# WP-07: Integrate the original four

## Objective

Lamplight, Baize, snorkeltoast and Gyre & Gymble each hold a design-system record and **none has been built against.** matthewsinclair and geodica went from cold tree to rollout in Laksa inside two days; these four have had a record since 31 July and nothing downstream.

**Integration is unblocked and independent of everything else in this thread.** It does not wait on the conversion round, on the rulings, or on the release.

## What each one needs

| Project | State | How it integrates |
| ------- | ----- | ----------------- |
| **Gyre & Gymble** | Cdsync-shaped, `kit/tokens.json`, `check` clean at 17 assets | **Unreservedly.** Nothing in the way |
| **Lamplight** | `check` clean at 4 assets | By reading. **Hold until the `ref` classification ruling lands** -- WP-06 -- because it is the one open ruling that could move paths |
| **Baize** | `check` refuses, `0 assets checked` | By reading. Tokens sit outside `kit/`, so the checker cannot see it |
| **snorkeltoast** | `check` refuses, `0 assets checked` | By reading |

**Reading is a legitimate integration path.** `check` is a check on a drop's shape, and three of these carry a convention older and more elaborate than anything Cdsync models. **Cdsync has no application-side check, by design** -- the tree is an end-state view, and a gap between it and the app is expected and never a defect.

`index.md` landed in all four on 31 July, and **two had no manifest of any kind before it**. That is the entry point.

## Deliverables

- Each of the four building against its design system, in whatever way suits that project.
- G&G first, since it has nothing in the way and will surface any process problem cheaply.
- Anything the integration *finds* about the design system recorded in `addenda/` -- **repo-authored, protected from every install path, and it flows back to Claude Design to retire when a later drop absorbs it.**

## Dependencies

Lamplight waits on WP-06's `ref` ruling. **The other three wait on nothing.**

## Notes

- **The app never reads from `design/system/`.** It is specification, not running code. Anything the application needs at runtime is delivered separately, exactly as the two Laksa theme packs were.
- After touching `addenda/`, **regenerate `BOOTSTRAP-CD.md` by hand.** Regeneration fires on sync only, so a repo-side edit has nothing to hang it on.
