---
verblock: "02 Aug 2026:v0.2: matts - Filled from the ST0001/ST0002 close-out carry-forward"
wp_id: WP-08
title: "Housekeeping and small gaps"
scope: Small
status: Not Started
---

# WP-08: Housekeeping and small gaps

## Objective

The small things that are individually not worth a work package and collectively worth one. Each is independent; none blocks anything.

## The list

### Baize's `BOOTSTRAP-CD.md` is genuinely stale

Steel-thread high-water 23 against a tree at 24. **Not noise** -- the other projects regenerate byte-identical, so this one is a real difference. It has been regenerated and **left uncommitted**, because that repository carries hv's own uncommitted work and committing over it was not mine to do.

### Two gaps in `cdsync brief`

Both recorded against `brief` and neither addressed:

- **It cannot express a repackaging round** -- a round whose job is to reshape what already exists rather than build something new.
- **It cannot order a slug the library does not hold.** Correct as a refusal, but it means a genuinely new asset type cannot be ordered at all until WP-03 writes its spec, which is a chicken-and-egg for anything novel.

### Should a stale generated document be detectable?

An advisory rule comparing `BOOTSTRAP-CD.md`'s mtime against the newest file in the tree. **It has bitten twice**: once from a repo-side edit, and once from a generator change that staled all four copies at once **with no local symptom at all** -- they were regenerated only because the board said to.

Cheap to build. **Not built, because it is unasked scope**, and this project has a standing preference for not inventing rules nobody ordered.

### Intent's template bakes an absolute path

`[[INTENT_HOME]]` is substituted into `.claude/settings.json` at install time, so every project built from the template carries an absolute path to one machine. **Cdsync's is fixed** and a test guards it. **Baize's and Lamplight's still carry theirs.** Upstream issue, worth reporting to Intent rather than patching per project forever.

### Downloads housekeeping

All optional and **none of it vestigial** -- this is the 31 July consolidation, not junk:

| Directory | Size |
| --------- | ---- |
| `claude-design-superseded-rounds-202607/` | 1.3G |
| `lamplight-design-drops/` | 1.1G |
| `Lamplight Design System/` | 281M |
| `baize-repo-snapshots-202606-202607/` | 233M |

**`baize-design-drops/` 441M stays** -- it is the off-repo home named in Baize's own root `.gitignore`.

**Now also six spent `_inbox/` directories.** All gitignored and local-only, and the two newest hold the Laksa theme packs, **which exist nowhere else** -- do not clear those two until Laksa has taken them.

### The whiteboard roster

`intent/whiteboard/README.md` is still deferred. **No `hv` node here, by hv's ruling -- `cc` is the whole roster in Cdsync for now**, so the roster document has had nothing to say.

## Deliverables

Each item either done, or explicitly declined with a reason. **An item declined on the record is finished; an item that quietly stays on a list forever is not.**

## Dependencies

None.
