#!/usr/bin/env bash
#
# cdtempl - YAML front matter, read and written
#
# THE front-matter accessor. Every module that reads a spec.md, an index.md or
# the spec library goes through here; nothing re-implements the parse.
#
# Deliberately not yq. Every field cdtempl decides on is a scalar -- status,
# spec_version, blanks, coverage -- and the only nested structure, depends_on,
# is read for reporting rather than for control flow. Adding a hard dependency
# on yq to parse fields awk handles in twenty lines would buy nothing and cost
# an install step on every machine that runs check.
#
# The parse covers the subset of YAML that appears in a drop: a leading `---`
# on line one, scalars, inline lists, block lists, and one level of nesting.
# Anything beyond that is out of scope by construction -- if a spec grows a
# structure this cannot read, that is a signal about the spec, not a reason to
# grow the parser.
#

# ============================================================================
# READING
# ============================================================================

# Emit the front-matter block -- everything between the opening `---` on line
# one and the next `---`. A file that does not open with `---` has no front
# matter and produces nothing, which every caller reads as "absent".
fm_block() {
  local file="$1"

  if [[ ! -f "$file" ]]; then
    return 1
  fi

  awk '
    NR == 1 && $0 !~ /^---[[:space:]]*$/ { exit }
    NR == 1 { next }
    /^---[[:space:]]*$/ { exit }
    { print }
  ' "$file"
}

# Read one scalar. Emits nothing and returns 1 when the key is absent, so
# `value="$(fm_get "$f" status)" || value="unknown"` reads naturally.
#
# Quotes are stripped. A trailing `# comment` is stripped only from unquoted
# values -- a quoted one may legitimately contain a `#`, which is how every
# colour literal in the kit is written.
fm_get() {
  local file="$1"
  local key="$2"
  local value

  value="$(fm_block "$file" | awk -v key="$key" '
    $0 ~ "^" key ":" {
      sub("^" key ":[[:space:]]*", "")
      print
      exit
    }
  ')"

  if [[ -z "$value" ]]; then
    return 1
  fi

  fm_scalar "$value"
}

# Normalise one raw scalar: strip an unquoted trailing comment, strip matching
# quotes, trim. Split out because fm_get and fm_list both need it and the two
# must agree on what a value is.
fm_scalar() {
  local value="$1"

  # Trim FIRST. A value cannot be classified as quoted until its surrounding
  # whitespace is gone, and the trim used to happen after the case below -- so
  # ` "social-and-ad-kit"`, the second element of any inline list, never matched
  # the quoted pattern and kept its quotes for the rest of its life.
  #
  # That is not cosmetic. Rule 2 then compared `"brand-guidelines"` against the
  # taxonomy, found no match, and reported a slug that is present in the library
  # as absent from it. Seventeen of twenty-two such advisories against one real
  # drop were this, and the first element of every list was clean while the rest
  # were not -- an asymmetry that reads as a data problem and is a parser one.
  #
  # Two substitutions rather than a regex, to stay bash 3.2 clean.
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"

  case "$value" in
    \"*\"|\'*\')
      value="${value%\"}"
      value="${value#\"}"
      value="${value%\'}"
      value="${value#\'}"
      ;;
    *)
      value="${value%%[[:space:]]#*}"
      ;;
  esac

  # Trim again: stripping a comment can leave trailing space behind it.
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"

  echo "$value"
}

# Is a key present, whatever its value?
#
# Distinct from `fm_get` succeeding: `coverage:` with an empty value is present
# but empty, and check rule 5 must tell those apart -- a declared-but-blank
# coverage is a different failure from an absent one.
fm_has() {
  local file="$1"
  local key="$2"

  fm_block "$file" | grep -q "^$key:"
}

# Read a list, one item per line. Handles both YAML forms, and one level of
# nesting via a dotted path:
#
#   fm_list spec.md bundles                 -> bundles: [seed-set, launch-set]
#   fm_list spec.md inputs_missing          -> a block list of `- item` lines
#   fm_list spec.md depends_on.hard_assets  -> nested under depends_on:
#
# Emits nothing for an absent or empty key. Consume it with process
# substitution, never a pipe -- see the walker note in lib/specs.sh.
fm_list() {
  local file="$1"
  local path="$2"
  local parent="" key="$path"

  case "$path" in
    *.*)
      parent="${path%%.*}"
      key="${path#*.}"
      ;;
  esac

  fm_block "$file" | awk -v parent="$parent" -v key="$key" '
    function emit_inline(rest,   n, i, parts) {
      sub(/^\[/, "", rest)
      sub(/\][[:space:]]*$/, "", rest)
      n = split(rest, parts, ",")
      for (i = 1; i <= n; i++) {
        print parts[i]
      }
    }

    # Without a parent, the key sits at column zero. With one, we first have to
    # be inside the parent block -- tracked by in_parent, which ends the moment
    # a line starts at column zero again.
    parent != "" && $0 ~ "^" parent ":" { in_parent = 1; next }
    parent != "" && in_parent && $0 ~ /^[^[:space:]]/ { in_parent = 0 }
    parent != "" && !in_parent { next }

    collecting && $0 ~ /^[[:space:]]*-[[:space:]]/ {
      sub(/^[[:space:]]*-[[:space:]]*/, "")
      print
      next
    }
    collecting { exit }

    $0 ~ "^[[:space:]]*" key ":" {
      rest = $0
      sub("^[[:space:]]*" key ":[[:space:]]*", "", rest)
      if (rest ~ /^\[/) {
        emit_inline(rest)
        exit
      }
      if (rest != "") {
        print rest
        exit
      }
      collecting = 1
    }
  ' | while IFS= read -r raw; do
    local item
    item="$(fm_scalar "$raw")"
    if [[ -n "$item" ]]; then
      echo "$item"
    fi
  done
}

# ============================================================================
# WRITING
# ============================================================================

# Replace a scalar in place, inserting it before the closing `---` if absent.
#
# This exists for exactly one caller: `cdtempl check` computing `blanks` and
# `blanks_unique` and writing them back. Those two fields were declared by hand
# twice and were wrong both times, in three different ways -- so the tool owns
# them now, and owning them means being able to write them.
# Does this file carry a front-matter block at all?
#
# Named because two callers need the same predicate. `fm_set` refuses to write
# into a file without one; `check` needs to say so as a finding rather than die on
# the attempt, which is what it did -- one un-stampable spec aborted the whole run
# and took the report with it.
fm_has_block() {
  local file="$1"

  if [[ ! -f "$file" ]]; then
    return 1
  fi

  [[ -n "$(fm_block "$file" 2>/dev/null)" ]]
}

#
# The value is written verbatim. Callers pass the scalar they want to see.
fm_set() {
  local file="$1"
  local key="$2"
  local value="$3"

  if [[ ! -f "$file" ]]; then
    error "cannot set $key: no such file: $file"
    return 1
  fi

  if ! fm_has_block "$file"; then
    error "cannot set $key: $file has no front matter"
    return 1
  fi

  # awk reads the original while atomic_write composes a sibling temp file and
  # renames it, so the file being read is never the file being written.
  awk -v key="$key" -v value="$value" '
    BEGIN { state = 0 }

    NR == 1 && $0 ~ /^---[[:space:]]*$/ { state = 1; print; next }

    state == 1 && $0 ~ "^" key ":" {
      print key ": " value
      done_it = 1
      next
    }

    state == 1 && $0 ~ /^---[[:space:]]*$/ {
      if (!done_it) {
        print key ": " value
        done_it = 1
      }
      state = 2
      print
      next
    }

    { print }
  ' "$file" | atomic_write "$file"
}
