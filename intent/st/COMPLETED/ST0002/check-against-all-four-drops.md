---
verblock: "30 Jul 2026:v0.1: Matthew Sinclair - check run against all four installed drops"
---

# `check` against all four drops

Written 2026-07-30, after Lamplight's round-three export landed. The first check run
(`first-check-against-a-real-drop.md`) covered Gyre & Gymble only. This is the other three,
and it found one bug in the tool and one constraint that every conversion brief now has to
carry.

## The bug: zero assets was reported as a clean bill of health

snorkeltoast and Baize both returned `ok 0 assets checked -- clean, 0 advisory`, **exit 0**,
in under a second. Zero assets and "clean" are a contradiction, and the tool rendered it as
success.

`drop_looks_valid` was already wired into `check`, `import` and `site`, and it carries a
comment saying exactly why it exists -- *"a silent pass on nothing is the worst possible
output for a checker"*. It did not fire, because it proves only that `assets/` or `kit/`
**exists**. All three trees have an `assets/`. The guard passed them, the walk then yielded
nothing, every rule had nothing to read, and the report came out clean.

Fixed in `lib/cmd_check.sh`: `count == 0` is now an error with exit 2, phrased so it says
what is actually wrong rather than "no drop at" -- the directory *is* there, the drop is
not. Three tests pin it: `assets/` holding loose files, `assets/` existing but empty, and a
pin against over-firing so a real drop still passes and reports a nonzero count.
**166 tests, 0 failures** (was 163).

This is the same family as the five bugs the first run found: **a rule that cannot see a
thing does not fail, it stops checking.** It is the fourth time that shape has appeared and
the first time it reached the top-level verdict rather than a single rule.

## The constraint: `assets/` is a reserved name that three of four projects already use

The drop contract owns `assets/`. Three of the four established projects already have a
directory at that path meaning something else, and **each means something different**:

| Drop | What `assets/` holds | `check` says |
| ---- | -------------------- | ------------ |
| Gyre & Gymble | Slug directories, each with `spec.md` -- Cdsync-shaped | `17 assets checked -- clean, 35 advisory`, exit 0 |
| snorkeltoast | Four loose files: mascot and wordmark, `.png` + `.svg` | `0 assets checked`, exit 2 |
| Baize | Loose files | `0 assets checked`, exit 2 |
| Lamplight | Four media directories: `brand/ portraits/ ref/ shots/` | `4 assets checked -- 4 blocking`, exit 1 |

**No conversion brief written before this run anticipated the collision.** Both
`port-brief-lamplight.md` and `port-brief-baize.md` describe a target shape without saying
what happens to the `assets/` that is already there. Every brief now has to name the
incumbent directory and say where it goes, because the conversion cannot simply create
`assets/` alongside it.

Lamplight is the sharpest case, because its collision is *silent in the other direction*:
its four media folders are shaped enough like assets to be walked, so the tool reports four
broken assets rather than zero real ones. It fails loudly, so this is a diagnosis-quality
issue rather than a correctness one -- but a reader of that output would draw the wrong
conclusion about what Lamplight contains.

**Open for hv:** whether `check` should cross-reference `index.md` to tell "a directory
that is not an asset" from "an asset missing its spec". G&G has an `index.md` and the other
three do not, so the signal exists. Deliberately not changed here -- it redesigns the
asset-detection contract, which is more than a bug fix.

## What did not go wrong

- **G&G is unaffected.** Re-run after the fix: `17 assets checked -- clean, 35 advisory`,
  exit 0. The first run's headline stands.
- **Scale was not the problem it looked like.** Lamplight at 708 files returned in under a
  second, because it only ever walked four directories. G&G's 3 seconds for 17 assets
  across 142 files is the real cost line. The binary-detection fix reading 8000 bytes per
  file is not a bottleneck at these sizes.
