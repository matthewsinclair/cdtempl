---
verblock: "29 Jul 2026:v0.1: claude-design - Round one response, filed verbatim as received"
---
# Round one response from Claude Design -- filed verbatim

Received 2026-07-29, answering `cd-brief.md` v0.4. Carried across by hv as text.

Filed as received and not edited. The spec library derived from it lives separately; this is the source document, kept so a later library edit can be checked against what was actually delivered.

Headline numbers: **51 asset types**, not the made-up "roughly twenty". Grouped by **precondition** rather than by design-versus-venture -- a better axis than the one the brief proposed, and adopted.

---

## 0. One thing to settle first: what "template" means in my hands

Before the taxonomy, a constraint that shapes every answer below, and which you should push back on now rather than discover in round two.

My output medium is **HTML and markdown**. Not Figma, not Sketch, not a component library in your framework. Concretely, what I can hand you:

- **Markdown** -- documents with blanks, specs, checklists, structured content.
- **CSS custom properties + JSON** -- tokens, in both a form a stylesheet can consume and a form a build can parse.
- **Self-contained HTML pages** -- a design system reference you open in a browser, a landing page, a component gallery with live states.
- **HTML that prints** -- decks that export to PDF and to editable PowerPoint; documents that print to a page.
- **SVG** -- only geometric primitives. I do not draw logos or illustrations, and a template should not contain a drawn mark anyway.

What this means for `templprj`: the design system template is a **browsable HTML reference plus a token file**, not a Figma library. That is arguably the more useful artefact for a venture that is going to build in code, but it is a choice, and you should make it deliberately. If a venture needs a Figma library, that is a hand-conversion from the token file and the component gallery, and the spec should say so rather than pretend otherwise.

Second constraint, same category: **I cannot make real photography, real illustration, or a real logo.** Every asset that needs those carries a placeholder and a written art direction instead. That is not a limitation of the template -- a template must not contain a real mark -- but it is a limitation of any *venture* drop, and briefs need to know it up front so nobody waits on a logo I was never going to produce.

---

## 1. The taxonomy

Grouped by **what has to be true for the asset to be writable**, not by design-versus-venture. That cut kept failing: a colour system is design, a pitch deck is venture, but a messaging framework is both and a landing page is both twice over. What actually clusters is the *precondition* -- what you need to know before you can start. That grouping also has the property the brief asks for: it implies no order of production, because several groups can be worked at once.

Audience key: **INV** investor, **CUS** customer, **INT** internal, **TEAM** team, **PUB** public.

### Group 1 -- Foundations (need only facts about the venture)

| # | Asset | What it is | For |
|---|---|---|---|
| 1 | Positioning statement | Who it is for, what it does, why it is different, in a page | INT |
| 2 | Venture thesis | Why this, why now, why us -- the argument the venture rests on | INT, INV |
| 3 | ICP definition | The buying target: firmographics, triggers, disqualifiers | INT |
| 4 | Personas | The humans inside the ICP -- goals, constraints, vocabulary | INT |
| 5 | Problem & opportunity statement | The job being done today and why it is done badly (JTBD) | INT |
| 6 | Competitive & category landscape | Who else is in the frame, and what category you are claiming | INT, INV |
| 7 | Product principles | The handful of rules that settle arguments about what to build | INT, TEAM |
| 8 | Naming & nomenclature | Product, feature and tier names, and the rules for coining more | INT, PUB |

### Group 2 -- Verbal identity (needs Group 1)

| # | Asset | What it is | For |
|---|---|---|---|
| 9 | Voice & tone guide | How the venture sounds, with do/don't pairs and register by context | INT |
| 10 | Messaging framework | Message house: one-liner, pillars, proof, objection handling | INT -> CUS |
| 11 | UX writing standards | Microcopy rules: buttons, errors, empty states, dates, numbers, currency | INT |

### Group 3 -- Visual identity (needs Groups 1-2; the brand)

| # | Asset | What it is | For |
|---|---|---|---|
| 12 | Logo & mark suite | Primary, secondary, mark-only, clear space, misuse, minimum sizes | PUB |
| 13 | Colour system | Full palette with roles, contrast pairings, and light/dark behaviour | INT, PUB |
| 14 | Typography system | Faces, scale, weights, roles, line lengths, fallbacks, licensing | INT |
| 15 | Iconography | Set, grid, stroke and corner rules, naming, coverage list | INT |
| 16 | Imagery & illustration direction | Written art direction plus a reference set -- subject, treatment, crop, what to avoid | PUB |
| 17 | Motion principles | Durations, easings, what may move and what must not | INT |
| 18 | Brand guidelines | The assembled identity document -- the thing you send a partner agency | INT, PUB |
| 19 | Brand asset kit | Exports: favicons, app icons, social avatars, OG images, signature, letterhead, slide master | INT, PUB |

### Group 4 -- Design system (needs Group 3)

| # | Asset | What it is | For |
|---|---|---|---|
| 20 | Design tokens | The machine-readable layer: colour, type, space, radius, shadow, motion, z-index | INT |
| 21 | Grid, layout & responsive spec | Columns, gutters, containers, breakpoints, density | INT |
| 22 | Component library | The inventory, each with anatomy, variants, sizes, props and usage rules | INT |
| 23 | States & interaction spec | Loading, empty, error, success, partial, permission-denied, focus, hover, disabled | INT |
| 24 | Pattern library | Composed patterns: forms, tables, nav, auth, onboarding, search, notifications | INT |
| 25 | Accessibility standard | Target level, contrast rules, focus order, keyboard model, motion and text preferences | INT |
| 26 | Theming spec | How light/dark, density and any white-labelling are expressed through tokens | INT |
| 27 | Data visualisation standard | Chart types, categorical and sequential ramps, axis and label rules | INT |
| 28 | Design system index | The browsable front door: what exists, where it lives, how to use it, version | INT |

### Group 5 -- Product definition (needs Groups 1 and 4, reciprocally)

| # | Asset | What it is | For |
|---|---|---|---|
| 29 | Information architecture & sitemap | Every screen and its parent, with naming | INT |
| 30 | Key flows | The handful of journeys that matter, wireframe-grade, with states | INT |
| 31 | Customer journey map | The outside view: awareness to advocacy, with moments of truth | INT |
| 32 | Roadmap | Now / next / later, with the reasoning, not dates you will miss | INT, INV |
| 33 | Pricing & packaging | Tiers, what gates what, and the logic of the fences | INT, CUS |

### Group 6 -- Customer-facing surfaces (needs Groups 2-4)

| # | Asset | What it is | For |
|---|---|---|---|
| 34 | Product one-pager | The single page you leave behind after a conversation | CUS, INV |
| 35 | Landing page | The primary public surface, designed and written | PUB |
| 36 | Sales deck & demo script | The narrated version, with the demo path written down | CUS |
| 37 | Case study template | Proof, in a repeatable shape | CUS, PUB |
| 38 | Email templates | Transactional and lifecycle, in a shared shell | CUS |
| 39 | Social & ad kit | Sized frames with the type and crop rules already made | PUB |
| 40 | Launch kit | Announcement post, press note, FAQ, and the sequencing | PUB |
| 41 | Demo video storyboard | Shot list, on-screen copy, narration, length | CUS |

### Group 7 -- Investment (needs Groups 1, 3 and real numbers)

| # | Asset | What it is | For |
|---|---|---|---|
| 42 | Pitch deck | The raise narrative, in slides | INV |
| 43 | Executive teaser | One page, sent before a meeting is agreed | INV |
| 44 | Financial summary & cap table narrative | The numbers, and the story the numbers are told in | INV |
| 45 | Data room index | The list of what a diligence process will ask for, and its state | INV |
| 46 | Investor update | The recurring one -- metrics, asks, misses, in a fixed shape | INV |

### Group 8 -- Team & operating (needs facts no design process can invent)

| # | Asset | What it is | For |
|---|---|---|---|
| 47 | Who's who in the zoo | Who is here, what they own, how to reach them | TEAM, INV |
| 48 | Hiring plan & role scorecards | The next roles, in sequence, each with a definition of success | INT |
| 49 | Job description template | The outward-facing version, in brand voice | PUB |
| 50 | Ways of working | Cadence, rituals, decision rights, where things are written down | TEAM |
| 51 | Decision log | The durable record of decisions and what changed them | INT |

**51 types.** Two notes on the shape of that list.

*Genuinely both design and venture*, and the brief asked me to say so rather than pick: **messaging framework** (10), **landing page** (35), **product one-pager** (34), **pitch deck** (42), **sales deck** (36), **launch kit** (40), **customer journey map** (31), **naming** (8). Each of these is unbuildable without both framings, which is the strongest evidence for grouping by precondition rather than by discipline.

*The decision log* (51) is the odd one and I have put it last deliberately -- see section 8.

---

## 2. Priorities

### Tier 1 -- recurring, every venture, and what round two should build

Eight. This is the set that runs a real venture, per your scope note.

1. **Design system** (20-24, 28 as one composite directory)
2. **Brand guidelines** (12-19 assembled)
3. **Positioning + ICP + personas** (1, 3, 4 -- one short document, not three)
4. **Product one-pager** (34)
5. **Pitch deck** (42)
6. **Who's who in the zoo** (47)
7. **Landing page** (35)
8. **Investor update** (46)

Why those eight: every venture I have seen needs all of them within the first quarter, they are the ones asked for by name, and between them they exercise all four template forms (section 5), which is the real test of whether the output structure works.

### Tier 2 -- recurring, but later or on a trigger

9, 10, 11, 21, 25, 29, 30, 32, 33, 43, 44, 45, 48, 50. Frequent enough to be worth templating in round three. Several are triggered rather than scheduled -- pricing when you start charging, hiring plan when you start hiring.

### Tier 3 -- occasional, specify but do not template yet

5, 6, 7, 8, 26, 27, 31, 37, 38, 39, 40, 41, 49, 51. Genuinely occasional, or so venture-specific that a template hinders (section 5, Form D).

---

## 3. The neutral kit

The single file every template imports. Neutrality lives here, so "is this too charming" is one question about one file.

### 3.1 Colour -- a pure greyscale ramp, no hue at all

Twelve steps, named by number, never by role. Role names (`--color-primary`) are where taste re-enters, because naming something primary is deciding it matters.

```
--grey-0:    #ffffff
--grey-50:   #f7f7f7
--grey-100:  #ededed
--grey-200:  #dcdcdc
--grey-300:  #c4c4c4
--grey-400:  #a3a3a3
--grey-500:  #808080
--grey-600:  #616161
--grey-700:  #474747
--grey-800:  #2e2e2e
--grey-900:  #1a1a1a
--grey-1000: #000000
```

Chroma is exactly zero. Any tint -- a warm white, a blue-black -- is an aesthetic decision, and a decision made in the kit is a decision inherited by every venture without anyone choosing it. That is the failure mode the kit exists to prevent, so the kit must not commit it.

One accent slot exists and resolves to grey:

```
--accent:    var(--grey-500)
--accent-fg: var(--grey-0)
```

Templates reference `--accent` wherever a real venture will want colour. Nothing looks designed, but the seams are in the right places, and a venture drop is a two-line change.

Contrast pairings are stated as a table in the kit, not left to be worked out: `grey-700` and darker on `grey-0`/`grey-50` for body text; `grey-600` for secondary; nothing lighter than `grey-500` carries text at any size.

### 3.2 Type -- two stacks, two weights, six steps

```
--font-text: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Helvetica, Arial, sans-serif
--font-mono: ui-monospace, SFMono-Regular, "SF Mono", Menlo, Consolas, monospace
```

No webfont, no `<link>` to a font service. A loaded typeface is a brand decision and would be inherited silently.

Two weights only: 400 and 600. No display face, no letterspacing, no small caps, no italics except in prose quotations.

Scale, ratio 1.25 on a 16px base: `13 / 16 / 20 / 25 / 31 / 39 / 49`.

Two floors override the scale, from standing practice rather than preference: **24px minimum for anything on a 1920x1080 slide**, and **12pt minimum for anything printed**. Where those conflict with the ramp, the floor wins and the kit says so.

### 3.3 Space, radius, line

- Space, 4px base: `4 / 8 / 12 / 16 / 24 / 32 / 48 / 64 / 96`.
- **Radius: 0.** Rounded corners are a style decision.
- **Shadow: none.** One hairline instead: `1px solid var(--grey-300)`. Elevation is a style decision too, and shadow is where templates get pretty first.
- Max line length for prose: 68 characters.

### 3.4 Placeholder treatment

Two distinct kinds of blank, and they must look different, because they fail differently.

**Missing imagery** -- a diagonal hairline hatch on `--grey-100`, a `--grey-300` hairline border, and a centred monospace caption in `--grey-600` naming exactly what belongs there: `product shot`, `team photo`, `founder headshot 1:1`. Never a drawn SVG scene, never stock, never a gradient. The caption is the art direction in miniature.

**Missing copy** -- monospace, `--grey-600`, square-bracketed and lower case: `[venture name]`, `[one-line description]`, `[metric, with units]`. Bracketed and monospace makes an unfilled blank both visually obvious in a screenshot and greppable in a diff, which is what stops a half-filled template shipping.

### 3.5 The prohibitions

The kit's teeth. Templates may not contain: gradients; border radius; box shadows; any hue at all; a webfont; more than two weights; drawn illustration; photography; icons beyond geometric primitives (square, circle, triangle, line, chevron, cross, tick); animation beyond a 120ms opacity or position change; more than one background value per page.

Each of these is a thing I will otherwise drift into, and each is a thing a venture inherits invisibly. The list is the mechanism.

### 3.6 What the kit is not

The kit is not a starting palette. It is a **deliberately unfinished** one, and a venture's first design act is to replace it -- accent, faces, radius, elevation -- from the brand. The kit's job is to make that replacement obvious and cheap, and to make forgetting to do it visible.

---

## 4. The output structure

```
$CDSYNC_TARGET/
  RETURN.md              # this drop's narrative. Mandatory. See section 8.
  brief.md               # the order this drop answers, copied in verbatim
  index.md               # manifest: every asset present, its status, its spec version
  kit/
    kit.md               # the neutral kit, written down
    tokens.css           # custom properties
    tokens.json          # same values, parseable
  assets/
    <asset-slug>/
      spec.md            # what complete means for this asset, travelling with it
      <artefact files>
      exports/           # pdf, pptx, png -- generated, never hand-edited
      src/               # working files, if any
  notes/
    <topic>.md           # optional; durable thinking that is not an asset
```

### Why flat `assets/`, and not grouped

The temptation is `brand/`, `product/`, `venture/`. I am arguing against it for three reasons, and this is the part of the proposal most worth arguing back on.

1. **Grouping is an order in disguise.** `01-brand/` obviously implies sequence; `brand/ product/ venture/` implies it only slightly less, because a reader infers left-to-right dependency from a sibling list. Your own constraint is that the structure must not imply an order of production. Flat is the only layout that genuinely doesn't.
2. **Eight of the assets are genuinely both** (section 1). Any grouping forces a lie about them, and the lie is load-bearing because it decides where people look.
3. **Retrofitting becomes `mkdir` and `mv`.** An existing venture's artefacts map onto flat slugs one at a time, in any order, with nothing left over. A grouped layout requires deciding the whole taxonomy before the first file moves.

Grouping is real and useful -- it just belongs in `index.md` and in the bundles (section 7), where it is data rather than a directory you have to be right about.

### Why every asset directory has the same shape

`spec.md` travelling *with* the artefact is the important part. It means the definition of done is readable next to the thing being judged, without anyone consulting Cdsync. The spec library on your side stays the source of truth; the copy in the drop is a stamped duplicate, with its version in the front matter, so a stale one is detectable.

`spec.md` front matter carries the checkable state:

```yaml
asset: pitch-deck
spec_version: 1
status: draft | complete | spec-only
blanks: 4          # unfilled [bracketed] placeholders remaining
inputs_missing:
  - "round size and use of funds"
```

`blanks` and `inputs_missing` are how a drop reports its own incompleteness rather than leaving you to find it. A drop with `status: complete` and `blanks: 4` is a contradiction a script can catch.

### `index.md`

One table: slug, name, status, spec version, and what it is waiting on. It is the answer to "what did I actually get" and the thing you read first after `RETURN.md`.

---

## 5. Template form, per asset type

Not uniform, as you expected. Four forms.

**Form A -- document with blanks.** Markdown, real structure, every venture-specific value a bracketed monospace placeholder. Prose that is *always* true is written out; prose that is venture-specific is a blank with a note on what makes a good answer.
-> 1-11, 25, 29, 31-33, 43-46, 47-50.

**Form B -- structure with placeholder values.** A working artefact whose content is deliberately valueless. `tokens.css` is the type case: correct structure, complete role coverage, every value from the neutral ramp.
-> 13, 14, 15, 17, 20, 21, 23, 26, 27.

**Form C -- built artefact with placeholder content.** A real, working, viewable thing -- a deck that navigates and prints, a landing page that lays out, a component gallery with live states. The craft is real; the content is `[bracketed]` and the imagery is hatched. This is the form that is worth the most and costs the most.
-> 18, 19, 22, 28, 34, 35, 36, 37, 38, 39, 42.

**Form D -- spec only, no artefact.** Where the content is wholly venture-specific and a template would actively hinder by anchoring the answer.
-> **12 Logo & mark suite** -- a template mark is worse than no mark; I would be handing over something that must be thrown away, and templates get kept. Spec plus a checklist of what a complete suite delivers.
-> **16 Imagery direction** -- the artefact *is* a reference set, and a neutral reference set is a contradiction. Spec plus the questions that produce one.
-> **40 Launch kit** and **41 Demo storyboard** -- both are so tied to what is actually launching that a skeleton would be filled in against its own grain.
-> **51 Decision log** -- an append-only file. A template is one line of front matter and a heading; anything more is prescribing what decisions to have.

The forms matter because they set expectations about round-two cost. Form A is cheap and there are twenty-odd of them. Form C is where the time goes: eleven assets, and the Tier 1 eight contains five of them.

---

## 6. Dependencies

Three hard classes, then the reciprocal ones stated plainly so the structure doesn't have to encode them.

### Hard: needs a fact only you can supply

No design process can invent these, and a brief that omits them produces either a blank or a fabrication.

- **47 Zoo** <- names, roles, photos, bios
- **44 Financial summary** <- the model
- **42 Pitch deck** <- round size, use of funds, traction numbers
- **46 Investor update** <- the period's actual metrics
- **33 Pricing** <- what you will actually charge
- **48 Hiring plan** <- budget and sequence
- **12 Logo** <- a designer, or a decision to commission one

### Hard: needs another asset to exist

- Everything visual <- **kit** (template land) or **13, 14** (venture land)
- **22 Components** <- **20 tokens** + **21 grid**
- **24 Patterns** <- **22 components** + **23 states**
- **28 Index** <- 20-27, because it is their front door
- **18 Brand guidelines** <- 12-17
- **19 Asset kit** <- **12 logo**
- **35, 36, 37, 38, 39** <- **10 messaging** + visual identity
- **30 Key flows** <- **29 IA**
- **11 UX writing** <- **9 voice**

### Reciprocal -- must not be ordered

State these as *loops*, and the structure deliberately does not sequence them:

- **42 deck <-> 1 positioning.** Making the deck is how positioning gets tested; nothing exposes a weak position faster than trying to put it on a slide.
- **35 landing page <-> 10 messaging.** The page reveals which pillars carry weight.
- **30 flows <-> 22 components.** Flows demand components; components constrain flows.
- **33 pricing <-> 3 ICP.** Each is evidence about the other.
- **13/14 colour & type <-> 9 voice.** A brittle voice and a soft palette will not both survive.

This is the practical case for flat `assets/` and for `RETURN.md`: the loops are real, so the filesystem should stay silent about order and the drop should carry a place to say "working on the deck changed my view of the positioning."

---

## 7. Bundles

Seven. Each is a name a brief can use instead of a list.

| Bundle | Contents | When |
|---|---|---|
| **Founding set** | 1, 2, 3, 4, 5, 47 | Day zero. Before any visual work is worth doing. |
| **Identity set** | 9, 12, 13, 14, 15, 16, 17, 18, 19 | Once positioning holds. |
| **Product set** | 11, 20, 21, 22, 23, 24, 25, 28, 29, 30 | Once identity exists and you are building. |
| **Seed set** | 42, 43, 44, 45, 47, 34 | Raising. |
| **Launch set** | 10, 35, 38, 39, 40, 41, 34 | Going public. |
| **Rebrand set** | Identity set + 19 + an audit inventory of what changes | Renaming or repositioning. |
| **Operating set** | 46, 48, 49, 50, 51 | Continuous, from first hire. |

Overlaps are deliberate: **34 product one-pager** is in both Seed and Launch, **47 zoo** in both Founding and Seed. A bundle is a view, not a partition, and `index.md` tracks each asset once regardless of how many bundles asked for it.

Two more notes. **The Founding set is the only one with a real prerequisite relationship to the others** -- everything downstream inherits from it, so a brief ordering the Identity set without a Founding set already in place should say what stands in for it. And **"Product set" is where most of the round-two cost sits**, so a brief ordering it should expect it to arrive in pieces.

---

## 8. What the brief must carry

Derived from the union of the specs' inputs, split into a universal header and per-asset requirements.

### 8.1 Universal header -- every brief, every time

```yaml
venture: "[name]"
one_liner: "[what it does, one sentence]"
stage: pre-seed | seed | series-a | scaling
round: 3                          # which drop this is
spec_library_version: 1
target_structure_version: 1
order:
  bundles: [seed-set]
  assets: [landing-page]          # additions outside the bundles
inherits_from: none | "previous drop" | "existing brand at <path>"
fixed:                            # decided; do not re-invent
  - "company name is X"
  - "we are calling the category Y"
open:                             # licensed to invent
  - "everything visual"
locale: en-AU
currency: AUD
accessibility_target: WCAG 2.2 AA
formats_required: [pdf, pptx]
effort: "one pass, argue-with-able" | "finished"
changed_since_last: "[what moved]"
```

The two fields that matter most are `fixed` and `open`. Almost every failure in this class of work is one of two things: I invented something that was already decided, or I left a blank where I was expected to invent. Those two lists close both, and everything else in the header is hygiene by comparison.

### 8.2 Per-asset inputs

Only where the asset needs something beyond the header. This is the part the specs' front matter mirrors as `inputs_missing`.

- **Pitch deck** -- round size, pre/post, use of funds, traction with dates, named comparables, the one thing you want remembered, length ceiling, whether numbers are real or illustrative.
- **Investor update** -- the period, the metric set (fixed across updates), the asks, and the misses. Updates that omit misses read as marketing.
- **Zoo** -- names, titles, what each owns, headshots or a licence to hatch them, whether it is internal or investor-facing (it changes what goes in).
- **Financial summary** -- the model, and which three numbers are the argument.
- **Landing page** -- the single conversion action, the traffic source, whether it is pre- or post-launch.
- **Design system** -- the target stack, whether dark mode is in scope now, density requirements, and whether an existing product must be matched or replaced.
- **Component library** -- the actual inventory needed, or an explicit "start from the standard set."
- **Pricing** -- the fences you are willing to enforce, and the floor.
- **ICP / personas** -- any real customer evidence. Without it these are hypotheses and must be labelled as such in the artefact.
- **Sales deck** -- the demo path, and how long the meeting is.
- **Case study** -- the customer, and what they have approved you to say.
- **Brand guidelines** -- whether a mark exists, and who else will use the document.

### 8.3 The gaps -- what past asks have consistently left out

The brief calls this the highest-value part, so it is specific rather than diplomatic.

1. **Whether I may invent facts, or must leave blanks.** The single most common omission and the most expensive. A plausible invented number is worse than an obvious blank, because it survives into a document someone acts on.
2. **Audience.** "Make a deck" without investor-versus-customer is a coin flip on structure, length, and tone.
3. **Whether numbers are real or illustrative.** And if illustrative, they must be *visibly marked* in the artefact, not just understood in chat. This is the failure with the worst consequences and it recurs.
4. **Existing constraints presented as absent.** A colour already in use, a name already registered, a deck a partner has already seen. Discovered late, these invalidate finished work.
5. **Output format.** PDF, PPTX, HTML, editable-by-whom. It changes construction, not just export.
6. **Length ceilings.** Ten slides and twenty slides are different arguments, not the same argument at two lengths.
7. **Locale.** Currency, date format, spelling, units. Cheap to state, tedious to retrofit.
8. **Who reviews it, and what done means to them.** A deck for a partner meeting and a deck for a board pack have different definitions of finished and the difference is not in the content.
9. **What has already been tried and rejected.** Without it, the second attempt re-proposes the first.
10. **Real team facts.** Persistently late, and the zoo cannot start without them.

### 8.4 Where "working on X changed my view of Y" goes

`RETURN.md` at the top of every drop, with fixed headings so it cannot degrade into a changelog:

```markdown
# Return -- [venture], round [n]

## What is in this drop
[assets, with status]

## Revisions to understanding
[Mandatory. Present-but-empty when there is nothing.
 What working on one asset changed about another.]

## Decisions I made that you did not ask me to make
[Every place I filled a gap. The list you audit.]

## What I could not do, and why
[Blocked on facts, or on things outside my medium.]

## What I would do next
```

Two additions to what you adopted.

**"Decisions I made that you did not ask me to make"** is the counterpart of the `fixed`/`open` lists, and I think it is nearly as valuable as the revisions heading. It makes invention auditable in one place rather than discoverable by reading everything.

**`RETURN.md` is per-drop and therefore perishable.** Round four's return does not contain round two's insight, and a durable revision of understanding will be lost in the pile. That is what **asset 51, the decision log**, is for: append-only, in the venture, cumulative. The mechanism is a rule rather than a file format -- anything under *revisions to understanding* that is still true next round gets promoted into the decision log. If that promotion is nobody's job it will not happen, so the spec should name whose job it is. My suggestion: mine, at the start of each drop, from the previous `RETURN.md` -- which means the previous return needs to travel with the next brief. That is a small change to the brief contract with a large payoff, and it is the one place I would ask you to add rather than subtract.

---

## 9. What I would argue about, if you only argue about three things

1. **Flat `assets/` versus grouped.** Section 4. I have made the strongest case I have; a directory layout is expensive to change later and this is the moment.
2. **The design system as browsable HTML plus tokens, not a Figma library.** Section 0. Defensible, but it is a real fork in what `templprj` becomes, and it should be chosen rather than defaulted into.
3. **Form D -- five assets get a spec and no artefact.** Section 5. If you want an artefact for all fifty-one, say so, but I think for those five a template is worse than nothing, and templates get kept.
