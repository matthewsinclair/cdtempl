---
verblock: "31 Jul 2026:v0.1: cc - Covering notes for the three Claude Design projects, 31 July round"
status: Draft
---

# Covering notes — 31 July 2026

Three messages for hv to send. **Each one accompanies that project's `design/system/BOOTSTRAP-CD.md`, uploaded as a file.** The document carries the substance; these are covering notes, deliberately short.

Baize is mid-round and holding for two answers. Gyre & Gymble and snorkeltoast have not run a round since **30 July 09:49** and have never seen a bootstrap document.

---

## 1. Baize — answering the round, then export

> Three answers, then please export.
>
> **First: the attached `BOOTSTRAP-CD.md` supersedes the one you read.** You were right to refuse the restructure it appeared to order — that was a fault in the document and it is fixed. This version tells you to export the shape you already have. It also carries several rules that were not there before, including what not to export back. Read it before the rest of this.
>
> **1. The filled action on `no-table`.** Your reasoning holds — keep it. AC-04.5 is scoped to play, `no-table` is the front door at screen 01, and "Open the camera" has always been there. The addendum over-reached by one state.
>
> **2. The copy discrepancy.** The document wins and §07 is right. An addendum records a gap; where it quotes the design it is a *citation*, not an amendment — so a citation that disagrees with the document is simply a wrong citation. No change needed in either place.
>
> **3. The two PDFs are done.** Both regenerated and landed.
>
> On `INVENTORY.md`'s 51 against the PDF table's 56 — thank you for flagging it rather than guessing. Check it once more now the two PDFs are current; the missing one alone may account for most of the gap.
>
> **The steel threads under `handoff/intent/` have been taken into the project.** All eight are now in Baize's own `intent/st/_inbox/` awaiting triage, so **delete `handoff/intent/` from your tree and do not export it.** Your rewrite of AC-04.6 and the new AC-04.8 came across with them. The updated `BOOTSTRAP-CD.md` explains the standing rule.
>
> **Two spent transport documents to delete from `uploads/` as well:**
>
> - `note-for-cd-in-baize.md` — the 30 July corrections note. Your `handoff/CORRECTIONS-2026-07-30.md` answers it section by section and **that receipt stays**, so nothing is lost by removing the request that produced it.
> - `export-brief-baize.md` — the brief for the 30 July round, which has happened.
>
> Neither is design material. They were handed to you as instructions, came back in the export, and are now tracked in the repository as though they were deliverable. **Keep everything else in `uploads/`** — the photography and screenshots are real source.
>
> Then **export the whole tree as one archive** — everything, including what you did not touch this round. Not a delta. The receiving side replaces what it holds with what you send, so anything left out reads as a deletion.
>
> Please keep `index.md` and `RETURN.md` in it. The manifest is the first this programme has had and it is wanted.

---

## 2. Gyre & Gymble — adopt the document, then export

> Attached is `BOOTSTRAP-CD.md`, generated from the design system as it actually stands in the repository. **It is new — please read it before doing anything else.** It replaces every instruction carried by hand before now.
>
> Nothing has changed on your side and no round is being ordered. The point of this one is to get us both onto the same protocol before the next round, because the last export was 30 July and a good deal has been settled since.
>
> Three things in it are worth knowing before you read:
>
> - **The repository is the source of truth for the design system, and you are a tool that works on it.** Corrections land in the material you export, never only in a delivery note — a fix that lives in a note is reverted by your next export.
> - **Export the whole tree, always.** The receiving side replaces what it holds, so a partial export reads as a deletion of everything left out.
> - **Never allocate an identifier blind.** The high-water marks are in the document.
>
> Your tree is the only one of the four already in the Cdsync asset shape — 16 assets, all with specs, and a manifest. The document says so and describes that shape rather than asking you to adopt one.
>
> When you have read it, **export the whole tree as one archive** so we can confirm the loop end to end.

---

## 3. snorkeltoast — adopt the document, then export

> Attached is `BOOTSTRAP-CD.md`, generated from the design system as it actually stands in the repository. **It is new — please read it before doing anything else.** It replaces every instruction carried by hand before now.
>
> No round is being ordered. The point is to get us both onto the same protocol before the next one; the last export was 30 July.
>
> Three things worth knowing before you read:
>
> - **The repository is the source of truth for the design system, and you are a tool that works on it.** Corrections land in the material you export, never only in a delivery note.
> - **Export the whole tree, always.** A partial export reads as a deletion of everything left out.
> - **Never allocate an identifier blind.** The high-water marks are in the document.
>
> One specific thing to action. Your tree carries a `cdsync/` directory — `RETIRED.md`, `OUTBOX.md` and a whiteboard skeleton with `cc` and `cd` nodes in it. **Please delete all of it and say so in `RETURN.md`.** It is a retired plan for a protocol that was then built differently, it is not design material, and anything globbing for `intent/whiteboard` or reading `OUTBOX.md` must never reach it. The document states the general rule: **Cdsync's own protocol material never belongs in a project's design system.** A project using Cdsync has exactly one concern, its own `design/system/` tree.
>
> Your tree is organised by medium rather than by asset. **That is fine and this is not asking you to reorganise it** — the document says to export the shape you already have. Restructuring would break every relative pointer, and if a conversion is ever wanted it will arrive as a brief that says so and nothing else.
>
> When you have read it, **export the whole tree as one archive.**

---

## After each one comes back

Same for all three: drop the archive into that project's `design/system/_inbox/`, then

```
cdsync install --dry-run     # the removal list is the gate — read it
cdsync install
```

**Two things to check on the result**, and both are the point of this round:

1. `design/system/handoff/intent/` did **not** come back (Baize).
2. `design/system/cdsync/` did **not** come back (snorkeltoast).

If either did, the instruction did not land and needs saying directly rather than through the document.
