---
verblock: "16 Sep 2026:v0.2: Matthew Sinclair - hv answered the six decisions, and the answers are Decisions on cc's board"
---

# Refocus proposal: Cdsync as a venture design-system kit

**Status: hv answered all six decisions below on 16 September, and the answers are Decisions on cc's board.** `intent/docs/design-system-lifecycle.md` remains canon until thread A (`intent st new`) carries them into it, and nothing in the transport is retired before then; this document is then superseded and says so.

## The question hv asked

On 15 September hv asked whether Cdsync should stop being a way to sync a design system between Claude Code and Claude Design and become **"a way to bootstrap a design system for a new venture using a family of tried and true assets"**, now that design work happens inside Claude Code.

hv named as worth keeping and improving: the templates (web, mobile and venture), the process for creating the design system, the data room and the markdown-to-web and markdown-to-PDF pipelines, and ready-made assets such as the who's who and the investor pitch deck.

hv named as less interesting now: syncing into and out of a delivery directory or zip, syncing between Claude Design and Claude Code, and anything that assumes the two are separate tools.

## The answer given: yes

Claude Design has already left the practice. Lamplight's tree says it is now edited in place, and a sibling venture built its design system inside Claude Code from the start. Cdsync's suite still spends a large share of its tests on moving drops in and out, working around a boundary that no longer exists. What is worth keeping is the assets with their definitions of done, the quality rules and the output pipelines, and most of the good pipeline work does not live in Cdsync yet.

**The survey figures behind this were measured by subagents and not re-verified** -- about 45% of tests, counted by name, on the transport; 21 copies of `support.js`; six publish scripts. Measure them again before quoting them.

## What there is to build on

- **Cdsync itself.** The spec library (read its counts from `cdsync doctor`), including the pitch deck, who's who, investor update, venture thesis, landing page and the brand specs. The neutral kit, check rules 1, 3, 4 and 5, and the scaffolding in `new` and `init`. Missing: there is no markdown-to-PDF, and `site` builds a single index page.
- **`templprj` in Cdsync's templates.** It holds the only generic pitch deck, who's who, one-pager, brand guidelines and landing page. All are Claude Design `.dc.html` files that load React and Babel from a CDN.
- **Sibling repositories.** The course-publishing project has the most mature markdown-to-PDF engine: targets in yaml, a shared typst style, gates on the PDF, and an end-to-end test. A sibling venture's tools repository drives its site, Word documents, typst PDFs and deck theme from one token file. Lamplight and snorkeltoast have site builders that respect classification. Laksa's site-theme contract is the web target.
- **Gaps.** No data room exists anywhere; `data-room-index` is a slug with no spec. Nothing reusable for mobile. Four token formats and no shared schema.
- **Duplication.** Copies of `support.js`, several publish scripts and reading-room builders, and process docs copied into each venture and drifted.

## The proposed shape

1. **Tokens are the spine.** One token file per venture, in one format, with generators for every output: CSS variables, a daisyUI theme, the PDF style, the deck theme and Swift colours. Check rule 4 reads the token source instead of scraping.
2. **Assets are templates, not deliveries.** Rebuild `templprj`'s pieces as plain token-driven sources with no Claude Design runtime, so `cdsync new` produces a design system that already renders rather than an empty tree and a brief.
3. **Pipelines become commands.** A `publish` family: markdown to PDF (standardised on the course-publishing engine), designed pieces to PDF, and a markdown reading room. Each derived file has one generator and a gate on its output. Classification is enforced at build time, so confidential material cannot reach a public build.
4. **The data room becomes an asset family.** Write the missing specs (data-room index, executive teaser, cap-table summary, hiring plan), plus a build that assembles a classification-filtered, per-recipient watermarked bundle with its index.
5. **Web and mobile.** Web: the Laksa theme contract, generated from tokens and seeded from an existing venture's theme. Mobile: a SwiftUI token export first, and an app starter only when a venture needs one.
6. **The process ships as one playbook, not a protocol.** `brief` becomes a work order Claude Code follows in place. The drifted copies of the process docs collapse into one home in Cdsync, possibly a Claude Code skill.
7. **Retire the transport, last.** `bootstrap`, `import`, `install`, the archive checks, the drop contract, `_inbox/`, `addenda/`, `BOOTSTRAP-CD.md`, `RETURN.md`, version stamping, both Claude Design docs and their tests -- only once the replacements cover what they did.

**Principles kept:** the tree is the single source of truth and is tracked in full; the app never reads it; specs define done; counts are computed; the neutral kit; classification controls where something is shown, not whether it is tracked; no mirrors.

**Principles dropped:** never hand-edit; never repair a drop; self-contained briefs; ID high-water tables; byte fidelity for re-exports.

## As a family of threads

- **A. Canon and scope:** rule on the new purpose and rewrite the lifecycle doc.
- **B. Token spine.**
- **C. Asset family:** templates without Claude Design, the missing seed specs, and a `new` that renders.
- **D. Pipelines:** publish, reading room, data room.
- **E. Retire the transport:** a breaking release.
- **F. Web theme and mobile token export.**

A comes first, then B, then C and D side by side, then E, with F when a venture asks.

## The six decisions that are hv's

1. **Token format:** the kit's `tokens.json`, the sibling tools repository's `tokens.yaml`, or the W3C design-tokens shape?
2. **PDF engine:** typst for documents and headless Chrome for designed pieces, or just one?
3. **Web target:** Laksa themes only, or plain static HTML as well?
4. **Mobile:** a SwiftUI token export now and an app starter later, or a starter now?
5. **The name:** "Cdsync" describes the half being retired, and a rename now carries the published `v0.1.0` with it. Better settled before E than after.
6. **The six delivered projects:** leave them delivered, as ruled on 9 August, or migrate them opportunistically?
