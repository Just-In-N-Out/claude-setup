# Role: planner (plan amendment 1, before any build): shared-palette — after site-shared-styles took its Task 2

You are a fresh planner (**Fable 5.2, high**). Amend the approved plan; change no source or test, commit nothing, start no
agents; never load any live site. Work under `~/.cache/spa1/`. Load `implementation-planning`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the plan-amendment paragraph:
Amendments list, `[amended]` marks, `ac-check.sh`'s `ac_start`, `bad_id`, `live` regexes on old and new, cited test names
whole on one line, no Amendments-list line starting with an AC id; an AC that rightly passes on its base is `base_exempt`
backed by a mutant).

## Why
site-shared-styles' amendment 1 (installed: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/plan-approved.md`)
took shared-palette's Task 2 whole (the importer's by-value palette names `--color-<hex>`, id from the hex alone, the
AC2-named test "two pages of one site give a colour one id and one variable", the pins, `styles.txt`, HANDOFF's Q4 line).
Its note for you: `…/site-shared-styles/planner-amend-1/for-shared-palette.md`. It lists four lines of shared-palette's plan
that no longer hold:
1. Task 3's proof "fails with Task 2 reverted (`git checkout HEAD~1 -- src/core/site/colours.ts`)" — no Task 2 commit:
   use a mutant.
2. "RED on the base: the first and second" — on its base (main after site-shared-styles) AC1 and AC2 already pass: make
   them `base_exempt` backed by a named mutant (or reword), so the verifier and auditor can prove them.
3. "Assumed from the plans this builds after" still names `<page>-<hex>` and `site-color:<page>:<#HEX>`.
4. The last risk (site-shared-styles ships `--home-…` first) can't happen: drop or reword.
Also: the shared files and the order (shared-palette now builds after site-shared-styles, which writes the rule inline in
`colours.ts`; shared-palette later swaps those inline strings for `valueKey`/`valueName` from its new
`src/core/model/shared-colour.ts` and adds it to `test/unit/site-isolation.test.ts`'s allow-list).

## Amend
- Approved copy (read-only, your base): `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/plan-approved.md`.
- Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/planner-amend-1/plan-amended.md` with the regex
  receipts beside it (the main session installs it, keeping the old copy as `plan-approved-v1-before-amendment-1.md`).
  Ids, the live set and cited test names unchanged.

## Report (as text)
The amended plan's path and sha256; each change in one line; the regex receipts; `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
