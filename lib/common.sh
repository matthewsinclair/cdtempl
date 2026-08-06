#!/usr/bin/env bash
#
# cdsync - shared primitives
#
# Sourced by bin/cdsync. Holds exactly the things every command needs and
# nothing a single command needs -- those live in that command's own module.
#

# ============================================================================
# COLOURS
# ============================================================================

if [[ -t 1 ]]; then
  BOLD='\033[1m'
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BLUE='\033[0;34m'
  RESET='\033[0m'
else
  BOLD=''
  RED=''
  GREEN=''
  YELLOW=''
  BLUE=''
  RESET=''
fi

# ============================================================================
# THE CLASSIFICATION VOCABULARY
# ============================================================================
#
# Shared because two commands need the same words and must not each hold their
# own copy: `check` VALIDATES these values, `bootstrap` INSTRUCTS Claude Design
# on them. A document telling the other side one thing while the check enforces
# another is the two-lists-that-disagree defect, and it is worse here than
# elsewhere -- the document is an instruction the other side obeys, so a drift
# would not merely mis-report, it would produce the wrong drop.
#
# It lives here rather than in cmd_check.sh because bin/cdsync sources command
# modules ON DEMAND. Only one cmd_*.sh is ever loaded, so bootstrap could not
# read a constant of check's, and a module re-sourcing another module's file is
# the thing bin/cdsync's own comment warns against.
#
# ONLY THIS SUBSET MOVED, not the full three-value vocabulary. `check` is the
# sole reader of that one, so hoisting it would have bought nothing and left a
# constant here that nothing in this file's reach uses -- which shellcheck reads
# as dead and a later reader reads as a loose end. What is shared moves; what is
# not, stays where it is used.

# The values that answer ONLY "where may this be shown", never "who is this for".
# `public` is deliberately absent: it is a real answer to both questions, so
# finding it in `audience` proves nothing. `internal` and `confidential` say
# nothing about who a thing is for, so they can only have arrived in that field
# by conflation. Full reasoning at rule_classification_conflation.
CDSYNC_CLASSIFICATION_ONLY="internal confidential"

# The above, rendered for prose: "`internal` and `confidential`".
#
# Reads naturally for the two values that exist. A third would render as "a and
# b and c" -- clumsy, and deliberately preferred to a hand-written sentence that
# would go on naming two words after someone added a third.
classification_only_prose() {
  local value out=""

  for value in $CDSYNC_CLASSIFICATION_ONLY; do
    out="$out\`$value\` and "
  done

  echo "${out% and }"
}

# ============================================================================
# LOGGING
# ============================================================================
#
# All diagnostics go to stderr so a command's stdout stays pipeable. `cdsync
# brief --stdout` pipes a brief into a clipboard; a stray info line on stdout
# would corrupt it.

info() {
  echo -e "${BLUE}i${RESET} $*" >&2
}

success() {
  echo -e "${GREEN}ok${RESET} $*" >&2
}

warn() {
  echo -e "${YELLOW}warn${RESET} $*" >&2
}

error() {
  echo -e "${RED}error${RESET} $*" >&2
}

debug() {
  if [[ "${CDSYNC_DEBUG:-}" == "1" ]]; then
    echo -e "${BOLD}[debug]${RESET} $*" >&2
  fi
}

# ============================================================================
# VERSION
# ============================================================================

get_cdsync_version() {
  local version_file="$CDSYNC_HOME/VERSION"

  if [[ -f "$version_file" ]]; then
    cat "$version_file"
  else
    echo "unknown"
  fi
}

# ============================================================================
# DEPENDENCIES
# ============================================================================

check_command() {
  command -v "$1" >/dev/null 2>&1
}

require_command() {
  local cmd="$1"
  local install_hint="${2:-}"

  if check_command "$cmd"; then
    return 0
  fi

  error "required command not found: $cmd"
  if [[ -n "$install_hint" ]]; then
    echo "" >&2
    echo "Install with:" >&2
    echo "  $install_hint" >&2
  fi
  return 1
}

# THE gate for jq, which parses cdsync.json and is the only JSON reader here.
#
# Call this ONCE, before any loop that reads config -- never per-iteration,
# and never try to memoise the result in a variable. A memo set inside a
# command substitution dies with its subshell, so a per-call guard prints its
# install hint once per item instead of once per invocation. That is a real
# bug that shipped in the sibling project this pattern comes from; see
# ../Utilz/intent/st/COMPLETED/ST0009/design.md.
require_jq() {
  require_command jq "brew install jq"
}

# ============================================================================
# ATOMIC WRITE
# ============================================================================

# Write stdin to a path atomically: compose to a temporary file alongside the
# destination, then move it into place.
#
# The original justification for this was that Claude Design reads the working
# tree through a live mount. That was wrong -- it cannot read this repository
# at all, and every input reaches it as an upload. The behaviour is kept
# anyway: it costs nearly nothing, handing a human a half-written brief to
# upload is its own failure, and that failure would be silent.
atomic_write() {
  local dest="$1"
  local dest_dir
  dest_dir="$(dirname "$dest")"

  if [[ ! -d "$dest_dir" ]]; then
    error "destination directory does not exist: $dest_dir"
    return 1
  fi

  # Same directory as the destination, so the move is a rename within one
  # filesystem and therefore atomic. A temp file in /tmp would not be.
  local tmp
  tmp="$(mktemp "$dest_dir/.cdsync.XXXXXX")" || {
    error "could not create a temporary file in $dest_dir"
    return 1
  }

  if ! cat >"$tmp"; then
    rm -f "$tmp"
    error "failed writing to temporary file: $tmp"
    return 1
  fi

  if ! mv "$tmp" "$dest"; then
    rm -f "$tmp"
    error "failed moving $tmp into place at $dest"
    return 1
  fi

  return 0
}

# ============================================================================
# NOT IMPLEMENTED
# ============================================================================

# Every unbuilt command routes through here. It fails loudly with a pointer to
# where the design lives, rather than succeeding quietly and leaving the caller
# to wonder why nothing happened.
not_implemented() {
  local cmd="$1"
  local what="$2"

  error "cdsync $cmd is not implemented yet"
  echo "" >&2
  echo "  $what" >&2
  echo "" >&2
  echo "  Blocked on ST0001, which settles the brief format, the output" >&2
  echo "  structure, the asset taxonomy, and the per-asset specifications." >&2
  echo "  See intent/st/ST0001/." >&2
  return 2
}
