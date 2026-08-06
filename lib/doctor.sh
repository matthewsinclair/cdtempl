#!/usr/bin/env bash
#
# cdsync - diagnostics
#

# Dependencies cdsync needs, as `name|install hint|why` records.
#
# A plain newline-delimited string rather than an array: bash 3.2 is the
# floor here (macOS ships it), and expanding an empty array under `set -u`
# is an error there.
CDSYNC_DEPS="jq|brew install jq|read cdsync.json and kit/tokens.json
unzip|pre-installed on macOS|unpack a Claude Design drop
python3|pre-installed on macOS|serve the microsite"

run_doctor() {
  echo -e "${BOLD}cdsync doctor${RESET}"
  echo "============"
  echo ""

  local issues=0

  echo -e "${BOLD}[1/6]${RESET} CDSYNC_HOME"
  if [[ -z "${CDSYNC_HOME:-}" ]]; then
    error "CDSYNC_HOME is not set"
    issues=$((issues + 1))
  elif [[ ! -d "$CDSYNC_HOME" ]]; then
    error "CDSYNC_HOME points at a directory that does not exist: $CDSYNC_HOME"
    issues=$((issues + 1))
  else
    success "CDSYNC_HOME=$CDSYNC_HOME"
  fi
  echo ""

  echo -e "${BOLD}[2/6]${RESET} Installation"
  local missing=""
  local d
  for d in bin lib help; do
    if [[ ! -d "$CDSYNC_HOME/$d" ]]; then
      missing="$missing $d"
    fi
  done
  if [[ -n "$missing" ]]; then
    error "missing directories:$missing"
    issues=$((issues + 1))
  elif [[ ! -x "$CDSYNC_HOME/bin/cdsync" ]]; then
    error "bin/cdsync is not executable -- fix with: chmod +x $CDSYNC_HOME/bin/cdsync"
    issues=$((issues + 1))
  else
    success "bin, lib and help present; bin/cdsync executable"
  fi
  echo ""

  echo -e "${BOLD}[3/6]${RESET} PATH"
  case ":$PATH:" in
    *":$CDSYNC_HOME/bin:"*)
      success "\$CDSYNC_HOME/bin is on \$PATH"
      ;;
    *)
      if check_command cdsync; then
        success "cdsync is on \$PATH: $(command -v cdsync)"
      else
        warn "cdsync is not on \$PATH"
        echo "  Add to your shell config:" >&2
        echo "    export PATH=\"$CDSYNC_HOME/bin:\$PATH\"" >&2
        issues=$((issues + 1))
      fi
      ;;
  esac
  echo ""

  # Dependencies are gated once, here, rather than by each command as it runs.
  echo -e "${BOLD}[4/6]${RESET} Dependencies"
  local missing_deps=0
  local dep_name dep_hint dep_why
  while IFS='|' read -r dep_name dep_hint dep_why; do
    [[ -z "$dep_name" ]] && continue
    if check_command "$dep_name"; then
      success "$dep_name -- $dep_why"
    else
      error "$dep_name missing -- needed to $dep_why"
      echo "    install: $dep_hint" >&2
      missing_deps=$((missing_deps + 1))
    fi
  done <<EOF
$CDSYNC_DEPS
EOF
  if [[ $missing_deps -gt 0 ]]; then
    issues=$((issues + 1))
  fi
  echo ""

  # The spec library is what `brief` assembles from and what `check` compares a
  # drop against. Without it neither command can run, so a missing or empty
  # library is a broken installation rather than an empty state.
  echo -e "${BOLD}[5/6]${RESET} Spec library"
  local manifest specs
  manifest="$(spec_library_manifest)"
  if [[ ! -f "$manifest" ]]; then
    error "no spec library manifest at $manifest"
    issues=$((issues + 1))
  else
    specs="$(each_spec | grep -c . || true)"
    if [[ "$specs" -eq 0 ]]; then
      error "the spec library holds no specs -- nothing can be briefed"
      issues=$((issues + 1))
    else
      success "$specs specs, $(each_taxonomy_slug | grep -c . || true) taxonomy slugs, $(each_bundle | grep -c . || true) bundles"
      info "library version $(library_get spec_library_version || echo '?'), structure $(library_get target_structure_version || echo '?'), kit $(library_get kit_version || echo '?')"
    fi
  fi
  echo ""

  # The check most likely to catch a real surprise: which target resolved, and
  # whether it versions with the project.
  echo -e "${BOLD}[6/6]${RESET} Target"
  local target source
  if target="$(resolve_target "" "$PWD")" && source="$(target_source "" "$PWD")"; then
    describe_target "$target" "$source" "$PWD"
    if [[ ! -d "$target" ]]; then
      info "does not exist yet -- cdsync import will create it"
    fi
  else
    error "could not resolve a target"
    issues=$((issues + 1))
  fi
  echo ""

  echo "============"
  if [[ $issues -eq 0 ]]; then
    echo -e "${GREEN}${BOLD}ok: all checks passed${RESET}"
    return 0
  fi

  echo -e "${YELLOW}${BOLD}found $issues issue(s)${RESET}"
  return 1
}
