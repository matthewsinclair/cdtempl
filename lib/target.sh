#!/usr/bin/env bash
#
# cdsync - $CDSYNC_TARGET resolution
#
# THE resolver. Every command that touches the target calls resolve_target and
# nothing else -- no command re-derives the path itself, and no command
# hardcodes `design/`.
#

# The layout underneath the target is standardised. The location is not.
CDSYNC_TARGET_DEFAULT="design"

# Subdirectories mandated underneath whatever the target resolves to.
# Deliberately not an implied production order: design and venture assets
# inform each other reciprocally, so this is a set, not a sequence.
#
# `venture/` was here until the taxonomy settled. It came from an earlier layout
# with assets/ and venture/ as siblings, which became incoherent once the
# taxonomy was cut by precondition rather than by discipline -- eight asset types
# are genuinely both, so any such split forces a lie about them. assets/ is flat
# and the grouping lives in index.md, as data rather than as a directory someone
# has to be right about.
# Consumed across the sourced-file boundary, by `cmd_new.sh`, which shellcheck
# cannot see from here -- so the "appears unused" reading is wrong rather than
# stale. Deliberately not exported: this is Cdsync's own constant, not something
# a child process has any business inheriting.
# shellcheck disable=SC2034
CDSYNC_TARGET_DIRS="assets kit notes"

# Collapse `.` and `..` segments in a path, textually.
#
# `cd && pwd` is not usable here: the target frequently does not exist yet --
# `cdsync import` creates it. `realpath` is not on every macOS. Textual
# normalisation is correct for what this feeds (is the target underneath the
# repository root), and symlinks are out of scope because resolving them on a
# path that does not exist is undefined anyway.
#
# Without this, `--target ../outside-repo` resolves to a string that still
# begins with the repo root and is reported as versioning with the project
# when it does not.
normalise_path() {
  local path="$1"
  local out=""
  local seg
  local IFS='/'

  for seg in $path; do
    case "$seg" in
      ''|.)
        continue
        ;;
      ..)
        out="${out%/*}"
        ;;
      *)
        out="$out/$seg"
        ;;
    esac
  done

  echo "${out:-/}"
}

# Resolve the target directory, in precedence order:
#
#   1. --target FLAG        explicit, wins over everything
#   2. $CDSYNC_TARGET        environment
#   3. cdsync.json .target   the project's durable answer
#   4. design/              built-in default
#
# Mirrors how $UTILZ_HOME and $INTENT_HOME resolve in the sibling tools:
# an explicitly set value always beats a derived one.
#
# Emits an absolute path on stdout. Diagnostics go to stderr, so this is safe
# to use in a command substitution.
resolve_target() {
  local flag_target="${1:-}"
  local base="${2:-$PWD}"
  local target=""
  local source=""

  if [[ -n "$flag_target" ]]; then
    target="$flag_target"
    source="--target flag"
  elif [[ -n "${CDSYNC_TARGET:-}" ]]; then
    target="$CDSYNC_TARGET"
    source="\$CDSYNC_TARGET"
  elif config_exists "$base"; then
    require_jq || return 1
    local from_config
    if from_config="$(config_get '.target' "$base")"; then
      target="$from_config"
      source="cdsync.json"
    fi
  fi

  if [[ -z "$target" ]]; then
    target="$CDSYNC_TARGET_DEFAULT"
    source="built-in default"
  fi

  # Relative targets resolve against the project base, never against $PWD --
  # `cdsync import` run from a subdirectory must land in the same place it
  # would from the root.
  case "$target" in
    /*) ;;
    *) target="$base/$target" ;;
  esac

  target="$(normalise_path "$target")"

  debug "target resolved to $target (from $source)"
  echo "$target"
}

# Report where the target came from, for `doctor` and for `import` to echo
# back. Same precedence as resolve_target; kept beside it so the two cannot
# drift apart.
target_source() {
  local flag_target="${1:-}"
  local base="${2:-$PWD}"

  if [[ -n "$flag_target" ]]; then
    echo "--target flag"
    return 0
  fi

  if [[ -n "${CDSYNC_TARGET:-}" ]]; then
    echo "\$CDSYNC_TARGET"
    return 0
  fi

  if config_exists "$base"; then
    require_jq || return 1
    if config_get '.target' "$base" >/dev/null; then
      echo "cdsync.json"
      return 0
    fi
  fi

  echo "built-in default"
}

# Is the target inside the repository that contains `base`?
#
# A target outside the repo is not versioned with the project. That is exactly
# right for a shared or confidential drop, and exactly wrong by accident, so
# every command that resolves a target says which it got.
target_is_in_repo() {
  local target="$1"
  local base="${2:-$PWD}"

  local repo_root
  repo_root="$(cd "$base" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null)" || return 1
  [[ -z "$repo_root" ]] && return 1

  # Normalise defensively: this is the check that decides whether a drop is
  # reported as versioning with the project, so it must not be fooled by a
  # `..` that walks back out of the repo.
  target="$(normalise_path "$target")"
  repo_root="$(normalise_path "$repo_root")"

  case "$target" in
    "$repo_root"|"$repo_root"/*) return 0 ;;
    *) return 1 ;;
  esac
}

# One line describing the resolved target, used by doctor and import so the
# phrasing is identical in both.
describe_target() {
  local target="$1"
  local source="$2"
  local base="${3:-$PWD}"

  echo "target: $target"
  echo "  from: $source"

  if target_is_in_repo "$target" "$base"; then
    echo "  scope: inside the repository, so it versions with the project"
    return 0
  fi

  # There are THREE states here, and collapsing them told a lie.
  #
  # `target_is_in_repo` answers one precise question -- is the target inside the
  # repo containing the working directory -- and the old wording read its `no` as
  # "not versioned at all". Run `cdsync check --target ...` from one repository
  # against a drop in another and it announced "it does not version with the
  # project" about a tree with 708 files tracked in it. Measured on Lamplight,
  # 30 July 2026.
  #
  # That is the day's recurring failure wearing different clothes: a check that
  # cannot see a thing reporting a verdict about it anyway. And it is worse than
  # ordinary noise here, because the whole canon rests on the drop being tracked
  # so the implementation can be diffed against it -- so telling someone their
  # tracked drop is unversioned contradicts the one thing they must believe.
  local other_repo
  other_repo="$(cd "$target" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null)" || other_repo=""

  if [[ -n "$other_repo" ]]; then
    echo "  scope: inside a DIFFERENT repository ($other_repo)"
    echo "         it versions with that project, not with this working directory"
    return 0
  fi

  echo "  scope: OUTSIDE any repository -- it does not version with anything"
}

# The repo-owned guard that keeps delivery archives out of git.
#
# IT LIVES IN THE TARGET'S PARENT, DELIBERATELY. `install` replaces the target
# wholesale, so a guard inside it would be removed by the next install and
# restored only if the drop happened to carry one. `drop.sh` records exactly
# that near-miss: today's drops ship a `.gitignore` saying `_inbox/` which
# agrees with the repo-owned file and is harmless -- but Lamplight's 2026-07-31
# export shipped none at all, and Baize had deleted its repo-owned guard the day
# before, reasoning that the drop's copy made it redundant. The agreement is the
# accident, not the design, and tracking policy flows from the repo outward.
#
# Until now nothing owned this file. All four ported projects carry it by hand,
# which is the definition of a rule that will eventually be missed -- and the
# thing it stops being committed is a 600MB delivery archive.
#
# NEVER TRUNCATES. The parent may be the project root and may already hold
# everything else the project ignores, so an existing file is appended to, and
# only when the rule is genuinely absent.
write_target_inbox_gitignore() {
  local target="$1"
  local parent name ignore rule

  parent="$(dirname "$target")"
  name="$(basename "$target")"
  ignore="$parent/.gitignore"

  # Anchored. Unanchored, `_inbox/` matches at ANY depth below the parent --
  # which silently caught an unrelated directory in a sibling project.
  rule="/$name/_inbox/"

  if [[ -f "$ignore" ]] && grep -qxF "$rule" "$ignore"; then
    echo "  present .gitignore already ignores $name/_inbox/"
    return 0
  fi

  if [[ -f "$ignore" ]]; then
    {
      echo ""
      echo "# _inbox/ is the drop-off point for delivery archives: ephemeral"
      echo "# transport, unpacked by cdsync and recreated whenever one is wanted"
      echo "# again. Nothing is in them that is not already unpacked and tracked"
      echo "# beside them."
      echo "$rule"
    } >>"$ignore" || {
      error "could not append to $ignore"
      return 1
    }
    echo "  append  .gitignore"
    return 0
  fi

  cat >"$ignore" <<EOF
# The Claude Design drop lands at $name/ and is tracked in full.
#
# It is the output of the Claude Design process, put here and replaced by cdsync,
# and it is never hand-edited -- addenda/ is the one sanctioned way to write into
# it. Nothing in this project runs on any of it. It is the requirements baseline
# the realised design system is checked against, and being able to diff the
# specification against the implementation is why it is stored with the project.
#
# Classification -- public / internal / confidential -- governs where material
# may be shown, never whether it is committed. Everything here is tracked
# regardless of it.
#
# _inbox/ is the drop-off point for delivery archives: ephemeral transport,
# unpacked by cdsync and recreated whenever one is wanted again. Nothing to track.
$rule
EOF

  if [[ ! -f "$ignore" ]]; then
    error "could not write $ignore"
    return 1
  fi

  echo "  create  .gitignore"
}
