# Role: planner (plan amendment 2, after the fix rounds): shared-palette — AC8's see-through rule, and the fix rounds' rulings

You are a fresh planner (**Fable 5.2, high**). Amend the approved plan; change no source or test, commit nothing, start no agents; never
load any live site. Work under `~/.cache/spa2/`. Load `implementation-planning`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the plan-amendment paragraph: Amendments list,
`[amended]` marks, `ac-check.sh`'s `ac_start`, `bad_id`, `live` regexes on old and new, cited test names whole on one line, no
Amendments-list line starting with an AC id; an AC that rightly passes on its base is `base_exempt` backed by a mutant).

## Why
The verifier found F1 (`/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/verifier/ac.json`, `finding-F1-seethrough.log`):
Justin's real Figma file re-listed its 73 see-through colours as new when its own palette was given back, because the site reader skipped a
see-through `light`. Fixer 3 (branch `shared-palette-fix3`, head `34502f91`; evidence `…/shared-palette/fixer-3/`, its ledger section
"Fixer 3" and HANDOFF's fix 3 paragraph) now reads a see-through site colour as the site's, alpha kept, and reserves the id and variable of
any colour it still skips (`SiteColours.unread`). The approved AC8 says a see-through `light` is skipped and counted: that no longer holds,
and an auditor reading AC8 as written would refuse it. Taken under Justin's "go with recommended" (he is asleep); mark the new wording as
not yet confirmed.

## Amend
- Approved copy (read-only, your base): `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/plan-approved.md` (amendment 1).
- AC8: a see-through site colour is read with its alpha and links only at the same value (alpha to 3 places); a raw with a fallback, a raw
  with no variable, an unreadable light and a missing id are skipped and counted, and each skipped colour's id and variable (where it has
  one) are reserved so no written colour takes them. Read fixer 3's test `test/unit/site-colours-seethrough.test.ts` and AC8's test in
  `test/unit/site-colours.test.ts` on `34502f91` (`git show 34502f91:<path>`) and keep the cited test name if it still fits; if it changed,
  cite it whole on one line.
- Write into the plan's rulings (not ACs unless one is now false as written): fix 1 (a `--colours` file is never removed or overwritten;
  `palette-2.json`), fix 2 (the importer links its own id whatever the value; the plugin only at the same value, else `<name>-2` exact with
  a note per colour), fix 3 (above). Check every other AC (AC1–AC11) against the head's behaviour as those rulings describe it; amend only
  where an AC is false as written, and say so per AC.
- Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/planner-amend-2/plan-amended.md` with the regex receipts beside it
  (the main session installs it, keeping the old copy as `plan-approved-v2-before-amendment-2.md`). Ids, the live set (AC11) and cited test
  names unchanged unless a test name changed.

## Report (as text)
The amended plan's path and sha256; each change in one line; the regex receipts; `skill_lessons[{skill, lesson, evidence, enforce}]`
(empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
