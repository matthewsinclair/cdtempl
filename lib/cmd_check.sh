#!/usr/bin/env bash
#
# cdtempl check - hold a drop against its own specifications
#
# Six rules, none of them invented. Every one was earned by a real failure in
# the rounds that produced the templates, which is why there are six rather
# than the twenty a checker grows if nobody asks what each is for.
#
#   1. status against blank count -- `complete` alongside blanks is a
#      contradiction.                                              BLOCKING
#   2. A drop's stamped spec_version against the library, to detect staleness.
#      The stamp is the LIBRARY'S, copied unchanged -- not a per-drop counter.
#   3. Illustrative numbers visibly marked IN THE ARTEFACT, not merely
#      understood in conversation.
#   4. Every colour literal, excluding files declaring themselves generated in a
#      comment, must appear in kit/tokens.json.                    BLOCKING
#   5. `status: partial` requires `coverage`; `complete` requires it to be total.
#   6. `classification` present and one of three, and NOT conflated with
#      `audience`.
#
# Rules 1 and 4 block; the rest advise. That split is deliberate: 4 is the leak
# guard that makes neutrality a property of the repository rather than of
# whoever last touched a file, and 1 is a drop lying about its own state. The
# others are worth knowing and not worth stopping for.
#
# Rule 6 was held back deliberately for one round so it would not fire on every
# drop that predated the decision, and Gyre & Gymble's round-2 export on 31 July
# 2026 is the round it waited for -- the first drop to carry `classification`
# at all, on all sixteen assets.
#
# blanks and blanks_unique are COMPUTED and written back, never read as
# declared. They were declared by hand twice and were wrong both times, in three
# different ways, by someone with every incentive to get them right. The
# conclusion is not that the counting convention needs specifying harder -- it is
# that a hand-maintained count of a mechanically countable property will always
# drift. Same move as enforcing neutrality with a kit rather than asking for
# restraint: remove the failure mode instead of detecting it.
#

CDTEMPL_CHECK_STATUSES="spec-only draft partial complete"
CDTEMPL_CHECK_CLASSIFICATIONS="public internal confidential"

# ============================================================================
# FINDINGS
# ============================================================================
#
# Every rule emits `SEVERITY|slug|rule|message` on stdout. The coordinator
# collects them; nothing prints as it goes, so the report can be ordered by
# severity rather than by the order the files happened to be walked.

finding() {
  echo "$1|$2|$3|$4"
}

# ============================================================================
# THE RULES
# ============================================================================

# Rule 1. A drop reports its own incompleteness rather than leaving it to be
# discovered, so a status that contradicts the count is a drop lying about
# itself.
rule_status_versus_blanks() {
  local slug="$1" spec="$2" blanks="$3"
  local status

  status="$(fm_get "$spec" status)" || {
    finding advisory "$slug" "rule-1" "no status declared"
    return 0
  }

  case " $CDTEMPL_CHECK_STATUSES " in
    *" $status "*) ;;
    *) finding advisory "$slug" "rule-1" "unknown status '$status' -- expected one of: $CDTEMPL_CHECK_STATUSES" ;;
  esac

  if [[ "$status" == "complete" && "$blanks" -gt 0 ]]; then
    finding blocking "$slug" "rule-1" "status: complete but $blanks blanks remain"
  fi
}

# Rule 2. The library here is the source of truth; the copy travelling in the
# drop is a stamped duplicate, and the version difference is the whole point of
# stamping it.
#
# WHAT THE NUMBER MEANS, ruled by hv on 31 July 2026 after both readings shipped
# at once. `spec_version` in a drop is THE VERSION OF THE LIBRARY SPECIFICATION
# THE ASSET WAS BUILT FROM, copied unchanged. It is not the asset's own revision
# counter. Both readings are coherent in isolation; only this one makes the
# comparison below mean anything, because a number each side increments on its
# own schedule cannot measure the distance between them.
#
# The other reading shipped too. Gyre & Gymble's round-2 export stamped all
# SIXTEEN assets `2` on the round that added classification -- a per-drop bump --
# and fourteen were flagged. The two that were not are the instructive ones:
# their library entries happened to also be at 2, so the check went quiet over
# two assets stamped exactly as wrongly as the fourteen. A collision of unrelated
# counters reading as agreement is the same failure as a probe that cannot see.
rule_spec_version() {
  local slug="$1" spec="$2"
  local drop_version library_version library_spec

  drop_version="$(fm_get "$spec" spec_version)" || drop_version=""

  if ! library_spec="$(spec_path "$slug")"; then
    # `unassigned` here is the CORRECT state, not a finding: the asset was
    # ordered ahead of the library (hv, 9 Aug 2026) and the stamp says so.
    # The rule starts measuring the day the library gains the entry.
    if [[ "$drop_version" == "unassigned" ]]; then
      return 0
    fi
    if [[ -n "$drop_version" ]]; then
      finding advisory "$slug" "rule-2" "no entry in the spec library, yet the drop stamps spec_version $drop_version -- a number nobody issued; an asset built ahead of the library stamps the literal 'unassigned'"
      return 0
    fi
    finding advisory "$slug" "rule-2" "no entry in the spec library -- it cannot be checked for staleness"
    return 0
  fi

  library_version="$(fm_get "$library_spec" spec_version)" || library_version=""

  if [[ -z "$drop_version" ]]; then
    finding advisory "$slug" "rule-2" "no spec_version stamped in the drop"
    return 0
  fi

  # An unversioned library entry is a fault in the library, not in the drop.
  # Without this guard the empty value compares as zero and every drop gets
  # reported as ahead of a library that simply forgot to say where it was.
  if [[ -z "$library_version" ]]; then
    finding advisory "$slug" "rule-2" "the library entry carries no spec_version, so staleness cannot be judged"
    return 0
  fi

  # An asset stamped ahead of the library, in a library that has since caught
  # up: the intended second half of the `unassigned` lifecycle, not an error.
  if [[ "$drop_version" == "unassigned" ]]; then
    finding advisory "$slug" "rule-2" "stamped unassigned, and the library now holds spec_version $library_version -- rebuild against it; do not just replace the stamp"
    return 0
  fi

  # Arithmetic on a word would read it as zero and report a confident wrong
  # verdict, so a stamp that is neither a number nor the unassigned convention
  # is named rather than compared.
  case "$drop_version" in
    *[!0-9]*)
      finding advisory "$slug" "rule-2" "unreadable spec_version '$drop_version' -- expected a number copied from the library, or the literal 'unassigned'"
      return 0
      ;;
  esac

  if [[ "$drop_version" -lt "$library_version" ]]; then
    # NAMES THE REMEDY, because the obvious reading of the bare disagreement is
    # the wrong one. Told only that its stamp is below the library's, the cheapest
    # repair is to edit the number up -- which silences the finding, changes
    # nothing, and re-creates the hand-driven counter this rule exists to stop.
    #
    # The stamp is a fact about which specification the asset was built from, so
    # it becomes correct by the asset being rebuilt, never by the number being
    # raised. This finding first fired for real on 31 July 2026, on the round that
    # reset a misused counter and revealed two genuinely stale assets underneath.
    finding advisory "$slug" "rule-2" "stale: built from spec_version $drop_version, library is at $library_version -- rebuild against the newer spec; do not raise the stamp on its own"
  elif [[ "$drop_version" -gt "$library_version" ]]; then
    # NOT "the library needs updating", which this said in every one of the
    # fourteen findings it raised on the only drop that ever hit it -- and was
    # wrong in all fourteen. The stamp is copied from the library, so a drop
    # cannot be built from a version the library has never had. What the tool
    # can establish is the disagreement; naming a culprit it cannot see is the
    # habit two other checks were corrected for on 30 July.
    finding advisory "$slug" "rule-2" "drop carries spec_version $drop_version, above the library at $library_version -- the stamp is the library's, not a per-drop counter"
  fi
}

# Rule 6. Classification is an axis of its own, and it is ADVISORY -- which is
# not a judgement call, it is forced by the decision that created it.
#
# Classification governs WHERE MATERIAL MAY BE SHOWN, never whether it is
# committed, and it "is not a delivery filter and must not be used as one". A
# blocking rule here would refuse a drop on the strength of a classification,
# which is precisely using it as a delivery filter. So the ruling that defines
# the field also settles the severity, and there was nothing left to weigh.
#
# Held back one round on purpose so it would not fire on every drop that
# predated the decision. Gyre & Gymble's round-2 export is the round it waited
# for: sixteen assets, all classified, 5 confidential / 4 internal / 7 public,
# allocated by Claude Design because the scale is ours and the assignment is
# per-asset.
rule_classification() {
  local slug="$1" spec="$2"
  local class

  class="$(fm_get "$spec" classification)" || class=""

  if [[ -z "$class" ]]; then
    finding advisory "$slug" "rule-6" "no classification declared -- nothing here says where this may be shown"
    return 0
  fi

  case " $CDTEMPL_CHECK_CLASSIFICATIONS " in
    *" $class "*) ;;
    *) finding advisory "$slug" "rule-6" "unknown classification '$class' -- expected one of: $CDTEMPL_CHECK_CLASSIFICATIONS" ;;
  esac

  return 0
}

# Rule 6, second half. THE CONFLATION, which is the failure this axis exists to
# end rather than a tidiness point.
#
# `audience` answers who a thing is FOR -- customer, investor, printer,
# developer. `classification` answers where it may be SHOWN. They are different
# questions and a value like `internal` is an answer to the second sitting in
# the field for the first, which is how "who reads this" and "who may see this"
# stop being distinguishable.
#
# Not hypothetical, and not only a supplier's mistake: Gyre & Gymble's
# `notes/confidentiality.md` had the two conflated and Claude Design rewrote it
# on 31 July -- and THIS PROJECT'S OWN SPEC LIBRARY declares the conflation in
# its audience legend, `INT internal` sitting in a column headed "For", which is
# where all twelve of its conflated entries inherited it from.
#
# `public` IS NOT FLAGGED, and that is the whole subtlety. It is a real answer
# to both questions: the general public genuinely is who a landing page is for,
# and `classification: public` says it may be shown externally. The two are
# independent -- an investor deck can be classified public while its audience is
# investors -- so the word appearing in `audience` proves nothing.
#
# `internal` and `confidential` are different. Neither says anything about who a
# thing is FOR; both answer only where it may be shown. So they are the ones
# that can only have arrived in this field by conflation.
#
# Defined in common.sh, because the generated document now tells Claude Design to
# strip exactly these values from `audience` -- and a document naming a different
# set from the rule that judges it would instruct the other side into the finding.
CDTEMPL_CHECK_CLASSIFICATION_ONLY="$CDTEMPL_CLASSIFICATION_ONLY"

rule_classification_conflation() {
  local slug="$1" spec="$2"
  local aud

  while IFS= read -r aud; do
    if [[ -z "$aud" ]]; then continue; fi
    case " $CDTEMPL_CHECK_CLASSIFICATION_ONLY " in
      *" $aud "*)
        finding advisory "$slug" "rule-6" "audience carries '$aud', which answers only where a thing may be shown, never who it is for -- the two axes are conflated"
        ;;
    esac
  done < <(fm_list "$spec" audience)

  return 0
}

# Rule 2, second half. A dependency on an asset that is real but unbuilt is
# correct and must not be flagged -- component-library requires grid-and-layout,
# which is first in Tier 2. A dependency on a slug that is not in the taxonomy
# at all is a naming error.
rule_dependencies() {
  local slug="$1" spec="$2"
  local field dep

  for field in depends_on.hard_assets depends_on.reciprocal; do
    while IFS= read -r dep; do
      if [[ -z "$dep" ]]; then continue; fi
      if ! taxonomy_has "$dep"; then
        finding advisory "$slug" "rule-2" "${field#depends_on.} names '$dep', which is not in the taxonomy"
      fi
    done < <(fm_list "$spec" "$field")
  done
}

# Rule 3. An unmarked number in a delivered artefact is a claim. Reported as the
# failure that recurs and has the worst consequences, which is why it is a check
# rather than a habit.
rule_illustrative() {
  local slug="$1" dir="$2"
  local file metrics sample total

  while IFS= read -r file; do
    if [[ -z "$file" ]]; then continue; fi

    metrics="$(each_metric_in_file "$file" | sort -u)"
    if [[ -z "$metrics" ]]; then continue; fi

    if grep -qi 'illustrative' "$file"; then continue; fi

    # THE SAMPLE IS THREE OF N AND USED NOT TO SAY SO, which hid the finding
    # inside the finding. G&G's design-system.dc.html carries `£44` and `£48` --
    # prices, and about as claim-like as a number gets -- and reported as
    # "100% 3% 7%", because the list is sorted and a digit sorts before a
    # currency symbol. So the truncation was not merely lossy, it systematically
    # dropped the most important end of the list and read as the whole of it.
    #
    # No silent caps: if a report bounds what it shows, it says what it dropped.
    total="$(printf '%s\n' "$metrics" | grep -c .)"
    sample="$(printf '%s\n' "$metrics" | head -3 | tr '\n' ' ')"
    if [[ "$total" -gt 3 ]]; then
      sample="$sample(+$((total - 3)) more)"
    fi

    finding advisory "$slug" "rule-3" "$(basename "$file") carries numbers with no 'illustrative' marker: $sample"
  done < <(each_artefact_file "$dir")
}

# Rule 4. The leak guard, and the one to build first if only one gets built. It
# catches drift in both directions -- an artefact holding a value the kit no
# longer has, and a hue entering an artefact without passing through the kit. The
# second is what makes neutrality a property of the repository rather than of
# whoever last touched a file.
rule_colour() {
  local slug="$1" dir="$2" kit_colours="$3"
  local file colour leaked

  while IFS= read -r file; do
    if [[ -z "$file" ]]; then continue; fi
    if is_generated_file "$file"; then continue; fi

    leaked=""
    while IFS= read -r colour; do
      if [[ -z "$colour" ]]; then continue; fi
      case "
$kit_colours
" in
        *"
$colour
"*) ;;
        *) leaked="$leaked $colour" ;;
      esac
    done < <(each_colour_in_file "$file" | sort -u)

    if [[ -n "$leaked" ]]; then
      finding blocking "$slug" "rule-4" "$(basename "$file") carries colours absent from kit/tokens.json:$leaked"
    fi
  done < <(each_scannable_file "$dir")
}

# Rule 5. A library declaring twenty-eight components and rendering twelve
# cannot claim to be finished, and that is the specific way that asset lies.
# Assets with parts but ONE definition of done take `partial` plus coverage --
# they do not split, because their parts are one specification applied N times
# rather than N specifications.
rule_coverage() {
  local slug="$1" spec="$2"
  local status coverage have want

  status="$(fm_get "$spec" status)" || return 0

  if [[ "$status" == "partial" ]]; then
    if ! fm_has "$spec" coverage || ! coverage="$(fm_get "$spec" coverage)"; then
      finding advisory "$slug" "rule-5" "status: partial requires a coverage field"
      return 0
    fi
  fi

  if ! fm_has "$spec" coverage; then
    return 0
  fi

  coverage="$(fm_get "$spec" coverage)" || return 0

  # Coverage reads as "N/M ..." -- the prose after the fraction is for a human.
  have="$(echo "$coverage" | sed -n 's|^\([0-9][0-9]*\)/\([0-9][0-9]*\).*|\1|p')"
  want="$(echo "$coverage" | sed -n 's|^\([0-9][0-9]*\)/\([0-9][0-9]*\).*|\2|p')"

  # Prose coverage is what the brief asks for -- "what is covered, when status is
  # partial" -- so demanding N/M of a `partial` asset punishes a supplier for
  # obeying the document, and ten assets across two real trees were doing exactly
  # that. Under `complete` the fraction still earns its keep: totality is the
  # claim being made, and prose cannot be measured against it. So the finding
  # stays there, reworded to report what it cannot see rather than a format.
  if [[ -z "$have" || -z "$want" ]]; then
    if [[ "$status" == "complete" ]]; then
      finding advisory "$slug" "rule-5" "status: complete but coverage '$coverage' is not in N/M form, so totality cannot be checked"
    fi
    return 0
  fi

  if [[ "$status" == "complete" && "$have" -ne "$want" ]]; then
    finding advisory "$slug" "rule-5" "status: complete but coverage is $have/$want"
  fi
}

# ============================================================================
# THE COORDINATOR
# ============================================================================

cmd_check() {
  local flag_target=""
  local write=1

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
      --no-write)
        write=0
        shift
        ;;
      -h|--help)
        show_help check
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

  # BEFORE the shape gate, deliberately: the poster cases for a stale document
  # are exactly the trees the asset walk refuses.
  report_bootstrap_staleness "$target"
  echo ""

  if ! drop_looks_valid "$target"; then
    error "no drop at $target -- expected assets/ or kit/ underneath it"
    echo "" >&2
    echo "  A checker that passes on an empty directory is worse than no" >&2
    echo "  checker, so this is a failure rather than a clean report." >&2
    return 2
  fi

  # Gate jq ONCE, here, before anything loops. Never per-iteration, and never
  # memoised inside a command substitution -- a memo set there dies with its
  # subshell and prints the install hint once per asset.
  require_jq || return 2

  # The `|| true` is load-bearing, and so is the emptiness warning after it.
  #
  # A tokens file carrying no colour the scanner recognises makes the pipeline in
  # each_kit_colour exit 1 -- `grep` finds nothing -- which `set -o pipefail`
  # propagates to this assignment, which `set -e` turns into an abort of the whole
  # command. `check` then printed the target header and NOTHING else and exited 1:
  # no rules, no rows, no verdict, no error. matthewsinclair.com's 2026-08-02 kit
  # did exactly this, because it is defined entirely in `oklch()` and the scanner
  # reads `#hex`, `rgb()` and `hsl()`.
  #
  # Surviving that is not enough on its own. An empty kit silently SKIPS rule 4
  # further down -- both call sites guard on `-n` -- so the run would come back
  # "clean" having never looked. A rule that cannot run has to say so, exactly as
  # the missing-file branch does; the two are the same condition reached two ways.
  local tokens kit_colours=""
  if tokens="$(drop_tokens_path "$target")"; then
    kit_colours="$(each_kit_colour "$tokens" || true)"
    if [[ -z "$kit_colours" ]]; then
      warn "kit/tokens.json carries no colour this scanner reads -- rule 4, the leak guard, cannot run"
      echo "  It reads #hex, rgb() and hsl(). A kit defined in another colour space" >&2
      echo "  -- oklch(), lab(), color() -- is invisible to it, so a leak in that" >&2
      echo "  space would go unreported. This is a gap in the scanner, not a" >&2
      echo "  finding about the drop." >&2
    fi
  else
    warn "no kit/tokens.json in the target -- rule 4, the leak guard, cannot run"
  fi

  local findings=""
  local rows=""
  local count=0
  local slug spec dir all blanks unique status no_spec_detail

  # An asset is "a directory under assets/", and nothing else decides it. That is
  # the contract, and it is wrong for three of the four 30 July drops: Lamplight's
  # assets/ holds media DIRECTORIES, so four of them walk as assets, none carries a
  # spec.md, and the report reads "4 blocking" when the truth is "zero assets here
  # and four media folders".
  #
  # Cross-referencing index.md would fix that properly -- an asset would be a
  # directory the manifest NAMES -- but that redesigns asset detection rather than
  # fixing a bug, and only one of the four drops even has an index.md, so the
  # no-manifest fallback would need designing too. Getting THAT wrong reintroduces
  # the worst failure this tool has had: a rule that cannot see a thing stops
  # checking and reports clean.
  #
  # So the contract is untouched and only the sentence changes. When there is no
  # manifest, the finding says there is no manifest, instead of asserting a
  # certainty the tool does not have. It still blocks -- over-reporting is the safe
  # direction -- but it no longer says "this asset is broken" about something that
  # was never claimed to be an asset.
  no_spec_detail="no spec.md -- an asset must carry its definition of done"
  if [[ ! -f "$target/index.md" ]]; then
    no_spec_detail="no spec.md, and no index.md to say whether this is an asset at all"
  fi

  while IFS= read -r slug; do
    if [[ -z "$slug" ]]; then continue; fi

    dir="$(drop_asset_dir "$target" "$slug")"

    if ! spec="$(drop_spec_path "$target" "$slug")"; then
      findings="$findings$(finding blocking "$slug" "structure" "$no_spec_detail")
"
      count=$((count + 1))
      continue
    fi

    all="$(each_blank_in_asset "$dir")"
    if [[ -z "$all" ]]; then
      blanks=0
      unique=0
    else
      blanks="$(printf '%s\n' "$all" | wc -l | tr -d ' ')"
      unique="$(printf '%s\n' "$all" | sort -u | wc -l | tr -d ' ')"
    fi

    # A spec with no front matter is reported, not fatal.
    #
    # It used to be fatal: fm_set returned non-zero, the failure propagated, and
    # the run died before printing anything. So one malformed spec cost the entire
    # report -- including the findings about the other four assets, which were
    # already computed. The report is the product; losing it to a failed write is
    # backwards, and it turns four bad files into four round trips.
    #
    # Blocking rather than advisory, because status, spec_version and coverage all
    # live in that block: without it three of the five rules cannot run on this
    # asset at all, and a check that cannot run is not a pass.
    if ! fm_has_block "$spec"; then
      findings="$findings$(finding blocking "$slug" "structure" \
        "spec.md has no front matter, so status, spec_version and coverage cannot be read and the computed counts cannot be stamped")
"
    elif [[ "$write" -eq 1 ]]; then
      fm_set "$spec" blanks "$blanks"
      fm_set "$spec" blanks_unique "$unique"
      fm_set "$spec" blanks_source "computed"
    fi

    status="$(fm_get "$spec" status)" || status="?"
    rows="$rows$(printf '  %-28s %5s blanks %5s unique   spec %-3s %s' \
      "$slug" "$blanks" "$unique" "$(fm_get "$spec" spec_version || echo '?')" "$status")
"

    findings="$findings$(rule_status_versus_blanks "$slug" "$spec" "$blanks")
$(rule_spec_version "$slug" "$spec")
$(rule_dependencies "$slug" "$spec")
$(rule_illustrative "$slug" "$dir")
$(rule_coverage "$slug" "$spec")
$(rule_classification "$slug" "$spec")
$(rule_classification_conflation "$slug" "$spec")
"
    if [[ -n "$kit_colours" ]]; then
      findings="$findings$(rule_colour "$slug" "$dir" "$kit_colours")
"
    fi

    count=$((count + 1))
  done < <(each_drop_asset "$target")

  # The kit is taxonomy asset 20 and lives at the target root, so it is walked by
  # name rather than found under assets/. It carries no status, so the rules that
  # read one do not apply.
  #
  # Staleness does apply, and used not to run here. Rule 2 needs only
  # `spec_version`, and "carries no status" had been taken to mean "no rules
  # apply" -- so the one asset every other artefact restates the values of was the
  # one asset that could never be reported as working from a superseded
  # specification. That is the most consequential staleness there is, and it was
  # the only kind invisible.
  if drop_has_kit "$target"; then
    local kit_spec
    if kit_spec="$(drop_spec_path "$target" kit)"; then
      findings="$findings$(rule_spec_version "kit" "$kit_spec")
"
    fi

    if [[ -n "$kit_colours" ]]; then
      findings="$findings$(rule_colour "kit" "$target/kit" "$kit_colours")
"
    fi
    count=$((count + 1))
  fi

  render_check_report "$rows" "$findings" "$count"
}

render_check_report() {
  local rows="$1" findings="$2" count="$3"
  local blocking advisory n_blocking n_advisory

  if [[ -n "$rows" ]]; then
    printf '%s' "$rows"
    echo ""
  fi

  blocking="$(printf '%s' "$findings" | grep '^blocking|' || true)"
  advisory="$(printf '%s' "$findings" | grep '^advisory|' || true)"

  n_blocking="$(count_lines "$blocking")"
  n_advisory="$(count_lines "$advisory")"

  if [[ -n "$blocking" ]]; then
    echo "BLOCKING"
    printf '%s\n' "$blocking" | while IFS='|' read -r _sev slug rule msg; do
      printf '  %-28s %-10s %s\n' "$slug" "$rule" "$msg"
    done
    echo ""
  fi

  if [[ -n "$advisory" ]]; then
    echo "advisory"
    printf '%s\n' "$advisory" | while IFS='|' read -r _sev slug rule msg; do
      printf '  %-28s %-10s %s\n' "$slug" "$rule" "$msg"
    done
    echo ""
  fi

  # `drop_looks_valid` proves only that assets/ or kit/ EXISTS. A tree organised
  # by medium has an assets/ holding raw brand files and no slug directories, so
  # the walk yields nothing, every rule has nothing to read, and the report comes
  # out clean. That is the same failure the guard in cmd_check exists to stop,
  # one step further in: the directory is there, the drop is not.
  if [[ "$count" -eq 0 ]]; then
    error "0 assets checked -- assets/ holds no slug directories"
    echo "" >&2
    echo "  A directory can hold assets/ without holding a drop's assets. Every" >&2
    echo "  rule had nothing to read, so nothing was checked -- and zero checked" >&2
    echo "  is a failure, not a clean bill of health." >&2
    return 2
  fi

  if [[ "$n_blocking" -gt 0 ]]; then
    error "$count assets checked -- $n_blocking blocking, $n_advisory advisory"
    return 1
  fi

  success "$count assets checked -- clean, $n_advisory advisory"
  return 0
}

count_lines() {
  if [[ -z "$1" ]]; then
    echo 0
    return 0
  fi
  printf '%s\n' "$1" | wc -l | tr -d ' '
}
