---
verblock: "02 Aug 2026:v0.2: matts - Filled from the ST0001/ST0002 close-out carry-forward"
wp_id: WP-01
title: "Cut the 0.1.0 release"
scope: Small
status: WIP
---

# WP-01: Cut the 0.1.0 release

## Objective

**`cdsync release` exists and nothing has ever been released.** `VERSION` is `0.1.0`, a clean-tree `cdsync release cut minor --dry-run` passes every gate, and the tarball is built by `git archive` from the tag. The machinery is done; the act has not happened.

This is first in the thread because the thread is named for it, and because everything else in here is easier to reason about against a fixed released baseline than against a moving `main`.

## Deliverables

- A tagged, packaged `0.1.0`.
- Confirmation that the tarball carries the tool and nothing about how the tool is made. `.gitattributes` declares this with `export-ignore` and a test pins it **positively** -- a list of what must be absent cannot notice a new thing that should have been.
- A decision on whether to push the tag. **Pushing is opt-in by ruling**: `cut` stops after tagging and will not push without `--push`, because it is the one step that leaves the machine and cannot be quietly undone.

## Notes

- Run the dry run first and read it. That is the house habit and it has earned itself twice.
- The release gates detect `BATS_TEST_FILENAME` and **fail** if the suite is run from inside the suite, which prevents an infinite recursion. Do not "fix" that by making it skip -- **a gate that cannot run is not a pass.**
- CI must be green on both platforms at the tagged commit, not merely on `main` at some earlier point.

## Dependencies

None. This is the one item in the thread that blocks on nothing and nobody.
