#!/usr/bin/env bats
# cdsync.bats - dispatcher, target resolution, primitives, and the five commands

setup() {
  CDSYNC_HOME="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  export CDSYNC_HOME
  export CDSYNC_BIN="$CDSYNC_HOME/bin/cdsync"

  # Every test runs somewhere disposable so a stray write cannot touch the
  # working tree, and so target resolution has a predictable base.
  TESTDIR="$(mktemp -d "${BATS_TMPDIR:-/tmp}/cdsync-test.XXXXXX")"
  cd "$TESTDIR"

  # The default tree root, present so a fixture can drop cdsync.json straight
  # into it -- the file lives at the tree root since hv's 9 Aug 2026 ruling.
  # Empty, so tests of the no-config and cold paths are unaffected.
  mkdir -p "$TESTDIR/design"

  # Inherited state would silently change what resolve_target returns.
  unset CDSYNC_TARGET

  # `new` makes an initial commit, which needs an identity. Supplying one here
  # rather than relying on the machine's global config keeps the suite the same
  # on a bare CI box as on a developer's laptop -- and stops a real name being
  # written into throwaway commits.
  export GIT_AUTHOR_NAME="cdsync test"
  export GIT_AUTHOR_EMAIL="test@example.invalid"
  export GIT_COMMITTER_NAME="cdsync test"
  export GIT_COMMITTER_EMAIL="test@example.invalid"
}

teardown() {
  cd /
  [[ -n "${TESTDIR:-}" && -d "$TESTDIR" ]] && rm -rf "$TESTDIR"
  return 0
}

# Run an expression against the sourced libraries, in the same order bin/cdsync
# sources them.
#
# The sourced path is in DOUBLE quotes on purpose. Single quotes here stop the
# inner shell expanding $l, so every source becomes a literal `$l.sh`, every
# library silently fails to load, and fifty-four tests fail with empty output
# and no error -- which reads exactly like fifty-four broken functions.
run_lib() {
  bash -c "set -euo pipefail
    export CDSYNC_HOME='$CDSYNC_HOME'
    for l in common config target frontmatter drop archive specs scan; do
      source \"$CDSYNC_HOME/lib/\$l.sh\"
    done
    $*"
}

assert_contains() {
  if [[ "$output" != *"$1"* ]]; then
    echo "expected output to contain: $1" >&2
    echo "actual:" >&2
    echo "$output" >&2
    return 1
  fi
}

refute_contains() {
  if [[ "$output" == *"$1"* ]]; then
    echo "expected output NOT to contain: $1" >&2
    echo "actual:" >&2
    echo "$output" >&2
    return 1
  fi
}

# A minimal but valid drop. Hand-rolled rather than copied from templprj, so
# these tests do not fail when the templates legitimately change.
make_drop() {
  local root="${1:-$TESTDIR/drop}"

  mkdir -p "$root/assets/investor-update" "$root/kit" "$root/notes"

  cat >"$root/RETURN.md" <<'EOF'
# Return -- fixture, round 1

## Revisions to understanding

Nothing this round.
EOF

  cat >"$root/index.md" <<'EOF'
---
venture: fixture
round: 1
---
# Manifest
EOF

  cat >"$root/kit/tokens.json" <<'EOF'
{ "grey": { "0": "#ffffff", "900": "#1a1a1a" } }
EOF

  cat >"$root/kit/kit.md" <<'EOF'
---
kit_version: 1
---
# The neutral kit
EOF

  cat >"$root/assets/investor-update/spec.md" <<'EOF'
---
asset: investor-update
name: Investor update
spec_version: 1
form: A
tier: 1
audience: [investor]
status: spec-only
inputs_missing:
  - "the period this covers"
depends_on:
  hard_facts: [period-metrics]
  hard_assets: []
  reciprocal: [roadmap]
bundles: [operating-set]
---
# Investor update -- specification
EOF

  cat >"$root/assets/investor-update/investor-update.md" <<'EOF'
---
verblock: "1 Jan 2026:v1: someone - [not a blank, verblock]"
---
# Update for [period]

Headline: [one sentence]. Runway: [months remaining].
EOF

  echo "# a note" >"$root/notes/thinking.md"
  echo "$root"
}

# ============================================================================
# DISPATCHER
# ============================================================================

@test "version reports the VERSION file" {
  run "$CDSYNC_BIN" version
  [ "$status" -eq 0 ]
  assert_contains "cdsync $(cat "$CDSYNC_HOME/VERSION")"
}

@test "no arguments shows usage" {
  run "$CDSYNC_BIN"
  [ "$status" -eq 0 ]
  assert_contains "Usage: cdsync"
}

@test "unknown command fails rather than falling through" {
  run "$CDSYNC_BIN" definitely-not-a-command
  [ "$status" -eq 1 ]
  assert_contains "unknown command"
}

@test "help renders a per-command topic" {
  run "$CDSYNC_BIN" help import
  [ "$status" -eq 0 ]
  assert_contains "cdsync import"
}

@test "help for an unknown topic fails" {
  run "$CDSYNC_BIN" help nonexistent-topic
  [ "$status" -ne 0 ]
  assert_contains "no help for"
}

@test "every command has a help file" {
  local c
  for c in cdsync new brief import check site; do
    [ -f "$CDSYNC_HOME/help/$c.md" ] || {
      echo "missing help/$c.md" >&2
      return 1
    }
  done
}

@test "usage advertises the settled layout, not the provisional one" {
  run "$CDSYNC_BIN"
  assert_contains "assets/<slug>/"
  assert_contains "kit/"
  # `venture/` and MANIFEST.md were the earlier layout, replaced when the
  # taxonomy settled. Neither should be advertised anywhere.
  refute_contains "venture/"
  refute_contains "MANIFEST.md"
}

# ============================================================================
# TARGET RESOLUTION
# ============================================================================

@test "target defaults to design/ under the base" {
  run run_lib "resolve_target '' '$TESTDIR'"
  [ "$status" -eq 0 ]
  [ "$output" = "$TESTDIR/design" ]
}

@test "CDSYNC_TARGET overrides the default" {
  run bash -c "set -euo pipefail
    export CDSYNC_HOME='$CDSYNC_HOME' CDSYNC_TARGET=/somewhere/else
    for l in common config target; do source \"$CDSYNC_HOME/lib/\$l.sh\"; done
    resolve_target '' '$TESTDIR'"
  [ "$status" -eq 0 ]
  [ "$output" = "/somewhere/else" ]
}

@test "cdsync.json's own directory supplies the target when no flag or env is set" {
  # The file lives at the tree root (hv, 9 Aug 2026), so finding it IS finding
  # the target -- there is no `.target` field to read any more.
  mkdir -p "$TESTDIR/design"
  echo '{"venture": "probe"}' > "$TESTDIR/design/cdsync.json"
  run run_lib "resolve_target '' '$TESTDIR'"
  [ "$status" -eq 0 ]
  [ "$output" = "$TESTDIR/design" ]
}

@test "design/system/ wins the probe over design/ when both hold a cdsync.json" {
  mkdir -p "$TESTDIR/design/system"
  echo '{"venture": "outer"}' > "$TESTDIR/design/cdsync.json"
  echo '{"venture": "inner"}' > "$TESTDIR/design/system/cdsync.json"
  run run_lib "resolve_target '' '$TESTDIR'"
  [ "$status" -eq 0 ]
  assert_contains "$TESTDIR/design/system"
}

@test "a retired .target field is ignored, and said out loud" {
  # A file inside the tree cannot also be the pointer to the tree. Silent
  # ignoring would leave a stale field that reads as if it steers.
  mkdir -p "$TESTDIR/design"
  echo '{"venture": "probe", "target": "artwork"}' > "$TESTDIR/design/cdsync.json"
  run run_lib "resolve_target '' '$TESTDIR'"
  [ "$status" -eq 0 ]
  assert_contains "$TESTDIR/design"
  assert_contains "retired .target field"
  refute_contains "$TESTDIR/artwork"
}

@test "the flag beats the environment, which beats cdsync.json" {
  mkdir -p "$TESTDIR/design"
  echo '{"venture": "probe"}' > "$TESTDIR/design/cdsync.json"

  run bash -c "set -euo pipefail
    export CDSYNC_HOME='$CDSYNC_HOME' CDSYNC_TARGET=/from-env
    for l in common config target; do source \"$CDSYNC_HOME/lib/\$l.sh\"; done
    resolve_target '/from-flag' '$TESTDIR'"
  [ "$output" = "/from-flag" ]

  run bash -c "set -euo pipefail
    export CDSYNC_HOME='$CDSYNC_HOME' CDSYNC_TARGET=/from-env
    for l in common config target; do source \"$CDSYNC_HOME/lib/\$l.sh\"; done
    resolve_target '' '$TESTDIR'"
  [ "$output" = "/from-env" ]

  run run_lib "resolve_target '' '$TESTDIR'"
  [ "$output" = "$TESTDIR/design" ]
}

@test "a relative target resolves against the base, not the working directory" {
  mkdir -p "$TESTDIR/subdir"
  cd "$TESTDIR/subdir"
  run run_lib "resolve_target 'design' '$TESTDIR'"
  [ "$output" = "$TESTDIR/design" ]
}

# ============================================================================
# PATH NORMALISATION
# ============================================================================
#
# Regression tests for a defect that actually occurred: `--target
# ../outside-repo` produced a string still prefixed by the repo root, so it was
# reported as versioning with the project when it does not.

@test "normalise_path collapses a .. segment" {
  run run_lib "normalise_path '/a/b/c/../d'"
  [ "$output" = "/a/b/d" ]
}

@test "normalise_path collapses . segments and doubled slashes" {
  run run_lib "normalise_path '/a/./b//c'"
  [ "$output" = "/a/b/c" ]
}

@test "normalise_path handles walking out and back in" {
  run run_lib "normalise_path '/a/b/../b/c'"
  [ "$output" = "/a/b/c" ]
}

@test "a target that walks out of the repo is reported as outside it" {
  run run_lib "target_is_in_repo '$CDSYNC_HOME/../elsewhere' '$CDSYNC_HOME'"
  [ "$status" -ne 0 ]
}

@test "a target inside the repo is reported as inside it" {
  run run_lib "target_is_in_repo '$CDSYNC_HOME/design' '$CDSYNC_HOME'"
  [ "$status" -eq 0 ]
}

@test "a target that walks out and back in is reported as inside" {
  run run_lib "target_is_in_repo '$CDSYNC_HOME/../$(basename "$CDSYNC_HOME")/design' '$CDSYNC_HOME'"
  [ "$status" -eq 0 ]
}

# Three states, not two. Collapsing the last two announced "it does not version
# with the project" about Lamplight's drop, which has 708 files tracked in it --
# a verdict about something the check never looked at. It matters more than
# ordinary noise because the canon rests on the drop BEING tracked, so telling
# someone theirs is unversioned contradicts the one thing they must believe.
@test "a target in a different repository is not called unversioned" {
  mkdir -p "$TESTDIR/other/design/system" "$TESTDIR/here"
  git -C "$TESTDIR/other" init -q .
  git -C "$TESTDIR/here" init -q .

  run run_lib "describe_target '$TESTDIR/other/design/system' 'test' '$TESTDIR/here'"
  [ "$status" -eq 0 ]
  assert_contains "DIFFERENT repository"
  assert_contains "versions with that project"
  refute_contains "does not version with anything"
}

@test "a target in no repository at all is called unversioned" {
  mkdir -p "$TESTDIR/here"
  git -C "$TESTDIR/here" init -q .
  mkdir -p "$TESTDIR/loose-target"

  run run_lib "describe_target '$TESTDIR/loose-target' 'test' '$TESTDIR/here'"
  [ "$status" -eq 0 ]
  assert_contains "OUTSIDE any repository"
  refute_contains "DIFFERENT repository"
}

@test "import announces the target scope before doing anything" {
  make_drop >/dev/null
  run bash -c "set -euo pipefail
    export CDSYNC_TARGET='$TESTDIR/outside'
    cd '$TESTDIR' && '$CDSYNC_BIN' import '$TESTDIR/drop'"
  # TESTDIR is a bare mktemp directory, so the target is in no repository at
  # all -- the one case that genuinely does not version with anything.
  assert_contains "OUTSIDE any repository"
}

# ============================================================================
# ATOMIC WRITE
# ============================================================================
#
# The original reason given for this was that Claude Design reads the working
# tree live. That was wrong and is withdrawn. These pin the behaviour anyway:
# handing a human a half-written brief to upload is its own failure, and it
# would be a silent one.

@test "atomic_write writes the content" {
  run run_lib "echo 'hello there' | atomic_write '$TESTDIR/out.md'"
  [ "$status" -eq 0 ]
  [ "$(cat "$TESTDIR/out.md")" = "hello there" ]
}

@test "atomic_write leaves no temporary file behind" {
  run_lib "echo body | atomic_write '$TESTDIR/out.md'"
  run bash -c "ls -a '$TESTDIR' | grep -c '^\.cdsync\.' || true"
  [ "$output" = "0" ]
}

@test "atomic_write fails when the destination directory is missing" {
  run run_lib "echo body | atomic_write '$TESTDIR/nope/out.md'"
  [ "$status" -ne 0 ]
  assert_contains "does not exist"
}

@test "atomic_write replaces existing content rather than appending" {
  echo "old" > "$TESTDIR/out.md"
  run_lib "echo new | atomic_write '$TESTDIR/out.md'"
  [ "$(cat "$TESTDIR/out.md")" = "new" ]
}

# ============================================================================
# FRONT MATTER
# ============================================================================

@test "fm_get reads a scalar and strips quotes" {
  make_drop >/dev/null
  run run_lib "fm_get '$TESTDIR/drop/assets/investor-update/spec.md' name"
  [ "$output" = "Investor update" ]
}

@test "fm_get returns non-zero for an absent key" {
  make_drop >/dev/null
  run run_lib "fm_get '$TESTDIR/drop/assets/investor-update/spec.md' nosuchkey"
  [ "$status" -ne 0 ]
  [ -z "$output" ]
}

@test "fm_get does not read past the front matter" {
  printf -- '---\na: 1\n---\nb: 2\n' > "$TESTDIR/f.md"
  run run_lib "fm_get '$TESTDIR/f.md' b"
  [ "$status" -ne 0 ]
}

@test "fm_get on a file with no front matter finds nothing" {
  echo "# just a heading" > "$TESTDIR/f.md"
  run run_lib "fm_get '$TESTDIR/f.md' anything"
  [ "$status" -ne 0 ]
}

@test "fm_list reads an inline list" {
  make_drop >/dev/null
  run run_lib "fm_list '$TESTDIR/drop/assets/investor-update/spec.md' audience"
  [ "$output" = "investor" ]
}

@test "fm_list reads a block list" {
  make_drop >/dev/null
  run run_lib "fm_list '$TESTDIR/drop/assets/investor-update/spec.md' inputs_missing"
  [ "$output" = "the period this covers" ]
}

@test "fm_list reads a nested list by dotted path" {
  make_drop >/dev/null
  run run_lib "fm_list '$TESTDIR/drop/assets/investor-update/spec.md' depends_on.hard_facts"
  [ "$output" = "period-metrics" ]
}

@test "fm_list emits nothing for an empty nested list" {
  make_drop >/dev/null
  run run_lib "fm_list '$TESTDIR/drop/assets/investor-update/spec.md' depends_on.hard_assets"
  [ -z "$output" ]
}

@test "fm_has distinguishes present-but-empty from absent" {
  printf -- '---\ncoverage:\n---\n' > "$TESTDIR/f.md"
  run run_lib "fm_has '$TESTDIR/f.md' coverage"
  [ "$status" -eq 0 ]
  run run_lib "fm_get '$TESTDIR/f.md' coverage"
  [ "$status" -ne 0 ]
  run run_lib "fm_has '$TESTDIR/f.md' absent"
  [ "$status" -ne 0 ]
}

@test "fm_set replaces an existing scalar in place" {
  printf -- '---\na: 1\nblanks: 9\nb: 2\n---\nbody\n' > "$TESTDIR/f.md"
  run_lib "fm_set '$TESTDIR/f.md' blanks 42"
  run run_lib "fm_get '$TESTDIR/f.md' blanks"
  [ "$output" = "42" ]
  # Order and neighbours preserved, body untouched.
  run bash -c "sed -n '2p;4p;6p' '$TESTDIR/f.md' | tr '\n' '/'"
  [ "$output" = "a: 1/b: 2/body/" ]
}

@test "fm_set inserts a missing scalar before the closing fence" {
  printf -- '---\na: 1\n---\nbody\n' > "$TESTDIR/f.md"
  run_lib "fm_set '$TESTDIR/f.md' blanks 7"
  run run_lib "fm_get '$TESTDIR/f.md' blanks"
  [ "$output" = "7" ]
  run bash -c "tail -1 '$TESTDIR/f.md'"
  [ "$output" = "body" ]
}

@test "fm_set refuses a file with no front matter" {
  echo "no front matter" > "$TESTDIR/f.md"
  run run_lib "fm_set '$TESTDIR/f.md' blanks 1"
  [ "$status" -ne 0 ]
  assert_contains "no front matter"
}

@test "fm_set does not confuse blanks with blanks_unique" {
  printf -- '---\nblanks: 1\nblanks_unique: 2\n---\n' > "$TESTDIR/f.md"
  run_lib "fm_set '$TESTDIR/f.md' blanks 99"
  run run_lib "fm_get '$TESTDIR/f.md' blanks_unique"
  [ "$output" = "2" ]
}

# ============================================================================
# THE SPEC LIBRARY
# ============================================================================

@test "each_spec walks the library and skips the manifest" {
  run run_lib "each_spec"
  [ "$status" -eq 0 ]
  assert_contains "investor-update"
  assert_contains "kit"

  # Whole-line, not substring: `component-library` is a real slug that contains
  # the manifest's name, so a substring check here fails against correct output.
  run run_lib "each_spec | grep -cx library || true"
  [ "$output" = "0" ]
}

@test "the library manifest exists and carries its versions" {
  run run_lib "library_get spec_library_version"
  [ "$status" -eq 0 ]
  [ -n "$output" ]
}

@test "the kit is checked for staleness like any other asset" {
  # It was not. Rule 2 needs only spec_version, but "the kit carries no status" had
  # been read as "no rules apply" -- so the one asset every artefact restates the
  # values of was the only one that could never be reported as working from a
  # superseded specification.
  make_drop >/dev/null
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop" --no-write
  assert_contains "kit"
  run bash -c "'$CDSYNC_BIN' check --target '$TESTDIR/drop' --no-write 2>&1 | grep '^  kit '"
  assert_contains "rule-2"
}

@test "a kit stamped behind the library is reported as stale" {
  make_drop >/dev/null
  # The fixture kit carries no spec_version; stamp it one behind the library.
  run run_lib "library=\$(fm_get '$CDSYNC_HOME/specs/kit.md' spec_version)
    fm_set '$TESTDIR/drop/kit/kit.md' spec_version \$((library - 1))"
  [ "$status" -eq 0 ]

  run bash -c "'$CDSYNC_BIN' check --target '$TESTDIR/drop' --no-write 2>&1 | grep '^  kit '"
  assert_contains "stale"
}

@test "fm_has_block distinguishes a file with front matter from one without" {
  printf -- '---\nkey: value\n---\n# body\n' > "$TESTDIR/with.md"
  printf -- '# body only\n' > "$TESTDIR/without.md"

  run run_lib "fm_has_block '$TESTDIR/with.md'"
  [ "$status" -eq 0 ]
  run run_lib "fm_has_block '$TESTDIR/without.md'"
  [ "$status" -ne 0 ]
  run run_lib "fm_has_block '$TESTDIR/absent.md'"
  [ "$status" -ne 0 ]
}

@test "a spec with no front matter is a blocking finding, not a fatal error" {
  # It used to be fatal. fm_set returned non-zero, the failure propagated, and the
  # run died before printing anything -- so one malformed spec cost the findings
  # about every other asset, which were already computed.
  make_drop >/dev/null
  mkdir -p "$TESTDIR/drop/assets/landing-page"
  printf -- '# Spec - Landing page\n\n| Slug | `landing-page` |\n' \
    > "$TESTDIR/drop/assets/landing-page/spec.md"

  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -ne 0 ]
  assert_contains "no front matter"

  # The report survived: the other asset is still listed and still measured.
  assert_contains "investor-update"
  assert_contains "blanks"
}

@test "a malformed spec does not stop the other assets being stamped" {
  make_drop >/dev/null
  mkdir -p "$TESTDIR/drop/assets/landing-page"
  printf -- '# Spec - Landing page\n' > "$TESTDIR/drop/assets/landing-page/spec.md"

  "$CDSYNC_BIN" check --target "$TESTDIR/drop" >/dev/null 2>&1 || true

  # investor-update comes after landing-page in the walk, so this is the assertion
  # that the run carried on rather than dying at the first bad file.
  run run_lib "fm_get '$TESTDIR/drop/assets/investor-update/spec.md' blanks_source"
  [ "$output" = "computed" ]
}

@test "a blank beginning with a currency symbol is counted" {
  # It was not, which made rule 1 passable by an asset whose ask slide still read
  # [$0.0m]. A check that cannot see a placeholder is not checking it.
  cat > "$TESTDIR/money.md" <<'EOF'
| [$0.0b] TAM | [A$00] local | [US$0.0m] intl |
| [£0.0m] gbp | [€000] eur | [¥000] jpy |
EOF
  run run_lib "each_blank_in_file '$TESTDIR/money.md' | grep -c ."
  [ "$output" = "6" ]
}

@test "the currency symbol is kept in the reported blank" {
  # $0.0m is the string a person has to replace, so it is what gets reported.
  printf '| [$0.0m] the ask |\n' > "$TESTDIR/money.md"
  run run_lib "each_blank_in_file '$TESTDIR/money.md'"
  [ "$output" = '$0.0m' ]
}

@test "a currency symbol alone is not a blank" {
  # [$] names no unknown, exactly as [] does not.
  printf '| [$] price | [] nothing |\n' > "$TESTDIR/money.md"
  run run_lib "each_blank_in_file '$TESTDIR/money.md'"
  [ -z "$output" ]
}

@test "a blank with the currency outside the bracket still counts once" {
  # Claude Design's preferred form: the bracket holds the unknown and nothing
  # else. It must keep working, since it is the shape being recommended.
  printf '| A$[0.0m] the ask |\n' > "$TESTDIR/money.md"
  run run_lib "each_blank_in_file '$TESTDIR/money.md'"
  [ "$output" = "0.0m" ]
}

@test "each_bundle lists the seven bundles" {
  run run_lib "each_bundle | grep -c ."
  [ "$output" = "7" ]
}

@test "a bundle expands to slugs" {
  run run_lib "each_bundle_member seed-set"
  assert_contains "pitch-deck"
  assert_contains "product-one-pager"
}

@test "an unknown bundle does not exist" {
  run run_lib "bundle_exists nonesuch"
  [ "$status" -ne 0 ]
}

@test "expand_order expands bundles and deduplicates" {
  # product-one-pager is in both seed-set and launch-set; a bundle is a view,
  # not a partition, so it must appear once.
  run run_lib "expand_order seed-set launch-set | cut -f1 | sort | uniq -d"
  [ -z "$output" ]
}

@test "expand_order passes through a bare slug" {
  run run_lib "expand_order landing-page | cut -f1"
  [ "$output" = "landing-page" ]
}

@test "expand_order preserves the order given" {
  run run_lib "expand_order landing-page pitch-deck | cut -f1 | tr '\n' ' '"
  [ "$output" = "landing-page pitch-deck " ]
}

@test "expand_order attributes a bare slug to no bundle" {
  run run_lib "expand_order landing-page"
  [ "$output" = "$(printf 'landing-page\t-')" ]
}

@test "expand_order attributes a bundle member to its bundle" {
  run run_lib "expand_order operating-set | grep '^investor-update'"
  [ "$output" = "$(printf 'investor-update\toperating-set')" ]
}

@test "expand_order attributes a named slug to itself even inside a bundle" {
  # The attribution decides whether brief refuses or trims, so first-reached is
  # not good enough: bundles expand before bare assets, so a slug the venture
  # asked for by name would be credited to the bundle and quietly dropped.
  run run_lib "expand_order operating-set investor-update"
  assert_contains "$(printf 'investor-update\t-')"
  refute_contains "$(printf 'investor-update\toperating-set')"
}

@test "the taxonomy is wider than the library" {
  # A slug can be legitimately named as a dependency long before it is
  # specified. pattern-library is real, declared by component-library, and
  # unwritten -- most of the taxonomy is in that state, and `cdsync doctor` is
  # what says how much of it. No figure here: this comment carried "32 of the
  # 50" while the table said otherwise, which is the drift the guard below
  # exists to stop.
  #
  # grid-and-layout held this role until it was specified on 30 Jul, which is
  # why the exemplar moved. The invariant is the point, not the example: pick a
  # replacement that some existing spec actually depends on, or the test stops
  # pinning the thing it is named for.
  run run_lib "taxonomy_has pattern-library"
  [ "$status" -eq 0 ]
  run run_lib "spec_exists pattern-library"
  [ "$status" -ne 0 ]
}

@test "a slug outside the taxonomy is rejected" {
  run run_lib "taxonomy_has not-a-real-asset"
  [ "$status" -ne 0 ]
}

# ============================================================================
# BLANK COUNTING
# ============================================================================
#
# Every case below is written down in the drop's own kit/kit.md. These pin the
# implementation to that spec.

@test "a lower-case bracketed blank counts" {
  printf 'x [venture name] y\n' > "$TESTDIR/a.md"
  run run_lib "each_blank_in_file '$TESTDIR/a.md'"
  [ "$output" = "venture name" ]
}

@test "a digit-initial blank counts" {
  printf 'x [00%% of target] y\n' > "$TESTDIR/a.md"
  run run_lib "each_blank_in_file '$TESTDIR/a.md'"
  [ "$output" = "00% of target" ]
}

@test "a capitalised bracket is prose, not a blank" {
  printf 'See [Appendix] for detail.\n' > "$TESTDIR/a.md"
  run run_lib "each_blank_in_file '$TESTDIR/a.md'"
  [ -z "$output" ]
}

@test "a markdown link is not a blank" {
  printf 'see [the docs](https://example.com) please\n' > "$TESTDIR/a.md"
  run run_lib "each_blank_in_file '$TESTDIR/a.md'"
  [ -z "$output" ]
}

@test "a blank inside a code span does not count" {
  printf 'the marker looks like `[bracketed]` in use\n' > "$TESTDIR/a.md"
  run run_lib "each_blank_in_file '$TESTDIR/a.md'"
  [ -z "$output" ]
}

@test "a blank inside a fenced block does not count" {
  printf '```\n[inside a fence]\n```\n[outside it]\n' > "$TESTDIR/a.md"
  run run_lib "each_blank_in_file '$TESTDIR/a.md'"
  [ "$output" = "outside it" ]
}

@test "a blank inside an html code tag does not count" {
  printf '<code>[in a code tag]</code>\n' > "$TESTDIR/a.md"
  run run_lib "each_blank_in_file '$TESTDIR/a.md'"
  [ -z "$output" ]
}

@test "the verblock line does not count" {
  printf -- 'verblock: "1 Jan 2026:v1: x - [description]"\n' > "$TESTDIR/a.md"
  run run_lib "each_blank_in_file '$TESTDIR/a.md'"
  [ -z "$output" ]
}

@test "a front-matter value other than the verblock does count" {
  printf -- '---\nventure: "[venture name]"\n---\n' > "$TESTDIR/a.md"
  run run_lib "each_blank_in_file '$TESTDIR/a.md'"
  [ "$output" = "venture name" ]
}

@test "a bracket longer than eighty characters is not a blank" {
  printf 'x [%s] y\n' "$(printf 'a%.0s' $(seq 81))" > "$TESTDIR/a.md"
  run run_lib "each_blank_in_file '$TESTDIR/a.md'"
  [ -z "$output" ]
}

@test "interior whitespace is collapsed so duplicates match" {
  printf '[one   liner] and [one liner]\n' > "$TESTDIR/a.md"
  run run_lib "each_blank_in_file '$TESTDIR/a.md' | sort -u | grep -c ."
  [ "$output" = "1" ]
}

@test "spec.md is out of scope for the blank count" {
  # A spec describes the work; it is not the work. Counting its placeholders
  # would make every asset permanently unfinishable.
  make_drop >/dev/null
  printf '\n[a blank in a spec]\n' >> "$TESTDIR/drop/assets/investor-update/spec.md"
  run run_lib "each_blank_in_asset '$TESTDIR/drop/assets/investor-update'"
  refute_contains "a blank in a spec"
}

@test "vendor and exports are out of scope for the blank count" {
  make_drop >/dev/null
  mkdir -p "$TESTDIR/drop/assets/investor-update/vendor" \
           "$TESTDIR/drop/assets/investor-update/exports"
  echo '[a vendored blank]' > "$TESTDIR/drop/assets/investor-update/vendor/r.md"
  echo '[an exported blank]' > "$TESTDIR/drop/assets/investor-update/exports/e.md"
  run run_lib "each_blank_in_asset '$TESTDIR/drop/assets/investor-update'"
  refute_contains "vendored"
  refute_contains "exported"
}

# ============================================================================
# COLOUR NORMALISATION
# ============================================================================

@test "hex shorthand expands so #FFF matches #ffffff" {
  run run_lib "printf '%s\n' '#FFF' | normalise_colours"
  [ "$output" = "#ffffff" ]
}

@test "rgb collapses to hex so form does not matter" {
  run run_lib "printf '%s\n' 'rgb(26,26,26)' | normalise_colours"
  [ "$output" = "#1a1a1a" ]
}

@test "a fully transparent value is not a colour" {
  # rgba(0,0,0,0) is the `transparent` keyword spelled long-hand. It carries no
  # hue, so it has nothing to leak.
  run run_lib "printf '%s\n%s\n%s\n' 'rgba(0,0,0,0)' 'rgba(255,255,255,0)' '#00000000' | normalise_colours"
  [ -z "$output" ]
}

@test "alpha above zero is compared on hue alone" {
  run run_lib "printf '%s\n' 'rgba(217,119,87,0.5)' | normalise_colours"
  [ "$output" = "#d97757" ]
}

@test "a modern colour function is read, not skipped" {
  # matthewsinclair.com's 2026-08-02 kit is defined entirely in oklch(). The
  # scanner read #hex, rgb() and hsl() only, so every colour in that kit was
  # invisible -- and rule 4, the leak guard, silently had nothing to compare.
  #
  # Asserted through each_colour_in_file, NOT by piping into normalise_colours.
  # The gap was in the grep pattern, and normalise_colours passes an
  # unrecognised string through unchanged -- so the direct pipe produces the
  # right answer with the bug still in place. It was written that way first and
  # stayed green against the unfixed scanner.
  printf 'background: oklch(96%% 0.014 92);\n' > "$TESTDIR/kit.css"
  run run_lib "each_colour_in_file '$TESTDIR/kit.css'"
  [ "$output" = "oklch(96%0.01492)" ]
}

@test "a modern colour function compares equal however it is spaced" {
  # Compared as normalised text rather than converted to hex, so the two sides
  # of the check must agree on spacing or nothing ever matches.
  printf 'a { c: oklch(96%%  0.014   92) }\nb { c: oklch(96%% 0.014 92) }\n' > "$TESTDIR/kit.css"
  run run_lib "each_colour_in_file '$TESTDIR/kit.css' | sort -u"
  [ "$output" = "oklch(96%0.01492)" ]
}

@test "every modern colour space the scanner claims is actually read" {
  # Named one by one rather than asserted as a count, so adding a form to the
  # pattern without teaching normalise_colours to parse it shows up here.
  printf 'oklab(59%% 0.1 0.1) lch(59%% 40 30) lab(59%% 40 30) color(display-p3 0.5 0.1 0.2)\n' \
    > "$TESTDIR/kit.css"
  run run_lib "each_colour_in_file '$TESTDIR/kit.css'"
  assert_contains "oklab(59%0.10.1)"
  assert_contains "lch(59%4030)"
  assert_contains "lab(59%4030)"
  assert_contains "color(display-p30.50.10.2)"
}

@test "the kit side reads a modern colour function too" {
  # The kit and the artefact are scanned by two different functions. They were
  # two identical hand-written patterns, so a gap could be closed on one side
  # only -- and a one-sided fix is worse than no fix: every kit colour unknown
  # makes every artefact colour a leak, and the check reports it with confidence.
  printf '{ "bg": "oklch(96%% 0.014 92)" }\n' > "$TESTDIR/tokens.json"
  run run_lib "each_kit_colour '$TESTDIR/tokens.json'"
  [ "$output" = "oklch(96%0.01492)" ]
}

@test "a modern colour function at zero alpha is not a colour" {
  # The same judgement rgba() already makes, in the syntax that replaced the
  # fourth comma-separated argument.
  run run_lib "printf '%s\n%s\n%s\n' 'oklch(96% 0.014 92 / 0)' 'lab(59% 40 30 / 0.0)' 'oklch(96% 0.014 92 / 0%)' | normalise_colours"
  [ -z "$output" ]
}

@test "a modern colour function being computed is not a literal" {
  # The gg-wash.js lesson in the syntax of 2026: an argument that is an
  # identifier is a colour being calculated, not a colour being declared.
  run run_lib "printf '%s\n%s\n' 'oklch(l c h)' 'color(display-p3 r g b)' | normalise_colours"
  [ -z "$output" ]
}

@test "the colour pattern is declared once, not once per caller" {
  # It was written out twice, identical by hand rather than by construction --
  # which is how oklch() came to be missing from both and could have been fixed
  # in only one. Asserted on the SCANNERS rather than on the string `rgba?`,
  # which also appears twice inside normalise_colours as parsing and is not a
  # duplicate of anything.
  run bash -c "grep -c 'grep -oiE' '$CDSYNC_HOME/lib/scan.sh'"
  [ "$output" = "2" ]

  # Both of them go through the declaration. Counted, so the probe is known able
  # to hit -- a guard that can only report zero is not a guard.
  run bash -c "grep -c 'grep -oiE \"\$CDSYNC_COLOUR_RE\"' '$CDSYNC_HOME/lib/scan.sh'"
  [ "$output" = "2" ]
}

@test "a generated declaration must be in a comment, not in prose" {
  printf '// @generated by a tool\n#d97757\n' > "$TESTDIR/gen.js"
  printf 'This file is generated.\n#d97757\n' > "$TESTDIR/gen.md"
  run run_lib "is_generated_file '$TESTDIR/gen.js'"
  [ "$status" -eq 0 ]
  run run_lib "is_generated_file '$TESTDIR/gen.md'"
  [ "$status" -ne 0 ]
}

# ============================================================================
# CHECK
# ============================================================================

@test "check passes a clean drop and computes its blanks" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -eq 0 ]
  assert_contains "clean"
  # Three: [period], [one sentence], [months remaining]. The verblock's bracket
  # is not one, and spec.md is out of scope.
  run run_lib "fm_get '$TESTDIR/drop/assets/investor-update/spec.md' blanks"
  [ "$output" = "3" ]
  run run_lib "fm_get '$TESTDIR/drop/assets/investor-update/spec.md' blanks_source"
  [ "$output" = "computed" ]
}

# ============================================================================
# RULE 6 -- CLASSIFICATION
# ============================================================================
#
# Held back one round on purpose so it would not fire on every drop predating
# the decision. Gyre & Gymble's round-2 export is the round it waited for: the
# first drop ever to carry classification, on all sixteen assets.

@test "rule 6 says so when nothing declares where an asset may be shown" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -eq 0 ]
  assert_contains "no classification declared"
}

@test "rule 6 accepts each of the three classifications" {
  make_drop >/dev/null
  for c in public internal confidential; do
    run run_lib "fm_set '$TESTDIR/drop/assets/investor-update/spec.md' classification '$c'"
    [ "$status" -eq 0 ]
    run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
    [ "$status" -eq 0 ]
    refute_contains "unknown classification"
    refute_contains "no classification declared"
  done
}

@test "rule 6 names an unknown classification rather than passing it" {
  make_drop >/dev/null
  run run_lib "fm_set '$TESTDIR/drop/assets/investor-update/spec.md' classification 'secret'"
  [ "$status" -eq 0 ]
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -eq 0 ]
  assert_contains "unknown classification 'secret'"
}

# ADVISORY, and not as a judgement call. Classification "governs where material
# may be shown, never whether it is committed" and "is not a delivery filter and
# must not be used as one" -- so a blocking rule here would be using it as
# exactly that. The ruling that defines the field settles the severity, and
# `confidential` is the value that would tempt someone to block on it.
@test "rule 6 never blocks, because blocking would make it a delivery filter" {
  make_drop >/dev/null
  run run_lib "fm_set '$TESTDIR/drop/assets/investor-update/spec.md' classification 'confidential'"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -eq 0 ]
  refute_contains "blocking"
}

# THE CONFLATION. `internal` answers only where a thing may be shown, so it can
# only have reached the audience field by the two axes being confused. This
# project's own spec library declared it that way in its legend -- `INT
# internal` in a column headed "For" -- and twelve entries inherited it.
@test "rule 6 catches a classification sitting in the audience field" {
  make_drop >/dev/null
  run run_lib "fm_set '$TESTDIR/drop/assets/investor-update/spec.md' audience '[internal, investor]'"
  [ "$status" -eq 0 ]
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -eq 0 ]
  assert_contains "the two axes are conflated"
}

# ...but `public` IS a real audience. The general public genuinely is who a
# landing page is for, and an investor deck can be classified public while its
# audience is investors. The two are independent, so the word appearing in
# `audience` proves nothing and flagging it would be a false positive.
@test "rule 6 leaves public alone in the audience field" {
  make_drop >/dev/null
  run run_lib "fm_set '$TESTDIR/drop/assets/investor-update/spec.md' audience '[public, investor]'"
  [ "$status" -eq 0 ]
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -eq 0 ]
  refute_contains "the two axes are conflated"
}

@test "check --no-write leaves the spec alone" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop" --no-write
  [ "$status" -eq 0 ]
  run run_lib "fm_has '$TESTDIR/drop/assets/investor-update/spec.md' blanks"
  [ "$status" -ne 0 ]
}

@test "rule 1 blocks a complete status with blanks remaining" {
  make_drop >/dev/null
  sed -i.bak 's/^status: spec-only/status: complete/' \
    "$TESTDIR/drop/assets/investor-update/spec.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -eq 1 ]
  assert_contains "BLOCKING"
  assert_contains "rule-1"
  assert_contains "blanks remain"
}

@test "rule 1 advises on an unknown status value" {
  make_drop >/dev/null
  sed -i.bak 's/^status: spec-only/status: nearly/' \
    "$TESTDIR/drop/assets/investor-update/spec.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  assert_contains "unknown status"
}

@test "rule 2 advises when the drop is behind the library" {
  make_drop >/dev/null
  sed -i.bak 's/^spec_version: 1/spec_version: 0/' \
    "$TESTDIR/drop/assets/investor-update/spec.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  assert_contains "rule-2"
  assert_contains "stale"
}

@test "rule 2 advises when the drop is stamped above the library" {
  make_drop >/dev/null
  sed -i.bak 's/^spec_version: 1/spec_version: 9/' \
    "$TESTDIR/drop/assets/investor-update/spec.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  assert_contains "rule-2"
  assert_contains "not a per-drop counter"
}

# The `unassigned` lifecycle, ruled by hv on 9 Aug 2026: an asset ordered ahead
# of the library stamps the literal word, which is CORRECT while the library
# holds no entry and becomes a rebuild prompt the day it gains one.
@test "rule 2 accepts unassigned for an asset the library does not hold" {
  make_drop >/dev/null
  mv "$TESTDIR/drop/assets/investor-update" "$TESTDIR/drop/assets/portraits"
  sed -i.bak 's/^spec_version: 1/spec_version: unassigned/' \
    "$TESTDIR/drop/assets/portraits/spec.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -eq 0 ]
  # The fixture kit carries its own unrelated rule-2 advisory, so the refutes
  # pin the two findings a library-less ASSET could raise, not the rule id.
  refute_contains "no entry in the spec library"
  refute_contains "a number nobody issued"
}

@test "rule 2 names a number nobody issued on a library-less asset" {
  make_drop >/dev/null
  mv "$TESTDIR/drop/assets/investor-update" "$TESTDIR/drop/assets/portraits"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  assert_contains "rule-2"
  assert_contains "a number nobody issued"
}

@test "rule 2 sends an unassigned asset to the spec the library has since gained" {
  make_drop >/dev/null
  sed -i.bak 's/^spec_version: 1/spec_version: unassigned/' \
    "$TESTDIR/drop/assets/investor-update/spec.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  assert_contains "rule-2"
  assert_contains "the library now holds spec_version 1"
  assert_contains "rebuild against it"
}

# Bash arithmetic reads a word as zero, so an unguarded compare would report a
# confident "stale: built from spec_version banana" -- a wrong verdict worn as
# a right one. Named instead.
@test "rule 2 names an unreadable stamp rather than comparing it as zero" {
  make_drop >/dev/null
  sed -i.bak 's/^spec_version: 1/spec_version: banana/' \
    "$TESTDIR/drop/assets/investor-update/spec.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  assert_contains "unreadable spec_version 'banana'"
  refute_contains "stale"
}

# The message, not the finding. This case fired fourteen times on the one drop
# that ever hit it and prescribed the wrong fix in all fourteen: the library was
# right and the drop had invented a number. A rule that reports the correct
# disagreement and names the wrong culprit is worse than silence, because it gets
# acted on.
@test "rule 2 does not blame the library when a drop is stamped above it" {
  make_drop >/dev/null
  sed -i.bak 's/^spec_version: 1/spec_version: 9/' \
    "$TESTDIR/drop/assets/investor-update/spec.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  refute_contains "the library needs updating"
}

# The remedy, not the disagreement. Told only that its stamp is below the
# library's, the cheapest repair is to edit the number up -- which silences the
# finding, changes nothing, and re-creates the hand-driven counter the whole rule
# exists to stop. The stamp becomes correct by the asset being rebuilt.
@test "rule 2 sends a stale drop to a rebuild rather than to the number" {
  make_drop >/dev/null
  sed -i.bak 's/^spec_version: 1/spec_version: 0/' \
    "$TESTDIR/drop/assets/investor-update/spec.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  assert_contains "rebuild against the newer spec"
}

@test "rule 2 does not invite a stale drop to raise its own stamp" {
  make_drop >/dev/null
  sed -i.bak 's/^spec_version: 1/spec_version: 0/' \
    "$TESTDIR/drop/assets/investor-update/spec.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  assert_contains "do not raise the stamp on its own"
}

# HIGHLANDER, AND THE PROBE PROVES ITSELF FIRST. `check` validates the
# classification vocabulary and `bootstrap` instructs Claude Design on it, so two
# copies could name different words -- and because the document is an instruction
# the other side obeys, a drift would not merely mis-report, it would produce the
# wrong drop.
#
# The common.sh assertion is not decoration: it is what proves the grep can hit
# at all, so the cmd_check.sh miss means absence rather than a broken probe. An
# empty search result trusted without that proof is this project's most-repeated
# mistake.
# `usage()` advertises every command AND promises `cdsync help <command>`, so a
# command without a help file makes the tool's own front page lie. `doctor` did
# for as long as it existed: seven of eight worked, which is exactly the ratio
# that never gets noticed by hand.
#
# The list is read from the dispatcher rather than typed here, so a ninth command
# is covered the day it is added rather than the day someone remembers this test.
# The README carries the rule table as well, because a front page that sends you
# elsewhere to find out what the tool checks is not a front page. But when a
# repository carries two lists of the same kind of thing, that is the bug and
# not the style -- so the second one is pinned to the first rather than trusted
# to keep up. help/check.md is the source; the README copies it.
#
# Both greps must find rows before a match means anything: two empty strings
# compare equal, and that is the shape of pass this project has been fooled by
# before.
# A HOME DIRECTORY PATH IN A TRACKED FILE IS TWO BUGS AT ONCE: it publishes the
# author's local layout, and it does not work on anybody else's machine.
# `.claude/settings.json` carried three, pointing at an Intent install by
# absolute path -- baked in by Intent's own installer, so every project built
# from that template has them. For a repository that is going public, both
# halves matter.
#
# The planted probe is the positive control. A grep that has stopped matching
# reports the same clean as a repository that has none.
# `install` is the only command that prompts: it asks on a tty and refuses when
# stdin is not one. So a test invoking it without controlling stdin asserts
# whatever the ambient environment happens to be -- passing under CI and every
# agent-run shell, and HANGING the whole suite for anyone running it from a
# terminal. It did, at test 183 of 313.
#
# A suite that can block on input is worse than one that fails: it gives no
# result at all, and only for the people most likely to be running it by hand.
@test "no test can hang waiting for the install confirmation prompt" {
  local offenders
  offenders="$(grep -n '"\$CDSYNC_BIN" install' "$BATS_TEST_FILENAME" \
    | grep -v -- '--yes' | grep -v -- '--dry-run' | grep -v '</dev/null' || true)"

  if [[ -n "$offenders" ]]; then
    echo "install invocations that neither confirm, dry-run, nor redirect stdin:" >&2
    printf '%s\n' "$offenders" >&2
    return 1
  fi

  # Prove the probe can hit: the pattern must match a real invocation, or its
  # silence means nothing.
  grep -q '"\$CDSYNC_BIN" install' "$BATS_TEST_FILENAME"
}

# ST0005 AT-00.6
@test "no tracked file carries an absolute home directory path" {
  local hits
  hits="$(git -C "$CDSYNC_HOME" grep -lIE '/Users/[a-zA-Z0-9._-]+|/home/[a-zA-Z0-9._-]+' \
    2>/dev/null || true)"

  if [[ -n "$hits" ]]; then
    echo "tracked files carrying an absolute home path:" >&2
    printf '%s\n' "$hits" >&2
    return 1
  fi

  # Prove the probe can hit before trusting the miss.
  #
  # Assembled from two halves rather than written out, because this file is
  # itself tracked -- a literal one here would be found by the check above, and
  # the first version of this test failed on its own positive control.
  local head="/Us" tail="ers/someone/bin/thing"
  local planted="$TESTDIR/planted.txt"
  printf 'command: %s%s\n' "$head" "$tail" > "$planted"
  grep -qE '/Users/[a-zA-Z0-9._-]+' "$planted" || {
    echo "the probe cannot match a home path it was handed -- the pass above means nothing" >&2
    return 1
  }
}

@test "help/check.md names every colour form the scanner reads" {
  # Rule 4's reach is exactly this list, and a kit written in a space absent from
  # it makes the rule UNRUNNABLE rather than clean. That is user-visible -- it
  # prints a warning and skips -- so which forms are read has to be documented.
  # Checked against the declaration so a form added to the code without being
  # documented fails here, rather than surprising whoever's kit stops being
  # guarded.
  local form pattern
  pattern="$(run_lib 'printf "%s" "$CDSYNC_COLOUR_RE"')"

  for form in rgb hsl oklch oklab lch lab color; do
    if ! printf '%s' "$pattern" | grep -qF "$form"; then
      echo "named here but absent from CDSYNC_COLOUR_RE: $form" >&2
      return 1
    fi
    if ! grep -qF "$form()" "$CDSYNC_HOME/help/check.md"; then
      echo "read by the scanner but not documented in help/check.md: $form" >&2
      return 1
    fi
  done
}

# check_contract_citations <canon-dir> <repo-root> -- every citation a test-backed
# acceptance row carries, checked against the repository it cites into.
#
# SINCE THE INTENT V3 PORT OF 26 AUGUST 2026, A CONTRACT LIVES IN THE STORE, and
# its committed form is one `intent/.canon/st/<id>.json` per thread, open or
# closed. The port removed every `acceptance.md` the guard below used to glob,
# and the guard failed at once on its own nonzero-total assertion -- which is
# what that assertion is for, and the second time it has caught a moved frame.
#
# NOT THE REALISED VIEWS. `intent/st/<id>/acceptance.md` still exists for an OPEN
# thread (`intent/.intentfiles` declares which), so a glob over the views goes
# green again as soon as any open thread cites one real test -- checking that
# thread's contract and silently no closed one. ST0005 measured exactly that
# before this was written. The extract is the one home; a view renders it.
#
# WHERE A ROW NAMES ITS TEST. A v2 row wrote `path::"test name"`, which the port
# kept as `legacy.raw`. A v3 row cites a FILE, and `intent at lint` and the close
# gate accept it once that file carries the row's id -- so a test this project
# cites is marked by a comment directly above it, naming the thread as well as
# the id, because an id is unique only within its own thread:
#
#   # <thread> <id>
#   @test "<name>" {
#
# Lint asks whether the id is in the file. Whether it sits on a TEST is the half
# lint cannot see -- a mark left behind when a test is renamed, moved or deleted
# still passes it -- so that half is asked here: each mark for a row must be
# followed, past any further comment lines, by an `@test`.
#
# Every cited file must exist, every name in `legacy.raw` must be a test in it,
# and every mark must sit on a test. A v3 row its file does not mark cites the
# whole file -- ST0004's whole-suite row does -- and the closing line's two counts
# show how many; refusing that in an OPEN thread is the close gate's job, and it
# does. A test-backed row citing no file at all is REPORTED, not skipped, because
# a reader that drops what it cannot parse is a reader that reports clean -- and
# `intent at lint` examines none of the legacy rows and still says `ok`.
#
# Prints one line per problem and a closing `checked:` line. Returns 1 on any
# problem, and on an extract it reads no citation from at all.
check_contract_citations() {
  local canon="$1" root="$2"
  local tab thread tid id cite path name kind marked
  local threads=0 cites=0 named=0 problems=0
  tab="$(printf '\t')"

  while IFS= read -r thread; do
    tid="${thread##*/}"
    tid="${tid%.json}"
    threads=$((threads + 1))

    if ! jq -e '.' "$thread" >/dev/null 2>&1; then
      echo "$tid: not readable as JSON"
      problems=$((problems + 1))
      continue
    fi

    while IFS="$tab" read -r id cite; do
      if [[ -z "$cite" ]]; then
        echo "$tid $id: a test-backed row that cites nothing"
        problems=$((problems + 1))
        continue
      fi
      cites=$((cites + 1))

      path="$cite"
      name=""
      if [[ "$cite" == *'::"'*'"' ]]; then
        path="${cite%%::\"*}"
        name="${cite#*::\"}"
        name="${name%\"}"
      fi

      if [[ ! -f "$root/$path" ]]; then
        echo "$tid $id: cites $path, which is not in the repository"
        problems=$((problems + 1))
        continue
      fi

      if [[ -n "$name" ]]; then
        named=$((named + 1))
        if ! grep -qF "@test \"$name\"" "$root/$path"; then
          echo "$tid $id: cites \"$name\", which $path does not have"
          problems=$((problems + 1))
        fi
        continue
      fi

      # A mark is the thread and id on a comment line, not followed by a further
      # digit -- so a row's id does not match the longer id it is a prefix of.
      marked=0
      while IFS= read -r kind; do
        if [[ "$kind" == test ]]; then
          marked=1
        else
          echo "$tid $id: $path marks $tid $id on a line no test follows"
          problems=$((problems + 1))
        fi
      done < <(awk -v mark="$tid $id" '
        /^[[:space:]]*#/ {
          p = index($0, mark)
          if (p && substr($0, p + length(mark), 1) !~ /[0-9]/) pending = 1
          next
        }
        pending {
          if ($0 ~ /^@test "/) print "test"; else print "stray"
          pending = 0
        }
        END { if (pending) print "stray" }
      ' "$root/$path")
      named=$((named + marked))
    done < <(jq -r '
      .tests[]? | select(.kind == "test") | . as $t
      | [$t.file, $t.legacy.raw] | map(select(type == "string" and length > 0))
      | if length == 0 then "\($t.id)\t" else .[] | "\($t.id)\t\(.)" end
    ' "$thread")
  done < <(find "$canon" -maxdepth 1 -type f -name 'ST*.json' 2>/dev/null | LC_ALL=C sort)

  echo "checked: $cites citation(s), $named naming a test, across $threads thread(s) -- $problems problem(s)"

  if [[ "$cites" -eq 0 ]]; then
    echo "read no citation under $canon -- the extract moved, or this reader broke"
    return 1
  fi
  [[ "$problems" -eq 0 ]]
}

# A repository the contract guard can be pointed at: a suite holding one test,
# and an empty extract for each fixture to write its own threads into.
make_contract_fixture() {
  mkdir -p "$TESTDIR/repo/test" "$TESTDIR/repo/intent/.canon/st"
  printf '@test "%s" {\n  true\n}\n' "a test that exists" >"$TESTDIR/repo/test/cdsync.bats"
}

# write_contract <thread-id> <tests-json> -- one thread in the fixture's extract.
write_contract() {
  printf '{"schema": "intent/thread@3.0", "id": "%s", "tests": %s}\n' "$1" "$2" \
    >"$TESTDIR/repo/intent/.canon/st/$1.json"
}

# ST0005 AT-00.1
@test "every acceptance test named in a contract exists in this suite" {
  # Written because the first draft of ST0001's contract cited ELEVEN acceptance
  # tests and EIGHT of them did not exist -- plausible names for tests nobody had
  # written. A contract citing a missing test is worse than an empty one: the
  # close-gate counts it as covered, so the thread closes on evidence that was
  # never there.
  #
  # The gate counts AC-to-AT coverage; it has no way to know whether the AT is
  # real. This is the half it cannot check.
  #
  # Its frame has moved three times: twice in v2, when `intent st` moved a
  # thread's directory as its status changed, and the nonzero assertion caught
  # the first of those; then in the v3 port, which it caught the same way. Where
  # the contracts live now, and why the realised views are the wrong place to
  # read them, is above check_contract_citations.
  run check_contract_citations "$CDSYNC_HOME/intent/.canon/st" "$CDSYNC_HOME"
  if [ "$status" -ne 0 ]; then
    printf '%s\n' "$output" >&2
    return 1
  fi
}

# ST0005 AT-00.9
@test "the contract guard holds a v3 row to a mark that sits on a test" {
  # `intent at lint` accepts a v3 row once its file carries the row's id
  # anywhere. A mark that a renamed or deleted test left behind still passes
  # that, so the guard asks whether each mark is followed by a test.
  make_contract_fixture
  printf '\n# ST9001 AT-1\n# a further comment line is allowed\n@test "%s" {\n  true\n}\n' \
    "a marked test" >>"$TESTDIR/repo/test/cdsync.bats"
  printf '\n# ST9001 AT-2\nnot_a_test=1\n# ST9001 AT-10\n# ST9001 AT-4\n' \
    >>"$TESTDIR/repo/test/cdsync.bats"
  write_contract ST9001 '[
    {"id": "AT-1", "kind": "test", "file": "test/cdsync.bats"},
    {"id": "AT-2", "kind": "test", "file": "test/cdsync.bats"},
    {"id": "AT-3", "kind": "test", "file": "test/cdsync.bats"},
    {"id": "AT-4", "kind": "test", "file": "test/cdsync.bats"}
  ]'

  run check_contract_citations "$TESTDIR/repo/intent/.canon/st" "$TESTDIR/repo"
  [ "$status" -eq 1 ]
  assert_contains 'ST9001 AT-2: test/cdsync.bats marks ST9001 AT-2 on a line no test follows'
  # A mark on the last line of a file has no test after it either.
  assert_contains 'ST9001 AT-4: test/cdsync.bats marks ST9001 AT-4 on a line no test follows'
  # AT-10's mark begins with AT-1's characters, so reading it as AT-1's would
  # report AT-1 as well.
  refute_contains 'AT-1:'
  # A row its file does not mark at all cites the whole file, counted apart.
  refute_contains 'AT-3'
  assert_contains 'checked: 4 citation(s), 1 naming a test'
}

# ST0005 AT-00.2
@test "the contract guard reports a cited test the suite does not have" {
  make_contract_fixture
  write_contract ST9001 '[
    {"id": "AT-1", "kind": "test", "legacy": {"raw": "test/cdsync.bats::\"a test that exists\""}},
    {"id": "AT-2", "kind": "test", "file": "test/cdsync.bats::\"a test nobody wrote\""}
  ]'

  run check_contract_citations "$TESTDIR/repo/intent/.canon/st" "$TESTDIR/repo"
  [ "$status" -eq 1 ]
  assert_contains 'ST9001 AT-2: cites "a test nobody wrote", which test/cdsync.bats does not have'
  # The real citation beside it was read and passed, so what failed is the
  # missing name -- not an extract the guard could not read.
  refute_contains 'AT-1'
  assert_contains 'checked: 2 citation(s), 2 naming a test'
}

# ST0005 AT-00.3
@test "the contract guard refuses a test-backed row that cites nothing" {
  make_contract_fixture
  write_contract ST9001 '[
    {"id": "AT-1", "kind": "test", "file": "test/cdsync.bats"},
    {"id": "AT-2", "kind": "test", "status": "green"},
    {"id": "AT-3", "kind": "non-test", "prose": "read by eye"}
  ]'

  run check_contract_citations "$TESTDIR/repo/intent/.canon/st" "$TESTDIR/repo"
  [ "$status" -eq 1 ]
  assert_contains 'ST9001 AT-2: a test-backed row that cites nothing'
  refute_contains 'AT-1'
  # A non-test row cites prose by design, and is not this guard's to judge.
  refute_contains 'AT-3'
}

# ST0005 AT-00.4
@test "the contract guard reports a cited file the repository does not have" {
  make_contract_fixture
  write_contract ST9001 '[
    {"id": "AT-1", "kind": "test", "file": "test/cdsync.bats"},
    {"id": "AT-2", "kind": "test", "file": "test/elsewhere.bats"}
  ]'

  run check_contract_citations "$TESTDIR/repo/intent/.canon/st" "$TESTDIR/repo"
  [ "$status" -eq 1 ]
  assert_contains 'ST9001 AT-2: cites test/elsewhere.bats, which is not in the repository'
  refute_contains 'AT-1'
}

# ST0005 AT-00.5
@test "the contract guard refuses an extract it reads no citation from" {
  make_contract_fixture
  local canon="$TESTDIR/repo/intent/.canon/st"

  # Empty -- the shape of what the old guard read after the port.
  run check_contract_citations "$canon" "$TESTDIR/repo"
  [ "$status" -eq 1 ]
  assert_contains 'read no citation'

  # Missing, which is what an extract that has moved looks like from here.
  run check_contract_citations "$TESTDIR/repo/intent/.canon/elsewhere" "$TESTDIR/repo"
  [ "$status" -eq 1 ]
  assert_contains 'read no citation'

  # Present, but holding no test-backed row.
  write_contract ST9001 '[{"id": "AT-1", "kind": "non-test", "prose": "read by eye"}]'
  run check_contract_citations "$canon" "$TESTDIR/repo"
  [ "$status" -eq 1 ]
  assert_contains 'read no citation'

  # And a thread that is not JSON at all is reported by name, not read as empty.
  printf 'not json\n' >"$canon/ST9002.json"
  run check_contract_citations "$canon" "$TESTDIR/repo"
  [ "$status" -eq 1 ]
  assert_contains 'ST9002: not readable as JSON'
}

@test "the README rule table matches help/check.md" {
  local from_help from_readme
  from_help="$(grep -E '^\| [0-9] \|.*\|.*(blocking|advisory)' "$CDSYNC_HOME/help/check.md")"
  from_readme="$(grep -E '^\| [0-9] \|.*\|.*(blocking|advisory)' "$CDSYNC_HOME/README.md")"

  [ -n "$from_help" ]
  [ -n "$from_readme" ]
  [ "$from_help" = "$from_readme" ]
}

# CI hands shellcheck and `bash -n` a list of paths, and a path that stops
# existing does not let either step pass quietly -- it fails both, but only on a
# push. 3fbb8d0, the v3 re-convert, deleted .claude/scripts/*.sh and left both
# steps naming them, with no CI run to see it. Asking here puts that failure in
# `bin/devbin test all`, before anything is published.
# ST0005 AT-00.10
@test "every path CI hands to shellcheck and bash -n names a file that exists" {
  local ci="$CDSYNC_HOME/.github/workflows/ci.yml"
  local listed word missing=0
  local -a words

  listed="$(sed -n -e 's/^ *run: shellcheck //p' -e 's/^ *for f in \(.*\); do$/\1/p' "$ci" | tr '\n' ' ')"

  # Each step found exactly once, and the dispatcher named by both, before an
  # absence in the list means anything -- a sed that stopped matching reads as
  # nothing to check.
  [ "$(grep -c '^ *run: shellcheck ' "$ci")" -eq 1 ]
  [ "$(grep -c '^ *for f in .*; do$' "$ci")" -eq 1 ]
  [ "$(tr ' ' '\n' <<<"$listed" | grep -cx 'bin/cdsync')" -eq 2 ]

  read -r -a words <<<"$listed"
  for word in "${words[@]}"; do
    if ! compgen -G "$CDSYNC_HOME/$word" >/dev/null; then
      echo "ci.yml names $word, which matches no file" >&2
      missing=$((missing + 1))
    fi
  done
  [ "$missing" -eq 0 ]
}

# The README's development block shows the shellcheck line for a person to copy.
# It is the line CI runs, or it is a second description of it that drifts --
# which is how the README went on naming .claude/scripts after the port.
# ST0005 AT-00.11
@test "the shellcheck line in the README is the one CI runs" {
  local from_ci from_readme
  from_ci="$(sed -n 's/^ *run: \(shellcheck .*\)$/\1/p' "$CDSYNC_HOME/.github/workflows/ci.yml")"
  from_readme="$(grep -E '^shellcheck ' "$CDSYNC_HOME/README.md")"

  [ -n "$from_ci" ]
  [ -n "$from_readme" ]
  [ "$from_ci" = "$from_readme" ]
}

# `--target` is implemented by every command and was documented by seven of the
# eight; `cdsync new` had it in its synopsis and no Options table at all. That is
# the same ratio as the `doctor` help-file gap -- most of them right, which is
# exactly the shape nobody notices by hand.
#
# `found_any` is the positive control. Without it this passes just as well when
# the flag pattern stops matching anything, which is how an empty result becomes
# a green tick in this project.
@test "every flag a command implements is documented in its help file" {
  local commands c impl flag missing="" found_any=0

  commands="$(grep -oE '^  [a-z|]+\)' "$CDSYNC_HOME/bin/cdsync" | tr -d ' )' | tr '|' '\n' \
    | grep -vE '^(-h|--help|help|-v|--version|version|\*)$' | sort -u)"
  [ -n "$commands" ]

  for c in $commands; do
    [[ -f "$CDSYNC_HOME/lib/cmd_$c.sh" ]] || continue
    impl="$(grep -oE '^\s+--[a-z-]+\)' "$CDSYNC_HOME/lib/cmd_$c.sh" | tr -d ' )' | sort -u)"
    for flag in $impl; do
      found_any=1
      grep -qE "^\| \`$flag" "$CDSYNC_HOME/help/$c.md" || missing="$missing $c:$flag"
    done
  done

  [ "$found_any" -eq 1 ]

  if [[ -n "$missing" ]]; then
    echo "flags implemented but absent from their help file:$missing" >&2
    return 1
  fi
}

# A HELP FILE EXISTING IS NOT THE SAME AS THE FRONT PAGE ADVERTISING IT, and
# the sibling test below checks only the first. `help/cdsync.md` carries the
# command table a reader meets before any of the per-command pages, and it has
# now fallen behind the dispatcher twice: once losing `install` and `bootstrap`,
# and once missing `init` on the day it was added -- by the same hand that had
# just written the note about two descriptions of one thing disagreeing.
#
# The terse description survives and the prose one rots, so the prose one is
# what needs the guard.
@test "the front-page command table lists every command the dispatcher accepts" {
  local commands
  commands="$(grep -oE '^  [a-z|]+\)' "$CDSYNC_HOME/bin/cdsync" | tr -d ' )' | tr '|' '\n' \
    | grep -vE '^(-h|--help|help|-v|--version|version|\*)$' | sort -u)"
  [ -n "$commands" ]

  local missing="" c
  for c in $commands; do
    if ! grep -qE "^\| \`cdsync $c( <[a-z]+>)?\`" "$CDSYNC_HOME/help/cdsync.md"; then
      missing="$missing $c"
    fi
  done

  if [[ -n "$missing" ]]; then
    echo "commands absent from the help/cdsync.md command table:$missing" >&2
    return 1
  fi
}

@test "every command the dispatcher accepts has a help file" {
  local commands
  commands="$(grep -oE '^  [a-z|]+\)' "$CDSYNC_HOME/bin/cdsync" | tr -d ' )' | tr '|' '\n' \
    | grep -vE '^(-h|--help|help|-v|--version|version|\*)$' | sort -u)"

  # The probe must be able to find commands at all before a pass means anything.
  [ -n "$commands" ]

  local missing="" c
  for c in $commands; do
    if [[ ! -f "$CDSYNC_HOME/help/$c.md" ]]; then missing="$missing $c"; fi
  done

  if [[ -n "$missing" ]]; then
    echo "commands with no help/<command>.md:$missing" >&2
    return 1
  fi
}

# `help/check.md` said "the five rules" for as long as rule 6 existed -- the one
# that fired eleven times on the first drop to carry classification at all.
#
# THE SEVERITY COLUMN IS WHAT MAKES THIS COUNTABLE. Matching `^| <digit> |` alone
# also catches the exit-code table further down the same file, which reported nine
# documented rules and passed a test that was measuring the wrong thing.
@test "the documented rule count matches the rules check implements" {
  local implemented documented
  implemented="$(grep -ohE '"rule-[0-9]"' "$CDSYNC_HOME/lib/cmd_check.sh" | sort -u | grep -c .)"
  [ "$implemented" -gt 0 ]

  documented="$(grep -cE '^\| [0-9] \|.*\|.*(blocking|advisory)' "$CDSYNC_HOME/help/check.md")"
  [ "$documented" -eq "$implemented" ]

  # THE TABLE IS NOT THE ONLY PLACE THE COUNT IS WRITTEN. The fix that added
  # rule 6's row left the opening sentence saying "applies five rules", and the
  # row-counting assertion above reads straight past it -- so the same file
  # carried the same drift a second time, guarded by a test that was watching
  # the other half of it. Joining the lines first keeps this off the wrap.
  local prose_word prose_n
  prose_word="$(tr '\n' ' ' <"$CDSYNC_HOME/help/check.md" |
    sed -n 's/.*applies \([a-z][a-z]*\) rules.*/\1/p')"
  [ -n "$prose_word" ]
  case "$prose_word" in
    three) prose_n=3 ;;
    four) prose_n=4 ;;
    five) prose_n=5 ;;
    six) prose_n=6 ;;
    seven) prose_n=7 ;;
    eight) prose_n=8 ;;
    nine) prose_n=9 ;;
    *) prose_n=0 ;;
  esac
  [ "$prose_n" -eq "$implemented" ]
}

@test "the conflating classifications are defined once, in the shared primitives" {
  run grep -c '="internal confidential"' "$CDSYNC_HOME/lib/common.sh"
  [ "$status" -eq 0 ]
  [ "$output" -ge 1 ]

  run grep -c '="internal confidential"' "$CDSYNC_HOME/lib/cmd_check.sh"
  [ "$output" -eq 0 ]
}

@test "rule 2 advises on a dependency outside the taxonomy" {
  make_drop >/dev/null
  sed -i.bak 's/reciprocal: \[roadmap\]/reciprocal: [not-a-real-asset]/' \
    "$TESTDIR/drop/assets/investor-update/spec.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  assert_contains "not in the taxonomy"
}

@test "rule 2 does not flag a dependency that is real but unbuilt" {
  make_drop >/dev/null
  sed -i.bak 's/hard_assets: \[\]/hard_assets: [grid-and-layout]/' \
    "$TESTDIR/drop/assets/investor-update/spec.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  refute_contains "grid-and-layout"
}

@test "rule 3 flags an unmarked number and ignores a marked one" {
  make_drop >/dev/null
  echo 'ARR reached $1.2M this period.' \
    >> "$TESTDIR/drop/assets/investor-update/investor-update.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  assert_contains "rule-3"

  echo 'All figures illustrative.' \
    >> "$TESTDIR/drop/assets/investor-update/investor-update.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  refute_contains "rule-3"
}

@test "rule 3 ignores a number inside a blank" {
  make_drop >/dev/null
  echo 'Revenue: [$0.0M, with units]' \
    >> "$TESTDIR/drop/assets/investor-update/investor-update.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  refute_contains "rule-3"
}

@test "rule 3 ignores a percentage in an inline style" {
  make_drop >/dev/null
  printf '<span style="width: 40%%"></span>\n' \
    > "$TESTDIR/drop/assets/investor-update/page.html"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  refute_contains "rule-3"
}

@test "rule 4 blocks a colour absent from the kit" {
  make_drop >/dev/null
  echo '<div style="color:#d97757">x</div>' \
    > "$TESTDIR/drop/assets/investor-update/page.html"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -eq 1 ]
  assert_contains "rule-4"
  assert_contains "#d97757"
}

@test "rule 4 says it cannot run when the kit holds no colour it can read" {
  # The regression guard for the silent abort. matthewsinclair.com's kit is
  # defined entirely in oklch(); before 2 August the scanner read #hex, rgb()
  # and hsl(), so grep matched nothing and exited 1, pipefail carried that into
  # a bare command-substitution assignment, and `set -e` killed the whole
  # command -- target header, then nothing, exit 1. No rules, no rows, no
  # verdict, no error.
  #
  # Two things are asserted and both matter. The run must SURVIVE, and it must
  # SAY the rule could not run -- because an empty kit silently skips rule 4
  # further down, so surviving alone would produce a clean report that never
  # looked.
  make_drop >/dev/null
  printf '{ "note": "a kit with no colour literal at all" }\n' \
    > "$TESTDIR/drop/kit/tokens.json"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -eq 0 ]
  assert_contains "rule 4"
  assert_contains "cannot run"
  assert_contains "assets checked"
}

@test "rule 4 says it cannot run when there is no tokens.json at all" {
  # The same condition reached by the other route. Both must announce, or a
  # tree gets a clean bill from a rule that never executed.
  make_drop >/dev/null
  rm -f "$TESTDIR/drop/kit/tokens.json"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -eq 0 ]
  assert_contains "rule 4"
  assert_contains "cannot run"
}

@test "rule 4 skips a file declaring itself generated in a comment" {
  make_drop >/dev/null
  printf '// @generated -- do not edit\n.x { color: #d97757; }\n' \
    > "$TESTDIR/drop/assets/investor-update/support.js"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -eq 0 ]
  refute_contains "#d97757"
}

@test "rule 4 does not scan a binary file that happens to carry hex bytes" {
  make_drop >/dev/null
  # A photograph is not somewhere a colour was authored. This stands in for the
  # 2.4M JPEG in a real drop that carries eleven hex-shaped byte runs: NUL bytes
  # up front, a sequence that matches the pattern further in.
  printf 'JFIF\000\000\000\000#d97757 trailing bytes\n' \
    > "$TESTDIR/drop/assets/investor-update/photo.jpg"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -eq 0 ]
  refute_contains "#d97757"
}

@test "rule 4 still scans a text file with a binary-looking extension" {
  make_drop >/dev/null
  # The skip is by content, so a text file named .png is still checked. Pins the
  # decision against decaying into an extension exemption, which would fail in
  # the direction that stops checking.
  printf '.x { color: #d97757; }\n' \
    > "$TESTDIR/drop/assets/investor-update/notes.png"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -eq 1 ]
  assert_contains "rule-4"
  assert_contains "#d97757"
}

@test "rule 1 does not count a bracket in a script block as a blank" {
  make_drop >/dev/null
  # Three assets in a real drop were blocked on `[]`, `[k]` and a bracket around
  # a function call, every one of them JavaScript in a .dc.html.
  printf '<p>text</p>\n<script>\nconst parts=[]; if(n("kit")) parts.push([k]);\n</script>\n' \
    > "$TESTDIR/drop/assets/investor-update/page.html"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  refute_contains "blanks remain"
}

@test "rule 1 still counts a blank in prose beside a script block" {
  make_drop >/dev/null
  # The skip is scoped to the block, not to the file. A file containing a script
  # must still be checked everywhere else in it.
  printf '<p>owner is [venture name]</p>\n<script>const a=[k];</script>\n' \
    > "$TESTDIR/drop/assets/investor-update/page.html"
  run run_lib "each_blank_in_file '$TESTDIR/drop/assets/investor-update/page.html'"
  assert_contains "venture name"
  refute_contains "k"
}

@test "a colour function with named arguments is code, not a colour" {
  # rgb(r, g, b) is a colour being computed. Eight such matches in one real
  # colour-space converter were reported as blocking.
  run run_lib "printf '%s\n%s\n%s\n' 'rgb(r, g, b)' 'hsl(d[i], d[i + 1], d[i + 2])' 'rgb(p, q, t)' | normalise_colours"
  [ -z "$output" ]
}

@test "a colour function with numeric arguments is still a colour" {
  # The guard must not stop the rule seeing real literals, in any valid form.
  run run_lib "printf '%s\n' 'rgb(217, 119, 87)' | normalise_colours"
  assert_contains "#d97757"

  run run_lib "printf '%s\n' 'hsl(120, 50%, 50%)' | normalise_colours"
  assert_contains "hsl(120,50%,50%)"
}

@test "fm_scalar strips quotes from a value with leading whitespace" {
  # The second and later elements of an inline list arrive with the space that
  # followed the comma. Quotes left on them made rule 2 report a slug that is in
  # the library as absent from it.
  run run_lib "fm_scalar '\"print-collateral\"'"
  [ "$output" = "print-collateral" ]

  run run_lib "fm_scalar ' \"social-and-ad-kit\"'"
  [ "$output" = "social-and-ad-kit" ]
}

@test "fm_list returns every element of an inline list unquoted" {
  make_drop >/dev/null
  spec="$TESTDIR/drop/assets/investor-update/spec.md"
  printf -- '---\nasset: investor-update\ndepends_on:\n  hard_assets: ["brand-guidelines", "pitch-deck", "kit"]\n---\n' \
    > "$spec"
  run run_lib "fm_list '$spec' depends_on.hard_assets"
  [ "${lines[0]}" = "brand-guidelines" ]
  [ "${lines[1]}" = "pitch-deck" ]
  [ "${lines[2]}" = "kit" ]
}

@test "a currency symbol is matched whole, not by its second byte" {
  make_drop >/dev/null
  # Under a C locale a bracket class is a set of bytes, and a pound sign is two
  # of them. Matching from the second byte produced an invalid lone A3 in a real
  # drop's output.
  printf 'The rate is \xc2\xa312 an hour and the kit is \xc2\xa33.95\n' \
    > "$TESTDIR/metric.md"
  run run_lib "LC_ALL=C each_metric_in_file '$TESTDIR/metric.md'"
  assert_contains "£12"
  assert_contains "£3.95"
}

# Three of the seven rule-3 findings on G and G were width/height percentages
# built in JS string literals -- unsatisfiable by any instruction, so they would
# have reported identically every round forever. The prose assertion is the
# positive control: without it this passes just as well when nothing was
# extracted at all.
@test "a CSS length built inside a script is not a claim" {
  make_drop >/dev/null
  cat > "$TESTDIR/metric.html" <<'HTML'
<div>Blacks lift off zero; contrast eases back 7%.</div>
<script type="text/x-dc">
  imgStyle: 'position: absolute; width: 100%; height: 100%; object-fit: cover'
</script>
HTML
  run run_lib "each_metric_in_file '$TESTDIR/metric.html'"
  assert_contains "7%"
  refute_contains "100%"
}

# ============================================================================
# RELEASE
# ============================================================================
#
# `release` operates on $CDSYNC_HOME, which in this suite IS the real repository.
# So these exercise the pure helpers and the read-only and --dry-run paths, and
# never a live bump -- a test that moved VERSION would move it for real.

@test "release show prints the bare version" {
  run "$CDSYNC_BIN" release show
  [ "$status" -eq 0 ]
  [[ "$output" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
}

@test "release bumps each part independently" {
  run run_lib "source '$CDSYNC_HOME/lib/cmd_release.sh'; release_bump_part 1.2.3 major"
  [ "$output" = "2.0.0" ]
  run run_lib "source '$CDSYNC_HOME/lib/cmd_release.sh'; release_bump_part 1.2.3 minor"
  [ "$output" = "1.3.0" ]
  run run_lib "source '$CDSYNC_HOME/lib/cmd_release.sh'; release_bump_part 1.2.3 patch"
  [ "$output" = "1.2.4" ]
}

@test "release rejects a bump part that is not major, minor or patch" {
  run run_lib "source '$CDSYNC_HOME/lib/cmd_release.sh'; release_bump_part 1.2.3 sideways"
  [ "$status" -ne 0 ]
}

# THE FIRST RELEASE WAS UNREACHABLE. `cut` took only major|minor|patch and
# always moved forward, so the version a project is ON could never be tagged --
# and that is exactly the version a project's FIRST release needs. Cdsync sat
# at 0.1.0 with zero tags and no way to cut 0.1.0: `cut minor` would have
# produced 0.2.0, skipping the release the repository already announced.
#
# The bump verbs presumed a previous release existed. Nothing said so, and the
# gap is invisible from reading the code -- it only shows up the first time
# anyone tries to release anything.
@test "release accepts an explicit target version, not only a bump part" {
  run run_lib "source '$CDSYNC_HOME/lib/cmd_release.sh'; release_bump_part 1.2.3 2.0.0"
  [ "$status" -eq 0 ]
  [ "$output" = "2.0.0" ]
}

# The whole point of the explicit form: cutting the version already in VERSION.
# Equality is ALLOWED here and refused one layer up -- `cut` refuses when the
# tag already exists, which is the check that actually knows whether a version
# has been released. Refusing equality here would re-close the gap.
@test "release accepts the current version as an explicit target, so a first release can be cut" {
  run run_lib "source '$CDSYNC_HOME/lib/cmd_release.sh'; release_bump_part 0.1.0 0.1.0"
  [ "$status" -eq 0 ]
  [ "$output" = "0.1.0" ]
}

# Forward or level, never backward. A tag that names a version older than the
# one in VERSION would make the two disagree about what is current.
@test "release refuses an explicit target older than the current version" {
  run run_lib "source '$CDSYNC_HOME/lib/cmd_release.sh'; release_bump_part 1.2.3 1.0.0"
  [ "$status" -ne 0 ]
  run run_lib "source '$CDSYNC_HOME/lib/cmd_release.sh'; release_bump_part 1.2.3 1.2.2"
  [ "$status" -ne 0 ]
  run run_lib "source '$CDSYNC_HOME/lib/cmd_release.sh'; release_bump_part 0.10.0 0.9.0"
  [ "$status" -ne 0 ]
}

# Each component compares as a NUMBER. String ordering puts 0.10.0 below 0.9.0
# and would refuse a legitimate release on the tenth minor version.
@test "release compares version components numerically, not as strings" {
  run run_lib "source '$CDSYNC_HOME/lib/cmd_release.sh'; release_bump_part 0.9.0 0.10.0"
  [ "$status" -eq 0 ]
  [ "$output" = "0.10.0" ]
}

# An explicit target is held to the same shape as VERSION itself. The `v`
# belongs to the git tag and nowhere else.
@test "release refuses an explicit target that is not bare semver" {
  local bad
  for bad in v2.0.0 2.0.0-rc1 1.2.3.4 2.0.x; do
    run run_lib "source '$CDSYNC_HOME/lib/cmd_release.sh'; release_bump_part 1.2.3 '$bad'"
    [ "$status" -ne 0 ] || {
      echo "accepted '$bad' as an explicit target, which is not bare semver" >&2
      return 1
    }
  done
}

@test "release cut plans the explicit version it was given" {
  run "$CDSYNC_BIN" release cut 9.9.9 --dry-run
  [ "$status" -eq 0 ]
  assert_contains "9.9.9"
  assert_contains "nothing was written"
}

# THE SECOND HALF OF THE FIRST-RELEASE GAP, and it survived the first fix.
# Teaching `cut` to accept an explicit version got past the arithmetic, and
# then the ceremony died one step later: cutting the version already in
# VERSION writes the same bytes, so `git commit` has nothing to commit and
# refuses. `cut 0.1.0` ran every gate green and then failed at step 3.
#
# It could not have been caught by a dry run, which stops before writing, nor
# by the six tests around `release_bump_part`, which assert one layer above
# where this lives. And the ceremony itself is untestable end to end here on
# purpose -- the gates refuse to run inside the suite, because running the
# suite from inside the suite does not terminate. So the decision is extracted
# to a function that CAN be tested, against a real repository.
#
# NO EMPTY COMMIT. The tag names the commit that already is the release; a
# manufactured empty commit would add a second thing claiming to be it.
@test "release commits a version change, and tags in place when VERSION is already correct" {
  local repo="$TESTDIR/relrepo"
  mkdir -p "$repo"
  git -C "$repo" init -q
  git -C "$repo" config user.email "test@example.invalid"
  git -C "$repo" config user.name "test"
  printf '0.1.0\n' >"$repo/VERSION"
  git -C "$repo" add VERSION
  git -C "$repo" commit -q -m "init"

  local before
  before="$(git -C "$repo" rev-list --count HEAD)"

  # VERSION already holds the target: nothing to commit. Must SUCCEED.
  run run_lib "source '$CDSYNC_HOME/lib/cmd_release.sh'; release_commit_version 0.1.0 '$repo'"
  [ "$status" -eq 0 ]
  [ "$(git -C "$repo" rev-list --count HEAD)" -eq "$before" ]

  # A real move still commits exactly once, and leaves nothing behind.
  printf '0.2.0\n' >"$repo/VERSION"
  run run_lib "source '$CDSYNC_HOME/lib/cmd_release.sh'; release_commit_version 0.2.0 '$repo'"
  [ "$status" -eq 0 ]
  [ "$(git -C "$repo" rev-list --count HEAD)" -eq "$((before + 1))" ]
  [ -z "$(git -C "$repo" status --porcelain)" ]
  git -C "$repo" log -1 --format=%s | grep -q '^release: v0.2.0$'
}

# The `v` belongs to the git tag and nowhere else. A version string that
# sometimes carries it is one that gets compared against one that does not.
@test "release accepts bare semver and refuses everything else" {
  run run_lib "source '$CDSYNC_HOME/lib/cmd_release.sh'; release_assert_semver 0.2.0"
  [ "$status" -eq 0 ]
  local bad
  for bad in v0.2.0 0.2 0.2.0-rc1 "" abc 1.2.3.4; do
    run run_lib "source '$CDSYNC_HOME/lib/cmd_release.sh'; release_assert_semver '$bad'"
    [ "$status" -ne 0 ] || {
      echo "accepted '$bad', which is not bare semver" >&2
      return 1
    }
  done
}

@test "release cut --dry-run writes nothing" {
  local before after
  before="$(cat "$CDSYNC_HOME/VERSION")"
  run "$CDSYNC_BIN" release cut minor --dry-run
  after="$(cat "$CDSYNC_HOME/VERSION")"
  [ "$before" = "$after" ]
  assert_contains "nothing was written"
}

@test "release cut --dry-run states whether it would push" {
  run "$CDSYNC_BIN" release cut patch --dry-run
  assert_contains "NO -- local only"
  run "$CDSYNC_BIN" release cut patch --dry-run --push
  assert_contains "push    commit and tag"
}

# Running the suite from inside the suite does not terminate, and the first
# version of the test above proved it. The gate reports that as a FAILURE
# rather than skipping it -- so a release cannot be cut from inside the tests,
# which is not a thing anyone should be able to do by accident.
@test "the test gate refuses to run the suite from inside the suite" {
  run "$CDSYNC_BIN" release cut patch --dry-run
  assert_contains "cannot run the suite from inside the suite"
}

@test "release refuses an unknown subcommand" {
  run "$CDSYNC_BIN" release frobnicate
  [ "$status" -ne 0 ]
  assert_contains "unknown subcommand"
}

# devbin's manifest is the one file devbin writes a home directory into:
# `devbin install` and `devbin upgrade` both record the absolute path of the
# devbin they came from. The home-path guard sees a file only once it is tracked,
# and this repository publishes on push -- so .gitignore keeps the manifest out
# of the tree, and this pins that it stays out.
# ST0005 AT-00.7
@test "the devbin manifest is never tracked, because it records a home directory" {
  # Two halves, each asked on its own. The rule: --no-index asks the patterns
  # alone, because without it check-ignore answers "not ignored" for any TRACKED
  # file, and the second half would never be reached. The index: an ignore rule
  # does not untrack a file that is already tracked.
  git -C "$CDSYNC_HOME" check-ignore -q --no-index bin/.devbin/manifest.sha256
  [ -z "$(git -C "$CDSYNC_HOME" ls-files bin/.devbin/manifest.sha256)" ]
}

# The tarball contract, checked against the mechanism that actually builds it.
# `git archive` reads .gitattributes, so this pins the export-ignore rules
# rather than a list restated in the module or the help page.
# ST0005 AT-00.8
@test "a release archive carries the tool and not how it is made" {
  local listing
  listing="$(git -C "$CDSYNC_HOME" archive --format=tar HEAD | tar -t 2>/dev/null)"

  # The probe must be able to see the archive at all before an absence means
  # anything.
  [ -n "$listing" ]
  printf '%s\n' "$listing" | grep -q '^bin/cdsync$'
  printf '%s\n' "$listing" | grep -q '^lib/cmd_release.sh$'
  printf '%s\n' "$listing" | grep -q '^specs/'
  printf '%s\n' "$listing" | grep -q '^VERSION$'

  local excluded
  for excluded in 'intent/' 'test/' '.github/' '.claude/' '.gitattributes' \
    'AGENTS.md' 'CLAUDE.md' 'usage-rules.md' '.intent_critic.yml' 'design/' \
    'bin/devbin' 'bin/.devbin/'; do
    if printf '%s\n' "$listing" | grep -q "^$excluded"; then
      echo "release archive carries $excluded, which .gitattributes export-ignores" >&2
      return 1
    fi
  done

  # Pinned POSITIVELY as well, because a list of things that must be absent
  # cannot notice a new thing that should have been. The top level of a release
  # is a short, deliberate set; if it grows, that should be a decision.
  # LC_ALL=C on the sort, or this assertion orders by the runner's locale and
  # compares against a list written under mine. Same bug as the one the
  # bootstrap inventory had, reproduced in the test that checks for it.
  local actual expected
  actual="$(printf '%s\n' "$listing" | sed 's|/.*|/|' | LC_ALL=C sort -u | tr -d ' ' | tr '\n' ' ')"
  expected="LICENSE.md README.md VERSION bin/ help/ lib/ specs/ templates/ "
  if [[ "$actual" != "$expected" ]]; then
    echo "release archive top level changed" >&2
    echo "  expected: $expected" >&2
    echo "  actual:   $actual" >&2
    return 1
  fi

  # And one level down, where the pin above cannot see. devbin lives in `bin/`
  # beside the dispatcher, so a release that carried it would leave the top level
  # exactly as it was -- measured on 15 September 2026 against a tree holding
  # devbin without its export-ignore rules: the top-level pin passed, and `bin/`
  # held 49 entries. The exclusions above name devbin; this pin is for whatever
  # arrives in `bin/` next without a name. A release's `bin/` holds the
  # dispatcher and nothing else.
  local bin_actual bin_expected
  bin_actual="$(printf '%s\n' "$listing" | grep '^bin/' | LC_ALL=C sort | tr '\n' ' ')"
  bin_expected="bin/ bin/cdsync "
  if [[ "$bin_actual" != "$bin_expected" ]]; then
    echo "release archive bin/ changed" >&2
    echo "  expected: $bin_expected" >&2
    echo "  actual:   $bin_actual" >&2
    return 1
  fi
}

@test "is_binary_file decides by content, not by extension" {
  make_drop >/dev/null
  printf 'a\000b\n' > "$TESTDIR/really-binary.md"
  printf '.x { color: #d97757; }\n' > "$TESTDIR/really-text.jpg"

  run run_lib "is_binary_file '$TESTDIR/really-binary.md'"
  [ "$status" -eq 0 ]

  run run_lib "is_binary_file '$TESTDIR/really-text.jpg'"
  [ "$status" -eq 1 ]
}

@test "rule 4 checks a README even though vendored runtime beside it is skipped" {
  make_drop >/dev/null
  mkdir -p "$TESTDIR/drop/assets/investor-update/vendor"
  printf '// @generated\n#d97757\n' \
    > "$TESTDIR/drop/assets/investor-update/vendor/runtime.js"
  printf 'This directory is generated.\n\n#abc\n' \
    > "$TESTDIR/drop/assets/investor-update/vendor/README.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -eq 1 ]
  # Shorthand expanded, so the reported value is comparable to the kit's.
  assert_contains "#aabbcc"
  refute_contains "#d97757"
}

# The sample is three of N, and saying so is the whole point. G&G's
# design-system.dc.html carries £44 and £48 -- prices, about as claim-like as a
# number gets -- and reported as "100% 3% 7%", because the list is sorted and a
# digit sorts before a currency symbol. The truncation dropped the most
# important end of the list and read as the whole of it.
@test "rule 3 says how many numbers it did not show" {
  make_drop >/dev/null
  local dir="$TESTDIR/drop/assets/investor-update"
  printf 'Revenue 12%% and 34%% and 56%% and then £44 and £48 besides.\n' \
    > "$dir/figures.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  assert_contains "rule-3"
  assert_contains "more)"
}

@test "rule 3 does not annotate a file whose numbers all fit" {
  make_drop >/dev/null
  printf 'Just 12%% here.\n' > "$TESTDIR/drop/assets/investor-update/figures.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  assert_contains "rule-3"
  refute_contains "more)"
}

@test "rule 5 advises when partial carries no coverage" {
  make_drop >/dev/null
  sed -i.bak 's/^status: spec-only/status: partial/' \
    "$TESTDIR/drop/assets/investor-update/spec.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  assert_contains "rule-5"
  assert_contains "requires a coverage field"
}

@test "rule 5 advises when complete has incomplete coverage" {
  make_drop >/dev/null
  run_lib "fm_set '$TESTDIR/drop/assets/investor-update/spec.md' coverage '12/28 rendered'"
  run_lib "fm_set '$TESTDIR/drop/assets/investor-update/spec.md' status complete"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  assert_contains "coverage is 12/28"
}

# `coverage: <what is covered, when status is partial>` is what the brief asks
# for, so prose is the obedient answer and the rule used to reject it -- ten
# times across Lamplight and G&G. `assert_contains "assets checked"` is the
# positive control: without it this passes just as well when nothing was walked
# at all, which is the way every silent check in this project has failed.
@test "rule 5 accepts prose coverage on a partial asset" {
  make_drop >/dev/null
  run_lib "fm_set '$TESTDIR/drop/assets/investor-update/spec.md' coverage 'Three of four surfaces as built. No Frontdesk capture.'"
  run_lib "fm_set '$TESTDIR/drop/assets/investor-update/spec.md' status partial"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  assert_contains "assets checked"
  refute_contains "not in N/M form"
}

# The half with teeth. `complete` is a claim of totality, and prose cannot be
# measured against it -- so the rule reports what it cannot see rather than
# going quiet, which is the one direction this project treats as dangerous.
@test "rule 5 reports prose coverage it cannot measure on a complete asset" {
  make_drop >/dev/null
  run_lib "fm_set '$TESTDIR/drop/assets/investor-update/spec.md' coverage 'Three of four surfaces as built. No Frontdesk capture.'"
  run_lib "fm_set '$TESTDIR/drop/assets/investor-update/spec.md' status complete"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  assert_contains "rule-5"
  assert_contains "totality cannot be checked"
}

@test "check refuses a target that is not a drop" {
  mkdir -p "$TESTDIR/empty"
  run "$CDSYNC_BIN" check --target "$TESTDIR/empty"
  [ "$status" -eq 2 ]
  assert_contains "no drop at"
}

# A tree organised by medium has a real assets/ holding raw brand files and no
# slug directories. drop_looks_valid passes it because assets/ exists, the walk
# then yields nothing, and every rule silently has nothing to read. Reproduces
# snorkeltoast, Baize and Lamplight, all three of which reported "clean".
@test "check refuses when assets/ holds files rather than slug directories" {
  mkdir -p "$TESTDIR/bymedium/assets"
  touch "$TESTDIR/bymedium/assets/wordmark.svg"
  touch "$TESTDIR/bymedium/assets/mascot.png"
  run "$CDSYNC_BIN" check --target "$TESTDIR/bymedium"
  [ "$status" -eq 2 ]
  assert_contains "0 assets checked"
  refute_contains "checked -- clean"
}

@test "check refuses an assets/ that exists but is empty" {
  mkdir -p "$TESTDIR/hollow/assets"
  run "$CDSYNC_BIN" check --target "$TESTDIR/hollow"
  [ "$status" -eq 2 ]
  assert_contains "0 assets checked"
  refute_contains "checked -- clean"
}

# Pins the guard against over-firing: a real drop must still pass and say how
# many assets it checked.
@test "check still passes a real drop and reports a nonzero count" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -eq 0 ]
  assert_contains "assets checked"
  refute_contains "0 assets checked"
}

@test "check reports an asset with no spec as blocking" {
  make_drop >/dev/null
  rm "$TESTDIR/drop/assets/investor-update/spec.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -eq 1 ]
  assert_contains "no spec.md"
}

# With a manifest present, the tool can say an asset is broken. Without one it
# cannot -- Lamplight's assets/ holds media directories, which walk as assets and
# produce "4 blocking" for four things nobody ever claimed were assets. The
# contract is untouched (an asset is still a directory under assets/); only the
# certainty of the sentence changes.
@test "a missing spec says so differently when there is no manifest to consult" {
  make_drop >/dev/null
  rm "$TESTDIR/drop/assets/investor-update/spec.md"

  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -eq 1 ]
  assert_contains "an asset must carry its definition of done"
  refute_contains "no index.md to say"

  rm "$TESTDIR/drop/index.md"
  run "$CDSYNC_BIN" check --target "$TESTDIR/drop"
  [ "$status" -eq 1 ]
  assert_contains "no index.md to say whether this is an asset at all"
}

# ============================================================================
# ARCHIVE PRE-FLIGHT
# ============================================================================
#
# Every one of these checks was a HAND ritual on 30 Jul 2026, applied to four
# Claude Design exports by a person reading a listing. The tool did none of them:
# stage_drop called `unzip -q` straight at the archive. These tests exist so the
# ritual cannot quietly stop happening.
#
# The rejection logic is exercised directly rather than through a crafted
# archive, because `zip` deliberately refuses to STORE an absolute or traversing
# path -- so a fixture built with it could not carry the thing under test. The
# wiring is proved separately, at the bottom, by a hostile archive `import`
# actually refuses.

@test "preflight refuses an absolute path" {
  run run_lib 'archive_reject_absolute "$(printf "RETURN.md\n/etc/passwd\nkit/kit.md")"'
  [ "$status" -eq 1 ]
  assert_contains "absolute path"
  assert_contains "/etc/passwd"
}

@test "preflight refuses parent-directory traversal" {
  run run_lib 'archive_reject_traversal "$(printf "RETURN.md\n../../escape.txt")"'
  [ "$status" -eq 1 ]
  assert_contains "traversal"
  assert_contains "../../escape.txt"
}

# `..deprecated.md` is a legal filename, not an escape. Anchoring the match to
# the separators rather than to the two characters is what keeps a real drop from
# being refused for spelling.
@test "traversal detection does not fire on a filename that merely begins with dots" {
  run run_lib 'archive_reject_traversal "$(printf "RETURN.md\nnotes/..deprecated.md")"'
  [ "$status" -eq 0 ]
}

@test "preflight refuses entries differing only in case" {
  run run_lib 'archive_reject_case_collision "$(printf "README.md\nreadme.md\nRETURN.md")"'
  [ "$status" -eq 1 ]
  assert_contains "differing only in case"
  assert_contains "README.md"
  assert_contains "readme.md"
}

@test "case detection does not fire on distinct names" {
  run run_lib 'archive_reject_case_collision "$(printf "README.md\nRETURN.md\nkit/kit.md")"'
  [ "$status" -eq 0 ]
}

# The regression pin for a bug that could only appear on a real archive. The
# offender list truncates at five; once `head` closes the pipe it SIGPIPEs the
# grep feeding it, `set -o pipefail` reports 141, and `set -e` aborts the
# refusal BEFORE its `return 1` -- so the caller reads 141, the explanation never
# prints, and every fixture with one bad entry still passes. Seven offenders is
# the smallest input that would have caught it.
@test "a refusal past the fifth offender still exits 1 and says how many it hid" {
  run run_lib 'archive_reject_absolute "$(printf "/a\n/b\n/c\n/d\n/e\n/f\n/g")"'
  [ "$status" -eq 1 ]
  assert_contains "and 2 more"
}

@test "preflight refuses an archive carrying a symlink" {
  mkdir -p "$TESTDIR/hostile"
  echo "real content" > "$TESTDIR/hostile/plain.txt"
  ln -s /etc/passwd "$TESTDIR/hostile/link.txt"
  ( cd "$TESTDIR/hostile" && zip -qry "$TESTDIR/hostile.zip" . )

  run run_lib "archive_preflight '$TESTDIR/hostile.zip'"
  [ "$status" -eq 1 ]
  assert_contains "symlink"
}

@test "preflight refuses a source directory carrying a symlink" {
  mkdir -p "$TESTDIR/hostiledir"
  echo "real content" > "$TESTDIR/hostiledir/plain.txt"
  ln -s /etc/passwd "$TESTDIR/hostiledir/link.txt"

  run run_lib "archive_preflight '$TESTDIR/hostiledir'"
  [ "$status" -eq 1 ]
  assert_contains "symlink"
}

# An empty archive is refused for BEING empty, not for failing a CRC check. The
# distinction is the whole point of ordering the index check ahead of the
# integrity one: a refusal that gives the wrong reason sends someone
# re-downloading a file that arrived intact.
@test "preflight refuses an empty archive, and says so" {
  # The 22-byte end-of-central-directory record: a structurally valid zip with
  # no entries. Built by hand because `zip` will not produce one.
  printf 'PK\005\006\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000' \
    > "$TESTDIR/empty.zip"

  run run_lib "archive_preflight '$TESTDIR/empty.zip'"
  [ "$status" -eq 1 ]
  assert_contains "empty"
  refute_contains "integrity"
}

@test "preflight passes a well-formed drop" {
  make_drop >/dev/null
  ( cd "$TESTDIR/drop" && zip -qry "$TESTDIR/clean.zip" . )

  run run_lib "archive_preflight '$TESTDIR/clean.zip'"
  [ "$status" -eq 0 ]
}

# The wiring test. Everything above proves the checks work; this proves import
# runs them, and runs them BEFORE it writes -- a pre-flight that fires after the
# first file lands is not a pre-flight.
@test "import refuses a hostile archive without touching the target" {
  mkdir -p "$TESTDIR/hostile/assets/investor-update" "$TESTDIR/target"
  echo "spec" > "$TESTDIR/hostile/assets/investor-update/spec.md"
  echo "# Return" > "$TESTDIR/hostile/RETURN.md"
  ln -s /etc/passwd "$TESTDIR/hostile/link.txt"
  ( cd "$TESTDIR/hostile" && zip -qry "$TESTDIR/hostile.zip" . )
  echo "repo-authored" > "$TESTDIR/target/addenda-note.md"

  run "$CDSYNC_BIN" import "$TESTDIR/hostile.zip" --target "$TESTDIR/target"
  [ "$status" -ne 0 ]
  assert_contains "symlink"
  [ ! -d "$TESTDIR/target/assets" ]
  [ "$(cat "$TESTDIR/target/addenda-note.md")" = "repo-authored" ]
}

# ============================================================================
# IMPORT
# ============================================================================
#
# The first test here is the one that matters. A drop deleted a file it did not
# know about, and that is what the owned-path list exists to prevent.

@test "a target file absent from the drop survives the import" {
  make_drop >/dev/null
  mkdir -p "$TESTDIR/target"
  echo "why the placeholder must be boring" > "$TESTDIR/target/README.md"
  echo "the order this drop answers" > "$TESTDIR/target/brief.md"

  run "$CDSYNC_BIN" import "$TESTDIR/drop" --target "$TESTDIR/target"
  [ "$status" -eq 0 ]
  [ "$(cat "$TESTDIR/target/README.md")" = "why the placeholder must be boring" ]
  [ "$(cat "$TESTDIR/target/brief.md")" = "the order this drop answers" ]
}

# An addendum is repo-authored material about the design, written where the design
# has a gap, and it flows BACK to Claude Design rather than arriving from it. It is
# the one thing under the target that an export must never eat. Baize lost a
# handoff file and eight ADR banners between two drops on 30 Jul 2026 -- not to
# import, which writes only the owned paths, but to a hand replace of the tree.
@test "a repo-authored addendum survives the import" {
  make_drop >/dev/null
  mkdir -p "$TESTDIR/target/addenda"
  echo "copy for four typed player states" > "$TESTDIR/target/addenda/typed-states.md"
  echo "the addenda protocol" > "$TESTDIR/target/addenda/README.md"

  run "$CDSYNC_BIN" import "$TESTDIR/drop" --target "$TESTDIR/target"
  [ "$status" -eq 0 ]
  [ "$(cat "$TESTDIR/target/addenda/typed-states.md")" = "copy for four typed player states" ]
  [ "$(cat "$TESTDIR/target/addenda/README.md")" = "the addenda protocol" ]
}

# The declaration had no reader for a day. Import protected addenda/ only
# because its owned list happened not to name it -- emergence, not enforcement.
@test "the protected declaration is what decides, not the owned list's silence" {
  run run_lib 'drop_path_is_protected addenda && echo protected'
  [ "$status" -eq 0 ]
  assert_contains "protected"
  run run_lib 'drop_path_is_protected assets || echo "not protected"'
  assert_contains "not protected"
}

@test "a name declared both owned and protected refuses the install outright" {
  run run_lib 'CDSYNC_DROP_OWNED_DIRS="assets kit notes addenda"; drop_guard_contract'
  [ "$status" -eq 1 ]
  assert_contains "contradicts itself"
  assert_contains "addenda"
}

@test "the contract as shipped does not contradict itself" {
  run run_lib 'drop_guard_contract && echo sane'
  [ "$status" -eq 0 ]
  assert_contains "sane"
}

@test "import reports a drop-carried protected path apart from what it ignores" {
  make_drop >/dev/null
  mkdir -p "$TESTDIR/drop/addenda"
  echo "echoed back" > "$TESTDIR/drop/addenda/typed-states.md"
  mkdir -p "$TESTDIR/target/addenda"
  echo "the repo's own" > "$TESTDIR/target/addenda/typed-states.md"

  run "$CDSYNC_BIN" import "$TESTDIR/drop" --target "$TESTDIR/target"
  [ "$status" -eq 0 ]
  assert_contains "protect addenda"
  [ "$(cat "$TESTDIR/target/addenda/typed-states.md")" = "the repo's own" ]
}

# A drop carrying addenda/ must not install it EITHER WAY -- whether or not the
# target already has one. The alternative makes the same archive install
# differently in two repositories, with nothing saying why.
@test "install discards a drop-carried protected path even when the target has none" {
  local src
  src="$(make_as_is_export)"
  mkdir -p "$src/addenda"
  echo "from the drop" > "$src/addenda/typed-states.md"
  mkdir -p "$TESTDIR/bare"

  run "$CDSYNC_BIN" install "$src" --target "$TESTDIR/bare" --yes
  [ "$status" -eq 0 ]
  assert_contains "discard  addenda"
  [ ! -e "$TESTDIR/bare/addenda" ]
}

@test "addenda is declared protected in the drop contract" {
  # Pins the declaration itself, not just the behaviour. The behaviour above
  # follows from import writing only the owned paths; the declaration is what a
  # brief and a future install path can both read.
  run run_lib 'printf "%s\n" "$CDSYNC_DROP_PROTECTED_PATHS"'
  [ "$status" -eq 0 ]
  assert_contains "addenda"
  run run_lib 'printf "%s\n" "$CDSYNC_DROP_OWNED_DIRS"'
  refute_contains "addenda"
}

@test "BOOTSTRAP-CD.md is declared protected alongside addenda" {
  # Cdsync-side output living inside a tree Claude Design replaces wholesale.
  # Without the declaration an export silently eats it, and the guarantee it
  # states -- that a cold CD project can be rebuilt from the tree -- goes with it.
  run run_lib 'printf "%s\n" "$CDSYNC_DROP_PROTECTED_PATHS"'
  [ "$status" -eq 0 ]
  assert_contains "BOOTSTRAP-CD.md"
  run run_lib 'drop_path_is_protected "BOOTSTRAP-CD.md" && echo protected'
  assert_contains "protected"
}

# The venture's own facts and order, living at the tree root by hv's 9 Aug 2026
# ruling. An install replacing it would hand the next round's order to the drop.
@test "cdsync.json is declared protected alongside addenda" {
  run run_lib 'drop_path_is_protected "cdsync.json" && echo protected'
  assert_contains "protected"
}

@test "the protected list guards files as well as directories" {
  # The guard was always on names -- the replace loop walks every top-level entry
  # and asks about the basename. It was called _DIRS while it held one entry and
  # that entry happened to be a directory.
  run run_lib 'drop_path_is_protected "addenda" && echo dir-protected'
  assert_contains "dir-protected"
  run run_lib 'drop_path_is_protected "assets" || echo not-protected'
  assert_contains "not-protected"
}

@test "an asset from an earlier drop survives a later one" {
  make_drop >/dev/null
  mkdir -p "$TESTDIR/target/assets/roadmap"
  echo "an earlier drop's work" > "$TESTDIR/target/assets/roadmap/spec.md"

  run "$CDSYNC_BIN" import "$TESTDIR/drop" --target "$TESTDIR/target"
  [ "$status" -eq 0 ]
  [ -f "$TESTDIR/target/assets/roadmap/spec.md" ]
}

@test "a generated site survives the import" {
  make_drop >/dev/null
  mkdir -p "$TESTDIR/target/site"
  echo "<h1>generated</h1>" > "$TESTDIR/target/site/index.html"

  run "$CDSYNC_BIN" import "$TESTDIR/drop" --target "$TESTDIR/target"
  [ -f "$TESTDIR/target/site/index.html" ]
}

@test "notes merge rather than replace" {
  make_drop >/dev/null
  mkdir -p "$TESTDIR/target/notes"
  echo "round two's reasoning" > "$TESTDIR/target/notes/earlier.md"

  run "$CDSYNC_BIN" import "$TESTDIR/drop" --target "$TESTDIR/target"
  [ -f "$TESTDIR/target/notes/earlier.md" ]
  [ -f "$TESTDIR/target/notes/thinking.md" ]
}

@test "an asset slug is replaced wholesale so renamed files do not linger" {
  make_drop >/dev/null
  mkdir -p "$TESTDIR/target/assets/investor-update"
  echo "old name" > "$TESTDIR/target/assets/investor-update/old-artefact.md"

  run "$CDSYNC_BIN" import "$TESTDIR/drop" --target "$TESTDIR/target"
  [ ! -f "$TESTDIR/target/assets/investor-update/old-artefact.md" ]
  [ -f "$TESTDIR/target/assets/investor-update/investor-update.md" ]
}

@test "an unowned path in the drop is reported and not written" {
  make_drop >/dev/null
  echo "not mine" > "$TESTDIR/drop/CHANGELOG.md"

  run "$CDSYNC_BIN" import "$TESTDIR/drop" --target "$TESTDIR/target"
  assert_contains "ignore  CHANGELOG.md"
  [ ! -f "$TESTDIR/target/CHANGELOG.md" ]
}

@test "import refuses a drop with no RETURN.md, before writing anything" {
  make_drop >/dev/null
  rm "$TESTDIR/drop/RETURN.md"

  run "$CDSYNC_BIN" import "$TESTDIR/drop" --target "$TESTDIR/never"
  [ "$status" -ne 0 ]
  assert_contains "no RETURN.md"
  [ ! -d "$TESTDIR/never" ]
}

@test "import refuses something that is not a drop" {
  mkdir -p "$TESTDIR/notadrop"
  echo x > "$TESTDIR/notadrop/thing.txt"
  run "$CDSYNC_BIN" import "$TESTDIR/notadrop" --target "$TESTDIR/target"
  [ "$status" -ne 0 ]
  assert_contains "does not look like a drop"
}

@test "import --dry-run writes nothing" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" import "$TESTDIR/drop" --target "$TESTDIR/target" --dry-run
  [ "$status" -eq 0 ]
  assert_contains "would be written"
  [ ! -d "$TESTDIR/target/assets" ]
}

@test "import of a missing file fails" {
  run "$CDSYNC_BIN" import /no/such/file.zip
  [ "$status" -ne 0 ]
  assert_contains "no such file"
}

@test "import unpacks a real zip and descends the wrapper directory" {
  make_drop >/dev/null
  ( cd "$TESTDIR" && zip -qr fixture.zip drop )
  run "$CDSYNC_BIN" import "$TESTDIR/fixture.zip" --target "$TESTDIR/target"
  [ "$status" -eq 0 ]
  [ -f "$TESTDIR/target/assets/investor-update/spec.md" ]
}

@test "import descends a wrapper nested more than one deep" {
  # Both 2026-08-02 drops held an identical drop root and disagreed about how
  # deeply to wrap it: one arrived as `design-system/`, the other as
  # `design/system/`, because that exporter preserved the path the tree sits at
  # in the receiving repository. Descending exactly once left the second at
  # `design/`, which installs as `design/system/system/` and leaves `check`
  # reporting an empty tree -- a wrong answer that reads as a supplier problem.
  make_drop >/dev/null
  mkdir -p "$TESTDIR/nest/design"
  mv "$TESTDIR/drop" "$TESTDIR/nest/design/system"
  ( cd "$TESTDIR/nest" && zip -qr "$TESTDIR/nested.zip" design )
  run "$CDSYNC_BIN" import "$TESTDIR/nested.zip" --target "$TESTDIR/target"
  [ "$status" -eq 0 ]
  [ -f "$TESTDIR/target/assets/investor-update/spec.md" ]
  [ ! -e "$TESTDIR/target/system" ]
  [ ! -e "$TESTDIR/target/design" ]
}

@test "the wrapper descent stops at drop content rather than entering it" {
  # The floor on the descent. An archive whose only top-level entry is `assets/`
  # is a drop root that happens to have one child, not a wrapper. Terminating on
  # child count alone cannot tell those apart, and would hand back the INSIDE of
  # assets/ -- so every spec lands one level too high and the owned paths vanish.
  # Asserted on stage_drop rather than through `import`, because an archive this
  # shape is not a valid drop and import's preflight rejects it before the
  # descent is reachable. The descent is a staging concern, so it is tested where
  # it lives.
  mkdir -p "$TESTDIR/lone/assets/investor-update"
  echo "spec" > "$TESTDIR/lone/assets/investor-update/spec.md"
  ( cd "$TESTDIR/lone" && zip -qr "$TESTDIR/lone.zip" assets )
  run run_lib "stage_drop '$TESTDIR/lone.zip'"
  [ "$status" -eq 0 ]
  [ -f "$output/assets/investor-update/spec.md" ]
}

@test "staging removes the whole staging tree, not just the drop root" {
  # stage_drop returns the drop root; the staging directory it created may be
  # several wrappers above that. Removing only what was returned stranded the
  # wrappers -- an abandoned temp tree per install.
  make_drop >/dev/null
  mkdir -p "$TESTDIR/nest/design"
  mv "$TESTDIR/drop" "$TESTDIR/nest/design/system"
  ( cd "$TESTDIR/nest" && zip -qr "$TESTDIR/nested.zip" design )
  run run_lib "
    staged=\"\$(stage_drop '$TESTDIR/nested.zip')\"
    stage_cleanup \"\$staged\" '$TESTDIR/nested.zip'
    if [[ -e \"\$staged\" ]]; then echo 'DROP ROOT SURVIVED'; fi
    if [[ -e \"\${staged%/design/system}\" ]]; then echo 'STAGING ROOT SURVIVED'; fi
    echo done
  "
  [ "$status" -eq 0 ]
  [[ "$output" != *"SURVIVED"* ]]
}

@test "import leaves the source directory in place" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" import "$TESTDIR/drop" --target "$TESTDIR/target"
  [ -d "$TESTDIR/drop" ]
  [ -f "$TESTDIR/drop/RETURN.md" ]
}

# ============================================================================
# INSTALL
# ============================================================================
#
# The second install path. `import` merges a CONVERTED drop and leaves the rest
# of the target standing; `install` replaces the target with an AS-IS export,
# which is the whole tree. Opposite semantics, and choosing wrong is the most
# destructive mistake this tool offers -- so the contrast is pinned first.

# An installed target: a git repo, a drop already in place, one repo-authored
# addendum and one gitignored inbox holding the delivery archive.
make_installed_target() {
  local repo="$TESTDIR/repo"
  local target="$repo/design/system"

  mkdir -p "$target/design-system" "$target/venture" "$target/addenda" "$target/_inbox"
  printf 'design/system/_inbox/\n' > "$repo/.gitignore"
  echo "old colour doc"    > "$target/design-system/colour.md"
  echo "venture doc"       > "$target/venture/plan.md"
  echo "repo-authored gap" > "$target/addenda/typed-states.md"
  echo "the delivery zip"  > "$target/_inbox/drop.zip"

  git -C "$repo" init -q .
  git -C "$repo" add -A
  git -C "$repo" commit -qm "installed drop"
  echo "$target"
}

# An as-is export: the whole tree. It carries design-system/ and a new
# prototypes/, and deliberately does NOT carry venture/.
make_as_is_export() {
  local src="$TESTDIR/export"
  mkdir -p "$src/design-system" "$src/prototypes"
  echo "new colour doc" > "$src/design-system/colour.md"
  echo "a prototype"    > "$src/prototypes/index.html"
  echo "# Return"       > "$src/RETURN.md"
  echo "$src"
}

# THE distinction, in one test. Same target, same unmentioned path, opposite
# outcomes -- and both are correct for the artefact each command takes.
@test "import leaves an unmentioned path standing where install removes it" {
  make_drop >/dev/null
  mkdir -p "$TESTDIR/target/leftover"
  echo "an earlier round" > "$TESTDIR/target/leftover/old.md"

  run "$CDSYNC_BIN" import "$TESTDIR/drop" --target "$TESTDIR/target"
  [ "$status" -eq 0 ]
  [ -f "$TESTDIR/target/leftover/old.md" ]

  run "$CDSYNC_BIN" install "$TESTDIR/drop" --target "$TESTDIR/target" --yes
  [ "$status" -eq 0 ]
  [ ! -e "$TESTDIR/target/leftover" ]
}

@test "install is dispatched as its own command" {
  run "$CDSYNC_BIN" install </dev/null
  [ "$status" -eq 2 ]
  assert_contains "usage: cdsync install"
}

@test "install help renders" {
  run "$CDSYNC_BIN" help install
  [ "$status" -eq 0 ]
  assert_contains "install"
}

@test "install dry-run names every removal and writes nothing" {
  local target src
  target="$(make_installed_target)"
  src="$(make_as_is_export)"

  run "$CDSYNC_BIN" install "$src" --target "$target" --dry-run
  [ "$status" -eq 0 ]
  assert_contains "remove   venture"
  assert_contains "replace  design-system"
  assert_contains "add      prototypes"
  # Nothing moved.
  [ "$(cat "$target/design-system/colour.md")" = "old colour doc" ]
  [ -f "$target/venture/plan.md" ]
  [ ! -e "$target/prototypes" ]
}

# The recoverability guard, and the reason there is no backup directory. Git is
# what makes a replace reversible, so content git could not return is the one
# thing this must not run over.
@test "install refuses a target holding changes git could not give back" {
  local target src
  target="$(make_installed_target)"
  src="$(make_as_is_export)"
  echo "hand-written, never committed" > "$target/design-system/NOTES.md"

  run "$CDSYNC_BIN" install "$src" --target "$target" --yes
  [ "$status" -ne 0 ]
  assert_contains "could not give back"
  assert_contains "NOTES.md"
  [ -f "$target/design-system/NOTES.md" ]
  [ "$(cat "$target/design-system/colour.md")" = "old colour doc" ]
}

@test "install --force proceeds over changes git could not give back" {
  local target src
  target="$(make_installed_target)"
  src="$(make_as_is_export)"
  echo "hand-written, never committed" > "$target/design-system/NOTES.md"

  run "$CDSYNC_BIN" install "$src" --target "$target" --yes --force
  [ "$status" -eq 0 ]
  [ "$(cat "$target/design-system/colour.md")" = "new colour doc" ]
}

@test "install preserves a declared protected directory" {
  local target src
  target="$(make_installed_target)"
  src="$(make_as_is_export)"

  run "$CDSYNC_BIN" install "$src" --target "$target" --yes
  [ "$status" -eq 0 ]
  assert_contains "keep     addenda"
  assert_contains "repo-authored"
  [ "$(cat "$target/addenda/typed-states.md")" = "repo-authored gap" ]
}

# Preserved for a DIFFERENT reason from addenda, and the output says which.
# `_inbox/` is not precious; it is unrecoverable, because it is excluded on a
# platform limit and git therefore never held it.
@test "install preserves a gitignored directory, and says why" {
  local target src
  target="$(make_installed_target)"
  src="$(make_as_is_export)"

  run "$CDSYNC_BIN" install "$src" --target "$target" --yes
  [ "$status" -eq 0 ]
  assert_contains "keep     _inbox"
  assert_contains "nothing else could restore it"
  [ "$(cat "$target/_inbox/drop.zip")" = "the delivery zip" ]
}

@test "install replaces what the drop carries and removes what it does not" {
  local target src
  target="$(make_installed_target)"
  src="$(make_as_is_export)"

  run "$CDSYNC_BIN" install "$src" --target "$target" --yes
  [ "$status" -eq 0 ]
  [ "$(cat "$target/design-system/colour.md")" = "new colour doc" ]
  [ -f "$target/prototypes/index.html" ]
  [ -f "$target/RETURN.md" ]
  [ ! -e "$target/venture" ]
}

# Installing nothing over a tree would delete the tree and deliver nothing. It
# is the same shape as `0 assets checked -- clean`: an empty input that every
# check downstream finds nothing to object to.
@test "install refuses a source holding nothing" {
  local target
  target="$(make_installed_target)"
  mkdir -p "$TESTDIR/hollow"

  run "$CDSYNC_BIN" install "$TESTDIR/hollow" --target "$target" --yes
  [ "$status" -ne 0 ]
  assert_contains "nothing to install"
  [ -f "$target/design-system/colour.md" ]
}

# `</dev/null` IS THE TEST, not decoration. install prompts when stdin is a tty
# and refuses when it is not, so without an explicit stdin this test asserts
# whatever the ambient environment happens to be. Non-interactively -- CI, and
# every agent-run shell -- it passed. Run from a real terminal it reached
# `Type "replace" to proceed:` and HUNG the whole suite at test 183 of 313.
#
# A test whose result depends on how the suite was launched is not a test. The
# same shape as the two the CI matrix caught: behaviour that is correct in one
# environment and silently different in another.
@test "install refuses to replace a tree without confirmation" {
  local target src
  target="$(make_installed_target)"
  src="$(make_as_is_export)"

  run "$CDSYNC_BIN" install "$src" --target "$target" </dev/null
  [ "$status" -ne 0 ]
  assert_contains "without confirmation"
  [ "$(cat "$target/design-system/colour.md")" = "old colour doc" ]
}

@test "install pre-flights the archive before writing" {
  local target
  target="$(make_installed_target)"
  mkdir -p "$TESTDIR/hostile/design-system"
  echo "content" > "$TESTDIR/hostile/design-system/colour.md"
  ln -s /etc/passwd "$TESTDIR/hostile/link.txt"
  ( cd "$TESTDIR/hostile" && zip -qry "$TESTDIR/hostile.zip" . )

  run "$CDSYNC_BIN" install "$TESTDIR/hostile.zip" --target "$target" --yes
  [ "$status" -ne 0 ]
  assert_contains "symlink"
  [ "$(cat "$target/design-system/colour.md")" = "old colour doc" ]
}

# Outside a repository there is no undo, so it says so rather than pretending
# the guard above applied.
@test "install warns when the target is not in a git repository" {
  local src
  src="$(make_as_is_export)"
  mkdir -p "$TESTDIR/loose"
  echo "standing" > "$TESTDIR/loose/existing.md"

  run "$CDSYNC_BIN" install "$src" --target "$TESTDIR/loose" --yes
  [ "$status" -eq 0 ]
  assert_contains "not inside a git repository"
}

# ============================================================================
# BRIEF
# ============================================================================

@test "brief refuses without a cdsync.json" {
  run "$CDSYNC_BIN" brief
  [ "$status" -eq 2 ]
  assert_contains "no cdsync.json"
}

@test "brief refuses an order with no specified assets" {
  echo '{"venture":"acme","order":{"assets":[]}}' > "$TESTDIR/design/cdsync.json"
  run "$CDSYNC_BIN" brief
  [ "$status" -eq 2 ]
  assert_contains "orders nothing"
}

@test "an ordered-ahead slug gets the contract section, not an invented spec" {
  # The refusal this test used to pin is gone (hv, 9 Aug 2026): an in-taxonomy
  # slug orders ahead of the library. What must still never happen is the
  # document inventing a specification section for it.
  echo '{"venture":"acme","order":{"assets":["roadmap"]}}' > "$TESTDIR/design/cdsync.json"
  run "$CDSYNC_BIN" brief
  [ "$status" -eq 0 ]
  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains "## Ordered ahead of the library"
  refute_contains '### `roadmap`'
}

@test "brief writes to the target and inlines the full specification" {
  echo '{"venture":"acme","order":{"assets":["investor-update"]}}' > "$TESTDIR/design/cdsync.json"
  run "$CDSYNC_BIN" brief
  [ "$status" -eq 0 ]
  [ -f "$TESTDIR/design/brief.md" ]

  # Self-contained: the definition of done travels in the brief, not as a link.
  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains "Definition of done"
  assert_contains "The fixed shape is the entire value"
  assert_contains "RETURN.md -- mandatory"
  assert_contains "The gaps"
}

@test "brief stamps the library versions rather than reading them from the venture" {
  echo '{"venture":"acme","spec_library_version":99,"order":{"assets":["investor-update"]}}' \
    > "$TESTDIR/design/cdsync.json"
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run run_lib "fm_get '$TESTDIR/design/brief.md' spec_library_version"
  [ "$output" = "$(run_lib 'library_get spec_library_version')" ]
}

@test "brief carries the fixed and open lists" {
  cat > "$TESTDIR/design/cdsync.json" <<'EOF'
{ "venture": "acme",
  "fixed": ["the company name is Acme"],
  "open": ["everything visual"],
  "order": { "assets": ["investor-update"] } }
EOF
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains "the company name is Acme"
  assert_contains "everything visual"
}

@test "brief warns in the document when nothing is declared fixed" {
  echo '{"venture":"acme","order":{"assets":["investor-update"]}}' > "$TESTDIR/design/cdsync.json"
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains "licence to invent everything"
}

@test "brief expands a bundle to its members" {
  echo '{"venture":"acme","order":{"bundles":["operating-set"]}}' > "$TESTDIR/design/cdsync.json"
  run "$CDSYNC_BIN" brief
  [ "$status" -eq 0 ]
  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains '`investor-update`'
}

@test "brief orders what a partial bundle has and declares the rest absent" {
  # operating-set holds four unspecified slugs against one specified. A bundle
  # names a group and its membership is the library's business, so refusing the
  # order would punish the venture for the library being incomplete -- but a
  # partial set is a different ask from a whole one, so the absence is stated.
  echo '{"venture":"acme","order":{"bundles":["operating-set"]}}' > "$TESTDIR/design/cdsync.json"
  run "$CDSYNC_BIN" brief
  [ "$status" -eq 0 ]
  assert_contains "bundle members omitted"

  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains "Not in this drop, and asked for"
  assert_contains "Treat the set above as partial"
  assert_contains '| `hiring-plan` | `operating-set` |'
}

@test "brief does not inline a specification for an omitted asset" {
  # The omission has to be a statement about an absence, not a heading with
  # nothing under it -- an asset that appears in Specifications reads as ordered.
  echo '{"venture":"acme","order":{"bundles":["operating-set"]}}' > "$TESTDIR/design/cdsync.json"
  "$CDSYNC_BIN" brief >/dev/null 2>&1

  run bash -c "grep '^### ' '$TESTDIR/design/brief.md'"
  assert_contains "investor-update"
  # `ways-of-working` was the second absent slug here until 31 July 2026, when it
  # gained a library entry. It is inlined now and that is the rule working:
  # an unspecified slug is declared absent when a BUNDLE reaches it, and the
  # moment it is specified it stops being absent. hiring-plan and decision-log
  # carry the case.
  assert_contains "ways-of-working"
  refute_contains "hiring-plan"
  refute_contains "decision-log"
}

@test "a slug a bundle omits is ordered ahead when named directly" {
  # Same slug, named rather than reached through a bundle. The taxonomy holds
  # it, so naming it is an order the library has not caught up with -- ordered
  # ahead, not refused (hv, 9 Aug 2026).
  mkdir -p "$TESTDIR/design"
  echo '{"venture":"acme","order":{"assets":["hiring-plan"]}}' > "$TESTDIR/design/cdsync.json"
  run "$CDSYNC_BIN" brief
  [ "$status" -eq 0 ]
  assert_contains "ahead of the library"
  [ -f "$TESTDIR/design/brief.md" ]
}

@test "a named in-taxonomy slug with no spec is ordered ahead of the library" {
  # The old refusal existed only because the brief could not say what a new
  # asset stamps. `unassigned` says it, so the order proceeds and the document
  # carries the contract its specification cannot.
  mkdir -p "$TESTDIR/design"
  echo '{"venture":"acme","order":{"assets":["roadmap"]}}' > "$TESTDIR/design/cdsync.json"
  run "$CDSYNC_BIN" brief
  [ "$status" -eq 0 ]
  assert_contains "1 ahead of the library, stamped unassigned"

  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains "## Ordered ahead of the library"
  assert_contains '`roadmap`'
  assert_contains "spec_version: unassigned"
}

@test "brief still refuses a named slug outside the taxonomy" {
  # The taxonomy is the identity space. A type it does not name is added to
  # the library first, never invented by an order.
  mkdir -p "$TESTDIR/design"
  echo '{"venture":"acme","order":{"assets":["flux-capacitor"]}}' > "$TESTDIR/design/cdsync.json"
  run "$CDSYNC_BIN" brief
  [ "$status" -eq 2 ]
  assert_contains "ordered by name but not in the taxonomy"
  [ ! -f "$TESTDIR/design/brief.md" ]
}

@test "a named unspecified slug is ordered even when a bundle also holds it" {
  # Named wins over bundle attribution, so the slug is ordered ahead rather
  # than quietly omitted with the bundle's other absentees.
  mkdir -p "$TESTDIR/design"
  echo '{"venture":"acme","order":{"bundles":["operating-set"],"assets":["hiring-plan"]}}' \
    > "$TESTDIR/design/cdsync.json"
  run "$CDSYNC_BIN" brief
  [ "$status" -eq 0 ]
  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains "## Ordered ahead of the library"
  assert_contains '`hiring-plan`'
}

@test "brief states hard_facts and bundle membership for a specified asset" {
  # The contract asks both fields back and the inlined body cannot carry them --
  # front matter is stripped when a spec is rendered -- so sixteen assets once
  # came back `[]` on the round that first asked, and that was the document's
  # fault rather than the supplier's.
  echo '{"venture":"acme","order":{"assets":["brand-guidelines","investor-update"]}}' \
    > "$TESTDIR/design/cdsync.json"
  run "$CDSYNC_BIN" brief
  [ "$status" -eq 0 ]
  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains "Facts that must be decided first:** mark-exists"
  assert_contains "Bundles that place this asset:"
}

@test "the refusal states the taxonomy's real size rather than a remembered one" {
  # The size was hand-written in four places and disagreed THREE ways: fifty-one
  # in lib/specs.sh and in this very refusal, fifty-two in two help files, fifty
  # in a test comment. The one users read was among the wrong ones.
  #
  # DERIVED BY A DIFFERENT PROBE THAN THE ONE UNDER TEST, deliberately. Asking
  # taxonomy_count for the expected value and then asserting the message matches
  # it passes for ANY value the function returns -- proved by mutation: replacing
  # its body with `echo 99` left all of these green. That is the second mutation
  # failure mode on the board, where the mutation lands perfectly and the test
  # asserts at a layer the bug cannot reach. Counting the manifest directly here
  # is what makes this able to fail.
  local expected
  expected="$(grep -E '^\|[[:space:]]*[0-9]+[[:space:]]*\|' "$CDSYNC_HOME/specs/library.md" \
    | grep -oE '`[a-z0-9-]+`' | sort -u | grep -c . || true)"
  [ "$expected" -gt 0 ]

  mkdir -p "$TESTDIR/design"
  echo '{"venture":"acme","order":{"assets":["flux-capacitor"]}}' > "$TESTDIR/design/cdsync.json"
  run "$CDSYNC_BIN" brief
  [ "$status" -eq 2 ]
  assert_contains "The taxonomy names $expected asset types"
}

@test "doctor and brief report the same taxonomy size" {
  # Two callers, one function. They disagreed before it existed, and the only
  # way that recurs is someone counting inline again. Independent derivation as
  # above, for the same reason.
  local expected
  expected="$(grep -E '^\|[[:space:]]*[0-9]+[[:space:]]*\|' "$CDSYNC_HOME/specs/library.md" \
    | grep -oE '`[a-z0-9-]+`' | sort -u | grep -c . || true)"

  run "$CDSYNC_BIN" doctor
  assert_contains "$expected taxonomy slugs"
}

@test "the help files that carried a stale taxonomy count state no count at all" {
  # Scoped to the two that were wrong, deliberately. The same pattern run over
  # all of bin/lib/help matches a dozen legitimate sentences -- "ten assets",
  # "eight asset types", "0 assets checked" -- so a repo-wide version of this
  # guard would be a false-positive machine and would be switched off within a
  # month. Narrow and precise beats broad and ignored.
  run bash -c "grep -niE '([0-9]+|one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|(twenty|thirty|forty|fifty|sixty|seventy|eighty|ninety)(-(one|two|three|four|five|six|seven|eight|nine))?)[[:space:]]+(assets|asset types|taxonomy slugs|slugs|types)' '$CDSYNC_HOME/help/brief.md' '$CDSYNC_HOME/help/cdsync.md' || true"
  [ -z "$output" ]
}

@test "the shipped library states no taxonomy-wide count either" {
  # THE SWEEP THAT BUILT THE GUARD ABOVE SEARCHED bin/, lib/ and help/, AND
  # NOTHING ASKED WHAT HAD CHOSEN THOSE THREE. specs/ was never searched, and it
  # was the copy that mattered most: specs/kit.md is inlined into EVERY brief,
  # so its wrong figure went to the supplier every round for six weeks while the
  # guard above reported the number settled. A positive control validates the
  # instrument, not the sampling frame -- this test is the frame widened.
  #
  # NARROWER THAN THE GUARD ABOVE, and deliberately. specs/library.md carries
  # two legitimate subset counts -- "founding-set is four slugs" and "Eight
  # assets are genuinely both design and venture" -- which the broad pattern
  # matches. What was ever wrong here is a count of the taxonomy AS A WHOLE, so
  # that is what this rejects: a number modifying `artefacts`, an `N of the M`
  # claim, and the spelled-out fifty-family figures that disagreed four ways.
  #
  # templates/claude_design/ is OUT OF SCOPE ON PURPOSE. templprj is a delivered
  # drop stamped spec_library_version 2, and a drop keeps the edition it was
  # ordered against; its "fifty-one" is a record, not a claim. Its README says so.
  run bash -c "grep -rniE '(^|[^a-z-])(fifty|fifty-(one|two|three|four))([^a-z-]|\$)|([0-9]+|one|two|three|four|five|six|seven|eight|nine|ten|twenty|thirty|forty|fifty)[[:space:]]+(artefacts|artifacts|asset types|taxonomy slugs)|[0-9]+ of the [0-9]+' '$CDSYNC_HOME/specs' '$CDSYNC_HOME/templates/venture' || true"
  [ -z "$output" ]
}

@test "every dependency the spec library names is a slug the taxonomy holds" {
  # THE LIBRARY HAD NO GUARD OF ITS OWN. rule 2 catches a dangling depends_on in
  # a DROP, so three of them sat in the library itself from July until 9 Aug --
  # `pitch-deck` naming `positioning` twice and `positioning-icp-personas`
  # naming `pricing` -- and went out inside every brief that carried those
  # specs. The library recorded them as known-and-deliberate, which is why
  # nothing chased them: a finding parked for a round that the wind-back then
  # cancelled. Repaired at edition 4; this is what stops the fourth.
  #
  # hard_facts IS EXCLUDED, matching rule_dependencies. Those are venture facts
  # -- `round-size`, `mark-exists`, `target-stack` -- not slugs. The first
  # version of this probe flattened all three fields together and reported
  # essentially the whole library as dangling, which is the instrument lying in
  # the reassuring-looking direction of "lots found, must be working".
  run run_lib '
    for spec in "$CDSYNC_HOME"/specs/*.md; do
      slug="$(basename "$spec" .md)"
      if [ "$slug" = "library" ]; then continue; fi
      for field in depends_on.hard_assets depends_on.reciprocal; do
        while IFS= read -r dep; do
          if [ -z "$dep" ]; then continue; fi
          taxonomy_has "$dep" || echo "DANGLING $slug ${field#depends_on.} -> $dep"
        done < <(fm_list "$spec" "$field")
      done
    done
  '
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "brief refuses when nothing the order reached is specified" {
  # No shipped bundle is entirely unspecified, so the library is stood in for
  # here. This is the guard against composing a brief with no specifications in
  # it, which would be a document with nothing to hold a drop against.
  mkdir -p "$TESTDIR/fakehome/specs"
  # Only specs/ is stood in for -- lib/ is the real one, so this exercises the
  # shipped code against a doctored library rather than a mock of the tool.
  ln -s "$CDSYNC_HOME/lib" "$TESTDIR/fakehome/lib"
  awk '/^bundles:/ {
    print
    print "  ghost-set: [venture-thesis, problem-and-opportunity]"
    next
  } { print }' "$CDSYNC_HOME/specs/library.md" > "$TESTDIR/fakehome/specs/library.md"
  # Every brief carries the kit, so the library needs one or the earlier
  # broken-installation guard fires instead of the path under test.
  cp "$CDSYNC_HOME/specs/kit.md" "$TESTDIR/fakehome/specs/kit.md"

  echo '{"venture":"acme","order":{"bundles":["ghost-set"]}}' > "$TESTDIR/design/cdsync.json"
  run env CDSYNC_HOME="$TESTDIR/fakehome" "$CDSYNC_BIN" brief
  [ "$status" -eq 2 ]
  assert_contains "nothing this order reached has a specification"
  [ ! -f "$TESTDIR/design/brief.md" ]
}

@test "brief carries the kit in full even when the kit was not ordered" {
  # The brief promised nothing in it points at a file the reader cannot open,
  # then required kit/kit.md and inlined it only if `kit` happened to be ordered.
  # An instance holding just the brief would have invented a kit -- the one
  # artefact that exists to stop invention.
  echo '{"venture":"acme","order":{"assets":["investor-update"]}}' > "$TESTDIR/design/cdsync.json"
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains "## The kit"
  assert_contains "The neutral kit"
  # A distinctive line from the kit spec body, so this proves the body is inlined
  # rather than merely referenced.
  assert_contains "twelve-step greyscale ramp"
}

@test "brief tells a first round to build the kit" {
  echo '{"venture":"acme","order":{"assets":["investor-update"]}}' > "$TESTDIR/design/cdsync.json"
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains "target has no kit yet, so this round builds it"
}

@test "brief carries the real token values once the target has a kit" {
  # Round two onwards. Without this the reader has no way to restate values it
  # cannot see, so it would reinvent the palette every round.
  echo '{"venture":"acme","order":{"assets":["investor-update"]}}' > "$TESTDIR/design/cdsync.json"
  mkdir -p "$TESTDIR/design/kit"
  echo '{"colour":{"grey-900":"#111111"}}' > "$TESTDIR/design/kit/tokens.json"
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains "target already has a kit"
  assert_contains "grey-900"
  assert_contains "#111111"
  refute_contains "no kit yet"
}

@test "brief carries the written kit, not only its specification" {
  # The specs point at kit/kit.md for the illustrative marker and the
  # blank-counting scope. Carrying only the library spec left the reader to define
  # both again, differently -- and check would then measure against a rule the drop
  # no longer follows.
  echo '{"venture":"acme","order":{"assets":["investor-update"]}}' > "$TESTDIR/design/cdsync.json"
  mkdir -p "$TESTDIR/design/kit"
  cat > "$TESTDIR/design/kit/kit.md" <<'EOF'
---
kit_version: 1
---
# The kit

## Marking an illustrative number

Suffix it with a dagger and footnote the table.
EOF
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains "The kit as written"
  assert_contains "Suffix it with a dagger"
  assert_contains "target already has a kit"
}

@test "a first round carries the kit specification and no written kit section" {
  echo '{"venture":"acme","order":{"assets":["investor-update"]}}' > "$TESTDIR/design/cdsync.json"
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains "no kit yet, so this round builds it"
  refute_contains "The kit as written"
  refute_contains "The token values"
}

@test "the kit is inlined once, not twice, when it is also ordered" {
  echo '{"venture":"acme","order":{"assets":["kit","investor-update"]}}' > "$TESTDIR/design/cdsync.json"
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run bash -c "grep -c 'The neutral kit -- specification' '$TESTDIR/design/brief.md' || true"
  [ "$output" -le 1 ]
  run bash -c "grep -c '^### .kit.' '$TESTDIR/design/brief.md'"
  [ "$output" = "1" ]
}

@test "brief declares a hard dependency the order does not satisfy" {
  # pitch-deck declares it needs a colour system, typography system and logo
  # suite first. None was ordered and none is in the target, and the brief used
  # to render that as a line of prose and proceed.
  echo '{"venture":"acme","order":{"assets":["pitch-deck"]}}' > "$TESTDIR/design/cdsync.json"
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains "Prerequisites this order does not meet"
  assert_contains "colour-system"
  assert_contains "This is declared, not refused"
}

@test "a bad dependency slug is declared as outside the taxonomy" {
  # A dependency naming a slug the taxonomy does not hold must read as exactly
  # that, and never as a real asset somebody forgot to order.
  #
  # THIS TEST USED THE SHIPPED LIBRARY'S OWN DEFECT AS ITS FIXTURE. pitch-deck
  # really did name `positioning`, so the assertion passed on live data -- and
  # could only pass for as long as the library stayed broken. Repairing the
  # library at edition 4 turned it red, which is the test reporting the fixture
  # it was silently depending on rather than the behaviour it is named for.
  # Same family as asking the code under test for its own expected value: green
  # for a reason nobody chose.
  #
  # The behaviour is pinned against a doctored library now, so it survives the
  # data being correct.
  mkdir -p "$TESTDIR/fakehome/specs"
  ln -s "$CDSYNC_HOME/lib" "$TESTDIR/fakehome/lib"
  cp "$CDSYNC_HOME/specs/library.md" "$TESTDIR/fakehome/specs/library.md"
  # Every brief carries the kit, so the library needs one or the
  # broken-installation guard fires instead of the path under test.
  cp "$CDSYNC_HOME/specs/kit.md" "$TESTDIR/fakehome/specs/kit.md"
  sed 's/^  hard_assets: \[positioning-icp-personas,/  hard_assets: [positioning,/' \
    "$CDSYNC_HOME/specs/pitch-deck.md" > "$TESTDIR/fakehome/specs/pitch-deck.md"
  # The doctoring must have landed, or this asserts nothing: a sed that quietly
  # matched nothing would leave a correct spec and a green test.
  grep -q 'hard_assets: \[positioning,' "$TESTDIR/fakehome/specs/pitch-deck.md"

  echo '{"venture":"acme","order":{"assets":["pitch-deck"]}}' > "$TESTDIR/design/cdsync.json"
  env CDSYNC_HOME="$TESTDIR/fakehome" "$CDSYNC_BIN" brief >/dev/null 2>&1
  run bash -c "grep 'positioning.*not in the taxonomy' '$TESTDIR/design/brief.md'"
  [ "$status" -eq 0 ]
}

@test "a repackaging round can be expressed at all" {
  # The gap: every brief said "build these", in that voice, with no way to say
  # anything else. The round's purpose is declared rather than measured, because
  # repackage, revise, extend and correct are four different jobs with one
  # filesystem signature.
  echo '{"venture":"acme","round_job":"Repackage the existing deck for a partner audience. Do not redesign it.","order":{"assets":["investor-update"]}}' \
    > "$TESTDIR/design/cdsync.json"
  run "$CDSYNC_BIN" brief
  [ "$status" -eq 0 ]

  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains "What this round is for"
  assert_contains "Repackage the existing deck for a partner audience"
  # Also in the header, so a machine reading the front matter sees it too.
  assert_contains "round_job:"
}

@test "the brief states which ordered assets are already in the target" {
  # Measured, not declared, and worth saying in every round. A supplier ordered
  # a slug that already exists and not told will rebuild it, and the rebuild
  # discards whatever the existing one carried -- silently, on both sides.
  echo '{"venture":"acme","order":{"assets":["investor-update"]}}' > "$TESTDIR/design/cdsync.json"
  mkdir -p "$TESTDIR/design/assets/investor-update"
  run "$CDSYNC_BIN" brief
  [ "$status" -eq 0 ]

  run bash -c "sed -n '/What this round is for/,/The order/p' '$TESTDIR/design/brief.md'"
  assert_contains "Already in the target, and ordered again"
  assert_contains "investor-update"
  assert_contains "Work from them rather than starting again"
}

@test "an ordered asset absent from the target is not claimed to be present" {
  # The negative half. Without this, a section that always says "already in the
  # target" would pass the test above while being wrong every time.
  echo '{"venture":"acme","round_job":"Build the first set.","order":{"assets":["investor-update"]}}' \
    > "$TESTDIR/design/cdsync.json"
  run "$CDSYNC_BIN" brief
  [ "$status" -eq 0 ]

  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains "Nothing you have been ordered is in the target yet"
  refute_contains "Already in the target, and ordered again"
}

@test "the round-job section is absent entirely when there is nothing to say" {
  # No job declared and nothing already present. An empty section headed "What
  # this round is for" would train its reader to skim the part of the document
  # that matters most, which is the same reason brief_field omits empty keys.
  echo '{"venture":"acme","order":{"assets":["investor-update"]}}' > "$TESTDIR/design/cdsync.json"
  run "$CDSYNC_BIN" brief
  [ "$status" -eq 0 ]

  run bash -c "cat '$TESTDIR/design/brief.md'"
  refute_contains "What this round is for"
  refute_contains "round_job:"
}

@test "a dependency already in the target is not declared unmet" {
  echo '{"venture":"acme","order":{"assets":["pitch-deck"]}}' > "$TESTDIR/design/cdsync.json"
  mkdir -p "$TESTDIR/design/assets/colour-system"
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run bash -c "sed -n '/Prerequisites this order/,/declared, not refused/p' '$TESTDIR/design/brief.md'"
  refute_contains "colour-system"
  assert_contains "logo-suite"
}

@test "a dependency satisfied by this same order is not declared unmet" {
  run run_lib "fm_list '$CDSYNC_HOME/specs/component-library.md' depends_on.hard_assets"
  assert_contains "kit"

  echo '{"venture":"acme","order":{"assets":["component-library","kit"]}}' > "$TESTDIR/design/cdsync.json"
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run bash -c "sed -n '/Prerequisites this order/,/declared, not refused/p' '$TESTDIR/design/brief.md'"
  refute_contains '`kit`'
}

@test "brief states the spec.md front-matter contract" {
  # The specs below it render their fields as a table, because that is how a
  # document reads -- and the front matter is stripped to do it. A reader shown
  # only that reproduced the table and put status in index.md, leaving check
  # unable to read status, spec_version or coverage on any asset in the drop.
  echo '{"venture":"acme","order":{"assets":["investor-update"]}}' > "$TESTDIR/design/cdsync.json"
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains "the one file with a required format"
  assert_contains "must open with a YAML front-matter"
  assert_contains "Do not copy that shape back"
  assert_contains "status: <spec-only|draft|partial|complete>"
}

@test "brief tells the supplier that formats are advisory" {
  # Two suppliers independently read `formats_required` as part of the
  # definition of done and held otherwise-finished assets back for a rendering
  # nobody was blocking on. hv ruled it advisory on 9 Aug 2026 -- and a ruling
  # that never reaches the supplier changes nothing, which is the whole shape of
  # the failure: the header states the field and the document never stated its
  # meaning. Fourth time in this project that a field was explained without its
  # value, and the expensive misreading is one-directional.
  echo '{"venture":"acme","formats_required":["pdf"],"order":{"assets":["investor-update"]}}' \
    > "$TESTDIR/design/cdsync.json"
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run bash -c "cat '$TESTDIR/design/brief.md'"
  # The header must still carry what was asked for -- advisory is not ignored.
  assert_contains "formats_required: [pdf]"
  assert_contains "in the header above is advisory"
  assert_contains "not part of the"
  assert_contains "missing PDF does not hold it open"
}

@test "brief forbids declaring the counts the tool computes" {
  echo '{"venture":"acme","order":{"assets":["investor-update"]}}' > "$TESTDIR/design/cdsync.json"
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains 'Do not declare `blanks`'
  assert_contains "not where state lives"
}

@test "brief carries the ruling that a fixed colour belongs in the kit" {
  echo '{"venture":"acme","order":{"assets":["investor-update"]}}' > "$TESTDIR/design/cdsync.json"
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run bash -c "cat '$TESTDIR/design/brief.md'"
  assert_contains "neutral ramp is a default, not a constraint"
  assert_contains "the kit carries that colour"
}

@test "brief no longer asks for itself to be echoed back" {
  # The structure listed brief.md as part of the drop, eleven lines above saying
  # brief.md is not one of the paths a drop owns -- so import discarded it. A
  # second copy of the order is a copy that can disagree with the first.
  echo '{"venture":"acme","order":{"assets":["investor-update"]}}' > "$TESTDIR/design/cdsync.json"
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run bash -c "cat '$TESTDIR/design/brief.md'"
  refute_contains "this document, echoed back"
  assert_contains "Do not echo this brief back"
}

@test "brief says nothing about omissions when the order is whole" {
  echo '{"venture":"acme","order":{"assets":["investor-update"]}}' > "$TESTDIR/design/cdsync.json"
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run bash -c "cat '$TESTDIR/design/brief.md'"
  refute_contains "Not in this drop"
}

@test "brief --stdout emits the document as well as writing it" {
  echo '{"venture":"acme","order":{"assets":["investor-update"]}}' > "$TESTDIR/design/cdsync.json"
  run "$CDSYNC_BIN" brief --stdout
  [ "$status" -eq 0 ]
  assert_contains "# Brief -- acme, round 1"
  [ -f "$TESTDIR/design/brief.md" ]
}

@test "brief output is valid front matter" {
  echo '{"venture":"acme","order":{"assets":["investor-update"]}}' > "$TESTDIR/design/cdsync.json"
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run run_lib "fm_get '$TESTDIR/design/brief.md' venture"
  [ "$output" = "acme" ]
}

# ----------------------------------------------------------------------------
# NUMBERING
# ----------------------------------------------------------------------------
#
# Claude Design allocated ids from an assumption because no brief had ever said
# what was taken, and repairing the collision cost a full export cycle. Three
# briefs hand-patched a table, which means the next brief written without one
# reintroduces the bug.

brief_lib() {
  run_lib "source \"\$CDSYNC_HOME/lib/cmd_brief.sh\"; $*"
}

ADR_PATTERN='[^A-Za-z0-9][Aa][Dd][Rr]-?[0-9]{3,4}'
ST_PATTERN='[^A-Za-z0-9][Ss][Tt]-?[0-9]{3,4}'

@test "brief carries a numbering section" {
  echo '{"venture":"acme","order":{"assets":["investor-update"]}}' > "$TESTDIR/design/cdsync.json"
  run "$CDSYNC_BIN" brief --stdout
  [ "$status" -eq 0 ]
  assert_contains "Numbering, so you never have to infer it"
  assert_contains "High-water"
}

# THE regression pin. The first version of this scan matched only `ADR-[0-9]+`
# and reported Baize -- 33 ADR files -- as having none, confidently, in a table
# headed "so you never have to infer it". Two real projects, two conventions:
# Lamplight writes `ADR-0003 Title.md`, Baize writes `adr0001-title.md`.
@test "the numbering scan finds both ADR naming conventions" {
  mkdir -p "$TESTDIR/proj/upper" "$TESTDIR/proj/lower"
  touch "$TESTDIR/proj/upper/ADR-0003 Pure-Functional Game Engine.md"
  touch "$TESTDIR/proj/upper/ADR-0020 Something.md"
  touch "$TESTDIR/proj/lower/adr0031-requirements-approach.md"

  run brief_lib "brief_series_row ADR '$ADR_PATTERN' '$TESTDIR/proj'"
  [ "$status" -eq 0 ]
  assert_contains '`0031`'
  assert_contains '**`0032`**'
}

# The scan cannot tell "no ADRs here" from "ADRs somewhere I did not look", and
# it has already been wrong about exactly that. Stating a confident 0001 off an
# unproven miss is how the original collision happened.
@test "a series with nothing found refuses to invent a starting number" {
  mkdir -p "$TESTDIR/empty"

  run brief_lib "brief_series_row ADR '$ADR_PATTERN' '$TESTDIR/empty'"
  [ "$status" -eq 0 ]
  assert_contains "none found"
  assert_contains "ask before allocating"
  refute_contains "0001"
}

@test "the numbering scan does not read test0001 as a steel thread" {
  mkdir -p "$TESTDIR/proj/test0001" "$TESTDIR/proj/ST0042"

  run brief_lib "brief_series_row 'Steel thread' '$ST_PATTERN' '$TESTDIR/proj'"
  [ "$status" -eq 0 ]
  assert_contains '`0042`'
  refute_contains '`0001`'
}

# The real high-water has been inside a DROP rather than the repository:
# Lamplight's own series ended at ADR-0007 while the drop held ADR-0008 through
# ADR-0020. Scanning only the project would have handed back a number already
# used.
@test "the numbering scan reads the drop as well as the project" {
  mkdir -p "$TESTDIR/proj/docs/adr" "$TESTDIR/drop/handoff/adr"
  touch "$TESTDIR/proj/docs/adr/adr0007-last-of-ours.md"
  touch "$TESTDIR/drop/handoff/adr/ADR-0020 Assigned by the supplier.md"

  run brief_lib "brief_series_row ADR '$ADR_PATTERN' '$TESTDIR/proj' '$TESTDIR/drop'"
  [ "$status" -eq 0 ]
  assert_contains '`0020`'
  assert_contains '**`0021`**'
}

# ============================================================================
# NEW
# ============================================================================

# ============================================================================
# INIT -- a design system inside a repository that already exists
# ============================================================================

# The four ported projects hold the tree and nothing else -- no cdsync.json, no
# agent contract, no nested repository. That is the canon rule about Cdsync
# protocol material, and it is the entire reason this command is not `new`.
@test "init creates the skeleton in an existing repository" {
  mkdir -p "$TESTDIR/site" && git -C "$TESTDIR/site" init -q .
  run "$CDSYNC_BIN" init --target "$TESTDIR/site/design/system"
  [ "$status" -eq 0 ]
  local d
  for d in assets kit notes; do
    [ -d "$TESTDIR/site/design/system/$d" ] || {
      echo "missing $d/" >&2
      return 1
    }
    [ -f "$TESTDIR/site/design/system/$d/.gitkeep" ] || {
      echo "missing $d/.gitkeep" >&2
      return 1
    }
  done
}

# The guard lives OUTSIDE the target because `install` replaces the target
# wholesale. Inside, it would not survive the first delivery it exists to
# protect against -- and what it stops being committed is a 600MB archive.
@test "init writes the repo-owned inbox gitignore beside the target" {
  mkdir -p "$TESTDIR/site" && git -C "$TESTDIR/site" init -q .
  run "$CDSYNC_BIN" init --target "$TESTDIR/site/design/system"
  [ "$status" -eq 0 ]
  [ -f "$TESTDIR/site/design/.gitignore" ]
  # Anchored. Unanchored, `_inbox/` matches at any depth below the parent.
  run grep -qxF "/system/_inbox/" "$TESTDIR/site/design/.gitignore"
  [ "$status" -eq 0 ]
  # And NOT inside the target, where an install would take it away.
  [ ! -f "$TESTDIR/site/design/system/.gitignore" ]
}

# The parent may be the project root, holding everything else the project
# ignores. Truncating it would be a destructive write outside the target, from
# a command whose whole job is to create three empty directories.
@test "init never truncates an existing gitignore" {
  mkdir -p "$TESTDIR/site/design" && git -C "$TESTDIR/site" init -q .
  printf '# the project already ignored these\n_build/\n*.beam\n' \
    > "$TESTDIR/site/design/.gitignore"
  run "$CDSYNC_BIN" init --target "$TESTDIR/site/design/system"
  [ "$status" -eq 0 ]
  run cat "$TESTDIR/site/design/.gitignore"
  assert_contains "_build/"
  assert_contains "*.beam"
  assert_contains "/system/_inbox/"
}

@test "init does not add the inbox rule twice" {
  mkdir -p "$TESTDIR/site/design" && git -C "$TESTDIR/site" init -q .
  printf '/system/_inbox/\n' > "$TESTDIR/site/design/.gitignore"
  "$CDSYNC_BIN" init --target "$TESTDIR/site/design/system" >/dev/null 2>&1
  run bash -c "grep -cxF '/system/_inbox/' '$TESTDIR/site/design/.gitignore'"
  [ "$output" -eq 1 ]
}

@test "init writes the cdsync.json stub and none of the agent scaffolding" {
  mkdir -p "$TESTDIR/site" && git -C "$TESTDIR/site" init -q .
  "$CDSYNC_BIN" init --target "$TESTDIR/site/design/system" >/dev/null 2>&1

  # The venture's facts live at the tree root -- one home for `new` ventures
  # and `init` projects alike (hv, 9 Aug 2026). This is what makes `brief`
  # runnable for a project Cdsync does not own.
  [ -f "$TESTDIR/site/design/system/cdsync.json" ]
  run bash -c "jq -r .venture '$TESTDIR/site/design/system/cdsync.json'"
  [ "$output" = "site" ]

  # The agent contract still never lands in an existing project.
  local f
  for f in AGENTS.md CLAUDE.md README.md; do
    [ ! -f "$TESTDIR/site/design/system/$f" ] || {
      echo "init wrote $f, which the canon forbids inside a project" >&2
      return 1
    }
  done
  # A second repository nested inside the first is what `new` would have done.
  [ ! -d "$TESTDIR/site/design/system/.git" ]
}

# Cold or warm is measured, never declared. A silent success here would hand
# bootstrap a warm tree it had been told was cold.
@test "init refuses over a target that is not empty" {
  mkdir -p "$TESTDIR/site/design/system/assets/investor-update"
  run "$CDSYNC_BIN" init --target "$TESTDIR/site/design/system"
  [ "$status" -ne 0 ]
  assert_contains "not empty"
}

# The end-to-end claim the command exists to make: what init leaves behind is a
# tree bootstrap accepts. Before init, bootstrap refused and advised `cdsync new`,
# which was the wrong command for an existing project.
#
# ASSERTING THE FILE EXISTS IS NOT ENOUGH, and the first version of this test
# did only that. It passed over a document that opened "The tree is populated.
# This is a resume -- do not start it again" across three empty directories.
# What the document SAYS is the whole product here; that it was written is not
# the claim worth pinning.
@test "init leaves a tree bootstrap reads as cold" {
  mkdir -p "$TESTDIR/site" && git -C "$TESTDIR/site" init -q .
  "$CDSYNC_BIN" init --target "$TESTDIR/site/design/system" >/dev/null 2>&1
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/site/design/system"
  [ "$status" -eq 0 ]
  [ -f "$TESTDIR/site/design/system/BOOTSTRAP-CD.md" ]
  run cat "$TESTDIR/site/design/system/BOOTSTRAP-CD.md"
  assert_contains "This is a cold start"
  refute_contains "This is a resume"
}

# The same defect through the older door. `new` has always written the skeleton,
# so `cdsync new acme && cdsync bootstrap` produced a resume over an empty venture
# for as long as both have existed -- which made the cold document unreachable
# through any sequence of the tool's own commands.
@test "a freshly scaffolded venture bootstraps as cold" {
  "$CDSYNC_BIN" new acme >/dev/null 2>&1
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/acme/design"
  [ "$status" -eq 0 ]
  run cat "$TESTDIR/acme/design/BOOTSTRAP-CD.md"
  assert_contains "This is a cold start"
}

# A cold tree holds no Cdsync-shaped assets, so the shape probe returned the
# absence answer and handed a project building from nothing the AS-IS contract:
# "this document is not asking you to adopt" the shape `cdsync check` then
# requires. Two generated documents disagreeing, with the one read first
# winning.
@test "a cold tree is told to build into the cdsync shape" {
  mkdir -p "$TESTDIR/site" && git -C "$TESTDIR/site" init -q .
  "$CDSYNC_BIN" init --target "$TESTDIR/site/design/system" >/dev/null 2>&1
  "$CDSYNC_BIN" bootstrap --target "$TESTDIR/site/design/system" >/dev/null 2>&1
  run cat "$TESTDIR/site/design/system/BOOTSTRAP-CD.md"
  assert_contains "the shape to build into"
  refute_contains "not asking you to adopt"
  refute_contains "the shape it already has"
}

# The as-is contract still has to reach the tree it exists for: one that
# arrived in some other shape and must not be restructured under a round that
# never ordered it.
@test "a warm tree that is not cdsync-shaped still gets the as-is contract" {
  mkdir -p "$TESTDIR/site" && git -C "$TESTDIR/site" init -q .
  "$CDSYNC_BIN" init --target "$TESTDIR/site/design/system" >/dev/null 2>&1
  mkdir -p "$TESTDIR/site/design/system/handoff"
  echo "delivered another way" > "$TESTDIR/site/design/system/handoff/styles.css"
  "$CDSYNC_BIN" bootstrap --target "$TESTDIR/site/design/system" >/dev/null 2>&1
  run cat "$TESTDIR/site/design/system/BOOTSTRAP-CD.md"
  assert_contains "the shape it already has"
  refute_contains "the shape to build into"
}

# THE OVER-CORRECTION GUARD, and the dangerous direction here. Reporting a
# populated tree as cold tells Claude Design to rebuild a design system that
# already exists, which is worse than the bug being fixed. One file of any
# shape, anywhere in the skeleton, is content.
@test "a tree holding any content at all still bootstraps as warm" {
  mkdir -p "$TESTDIR/site" && git -C "$TESTDIR/site" init -q .
  "$CDSYNC_BIN" init --target "$TESTDIR/site/design/system" >/dev/null 2>&1
  # Deliberately NOT a Cdsync-shaped asset: the earlier each_drop_asset bug
  # called Lamplight cold because its files are not in that shape.
  echo "notes on the thing" > "$TESTDIR/site/design/system/notes/thinking.md"
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/site/design/system"
  [ "$status" -eq 0 ]
  run cat "$TESTDIR/site/design/system/BOOTSTRAP-CD.md"
  assert_contains "This is a resume"
  refute_contains "This is a cold start"
}

@test "new without a name is a usage error" {
  run "$CDSYNC_BIN" new
  [ "$status" -eq 2 ]
  assert_contains "usage:"
}

@test "new rejects a path rather than a name" {
  run "$CDSYNC_BIN" new some/where
  [ "$status" -eq 2 ]
  assert_contains "directory name, not a path"
}

@test "new scaffolds a venture" {
  run "$CDSYNC_BIN" new acme
  [ "$status" -eq 0 ]
  local f
  for f in AGENTS.md CLAUDE.md README.md .gitignore; do
    [ -f "$TESTDIR/acme/$f" ] || {
      echo "missing acme/$f" >&2
      return 1
    }
  done
  # cdsync.json lives at the tree root, not the venture root (hv, 9 Aug 2026).
  [ -f "$TESTDIR/acme/design/cdsync.json" ]
  [ ! -f "$TESTDIR/acme/cdsync.json" ]
  [ -d "$TESTDIR/acme/design/assets" ]
  [ -d "$TESTDIR/acme/design/kit" ]
  [ -d "$TESTDIR/acme/design/notes" ]
}

# A venture ignored the generated site/ and .DS_Store and nothing else, so the
# first delivery archive dropped into one would have been committed with it --
# the same hole an existing project had, through the older door.
@test "new ignores the target inbox as well as the generated site" {
  "$CDSYNC_BIN" new acme >/dev/null 2>&1
  run cat "$TESTDIR/acme/.gitignore"
  assert_contains "design/site/"
  assert_contains "/design/_inbox/"
}

@test "new writes a cdsync.json that parses and carries the name" {
  "$CDSYNC_BIN" new acme >/dev/null 2>&1
  run bash -c "jq -r .venture '$TESTDIR/acme/design/cdsync.json'"
  [ "$output" = "acme" ]

  # The .target field is retired: the file's own location is the target, and a
  # file inside the tree pointing at the tree would be circular.
  run bash -c "jq -r '.target // \"absent\"' '$TESTDIR/acme/design/cdsync.json'"
  [ "$output" = "absent" ]
}

@test "new substitutes the venture name into every template" {
  "$CDSYNC_BIN" new acme >/dev/null 2>&1
  run bash -c "grep -rl '{{VENTURE}}' '$TESTDIR/acme' || true"
  [ -z "$output" ]
}

@test "new initialises a git repository" {
  "$CDSYNC_BIN" new acme >/dev/null 2>&1
  [ -d "$TESTDIR/acme/.git" ]
}

@test "new commits the scaffold rather than leaving an unborn HEAD" {
  # `git init` alone leaves no branch, so git log, diff and show all fail in a
  # fresh venture -- the first thing anyone runs makes the scaffold look broken.
  "$CDSYNC_BIN" new acme >/dev/null 2>&1
  run git -C "$TESTDIR/acme" log --oneline
  [ "$status" -eq 0 ]
  [ -n "$output" ]
}

@test "the scaffold commit holds the scaffold and leaves nothing uncommitted" {
  "$CDSYNC_BIN" new acme >/dev/null 2>&1
  run git -C "$TESTDIR/acme" status --porcelain
  [ -z "$output" ]

  run git -C "$TESTDIR/acme" ls-files
  assert_contains "cdsync.json"
  assert_contains ".gitignore"
  assert_contains "design/assets/.gitkeep"
}

@test "the scaffold commit does not carry the generated site" {
  # .gitignore excludes it; a committed site is a stale view of the target.
  "$CDSYNC_BIN" new acme >/dev/null 2>&1
  cd "$TESTDIR/acme"
  jq '.order.assets = ["investor-update"]' design/cdsync.json > tmp.json && mv tmp.json design/cdsync.json
  "$CDSYNC_BIN" brief >/dev/null 2>&1
  run git -C "$TESTDIR/acme" ls-files
  refute_contains "design/site/"
}

@test "new refuses a non-empty directory" {
  mkdir -p "$TESTDIR/acme"
  echo "existing work" > "$TESTDIR/acme/important.md"
  run "$CDSYNC_BIN" new acme
  [ "$status" -ne 0 ]
  assert_contains "not empty"
  [ "$(cat "$TESTDIR/acme/important.md")" = "existing work" ]
}

@test "a scaffolded venture can immediately produce a brief" {
  "$CDSYNC_BIN" new acme >/dev/null 2>&1
  cd "$TESTDIR/acme"
  # The template orders nothing, which must be a refusal rather than an empty
  # brief -- so add an order the way a human would.
  jq '.order.assets = ["investor-update"]' design/cdsync.json > tmp.json && mv tmp.json design/cdsync.json
  run "$CDSYNC_BIN" brief
  [ "$status" -eq 0 ]
  [ -f "$TESTDIR/acme/design/brief.md" ]
}

# ============================================================================
# SITE
# ============================================================================

@test "site --build generates a page without serving" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" site --target "$TESTDIR/drop" --build
  [ "$status" -eq 0 ]
  [ -f "$TESTDIR/drop/site/index.html" ]
}

@test "the generated page declares itself generated on line one" {
  make_drop >/dev/null
  "$CDSYNC_BIN" site --target "$TESTDIR/drop" --build >/dev/null 2>&1
  run bash -c "head -1 '$TESTDIR/drop/site/index.html'"
  assert_contains "@generated"
  # Which means the colour check exempts it by the same rule every vendored
  # runtime uses, rather than by a special case.
  run run_lib "is_generated_file '$TESTDIR/drop/site/index.html'"
  [ "$status" -eq 0 ]
}

@test "the generated page lists each asset with its status and links its artefacts" {
  make_drop >/dev/null
  "$CDSYNC_BIN" check --target "$TESTDIR/drop" >/dev/null 2>&1
  "$CDSYNC_BIN" site --target "$TESTDIR/drop" --build >/dev/null 2>&1
  run bash -c "cat '$TESTDIR/drop/site/index.html'"
  assert_contains "investor-update"
  assert_contains "spec-only"
  assert_contains "../assets/investor-update/investor-update.md"
  assert_contains "../RETURN.md"
}

@test "site refuses a target that is not a drop" {
  mkdir -p "$TESTDIR/empty"
  run "$CDSYNC_BIN" site --target "$TESTDIR/empty" --build
  [ "$status" -eq 2 ]
  assert_contains "no drop at"
}

# ============================================================================
# DOCTOR
# ============================================================================

@test "doctor runs and reports on the target" {
  run "$CDSYNC_BIN" doctor
  assert_contains "CDSYNC_HOME"
  assert_contains "Dependencies"
  assert_contains "target:"
}

@test "doctor reports the spec library" {
  run "$CDSYNC_BIN" doctor
  assert_contains "Spec library"
  assert_contains "taxonomy slugs"
}

# ============================================================================
# THE WHOLE LOOP
# ============================================================================

@test "new, brief, import, check and site compose end to end" {
  "$CDSYNC_BIN" new acme >/dev/null 2>&1
  cd "$TESTDIR/acme"
  jq '.order.assets = ["investor-update"]' design/cdsync.json > tmp.json && mv tmp.json design/cdsync.json

  run "$CDSYNC_BIN" brief
  [ "$status" -eq 0 ]

  # A drop answering that brief, echoing brief.md back the way a real one does.
  make_drop "$TESTDIR/acme/incoming" >/dev/null
  cp design/brief.md "$TESTDIR/acme/incoming/brief.md"

  run "$CDSYNC_BIN" import "$TESTDIR/acme/incoming"
  [ "$status" -eq 0 ]

  run "$CDSYNC_BIN" check
  [ "$status" -eq 0 ]

  run "$CDSYNC_BIN" site --build
  [ "$status" -eq 0 ]

  [ -f design/brief.md ]
  [ -f design/RETURN.md ]
  [ -f design/assets/investor-update/spec.md ]
  [ -f design/site/index.html ]
}

# ============================================================================
# BOOTSTRAP
# ============================================================================

@test "bootstrap is dispatched as its own command" {
  run "$CDSYNC_BIN" bootstrap --help
  [ "$status" -eq 0 ]
}

# A GENERATED DOCUMENT MUST BE A FUNCTION OF THE TREE, NOT OF WHOSE SHELL RAN
# IT. `for entry in "$target"/*` orders by the locale's collating sequence, so
# the same tree produced one document under C and a different one under
# en_US.UTF-8 -- which made all four projects report themselves stale against a
# regeneration that had changed nothing. The standing rule is to regenerate
# after touching the generator and read the diff, and a diff that is always
# noisy is a diff nobody reads.
#
# Asserted by byte order rather than by running two locales, because a locale
# that is not installed on the box falls back and makes the test vacuous.
# `Zeta.md` sorts before `alpha.md` in C and after it almost everywhere else.
@test "the bootstrap inventory is ordered by bytes, not by locale" {
  make_drop >/dev/null
  echo "z" > "$TESTDIR/drop/Zeta.md"
  echo "a" > "$TESTDIR/drop/alpha.md"
  # LC_ALL, not LC_COLLATE. LC_ALL overrides LC_COLLATE per POSIX, so the
  # dispatcher's `export LC_COLLATE=C` does not survive it -- which is how this
  # passed here and on ubuntu and failed on the macOS runner alone. The listing
  # now sorts itself, so no caller's environment can reach it.
  LC_ALL=en_US.UTF-8 "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" >/dev/null 2>&1

  local zeta alpha
  zeta="$(grep -n '`Zeta.md`' "$TESTDIR/drop/BOOTSTRAP-CD.md" | head -1 | cut -d: -f1)"
  alpha="$(grep -n '`alpha.md`' "$TESTDIR/drop/BOOTSTRAP-CD.md" | head -1 | cut -d: -f1)"

  # Both must be found, or comparing them proves nothing.
  [ -n "$zeta" ]
  [ -n "$alpha" ]
  [ "$zeta" -lt "$alpha" ]
}

@test "bootstrap over an empty target reports a cold start" {
  mkdir -p "$TESTDIR/empty"
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/empty" --stdout
  [ "$status" -eq 0 ]
  assert_contains "This is a cold start"
  refute_contains "This is a resume"
}

@test "bootstrap over a populated target reports a resume and names the assets" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  [ "$status" -eq 0 ]
  assert_contains "This is a resume"
  assert_contains "investor-update"
  refute_contains "This is a cold start"
}

# Cold and warm are decided by the tree, never by a flag. A flag would let the
# caller assert a state the tree contradicts, and the two documents differ in
# what they can safely assume -- a "resume" over an empty tree tells Claude
# Design not to build the thing that is not there.
@test "bootstrap decides cold or warm from the tree rather than a flag" {
  mkdir -p "$TESTDIR/becoming"
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/becoming" --stdout
  assert_contains "cold start"

  mkdir -p "$TESTDIR/becoming/assets/some-asset"
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/becoming" --stdout
  assert_contains "This is a resume"
}

@test "bootstrap writes BOOTSTRAP-CD.md into the target" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop"
  [ "$status" -eq 0 ]
  [ -f "$TESTDIR/drop/BOOTSTRAP-CD.md" ]
  grep -q "single source of truth" "$TESTDIR/drop/BOOTSTRAP-CD.md"
}

@test "bootstrap --stdout emits without writing" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  [ "$status" -eq 0 ]
  [ ! -f "$TESTDIR/drop/BOOTSTRAP-CD.md" ]
}

# Reuse, not a second scanner. The one in cmd_brief.sh reads BOTH ADR naming
# conventions because a scan that saw only one reported a project with 33 ADRs
# as having none -- and that bug appeared inside the fix for itself. A copy here
# would not inherit the lesson.
@test "bootstrap carries the numbering high-water marks" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  [ "$status" -eq 0 ]
  assert_contains "Numbering"
}

@test "bootstrap tells Claude Design to export the whole tree, never a delta" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  assert_contains "whole tree"
}

# Seventh not-yours rule, hv 31 July. Lamplight exported 39 tracked PNGs of a
# working directory, which the tree then carried as deliverable.
@test "bootstrap says a working directory is not the drop's to deliver" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  [ "$status" -eq 0 ]
  assert_contains "or any working directory of your own"
}

# The field was asked for by name and read by name, and defined nowhere -- so the
# reader supplied a reading and bumped sixteen assets. This is the definition
# landing where that reader will see it.
@test "bootstrap defines spec_version as the library's stamp" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  [ "$status" -eq 0 ]
  assert_contains "not yours to increment"
  assert_contains "specification the asset was built from"
}

@test "bootstrap sends a round's progress to status rather than to a version" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  assert_contains "is \`status\` and \`coverage\`, not a version"
}

# THE INSTRUCTION WITHOUT THE NUMBER IS NOT AN INSTRUCTION. The section above
# shipped telling Claude Design to copy the specification's version, and no
# document ever carried that version -- so on 31 July 2026 one project asked for
# the numbers by name, one left every stamp unset, and one reset sixteen assets to
# a value the library disagreed with. Three correct readings of a withheld fact.
@test "bootstrap states the number the library holds, not only what it means" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  [ "$status" -eq 0 ]
  assert_contains "| \`investor-update\` | 1 |"
}

# The kit is walked by name rather than by each_drop_asset, so it is exactly the
# asset a table built from that walker would omit -- and it was the one asset the
# round of 31 July left unstamped.
@test "bootstrap gives the kit its number too, which the asset walker would miss" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  assert_contains "| \`kit\` |"
}

# The commoner case rather than the edge: of the four trees in round one, only one
# was built from taxonomy slugs at all. For the rest the honest number is no
# number, and saying so is what stops the next round inventing one.
@test "bootstrap tells a tree the library does not know to stamp unassigned" {
  make_drop >/dev/null
  mv "$TESTDIR/drop/assets/investor-update" "$TESTDIR/drop/assets/portraits"
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  assert_contains "no entry in the library"
  assert_contains "spec_version: unassigned"
  assert_contains "rather than inventing a value"
}

@test "bootstrap says nothing takes a stamp when the tree holds no assets" {
  mkdir -p "$TESTDIR/bare"
  echo "# a tree of its own shape" >"$TESTDIR/bare/README.md"
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/bare" --stdout
  assert_contains "Nothing in this tree carries a copyable number"
  assert_contains "spec_version:"
}

# DECLARING THE FIELD IS ONLY HALF THE SEPARATION, and this document knew only
# the first half. A tree that already carried `classification` on all sixteen
# assets still carried `internal` in `audience` on eleven of them, and a pass
# doing exactly as instructed changed neither -- because nothing had ever said to
# take the value out of the other field.
@test "bootstrap tells the drop to take the classification out of audience" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  assert_contains "take it out of \`audience\`"
}

@test "bootstrap keeps public in audience while naming the two that conflate" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  assert_contains "\`public\` stays"
  assert_contains "\`internal\` and \`confidential\` reach \`audience\` by conflation"
}

# The half most likely to be already half-done, so the document has to say the
# instruction applies to a tree that already carries the field. Without this a
# reader finds it declared and correctly moves on.
@test "bootstrap aims the de-conflation at a tree that already classifies" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  assert_contains "already carries \`classification\`"
}

@test "bootstrap refuses a target that does not exist" {
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/nowhere" --stdout
  [ "$status" -ne 0 ]
}

# The return leg. Canon says an addendum flows BACK to Claude Design and retires
# when a drop absorbs it -- it said THAT it flows back and never HOW, and until
# this nothing implemented it.
@test "bootstrap surfaces addenda awaiting Claude Design" {
  make_drop >/dev/null
  mkdir -p "$TESTDIR/drop/addenda"
  cat >"$TESTDIR/drop/addenda/gap-in-the-colour-doc.md" <<'EOF'
The colour document gives no value for the error state.
EOF

  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  [ "$status" -eq 0 ]
  assert_contains "Addenda awaiting you"
  assert_contains "gap-in-the-colour-doc.md"
  assert_contains "no value for the error state"
}

@test "bootstrap says so when addenda is present but empty" {
  make_drop >/dev/null
  mkdir -p "$TESTDIR/drop/addenda"
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  assert_contains "holds nothing for you"
}

# addenda/README.md is the directory documenting itself -- what belongs there,
# how one retires. Counting it reported Baize's two addenda as three, and
# quoting it introduced the receiving project's own filing protocol to Claude
# Design as "a thing you got wrong or left out, in their words", to be absorbed
# and retired. Baize is the only one of the four with an addenda/ at all, so
# this had never been exercised.
@test "bootstrap does not mistake the addenda README for an addendum" {
  make_drop >/dev/null
  mkdir -p "$TESTDIR/drop/addenda"
  echo "# Addenda -- what belongs here" > "$TESTDIR/drop/addenda/README.md"
  echo "# The gap in round two"         > "$TESTDIR/drop/addenda/the-gap.md"

  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  [ "$status" -eq 0 ]
  assert_contains "**1 addenda"
  assert_contains '### `the-gap.md`'
  refute_contains '### `README.md`'
}

# A COPY OF THE PROJECT'S OWN DOCUMENTS, due back. The mirror image of the
# docs/design/ failure: that was a copy of the drop in the repository, this is a
# copy of the repository in the drop, and it goes stale the same way. Baize
# carries 28 files of it and Lamplight 58; Baize's had already drifted on both
# content (129 lines vs 237) and structure (nine files at paths the repository
# had moved) by the time anyone looked.
@test "bootstrap names project documents borrowed into the drop" {
  mkdir -p "$TESTDIR/borrowed/handoff/intent/st/ST0016" "$TESTDIR/borrowed/docs"
  echo "criteria" > "$TESTDIR/borrowed/handoff/intent/st/ST0016/acceptance.md"
  echo "info"     > "$TESTDIR/borrowed/handoff/intent/st/ST0016/info.md"
  echo "a doc"    > "$TESTDIR/borrowed/docs/overview.md"

  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/borrowed" --stdout
  [ "$status" -eq 0 ]
  assert_contains "Borrowed from the project, and due back"
  assert_contains '`handoff/intent/` -- 2 files'
  # Asserted on fragments that do not span a line wrap. The previous version
  # failed on a phrase the document does carry, split across two lines.
  assert_contains "It must not survive more than one round."
  assert_contains "what you changed or authored here"
}

# Silent when there is nothing borrowed -- two of the four projects have no
# mirror at all, and a section explaining a hazard they do not have is noise.
# The LISTING is conditional on this tree holding borrowed material. The RULE
# must not be, because the copy that matters is the one in Claude Design's own
# project -- which this side cannot see. Once the material is moved out here,
# a conditional rule vanishes from the document at exactly the moment CD still
# needs telling, and the next export brings it all back.
@test "bootstrap says nothing about borrowing when nothing is borrowed" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  [ "$status" -eq 0 ]
  refute_contains "Borrowed from the project"
  # ...but the rules are still stated, unconditionally. Every one of these is
  # about material sitting in CLAUDE DESIGN's tree, which this side cannot see,
  # so a conditional rule would vanish at exactly the point it is needed.
  # snorkeltoast is the live case: its Claude Design project holds a fake Cdsync
  # protocol tree that was deleted here before it was ever tracked, so nothing
  # on this side can detect it and its next export brings it straight back.
  assert_contains "Nor are the project's own working documents"
  assert_contains "must not survive more than one"
  assert_contains "Nor is Cdsync's own protocol material"
  # The document must exclude ITSELF. It is handed over as an upload, and
  # uploads come back in the export -- Baize's tree already carries
  # note-for-cd-in-baize.md and export-brief-baize.md from earlier rounds for
  # exactly that reason. A copy exported back is a snapshot of a file that
  # regenerates on every sync, so it is stale before it lands.
  assert_contains "Nor is this document, at any path"
}

# An `intent` directory without `st/` is not Intent's layout, and a wider net
# would start naming real deliverables as borrowed.
@test "bootstrap does not call any directory named intent a borrowed copy" {
  mkdir -p "$TESTDIR/notborrowed/docs/intent" "$TESTDIR/notborrowed/docs"
  echo "design intent" > "$TESTDIR/notborrowed/docs/intent/brand-intent.md"
  echo "a doc"         > "$TESTDIR/notborrowed/docs/overview.md"

  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/notborrowed" --stdout
  [ "$status" -eq 0 ]
  refute_contains "Borrowed from the project"
}

# CD'S OWN PUSHBACK, TURNED INTO A TEST. The contract section printed the Cdsync
# shape unconditionally under the heading "The shape to export". Over an as-is
# tree that is an order to restructure, and Baize's Claude Design project read
# it that way on 31 July -- worked out that converting would break every
# relative pointer across 442 files, and refused. It was right.
@test "bootstrap does not order a restructure of an as-is tree" {
  mkdir -p "$TESTDIR/asis2/docs" "$TESTDIR/asis2/handoff"
  echo "a doc"    > "$TESTDIR/asis2/docs/overview.md"
  echo "handover" > "$TESTDIR/asis2/handoff/notes.md"

  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/asis2" --stdout
  [ "$status" -eq 0 ]
  assert_contains "Export the tree in the shape it already has"
  assert_contains "this document is not asking you to adopt it"
  refute_contains "Cdsync owns exactly these paths"
  # The whole-tree rule survives either branch.
  assert_contains "Export the whole tree, always"
}

# LAMPLIGHT'S SHAPE, and the trap in the fix for the trap. It has assets/ with
# four subdirectories -- brand, portraits, ref, shots -- and not one carries a
# spec.md. Branching on "are there asset directories" put it on the shaped
# branch and handed it the restructure order the branch exists to prevent. The
# contract's marker for an asset is the spec, so that is what decides.
@test "an assets directory without specs is not the Cdsync shape" {
  mkdir -p "$TESTDIR/named/assets/brand" "$TESTDIR/named/assets/shots" "$TESTDIR/named/docs"
  echo "logo"  > "$TESTDIR/named/assets/brand/logo.svg"
  echo "shot"  > "$TESTDIR/named/assets/shots/one.png"
  echo "a doc" > "$TESTDIR/named/docs/overview.md"

  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/named" --stdout
  [ "$status" -eq 0 ]
  assert_contains "Export the tree in the shape it already has"
  refute_contains "Cdsync owns exactly these paths"
}

@test "bootstrap states the contract shape when the tree is already in it" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  [ "$status" -eq 0 ]
  assert_contains "Cdsync owns exactly these paths"
  assert_contains "this tree is already in"
  refute_contains "Export the tree in the shape it already has"
  assert_contains "Export the whole tree, always"
}

# The step list must not point at a section this document did not produce.
@test "bootstrap omits the absorb-addenda step when there are no addenda" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  [ "$status" -eq 0 ]
  refute_contains "Absorb the addenda above"
  assert_contains "Do this round's work"
}

@test "bootstrap includes the absorb-addenda step when addenda are waiting" {
  make_drop >/dev/null
  mkdir -p "$TESTDIR/drop/addenda"
  echo "# a gap" > "$TESTDIR/drop/addenda/the-gap.md"
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  [ "$status" -eq 0 ]
  assert_contains "Absorb the addenda above"
}

# A directory holding only its own README has no addenda in it.
@test "bootstrap reports none waiting when addenda holds only its README" {
  make_drop >/dev/null
  mkdir -p "$TESTDIR/drop/addenda"
  echo "# Addenda -- what belongs here" > "$TESTDIR/drop/addenda/README.md"

  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  [ "$status" -eq 0 ]
  assert_contains "holds nothing for you"
}

@test "bootstrap --delta carries the addenda and the numbering, not the whole document" {
  make_drop >/dev/null
  mkdir -p "$TESTDIR/drop/addenda"
  echo "a gap" >"$TESTDIR/drop/addenda/note.md"

  run "$CDSYNC_BIN" bootstrap --delta --target "$TESTDIR/drop" --stdout
  [ "$status" -eq 0 ]
  assert_contains "Since your last export"
  assert_contains "note.md"
  assert_contains "Numbering"
  refute_contains "This is a cold start"
}

@test "bootstrap --delta writes RETURN-DELTA.md rather than BOOTSTRAP-CD.md" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" bootstrap --delta --target "$TESTDIR/drop"
  [ "$status" -eq 0 ]
  [ -f "$TESTDIR/drop/RETURN-DELTA.md" ]
  [ ! -f "$TESTDIR/drop/BOOTSTRAP-CD.md" ]
}

# ============================================================================
# THE INBOX, AND THE REFRESH
# ============================================================================

# `_inbox/` IS the drop-off point -- that is the whole of what it is for -- so
# "drop the archive in and sync it" should be the literal interface rather than a
# description of what someone does before typing a path.
@test "install with no archive takes the newest zip from _inbox/" {
  local target src
  target="$(make_installed_target)"
  src="$(make_as_is_export)"
  # The fixture leaves a decoy drop.zip in _inbox. Under bash 3.2, which is
  # what /bin/bash is on macOS, `-nt` compares whole seconds -- so without this
  # the two tie and the tool now refuses rather than guessing. The sibling test
  # below has always had this sleep; this one had not.
  sleep 1
  ( cd "$src" && zip -qr "$target/_inbox/export-real.zip" . )

  run "$CDSYNC_BIN" install --target "$target" --yes
  [ "$status" -eq 0 ]
  assert_contains "export-real.zip"
  [ -f "$target/design-system/colour.md" ]
  [ "$(cat "$target/design-system/colour.md")" = "new colour doc" ]
}

# Newest by mtime, not by name. The supplier's filenames carry a timestamp and
# sorting on it would usually agree -- but "usually" is how a tool installs the
# wrong 380MB tree, and the naming convention is theirs, not ours to depend on.
@test "install picks the newest archive in _inbox/ by time, not by name" {
  local target src
  target="$(make_installed_target)"
  src="$(make_as_is_export)"

  echo "stale doc" > "$src/design-system/colour.md"
  ( cd "$src" && zip -qr "$target/_inbox/zzz-would-sort-last.zip" . )
  sleep 1
  echo "new colour doc" > "$src/design-system/colour.md"
  ( cd "$src" && zip -qr "$target/_inbox/aaa-would-sort-first.zip" . )

  run "$CDSYNC_BIN" install --target "$target" --yes
  [ "$status" -eq 0 ]
  assert_contains "aaa-would-sort-first.zip"
  [ "$(cat "$target/design-system/colour.md")" = "new colour doc" ]
}

# An empty result is not a reason to proceed. The failure this project keeps
# rediscovering is the check that cannot see a thing and reports clean rather
# than saying it could not look.
# `install` REPLACES the whole tree, so picking the wrong archive is the most
# destructive thing available here. Two archives sharing a timestamp is
# genuinely unanswerable, and the old code answered it with glob order --
# alphabetical order wearing the word "newest".
@test "install refuses when two archives tie for newest" {
  local target src
  target="$(make_installed_target)"
  src="$(make_as_is_export)"
  ( cd "$src" && zip -qr "$target/_inbox/aaa-same-second.zip" . )
  # `touch -r` copies the reference's timestamp exactly, so these tie at any
  # resolution. `touch a b` does not: it ties under bash 3.2's whole seconds
  # and not under a bash that resolves nanoseconds, which would make this test
  # pass or fail depending on the runner -- the very thing being fixed.
  touch -r "$target/_inbox/drop.zip" "$target/_inbox/aaa-same-second.zip"

  run "$CDSYNC_BIN" install --target "$target" --yes
  [ "$status" -ne 0 ]
  assert_contains "cannot tell which archive"
  assert_contains "drop.zip"
  assert_contains "aaa-same-second.zip"
}

@test "install with no archive and an empty _inbox refuses rather than guessing" {
  local target
  target="$(make_installed_target)"
  rm -f "$target/_inbox"/*.zip

  run "$CDSYNC_BIN" install --target "$target" --yes
  [ "$status" -ne 0 ]
  assert_contains "no .zip"
}

@test "install with no archive and no _inbox says which directory it looked in" {
  local target
  target="$(make_installed_target)"
  rm -rf "$target/_inbox"

  run "$CDSYNC_BIN" install --target "$target" --yes
  [ "$status" -ne 0 ]
  assert_contains "_inbox"
}

@test "install regenerates BOOTSTRAP-CD.md" {
  local target src
  target="$(make_installed_target)"
  src="$(make_as_is_export)"

  run "$CDSYNC_BIN" install "$src" --target "$target" --yes
  [ "$status" -eq 0 ]
  [ -f "$target/BOOTSTRAP-CD.md" ]
  grep -q "single source of truth" "$target/BOOTSTRAP-CD.md"
}

# Cdsync-side output living inside a tree Claude Design replaces wholesale. The
# replace removes what the drop does not carry -- and the drop never carries
# this -- so without the declaration the guarantee it states dies on the first
# install.
@test "install declares BOOTSTRAP-CD.md protected in its plan" {
  # Asserted on the PLAN, not on the file surviving, and the difference matters.
  # bootstrap_refresh rewrites BOOTSTRAP-CD.md after every install, so the file
  # is there afterwards whether it was protected or deleted-and-regenerated --
  # existence cannot tell those apart, and a test that cannot tell them apart
  # reports clean either way. The plan says which actually happened.
  local target src
  target="$(make_installed_target)"
  src="$(make_as_is_export)"
  echo "repo-authored, no export carries this" > "$target/BOOTSTRAP-CD.md"
  git -C "$(dirname "$(dirname "$target")")" add -A
  git -C "$(dirname "$(dirname "$target")")" commit -qm "bootstrap doc"

  run "$CDSYNC_BIN" install "$src" --target "$target" --dry-run --yes
  [ "$status" -eq 0 ]
  assert_contains "BOOTSTRAP-CD.md  (repo-authored, declared protected)"
  refute_contains "remove   BOOTSTRAP-CD.md"
}

# The guard that made the test above fail the first time it ran, pinned so it
# cannot regress: an untracked file under the target is exactly what a replace
# destroys irrecoverably, and it is the reason there is no backup directory.
@test "install refuses when BOOTSTRAP-CD.md is untracked under the target" {
  local target src
  target="$(make_installed_target)"
  src="$(make_as_is_export)"
  echo "never committed" > "$target/BOOTSTRAP-CD.md"

  run "$CDSYNC_BIN" install "$src" --target "$target" --yes
  [ "$status" -ne 0 ]
  assert_contains "git could not give back"
}

@test "import regenerates BOOTSTRAP-CD.md" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" import "$TESTDIR/drop" --target "$TESTDIR/target"
  [ "$status" -eq 0 ]
  [ -f "$TESTDIR/target/BOOTSTRAP-CD.md" ]
}

@test "bootstrap help renders" {
  run "$CDSYNC_BIN" help bootstrap
  [ "$status" -eq 0 ]
  assert_contains "invariant"
}

# The dangerous direction, and the one this project keeps rediscovering: a probe
# that sees one corner returning a verdict on the whole. An earlier version asked
# each_drop_asset and called a tree cold when it found none -- which over
# Lamplight (708 tracked files, 1.1GB) reported a COLD START and would have told
# Claude Design to build a delivered design system from nothing.
@test "bootstrap does not call a populated non-Cdsync-shaped tree cold" {
  mkdir -p "$TESTDIR/asis/design-system" "$TESTDIR/asis/venture" "$TESTDIR/asis/prototypes"
  echo "colour" > "$TESTDIR/asis/design-system/colour.md"
  echo "plan"   > "$TESTDIR/asis/venture/plan.md"

  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/asis" --stdout
  [ "$status" -eq 0 ]
  refute_contains "This is a cold start"
  assert_contains "This is a resume"
}

@test "bootstrap names material the drop contract does not describe" {
  mkdir -p "$TESTDIR/asis/design-system" "$TESTDIR/asis/venture"
  echo "colour" > "$TESTDIR/asis/design-system/colour.md"

  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/asis" --stdout
  [ "$status" -eq 0 ]
  assert_contains "The rest of the tree"
  assert_contains "design-system/"
  assert_contains "venture/"
  assert_contains "no assets in the Cdsync shape"
}

# "4 assets" over a tree holding 708 files is true and useless. It reads as a
# description of the tree, and Claude Design would then export four things.
@test "bootstrap says the asset list is not the whole tree when there is more" {
  make_drop >/dev/null
  mkdir -p "$TESTDIR/drop/venture"
  echo "the raise" > "$TESTDIR/drop/venture/plan.md"

  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  [ "$status" -eq 0 ]
  assert_contains "not the whole tree"
  assert_contains "venture/"
  assert_contains "reads as a deletion"
}

# The listing's rule is INVERTED: everything appears unless another section
# already accounts for it. So a Cdsync-shaped tree still lists `kit/` and
# `notes/` -- nothing else in the document enumerates them, and they have to
# come back in the export like anything else. What it must not do is repeat
# `assets/`, which the table above just named slug by slug.
@test "bootstrap lists the shaped paths nothing else reports, and does not repeat the assets" {
  make_drop >/dev/null
  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  [ "$status" -eq 0 ]
  assert_contains "The rest of the tree"
  assert_contains '`kit/`'
  assert_contains '`notes/`'
  # As a BULLET. The asset table's own lead line says "at `assets/`" and that is
  # the mention this one must not duplicate, so the assertion has to be the
  # listing's line form rather than the bare name.
  refute_contains '- `assets/`'
}

# THE BAIZE SHAPE, and the defect that would have cost seven tracked files.
#
# `each_drop_asset` walks assets/<slug>/ SUBDIRECTORIES. Three of the four real
# projects keep flat files in assets/ instead -- Baize 7, snorkeltoast 4 -- so
# the table found nothing to print AND the listing skipped the directory on the
# assumption the table had covered it. The result was a document that named
# fourteen paths, said "export every path listed here", and never mentioned
# assets/ at all. Claude Design obeying it omits the logo and the app icon, and
# the install removes them.
@test "bootstrap lists assets/ when it holds flat files rather than asset directories" {
  mkdir -p "$TESTDIR/flat/assets" "$TESTDIR/flat/docs"
  echo "<svg/>" > "$TESTDIR/flat/assets/logo.svg"
  echo "png"    > "$TESTDIR/flat/assets/icon-512.png"
  echo "a doc"  > "$TESTDIR/flat/docs/overview.md"

  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/flat" --stdout
  [ "$status" -eq 0 ]
  assert_contains '`assets/` -- 2 files'
  assert_contains "All of it is yours and all of it comes back"
}

# `.thumbnail` is tracked in three of the four real projects and the listing
# never saw it, because this scan skipped dotfiles while the cold/warm scan
# beside it did not. Two skip lists, one concern, and they disagreed.
@test "bootstrap lists top-level dotfiles, which an export must carry back" {
  mkdir -p "$TESTDIR/dotted/docs"
  echo "a doc" > "$TESTDIR/dotted/docs/overview.md"
  echo "thumb" > "$TESTDIR/dotted/.thumbnail"

  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/dotted" --stdout
  [ "$status" -eq 0 ]
  assert_contains '`.thumbnail`'
}

# ...but NOT a refused one. The listing sits under "all of it comes back", and
# a drop-carried .gitignore does not come back -- install discards it and names
# it. Asking Claude Design to export a file the tool then throws away is the
# document contradicting the tool, so the contract section declares it not
# theirs the way it does addenda/ and _inbox/.
@test "bootstrap does not ask for a file the install refuses" {
  mkdir -p "$TESTDIR/refused/docs"
  echo "a doc"    > "$TESTDIR/refused/docs/overview.md"
  echo "_inbox/"  > "$TESTDIR/refused/.gitignore"
  echo "thumb"    > "$TESTDIR/refused/.thumbnail"

  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/refused" --stdout
  [ "$status" -eq 0 ]
  refute_contains '- `.gitignore`'
  assert_contains '`.thumbnail`'
  assert_contains "Nor is \`.gitignore\`, at any depth"
}

# The counts are the deliverable, not the disk. Reporting 318 files in docs/
# when three of them are macOS junk invites Claude Design to reconcile against
# a number it can never reach.
@test "bootstrap counts the deliverable rather than the disk" {
  mkdir -p "$TESTDIR/noisy/docs"
  echo "one" > "$TESTDIR/noisy/docs/one.md"
  echo "two" > "$TESTDIR/noisy/docs/two.md"
  printf 'junk' > "$TESTDIR/noisy/docs/.DS_Store"
  printf 'junk' > "$TESTDIR/noisy/.DS_Store"

  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/noisy" --stdout
  [ "$status" -eq 0 ]
  assert_contains '`docs/` -- 2 files'
  refute_contains '.DS_Store'
}

# EVERY DOCUMENT THAT LEAVES HERE, and this is a class rather than an instance.
#
# The numbering section printed its scan roots verbatim, and those come from
# `git rev-parse --show-toplevel`, which is absolute by construction. So both
# generated BOOTSTRAP-CD.md files named the author's home directory, in a
# document whose own header promises it points at nothing the reader can open.
# It tells Claude Design nothing it can act on and puts a local directory layout
# into material sent outside.
#
# Asserted against $TESTDIR rather than a literal, so it holds wherever the
# suite runs, and covering all three outputs rather than the one that broke.
@test "no generated document names the filesystem it was generated on" {
  make_drop >/dev/null
  mkdir -p "$TESTDIR/drop/addenda"
  echo "# a gap" > "$TESTDIR/drop/addenda/the-gap.md"

  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/drop" --stdout
  [ "$status" -eq 0 ]
  refute_contains "$TESTDIR"

  run "$CDSYNC_BIN" bootstrap --delta --target "$TESTDIR/drop" --stdout
  [ "$status" -eq 0 ]
  refute_contains "$TESTDIR"

  echo '{"venture":"acme","order":{"assets":["investor-update"]}}' > "$TESTDIR/design/cdsync.json"
  run "$CDSYNC_BIN" brief
  [ "$status" -eq 0 ]
  run bash -c "cat '$TESTDIR/design/brief.md'"
  refute_contains "$TESTDIR"
}

# _inbox/ and the two generated documents are Cdsync's own, not tree content. A
# tree holding only those is still empty.
@test "bootstrap ignores its own output when deciding cold or warm" {
  mkdir -p "$TESTDIR/fresh/_inbox"
  echo "an archive" > "$TESTDIR/fresh/_inbox/drop.zip"

  run "$CDSYNC_BIN" bootstrap --target "$TESTDIR/fresh" --stdout
  [ "$status" -eq 0 ]
  assert_contains "This is a cold start"
}

# ============================================================================
# THE GENERATED DOCUMENT KNOWS WHEN IT HAS GONE STALE
# ============================================================================
#
# Ordered by hv on 9 Aug 2026, shape (a): an advisory line, never blocking.
# REPOSITORY-scoped, because what stales the document usually lives outside the
# design tree -- Baize's snapshot was staled by a steel thread two directories
# away while remaining the newest file in its own tree. Tracked and
# untracked-unignored files only, so build noise cannot make it cry wolf.

@test "check warns when BOOTSTRAP-CD.md is older than the repository" {
  mkdir -p "$TESTDIR/proj/design/system/assets" && git -C "$TESTDIR/proj" init -q .
  echo "# doc" > "$TESTDIR/proj/design/system/BOOTSTRAP-CD.md"
  touch -t 202601010000 "$TESTDIR/proj/design/system/BOOTSTRAP-CD.md"
  mkdir -p "$TESTDIR/proj/intent/st/ST0999"
  echo "# newer, outside the design tree" > "$TESTDIR/proj/intent/st/ST0999/info.md"

  # The tree refuses the asset walk (nothing in the Cdsync shape), and the
  # advisory must fire anyway -- the poster cases for staleness are exactly
  # the trees check cannot walk.
  run "$CDSYNC_BIN" check --target "$TESTDIR/proj/design/system"
  assert_contains "BOOTSTRAP-CD.md is older"
  assert_contains "ST0999"
  assert_contains "cdsync bootstrap --target"
}

@test "the staleness warning is silent when the document is current" {
  mkdir -p "$TESTDIR/proj/design/system/assets" && git -C "$TESTDIR/proj" init -q .
  mkdir -p "$TESTDIR/proj/intent/st/ST0999"
  echo "# older" > "$TESTDIR/proj/intent/st/ST0999/info.md"
  touch -t 202601010000 "$TESTDIR/proj/intent/st/ST0999/info.md"
  echo "# doc, newest" > "$TESTDIR/proj/design/system/BOOTSTRAP-CD.md"

  run "$CDSYNC_BIN" check --target "$TESTDIR/proj/design/system"
  refute_contains "BOOTSTRAP-CD.md is older"
}

@test "an ignored file cannot stale the document" {
  mkdir -p "$TESTDIR/proj/design/system/assets" && git -C "$TESTDIR/proj" init -q .
  printf '_build/\n' > "$TESTDIR/proj/.gitignore"
  touch -t 202601010000 "$TESTDIR/proj/.gitignore"
  echo "# doc" > "$TESTDIR/proj/design/system/BOOTSTRAP-CD.md"
  touch -t 202601020000 "$TESTDIR/proj/design/system/BOOTSTRAP-CD.md"
  mkdir -p "$TESTDIR/proj/_build"
  echo "churn" > "$TESTDIR/proj/_build/artifact"

  run "$CDSYNC_BIN" check --target "$TESTDIR/proj/design/system"
  refute_contains "BOOTSTRAP-CD.md is older"
}

@test "doctor reports the stale document too" {
  mkdir -p "$TESTDIR/proj/design/assets" && git -C "$TESTDIR/proj" init -q .
  echo "# doc" > "$TESTDIR/proj/design/BOOTSTRAP-CD.md"
  touch -t 202601010000 "$TESTDIR/proj/design/BOOTSTRAP-CD.md"
  echo "# newer" > "$TESTDIR/proj/newer.md"

  cd "$TESTDIR/proj"
  run "$CDSYNC_BIN" doctor
  assert_contains "BOOTSTRAP-CD.md is older"
  assert_contains "newer.md"
}

# The project is the one that OWNS the target, not the one you are standing in.
# Rooting on $PWD is right whenever the command runs inside the project and
# silently wrong the moment it does not: generating a document for another
# project's tree scanned THIS repository for high-water marks and handed the
# answer over as if it were theirs. Allocating from another project's marks is
# the exact collision the numbering section exists to prevent.
@test "the numbering scan roots on the target's repository, not the working directory" {
  local here theirs
  here="$TESTDIR/mine"
  theirs="$TESTDIR/theirs"

  mkdir -p "$here/intent/st/ST0999"
  echo "# mine" > "$here/intent/st/ST0999/info.md"
  git -C "$here" init -q .
  git -C "$here" add -A
  git -C "$here" commit -qm "mine"

  mkdir -p "$theirs/intent/st/ST0007" "$theirs/design/system/assets/thing"
  echo "# theirs" > "$theirs/intent/st/ST0007/info.md"
  git -C "$theirs" init -q .
  git -C "$theirs" add -A
  git -C "$theirs" commit -qm "theirs"

  cd "$here"
  run "$CDSYNC_BIN" bootstrap --target "$theirs/design/system" --stdout
  [ "$status" -eq 0 ]

  # Asserted on the IDS HANDED OVER, not on a path in the prose. The document
  # names its scan roots by basename now -- an absolute path in a document the
  # reader cannot open was itself a defect -- but the id is the thing a wrong
  # root actually corrupts, so it is the better probe either way.
  assert_contains "the project, \`theirs\`"
  refute_contains "\`mine\`"
  assert_contains "0008"   # theirs holds ST0007
  refute_contains "0999"   # mine holds ST0999, and must not be reachable
  refute_contains "1000"
}

# The normal case has to stay identical, or the fix above is a behaviour change
# wearing a correctness argument: run inside the project, the git toplevel IS
# the working directory.
@test "the numbering scan is unchanged when run from inside the project" {
  "$CDSYNC_BIN" new acme >/dev/null 2>&1
  cd "$TESTDIR/acme"
  # The template orders nothing, and brief refuses an empty order rather than
  # emitting an empty brief -- so add one the way a human would.
  jq '.order.assets = ["investor-update"]' design/cdsync.json > tmp.json && mv tmp.json design/cdsync.json

  run "$CDSYNC_BIN" brief --stdout
  [ "$status" -eq 0 ]
  assert_contains "Numbering"
  assert_contains "$TESTDIR/acme"
}

# ============================================================================
# TRACKING POLICY FLOWS FROM THE REPO, NEVER FROM A DROP
# ============================================================================

@test "a drop-carried .gitignore is declared refused" {
  run run_lib 'printf "%s\n" "$CDSYNC_DROP_REFUSED_FILES"'
  [ "$status" -eq 0 ]
  assert_contains ".gitignore"
  run run_lib 'drop_file_is_refused ".gitignore" && echo refused'
  assert_contains "refused"
  run run_lib 'drop_file_is_refused "index.md" || echo allowed'
  assert_contains "allowed"
}

# The order flows from the venture to the drop, never back. A drop-carried
# cdsync.json landing anywhere in the tree would sit where the next round reads
# its order from -- uncontrolled input steering what gets built.
@test "a drop-carried cdsync.json is declared refused" {
  run run_lib 'drop_file_is_refused "cdsync.json" && echo refused'
  assert_contains "refused"
}

# .gitignore decides what is TRACKED, and the tree is tracked so the spec can be
# diffed against the implementation. A drop shipping one saying `docs/` would
# silently stop part of the deliverable being recorded, and nothing would say so
# -- the tree would just get smaller.
@test "install discards a drop-carried .gitignore rather than writing it" {
  local target src
  target="$(make_installed_target)"
  src="$(make_as_is_export)"
  printf 'docs/\n' > "$src/.gitignore"

  run "$CDSYNC_BIN" install "$src" --target "$target" --yes
  [ "$status" -eq 0 ]
  [ ! -f "$target/.gitignore" ]
  assert_contains "discard"
}

@test "install discards a drop-carried .gitignore at any depth" {
  local target src
  target="$(make_installed_target)"
  src="$(make_as_is_export)"
  mkdir -p "$src/design-system/deep"
  printf '*.pdf\n' > "$src/design-system/.gitignore"
  printf '*.png\n' > "$src/design-system/deep/.gitignore"

  run "$CDSYNC_BIN" install "$src" --target "$target" --yes
  [ "$status" -eq 0 ]
  [ ! -f "$target/design-system/.gitignore" ]
  [ ! -f "$target/design-system/deep/.gitignore" ]
}

# Removing quietly is the failure this exists to prevent, one level up: a drop
# losing a file it shipped, discovered three rounds later.
@test "install names each discarded .gitignore rather than removing it quietly" {
  local target src
  target="$(make_installed_target)"
  src="$(make_as_is_export)"
  printf 'docs/\n' > "$src/design-system/.gitignore"

  run "$CDSYNC_BIN" install "$src" --target "$target" --dry-run --yes
  [ "$status" -eq 0 ]
  assert_contains "design-system/.gitignore"
  assert_contains "the repository owns tracking policy"
}

@test "a discarded .gitignore shows in a dry run, so the plan is honest" {
  local target src
  target="$(make_installed_target)"
  src="$(make_as_is_export)"
  printf 'docs/\n' > "$src/.gitignore"

  run "$CDSYNC_BIN" install "$src" --target "$target" --dry-run --yes
  [ "$status" -eq 0 ]
  assert_contains "discard"
  [ ! -f "$target/.gitignore" ]
}

@test "import discards a drop-carried .gitignore inside an owned path" {
  make_drop >/dev/null
  printf '*.png\n' > "$TESTDIR/drop/assets/investor-update/.gitignore"

  run "$CDSYNC_BIN" import "$TESTDIR/drop" --target "$TESTDIR/target"
  [ "$status" -eq 0 ]
  [ ! -f "$TESTDIR/target/assets/investor-update/.gitignore" ]
}

@test "the repo-owned design/.gitignore is untouched by any of this" {
  # It lives OUTSIDE the target, which is the whole reason it survives a
  # replace. Nothing here should reach up and touch it.
  local target src repo
  target="$(make_installed_target)"
  repo="$(dirname "$(dirname "$target")")"
  src="$(make_as_is_export)"
  printf '/system/_inbox/\n' > "$repo/design/.gitignore"
  git -C "$repo" add -A && git -C "$repo" commit -qm "repo-owned guard"

  run "$CDSYNC_BIN" install "$src" --target "$target" --yes
  [ "$status" -eq 0 ]
  [ -f "$repo/design/.gitignore" ]
  [ "$(cat "$repo/design/.gitignore")" = "/system/_inbox/" ]
}
