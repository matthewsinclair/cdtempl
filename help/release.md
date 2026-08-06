# cdsync release

Read the version, move it, cut a release.

```
cdsync release show
cdsync release bump <major|minor|patch|X.Y.Z>
cdsync release cut  <major|minor|patch|X.Y.Z> [--push] [--dry-run]
```

`VERSION` at the repository root is the single source of truth, bare semver and
nothing else. It is the **only** place the version appears -- no module, help
page or manifest restates it -- so moving it is a one-file edit with nothing to
keep in step.

## Options

| Option | Effect |
|---|---|
| `--dry-run` | Run the gates, print the plan, write nothing |
| `--push` | Also push the commit and the tag. Off by default |

## The three verbs

| Verb | Does |
|---|---|
| `show` | Prints the bare version, for scripting |
| `bump` | Moves `VERSION` and stops. No commit, no tag |
| `cut` | The ceremony: gates, bump, commit, tag, package |

`bump` exists separately because moving the version is sometimes part of a
change rather than the whole of it, and a verb that also commits cannot be
composed with one.

## Bump part, or an explicit version

Both verbs take either one of the three bump parts or a bare semver to land on
directly.

| Given | From `0.1.0` | Means |
|---|---|---|
| `major` | `1.0.0` | Bump the part |
| `minor` | `0.2.0` | Bump the part |
| `patch` | `0.1.1` | Bump the part |
| `0.1.0` | `0.1.0` | Land on it exactly -- **including the version already in `VERSION`** |
| `0.4.0` | `0.4.0` | Land on it exactly, skipping intervening versions |

**The explicit form exists because the first release was otherwise
unreachable.** All three bump parts move forward, so the version a project is
*on* could never be tagged -- and that is precisely the version a first release
needs. This repository sat at `0.1.0` with no tags and no way to cut `0.1.0`:
`cut minor` would have produced `0.2.0` and skipped the release the repository
already announced. The verbs presumed a previous release existed, and nothing
said so.

**An explicit target may equal the current version, and that is the point.**
Whether a version has already been *released* is a question about tags, not
about `VERSION`, so it is answered by the gate that finds the tag already
exists rather than here.

**It may not go backwards.** A tag naming a version older than `VERSION` would
make the two disagree about what is current. Components compare as numbers, so
`0.10.0` is correctly newer than `0.9.0`.

An explicit target is held to the same shape as `VERSION` itself: bare semver,
no `v`, no suffix.

## `cut`, in order

1. **Gates.** All of them run and all of them report, so a refusal says which
   check refused rather than making you rerun blind.
2. **Write** `VERSION`.
3. **Commit** `release: vX.Y.Z`.
4. **Tag** `vX.Y.Z`, annotated.
5. **Package** `dist/cdsync-X.Y.Z.tar.gz`, built by `git archive` **from the
   tag**.
6. **Push** -- only with `--push`.

Every step is safe to rerun after the one following it failed. That is the
ordering principle `bin/lamplight_version` states as "derived files first,
`VERSION` last, so a rerun cannot double-bump"; here there are no derived files,
so the same idea lands on the ceremony instead.

## The gates

| Gate | Why |
|---|---|
| Working tree clean | A release must be reproducible from the tag |
| On `main` | A tag cut from a branch is a tag nobody can find |
| Not behind upstream | Otherwise the tag names a commit the remote does not have |
| `cdsync doctor` | The tool's own statement of what it needs |
| `shellcheck` | Run bare |
| `bats` | The suite is the contract |

**A gate that cannot run is not a pass.** If `shellcheck` or `bats` is missing,
that is a failure and not a skip -- the alternative is a release that reports
green because nothing checked it.

Being **ahead** of upstream is fine and is the normal case; the release commit
is about to make it one further ahead. Being **behind** is not.

An absent `LICENSE` warns rather than blocks. It matters for a public
repository and not at all for a private one, and this command cannot tell which
it is looking at.

## The tarball

Built by `git archive` from the tag, never from the working tree -- a tarball
built from disk can carry a file the tag does not, and that difference is
invisible once it is an artefact.

What it may **not** carry is declared in `.gitattributes` with `export-ignore`,
which is what `git archive` reads. So the exclusion list is data read by the
tool that does the work, rather than a second list this page would have to keep
in step with the first. Today that is `intent/`, `test/`, `.github/`,
`.claude/`, and the two dotfiles themselves.

The rule behind it: **a release carries the tool, and nothing about how the
tool is made.**

`dist/` is gitignored. It is a build output, and git already holds every tagged
state it is built from.

## Pushing is opt-in

`cut` stops after tagging unless you pass `--push`. It is the one step that
leaves this machine, and the one that cannot be quietly undone -- a tag that
has been fetched by someone else is not yours to move.

Without `--push` the commit and tag are local, so you can read both before
publishing them.
