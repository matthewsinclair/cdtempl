# templprj

The placeholder venture. A deliberately neutral, fictional company that exists so the Claude Design templates have something concrete to be templates *of* -- a design system needs a brand to be a system for, and a pitch deck needs a company to be pitching.

Claude Design builds the template suite here, per `intent/st/ST0001/cd-brief.md`.

## What this directory is, and what it stopped being

**A worked example of the mandated output layout.** Whatever structure Claude Design settled on, this directory demonstrates it. Someone should be able to look here and see exactly what a real venture's `$CDSYNC_TARGET` contains once populated.

**It is a delivered drop, and it is read as a record rather than as live text.** Its front matter reads `spec_library_version: 2` and that is correct: a drop keeps the library edition it was ordered against, and is never restamped when the library moves. For the same reason its prose is left as delivered -- including the taxonomy figure it quotes, which the library itself no longer states. Editing it would falsify the delivery it records. `specs/library.md` states the rule under "What a library edition bump does, and does not do".

**It is NOT what `cdsync new` draws from, and this file used to say it was.** The as-built renders `templates/venture/*.tmpl` and nothing else; no code path reads this directory. The claim was written in round one when that was the plan, survived the plan changing, and was then inherited by a work package and a source comment that both repeated it. Corrected 9 Aug 2026 -- checked against `lib/cmd_new.sh`, not against the sentence.

## templprj is boring on purpose

The temptation with a placeholder is to make it charming -- a memorable name, a personality, a distinctive palette. That temptation must be resisted completely.

Every venture built from these templates inherits whatever character `templprj` has, and character inherited by default is character nobody chose. Placeholder names, neutral marks, wireframe-grade tokens. **If it looks like a real brand you would be pleased with, it is wrong.**
