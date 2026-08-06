#!/usr/bin/env bash
#
# cdsync - getting an archive safely onto disk
#
# Every path that reads a drop from outside the repository comes through here:
# pre-flight the source, unpack it somewhere disposable, hand back its root.
#
# Pre-flight and staging live in ONE function pair on purpose. They were separate
# concerns for exactly one day -- 30 July 2026, when four Claude Design exports
# were pre-flighted BY HAND (absolute paths, `..` traversal, symlinks,
# case-collisions, integrity) and then unpacked. The tool did none of it:
# `stage_drop` called `unzip -q` straight at the archive. A ritual that lives in
# a person's head is not a check, and the moment an install path started
# REPLACING a tree rather than adding five paths to it, the gap stopped being
# theoretical. You cannot now stage a drop without pre-flighting it, because
# there is no way to ask for one without the other.
#

# The staging directory's name, so it can be recognised later from a path
# pointing inside it. Declared here because both halves of the pair depend on
# it agreeing, and a literal repeated in two functions is a literal that drifts.
CDSYNC_STAGE_PREFIX="cdsync-stage"

# ============================================================================
# PRE-FLIGHT
# ============================================================================

# Refuse a source that would write outside the target, lose a file on the way in,
# or turn out to be corrupt. Emits nothing on success.
#
# A directory source is a different threat model from an archive: absolute paths
# and `..` traversal have already been resolved by the filesystem, and a
# case-collision cannot exist on a filesystem that would not store one. Symlinks
# survive both.
archive_preflight() {
  local src="$1"

  if [[ -d "$src" ]]; then
    archive_preflight_dir "$src"
    return $?
  fi

  if [[ ! -f "$src" ]]; then
    error "no such file or directory: $src"
    return 1
  fi

  archive_preflight_zip "$src"
}

archive_preflight_zip() {
  local zip="$1"

  require_command unzip "pre-installed on macOS" || return 1

  # The index comes first, because everything below reads it and because a
  # nothing-to-inspect archive must not reach a check that would find nothing to
  # object to and pass. That is the shape of the bug that put
  # `0 assets checked -- clean` on a directory that was not a drop (30 Jul 2026).
  #
  # Empty and unreadable are ONE refusal deliberately. An empty archive fails the
  # listing rather than returning an empty one -- `unzip -Z1` exits 1 and prints
  # "Empty zipfile." -- so telling the two apart means matching that string, and
  # a verdict that turns on an unzip build's wording is the same
  # environment-decides-the-answer trap as the currency matcher and the binary
  # scan. The remedy is identical either way: get an archive that is not this one.
  local names
  if ! names="$(unzip -Z1 "$zip" 2>/dev/null)" || [[ -z "$names" ]]; then
    error "archive is empty, or its index cannot be read: $zip"
    echo "" >&2
    echo "  Nothing to inspect reads the same as nothing wrong to every check" >&2
    echo "  that follows, so it is refused rather than passed." >&2
    return 1
  fi

  # Integrity second. An index can be intact while the data behind it is
  # truncated -- a download that stopped at 90% lists all its entries happily.
  if ! unzip -tq "$zip" >/dev/null 2>&1; then
    error "archive fails its own integrity check: $zip"
    echo "" >&2
    echo "  Its CRCs do not match its contents. Re-download it; do not unpack" >&2
    echo "  it and see what survives." >&2
    return 1
  fi

  archive_reject_absolute "$names" || return 1
  archive_reject_traversal "$names" || return 1
  archive_reject_case_collision "$names" || return 1

  local links
  links="$(unzip -Z "$zip" 2>/dev/null | grep -E '^l[rwxsStT-]{9}' | sed 's/.* //' || true)"
  if [[ -n "$links" ]]; then
    error "archive contains symlink(s)"
    archive_show_offenders "$links"
    echo "  A symlink unpacked into the target can point anywhere on the disk," >&2
    echo "  including out of the repository. A drop is files, not references." >&2
    return 1
  fi

  return 0
}

archive_preflight_dir() {
  local dir="$1"
  local links

  links="$(find "$dir" -type l 2>/dev/null | sed "s|^$dir/||" || true)"
  if [[ -n "$links" ]]; then
    error "source directory contains symlink(s)"
    archive_show_offenders "$links"
    echo "  A symlink copied into the target can point anywhere on the disk," >&2
    echo "  including out of the repository. A drop is files, not references." >&2
    return 1
  fi

  return 0
}

archive_reject_absolute() {
  local offenders
  offenders="$(printf '%s\n' "$1" | grep '^/' || true)"

  if [[ -n "$offenders" ]]; then
    error "archive contains absolute path(s)"
    archive_show_offenders "$offenders"
    echo "  An absolute path unpacks to where it says, not into the target." >&2
    return 1
  fi

  return 0
}

# Any `..` as a whole path COMPONENT. A file legitimately named `..deprecated` is
# not traversal, so the match is anchored to the separators rather than to the
# two characters appearing anywhere.
archive_reject_traversal() {
  local offenders
  offenders="$(printf '%s\n' "$1" | grep -E '(^|/)\.\.(/|$)' || true)"

  if [[ -n "$offenders" ]]; then
    error "archive contains parent-directory traversal"
    archive_show_offenders "$offenders"
    echo "  A path climbing out of the archive root writes outside the target." >&2
    return 1
  fi

  return 0
}

# Two entries differing only in case are a silent data-loss bug on this platform
# and nowhere else, which is why an archive built on Linux can carry one and
# nothing upstream ever notices. macOS defaults to a case-INSENSITIVE filesystem,
# so the second entry overwrites the first on the way in and `unzip` reports
# success: the drop arrives one file short with a clean exit code.
archive_reject_case_collision() {
  local collisions offenders lower
  collisions="$(printf '%s\n' "$1" | tr '[:upper:]' '[:lower:]' | sort | uniq -d || true)"

  if [[ -z "$collisions" ]]; then
    return 0
  fi

  offenders=""
  while IFS= read -r lower; do
    if [[ -z "$lower" ]]; then continue; fi
    offenders+="$(printf '%s\n' "$1" | grep -ix -- "$lower" || true)"$'\n'
  done <<< "$collisions"

  error "archive contains entries differing only in case"
  archive_show_offenders "$offenders"
  echo "  This filesystem is case-insensitive by default, so the second entry" >&2
  echo "  overwrites the first and unzip still exits 0. The drop would arrive" >&2
  echo "  short by one file, with nothing to say so." >&2
  return 1
}

# Name the offenders rather than the count. A refusal that does not say which
# entry caused it sends someone hunting through a 700-file archive by hand.
#
# The `|| true` on the truncating pipeline is load-bearing under `set -o
# pipefail`: once there are more than five offenders, `head` closes the pipe and
# SIGPIPEs `grep`, the pipeline reports 141, and `set -e` aborts the refusal
# BEFORE its return -- so the caller sees 141 instead of 1 and the explanation
# never prints. The failure appears only past the fifth offender, which is to say
# only on real archives and never on a fixture with one bad entry.
archive_show_offenders() {
  local offenders="$1"
  local total shown

  total="$(printf '%s\n' "$offenders" | grep -c . || true)"
  echo "" >&2
  printf '%s\n' "$offenders" | grep . | head -5 | sed 's/^/    /' >&2 || true
  shown=$(( total > 5 ? 5 : total ))
  if [[ "$total" -gt "$shown" ]]; then
    echo "    ... and $((total - shown)) more" >&2
  fi
  echo "" >&2
}

# ============================================================================
# STAGING
# ============================================================================

# Pre-flight the source, unpack it somewhere it can be inspected before anything
# is written, and echo the directory holding it. A directory argument is used in
# place.
#
# Validating before writing is the whole point: the target is only touched once
# the drop is known to be a drop.
stage_drop() {
  local src="$1"

  archive_preflight "$src" || return 1

  if [[ -d "$src" ]]; then
    echo "$src"
    return 0
  fi

  # Named rather than anonymous, so stage_cleanup can recognise the staging root
  # from a path pointing INSIDE it. stage_drop returns the drop root, which may
  # sit several wrappers down, and the tmp path itself cannot be handed back --
  # the return value goes through a command substitution, so anything the
  # function sets dies with its subshell.
  local tmp
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/$CDSYNC_STAGE_PREFIX.XXXXXX")" || {
    error "could not create a staging directory"
    return 1
  }

  if ! unzip -q "$src" -d "$tmp"; then
    rm -rf "$tmp"
    error "could not unpack $src"
    return 1
  fi

  # An export usually wraps everything in one directory named after the
  # project -- and sometimes in more than one. A 2026-08-02 drop arrived wrapped
  # as `design/system/`, two deep, because the exporter had preserved the path
  # the tree sits at in the receiving repository. A sibling drop the same
  # morning was wrapped once, as `design-system/`. Both held an identical drop
  # root, so the wrapping is the exporter's habit and not something a drop can
  # be relied on to get right.
  #
  # This descended exactly once, which is why that mattered: the two-deep drop
  # resolved to `design/`, and `install` would have written
  # `design/system/system/` and left `check` reporting an empty tree -- a wrong
  # answer that looks like a supplier problem and is not one.
  #
  # So descend WHILE the directory is a wrapper, and stop the moment it holds
  # drop content. Both conditions are needed. Depth alone cannot terminate
  # safely, and content alone would not move off an empty wrapper.
  local root="$tmp" entries count
  while true; do
    if drop_root_is_shaped "$root"; then
      break
    fi

    entries="$(find "$root" -mindepth 1 -maxdepth 1 -not -name '__MACOSX' -not -name '.DS_Store')"
    count="$(printf '%s\n' "$entries" | grep -c . || true)"

    if [[ "$count" -ne 1 || ! -d "$entries" ]]; then
      break
    fi

    root="$entries"
  done

  echo "$root"
}

# A directory argument is read in place; only an unpacked archive is ours to
# remove. Deleting the user's own directory because they passed it as a source
# would be an unrecoverable answer to a typo.
#
# Climbs back to the staging root before removing, because stage_drop returns
# the DROP root and those are not the same directory: a drop wrapped in
# `design/system/` leaves two directories above the one that gets returned.
# Removing only what was handed over stranded them -- an abandoned temp tree per
# install, and one more level of it once the descent stopped being single-step.
#
# The climb is bounded by the prefix rather than by a count, so it removes the
# directory this function's own module created and nothing above it. If the
# prefix is not found -- a caller passing a path from somewhere else -- it falls
# back to removing exactly what it was given, which is the old behaviour.
stage_cleanup() {
  local staged="$1"
  local original="$2"
  local root="$staged"

  case "$staged" in
    "$original"|"$original"/*) return 0 ;;
  esac

  while [[ "$root" == */* ]]; do
    case "${root##*/}" in
      "$CDSYNC_STAGE_PREFIX".*)
        rm -rf "$root"
        return 0
        ;;
    esac
    root="${root%/*}"
  done

  rm -rf "$staged"
}
