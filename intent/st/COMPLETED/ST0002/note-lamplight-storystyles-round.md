---
verblock: "31 Jul 2026:v0.1: Matthew Sinclair - The note handed to Lamplight's Claude Design session for the storystyles round"
---

# Note for Claude Design -- Lamplight, storystyles round

**Transport is hv.** Paste the block below into the Lamplight Claude Design session.

This is a **hand-written transition note**, and deliberately so: it is the first round
under the new model, and that session has never been told any of it. From the next round
on this is generated -- `cdsync bootstrap` writes the whole adoption document and
`cdsync bootstrap --delta` writes the since-your-last-export one. A hand-written note is
what we are replacing, so this file should have no successor.

The full generated document for Lamplight is 168 lines and is what to send if the session
wants the whole contract rather than the instruction. Produce it with:

```
cdsync bootstrap --target ~/Devel/prj/Lamplight/design/system --stdout
```

---

> **Export everything you hold, as one zip.**
>
> `design/system/` in the Lamplight repo is now the single source of truth for the design
> system, and Cdsync manages it in and out. I'm about to sync your latest work --
> storystyles included -- back into it.
>
> What I need is **one zip containing the entire tree you hold**: every document, every
> asset, the venture set, the microsite, the prototypes, all of it. **Not just the
> storystyles work, and not a delta.**
>
> That matters because the receiving side **replaces** what it has with what you send.
> Anything you leave out of the zip reads as a deletion.
>
> Two rules that come with this:
>
> - **Corrections land at source.** If something is wrong, fix it in the material you
>   export -- never only in a delivery note. A fix that lives only in a note is reverted by
>   your next export.
> - **Never allocate an ADR/ST/WP number blind.** If you need one and don't know the
>   project's high-water mark, ask first. Lamplight's marks as at 31 July: **ADR next free
>   `0021`**, **steel thread next free `0342`**. Work packages are numbered per steel
>   thread, so ask for the mark on the specific thread.

---

## Then, on this side

```
cd ~/Devel/prj/Lamplight
# drop the zip into design/system/_inbox/
cdsync install --target design/system --dry-run
```

**The removal list is the gate.** Lamplight has 708 tracked files under `design/system/`,
and the dry run names every path that would be removed. A short list means a whole-tree
export. **A long list means the export was partial -- stop, and ask for a full one.** Do
not proceed and do not `--force`.

If it reads correctly, drop `--dry-run` and type `replace` when asked.

## Two things to check before running it

- **The target must be clean or `install` refuses**, which is the whole safety net -- git
  holding every prior state is what makes a replace reversible. Lamplight had live sessions
  in it on 31 July (four whiteboard boards moved during one), so verify rather than assume:
  `git -C ~/Devel/prj/Lamplight status --porcelain -- design/system`.
- **Lamplight's four `assets/` entries are imagery directories, not Cdsync assets.** This is
  the documented trap that `assets/` is a name the drop contract owns and three of four
  projects use for something else. The generated document reports their specs as absent,
  which is the honest signal, but do not read "4 assets" as a description of that tree --
  the other 648 files sit under `design-system/`, `docs/`, `handoff/`, `prototypes/`,
  `venture/`, `lib/`, `uploads/` and `scratch/`.
