#!/usr/bin/env bash
#
# cdsync new - scaffold a venture
#
# ALL application knowledge lives in this module. Nothing else in cdsync knows
# what a Phoenix app is, and that confinement is what lets `import`, `check` and
# `site` stay dumb and therefore safe.
#
# WHAT IT DELIBERATELY DOES NOT DO: run `mix phx.new`, install Ash, or write a
# Laksa site config. Standing up an Elixir application is that toolchain's job and
# it does it better. A venture's stack is recorded here as a fact the agent
# contract can state, not reproduced as scaffolding this tool would then have to
# keep current with somebody else's generator.
#
# A generated venture is also not an Intent project in the full sense. It borrows
# CLAUDE.md and AGENTS.md as the agent contract but does not inherit intent/st/ --
# a design drop has documents, not steel threads.
#

CDSYNC_VENTURE_TEMPLATES="cdsync.json AGENTS.md CLAUDE.md README.md"

cmd_new() {
  local name=""
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
      -h|--help)
        show_help new
        return 0
        ;;
      -*)
        error "unknown option: $1"
        return 2
        ;;
      *)
        if [[ -n "$name" ]]; then
          error "only one venture may be created at a time"
          return 2
        fi
        name="$1"
        shift
        ;;
    esac
  done

  if [[ -z "$name" ]]; then
    error "usage: cdsync new <name> [--target PATH]"
    return 2
  fi

  case "$name" in
    */*|.|..)
      error "a venture name is a directory name, not a path: $name"
      return 2
      ;;
  esac

  local root="$PWD/$name"

  # Refuse a non-empty directory rather than merging into it. Scaffolding over
  # somebody's existing work is the same class of failure as a drop deleting a
  # file it did not know about, and it is just as hard to notice.
  if [[ -e "$root" ]]; then
    if [[ ! -d "$root" ]]; then
      error "$name already exists and is not a directory"
      return 1
    fi
    if [[ -n "$(ls -A "$root" 2>/dev/null)" ]]; then
      error "$name already exists and is not empty"
      echo "" >&2
      echo "  Refusing to scaffold over it. Move it aside, or pick another name." >&2
      return 1
    fi
  fi

  local templates="$CDSYNC_HOME/templates/venture"
  if [[ ! -d "$templates" ]]; then
    error "cannot find the venture templates at $templates"
    echo "  CDSYNC_HOME resolved to $CDSYNC_HOME -- is the installation intact?" >&2
    return 1
  fi

  mkdir -p "$root" || {
    error "could not create $root"
    return 1
  }

  local file
  for file in $CDSYNC_VENTURE_TEMPLATES; do
    render_venture_template "$templates/$file.tmpl" "$root/$file" "$name" || return 1
    echo "  create  $name/$file"
  done

  # The target skeleton. `.gitkeep` because git does not track an empty
  # directory, and an absent assets/ makes `cdsync check` report "no drop here"
  # rather than "nothing imported yet".
  local target target_rel
  target_rel="$(config_get '.target' "$root" 2>/dev/null || echo 'design')"
  if [[ -n "$flag_target" ]]; then
    target_rel="$flag_target"
  fi

  case "$target_rel" in
    /*) target="$target_rel" ;;
    *) target="$root/$target_rel" ;;
  esac

  local dir
  for dir in $CDSYNC_TARGET_DIRS; do
    mkdir -p "$target/$dir" || {
      error "could not create $target/$dir"
      return 1
    }
    : >"$target/$dir/.gitkeep"
    echo "  create  ${target#"$PWD"/}/$dir/"
  done

  write_venture_gitignore "$root" "$target_rel"
  echo "  create  $name/.gitignore"

  # A venture had the same hole an existing project did: the file above ignores
  # the generated site/ and .DS_Store, and nothing ignored the target's
  # _inbox/. So the first delivery archive dropped into a venture would have
  # been committed with it. Appends to the file just written rather than
  # carrying a second copy of the rule.
  write_target_inbox_gitignore "$target" || return 1

  init_venture_repo "$root"

  echo ""
  success "venture scaffolded at $root"
  echo ""
  info "next: fill in $name/cdsync.json -- especially 'fixed', 'open' and 'order'"
  info "then: cd $name && cdsync brief"
  echo ""
  echo "  The spec library holds specifications for these assets:" >&2
  each_spec | sed 's/^/    /' >&2
  echo "" >&2

  report_bundle_readiness

  return 0
}

# List the bundles, saying for each how much of it the library can actually brief.
#
# Listing the seven names under "usable in .order.bundles" and stopping there was
# worse than not mentioning them: no bundle is complete, so the reader picked one
# and found out one command later. The counts are here so the choice is made with
# the numbers in view.
#
# `partial` is a usable state, not a broken one -- `brief` orders what the library
# has and declares the rest absent in the document. `empty` is the only unusable
# one, because a brief carrying no specifications is not a brief.
report_bundle_readiness() {
  local bundle member total have missing incomplete=0

  echo "  Bundles for .order.bundles:" >&2

  while IFS= read -r bundle; do
    if [[ -z "$bundle" ]]; then continue; fi

    total=0
    have=0
    missing=""
    while IFS= read -r member; do
      if [[ -z "$member" ]]; then continue; fi
      total=$((total + 1))
      if spec_exists "$member"; then
        have=$((have + 1))
      else
        missing="$missing $member"
      fi
    done < <(each_bundle_member "$bundle")

    if [[ "$have" -eq "$total" ]]; then
      printf '    %-16s complete -- all %d specified\n' "$bundle" "$total" >&2
    elif [[ "$have" -eq 0 ]]; then
      printf '    %-16s empty -- none of its %d specified, cannot be briefed\n' \
        "$bundle" "$total" >&2
      incomplete=$((incomplete + 1))
    else
      printf '    %-16s partial -- %d of %d; absent:%s\n' \
        "$bundle" "$have" "$total" "$missing" >&2
      incomplete=$((incomplete + 1))
    fi
  done < <(each_bundle)

  if [[ "$incomplete" -gt 0 ]]; then
    echo "" >&2
    echo "  A partial bundle is orderable. The brief carries what the library has" >&2
    echo "  specified and states the rest as deliberately absent, because a partial" >&2
    echo "  set is a different ask from a whole one and the reader has to know which" >&2
    echo "  they were given. A slug you name yourself is held to a higher bar: if the" >&2
    echo "  library cannot specify it, the order is refused rather than trimmed." >&2
  fi

  return 0
}

# ============================================================================
# RENDERING
# ============================================================================

# Substitute {{VENTURE}} and write. Same token convention as the sibling tool's
# tmpl/ directory, so a template here reads the way one there does.
render_venture_template() {
  local src="$1"
  local dst="$2"
  local name="$3"

  if [[ ! -f "$src" ]]; then
    error "missing template: $src"
    return 1
  fi

  sed "s|{{VENTURE}}|$name|g" "$src" >"$dst" || {
    error "could not write $dst"
    return 1
  }
}

write_venture_gitignore() {
  local root="$1"
  local target_rel="$2"

  cat >"$root/.gitignore" <<EOF
# Generated by cdsync site. Rebuild it rather than committing it -- it is a view
# onto the target, and a stale committed copy is worse than none.
$target_rel/site/

.DS_Store
EOF
}

# A venture lives in its own repository, so that per-venture access is possible
# and one venture's confidential tree is never coupled to another's.
init_venture_repo() {
  local root="$1"

  if ! check_command git; then
    warn "git not found -- skipping repository initialisation"
    return 0
  fi

  if [[ -d "$root/.git" ]]; then
    return 0
  fi

  if ! git -C "$root" init --quiet 2>/dev/null; then
    warn "could not initialise a git repository in $root"
    return 0
  fi
  echo "  create  $(basename "$root")/.git/"

  # Commit the scaffold, because `git init` on its own leaves an unborn HEAD.
  # Until something is committed a fresh venture has no branch, so `git log`,
  # `git diff` and `git show` all fail in it -- which makes the first thing anyone
  # does in a newly scaffolded venture look like the scaffold is broken.
  #
  # It is also the commit worth having: the boundary between what the tool wrote
  # and what the venture decided, which is the diff anyone reviewing round one
  # actually wants.
  if ! git -C "$root" add -A 2>/dev/null; then
    warn "scaffolded, but could not stage it for the initial commit"
    return 0
  fi

  # Identity is deliberately not forced. Overriding user.name to get a commit
  # through would attribute the venture's first commit to a fabricated author,
  # and a warning the human can act on beats a repository quietly misattributed.
  if git -C "$root" commit --quiet -m "Scaffold $(basename "$root")" 2>/dev/null; then
    echo "  commit  $(basename "$root") scaffold"
  else
    warn "scaffolded and staged, but the initial commit failed -- is git user.name/user.email set?"
  fi

  return 0
}
