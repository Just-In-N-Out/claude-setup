# Role: planner (plan amendment only): site-motion

You are a fresh planner (Opus 5.5, high). Amend the approved site-motion plan for two of Justin's decisions; change no
source or test, commit nothing, start no agents. Never edit the main folder or any worktree; never load any live site.

**Skills:** `implementation-planning`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
(the paragraph "When Justin decides something mid-build that changes an approved AC, a planner amends the plan" — follow it
exactly: Amendments list at the top, each changed line marked, receipts that encode the old expectation named, `ac-check.sh`'s
`ac_start`, `bad_id` and `live` regexes run on the old and new plan with ids, live set and test-name lines unchanged, no
Amendments-list line starting with an AC id).

## Inputs
- Approved copy (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/plan-approved.md`. Its end holds
  an "Amendment 1" paragraph the main session appended (AC4 wording) — fold it into your Amendments list properly.
- The in-repo plan at head: `git show 85a1f2fe36124135c6f37c8d1a0b7b9d655b09ec:docs/plans/2026-11-07-site-motion.md`
  (branch `worktree-agent-acb4df7f943f7bd4c`; base `7ff9ba4a`); the tests at that head (`git show 85a1f2fe:<path>`).
- **Decision 1 (review 2 R2-1, Justin "Fix it, then merge (Recommended)", `evidence/site-motion/review-2/justin.json`):**
  an entrance that starts hidden (start frame over rest look has opacity 0 or visibility hidden) whose site name lacks a
  capital "In" takes the Interaction type `<paste name>In`, frames playing by `.c.brx-animate-<paste name>In`; others keep
  the site name. Affects AC4 (and AC7 if its text names the type). Reconcile with `test/unit/site-motion.test.ts` and
  `test/web/site-motion-proof.test.ts` at head.
- **Decision 2 (verifier, AC11, Justin "Accept, fix 7.59 px later (Recommended)", `evidence/site-motion/verifier/justin-ac11.json`):**
  AC11's still-frame clause becomes: the code route's still frames within 2 px at 1440, 768 and 390; the Elementor route's
  still frames no worse than the same Elementor paste without motion (B-Dry's page part is 7.59 px off at 390 on base
  `7ff9ba4a` too; a separate job will bring it within 2 px). Match it to `test/web/site-motion-bdry.test.ts` at head
  (lines ~259–272) and Task 13's text.
- **Also reconcile (no decision needed, out-of-date wording):** AC1's list of the fixture's keyframes (the fixture gained
  `appear` for R1-1 and `fadeUp` for R2-1; check `test/web/capture-motion.test.ts` at head).

## Output
1. Write the amended plan to `/home/justin/.hermes/plans/figma-to-bricks/site-motion-amended.md` (the whole plan, the
   in-repo text as the base, amendments applied). Don't touch `plan-approved.md`; the main session installs yours.
2. Show the regex checks' output (old vs new: ids, live set, test-name lines).

## Report (as text)
The amendments one line each, the receipts named, the regex check, then `skill_lessons[{skill, lesson, evidence, enforce}]`
(reusable only; empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
