#!/usr/bin/env bash
#
# cdsync - the spec library
#
# THE reader of specs/. `brief` assembles from here, `check` compares a drop
# against here, and nothing else touches it.
#
# The library is the source of truth for what an asset is. A drop carries a
# stamped copy of each spec it delivers; the version difference between the two
# is what makes staleness detectable, which is check rule 2. If the library were
# the drop -- as it was until this module existed -- rule 2 could never fire.
#

# ============================================================================
# LOCATION
# ============================================================================

spec_library_dir() {
  echo "$CDSYNC_HOME/specs"
}

# The library's own manifest: version fields and the bundle definitions. Named
# so the walker below can skip it -- same shape as `utilz` being skipped by the
# walker over bin/ in the sibling tool.
spec_library_manifest() {
  echo "$(spec_library_dir)/library.md"
}

spec_path() {
  local slug="$1"
  local path
  path="$(spec_library_dir)/$slug.md"

  if [[ ! -f "$path" ]]; then
    return 1
  fi

  echo "$path"
}

spec_exists() {
  spec_path "$1" >/dev/null 2>&1
}

# ============================================================================
# THE WALKER
# ============================================================================

# Emit every slug that has a spec in the library, one per line.
#
# THE walker of specs/. Nothing else globs that directory.
#
# CONSUME THIS WITH PROCESS SUBSTITUTION, NEVER A PIPE:
#
#   while IFS= read -r slug; do ...; done < <(each_spec)
#
# A pipe puts the loop body in a subshell, so any array or counter the body
# accumulates is discarded when the subshell ends and the caller reports
# nothing -- successfully, which is what makes it expensive to find. That bug
# shipped in the sibling tool this pattern comes from; the reasoning is in
# ../Utilz/intent/st/COMPLETED/ST0009/design.md.
each_spec() {
  local file name

  for file in "$(spec_library_dir)"/*.md; do
    if [[ ! -f "$file" ]]; then continue; fi
    name="$(basename "$file" .md)"
    if [[ "$name" == "library" ]]; then continue; fi
    echo "$name"
  done

  return 0
}

# ============================================================================
# THE MANIFEST
# ============================================================================

library_get() {
  fm_get "$(spec_library_manifest)" "$1"
}

# Emit the slugs in one bundle, one per line. Nothing for an unknown bundle,
# which callers must distinguish from an empty one -- see bundle_exists.
each_bundle_member() {
  fm_list "$(spec_library_manifest)" "bundles.$1"
}

bundle_exists() {
  local bundle="$1"
  local found

  found="$(each_bundle_member "$bundle")"
  [[ -n "$found" ]]
}

each_bundle() {
  fm_block "$(spec_library_manifest)" | awk '
    /^bundles:/ { in_bundles = 1; next }
    in_bundles && /^[^[:space:]]/ { in_bundles = 0 }
    in_bundles && /^[[:space:]]+[a-z0-9-]+:/ {
      sub(/^[[:space:]]+/, "")
      sub(/:.*$/, "")
      print
    }
  '
}

# ============================================================================
# THE TAXONOMY
# ============================================================================

# Emit every slug named anywhere in the taxonomy tables, deduplicated.
#
# Wider than each_spec: the taxonomy is the menu of fifty-one, the library holds
# specs for the eleven written so far. A slug can be legitimately named -- as a
# dependency, or in a bundle -- long before anyone specifies it, which is why
# `component-library` depending on `grid-and-layout` is correct rather than
# broken.
each_taxonomy_slug() {
  awk '
    /^\|[[:space:]]*[0-9]+[[:space:]]*\|/ {
      if (match($0, /`[a-z0-9-]+`/)) {
        slug = substr($0, RSTART + 1, RLENGTH - 2)
        if (!(slug in seen)) {
          seen[slug] = 1
          print slug
        }
      }
    }
  ' "$(spec_library_manifest)"
}

taxonomy_has() {
  local slug="$1"
  local known

  while IFS= read -r known; do
    if [[ "$known" == "$slug" ]]; then
      return 0
    fi
  done < <(each_taxonomy_slug)

  return 1
}

# ============================================================================
# ORDERS
# ============================================================================

# Expand a brief's order -- bundle names and bare slugs -- into a deduplicated
# list of `slug<TAB>origin`, in the sequence given.
#
# Order is preserved but carries no meaning. Design and venture work inform each
# other reciprocally, so a drop's assets are a set; the sequence here is just the
# sequence the brief listed them in, kept so the brief reads the way it was
# written.
#
# ORIGIN IS WHY THIS EMITS TWO FIELDS. It is the bundle that asked for a slug, or
# `-` for a slug the order named itself, and the difference decides what `brief`
# does when the library has no spec for it: a named slug is refused, a bundle
# member is omitted and declared. The library cannot make that call -- it is
# policy -- but only the library knows which of the two a slug arrived as, so the
# fact is emitted here and judged there.
expand_order() {
  local seen=" "
  local named=" "
  local item member origin

  # Pass one: which slugs did the order name in its own right?
  #
  # An explicitly named slug stays the loud case even when a bundle also happens
  # to contain it. Attributing by first-reached instead would hand such a slug to
  # whichever bundle got there first -- and since bundles are expanded before
  # bare assets, a slug the venture asked for by name would be quietly omitted
  # rather than refused. That is the exact failure the origin field exists to
  # prevent, so it must not be reintroduced by the order of the walk.
  for item in "$@"; do
    if ! bundle_exists "$item"; then
      named="$named$item "
    fi
  done

  for item in "$@"; do
    if bundle_exists "$item"; then
      while IFS= read -r member; do
        case "$seen" in
          *" $member "*) continue ;;
        esac
        seen="$seen$member "

        case "$named" in
          *" $member "*) origin="-" ;;
          *) origin="$item" ;;
        esac
        printf '%s\t%s\n' "$member" "$origin"
      done < <(each_bundle_member "$item")
    else
      case "$seen" in
        *" $item "*) continue ;;
      esac
      seen="$seen$item "
      printf '%s\t-\n' "$item"
    fi
  done

  return 0
}
