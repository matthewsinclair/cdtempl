# cdtempl site

Stand up the microsite over the target.

```
cdtempl site [--target PATH] [--port N] [--build]
```

Generates `$CDTEMPL_TARGET/site/index.html` from `index.md` and each asset's
`spec.md`, then serves it. One page: the documents, every asset with its status and
blank count, links to each artefact, and the notes.

## Options

| Option | Effect |
|---|---|
| `--target PATH` | Override the target for this invocation |
| `--port N` | Port to serve on. Default 8080 |
| `--build` | Generate the page and exit without serving |

## It knows nothing about the application

Independent of whatever the designs relate to — no Phoenix, no Ash, no Laksa. It
serves what is in the target and no more.

That confinement is what lets the microsite stay independent of the application it
describes. The target is the as-designed record; this is a window onto it, not onto
the build.

## site/ is not a path a drop owns

`cdtempl site` generates into the target, and `cdtempl import` writes only `assets/`,
`kit/`, `notes/`, `index.md` and `RETURN.md`.

That is the owned-path list earning its keep: a generated site sitting in the target
survives the next drop instead of being deleted by it.

The generated page declares itself generated in a comment on line one, so it is
exempt from the colour check by the same declaration rule every vendored runtime
uses. Nothing about it is a special case.

## Why the server is rooted at the target

Not at `site/`. The page links out to `../assets/<slug>/…`, so a server rooted at
`site/` would render the index and then 404 every artefact on it.

The page lands at `http://localhost:8080/site/`.

## Styling

Greyscale only, and every value is a step on the kit's ramp. The site describes a
deliberately neutral kit, so a site with a brand colour in it would be arguing
against its own content.
