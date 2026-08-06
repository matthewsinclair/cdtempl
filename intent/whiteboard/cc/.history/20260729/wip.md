---
node: cc
name: Control Claude
role: control
session_id: 522b7752-3539-44be-9420-78bb12a4bdec
heartbeat_at: 2026-07-29T14:15Z
status: active
focus: "ST0001 WIP: bin/cdsync skeleton landed, brief written; waiting on cd's template suite in templates/claude_design/templprj"
claims: [ST0001]
---

# Control Claude (cc)

## DOING

- **ST0001** (claimed, WIP). Model settled and written to `intent/st/ST0001/design.md`, which is the single source for it -- do not restate it here.
- Brief to Claude Design written at `intent/st/ST0001/cd-brief.md`. It works from a **fresh** project rather than an existing venture, building generically into `templates/claude_design/templprj/`. hv is getting `cd` going against it.
- `bin/cdsync` skeleton landed: dispatcher plus `lib/` modules, real target resolution, real `doctor`, `atomic_write`. Four commands stubbed, each exiting 2 with a pointer to ST0001. 28 bats tests, clean under bash 3.2.57 and `critic-shell`.

## TODO

- **Waiting on `cd`**: the taxonomy, the per-asset specs, and the built template suite. Text answers come back by hv pasting; templates come back as a zip. Nothing to poll -- `cd` cannot write here.
- Then implement the four commands against whatever the specs say. `new` is where all the Elixir / Phoenix / Ash / Laksa knowledge goes; `import` and `site` stay dumb.
- Five questions parked in `intent/st/ST0001/info.md`, all for `cd` to settle: what "template form" means per asset type; whether the types cluster into orderable bundles; where "working on X changed my view of Y" belongs in the return contract; whether `site/` ships built or gets built from markdown; whether the target versions in place or accumulates.
- Still deferred, still not earning their keep: `hv` node, whiteboard `README.md` roster, `.gitignore`, `intent/wip.md`, `intent/llm/ARCHITECTURE.md` (still the verbatim default).

## Watch-outs

- **`cd` cannot read this repository. At all.** Not by git, not by mount. Every input it receives is uploaded by hv, and everything it produces comes back by paste or zip. **Briefs must therefore be self-contained** -- a reference to a path in this repo is a hole in the brief, not a pointer.
- **I got this channel wrong three times in one afternoon**, each time by inferring its shape from this side instead of asking: first that `cd` was a peer that could commit, then that it read the git remote, then that it had a live local mount. `cd` corrected the third one itself. **Treat any claim about this channel as provisional until `cd` confirms it**, and never infer from `cd`'s silence that it has not worked -- I did that too, reading a stock board as "not started" when it had already produced its output.
- **`announce` before the first write when editing another project's tree.** I fixed three defects in `../Utilz` at hv's instruction while a live session was active there, without announcing. It blocked itself on an unexplained diff, and its baseline measurements were taken against a tree I was still writing. It re-verified and the numbers held, but that was timing, not method.
- **Two dispatcher contracts for `bin/cdsync`, inherited from Utilz ST0009.** Both fail silently. Consume a utility walker with process substitution, never a pipe -- a pipe subshells the loop body and discards accumulator arrays, so the caller reports nothing, successfully. Gate a hard dependency once before a loop, never per-iteration, never memoised across command substitution -- a memo set inside `$(...)` dies with its subshell. Reasoning: `../Utilz/intent/st/COMPLETED/ST0009/design.md`.
- **Correction on the record:** I told Utilz's `cc` that `opt/todo/todo.yaml` carrying `^2.0.0` was the fossil of a hand-fixed generator-floor bug. It checked: `todo.yaml` was born `^2.0.0` in commit `03ccded` and all 13 utilities carry it. The defect was real but purely latent. Do not carry the assumption that generated utilities there ever needed hand-fixing.
- **`templates/claude_design/_Archive/` is hv's own rolling backup of each drop.** Untracked on purpose, and hv removes the lot later. Do not commit it, do not delete it, and do not raise it again as an untracked-files finding -- it was already flagged once and answered.
- `intent claude prime --refresh` overwrites `MEMORY.md` at the Claude Code project-memory path; hand-written pointer lines there are not safe across a refresh.
- `intent st sync` writes only WIP threads into `steel_threads.md`, matching `intent st list`'s default. An empty index with a Not Started thread on disk is correct, not a fault.

## Decisions

- (2026-07-29) **Four of `cd`'s round-one proposals adopted.** (1) The mandated layout is the delivered folder, not a document describing it -- so `import` is an unzip and there is no second description to drift from. (2) The spec library lives here, version-controlled; `cd` authors the text, we commit it, because specs living only in `cd`'s output would fork the first time one was edited here and `cd` could never see it. (3) **Neutrality is a spec, not an instruction** -- one neutral kit every template imports, so "is this too charming" is a question about one file rather than a judgement across twenty. `cd`'s own point, and better than asking it to fight a tendency. (4) `RETURN.md` mandatory at the top of every drop with a required *revisions to understanding* heading, present-but-empty when there is nothing -- an optional section would be empty every time.
- (2026-07-29) **ST0001 runs in two rounds.** Round one is text only and cheap to argue with; round two builds. Splitting them because the build is expensive to redo if the specs turn out wrong. `cd`'s proposal, hv agreed.
- (2026-07-29) **The model lives in `intent/st/ST0001/design.md`.** Two asymmetric surfaces; brief out, zip back; `$CDSYNC_TARGET` is the whole output boundary and defaults to `design/`; structure underneath it is standardised, location is not; all Elixir / Phoenix / Ash / Laksa knowledge is confined to `cdsync new`. Read it there rather than reconstructing it from this board. **No project-level design doc exists by choice** -- steel threads carry the design, and as-built project docs get written at the end rather than maintained speculatively alongside the work.
- (2026-07-29) **`cd` is scoped to `templprj` deliberately, and that scoping stays.** Not a limitation to route around: it is a forcing function. If `cd` could read the repo, briefs would drift toward thin and reference-rich, which works now and breaks the day `cd` is scoped to a real venture where Cdsync's internals are genuinely invisible. The rule is "a brief carries everything its round needs", which holds whatever access happens to exist -- not "cd cannot read", which is merely a fact about today.
- (2026-07-29) **Cdsync does not write into the application.** An earlier design fanned artefacts into `assets/`, `priv/static/`, and `lib/<app>_web/components/`; rejected because it collapses as-designed into as-built, is unsafe against hand-edited components, and has no destination for a PPTX. The venture project pulls from the target on its own terms.
- (2026-07-29) **`cdsync inbox` is superseded by `cdsync import <zip>`.** It was conceived to carry whiteboard messages past `cd`'s missing push path; under the supplier model the thing that needs importing is the artefact drop, not a message.
- (2026-07-29) **Shell is the declared language.** `intent lang init shell` plus `intent claude upgrade --apply` installed the pre-commit critic gate and `.intent_critic.yml` at `severity_min=warning`. JS under a design drop stays ungated -- Intent ships no JavaScript rule pack.
