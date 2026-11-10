# Role: planner (plan amendment only): staging-fit-renderer

You are a fresh planner (Fable 5.2, high). Amend the approved plan for what review 1's fix changed; change no source or
test, commit nothing, start no agents. Never edit the main folder or any worktree; never load any live site.

**Skills:** `implementation-planning`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
(the paragraph "When Justin decides something mid-build that changes an approved AC, a planner amends the plan": an
Amendments list at the top, changed lines marked, receipts encoding the old expectation named, `ac-check.sh`'s `ac_start`,
`bad_id` and `live` regexes run on old and new with ids, live set and cited test names unchanged, no Amendments-list line
starting with an AC id, each cited test name whole on one line).

## Inputs
- Approved copy (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/plan-approved.md`.
- The in-repo plan and tests at the fixer's head: `git -C /home/justin/Documents/FigmaToBricksV2 show b512ec6a4d0e5add0c29455190dbde3df8c1b9ff:docs/plans/2026-11-09-staging-fit-renderer.md`
  (branch `staging-fit-renderer-fix1`, base `fd1986dc`), `…:test/web/site-live.test.ts`, `…:docs/HANDOFF.md`.
- What changed (review 1, `evidence/staging-fit-renderer/review-1/review.json`; fixer receipts
  `evidence/staging-fit-renderer/fixer-1/`): (1) R1-1: an element the published page holds in another's place is no
  longer "a named exception the checks skip" (AC4's words) — it is named and compared, and the run fails (exit 1) unless
  its box agrees with the capture's within 2 px at a width where the capture holds a box; (2) Justin's standing rule
  "GET/read only": `site:live`'s Chrome refuses every request that isn't GET/HEAD/OPTIONS and every WebSocket, and its
  report lists them (AC2's "read-only" wording, if it names GET only for the old site); (3) R1-2: a published page under
  the old site's host is readable. Reconcile AC2 and AC4 (and AC5 live, if its text depends on the skip) with the tests
  at that head; change nothing else.

## Output
1. Write the amended plan to `/home/justin/.hermes/plans/figma-to-bricks/staging-fit-renderer-amended.md` (the whole plan,
   the in-repo text at `b512ec6a` as the base). Don't touch `plan-approved.md`.
2. Show the regex checks' output (old vs new).

## Report (as text)
The amendments one line each, receipts named, the regex check, then `skill_lessons[{skill, lesson, evidence, enforce}]`
(reusable only; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
