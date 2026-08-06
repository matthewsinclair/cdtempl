---
verblock: "30 Jul 2026:v0.1: Matthew Sinclair - Lamplight's and Baize's inventories read against their trees"
---

# Lamplight and Baize, read

Written 2026-07-30 against Lamplight's round-three export (15:26) and Baize's second export
(16:29). Companion to `read-gyreandgymble-and-snorkeltoast.md`. Every structural claim below
was measured on disk, not taken from the inventory.

## The finding that collapses this thread

**Lamplight, Baize and snorkeltoast are the same shape.** Eleven paths are common to all
three:

```
assets/  docs/  handoff/  lib/  prototypes/  uploads/  venture/
CLAUDE.md  INVENTORY.md  README.md  START-HERE.md
```

That is the Claude Design *programme* house shape, and it is not a coincidence -- all three
came out of the same methodology. Gyre & Gymble is the odd one out precisely because it was
produced **to the Cdsync contract** (`assets/ kit/ notes/ index.md RETURN.md`) rather than by
the programme.

**But the sharing stops at the skeleton, and the first draft of this document overstated
it.** Measuring the top-level directories and inferring the document layer from them gave
"one conversion applied three times". Measuring the document layer says otherwise:

| | Document layer | Convention |
| - | -------------- | ---------- |
| Lamplight | `design-system/` + `venture/` | `.dc.html`, every document with a `-print` rendition |
| Baize | `design-system/` + `venture/` | `.dc.html`, no renditions |
| snorkeltoast | `brand/ print/ social/ email/ venture/` | **plain `.html`, zero `.dc.html` in the tree** |

**Lamplight and Baize are one conversion done twice. snorkeltoast is a genuine third
case.** It has no `design-system/` directory at all, and none of the `.dc.html` convention
the other two are built on. The shared skeleton is real and useful -- it means the brief's
*structure* transfers -- but the asset map does not.

The correction is worth recording because of how it happened: seven matching directory
names read as a matching shape, and the layer that actually decides the conversion was
never looked at.

## The slug mapping falls out of the shape

Each canonical `.dc.html` document is one asset. Counted on disk:

| Project | design-system/ | venture/ | Canonical documents |
| ------- | -------------- | -------- | ------------------- |
| Lamplight | 6 | 8 | **14** |
| Baize | 9 | 4 | **13** |

Lamplight's documents: `acton-index`, `design-system`, `gwidget`, `storyfield-ios`,
`storyfield-surfaces`, `wrighter-frontdesk`; `authoring-on-life`, `investor-deck`,
`leave-behind`, `pitching-to-fans`, `rights-holder-brief`, `technical-due-diligence`,
`technical-overview`, `whos-who`.

Baize's: `darts-spike`, `design-system`, `index`, `notifications`, `operator-surfaces`,
`party-handshake`, `player-surfaces`, `spikes-trivia-poker-cards`, `the-way-in`;
`investors`, `patrons`, `thesis`, `venues`.

### The trap: `-print` renditions are not assets

**Lamplight carries a `-print` copy of every document; Baize carries none.** A glob of
`*.dc.html` therefore yields Lamplight **28** assets -- exactly double the truth -- because
every print copy counts as its own slug. `wrighter-frontdesk-print` is a rendition of
`wrighter-frontdesk`, in the same relationship as a PDF, and belongs beside it rather than
beside its peers.

The house shape has per-project variation, and this is the first instance found. **Any
conversion brief must say how renditions are recognised**, not assume the projects agree.

## Decision 2 does not block these two briefs

The taxonomy holds **51 entries with 9 specs written**. A minority of the 27 documents map
onto it -- `design-system` to *Design system index*, `whos-who` to *Who's who in the zoo*,
`investor-deck` to *Pitch deck*, `thesis` to *Venture thesis*. The majority are
venture-specific by nature: `wrighter-frontdesk`, `party-handshake`, `darts-spike`,
`storyfield-ios` describe these ventures and nothing else, and no plausible taxonomy would
hold them.

That is already a settled question. A venture-specific slug imports fine and `check` reports
it as **advisory** (29 Jul decision). **So both briefs can be written now** -- Decision 2
governs how much advisory noise G&G's three slugs produce, not whether Lamplight and Baize
can be converted.

## What the inventories confirm independently

- **Both mark `venture/` and `uploads/` CONFIDENTIAL** in their own shape blocks, and
  Lamplight additionally marks `docs/investor/`, `docs/site/venture/`, `pdf/investor/` and
  `pptx/investor/`. This corroborates the gitignore decision from the supplier's side: the
  drops say themselves that they carry material which must not be tracked.
- **Both are specification, not implementation.** Neither has been applied to its project's
  code, which is what makes the conversion a documents problem rather than a code one.

## One defect to send back to Baize's CD

`INVENTORY.md` line 42 reads `design-system/ 9 — the 8 canonical design documents (.dc.html)
+ support.js`. On disk the directory holds **10** files: **9** canonical documents plus
`support.js`. Lines 56 (*"9 documents as markdown"*) and 210 (*"party-handshake adds a 13th
document"*) are both correct, so one line is out of step with two others -- the 30 July
party-handshake addition was not carried into the shape block. **Corrections land at source.**
