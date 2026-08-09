#!/usr/bin/env bash
#
# cdsync - the file-level computations `check` runs on a drop
#
# Two scans live here: counting blanks, and finding colour literals. Both are
# computations over files rather than judgements about a drop, which is why
# they are separate from lib/cmd_check.sh -- that module applies the rules,
# these produce the facts the rules are applied to.
#
# Both scans are specified in the drop's own kit, at kit/kit.md, and not here.
# The treatment is what changes; the counting follows it. This module is the
# implementation of that spec and deliberately not a second copy of it.
#

# ============================================================================
# WHICH FILES COUNT
# ============================================================================

# Emit every file in an asset directory that a venture actually fills in.
#
# The line is not "files containing brackets", it is **files a venture edits to
# finish the asset**. A spec.md describes the work; it is not the work, and
# counting its placeholders would make every asset permanently unfinishable
# because a spec is meant to keep them.
#
# In scope:  *.md and *.html artefacts, and kit/tokens.*
# Out:       spec.md, index.md, RETURN.md, any README.md, notes/, vendor/,
#            exports/
each_artefact_file() {
  local dir="$1"

  find "$dir" -type f \
    \( -name '*.md' -o -name '*.html' \) \
    -not -name 'spec.md' \
    -not -name 'index.md' \
    -not -name 'RETURN.md' \
    -not -name 'README.md' \
    -not -path '*/notes/*' \
    -not -path '*/vendor/*' \
    -not -path '*/exports/*' \
    2>/dev/null | sort
}

# Every text file in an asset directory, for the colour scan -- which has a
# wider reach than the blank count because a hue can enter through a stylesheet
# or a script as easily as through an artefact.
#
# `exports/` is skipped as binary output. `vendor/` is NOT skipped: exclusion is
# by declaration, not by path. See is_generated_file.
#
# Binary files are skipped by content, not by name. See is_binary_file for why
# that decision belongs here rather than to whichever grep happens to be
# installed.
each_scannable_file() {
  local dir="$1"
  local file

  while IFS= read -r file; do
    if [[ -z "$file" ]]; then continue; fi
    if is_binary_file "$file"; then continue; fi
    printf '%s\n' "$file"
  done < <(find "$dir" -type f -not -path '*/exports/*' 2>/dev/null | sort)
}

# Is this file binary, and therefore not somewhere a colour can be authored?
#
# The colour scan's verdict used to rest on an undocumented grep heuristic rather
# than on anything this code decided, and that is the whole defect. A 2.4M JPEG
# in a real drop carries **eleven** byte sequences matching the hex pattern. BSD
# grep suppresses every one of them, because it sniffs binary content itself and
# then silently reports nothing -- so the check passed. Force the same file
# through as text (`grep -a`) and all eleven surface as *blocking* findings
# against an asset whose only crime is holding a photograph.
#
# Passing by luck is not passing. A grep build that does not suppress, a
# `--binary-files=text` in someone's environment, or a photograph whose first
# block happens to carry no NUL, and the identical drop fails. A rule whose
# verdict depends on which grep is installed is not a rule.
#
# So the decision is made here, explicitly, and the test is deliberately ours
# rather than grep's: a NUL byte inside the first block means binary. Same
# heuristic git uses, same answer on every platform.
#
# Content, not extension. An extension list is a maintained exception list -- it
# goes stale the first time a format arrives that nobody added, and it fails in
# the direction that stops checking rather than the direction that complains.
# That is the same trap is_generated_file documents at length, and it is not
# worth falling into twice in one file.
is_binary_file() {
  local file="$1"
  local total stripped

  total="$(head -c 8000 "$file" 2>/dev/null | wc -c)"
  stripped="$(head -c 8000 "$file" 2>/dev/null | LC_ALL=C tr -d '\0' | wc -c)"

  (( total != stripped ))
}

# Does this file declare itself generated, in a comment near the top?
#
# Exclusion from the colour check is by declaration rather than by path. The
# first design excluded `vendor/` by path and was wrong: `support.js` cannot be
# moved there, because the authoring runtime emits it as a sibling of every
# .dc.html and that path is not the author's to set. A path rule therefore needs
# support.js named as a special case -- which is exactly the maintained
# exception list that prohibitions-over-instructions exists to avoid,
# reintroduced by the fix meant to prevent it.
#
# Comment-scoped on purpose. A README that says "generated" in prose is prose,
# and gets checked like anything else. Only a real comment marker exempts.
#
# Two things make that scoping actually hold, and a first cut got both wrong:
#
# **The comment opener is anchored to the start of the line.** Accepting a bare
# `*` anywhere on the line exempted both `vendor/README.md` and
# `exports/README.md`, because `- **Do not edit these files.**` and `| **not
# generated** |` each carry an asterisk ahead of the marker. That is the
# path-shaped exemption creeping back in through a sloppy comment test -- the
# same failure the declaration rule replaced, wearing a different hat.
#
# **Near the top means five lines, not twenty.** A generated-file banner is the
# first thing in the file; prose that happens to discuss generation is anywhere.
# Both real runtime banners in the drop sit on line 1 or 2.
#
# Either fix alone would have caught the two READMEs. Both are applied because
# a false exemption is the dangerous direction: it does not fail the check, it
# silently stops checking.
is_generated_file() {
  local file="$1"

  head -n 5 "$file" 2>/dev/null | grep -qiE \
    '^[[:space:]]*(//|/\*|\*|<!--|#).*(@generated|GENERATED|do not edit|copied .*starter)'
}

# ============================================================================
# BLANKS
# ============================================================================

# Emit every blank in one file, one per line, interior whitespace collapsed.
#
# A blank is `[...]` where the content starts with a lower-case letter or digit,
# has no line break, and is at most eighty characters. Lower-case initial is what
# separates a blank from prose that happens to use brackets.
#
# Three exclusions, in the order they bite:
#
#   1. Code spans and fenced blocks. A literal `[bracketed]` inside a "no blanks
#      remain" checklist documents the marker rather than being an instance of
#      it. This is the exclusion most likely to be forgotten, and it is why a
#      completion checklist can safely name the thing it checks for. In HTML the
#      equivalent constructs are <code> and <pre>.
#   2. Markdown links -- `[...]` followed immediately by `(`.
#   3. The verblock line, whose placeholders are stamped by tooling rather than
#      filled by a person, so they are not work remaining.
#
# Everything else counts. In particular front-matter values other than the
# verblock DO count, and so do data-props defaults: a venture really does replace
# `"default": "[venture name]"`, and the props panel is usually where it does so
# first. Excluding them would undercount the primary edit site.
each_blank_in_file() {
  local file="$1"

  awk '
    # Fenced code blocks, markdown only. Toggling rather than counting, because
    # an unterminated fence should swallow the rest of the file exactly as a
    # renderer would.
    /^[[:space:]]*```/ { in_fence = !in_fence; next }
    in_fence { next }

    # Script blocks. An array literal is not a placeholder, and a real drop
    # proved it: three assets in Gyre and Gymble were reported `status: complete
    # but N blanks remain` -- **blocking** -- on `[]`, `[k]` and a bracket pair
    # around `n(''product'')`, every one of them JavaScript inside a .dc.html.
    #
    # The neighbouring rule in this same file already knew to do this. Rule 3
    # strips <style> before looking for metrics, for exactly the same reason: a
    # width is not a claim. Rule 1 stripped <code>, <pre> and fences but not
    # <script>, so two scanners over the same markup disagreed about what counts
    # as prose -- which is how `[$0.0m]` got through, and it is the same shape of
    # bug wearing different clothes.
    /<script[ >]/ { in_script = 1 }
    in_script && /<\/script>/ { in_script = 0; next }
    in_script { next }

    /verblock:/ { next }

    {
      line = $0

      # Strip the constructs that quote rather than use the marker. Done before
      # scanning so a blank inside one is never seen at all.
      gsub(/`[^`]*`/, " ", line)
      gsub(/<code>[^<]*<\/code>/, " ", line)
      gsub(/<pre>.*<\/pre>/, " ", line)

      rest = line
      while (match(rest, /\[[^][]*\]/)) {
        inner = substr(rest, RSTART + 1, RLENGTH - 2)
        after = substr(rest, RSTART + RLENGTH, 1)
        rest = substr(rest, RSTART + RLENGTH)

        if (after == "(") { continue }
        if (length(inner) > 80) { continue }

        # A leading currency symbol does not stop something being a blank.
        # `[$0.0m]` on an ask slide was invisible to this rule, which meant a
        # deck could declare `blanks: 0` while its four most consequential
        # numbers were still placeholders -- rule 1 passing an asset precisely
        # because the check could not see the thing it exists to see.
        #
        # An optional uppercase prefix comes with it, for `A$` and `US$`.
        #
        # The symbol is stripped for the test only; the blank is reported with it
        # intact, because `$0.0m` is what a person has to replace.
        probe = inner
        sub(/^[A-Z]*(\$|£|€|¥)/, "", probe)

        # Still lower-case-or-digit after stripping, so a symbol on its own is
        # not a blank -- `[$]` names no unknown, exactly as `[]` does not.
        if (probe !~ /^[a-z0-9]/) { continue }

        gsub(/[[:space:]]+/, " ", inner)
        sub(/^ /, "", inner)
        sub(/ $/, "", inner)
        print inner
      }
    }
  ' "$file"
}

# Emit every blank across an asset, one per line. Occurrences, not unique --
# the caller decides which number it wants.
#
# `blanks` counts occurrences, because that is the number of substitutions a
# person faces. `blanks_unique` counts distinct strings, because that is the
# number of decisions. Neither alone is honest: 62 and 31 is a materially
# different picture from either number by itself.
each_blank_in_asset() {
  local dir="$1"
  local file

  while IFS= read -r file; do
    if [[ -z "$file" ]]; then continue; fi
    each_blank_in_file "$file"
  done < <(each_artefact_file "$dir")

  return 0
}

# ============================================================================
# COLOUR LITERALS
# ============================================================================

# Every colour form the scanner reads, declared ONCE.
#
# It was written out twice -- once for artefacts, once for the kit -- identical
# by hand rather than by construction. That is how a gap gets closed on one side
# only, and the gap was real: matthewsinclair.com's 2026-08-02 kit is defined
# entirely in `oklch()`, which neither copy read. Had only the artefact copy
# been extended, every kit colour would have been unknown and every artefact
# colour a leak; had only the kit copy been, the reverse. Both wrong, and the
# check would have reported either with confidence.
#
# The modern CSS colour functions are here because a kit is now as likely to be
# written in `oklch()` as in hex, and a guard that cannot see the colour space
# the kit is written in is not a guard. `oklch` and `oklab` precede `lch` and
# `lab` so the longer name wins the alternation.
CDSYNC_COLOUR_RE='#[0-9a-f]{3,8}\b|rgba?\([^)]*\)|hsla?\([^)]*\)|oklch\([^)]*\)|oklab\([^)]*\)|lch\([^)]*\)|lab\([^)]*\)|color\([^)]*\)'

# THE colour normaliser, reading raw literals on stdin and emitting comparable
# ones. Both sides of the check pipe through this, so the artefact and the kit
# can never be normalised by two rules that drift.
#
# Three things it settles.
#
# **Case and shorthand.** `#FFF`, `#ffffff` and `#FFFFFF` are one colour, and a
# check reporting them as three would be noise nobody reads.
#
# **Form.** `rgb()` and `rgba()` collapse to hex, so a value written one way in
# the kit and another in an artefact still compares equal. The check is about
# which hues exist, not about how they were typed.
#
# **Alpha zero is not a colour.** `rgba(0,0,0,0)` is the `transparent` keyword
# spelled long-hand -- it carries no hue, and the rule exists to catch a hue
# entering an artefact without passing through the kit. Dropping it is not a
# loophole: a fully transparent value has nothing to leak. Alpha above zero is
# kept and compared on its hue alone, because the kit has no alpha tokens and
# opacity is a separate axis from palette.
normalise_colours() {
  # `LC_ALL=C` is the point of this form, not decoration. The character classes
  # are what shellcheck asks for, but unlike the `A-Z` range they are
  # locale-aware, and a Turkish locale lowercases `I` to a dotless `ı`. No hex
  # digit is at risk -- hex stops at F -- but the named colours are: `INDIGO`,
  # `INDIANRED` and `MIDNIGHTBLUE` all carry an `I`, and this is the one
  # function whose whole job is deterministic normalisation. Pinning the locale
  # makes the classes exactly A-Z and a-z, so the behaviour is the old one and
  # the locale can no longer reach it.
  LC_ALL=C tr '[:upper:]' '[:lower:]' | awk '
    # Is this colour-function argument a number, or an identifier?
    #
    # `rgb(r, g, b)` is not a colour, it is a colour being computed. A real drop
    # proved this too: `gg-wash.js` is a colour-space converter, and rule 4
    # reported it as **blocking** for carrying `hsl(r, g, b)` and `rgb(p, q, t)`
    # -- eight matches, not one of them a literal. One was `rgb(h, Math.min(1, s)`,
    # matched with the parenthesis unbalanced, which is the tell that the pattern
    # was reading code.
    #
    # Skipping .js would be the wrong fix twice over: a real `#d97757` in a script
    # is a genuine leak and the module says so, and a path rule is the maintained
    # exception list this file already refuses once. So the test is on the content
    # -- an argument beginning with a digit, sign or point is a number, anything
    # else is a name. `120`, `50%`, `.5` and `-3` pass; `r`, `p`, `d[i` and
    # `Math.min(1` do not.
    function is_number(s) {
      return s ~ /^[-+.0-9]/
    }

    {
      value = $0
      gsub(/[[:space:]]+/, "", value)

      if (value ~ /^#[0-9a-f]{3}$/) {
        printf "#%s%s%s%s%s%s\n", \
          substr(value,2,1), substr(value,2,1), \
          substr(value,3,1), substr(value,3,1), \
          substr(value,4,1), substr(value,4,1)
        next
      }

      if (value ~ /^#[0-9a-f]{8}$/) {
        if (substr(value,8,2) == "00") { next }
        print substr(value, 1, 7)
        next
      }

      if (value ~ /^rgba?\(/) {
        body = value
        sub(/^rgba?\(/, "", body)
        sub(/\)$/, "", body)
        n = split(body, part, ",")
        if (n >= 4 && part[4] + 0 == 0) { next }
        if (n >= 3) {
          if (!is_number(part[1]) || !is_number(part[2]) || !is_number(part[3])) { next }
          printf "#%02x%02x%02x\n", part[1], part[2], part[3]
          next
        }
      }

      if (value ~ /^hsla?\(/) {
        body = value
        sub(/^hsla?\(/, "", body)
        sub(/\)$/, "", body)
        n = split(body, part, ",")
        if (n >= 4 && part[4] + 0 == 0) { next }
        if (n >= 3) {
          if (!is_number(part[1]) || !is_number(part[2]) || !is_number(part[3])) { next }
        }
      }

      # The modern CSS colour functions: oklch(), oklab(), lch(), lab(), color().
      #
      # Compared as normalised TEXT, not converted to hex. Converting properly
      # needs a colour-space transform, and converting approximately is worse
      # than not converting at all -- two distinct kit colours that round to one
      # hex value would report a leak that is not there. Both sides of the check
      # come through here, so text comparison is sound: the same colour spelled
      # with different spacing still compares equal.
      #
      # Read from `$0` rather than `value`, because these take SPACE-separated
      # arguments and the whitespace has already been stripped by the time
      # `value` exists. That strip is why the comma splits above cannot be
      # reused, and why this branch parses its own arguments.
      if (value ~ /^(oklch|oklab|lch|lab|color)\(/) {
        body = $0
        sub(/^[a-z]+\(/, "", body)
        sub(/\)[[:space:]]*$/, "", body)

        # `/ 0` is `transparent` in modern spelling -- no hue, nothing to leak.
        # The same judgement the rgba() and hsla() branches already make, in the
        # syntax that replaced the fourth comma-separated argument.
        if (body ~ /\/[[:space:]]*0(\.0*)?%?[[:space:]]*$/) { next }
        if (body ~ /\/[[:space:]]*\.0+%?[[:space:]]*$/) { next }
        sub(/\/.*$/, "", body)

        gsub(/^[[:space:],]+|[[:space:],]+$/, "", body)
        n = split(body, part, /[[:space:],]+/)

        # `color()` names its colour space first and its components after; the
        # others are three components with no prefix.
        first = (value ~ /^color\(/) ? 2 : 1
        if (n < first + 2) { next }
        for (i = first; i < first + 3; i++) {
          if (!is_number(part[i])) { next }
        }

        print value
        next
      }

      print value
    }
  '
}

# Emit every colour literal in a file, one per line, normalised.
each_colour_in_file() {
  local file="$1"

  grep -oiE "$CDSYNC_COLOUR_RE" "$file" 2>/dev/null \
    | normalise_colours
}

# Emit every colour the kit declares, normalised identically.
#
# Requires jq. Gate it ONCE before the loop that calls this, never per call --
# a memo set inside a command substitution dies with its subshell, which turns
# a single install hint into one per item.
each_kit_colour() {
  local tokens="$1"

  jq -r '.. | strings' "$tokens" 2>/dev/null \
    | grep -oiE "$CDSYNC_COLOUR_RE" \
    | normalise_colours \
    | sort -u
}

# ============================================================================
# ILLUSTRATIVE NUMBERS
# ============================================================================

# Emit every metric-shaped literal in a file: currency amounts, percentages,
# multipliers, and separated thousands.
#
# An unmarked number in a delivered artefact is a claim. This is the input to
# check rule 3, which is a safety property rather than a habit -- Claude Design
# reports it as the failure that recurs and has the worst consequences.
#
# Two exclusions, neither of which was in the spec, because both only became
# visible the first time the rule was actually run against the templates.
#
# **A number inside a blank is not a claim.** `[svg, png at 1x/2x/3x]` and
# `determinate — [00%]` are placeholders; they are already marked as the thing a
# venture must replace, which is a stronger marking than `illustrative` would be.
# Flagging them inverts the rule -- it would demand a claim-marker on the one
# construct that is definitionally not a claim.
#
# **A number in a stylesheet is not a metric.** Every percentage in the drop's
# built artefacts was a CSS `width:` or `height:` in an inline style attribute.
# A rule that fires on `width: 40%` is a rule that gets switched off, and a check
# nobody runs guards nothing.
#
# **The currency symbols are an alternation, not a bracket class, and that is not
# a style choice.** `[$£€¥]` is a set of *bytes* under a C locale, and `£` is two
# of them (C2 A3). The class therefore matches the second byte on its own, and
# `£12` came out of a real drop as a lone A3 followed by `12` -- an invalid
# sequence that renders as a replacement character. The match starts mid-letter.
#
# `(\$|£|€|¥)` matches each symbol as a complete sequence, so it cannot begin
# inside one, and it behaves the same under every locale.
#
# Rule 1 already had this right: each_blank_in_file strips a leading currency
# symbol with `(\$|£|€|¥)`, alternation, for the same reason. Two rules in this
# file, one concept, two spellings, and only one of them correct -- which is the
# third time that exact shape has produced a bug here. **If these two ever
# disagree again, they should become one shared definition rather than a third
# careful copy.**
each_metric_in_file() {
  local file="$1"

  awk '
    /<style[ >]/ { in_style = 1 }
    in_style && /<\/style>/ { in_style = 0; next }
    in_style { next }

    # THE OTHER HALF OF A BUG THIS FILE ALREADY DIAGNOSED. each_blank_in_file
    # above carries the same three lines, and its comment says rule 3 strips
    # <style> "for exactly the same reason: a width is not a claim" -- then names
    # the defect as two scanners over the same markup disagreeing about what
    # counts as prose. Rule 1 was fixed and rule 3 was not, so the disagreement
    # stayed live, pointing the other way.
    #
    # It cost three of the seven rule-3 findings on G and G: width calc(100% -
    # 44px) and height 100%, built in JS string literals rather than written in a
    # style block. A CSS length is not an assertion about the world, and no
    # instruction could ever satisfy the finding -- it would have reported the
    # same three every round forever.
    #
    # THIS IS NOT THE gg-wash.js ARGUMENT INVERTED. That one says a hex literal
    # in a script is a real leak for rule 4, and it still is: the script renders
    # that colour. A number in a script is the opposite case, because it is
    # arithmetic rather than a claim anyone reads.
    #
    # What it gives up: a genuine statistic living only in a data structure,
    # rendered into the page by script, is now invisible to rule 3. Nothing in
    # the four trees does that, and the prose a reader actually sees is markup,
    # which is still read.
    /<script[ >]/ { in_script = 1 }
    in_script && /<\/script>/ { in_script = 0; next }
    in_script { next }

    {
      line = $0
      gsub(/style="[^"]*"/, " ", line)
      gsub(/\[[^][]*\]/, " ", line)
      print line
    }
  ' "$file" 2>/dev/null \
    | grep -oE '(\$|£|€|¥)[0-9][0-9,.]*[kmbKMB]?|[0-9][0-9,.]*%|[0-9]+(\.[0-9]+)?x\b|[0-9]{1,3}(,[0-9]{3})+'
}

# ============================================================================
# THE GENERATED-DOCUMENT STALENESS PROBE
# ============================================================================

# Advisory line when BOOTSTRAP-CD.md is older than the repository it describes.
# Ordered by hv on 9 Aug 2026, shape (a): a warning, never blocking, and never
# a numbered check rule -- the six rules judge what Claude Design delivered,
# and this judges Cdsync's own output.
#
# REPOSITORY-scoped, matching the generator's own reach. Scoped to the design
# tree it reports clean on the provable case: what stales the document -- a new
# steel thread, an ADR -- usually lives outside that tree, and Baize's stale
# snapshot was the newest file in its own tree when it was 1.3 days behind the
# repository. The dangerous direction is always the clean report.
#
# TRACKED AND UNTRACKED-UNIGNORED FILES ONLY, via git. An mtime sweep of the
# disk would compare against _build/ churn and cry wolf forever, and a guard
# people learn to ignore is worse than no guard. Outside a repository the walk
# falls back to the target tree, which is then the whole visible world.
#
# One definition, two callers -- doctor and check -- because two hand-rolled
# copies of one probe is how this project's scanners have drifted before.
report_bootstrap_staleness() {
  local target="$1"
  local doc="$target/BOOTSTRAP-CD.md"
  local repo file count=0 example=""

  if [[ ! -f "$doc" ]]; then
    return 0
  fi

  repo="$(git -C "$target" rev-parse --show-toplevel 2>/dev/null)" || repo=""

  if [[ -n "$repo" ]]; then
    while IFS= read -r -d '' file; do
      [[ -z "$file" ]] && continue
      [[ "$repo/$file" -nt "$doc" ]] || continue
      count=$((count + 1))
      if [[ -z "$example" ]]; then example="$file"; fi
    done < <(git -C "$repo" ls-files -z --cached --others --exclude-standard 2>/dev/null)
  else
    while IFS= read -r -d '' file; do
      [[ "$file" -ef "$doc" ]] && continue
      [[ "$file" -nt "$doc" ]] || continue
      count=$((count + 1))
      if [[ -z "$example" ]]; then example="${file#"$target"/}"; fi
    done < <(find "$target" -type f ! -name '.DS_Store' -print0 2>/dev/null)
  fi

  if [[ "$count" -eq 0 ]]; then
    return 0
  fi

  warn "BOOTSTRAP-CD.md is older than $count file(s) in the repository -- eg $example"
  echo "  A stale snapshot hands Claude Design numbers the tree has moved past," >&2
  echo "  and the last collision cost a full export cycle. Regenerate before" >&2
  echo "  sending:  cdsync bootstrap --target $target" >&2
  return 0
}
