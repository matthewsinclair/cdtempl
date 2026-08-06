#!/usr/bin/env bash
#
# cdsync import - unpack a Claude Design drop into the target
#
# Deliberately dumb, and that is what makes it safe. It unpacks into
# $CDSYNC_TARGET and stops. It does not write into the application -- not
# assets/, not priv/static/, not lib/<app>_web/components/. The venture project
# takes what it needs out of the target on its own terms, by hand, with
# judgement.
#
# The target is the as-designed record; the app is the as-built. Import touching
# only the former is what keeps a later drop from clobbering work built on an
# earlier one.
#
# THE RULE THIS MODULE EXISTS TO ENFORCE: it writes only the paths Claude Design
# owns, listed once in lib/drop.sh, and never touches anything else in the
# target.
#
# That rule was learned rather than designed. A drop arrived without
# templprj/README.md -- the only statement anywhere in that directory of why the
# placeholder must be boring -- and syncing the drop over the target deleted it
# silently. Nothing removed it deliberately; a drop is simply the whole
# directory, so anything in the target and absent from the drop went with it.
# brief.md survived only because Claude Design echoes it back verbatim, which is
# a convention propping up a guarantee, and conventions do not hold.
#

if ! declare -F bootstrap_refresh >/dev/null 2>&1; then
  # shellcheck source=/dev/null
  source "$CDSYNC_HOME/lib/cmd_bootstrap.sh"
fi

cmd_import() {
  local zip=""
  local flag_target=""
  local dry_run=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --target)
        if [[ -z "${2:-}" ]]; then
          error "--target requires a path"
          return 2
        fi
        flag_target="$2"
        shift 2
        ;;
      --dry-run)
        dry_run=1
        shift
        ;;
      -h|--help)
        show_help import
        return 0
        ;;
      -*)
        error "unknown option: $1"
        return 2
        ;;
      *)
        if [[ -n "$zip" ]]; then
          error "only one drop may be imported at a time"
          return 2
        fi
        zip="$1"
        shift
        ;;
    esac
  done

  if [[ -z "$zip" ]]; then
    error "usage: cdsync import <zip|dir> [--target PATH] [--dry-run]"
    return 2
  fi

  local target source
  target="$(resolve_target "$flag_target" "$PWD")" || return 2
  source="$(target_source "$flag_target" "$PWD")" || return 2

  # Say which target resolved and whether it versions with the project, before
  # doing anything. A target outside the repo is correct for a confidential drop
  # and wrong by accident, and the difference is invisible unless stated.
  describe_target "$target" "$source" "$PWD"
  echo ""

  drop_guard_contract || return 1

  local staged
  staged="$(stage_drop "$zip")" || return 1

  validate_drop "$staged" || {
    stage_cleanup "$staged" "$zip"
    return 1
  }

  # Same declaration as install reads. import writes only the owned paths, so a
  # top-level .gitignore would not have landed anyway -- but one inside assets/
  # would, and "safe by accident of the owned list" is how addenda/ was
  # protected for a day before anything declared it.
  drop_strip_refused "$staged" || {
    stage_cleanup "$staged" "$zip"
    return 1
  }

  if [[ "$dry_run" -eq 1 ]]; then
    info "dry run -- nothing will be written"
    echo ""
  fi

  import_drop "$staged" "$target" "$dry_run"
  local status=$?

  stage_cleanup "$staged" "$zip"
  return $status
}

# ============================================================================
# VALIDATION
# ============================================================================

validate_drop() {
  local root="$1"

  if ! drop_looks_valid "$root"; then
    error "that does not look like a drop: no assets/ and no kit/ at its root"
    echo "" >&2
    echo "  A drop's top level is exactly what lands in the target:" >&2
    echo "    RETURN.md  index.md  kit/  assets/<slug>/  notes/" >&2
    return 1
  fi

  # RETURN.md is mandatory at the top of every drop, with a required
  # `revisions to understanding` heading, present-but-empty when there is
  # nothing to say. Design and venture work inform each other reciprocally and
  # non-linearly, so the most valuable thing in a round is sometimes a changed
  # mind rather than an artefact -- and an optional section for it would be
  # empty every time.
  if [[ ! -f "$root/RETURN.md" ]]; then
    error "no RETURN.md at the top of the drop"
    echo "" >&2
    echo "  It is mandatory on every drop. The most valuable thing in a round" >&2
    echo "  is sometimes a changed mind rather than an artefact, and a drop" >&2
    echo "  with nowhere to say so loses it." >&2
    return 1
  fi

  return 0
}

# ============================================================================
# THE WRITE
# ============================================================================

import_drop() {
  local staged="$1"
  local target="$2"
  local dry_run="$3"
  local written=0 skipped=0

  if [[ ! -d "$target" ]]; then
    if [[ "$dry_run" -eq 0 ]]; then
      mkdir -p "$target" || {
        error "could not create the target: $target"
        return 1
      }
    fi
    info "created target $target"
  fi

  local slug src dst file known

  # assets/<slug>/ -- replaced one slug at a time.
  #
  # Wholesale per slug, so a file renamed inside an asset does not linger as a
  # ghost. But ONLY the slugs this drop carries: a drop is an order of six to
  # ten assets, never the whole taxonomy, so anything already in the target and
  # absent here is an earlier drop's work and is left exactly alone.
  while IFS= read -r slug; do
    if [[ -z "$slug" ]]; then continue; fi
    src="$staged/assets/$slug"
    dst="$target/assets/$slug"

    if [[ "$dry_run" -eq 0 ]]; then
      mkdir -p "$target/assets"
      rm -rf "$dst"
      if ! cp -R "$src" "$dst"; then
        error "could not write $dst"
        return 1
      fi
    fi
    echo "  write   assets/$slug/"
    written=$((written + 1))
  done < <(each_drop_asset "$staged")

  # kit/ -- wholly Claude Design's, so replaced entire.
  if [[ -d "$staged/kit" ]]; then
    if [[ "$dry_run" -eq 0 ]]; then
      rm -rf "$target/kit"
      if ! cp -R "$staged/kit" "$target/kit"; then
        error "could not write $target/kit"
        return 1
      fi
    fi
    echo "  write   kit/"
    written=$((written + 1))
  fi

  # notes/ -- merged, never replaced.
  #
  # Notes are durable thinking rather than deliverables, so they accumulate
  # across rounds. Replacing the directory would discard round two's reasoning
  # because round four happened not to restate it.
  if [[ -d "$staged/notes" ]]; then
    if [[ "$dry_run" -eq 0 ]]; then
      mkdir -p "$target/notes"
    fi
    while IFS= read -r src; do
      if [[ -z "$src" ]]; then continue; fi
      if [[ "$dry_run" -eq 0 ]]; then
        if ! cp "$src" "$target/notes/"; then
          error "could not write $target/notes/$(basename "$src")"
          return 1
        fi
      fi
      echo "  write   notes/$(basename "$src")"
      written=$((written + 1))
    done < <(find "$staged/notes" -maxdepth 1 -type f 2>/dev/null | sort)
  fi

  # The two owned files at the drop root.
  for file in $CDSYNC_DROP_OWNED_FILES; do
    if [[ ! -f "$staged/$file" ]]; then continue; fi
    if [[ "$dry_run" -eq 0 ]]; then
      if ! cp "$staged/$file" "$target/$file"; then
        error "could not write $target/$file"
        return 1
      fi
    fi
    echo "  write   $file"
    written=$((written + 1))
  done

  # Everything else in the drop is reported and NOT written. Silence here would
  # be the same failure this module exists to prevent, pointed the other way: a
  # drop carrying something that nobody notices was dropped.
  while IFS= read -r file; do
    if [[ -z "$file" ]]; then continue; fi
    # A protected path in a DROP is reported apart from the general ignore
    # list, because it means something different. `addenda/` is repo-authored
    # and flows the other way -- back to Claude Design, retiring when a drop
    # absorbs it -- so a drop carrying one is either an echo or a sign the
    # round absorbed it. Lumping that in with "sits outside what a drop owns"
    # buries the one line worth reading.
    if drop_path_is_protected "$(basename "$file")"; then
      echo "  protect ${file#"$staged"/}  (repo-authored; the target's copy stands)"
      skipped=$((skipped + 1))
      continue
    fi
    echo "  ignore  ${file#"$staged"/}"
    skipped=$((skipped + 1))
  done < <(each_unowned_path "$staged")

  echo ""
  if [[ "$skipped" -gt 0 ]]; then
    warn "$skipped path(s) in the drop sit outside what a drop owns, and were not written"
  fi

  if [[ "$dry_run" -eq 1 ]]; then
    success "dry run -- $written path(s) would be written to $target"
    return 0
  fi

  # Both install paths regenerate it, for the reason in lib/cmd_bootstrap.sh:
  # its currency has to be continuous or the guarantee it states is only a claim.
  bootstrap_refresh "$target"

  success "$written path(s) written to $target"
  echo ""
  info "nothing else in the target was touched. Run 'cdsync check' to hold the drop against its specs."
  return 0
}

# Emit every top-level entry in a drop that is not one of the owned paths.
each_unowned_path() {
  local staged="$1"
  local entry name owned known

  for entry in "$staged"/*; do
    if [[ ! -e "$entry" ]]; then continue; fi
    name="$(basename "$entry")"
    case "$name" in
      .DS_Store|__MACOSX) continue ;;
    esac

    owned=0
    for known in $CDSYNC_DROP_OWNED_DIRS $CDSYNC_DROP_OWNED_FILES; do
      if [[ "$name" == "$known" ]]; then
        owned=1
        break
      fi
    done

    if [[ "$owned" -eq 0 ]]; then
      echo "$entry"
    fi
  done

  return 0
}
