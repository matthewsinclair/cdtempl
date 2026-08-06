#!/usr/bin/env bash
#
# cdsync install - replace the target with an as-is drop, preserving what a drop
# cannot supply
#
# THE SECOND INSTALL PATH, and it exists because the first one cannot do this.
#
# `import` takes a CONVERTED drop -- a subset, five owned paths -- and merges it,
# leaving everything else in the target standing. That is exactly wrong for an
# as-is export, which IS the whole tree: import would write five paths and report
# the venture set, the microsite, the prototypes and the handoff tree as
# "ignored", delivering perhaps a tenth of the drop.
#
# So all four exports on 30 July 2026 were hand-unzipped over the tree instead,
# and that replace destroyed what the project had authored underneath: Baize lost
# a handoff file and eight ADR banners between its 09:49 and 16:29 drops, noticed
# only by someone seeing the files were gone. The two paths had opposite failure
# modes and there was no third. This is the third.
#
# WHY THERE IS NO BACKUP DIRECTORY
#
# The hand process copied each target to ~/Downloads/backup/ first, and it sat
# there for weeks as clutter nobody dared delete because nobody remembered
# whether it was the only copy. Swept on 31 July 2026: 1.3GB across 2607 files,
# of which 2287 were recoverable from the projects' own git object databases.
# The 320 that were not were intermediate round snapshots, never committed --
# so the backup was 96% redundant and 4% irreplaceable, mixed together with
# nothing to tell them apart. That is the failure mode, not the size.
#
# It is not needed. `design/system/` is tracked in full (see
# intent/docs/design-system-lifecycle.md), so git already holds every previous
# state of it. The tool's job is therefore not to make a copy but to GUARANTEE
# THE COPY GIT HOLDS IS COMPLETE before destroying anything -- which means
# refusing to run over a target with uncommitted or untracked content, because
# that is precisely the content git could not give back.
#
# The exception proves the rule: gitignored paths are preserved rather than
# replaced, because git cannot restore what it never tracked. `_inbox/` is the
# live case -- it is the drop-off point for delivery archives, which are
# ephemeral transport and so are not tracked, and replacing over it would
# destroy the archive currently being installed from.
#

if ! declare -F bootstrap_refresh >/dev/null 2>&1; then
  # shellcheck source=/dev/null
  source "$CDSYNC_HOME/lib/cmd_bootstrap.sh"
fi

cmd_install() {
  local src=""
  local flag_target=""
  local dry_run=0
  local assume_yes=0
  local force=0

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
      -y|--yes)
        assume_yes=1
        shift
        ;;
      --force)
        force=1
        shift
        ;;
      -h|--help)
        show_help install
        return 0
        ;;
      -*)
        error "unknown option: $1"
        return 2
        ;;
      *)
        if [[ -n "$src" ]]; then
          error "only one drop may be installed at a time"
          return 2
        fi
        src="$1"
        shift
        ;;
    esac
  done

  local target source
  target="$(resolve_target "$flag_target" "$PWD")" || return 2
  source="$(target_source "$flag_target" "$PWD")" || return 2

  # No archive named: take the newest in the target's _inbox/.
  #
  # `_inbox/` IS the drop-off point -- that is the whole of what it is for -- so
  # "drop the archive in and sync it" should be the literal interface rather than
  # a description of what someone does before typing a path. It resolves rather
  # than guesses: the chosen archive is printed, and an ambiguous or empty inbox
  # says so instead of picking.
  if [[ -z "$src" ]]; then
    src="$(install_newest_in_inbox "$target")" || return 2
    info "no archive named -- using the newest in _inbox/"
    info "  $(basename "$src")"
  fi

  describe_target "$target" "$source" "$PWD"
  echo ""

  drop_guard_contract || return 1

  local staged
  staged="$(stage_drop "$src")" || return 1

  install_validate_source "$staged" || {
    stage_cleanup "$staged" "$src"
    return 1
  }

  # Before the plan, so anything discarded shows up in a --dry-run too. Tracking
  # policy flows from the repo outward; see CDSYNC_DROP_REFUSED_FILES.
  drop_strip_refused "$staged" || {
    stage_cleanup "$staged" "$src"
    return 1
  }

  # The guard comes before the plan, not after. A plan printed over a target git
  # could not restore invites someone to say yes to it.
  if [[ "$force" -eq 0 ]]; then
    install_guard_recoverable "$target" || {
      stage_cleanup "$staged" "$src"
      return 1
    }
  fi

  install_show_plan "$staged" "$target"

  if [[ "$dry_run" -eq 1 ]]; then
    echo ""
    success "dry run -- nothing was written to $target"
    stage_cleanup "$staged" "$src"
    return 0
  fi

  if [[ "$assume_yes" -eq 0 ]]; then
    if ! install_confirm "$target"; then
      stage_cleanup "$staged" "$src"
      info "nothing was written"
      return 1
    fi
  fi

  install_execute "$staged" "$target"
  local status=$?

  # BOOTSTRAP-CD.md is only a guarantee if it is current, and it is only current
  # if every sync rewrites it. Hanging it here rather than on a command someone
  # remembers to run is the whole mechanism -- see lib/cmd_bootstrap.sh.
  if [[ "$status" -eq 0 ]]; then
    bootstrap_refresh "$target" "$source"
  fi

  stage_cleanup "$staged" "$src"
  return $status
}

# ============================================================================
# THE INBOX
# ============================================================================

# The newest archive in the target's `_inbox/`, or a refusal that says which.
#
# Newest by mtime rather than by name. The archives Claude Design produces carry
# a timestamp in the filename and sorting on that would usually agree -- but
# "usually" is how a tool ends up installing the wrong 380MB tree, and the
# filename is the supplier's convention rather than ours to depend on.
#
# Bash's own -nt does the comparison: no `stat` (whose flags differ between BSD
# and GNU) and no parsing of `ls` output, so a path with a space in it is
# handled by construction rather than by hoping.
install_newest_in_inbox() {
  local target="$1"
  local inbox="$target/_inbox"
  local f newest=""

  if [[ ! -d "$inbox" ]]; then
    error "no archive given, and there is no $inbox to take one from"
    echo "" >&2
    echo "  usage: cdsync install [zip|dir] [--target PATH] [--dry-run] [--yes] [--force]" >&2
    echo "" >&2
    echo "  Name an archive, or drop one in $inbox and run this again." >&2
    return 2
  fi

  for f in "$inbox"/*.zip; do
    [[ -f "$f" ]] || continue
    if [[ -z "$newest" || "$f" -nt "$newest" ]]; then
      newest="$f"
    fi
  done

  # AMBIGUITY IS REFUSED, because this picks what `install` will REPLACE the
  # whole tree with. `-nt` compares whole seconds under bash 3.2 -- which is
  # what /bin/bash is on macOS -- so two archives dropped in the same second
  # tie, and the loop above silently keeps whichever the glob reached first.
  # That is alphabetical order wearing the word "newest".
  #
  # Found by the CI matrix: ubuntu and a brewed bash resolve nanoseconds and
  # passed, macos-latest did not, and the tool installed the wrong archive.
  # A tie is genuinely unanswerable, so it is said rather than guessed.
  local tied=""
  for f in "$inbox"/*.zip; do
    [[ -f "$f" ]] || continue
    [[ "$f" == "$newest" ]] && continue
    if [[ ! "$newest" -nt "$f" ]]; then
      tied="$tied    $(basename "$f")"$'\n'
    fi
  done

  if [[ -n "$tied" ]]; then
    error "cannot tell which archive in $inbox is newest"
    echo "" >&2
    echo "    $(basename "$newest")" >&2
    printf '%s' "$tied" >&2
    echo "" >&2
    echo "  They share a timestamp. Name the one you mean:" >&2
    echo "    cdsync install <zip> --target $target" >&2
    return 2
  fi

  if [[ -z "$newest" ]]; then
    error "no archive given, and $inbox holds no .zip"
    echo "" >&2
    echo "  Drop the export in there and run this again, or name one directly." >&2
    return 2
  fi

  echo "$newest"
  return 0
}

# ============================================================================
# VALIDATION
# ============================================================================

# An as-is drop has NO CONTRACT, and that is a fact about the artefact rather
# than a gap in this function. It is whatever Claude Design exported: the four
# 30 July drops carry design-system/, venture/, handoff/, prototypes/ and a
# microsite, and not one of them would satisfy `drop_looks_valid` -- which is
# exactly why `cdsync check` refused three of the four.
#
# So there is nothing here to validate a shape against, and inventing a shape
# would refuse real drops. Safety comes from the three things around this
# instead: the archive was pre-flighted, the target is proven recoverable, and
# the plan is shown before anything is written. All this can honestly do is
# refuse a source with nothing in it.
install_validate_source() {
  local staged="$1"
  local count

  count="$(find "$staged" -mindepth 1 -maxdepth 1 -not -name '.DS_Store' -not -name '__MACOSX' 2>/dev/null | grep -c . || true)"

  if [[ "$count" -eq 0 ]]; then
    error "the source holds nothing to install"
    echo "" >&2
    echo "  Installing an empty tree over the target would delete the target" >&2
    echo "  and deliver nothing in its place." >&2
    return 1
  fi

  return 0
}

# ============================================================================
# RECOVERABILITY
# ============================================================================

# Refuse unless git can give the target back.
#
# This replaces the backup directory rather than supplementing it. A backup is a
# second copy someone has to find, trust and eventually delete; a clean git
# working tree is a copy that is already versioned, already pushed and already
# understood. The cost is that this command will not run over uncommitted work --
# which is the point, because uncommitted work is the only thing a replace can
# destroy irrecoverably.
install_guard_recoverable() {
  local target="$1"
  local repo dirty

  if [[ ! -d "$target" ]]; then
    return 0
  fi

  if ! repo="$(git -C "$target" rev-parse --show-toplevel 2>/dev/null)"; then
    warn "the target is not inside a git repository"
    echo "  Nothing can undo this install. Copy $target aside first if it" >&2
    echo "  holds anything you cannot reproduce from the archive." >&2
    echo "" >&2
    return 0
  fi

  # Tracked-and-modified AND untracked both count. An untracked file under the
  # target is no more recoverable than a modified one -- and repo-authored
  # untracked files are precisely what the last replace destroyed.
  dirty="$(git -C "$repo" status --porcelain -- "$target" 2>/dev/null || true)"

  if [[ -z "$dirty" ]]; then
    return 0
  fi

  error "the target holds changes git could not give back"
  echo "" >&2
  printf '%s\n' "$dirty" | head -10 | sed 's/^/    /' >&2 || true
  local total
  total="$(printf '%s\n' "$dirty" | grep -c . || true)"
  if [[ "$total" -gt 10 ]]; then
    echo "    ... and $((total - 10)) more" >&2
  fi
  echo "" >&2
  echo "  This install replaces the target, and git is what makes that" >&2
  echo "  reversible. Commit or stash the above first. If any of it is" >&2
  echo "  repo-authored material about the design, it belongs in" >&2
  echo "  $target/addenda/, which every install path preserves." >&2
  echo "" >&2
  echo "  --force proceeds anyway. It is not recoverable." >&2
  return 1
}

# ============================================================================
# WHAT SURVIVES
# ============================================================================

# Top-level entries under the target that the install must NOT replace.
#
# Two rationales, deliberately kept distinct in the output so neither gets
# re-litigated as the other:
#
#   declared  -- CDSYNC_DROP_PROTECTED_PATHS. Repo-authored, flows BACK to Claude
#                Design, never arrives from an export.
#   untracked -- gitignored. Preserved not because it is precious but because
#                git cannot restore it, so the recoverability argument that
#                permits this whole command does not cover it.
#
# Top level is the right granularity because the replace itself works at top
# level: every entry either survives whole or is removed whole.
install_protected_entries() {
  local target="$1"
  local entry name repo

  repo="$(git -C "$target" rev-parse --show-toplevel 2>/dev/null || true)"

  for entry in "$target"/*  "$target"/.[!.]*; do
    if [[ ! -e "$entry" ]]; then continue; fi
    name="$(basename "$entry")"

    if drop_path_is_protected "$name"; then
      echo "declared $name"
      continue
    fi

    if [[ -n "$repo" ]] && git -C "$repo" check-ignore -q "$entry" 2>/dev/null; then
      echo "untracked $name"
    fi
  done

  return 0
}

# ============================================================================
# THE PLAN
# ============================================================================

install_show_plan() {
  local staged="$1"
  local target="$2"
  local protected entry name reason kept

  protected="$(install_protected_entries "$target")"

  # Source entries: replacing something already there, or arriving new.
  while IFS= read -r entry; do
    if [[ -z "$entry" ]]; then continue; fi
    name="$(basename "$entry")"
    # A protected path NEVER arrives from a drop, whether or not the target
    # already has one. The alternative rule -- the drop's copy wins when the
    # target has none -- makes the outcome depend on the target's prior state,
    # so the same archive installs differently in two repositories and neither
    # says why. Discarding it always is the version nobody has to reason about.
    if drop_path_is_protected "$name"; then
      echo "  discard  $name  (repo-authored; a drop does not supply it)"
      continue
    fi
    if [[ -e "$target/$name" ]]; then
      echo "  replace  $name"
    else
      echo "  add      $name"
    fi
  done < <(install_each_entry "$staged")

  # Target entries the source does not carry: removed, unless protected.
  #
  # Reporting the removals is the half that matters. A replace that silently
  # drops what the new tree happens not to mention is the failure this command
  # was built to end, and a count would not have caught it -- Baize's loss was
  # nine files inside directories the drop DID carry.
  while IFS= read -r entry; do
    if [[ -z "$entry" ]]; then continue; fi
    name="$(basename "$entry")"

    kept="$(printf '%s\n' "$protected" | awk -v n="$name" '$2 == n { print $1 }')"
    if [[ -n "$kept" ]]; then
      if [[ "$kept" == "declared" ]]; then
        reason="repo-authored, declared protected"
      else
        reason="not tracked by git -- nothing else could restore it"
      fi
      echo "  keep     $name  ($reason)"
      continue
    fi

    if [[ ! -e "$staged/$name" ]]; then
      echo "  remove   $name"
    fi
  done < <(install_each_entry "$target")

  return 0
}

# Every top-level entry, dotfiles included, platform litter excluded.
install_each_entry() {
  local root="$1"
  local entry name

  if [[ ! -d "$root" ]]; then return 0; fi

  for entry in "$root"/* "$root"/.[!.]*; do
    if [[ ! -e "$entry" ]]; then continue; fi
    name="$(basename "$entry")"
    case "$name" in
      .DS_Store|__MACOSX) continue ;;
    esac
    echo "$entry"
  done

  return 0
}

install_confirm() {
  local target="$1"
  local reply

  echo "" >&2
  warn "this replaces the contents of $target"

  if [[ ! -t 0 ]]; then
    error "refusing to replace a tree without confirmation"
    echo "  Not running interactively. Pass --yes if this is what you want." >&2
    return 1
  fi

  printf 'Type "replace" to proceed: ' >&2
  read -r reply
  [[ "$reply" == "replace" ]]
}

# ============================================================================
# THE WRITE
# ============================================================================

install_execute() {
  local staged="$1"
  local target="$2"
  local protected held entry name written removed kept

  written=0
  removed=0
  kept=0

  if [[ ! -d "$target" ]]; then
    mkdir -p "$target" || {
      error "could not create the target: $target"
      return 1
    }
  fi

  protected="$(install_protected_entries "$target")"

  # Move the survivors out of the way rather than copying them: a move is atomic
  # per entry and cannot half-finish partway through a 200MB _inbox/.
  held="$(mktemp -d)" || {
    error "could not create a staging directory for the protected paths"
    return 1
  }

  while IFS= read -r entry; do
    if [[ -z "$entry" ]]; then continue; fi
    name="${entry#* }"
    if [[ -e "$target/$name" ]]; then
      mv "$target/$name" "$held/$name" || {
        error "could not set aside $name"
        rm -rf "$held"
        return 1
      }
      kept=$((kept + 1))
    fi
  done < <(printf '%s\n' "$protected" | grep . || true)

  # Clear whatever is left, then lay the drop down whole.
  while IFS= read -r entry; do
    if [[ -z "$entry" ]]; then continue; fi
    rm -rf "$entry" || {
      error "could not remove $entry"
      install_restore_held "$held" "$target"
      return 1
    }
    removed=$((removed + 1))
  done < <(install_each_entry "$target")

  while IFS= read -r entry; do
    if [[ -z "$entry" ]]; then continue; fi
    name="$(basename "$entry")"
    if drop_path_is_protected "$name"; then continue; fi
    if ! cp -R "$entry" "$target/$name"; then
      error "could not write $target/$name"
      install_restore_held "$held" "$target"
      return 1
    fi
    written=$((written + 1))
  done < <(install_each_entry "$staged")

  install_restore_held "$held" "$target" || return 1

  echo ""
  success "$written path(s) installed, $kept preserved, $removed replaced or removed"
  echo ""
  info "the design system is specification, not running code -- nothing in the app should read from $target"
  info "run 'cdsync check' if this drop is Cdsync-shaped; an as-is export is not, and will refuse"
  return 0
}

# Put the protected paths back. Called on the happy path AND from every failure
# above it -- a partial install that also ate addenda/ would be strictly worse
# than the hand replace this command exists to retire.
install_restore_held() {
  local held="$1"
  local target="$2"
  local entry name status=0

  for entry in "$held"/* "$held"/.[!.]*; do
    if [[ ! -e "$entry" ]]; then continue; fi
    name="$(basename "$entry")"
    rm -rf "${target:?}/$name"
    if ! mv "$entry" "$target/$name"; then
      error "could not restore $name -- it is in $held"
      status=1
    fi
  done

  if [[ "$status" -eq 0 ]]; then
    rm -rf "$held"
  fi

  return $status
}
