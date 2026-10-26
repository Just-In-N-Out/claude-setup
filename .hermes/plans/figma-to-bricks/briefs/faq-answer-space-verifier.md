# Brief: VERIFIER for figma-to-bricks feature "faq-answer-space" (Mini pipeline, after fix round 1)

You are a fresh VERIFIER. You never saw the build or the fix. **Read only: change no source, test or doc file, make no commit.**

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/faq-answer-space`, branch `worktree-faq-answer-space`.
- **Head:** `ac603ff0a3aa5861965c7b02dc103978a9989204`. **Base:** `cd9c1c928d69c2fd8e0efb6a146c5813f837b96a` (`git merge-base HEAD main`). The whole change: `git diff cd9c1c9...HEAD`; the fix round: `git diff a503635..ac603ff`.
- Approved plan (read-only, the ACs you check): `~/.hermes/plans/figma-to-bricks/evidence/faq-answer-space/plan-approved.md`. Justin took every ⭐ answer (1A 2A 3A).
- Your folder: `~/.hermes/plans/figma-to-bricks/evidence/faq-answer-space/verifier/` (create it; it is empty). Write only there; never in `auditor/`. Every receipt you cite must be one you made yourself, in your own folder. You may read `review-a503635/` (the first review), `fixer/` and `builder/` for context.
- Your scratch: `/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2/d6d1b80e-7af5-449f-b45c-e3ce3431cbe6/scratchpad/verifier2-faq-answer-space/` (create it; remove only that folder when done). Leave the worktree committed and clean: `ac-check.sh` fails any untracked file.

## Skills (load first, say so in one line each)
1. The project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (verifier role), `references/rules-summary.md` and `references/rendering-validation.md`.
2. `engineering-best-practices` (Skill tool).
3. Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`: do the VERIFIER's AC work exactly as written there.

## What to verify
Justin's live FAQ: an open answer's last line sat on the divider under it. The fix (`src/core/understand/accordion.ts` `spaceUnder` / `underAnswers`): an answer box Figma draws at a fixed height with its words at its top hugs its words, and the drawn space becomes the item Content's bottom padding, on every screen.

The first review (`review-a503635/`) found, and the fixer says it fixed (commits 7ed5301, 351565f, ac603ff):
- **F1 (medium):** a painted / outlined / shadowed answer box had its inner space moved outside its paint at the design width. Fix: `spaceUnder` returns 0 when the box paints anything of its own (fills, stroke, shadows, backdrop blur).
- **F2 (low):** a placed (absolute) layer pinned to an answer box's bottom rode up onto the words. Fix: `spaceUnder` returns 0 when the box holds any placed layer.
- **F3 (low):** two parts of the measure (the box's own top/bottom padding, a row layer's vertical offset) had no test. Fix: tests added.
- Fixer's ruling (not confirmed by Justin): such painted or placed-layer boxes keep today's min height (exact at the design width; from 991px down they lose the space, as on main).

Confirm each finding is really closed (reproduce the reviewer's probes at 1440 and 390 on base and head yourself), that the fix brought no new problem, and re-run the gates:
- `npm run check` (it exits 0 while 55 unit + 5 performance corpus tests skip because `corpus.json` has Mac paths: run the `corpus-convert` soundness checks by hand on the repo files).
- Pastes with `npm run replay`, base against head: `corpus/files/hydraulics-home.json` and repo-root `figma-to-bricks-debug-page-1.json` change only in their FAQ answers (no `_heightMin*`, Content `_padding.bottom` 25 / 26); `corpus/files/gro-home.json`, `figma-to-bricks-debug-design-inspo-brainstorm.json` and the Services save (`git show 2199895:figma-to-bricks-debug-page-1.json`) byte-identical. Lint with `npm run snap` at 390/768/1024/1440/design width no worse.
- Browser: `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` inline with literal paths (the worktree guard refuses `source`, loops, `$VAR` as a command and compound commands with variables: put multi-step logic in a script file in your scratch and run it with `bash`/`node`). AC browser tests run alone must show `skipped 0`; the full suite is compared by test name with base's run (12 tests fail on base here too; `woff.test.ts` always skips). Wait for long runs in the foreground (a bounded `node -e` poll on the log), not by ending your turn.

## AC work (per ac-verification.md)
For every AC in the approved plan: run its own test alone on head and on base (a separate detached copy of base under your scratch, head's test files checked out into it, `node_modules` linked, as the reference shows), logs `ac<n>-ac603ff.log` / `ac<n>-base-cd9c1c9.log` in your folder with `HEAD=` and `EXIT=` lines; one screenshot per AC (the real render for AC2–AC4, a terminal capture for the rest). An AC that rightly passes on base gets `base_exempt` with its reason, and you confirm a mutant of the code it depends on makes it fail. AC7 is `(live)`: `"accepted": false, "not_run": "live: <why>"`. Write `verifier/ac.json` in the format at the top of `ac-check.sh`, then self-check it blind: `cp` (not `ln`) your report and receipts to your scratch and run `ac-check.sh --repo <worktree> --base cd9c1c9 --plan <plan-approved.md> <your ac.json> <scratch copy ac.json>`; fix any slip; delete the copy.

## Rules
- Any other bug or problem: list it in `found_else` (one line, evidence, severity).
- Reusable lessons: don't edit any skill or memory file; list them in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section. An empty list is the normal answer.

## Return (your final message)
`{verdict: clean | not-clean, findings_closed[{id, closed, evidence}], new_findings[{id, severity, file_line, issue, why, suggested_fix}], ac_status[{ac, accepted, why}], checks{npm_check, corpus_sound, browser_ac_tests, browser_suite_vs_base, pastes, lint}, found_else[], skill_lessons[]}`. `verdict: clean` only when F1–F3 are closed, there are no new findings to fix, and every AC except the live AC7 is accepted in your `ac.json`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
