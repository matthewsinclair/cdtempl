#!/usr/bin/env bash
# ============================================================================
# cdsync release -- read the version, move it, cut a release
# ============================================================================
#
# Modelled on `bin/lamplight_version`, which is the house pattern: `VERSION` as
# bare semver, one helper to read it, one to assert its shape, and `show` /
# `bump` as separate verbs from the ceremony that uses them.
#
# Cdsync is the simple case of that pattern. Lamplight syncs three Cargo.toml
# files and an iOS plist, so its comment about writing derived files first and
# `VERSION` last -- leaving `VERSION` un-advanced if a sync fails, so a rerun
# cannot double-bump -- guards a real hazard. Here `VERSION` is the ONLY place
# the version appears, verified by grep rather than assumed, so there is nothing
# to keep in step with it.
#
# The hazard moves instead to the ceremony, and the ordering principle carries
# over unchanged: every step must be safe to rerun after the one after it
# failed. Gates run before anything is written. The tag is cut from the commit.
# The tarball is built from the tag by `git archive` rather than from the
# working tree, so it cannot contain anything the tag does not. And PUSHING IS
# OPT-IN, because it is the one step that leaves this machine and the one that
# cannot be quietly undone.

# What a release tarball is allowed to contain is declared in `.gitattributes`
# with `export-ignore`, not listed here. `git archive` reads that, so the
# exclusion is data rather than a second list this file would have to keep in
# step with the first.
release_dist_dir() {
  echo "$CDSYNC_HOME/dist"
}

# Bare semver, no `v`, no suffix. The `v` belongs to the git tag and nowhere
# else -- a version string that sometimes carries it is one that gets compared
# against one that does not.
release_assert_semver() {
  local version="${1:-}"
  if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    error "version must be bare semver (eg 0.2.0), got '${version:-<empty>}'"
    return 1
  fi
  return 0
}

release_bump_part() {
  local current="$1" part="$2"
  local major minor patch

  IFS='.' read -r major minor patch <<<"$current"

  case "$part" in
    major) printf '%d.0.0\n' "$((major + 1))" ;;
    minor) printf '%d.%d.0\n' "$major" "$((minor + 1))" ;;
    patch) printf '%d.%d.%d\n' "$major" "$minor" "$((patch + 1))" ;;
    *)
      error "invalid bump part '$part' -- use major, minor or patch"
      return 1
      ;;
  esac
}

# Every gate reports rather than returning a bare status, because a release that
# refuses without saying which check refused is a release someone reruns blind.
release_gates() {
  local failed=0

  echo "gates:"

  if [[ -n "$(git -C "$CDSYNC_HOME" status --porcelain)" ]]; then
    echo "  FAIL  working tree is not clean"
    git -C "$CDSYNC_HOME" status --short | sed 's/^/          /'
    failed=1
  else
    echo "  ok    working tree clean"
  fi

  local branch
  branch="$(git -C "$CDSYNC_HOME" rev-parse --abbrev-ref HEAD)"
  if [[ "$branch" != "main" ]]; then
    echo "  FAIL  on branch '$branch', not main"
    failed=1
  else
    echo "  ok    on main"
  fi

  # Ahead is fine and is the normal case -- the release commit is about to make
  # it one further ahead. BEHIND is not: it means the tag would be cut from a
  # commit that is not what the remote holds.
  local behind
  if behind="$(git -C "$CDSYNC_HOME" rev-list --count 'HEAD..@{upstream}' 2>/dev/null)"; then
    if [[ "$behind" -gt 0 ]]; then
      echo "  FAIL  $behind commits behind upstream -- pull first"
      failed=1
    else
      echo "  ok    not behind upstream"
    fi
  else
    echo "  FAIL  no upstream tracking branch -- git push -u <remote> $branch"
    failed=1
  fi

  if "$CDSYNC_HOME/bin/cdsync" doctor >/dev/null 2>&1; then
    echo "  ok    doctor"
  else
    echo "  FAIL  doctor -- run 'cdsync doctor' to see why"
    failed=1
  fi

  # Bare, both of them. `cmd | tail` reports tail's exit code and is 0 whatever
  # the command found, which is how this repo believed shellcheck was clean for
  # several days while it was not.
  if command -v shellcheck >/dev/null 2>&1; then
    if shellcheck "$CDSYNC_HOME/bin/cdsync" "$CDSYNC_HOME"/lib/*.sh >/dev/null 2>&1; then
      echo "  ok    shellcheck"
    else
      echo "  FAIL  shellcheck -- run it bare to see the findings"
      failed=1
    fi
  else
    echo "  FAIL  shellcheck not installed -- a gate that cannot run is not a pass"
    failed=1
  fi

  # RUNNING THE SUITE FROM INSIDE THE SUITE DOES NOT TERMINATE. A test that
  # exercised `release cut` re-entered this gate, which ran bats, which ran that
  # test again. Found by writing exactly that test.
  #
  # Reported as a FAILURE rather than skipped, and that is the point: the gate
  # cannot run here, and a gate that cannot run is not a pass. It also makes the
  # right thing true by construction -- a release cannot be cut from inside the
  # test suite, which is not a thing anyone should be able to do by accident.
  if [[ -n "${BATS_TEST_FILENAME:-}" ]]; then
    echo "  FAIL  tests -- cannot run the suite from inside the suite"
    failed=1
  elif command -v bats >/dev/null 2>&1; then
    if bats "$CDSYNC_HOME/test/cdsync.bats" >/dev/null 2>&1; then
      echo "  ok    tests"
    else
      echo "  FAIL  tests -- run 'bats test/cdsync.bats'"
      failed=1
    fi
  else
    echo "  FAIL  bats not installed -- a gate that cannot run is not a pass"
    failed=1
  fi

  # An absent LICENSE is a warning rather than a gate: it matters for a public
  # repository and not at all for a private one, and this command cannot tell
  # which this is.
  # Either spelling. Intent uses LICENSE.md and GitHub recognises both, so a
  # gate that insisted on one would be enforcing a preference rather than the
  # thing that matters.
  if [[ ! -f "$CDSYNC_HOME/LICENSE" && ! -f "$CDSYNC_HOME/LICENSE.md" ]]; then
    warn "no LICENSE at the repository root -- a public release without one is 'all rights reserved'"
  fi

  echo ""
  return "$failed"
}

release_package() {
  local version="$1"
  local dist tarball

  dist="$(release_dist_dir)"
  mkdir -p "$dist" || {
    error "could not create $dist"
    return 1
  }
  tarball="$dist/cdsync-$version.tar.gz"

  # FROM THE TAG, NOT THE WORKING TREE. A tarball built from disk can contain a
  # file the tag does not, and that difference is invisible in the artefact.
  if ! git -C "$CDSYNC_HOME" archive \
    --format=tar.gz \
    --prefix="cdsync-$version/" \
    -o "$tarball" \
    "v$version"; then
    error "could not archive v$version"
    return 1
  fi

  echo "  package $tarball"
  echo "          $(printf '%s' "$(wc -c <"$tarball")" | tr -d ' ') bytes, $(tar -tzf "$tarball" | grep -c .) entries"
  return 0
}

cmd_release() {
  local sub="${1:-show}"
  [[ $# -gt 0 ]] && shift

  case "$sub" in
    -h | --help)
      show_help release
      return 0
      ;;
    show)
      get_cdsync_version
      return 0
      ;;
    bump)
      release_do_bump "$@"
      return $?
      ;;
    cut)
      release_do_cut "$@"
      return $?
      ;;
    *)
      error "unknown subcommand: $sub -- use show, bump or cut"
      return 2
      ;;
  esac
}

# `bump` moves VERSION and stops. It writes one tracked file and does not
# commit, so it composes with a change someone wants in the same commit.
release_do_bump() {
  local part="${1:-}"
  if [[ -z "$part" ]]; then
    error "usage: cdsync release bump <major|minor|patch>"
    return 2
  fi

  local current next
  current="$(get_cdsync_version)"
  release_assert_semver "$current" || return 1
  next="$(release_bump_part "$current" "$part")" || return 2

  printf '%s\n' "$next" | atomic_write "$CDSYNC_HOME/VERSION" || return 1
  success "VERSION $current -> $next"
  info "not committed, not tagged -- 'cdsync release cut $part' does the ceremony"
  return 0
}

release_do_cut() {
  local part="" dry_run=0 do_push=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run)
        dry_run=1
        shift
        ;;
      --push)
        do_push=1
        shift
        ;;
      -h | --help)
        show_help release
        return 0
        ;;
      -*)
        error "unknown option: $1"
        return 2
        ;;
      *)
        part="$1"
        shift
        ;;
    esac
  done

  if [[ -z "$part" ]]; then
    error "usage: cdsync release cut <major|minor|patch> [--push] [--dry-run]"
    return 2
  fi

  local current next
  current="$(get_cdsync_version)"
  release_assert_semver "$current" || return 1
  next="$(release_bump_part "$current" "$part")" || return 2

  echo "release: $current -> $next"
  echo ""

  if [[ "$dry_run" -eq 1 ]]; then
    release_gates || true
    echo "plan:"
    echo "  write   VERSION = $next"
    echo "  commit  release: v$next"
    echo "  tag     v$next (annotated)"
    echo "  package $(release_dist_dir)/cdsync-$next.tar.gz, from the tag"
    if [[ "$do_push" -eq 1 ]]; then
      echo "  push    commit and tag to upstream"
    else
      echo "  push    NO -- local only. Pass --push to publish"
    fi
    echo ""
    info "dry run -- nothing was written"
    return 0
  fi

  release_gates || {
    error "gates failed -- nothing written"
    return 1
  }

  if git -C "$CDSYNC_HOME" rev-parse "v$next" >/dev/null 2>&1; then
    error "tag v$next already exists"
    return 1
  fi

  printf '%s\n' "$next" | atomic_write "$CDSYNC_HOME/VERSION" || return 1
  echo "  write   VERSION = $next"

  git -C "$CDSYNC_HOME" add VERSION || return 1
  git -C "$CDSYNC_HOME" commit -q -m "release: v$next" || return 1
  echo "  commit  release: v$next"

  git -C "$CDSYNC_HOME" tag -a "v$next" -m "cdsync $next" || return 1
  echo "  tag     v$next"

  release_package "$next" || return 1

  if [[ "$do_push" -eq 1 ]]; then
    local remote
    remote="$(git -C "$CDSYNC_HOME" config --get branch.main.remote || echo origin)"
    git -C "$CDSYNC_HOME" push "$remote" main || return 1
    git -C "$CDSYNC_HOME" push "$remote" "v$next" || return 1
    echo "  push    $remote main + v$next"
  fi

  echo ""
  success "cdsync $next"
  if [[ "$do_push" -eq 0 ]]; then
    info "local only -- 'git push <remote> main && git push <remote> v$next' to publish"
  fi
  return 0
}
