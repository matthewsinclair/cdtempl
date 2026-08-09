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
# IT LIVES AT THE DESIGN TREE ROOT, always -- one home for `new` ventures and
# `init` projects alike (hv, 9 Aug 2026). The old shape had it at the venture
# root for `new` and nowhere at all for `init`, which is why an existing
# project could not run `brief` and scope was supplied by hand. The file's own
# location is what the target resolves from, so it carries no `.target` field:
# a file inside the tree pointing at the tree would be circular.
#

CDSYNC_CONFIG_NAME="cdsync.json"

# The conventional tree roots, probed in order by config_probe. A tree kept
# anywhere else needs --target or $CDSYNC_TARGET on every command, and `new`
# says so when it scaffolds one.
CDSYNC_CONFIG_PROBE_DIRS="design/system design"

# The directory config reads default to. `brief` binds this to the resolved
# target once, so the dozen helpers underneath it do not each thread a base
# through -- one home for the default, like the constant above.
: "${CDSYNC_CONFIG_DIR:=}"

config_path() {
  local base="${1:-${CDSYNC_CONFIG_DIR:-$PWD}}"
  local path="$base/$CDSYNC_CONFIG_NAME"

  if [[ ! -f "$path" ]]; then
    return 1
  fi

  echo "$path"
}

# Find the venture's cdsync.json by probing the conventional tree roots under a
# project base. Emits the FILE path; the file's directory IS the target.
config_probe() {
  local base="${1:-$PWD}"
  local dir path

  for dir in $CDSYNC_CONFIG_PROBE_DIRS; do
    path="$base/$dir/$CDSYNC_CONFIG_NAME"
    if [[ -f "$path" ]]; then
      echo "$path"
      return 0
    fi
  done

  return 1
}

# The fallback chain -- explicit base, then CDSYNC_CONFIG_DIR, then $PWD --
# lives in config_path ALONE. Every helper below hands its argument through
# verbatim, empty when the caller gave none, so there is exactly one place the
# default is decided. Each carrying its own `${2:-$PWD}` is how the tree-root
# binding was silently overridden the first time it was tried.
config_exists() {
  config_path "${1:-}" >/dev/null 2>&1
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
  local base="${2:-}"
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
  local base="${2:-}"
  local path

  path="$(config_path "$base")" || return 0

  jq -r "($query // []) | .[]" "$path" 2>/dev/null
}
