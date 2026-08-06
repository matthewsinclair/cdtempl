---
verblock: "29 Jul 2026:v1: claude-design - Surfaced while building the pitch deck probe"
---
# Tokens and built artefacts: a drift risk, and the check that closes it

Surfaced by the round-two probe. Durable, so it is here rather than only in
`RETURN.md`.

## The situation

The kit exists in two forms and is consumed in three ways.

1. `kit/tokens.css` — custom properties. Consumed directly by the venture's
   application: Tailwind theme, daisyUI theme, `assets/css/`. This is the path
   the architecture was designed for and it works as intended.
2. `kit/tokens.json` — the same values, parseable. Consumed by any build step or
   script that needs them without parsing CSS.
3. **Built HTML artefacts** — the decks, galleries and pages of Form C. These
   **restate the values literally** rather than linking the stylesheet.

Point 3 is the one worth writing down.

## Why artefacts restate rather than import

Two reasons, and the first is not negotiable from my side.

**Artefacts must be directory-portable.** This was originally written as "open
standalone", which was overstated and has been corrected — see *The unit of
portability* below. The claim that survives is narrower and sufficient: an
artefact travels as its own directory, so a same-directory sibling resolves
wherever that directory is put, and a path two levels up does not. A linked
`../../kit/tokens.css` is a blank page the moment the asset directory is moved,
zipped on its own, or imported into a venture whose target is laid out
differently. An artefact that only works in place is an artefact that will be
seen broken.

**Values inline paint immediately.** A stylesheet defers everything the reader
sees until both the rules and the markup have arrived. For a deck this is the
difference between a slide appearing and a white rectangle appearing.

So `#c4c4c4` appears literally in the pitch deck, in the place where an
application would write `var(--line)`.

## The cost

The kit and the artefacts can drift. Someone edits `--grey-300` in
`tokens.css`, the deck keeps the old value, and nobody notices because both look
grey. This is exactly the failure class the kit was built to prevent, arriving
by a different door.

Handling it by care does not work, for the same reason the prohibitions exist.

## The unit of portability

Correcting the claim above, because this note will be the thing someone cites.

The deck loads `./support.js` and `./vendor/deck-stage.js`. Both are siblings
within the asset directory, so the deck is **directory-portable, not
file-portable**: zip `assets/pitch-deck/` and it works anywhere; email the
`.dc.html` alone and it is a blank page, in exactly the way the argument warns
about.

That is enough for the inlining conclusion, which does not depend on the
stronger claim. Same-directory siblings travel with the asset directory; `../../`
does not. But the wording mattered, and "standalone" was wrong.

**The unit of portability is the asset directory.** That is now a property of the
structure rather than an accident of one asset, and it is the reason `vendor/`
lives inside each asset directory rather than once at the target root. A shared
`$CDSYNC_TARGET/vendor/` would save bytes and reintroduce precisely the
two-levels-up fragility this note exists to warn about. Duplication is the
correct trade: bytes are cheap and a deck that does not open is not.

Where genuine file-portability is needed — emailing one artefact to someone
outside the venture — that is what a bundled single-file export in `exports/` is
for. It is a generated artefact, not the source.

## The check

A fourth rule for `cdsync check`, and mechanically the cheapest of the four:

> **Every colour literal in an asset's source must appear in
> `kit/tokens.json`.**

Grep every `#rrggbb` and `rgb()` under `assets/**`, resolve against the ramp in
`tokens.json`, fail on anything unmatched.

### Two exclusions, and why one of them is not a directory

`exports/` is excluded because its contents are generated. Checking a generated
file checks the generator, and the generator is not in the repository.

Vendored runtime also has to be excluded, and here the obvious implementation is
the wrong one. **Excluding `vendor/` by path does not work**, because not all
runtime can be put there: this project's authoring runtime emits
`<script src="./support.js">` as a sibling of every `.dc.html`, and that path is
not the author's to set. A path-based exclusion therefore needs `support.js`
named as a special case — which is the maintained exception list that the
prohibitions-over-instructions principle exists to avoid, arriving one level
down.

**Exclude by declaration instead.** Every vendored file states what it is in its
first few lines:

```
GENERATED from dc-runtime/src/*.ts -- do not edit
Copied omelette starter. Re-running copy_starter_component ... overwrites this file.
```

So the rule is: skip any file whose first ten lines contain one of those markers
**inside a comment**.

The comment scoping is a correction, and it matters. As first written the pattern
matched prose *about* generated things, not only generated files:
`exports/README.md` opens "Generated. Never hand-edited." and exempted itself from
a check it should pass. Harmless there — READMEs carry no colour — but a rule where
any file that discusses generation opts out of being checked is a rule that will
be used that way eventually, and not deliberately.

So the marker must sit in a comment for its language: `//` or `/* */` in
JavaScript and CSS, `<!-- -->` in HTML and markdown, `#` in shell and YAML. Every
real vendored file qualifies — a generated file's banner is always a comment,
because it has to be inert. The documentation false-positive drops out.

This is better than a path rule on three counts. It requires nobody to have put
a file in the right place, so correctness does not depend on an instruction being
followed. It covers runtime that *cannot* be moved, which a path rule cannot. And
new vendored files arrive already exempt, carrying their own declaration, so the
rule never needs updating.

`vendor/` still earns its place — 205KB of minified JavaScript sitting beside
`spec.md` is illegible, and a directory says "not yours to maintain" to a human
at a glance. But it is an organisational convenience, and the check must not
depend on it.

With those exclusions the rule catches both directions of the problem at once:

- **Drift** — an artefact holding a value the kit no longer contains.
- **Smuggling** — a hue entering an artefact without passing through the kit,
  which is prohibition 4 becoming enforceable rather than aspirational.

The second is the more valuable of the two. It is the single check that makes
neutrality a property of the repository rather than a property of whoever last
touched it. If only one of the four rules gets built, build this one.

## A related rule not worth building

Font stacks could be checked the same way, but there is one stack and it appears
in one form. Checking it would be ceremony. Colour is worth checking because
there are twelve values, they are indistinguishable by eye, and a hue is exactly
what someone adds when they are trying to be helpful.
