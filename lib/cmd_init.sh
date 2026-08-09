#!/usr/bin/env bash
# ============================================================================
# cdsync init -- start a design system inside a repository that already exists
# ============================================================================
#
# `new` scaffolds a VENTURE: its own repository, `cdsync.json`, the agent
# contract, and the target skeleton underneath. That is the right shape when the
# venture is the new thing.
#
# It is the wrong shape when the project is already there. An existing site has
# its own repository and its own history, and no agent contract or nested
# repository belongs inside it -- the canon's no-protocol-material rule. The
# design tree is the one Cdsync-owned carve-out in such a project, and
# `cdsync.json` lives at its root -- one home for `new` ventures and `init`
# projects alike (hv, 9 Aug 2026). That ruling superseded the older reading
# under which an init'd project carried no `cdsync.json` at all, which left
# `brief` unrunnable there and scope supplied by hand.
#
# Before this command there was no way to start a tree at all. `bootstrap`
# refused over a tree that did not exist and advised `cdsync new <name>`, which
# would have created a second repository nested inside the first and written an
# agent contract the canon forbids there. The advice was the only advice
# available and it was wrong, which is the tell for a missing command rather
# than a missing flag.
#
# So this does the small set of things that were missing and nothing else: the
# directories, the `.gitkeep` in each, and the venture's `cdsync.json` stub at
# the tree root. `bootstrap` writes the document, `brief` orders the round,
# `install` lands the export. One job each.

# The skeleton is three directories and a `.gitkeep` apiece. `.gitkeep` because
# git does not track an empty directory, and an absent `assets/` makes
# `cdsync check` report "no drop here" rather than "nothing imported yet" -- the
# same reason `new` writes them.
cmd_init() {
  local flag_target=""

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
      -h | --help)
        show_help init
        return 0
        ;;
      *)
        error "unknown option: $1"
        return 2
        ;;
    esac
  done

  local target source
  target="$(resolve_target "$flag_target" "$PWD")" || return 2
  source="$(target_source "$flag_target" "$PWD")" || return 2

  describe_target "$target" "$source" "$PWD"
  echo ""

  # REFUSING OVER A POPULATED TREE IS THE WHOLE SAFETY STORY HERE. This command
  # creates directories, so on its own it can only ever add -- but a silent
  # success over a tree that already holds a drop would read as "initialised"
  # when nothing was, and the next step is a bootstrap that would then describe
  # a cold start over a warm tree. Cold or warm is measured, never declared,
  # and this is where the measurement happens.
  if [[ -d "$target" ]] && [[ -n "$(ls -A "$target" 2>/dev/null)" ]]; then
    error "target already exists and is not empty: $target"
    echo "  init starts a design system; it does not adopt one." >&2
    echo "  To regenerate the document over a tree that already holds a drop:" >&2
    echo "    cdsync bootstrap --target $target" >&2
    return 1
  fi

  local dir
  for dir in $CDSYNC_TARGET_DIRS; do
    mkdir -p "$target/$dir" || {
      error "could not create $target/$dir"
      return 1
    }
    : >"$target/$dir/.gitkeep"
    echo "  create  $dir/"
  done

  # The one thing written outside the target, and it has to be. `install`
  # replaces the target wholesale, so a guard living inside it would not
  # survive the first delivery it is meant to protect against.
  write_target_inbox_gitignore "$target" || return 1

  # The venture's cdsync.json, at the tree root. This is what makes `brief`
  # runnable for a project Cdsync does not own -- scope used to be supplied by
  # hand for exactly this case. Protected from every install path, so the
  # first delivery cannot eat it.
  # Named after the TARGET'S repository, not the working directory -- the tree
  # belongs to the project that owns it, which is the same lesson the
  # numbering scan already carries.
  local venture
  venture="$(basename "$(git -C "$(dirname "$target")" rev-parse --show-toplevel 2>/dev/null || echo "$target")")"
  render_venture_template "$CDSYNC_HOME/templates/venture/$CDSYNC_CONFIG_NAME.tmpl" \
    "$target/$CDSYNC_CONFIG_NAME" "$venture" || return 1
  echo "  create  $CDSYNC_CONFIG_NAME"

  echo ""
  success "design system tree initialised at $target"
  echo ""
  info "next: fill in $target/cdsync.json -- especially 'fixed', 'open' and 'order'"
  info "then: cdsync bootstrap --target $target"
  info "then: commit the tree in the project's own repository"
}
