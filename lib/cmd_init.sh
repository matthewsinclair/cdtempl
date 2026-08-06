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
# its own repository and its own history, and the canon is explicit that no
# Cdsync protocol material belongs inside a project -- no `cdsync.json`, no
# `AGENTS.md`, no handover scaffolding. All four ported projects bear that out:
# not one of them carries a `cdsync.json`, and what they hold is the tree and
# nothing else.
#
# Before this command there was no way to say so. `bootstrap` refused over a
# tree that did not exist and advised `cdsync new <name>`, which would have
# created a second repository nested inside the first and written three files
# the canon forbids there. The advice was the only advice available and it was
# wrong, which is the tell for a missing command rather than a missing flag.
#
# So this does the one thing that was missing and nothing else: the directories,
# and the `.gitkeep` in each. `bootstrap` writes the document, `brief` orders the
# round, `install` lands the export. One job each.

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

  echo ""
  success "design system tree initialised at $target"
  echo ""
  info "next: cdsync bootstrap --target $target"
  info "then: commit the tree in the project's own repository"
}
