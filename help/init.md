# cdtempl init

Start a design system in a repository that already exists.

```
cdtempl init [--target PATH]
```

Creates the target skeleton -- `assets/`, `kit/`, `notes/`, each with a
`.gitkeep` -- plus the repo-owned `.gitignore` that keeps delivery archives out
of git. The tree is then cold, which is exactly what `cdtempl bootstrap` wants to
see.

## The one file written outside the target

`.gitignore`, in the target's **parent**, holding one anchored rule:

```
/system/_inbox/
```

**It has to live outside.** `install` replaces the target wholesale, so a guard
inside it would not survive the first delivery it exists to protect against.
Today's drops happen to ship a `.gitignore` saying `_inbox/`, and that agreement
is the accident rather than the design: one 2026-07-31 export shipped none at
all, and another project deleted its repo-owned guard on the reasoning that the
drop's copy made it redundant. **Tracking policy flows from the repository
outward, never from a drop inward.**

It **never truncates**. The parent may be the project root and may already hold
everything else the project ignores, so an existing `.gitignore` is appended to,
and only when the rule is genuinely absent.

## Options

| Option | Effect |
|---|---|
| `--target PATH` | Initialise this path instead of the resolved one |

## `init` or `new`

They are not variants of each other. The question is what the new thing is.

| The new thing | The command | What you get |
|---|---|---|
| A **venture** | `cdtempl new <name>` | Its own git repository, the agent contract, the skeleton underneath `design/`, and `cdtempl.json` at the tree root |
| A **design system**, in a project that already exists | `cdtempl init` | The skeleton and the `cdtempl.json` stub, in the repository you are already in |

**An existing project must not get the `new` treatment.** No agent contract and
no nested repository belong inside a project -- the canon's no-protocol-material
rule. The design tree is the one Cdtempl-owned carve-out there, and `cdtempl.json`
lives at its root -- one home for `new` ventures and `init` projects alike
(hv, 9 Aug 2026). That is what makes `brief` runnable for a project Cdtempl does
not own; scope used to be supplied by hand for exactly this case.

## Why this exists

`bootstrap` refused over a tree that did not exist and advised `cdtempl new
<name>`, which for an existing project was the wrong command -- but it was the
only advice available, because there was no right one. **A tool giving the only
advice it has, and that advice being wrong, is the tell for a missing command
rather than a missing flag.**

## It refuses over a tree that is not empty

`init` starts a design system; it does not adopt one. The refusal is not about
protecting files -- this command only ever creates directories -- it is about
what happens next. **Cold or warm is measured, never declared**, and a silent
success over a populated tree would hand `bootstrap` a warm tree it had been
told was cold.

To regenerate the document over a tree that already holds a drop, that is what
`bootstrap` does on its own:

```
cdtempl bootstrap --target <path>
```

## What comes next

```
cdtempl init --target <repo>/design/system
# fill in <repo>/design/system/cdtempl.json -- especially fixed, open and order
cdtempl bootstrap --target <repo>/design/system
```

Then commit the tree in the project's own repository. It versions with that
project, not with Cdtempl -- the tree is the project's single source of truth for
its design system, and Claude Design is a clamp-on tool used to work on it.
