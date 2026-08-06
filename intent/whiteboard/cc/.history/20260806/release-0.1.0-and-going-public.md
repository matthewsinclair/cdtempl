# 6 August -- the rename, the public cut, and 0.1.0

Day record. The live board carries only the standing lists and current state; this is the narrative it does not need to hold.

## What happened, in order

1. **Renamed the tool to Cdsync** across five repositories. 1569 occurrences, 8 filenames, zero remnant. ST0004, closed 11/11.
2. **Globalfold** -- the live docs cut 43%, collapsing rulings that had been restated in four documents and watch-outs in three down to one home each.
3. **Pre-publication review** -- secrets, credentials, keys and absolute paths across HEAD and all 134 revisions. Clean. Two real venture contact addresses found and redacted.
4. **Truncated 135 commits to one** and republished. GitHub repository deleted and recreated, then flipped public.
5. **Cut and shipped 0.1.0.** ST0003/WP-01, closed 8/8.

## The three findings worth keeping

**A mutation can fail to apply because of the TOOL, not the pattern.** BSD `xargs` has no `-a`, so the first rename pass ran to completion having changed zero bytes while printing a tidy per-pass summary. The before/after counters caught it at `before=654 after=654`. Five instances of this class now; the first four were pattern-quoting, this one was a flag that does not exist on this platform.

**A generator pointed at the wrong root reports an empty tree with total confidence.** `bootstrap --stdout --target <repo>/design` said Lamplight had no assets. It has four, each with its `spec.md`, one level down at `design/system/`. The output was not an error -- it was a well-formed document making a false claim, which is the dangerous shape.

**A remote-tracking ref is a cached claim, not the remote.** `git rev-list` reported Lamplight's `origin` 130 commits behind and Baize's 144, while `upstream` -- the same URL -- reported 1. A `git fetch --all` collapsed every one to `ahead=1, behind=0`. Pushing on the first reading would have published what looked like 130 commits of another session's live work.

## What running `release` for real found

Two defects, neither visible from reading the code, both on the first two steps of the ceremony.

**`cut` could not tag the version a project is on.** Only `major|minor|patch`, all forward-moving, so the FIRST release of any project was unreachable. `cut minor` would have produced 0.2.0 and skipped the release the repository already announced.

**The ceremony then died one step later.** Cutting the version already in `VERSION` writes the same bytes, so `git commit` had nothing to commit. Six gates green, then failure at step 3. Three reasons nothing caught it: a dry run stops before writing; the six new unit tests asserted one layer above; and the ceremony is untestable end to end by design, because `release_gates` refuses to run inside bats.

The failed run left nothing half-written. The module header's ordering principle -- every step safe to rerun after the one following it failed -- held under its first real test.

## Publication decisions

**A force-push does not scrub history from GitHub.** The old commits stay reachable through a PR's `refs/pull/N/head` and by SHA. Delete-and-recreate was the only airtight route, which cost PR #1 and its CI history and was worth it.

**Two independent copies of the history were verified at the moment of deletion**, not on an earlier reading: the mirror's `archive/pre-public-20260806` at 135 commits, fsck clean, and a 1.1M bundle that `git bundle verify` passed. The published tree and the archived tip are **the same git object** -- the cut lost ancestry, not content.

**Accepted deliberately, and still true:** roughly 70 comment sites across `lib/`, `help/`, `specs/` and the suite name Lamplight, Baize, snorkeltoast, Gyre & Gymble and Laksa with file counts and export incidents. They are load-bearing rationale, they ship in the release tarball too, and hv ruled them acceptable. The workshop -- 86 of 214 tracked files under `intent/` -- is public for the same reason.
