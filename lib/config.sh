#!/usr/bin/env bash
#
# cdsync - cdsync.json
#
# THE reader of cdsync.json. `target.sh` resolves the target through here and
# `brief` assembles the venture's facts through here; nothing runs jq against
# that file directly.
#
# cdsync.json holds the universal brief header -- the facts about the venture that
# every brief carries, every time. That is deliberate: those facts have exactly
# one home, so a brief is generated from them rather than restating them, and two
# rounds cannot disagree about what stage the venture is at.
#
# The two fields that matter most are `fixed` and `open`. Almost every failure in
# this class of work is one of two things: something was invented that had
# already been decided, or a blank was left where invention was expected. Those
# two lists close both, and everything else in the header is hygiene by
# comparison.
#

CDSYNC_CONFIG_NAME="cdsync.json"

config_path() {
  local base="${1:-$PWD}"
  local path="$base/$CDSYNC_CONFIG_NAME"

  if [[ ! -f "$path" ]]; then
    return 1
  fi

  echo "$path"
}

config_exists() {
  config_path "${1:-$PWD}" >/dev/null 2>&1
}

# Read one scalar by jq path, eg `config_get .venture`.
#
# Emits nothing and returns 1 when absent, so a caller can supply its own
# default without having to distinguish empty from missing first.
#
# Requires jq. Gate it ONCE before any loop that reads config -- never
# per-iteration, and never memoised across a command substitution, where the
# memo dies with its subshell and turns one install hint into one per item.
config_get() {
  local query="$1"
  local base="${2:-$PWD}"
  local path value

  path="$(config_path "$base")" || return 1

  value="$(jq -r "$query // empty" "$path" 2>/dev/null)"

  if [[ -z "$value" ]]; then
    return 1
  fi

  echo "$value"
}

# Read an array by jq path, one item per line.
config_list() {
  local query="$1"
  local base="${2:-$PWD}"
  local path

  path="$(config_path "$base")" || return 0

  jq -r "($query // []) | .[]" "$path" 2>/dev/null
}
