# Role: planner (plan amendment only): site-slider

You are a fresh planner (Fable 5.2, high). Amend the approved plan's wording for what fix round 1 changed; change no
source or test, commit nothing, start no agents. Never edit the main folder or any worktree; never load any live site.

**Skills:** `implementation-planning`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
(the paragraph "When Justin decides something mid-build that changes an approved AC, a planner amends the plan": an
Amendments list at the top, changed lines marked, receipts encoding the old expectation named, `ac-check.sh`'s `ac_start`,
`bad_id` and `live` regexes run on old and new with ids, live set and cited test names unchanged, no Amendments-list line
starting with an AC id, each cited test name whole on one line).

## Inputs
- Approved copy (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/plan-approved.md`.
- The in-repo plan and tests at fixer 1's head: `git -C /home/justin/Documents/FigmaToBricksV2 show 84e591dbdaf6fe3e6237be89098204fb9ea8c085:docs/plans/2026-11-09-site-slider.md`
  (branch `site-slider-fix1`, base `fd1986dc`), `…:test/unit/site-slider.test.ts`, `…:docs/HANDOFF.md`.
- What changed (reviews 1 and 2: `evidence/site-slider/review-1/review.json`, `review-2/review.json` R2-5; fixer receipts
  `evidence/site-slider/fixer-1/`): **Q4 A's reading** — the plan says a Bricks tier takes "the site's value at each
  tier's widest width"; since review 1's R1-3 a tier takes what the site shows across most of the tier's widths (the
  wider part on a tie), the desktop value the design width's, and a tier the site cuts is named in the note (for
  Elementor's 3/2/1: 1 slide at exactly 767 and 3 at 992–1023 where the site shows 2). Also record as amendments, where
  an AC line or the rule text says otherwise: arrows, dots and loop are read from either Elementor key family or from
  what the captured page shows (R1-1); a Bricks checkbox key is written only when true (R1-2). **These follow the
  reviewers' findings under Justin's standing "go with recommended" (2026-11-09); mark the Q4 A reading "to be confirmed
  with Justin".** A second fix round (R2-1…R2-3: a slide's own height kept, the restore class not beating the site's
  look, arrow and dot places by containing box) is under way: if AC3–AC6's text already covers those as written, leave
  them; if a line contradicts them, mark it too and say so.

## Output
1. Write the amended plan to `/home/justin/.hermes/plans/figma-to-bricks/site-slider-amended.md` (the whole plan, the
   in-repo text at `84e591db` as the base). Don't touch `plan-approved.md`.
2. Show the regex checks' output (old vs new).

## Report (as text)
The amendments one line each, receipts named, the regex check, then `skill_lessons[{skill, lesson, evidence, enforce}]`
(reusable only; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
