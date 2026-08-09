#!/usr/bin/env bash
#
# cdsync brief - assemble the brief for Claude Design
#
# One generator, two outlets: written to $CDSYNC_TARGET/brief.md, and with
# --stdout also emitted for pasting. Whether the brief reaches Claude Design by
# upload or by being read out of the target it is scoped to is transport, not
# content -- letting the paste path grow its own format would produce two
# specifications that drift.
#
# THE BRIEF CARRIES EVERYTHING ITS ROUND NEEDS. That is the rule, and it is a
# principle rather than a workaround for today's access arrangement.
#
# Claude Design is scoped to one directory and cannot read this repository. If it
# could, briefs would drift toward being thin and reference-rich -- pointers to
# specs, to design docs, to steel threads. That works now and breaks completely
# the day Claude Design is scoped to a real venture, where Cdsync's internals
# genuinely are not visible. So the constraint is held deliberately, and it is
# what makes this command an assembler rather than a list of links: a pointer to
# a file the reader cannot open is a hole in the brief, not a reference.
#
# Which is also why every ordered asset's full specification is inlined, always,
# with no shorter mode. A brief that is complete only sometimes is a brief nobody
# can trust without checking, and regular and predictable is the whole point of
# this tool -- ahead of being automated, and well ahead of being terse.
#

cmd_brief() {
  local to_stdout=0
  local flag_target=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --stdout)
        to_stdout=1
        shift
        ;;
      --target)
        if [[ -z "${2:-}" ]]; then
          error "--target requires a path"
          return 2
        fi
        flag_target="$2"
        shift 2
        ;;
      -h|--help)
        show_help brief
        return 0
        ;;
      *)
        error "unknown option: $1"
        return 2
        ;;
    esac
  done

  require_jq || return 2

  local target source
  target="$(resolve_target "$flag_target" "$PWD")" || return 2
  source="$(target_source "$flag_target" "$PWD")" || return 2

  # cdsync.json lives at the tree root (hv, 9 Aug 2026), so the resolved target
  # is where the venture's facts are read from. Bound once; every config reader
  # below defaults to it. Consumed across the sourced-file boundary by
  # config.sh's config_path, which shellcheck cannot see from here -- the same
  # shape as CDSYNC_TARGET_DIRS in target.sh. Deliberately not exported: it is
  # Cdsync's own state, not something a child process should inherit.
  # shellcheck disable=SC2034
  CDSYNC_CONFIG_DIR="$target"

  if ! config_exists "$target"; then
    error "no cdsync.json in the target: $target"
    echo "" >&2
    if [[ -f "$PWD/$CDSYNC_CONFIG_NAME" ]]; then
      echo "  There is one at the project root, which was its old home. It lives at" >&2
      echo "  the design tree root now -- move it:" >&2
      echo "    mv $CDSYNC_CONFIG_NAME ${target#"$PWD"/}/$CDSYNC_CONFIG_NAME" >&2
    else
      echo "  A brief is assembled from the venture's own facts. Run 'cdsync new'," >&2
      echo "  or write ${target#"$PWD"/}/$CDSYNC_CONFIG_NAME -- see 'cdsync help brief' for the fields." >&2
    fi
    return 2
  fi

  local venture
  venture="$(config_get '.venture')" || {
    error "cdsync.json has no .venture"
    return 2
  }

  # Expand the order before writing anything, so an unbriefable slug is decided
  # here rather than becoming a hole in a document already on disk.
  local order expanded
  order="$(config_list '.order.bundles') $(config_list '.order.assets')"

  # Word-splitting is what is wanted here: the order is a list of names.
  # shellcheck disable=SC2086
  expanded="$(expand_order $order)"

  if [[ -z "$expanded" ]]; then
    error "cdsync.json orders nothing -- set .order.bundles or .order.assets"
    return 2
  fi

  local slugs="" unspecified="" omitted="" refused="" slug origin
  while IFS=$'\t' read -r slug origin; do
    if [[ -z "$slug" ]]; then continue; fi

    if spec_exists "$slug"; then
      slugs="$slugs$slug"$'\n'
    elif [[ "$origin" == "-" ]]; then
      if taxonomy_has "$slug"; then
        unspecified="$unspecified$slug"$'\n'
      else
        refused="$refused $slug"
      fi
    else
      omitted="$omitted$slug"$'\t'"$origin"$'\n'
    fi
  done < <(printf '%s\n' "$expanded")

  slugs="${slugs%$'\n'}"
  unspecified="${unspecified%$'\n'}"
  omitted="${omitted%$'\n'}"

  # A named slug OUTSIDE the taxonomy is a refusal: the taxonomy is the identity
  # space, and a type it does not name is added to the library, never invented by
  # an order. A named slug the taxonomy holds and the library has not specified
  # is different, and is ordered -- the round creates the asset and stamps
  # `spec_version: unassigned` (hv, 9 Aug 2026). The old refusal covered both,
  # and existed only because the brief could not say what a new asset stamps.
  if [[ -n "$refused" ]]; then
    error "ordered by name but not in the taxonomy:$refused"
    echo "" >&2
    echo "  The taxonomy names $(taxonomy_count) asset types and is the identity space:" >&2
    echo "  a slug it holds may be ordered even before the library specifies it, but" >&2
    echo "  a new TYPE is added to the library first, not invented by an order." >&2
    return 2
  fi

  # The kit is carried by every brief, ordered or not, so its absence from the
  # library is a broken installation rather than a bad order.
  if ! spec_exists kit; then
    error "the spec library has no 'kit' entry"
    echo "" >&2
    echo "  Every brief inlines the kit in full. Every other artefact restates its" >&2
    echo "  values literally, so a brief without it asks its reader to invent the one" >&2
    echo "  artefact that exists to prevent invention everywhere else." >&2
    return 1
  fi

  # Reached only by bundle expansion: a named unspecified slug is ordered above,
  # so an empty pair here means every bundle member fell to the omission list.
  if [[ -z "$slugs" && -z "$unspecified" ]]; then
    error "nothing this order reached has a specification yet"
    echo "" >&2
    echo "  Every asset the order expanded to is unspecified, so there is no brief" >&2
    echo "  to assemble -- a brief carries the specification itself, and this one" >&2
    echo "  would carry none. Name a slug directly to order it ahead of the library." >&2
    echo "" >&2
    echo "  The library holds a spec for each of these:" >&2
    each_spec | sed 's/^/    /' >&2
    return 2
  fi

  describe_target "$target" "$source" "$PWD"
  echo ""

  if [[ ! -d "$target" ]]; then
    mkdir -p "$target" || {
      error "could not create the target: $target"
      return 1
    }
  fi

  # Composed once, then routed. Composing twice for the two outlets is how the
  # written brief and the pasted one start to differ.
  local document
  document="$(compose_brief "$venture" "$slugs" "$unspecified" "$omitted" "$target")"

  # Atomic. The original reason given for this was wrong and is withdrawn --
  # Claude Design does not read the working tree. The behaviour stays because it
  # costs nearly nothing, because handing a human a half-written brief to upload
  # is its own failure, and because that failure would be silent.
  printf '%s\n' "$document" | atomic_write "$target/brief.md" || return 1

  success "brief written to $target/brief.md"

  local n_spec n_unspec
  n_spec="$(printf '%s\n' "$slugs" | grep -c . || true)"
  n_unspec="$(printf '%s\n' "$unspecified" | grep -c . || true)"
  if [[ "$n_unspec" -gt 0 ]]; then
    info "$((n_spec + n_unspec)) assets ordered ($n_unspec ahead of the library, stamped unassigned), against spec library version $(library_get spec_library_version)"
  else
    info "$n_spec assets ordered, against spec library version $(library_get spec_library_version)"
  fi

  # Said out here as well as in the document. The brief states the omission for
  # its reader; this states it for whoever is about to send the brief, who is the
  # only person who can decide the partial set is not what they wanted.
  if [[ -n "$omitted" ]]; then
    warn "$(printf '%s\n' "$omitted" | grep -c .) bundle members omitted -- unspecified, and declared as absent in the brief"
    printf '%s\n' "$omitted" | awk -F'\t' '{ printf "    %s (asked for by %s)\n", $1, $2 }' >&2
  fi

  if [[ "$to_stdout" -eq 1 ]]; then
    printf '%s\n' "$document"
  fi

  return 0
}

# ============================================================================
# COMPOSITION
# ============================================================================

compose_brief() {
  local venture="$1"
  local slugs="$2"
  local unspecified="$3"
  local omitted="$4"
  local target="$5"

  # The present-in-target check and the prerequisites walk cover everything
  # ordered, specified or not -- an unspecified asset already in the target is
  # exactly the rebuild-and-replace hazard the round-job section warns about.
  local ordered_all
  ordered_all="$(printf '%s\n%s\n' "$slugs" "$unspecified" | grep . || true)"

  brief_header "$venture"
  brief_venture_facts "$venture"
  brief_round_job "$ordered_all" "$target"
  brief_order "$slugs" "$omitted"
  brief_unspecified "$unspecified"
  brief_prerequisites "$ordered_all" "$target"
  brief_structure
  brief_kit "$target"
  brief_specifications "$slugs"
  brief_gaps
  brief_numbering "$target"
  brief_return_contract "$venture"
}

brief_header() {
  local venture="$1"

  echo "---"
  echo "venture: \"$venture\""
  brief_field one_liner '.one_liner'
  brief_field stage '.stage'
  brief_field round '.round'
  brief_field round_job '.round_job'
  echo "spec_library_version: $(library_get spec_library_version)"
  echo "target_structure_version: $(library_get target_structure_version)"
  echo "kit_version: $(library_get kit_version)"
  brief_field locale '.locale'
  brief_field currency '.currency'
  brief_field accessibility_target '.accessibility_target'
  brief_field invention '.invention'
  brief_field numbers '.numbers'
  brief_field effort '.effort'
  brief_field inherits_from '.inherits_from'
  brief_inline_list formats_required '.formats_required'
  echo "---"
}

# Emit `key: value` only when the venture actually declared it. A header full of
# empty fields trains its reader to skim, and the header is where the two fields
# that matter most live.
brief_field() {
  local key="$1"
  local query="$2"
  local value

  if value="$(config_get "$query")"; then
    echo "$key: \"$value\""
  fi
}

brief_inline_list() {
  local key="$1"
  local query="$2"
  local items

  items="$(config_list "$query" | tr '\n' ',' | sed 's/,$//; s/,/, /g')"
  if [[ -n "$items" ]]; then
    echo "$key: [$items]"
  fi
}

brief_venture_facts() {
  local venture="$1"
  local round value

  round="$(config_get '.round' || echo '1')"

  echo "# Brief -- $venture, round $round"
  echo ""
  echo "Everything this round needs is in this document. Nothing in it points at a"
  echo "file you cannot open."
  echo ""

  if value="$(config_get '.one_liner')"; then
    echo "## The venture"
    echo ""
    echo "$value"
    echo ""
  fi

  if value="$(config_get '.changed_since_last')"; then
    echo "## What changed since the last round"
    echo ""
    echo "$value"
    echo ""
  fi

  # `fixed` and `open` carry more weight than the rest of the brief combined.
  # Almost every failure in this class of work is one of two things: something
  # was invented that had already been decided, or a blank was left where
  # invention was expected. These two lists close both.
  echo "## Fixed -- decided, do not re-invent"
  echo ""
  if config_list '.fixed' | grep -q .; then
    config_list '.fixed' | sed 's/^/- /'
  else
    echo "- _Nothing declared fixed. If that is deliberate, say so -- an empty_"
    echo "  _fixed list otherwise reads as licence to invent everything._"
  fi
  echo ""

  echo "## Open -- licensed to invent"
  echo ""
  if config_list '.open' | grep -q .; then
    config_list '.open' | sed 's/^/- /'
  else
    echo "- _Nothing declared open._"
  fi
  echo ""

  echo "## Invention and numbers"
  echo ""
  echo "| Question | Answer |"
  echo "|---|---|"
  echo "| May facts be invented, or must blanks be left? | $(config_get '.invention' || echo 'NOT STATED -- leave blanks') |"
  echo "| Are numbers real or illustrative? | $(config_get '.numbers' || echo 'NOT STATED -- treat as illustrative') |"
  echo ""
  echo "These are the two most expensive omissions in this class of work. A"
  echo "plausible invented number is worse than an obvious blank, because it"
  echo "survives into a document someone acts on. Illustrative numbers must be"
  echo "**visibly marked in the artefact**, not merely understood in conversation --"
  echo "\`cdsync check\` enforces that, so an unmarked number fails the drop rather"
  echo "than reaching a reader."
  echo ""
}

# State what this round is FOR, and what it already has to work from.
#
# THE GAP THIS CLOSES. Every brief this tool had ever written said "build these",
# in that voice, with no way to say anything else. A repackaging round -- one
# whose job is to reshape what already exists rather than make something new --
# could not be expressed at all, so the only way to order one was to order a
# build and explain the difference out of band. Which is exactly the shape this
# project keeps finding: the document explains a field and never supplies its
# value, and the supplier reasonably does the one thing the document describes.
#
# TWO HALVES, AND THEY ARE DIFFERENT KINDS OF FACT.
#
# `round_job` is DECLARED, because a round's purpose is not derivable from the
# tree. An asset already existing does not say whether this round repackages it,
# revises it, extends it or corrects it -- four different jobs with one
# filesystem signature. Free text rather than an enum, matching `effort` and
# `inherits_from`, because nobody has ordered a vocabulary and inventing one here
# would be this tool deciding what kinds of round exist.
#
# What is already in the target is MEASURED, and it is worth stating in every
# round rather than only in repackaging ones. The brief could always see it --
# `brief_prerequisites` has tested that same path all along -- and never said so,
# so a supplier ordered a slug that already existed had no way to know it was not
# starting from nothing. That is a rebuild-and-replace waiting to happen, and it
# is silent when it happens.
brief_round_job() {
  local slugs="$1"
  local target="$2"
  local job slug present=""

  while IFS= read -r slug; do
    if [[ -z "$slug" ]]; then continue; fi
    if [[ -d "$target/assets/$slug" ]]; then
      present="$present$slug"$'\n'
    fi
  done < <(printf '%s\n' "$slugs")

  present="${present%$'\n'}"
  job="$(config_get '.round_job' || true)"

  if [[ -z "$job" && -z "$present" ]]; then
    return 0
  fi

  echo "## What this round is for"
  echo ""

  if [[ -n "$job" ]]; then
    echo "$job"
    echo ""
  else
    echo "_The venture did not say. Treat it as a build unless something below_"
    echo "_contradicts that, and say in \`RETURN.md\` if the material suggested_"
    echo "_otherwise._"
    echo ""
  fi

  if [[ -z "$present" ]]; then
    echo "**Nothing you have been ordered is in the target yet.** Every asset below"
    echo "is being made for the first time."
    echo ""
    return 0
  fi

  echo "**Already in the target, and ordered again:**"
  echo ""

  while IFS= read -r slug; do
    if [[ -z "$slug" ]]; then continue; fi
    # Literal markdown backticks -- a list item, not command substitution.
    # shellcheck disable=SC2016
    printf -- '- `%s`\n' "$slug"
  done < <(printf '%s\n' "$present")

  echo ""
  echo "**These exist. Work from them rather than starting again**, unless the job"
  echo "above says otherwise. What you deliver replaces what is there, so an asset"
  echo "rebuilt from scratch silently discards whatever the existing one had that"
  echo "you did not know to reproduce -- and neither side would see it happen."
  echo ""
  echo "If reworking one turns out to be the wrong call, say so in \`RETURN.md\` and"
  echo "deliver the rebuild. **The point is that it be a decision rather than a"
  echo "default.**"
  echo ""
}

brief_order() {
  local slugs="$1"
  local omitted="$2"
  local slug bundles assets spec

  echo "## The order"
  echo ""

  bundles="$(join_words "$(config_list '.order.bundles')")"
  assets="$(join_words "$(config_list '.order.assets')")"

  if [[ -n "$bundles" ]]; then
    echo "Bundles: $bundles"
  fi
  if [[ -n "$assets" ]]; then
    echo "Named assets: $assets"
  fi
  echo ""
  echo "Expanded, in full:"
  echo ""
  echo "| Slug | Name | Form | Tier | Audience |"
  echo "|---|---|---|---|---|"

  while IFS= read -r slug; do
    if [[ -z "$slug" ]]; then continue; fi
    spec="$(spec_path "$slug")" || continue
    # The backticks are literal markdown -- this is a table row, not command
    # substitution -- and single quotes are what keeps them literal.
    # shellcheck disable=SC2016
    printf '| `%s` | %s | %s | %s | %s |\n' \
      "$slug" \
      "$(fm_get "$spec" name || echo '?')" \
      "$(fm_get "$spec" form || echo '?')" \
      "$(fm_get "$spec" tier || echo '?')" \
      "$(fm_list "$spec" audience | tr '\n' ',' | sed 's/,$//; s/,/, /g')"
  done < <(printf '%s\n' "$slugs")

  echo ""
  brief_omissions "$omitted"
  echo "**The sequence above carries no meaning.** Design and venture work inform"
  echo "each other reciprocally and non-linearly, so this is a set. Work it in"
  echo "whatever order the material suggests, and say in \`RETURN.md\` if working one"
  echo "asset changed your view of another."
  echo ""
}

# Assets ordered ahead of their specification.
#
# The library cannot supply what the round is creating, so this section stands
# where their specifications would: the round defines the asset, its `spec.md`
# declares what done means, and the stamp is `unassigned` -- the literal word --
# because a number nobody issued cannot measure anything. When the library later
# gains the specification, `check` rule 2 flags the asset for rebuild against
# it, which is the intended lifecycle rather than an error. Ruled by hv on
# 9 Aug 2026; until then a named unspecified slug was refused outright, which
# made a genuinely new asset unorderable -- the WP-08 chicken-and-egg.
brief_unspecified() {
  local unspecified="$1"
  local slug

  if [[ -z "$unspecified" ]]; then
    return 0
  fi

  echo "## Ordered ahead of the library -- no specification exists yet"
  echo ""
  echo "The taxonomy names these and the library has not specified them, so **this"
  echo "round creates them**. No specification for them appears below, and that is"
  echo "deliberate rather than an omission:"
  echo ""
  while IFS= read -r slug; do
    if [[ -z "$slug" ]]; then continue; fi
    # Literal markdown backticks -- a list item, not command substitution.
    # shellcheck disable=SC2016
    printf -- '- `%s`\n' "$slug"
  done < <(printf '%s\n' "$unspecified")
  echo ""
  echo "For each of these:"
  echo ""
  echo "- **Define the asset as you build it.** Its \`spec.md\` is the statement of"
  echo "  what done means, exactly as for a specified asset, in the format the"
  echo "  output-structure section requires."
  echo "- **Stamp \`spec_version: unassigned\` -- the literal word.** There is no"
  echo "  specification to copy a number from, and a number you choose yourself is"
  echo "  the revision counter the versions section warns about. When the library"
  echo "  gains a specification for it, the check will ask for a rebuild against"
  echo "  it -- that is the intended lifecycle, not a fault."
  echo "- **\`kit_version\` follows the kit as usual.**"
  echo ""
}

# Declare what a bundle asked for and the library could not supply.
#
# A bundle names a group, and its membership is the library's business rather than
# the venture's. Refusing a whole order because the library has not caught up
# punishes the reader for someone else's gap, so the order proceeds with what
# exists -- but it cannot proceed silently. A partial seed set is a different ask
# from a whole one, and a reader who is not told will infer that the absences were
# deliberate scope and quietly design around them. Stating it costs four lines and
# removes the inference.
#
# A slug the order named itself is the other case, and `brief` refuses that one
# outright before reaching here.
brief_omissions() {
  local omitted="$1"
  local slug origin

  if [[ -z "$omitted" ]]; then
    return 0
  fi

  echo "**Not in this drop, and asked for.** The library has no specification for"
  echo "these yet, so they are deliberately absent rather than overlooked:"
  echo ""
  echo "| Slug | Asked for by |"
  echo "|---|---|"

  while IFS=$'\t' read -r slug origin; do
    if [[ -z "$slug" ]]; then continue; fi
    # Literal markdown backticks, as above.
    # shellcheck disable=SC2016
    printf '| `%s` | `%s` |\n' "$slug" "$origin"
  done < <(printf '%s\n' "$omitted")

  echo ""
  echo "**Treat the set above as partial, not as the whole.** Their absence changes"
  echo "what the present assets have to carry. Where one of them would have held"
  echo "something, leave the blank and say so in \`RETURN.md\` rather than absorbing"
  echo "it into a neighbouring asset -- an absent asset silently covered by its"
  echo "neighbour is the hardest kind of scope drift to find later."
  echo ""
}

# Declare hard dependencies the order does not satisfy.
#
# A spec's `depends_on.hard_assets` says what must exist before the asset can be
# finished. The brief used to render that as a line of prose per asset and proceed,
# which meant an order could require three systems nobody had built and say so only
# in passing -- and the consequence surfaced in the drop rather than in the brief.
#
# Declared rather than refused, the same way an absent bundle member is. The drop is
# still worth making: what an asset actually inherits, absent a colour system, is the
# neutral kit, and that is fine as long as somebody chose it. The point is that it be
# a choice made here rather than a discovery made later.
brief_prerequisites() {
  local slugs="$1"
  local target="$2"
  local ordered=" " slug spec dep unsatisfied=""

  while IFS= read -r slug; do
    if [[ -z "$slug" ]]; then continue; fi
    ordered="$ordered$slug "
  done < <(printf '%s\n' "$slugs")

  while IFS= read -r slug; do
    if [[ -z "$slug" ]]; then continue; fi
    spec="$(spec_path "$slug")" || continue

    while IFS= read -r dep; do
      if [[ -z "$dep" ]]; then continue; fi

      # Satisfied by this same order: the drop builds its own prerequisite.
      case "$ordered" in
        *" $dep "*) continue ;;
      esac

      # Already in the target from an earlier round.
      if [[ -d "$target/assets/$dep" ]]; then continue; fi

      unsatisfied="$unsatisfied$slug"$'\t'"$dep"$'\n'
    done < <(fm_list "$spec" depends_on.hard_assets)
  done < <(printf '%s\n' "$slugs")

  unsatisfied="${unsatisfied%$'\n'}"

  if [[ -z "$unsatisfied" ]]; then
    return 0
  fi

  echo "## Prerequisites this order does not meet"
  echo ""
  echo "Each ordered asset below declares something that must exist first. It is"
  echo "neither in this order nor already in the target:"
  echo ""
  echo "| Ordered asset | Declares it needs | Note |"
  echo "|---|---|---|"

  while IFS=$'\t' read -r slug dep; do
    if [[ -z "$slug" ]]; then continue; fi
    # Literal markdown backticks, as above -- covers both arms.
    # shellcheck disable=SC2016
    if taxonomy_has "$dep"; then
      printf '| `%s` | `%s` | absent from the target, and not ordered |\n' "$slug" "$dep"
    else
      printf '| `%s` | `%s` | **not in the taxonomy at all** -- a bad slug in the spec as delivered |\n' \
        "$slug" "$dep"
    fi
  done < <(printf '%s\n' "$unsatisfied")

  echo ""
  echo "**This is declared, not refused.** The drop is still worth making. But what"
  echo "these assets will actually inherit, absent the systems above, is the neutral"
  echo "kit below -- and that needs to be a choice somebody made rather than a default"
  echo "nobody noticed. If inheriting the neutral kit is wrong for any of them, say so"
  echo "in \`RETURN.md\` instead of inventing the missing system."
  echo ""
}

brief_structure() {
  echo "## The output structure"
  echo ""
  echo "The top level of what you deliver is exactly what lands in the target, so"
  echo "the folder IS the specification. Deliver it as a zip."
  echo ""
  echo '```'
  echo "RETURN.md              this drop's narrative -- mandatory"
  echo "index.md               manifest: every asset present, its status, its spec version"
  echo "kit/                   kit.md, tokens.css, tokens.json"
  echo "assets/"
  echo "  <asset-slug>/        FLAT -- no grouping"
  echo "    spec.md            what complete means for this asset, travelling with it"
  echo "    <artefact files>"
  echo "    exports/           pdf, pptx, png -- generated, never hand-edited"
  echo "    src/               working files, if any"
  echo "    vendor/            third-party runtime an artefact needs to render"
  echo "notes/"
  echo "  <topic>.md           optional; durable thinking that is not an asset"
  echo '```'
  echo ""
  echo "\`assets/\` is flat deliberately. Grouping is an order in disguise and this"
  echo "structure must not imply one; eight asset types are genuinely both design and"
  echo "venture, so any grouping forces a lie about them. Grouping is real and useful,"
  echo "and it lives in \`index.md\` as data rather than as a directory someone has to"
  echo "be right about."
  echo ""
  echo "Only \`assets/\`, \`kit/\`, \`notes/\`, \`index.md\` and \`RETURN.md\` are yours. The"
  echo "importer writes those and nothing else, so anything else already in the target"
  echo "survives your drop -- and your drop cannot delete it."
  echo ""
  echo "**Do not echo this brief back.** \`brief.md\` is not in that set, so the importer"
  echo "discards it -- and should, because the venture wrote it and the venture's copy is"
  echo "the authoritative one. A second copy of the order is a copy that can disagree"
  echo "with the first."
  echo ""

  brief_spec_contract
}

# State the shape of the spec.md that comes back.
#
# THE ROUND TRIP THIS CLOSES. Every specification below is inlined as a heading, a
# metadata table and prose -- because that is how a document reads. But the front
# matter is stripped to render it that way, so a reader shown only this document had
# no way to know the fields were ever machine-readable, reproduced the table it was
# shown, and put the state in `index.md` instead. Entirely reasonable, and it left
# `cdsync check` unable to read `status`, `spec_version` or `coverage` on any asset in
# the drop.
#
# The brief's rendering of a spec was not the format the tool demanded back, and the
# tool never said what that format was. This is that statement.
brief_spec_contract() {
  echo "### \`spec.md\` -- the one file with a required format"
  echo ""
  echo "Each asset's \`spec.md\` is its definition of done travelling with it, and it is"
  echo "read by machine as well as by people. **It must open with a YAML front-matter"
  echo "block**, because \`cdsync check\` reads \`status\`, \`spec_version\` and \`coverage\`"
  echo "from it and can hold the asset against nothing without them."
  echo ""
  echo "The specifications further down this document render those same fields as a"
  echo "table, because that is how a document reads. **Do not copy that shape back.**"
  echo "Front matter first, then the body:"
  echo ""
  echo '```yaml'
  echo "---"
  echo "asset: <slug>              # exactly the slug this brief ordered"
  echo "name: <name>"
  echo "spec_version: <n>          # copied from the specification below and left"
  echo "                           # alone -- not a counter you increment. For an"
  echo "                           # asset ordered ahead of the library, the"
  echo "                           # literal word: unassigned"
  echo "kit_version: <n>           # likewise, from the kit"
  echo "form: <A|B|C|D>"
  echo "tier: <n>"
  echo "group: <n>"
  echo "audience: [<audience>]     # the copy you actually made, not every copy possible"
  echo "status: <spec-only|draft|partial|complete>"
  echo "coverage: <what is covered, when status is partial>"
  echo "inputs_missing:"
  echo "  - \"<a fact this asset needed and the brief did not carry>\""
  echo "depends_on:"
  echo "  hard_facts: [<...>]      # venture facts that must be DECIDED before this"
  echo "                           # asset can complete -- copied from 'facts that"
  echo "                           # must be decided first' under the specification;"
  echo "                           # empty when it states none"
  echo "  hard_assets: [<...>]     # assets that must EXIST first -- likewise copied"
  echo "  reciprocal: [<...>]      # develops in dialogue with these -- likewise copied"
  echo "bundles: [<...>]           # where the library's bundles place this asset --"
  echo "                           # stated under each specification; copy, never choose"
  echo "---"
  echo '```'
  echo ""
  echo "**Do not declare \`blanks\`, \`blanks_unique\` or \`blanks_source\`.** The tool"
  echo "computes them and writes them in. Every hand-counted figure ever delivered here"
  echo "was wrong, which is why counting stopped being anyone's job."
  echo ""
  echo "\`index.md\` is a manifest and a convenience. It is not where state lives: a"
  echo "status recorded only there is a status the checker cannot see."
  echo ""
  echo "**Each asset directory is the unit of portability**, not each artefact file."
  echo "A built artefact restates token values literally rather than linking"
  echo "\`../../kit/tokens.css\`, because a path two levels up does not survive the"
  echo "directory being moved. Same-directory siblings do."
  echo ""
}

# Carry the kit, in every brief, ordered or not.
#
# THE HOLE THIS CLOSES. The brief's second line promises that nothing in it points at
# a file the reader cannot open. It then required `kit/kit.md`, `kit/tokens.css` and
# `kit/tokens.json` in the delivered structure and inlined the kit only when `kit`
# happened to be in the order -- so `kit_version: 1` in the header was a stamp with
# nothing behind it. Claude Design could satisfy it only because it still had the
# library; an instance holding just the brief would have done the one thing available
# and invented a kit.
#
# Which is the worst possible failure for this document: a brief whose entire purpose
# is to prevent invention, licensing the invention of the artefact that exists to
# prevent invention everywhere else.
#
# The kit is not an ordered asset. It is `root: true` -- everything restates its
# values literally -- so it is context every round needs regardless of what was
# ordered.
brief_kit() {
  local target="$1"
  local spec tokens written

  spec="$(spec_path kit)" || return 1
  tokens="$target/kit/tokens.json"
  written="$target/kit/kit.md"

  echo "---"
  echo ""
  echo "## The kit"
  echo ""

  if [[ ! -f "$written" && ! -f "$tokens" ]]; then
    echo "**The target has no kit yet, so this round builds it** to the specification"
    echo "below. Everything else in the drop restates its values literally, which makes"
    echo "it the first thing to settle and the only thing everything else depends on."
    echo ""
    brief_one_specification kit "$spec"
    return 0
  fi

  echo "**The target already has a kit. It is reproduced in full below, and it is"
  echo "authoritative.** Do not regenerate it and do not substitute your own. Restate"
  echo "its values literally in each artefact rather than linking the file -- a path two"
  echo "levels up does not survive the asset directory being moved, and same-directory"
  echo "siblings do."
  echo ""

  # The written kit, not merely its specification. Inlining only the spec left the
  # same hole one level down: a later round's brief would say "see `kit/kit.md`" for
  # the illustrative marker and the blank-counting scope, and carry neither -- so the
  # reader would define them again, differently, and `check` would then be measuring
  # against a rule the drop no longer follows.
  if [[ -f "$written" ]]; then
    echo "### The kit as written"
    echo ""
    brief_demote_body "$written"
    echo ""
  fi

  if [[ -f "$tokens" ]]; then
    echo "### The token values"
    echo ""
    echo "The file \`cdsync check\` reads. Every colour literal in the drop must appear"
    echo "here, or the check blocks the drop."
    echo ""
    echo '```json'
    cat "$tokens"
    echo '```'
    echo ""
  fi

  echo "The specification the kit is held against follows, unchanged."
  echo ""
  brief_one_specification kit "$spec"
}

brief_specifications() {
  local slugs="$1"
  local slug spec

  echo "## Specifications"
  echo ""
  echo "One per ordered asset, in full. These are the definition of done, and they"
  echo "are what the drop is held against."
  echo ""

  while IFS= read -r slug; do
    if [[ -z "$slug" ]]; then continue; fi

    # The kit is always carried in its own section above, whether or not it was
    # ordered. Emitting it twice would put two copies of one specification in a
    # document whose job is to be the single statement of done.
    if [[ "$slug" == "kit" ]]; then continue; fi

    spec="$(spec_path "$slug")" || continue

    echo "---"
    echo ""
    brief_one_specification "$slug" "$spec"
  done < <(printf '%s\n' "$slugs")
}

brief_one_specification() {
  local slug="$1"
  local spec="$2"
  local item hard reciprocal

  echo "### \`$slug\` -- $(fm_get "$spec" name || echo "$slug")"
  echo ""
  echo "| | |"
  echo "|---|---|"
  echo "| Form | $(fm_get "$spec" form || echo '?') |"
  echo "| Tier | $(fm_get "$spec" tier || echo '?') |"
  echo "| Spec version | $(fm_get "$spec" spec_version || echo '?') |"
  echo "| Audience | $(fm_list "$spec" audience | tr '\n' ',' | sed 's/,$//; s/,/, /g') |"
  echo ""

  if fm_list "$spec" inputs_missing | grep -q .; then
    echo "**Inputs this asset needs that the header does not carry.** Where one is"
    echo "absent, leave a blank rather than filling it -- and say so in \`RETURN.md\`."
    echo ""
    while IFS= read -r item; do
      if [[ -z "$item" ]]; then continue; fi
      echo "- $item"
    done < <(fm_list "$spec" inputs_missing)
    echo ""
  fi

  hard="$(join_words "$(fm_list "$spec" depends_on.hard_assets)")"
  reciprocal="$(join_words "$(fm_list "$spec" depends_on.reciprocal)")"

  # Stated because the contract asks them back and the body below cannot carry
  # them -- front matter is stripped when the spec is inlined, so a supplier
  # shown only this document had no source for either field. Sixteen assets came
  # back `[]` on the first round that asked, and that was the document's fault.
  local facts membership
  facts="$(join_words "$(fm_list "$spec" depends_on.hard_facts)")"
  membership="$(join_words "$(bundles_holding "$slug")")"

  if [[ -n "$facts" ]]; then
    echo "**Facts that must be decided first:** $facts -- copy into"
    echo "\`depends_on.hard_facts\`."
    echo ""
  fi
  if [[ -n "$hard" ]]; then
    echo "**Needs to exist first:** $hard"
    echo ""
  fi
  if [[ -n "$reciprocal" ]]; then
    echo "**Reciprocal, must not be ordered:** $reciprocal -- each is evidence about"
    echo "the other, so neither waits on the other."
    echo ""
  fi
  if [[ -n "$membership" ]]; then
    echo "**Bundles that place this asset:** $membership -- copy into \`bundles:\`."
    echo ""
  fi

  # The body, nested under this asset's heading. This is the part that makes the
  # brief self-contained rather than a table of contents.
  brief_demote_body "$spec"
  echo ""
}

# Emit a spec's body so it nests under the `###` heading above it.
#
# Two things to get right, and a first cut got both wrong.
#
# The body's own `# <Name> -- specification` title duplicates the wrapper
# heading, so it is dropped rather than demoted -- otherwise every asset gets
# announced twice.
#
# Everything else moves down two levels, so a body `##` becomes `####` and sits
# UNDER the asset rather than beside it. Adding two hashes to a `#` produced
# `###`, which collides with the wrapper and silently flattens the document
# structure: every spec section rendered as a sibling of its own asset.
#
# Fenced code is passed through untouched, because a `#` at the start of a line
# inside a fence is a shell comment, not a heading.
brief_demote_body() {
  local spec="$1"

  awk '
    /^---$/ && n < 2 { n++; next }
    n < 2 { next }

    /^[[:space:]]*```/ { in_fence = !in_fence; print; next }
    in_fence { print; next }

    # A heading is hash-then-space. Matching a bare leading hash would delete a
    # line beginning with a colour literal -- `#d97757` reads as a one-hash
    # heading to a looser pattern.
    /^# / { next }
    /^#+ / { print "##" $0; next }
    { print }
  ' "$spec"
}

# Join newline-separated items with single spaces, with no trailing space.
#
# `tr '\n' ' '` leaves one behind, which renders as a double space before the
# next word.
join_words() {
  echo "$1" | tr '\n' ' ' | sed 's/  */ /g; s/ *$//'
}

brief_gaps() {
  echo "---"
  echo ""
  echo "## The gaps -- what asks consistently leave out"
  echo ""
  echo "Specific rather than diplomatic, because this list is the highest-value part"
  echo "of the contract. If this brief has left one of these open, say so in"
  echo "\`RETURN.md\` rather than guessing."
  echo ""
  echo "1. **Whether facts may be invented, or blanks must be left.** The most common"
  echo "   omission and the most expensive."
  echo "2. **Audience.** \"Make a deck\" without investor-versus-customer is a coin"
  echo "   flip on structure, length and tone."
  echo "3. **Whether numbers are real or illustrative** -- and if illustrative,"
  echo "   visibly marked in the artefact rather than understood in chat. The failure"
  echo "   with the worst consequences, and it recurs."
  echo "4. **Existing constraints presented as absent.** A colour already in use, a"
  echo "   name already registered, a deck a partner has already seen. Discovered"
  echo "   late, these invalidate finished work."
  echo "5. **Output format.** PDF, PPTX, HTML, editable-by-whom. It changes"
  echo "   construction, not just export."
  echo "6. **Length ceilings.** Ten slides and twenty slides are different arguments,"
  echo "   not the same argument at two lengths."
  echo "7. **Locale.** Currency, date format, spelling, units. Cheap to state, tedious"
  echo "   to retrofit."
  echo "8. **Who reviews it, and what done means to them.** A deck for a partner"
  echo "   meeting and a deck for a board pack have different definitions of"
  echo "   finished, and the difference is not in the content."
  echo "9. **What has already been tried and rejected.** Without it, the second"
  echo "   attempt re-proposes the first."
  echo "10. **Real team facts.** Persistently late, and the zoo cannot start without"
  echo "    them."
  echo ""
}

# ============================================================================
# NUMBERING
# ============================================================================
#
# Claude Design allocated ADR and steel-thread ids from an assumption, because no
# brief had ever told it what was already taken. Repairing the collision cost a
# full export cycle on both sides -- Lamplight, July 2026 -- and the fix has been
# a hand-written table in three briefs ever since, which means the next brief
# written without one reintroduces the bug.
#
# THE MARK IS NOT JUST THE PROJECT'S. A drop carries ids too: Lamplight's own
# series ended at ADR-0007 and the drop held ADR-0008 through ADR-0020, so the
# real high-water was in the drop. Scanning only the repository would have
# reported 0007 and handed the supplier a number it had already used.
#
# So both are scanned, and the paths are printed. A number stated without saying
# where it came from is the same as no number: unverifiable, and therefore
# something a careful supplier has to re-derive anyway.

# Where ADRs live is per project, not conventional. Lamplight keeps them in
# intent/docs/adr/ and Baize in docs/adr/, so a scan that knows one path finds
# nothing in the other project and says so with total confidence.
# FILENAMES AND DIRECTORY NAMES, NEVER FILE CONTENTS, and that is deliberate.
#
# A filename is an ALLOCATION -- `intent/st/ST0007/`, `docs/adr/adr0030-....md`
# is someone having taken that number. A mention inside a document is a
# REFERENCE, and references are routinely to other projects' ids: Baize's
# `usage-rules.md` cites ST0035 from Arca, its whiteboard README cites Intent's
# ST0047, and three of its acceptance files cite ST0048. Scanning content would
# have put Baize's steel-thread high-water at 0048 and handed Claude Design
# "next free ST0049" -- over-reporting, which causes the very collision this
# section exists to prevent, just from the other direction.
#
# So the miss this cannot avoid is a project that records allocations only
# inside a document, and the honest answer there is the "none found -- ask
# before allocating" row rather than a number. Do not "fix" this by grepping
# contents; verify a suspected miss by planting a FILENAME and rescanning.
brief_series_scan() {
  local pattern="$1"
  shift

  local root numbers all=""

  for root in "$@"; do
    if [[ ! -d "$root" ]]; then continue; fi
    numbers="$(find "$root" -maxdepth 8 \( -type f -o -type d \) 2>/dev/null \
      | grep -oE "$pattern" | grep -oE '[0-9]+' || true)"
    if [[ -n "$numbers" ]]; then
      all="$all$numbers"$'\n'
    fi
  done

  printf '%s' "$all" | grep . | sort -u || true
}

brief_numbering() {
  local target="$1"
  local roots=()
  local project

  # THE PROJECT IS THE ONE THAT OWNS THE TARGET, not the one you happen to be
  # standing in. $PWD was the root here, which is right whenever the command is
  # run from inside the project -- and silently wrong the moment it is not.
  # Generating a document for another project's tree from this repository
  # scanned THIS repository for high-water marks and handed the answer over as
  # if it were theirs. Allocating ids from another project's marks is exactly
  # the collision the section below exists to prevent, so the bug would have
  # been served by the fix for itself.
  #
  # Resolving through git rather than through $PWD makes the normal case
  # identical -- run inside the project, the toplevel IS $PWD -- and the
  # remote-target case correct.
  project="$(git -C "$target" rev-parse --show-toplevel 2>/dev/null || true)"
  if [[ -z "$project" ]]; then
    project="$PWD"
  fi
  roots=("$project")

  # The target is usually inside the project, but it may be pointed anywhere.
  case "$(normalise_path "$target")" in
    "$(normalise_path "$project")"/*) : ;;
    *) roots+=("$target") ;;
  esac

  echo "## Numbering, so you never have to infer it"
  echo ""
  echo "The last round in this programme allocated ids from an assumption, and repairing"
  echo "the collision cost a full export cycle on both sides. **If you allocate any id for"
  echo "any reason, allocate from here.**"
  echo ""
  echo "| Series | Found | High-water | Next free |"
  echo "| ------ | ----- | ---------- | --------- |"

  # Case-insensitive, separator optional, and anchored to a non-alphanumeric so
  # `test0001` cannot pass as `st0001`.
  #
  # The first version of this scan matched only `ADR-[0-9]+` and reported Baize
  # as having NO ADRs -- confidently, in a table headed "so you never have to
  # infer it" -- because Baize writes `adr0001-requirements-approach.md` while
  # Lamplight writes `ADR-0003 Pure-Functional Game Engine.md`. Thirty files,
  # `adr0001` to `adr0030`, invisible to the probe. That is the exact failure
  # this section exists to prevent, reproduced inside the fix for it, and caught
  # only by running the scan against both real projects instead of the one it
  # was written against.
  #
  # (The count read "thirty-three" until 31 July, when enumerating Baize on the
  # way to its bootstrap document showed thirty. A wrong number inside the
  # cautionary tale about wrong numbers.)
  brief_series_row "ADR" '[^A-Za-z0-9][Aa][Dd][Rr]-?[0-9]{3,4}' "${roots[@]}"
  brief_series_row "Steel thread" '[^A-Za-z0-9][Ss][Tt]-?[0-9]{3,4}' "${roots[@]}"

  echo ""
  echo "Scanned:"

  # NAMED, NOT PATHED. This document goes to a reader that cannot open the
  # filesystem it was generated on, and its own header promises it points at
  # nothing they cannot read -- so an absolute path here breaks that promise
  # while telling them nothing, and puts the author's local directory layout
  # into material sent outside. The name says which tree was covered, which is
  # the whole job of the list.
  local root i=0
  for root in "${roots[@]}"; do
    echo ""
    if [[ "$i" -eq 0 ]]; then
      echo "- the project, \`$(basename "$root")\`"
    else
      echo "- the drop, \`$(basename "$root")\`"
    fi
    i=$((i + 1))
  done
  echo ""
  echo "Both the project and the drop are scanned, because **a drop carries ids too** and"
  echo "the real high-water has been inside one before. Work-package numbers are per steel"
  echo "thread rather than global, so they are not listed: ask for the mark on the specific"
  echo "thread before allocating one."
  echo ""
}

brief_series_row() {
  local label="$1"
  local pattern="$2"
  shift 2

  local numbers count high next
  numbers="$(brief_series_scan "$pattern" "$@")"
  count="$(printf '%s\n' "$numbers" | grep -c . || true)"

  # Nothing found is reported as nothing found, and never as "start at 0001".
  # The scan cannot tell "this project has no ADRs" from "this project keeps its
  # ADRs somewhere I did not look" -- and it has already been wrong about exactly
  # that, since the two projects in this programme use different paths. Stating a
  # confident 0001 off the back of an unproven miss is how the original collision
  # happened.
  if [[ "$count" -eq 0 ]]; then
    echo "| $label | **none found** | -- | **ask before allocating** |"
    return 0
  fi

  high="$(printf '%s\n' "$numbers" | sort -n | tail -1)"
  next="$(printf '%04d' "$((10#$high + 1))")"
  echo "| $label | $count | \`$high\` | **\`$next\`** |"
}

brief_return_contract() {
  local venture="$1"
  local round

  round="$(config_get '.round' || echo '1')"

  echo "## RETURN.md -- mandatory, at the top of the drop"
  echo ""
  echo "Fixed headings, so it cannot degrade into a changelog. *Revisions to"
  echo "understanding* is required and present-but-empty when there is nothing to"
  echo "say -- an optional section for it would be empty every time, and it is"
  echo "sometimes the most valuable thing in a round."
  echo ""
  echo '```markdown'
  echo "# Return -- $venture, round $round"
  echo ""
  echo "## What is in this drop"
  echo "[assets, with status]"
  echo ""
  echo "## Revisions to understanding"
  echo "[Mandatory. Present-but-empty when there is nothing."
  echo " What working on one asset changed about another.]"
  echo ""
  echo "## Decisions I made that you did not ask me to make"
  echo "[Every place a gap was filled. The list that gets audited.]"
  echo ""
  echo "## What I could not do, and why"
  echo "[Blocked on facts, or on things outside the medium.]"
  echo ""
  echo "## What I would do next"
  echo '```'
  echo ""
  echo "*Decisions I made that you did not ask me to make* is the counterpart of the"
  echo "\`fixed\`/\`open\` lists: it makes invention auditable in one place rather than"
  echo "discoverable by reading everything."
  echo ""
  echo "\`RETURN.md\` is per-drop and therefore perishable. Anything under *revisions"
  echo "to understanding* that is still true next round gets promoted into the"
  echo "decision log, which is cumulative and lives in the venture."
  echo ""
}
