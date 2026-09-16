# cdtempl new

Scaffold a venture.

```
cdtempl new <name> [--target PATH]
```

Creates `./<name>/` as its own git repository, with the venture's facts in
`design/cdtempl.json` at the tree root, an agent contract in `AGENTS.md` and
`CLAUDE.md`, and the target skeleton underneath `design/`.

A venture gets its own repository rather than living under Cdtempl. The rejected
alternative — `drops/<name>/` inside Cdtempl — would couple every venture's
confidential tree to one repository and make per-venture access impossible.

## Options

| Option | Effect |
|---|---|
| `--target PATH` | Put the target skeleton here instead of `design/` |

## What it creates

| Path | What it is |
|---|---|
| `design/cdtempl.json` | The venture's facts, at the tree root. `brief` is generated from it, and its location is what the target resolves from |
| `AGENTS.md` | The tool-agnostic agent contract |
| `CLAUDE.md` | The Claude Code overlay |
| `README.md` | The loop, written down |
| `design/{assets,kit,notes}/` | The target skeleton |
| `.gitignore` | Ignores the generated `design/site/` |

## What it deliberately does not do

**It does not run `mix phx.new`, install Ash, or write a Laksa site config.**

Standing up an Elixir application is that toolchain's job and it does it better. A
venture's stack is a fact this command records so the agent contract can state it —
not scaffolding Cdtempl would then have to keep current with somebody else's
generator.

**A generated venture is not an Intent project in the full sense.** It borrows
`CLAUDE.md` and `AGENTS.md` as the agent contract but does not inherit `intent/st/`.
A design drop has documents, not steel threads.

## Where application knowledge lives

**All of it is in this command.** `brief`, `import`, `check` and `site` know
nothing about Phoenix, Ash or Laksa.

That confinement is what lets the target stay self-contained and the microsite stay
independent of the application it describes. It is also what keeps `import` dumb,
which is what keeps it safe.

## Refusing a non-empty directory

Scaffolding over existing work is the same class of failure as a drop deleting a
file it did not know about, and it is just as hard to notice. So a non-empty
directory is a refusal, not a merge.
