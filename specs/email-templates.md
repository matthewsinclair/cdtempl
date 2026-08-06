---
asset: email-templates
name: Email templates
taxonomy: [38]
spec_version: 1
kit_version: 1
form: C
tier: 3
group: 6
audience: [customer]
inputs_missing:
  - "which emails actually send, and what event triggers each"
  - "the sending system, because it constrains what the templates can be"
  - "who edits the copy after handover, and whether they can edit HTML"
  - "whether any email is transactional, marketing, or legally required to be one of those"
  - "the sender identity — name, address, and reply behaviour"
depends_on:
  hard_facts: []
  hard_assets: [brand-guidelines, colour-system, typography-system, voice-and-tone]
  reciprocal: [messaging-framework]
bundles: [launch-set]
---
# Email templates — specification

## What it is

The set of emails the product actually sends, designed and built. Each is triggered by an
event, so **the set is defined by the events, not by a wish list** — an email with no
trigger is a template nobody will ever send.

## Email is not the web, and this is the whole difficulty

Every other customer-facing surface in the taxonomy is rendered by a browser the venture
can reason about. Email is rendered by dozens of clients, several of which are hostile to
modern layout, and **the design has to survive all of them**.

That produces constraints no other asset in this group has:

- **Layout is tables.** Not because anyone wants it, but because the clients that matter
  do not reliably support anything else.
- **CSS is inline.** Style blocks are stripped by several major clients.
- **Images are blocked by default** in many clients. An email whose meaning lives in an
  image arrives as a blank rectangle, so every image needs alt text that carries the actual
  message, and no critical content may be image-only.
- **Web fonts mostly do not load.** Specify the fallback stack deliberately and design
  against the fallback, not against the intended face.
- **Dark mode is applied *to* the email**, often by inverting colours the designer chose.
  A design that assumes a white ground will be inverted into something nobody approved.

None of these is optional knowledge. A template built as though it were a web page will
look correct in exactly one client.

## Preview text is part of the design

The first thing a recipient reads is the subject line and the preview snippet, before the
email is opened and often instead of opening it. Left unspecified, the snippet is whatever
text happens to come first — usually "View this email in your browser".

**Specify subject and preview text as designed content**, per template.

## The standard shape

| Part | Carries |
|---|---|
| The set | Each email, its trigger event, and its single purpose |
| Subject and preview | Written, per template, not left to the sending system |
| Structure | The block order, and which blocks are optional |
| Editable regions | What a non-technical person may change, and what they may not |
| Fallbacks | Font stack, image-blocked appearance, dark-mode behaviour |
| Footer | Sender identity, unsubscribe where required, and the legal minimum |

**Mark the editable regions explicitly.** Someone will edit these emails without a
designer. A template that does not say which parts are safe to change gets changed
everywhere, and the first casualty is the structure that made it render.

## One email, one action

The same discipline as print. A transactional email confirming something should confirm
that thing and ask for at most one further action. Emails that carry three calls to action
get none of them taken.

## Definition of done

- Every template names its **trigger event**. A template with no trigger is not done, it is
  speculative.
- Subject line and preview text are written for every template.
- Every image carries alt text that conveys the message, and no critical content is
  image-only.
- The template renders acceptably with images blocked.
- The font fallback stack is specified, and the design works against the fallback.
- Dark-mode behaviour is stated rather than left to inversion.
- Editable regions are marked.
- The footer carries sender identity and whatever the email's category legally requires.
- Every colour appears in `kit/tokens.json`.

## What the brief must carry

- Which emails send, and on what trigger.
- The sending system, which constrains everything.
- Who edits after handover, and whether they can edit HTML.
- Whether each email is transactional or marketing — the categories carry different legal
  requirements, and getting it wrong is a compliance problem rather than a design one.
- The sender identity and reply behaviour.

## Notes

**Why `audience: [customer]`.** These are read by customers, one at a time, usually on a
phone, usually while doing something else. That framing decides most of the design: short,
one action, legible at a glance, comprehensible with images off.

**Why no `hard_facts`.** Everything this asset needs is an input about the venture's own
systems and intentions, captured in `inputs_missing`, rather than a fact about the market
or the product that other assets also depend on.
