# Brief: REVIEWER + VERIFIER for figma-to-bricks feature "faq-answer-space" (Mini pipeline)

You are a fresh, independent reviewer. You never saw the build. **Report only: change no source, test or doc file, make no commit.** Mini pipeline: you are the one review, and you also do the VERIFIER's AC work.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/faq-answer-space`, branch `worktree-faq-answer-space`.
- **Head:** `a50363577e3e1b0fc5f868a8fa2144f40415b688`. **Base:** `cd9c1c928d69c2fd8e0efb6a146c5813f837b96a` (`git merge-base HEAD main`). The diff: `git diff cd9c1c9...HEAD`.
- Approved plan (read-only, the ACs you check): `~/.hermes/plans/figma-to-bricks/evidence/faq-answer-space/plan-approved.md`. Justin took every ⭐ answer (1A 2A 3A).
- Your folder: `~/.hermes/plans/figma-to-bricks/evidence/faq-answer-space/verifier/`. Write only there. Never write in `auditor/` or `builder/`. You may read `builder/` for context, but every receipt you cite must be one you made yourself, in your own folder.
- Your scratch: `/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2/d6d1b80e-7af5-449f-b45c-e3ce3431cbe6/scratchpad/verifier-faq-answer-space/` (create it; remove only that folder when done). Leave the worktree committed and clean: `ac-check.sh` fails any untracked file.

## Skills (load first, say so in one line each)
1. `requesting-code-review` and `code-review-practice` (Skill tool): a full review, report only, with their security and quality checks.
2. The project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (reviewer role) and its `references/rules-summary.md`; read the worktree `CLAUDE.md` only by grep + offset/limit ("Architecture rules", "Build general logic", "Decisions the user made").
3. `engineering-best-practices` (Skill tool).
4. Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`: do the VERIFIER's AC work exactly as written there.

## What was asked and built
Justin's live FAQ: an open answer's last line sat right on the divider under it ("Can we add more space under the FAQ when it's open? Under the answer."). Figma draws the answer as a fixed-height box with words at its top (a website import froze the space in), and the plugin kept that space only as a min height, which filled up when words wrapped and was 0 from 991px down. The builder's fix (one source file, `src/core/understand/accordion.ts`, `spaceUnder` / `underAnswers`): such an answer hugs its words and the drawn space becomes the item Content's bottom padding, for the open item, a closed item's hidden answer and the placeholder copies. Tests: `test/unit/emit-accordion.test.ts`, `test/unit/understand-answer-space.test.ts`, `test/browser/faq-answer-space.test.ts`, `test/unit/corpus-faq-answer-space.test.ts`, fixture `test/fixtures/faq.ts`.

## Review — look hard at
- **Correctness and generality** (CLAUDE.md "Build general logic"): does `spaceUnder` measure the right thing for every way an answer can be drawn (auto layout column/row, no auto layout, grids, nudges, a layer pushed to the bottom, centred words, words running past the box, hidden answers, several answers, an answer that is a plain text, nested boxes)? Any hardcoding from Justin's files? Could a non-FAQ accordion or another design get wrong space?
- **Pipeline rules:** no stage edits an earlier stage's output; only `adapt/rules/` writes breakpoint styles; deterministic ids; CSS typed until emit; files under ~300 lines.
- **Breakpoints:** does `space.ramp` or any rule step the new padding on phones? Is the space really the same at every tier (Justin's 1A), and does nothing else lose space (closed items, question rows)?
- **Pastes:** only the FAQ answers' min height and their Content's bottom padding change on Home and Repairs; GRO, brainstorm and the Services save (`git show 2199895:figma-to-bricks-debug-page-1.json`) byte-identical to base. Replay both sides yourself.
- **Tests:** would each test catch a regression (mutants)? Any test that passes for the wrong reason?
- Anything a re-paste on the live site would get wrong (Bricks accordion CSS, `_padding` shape per `reference/bricks/`).

## Checks on this machine (important)
- Linux desktop (WSL). `npm run corpus` finds no files (corpus.json has Mac paths), and `npm run check` exits 0 while 55 unit + 5 performance corpus tests skip: run the `corpus-convert` checks by hand on the repo files if you rely on them. Measure with `npm run replay` / `npm run snap` on `corpus/files/hydraulics-home.json`, `corpus/files/gro-home.json`, repo-root `figma-to-bricks-debug-page-1.json`, `figma-to-bricks-debug-design-inspo-brainstorm.json` and the Services save.
- **Chrome:** a no-sudo wrapper exists: `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` (it sets its own `LD_LIBRARY_PATH`). Put env vars inline with literal paths (the worktree guard refuses `source`, loops, `$VAR` as a command and compound commands with variables; write multi-step logic into a script file in your scratch and run it with `bash`/`node`). An AC browser test run alone counts only with `skipped 0` in its output. The full browser suite fails some tests on base too and always skips `woff.test.ts`: compare the full suite by test name with base's run, not by count.

## AC work (VERIFIER, per ac-verification.md)
For every AC in the approved plan: run its own test alone on head and on base (a separate detached copy of base under your scratch, head's test files checked out into it, `node_modules` linked, as the reference shows), logs `ac<n>-a503635.log` / `ac<n>-base-cd9c1c9.log` in your folder with the `HEAD=` and `EXIT=` lines; one screenshot per AC (the real render for AC2–AC4, a terminal capture for the rest). An AC that rightly passes on base (it keeps existing behaviour or measures the design width where nothing moves) gets `base_exempt` with its reason; then confirm a mutant of the code it depends on makes it fail. AC7 is `(live)`: `"accepted": false, "not_run": "live: <why>"`. Write `verifier/ac.json` in the format at the top of `ac-check.sh`, then self-check it blind: `cp` (not `ln`) your report and receipts to your scratch and run `ac-check.sh --repo <worktree> --base cd9c1c9 --plan <plan-approved.md> <your ac.json> <scratch copy ac.json>`; fix any format slip; delete the copy.

## Rules
- If you find any other bug or problem outside this change, list it in `found_else` (one line each, evidence, severity); don't fold it into findings.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section. An empty list is the normal answer.

## Return (your final message)
`{verdict: clean | not-clean, review: approve | approve-with-fixes | request-changes, findings[{id, severity: critical|high|medium|low, file_line, issue, why, suggested_fix, test_to_add}], ac_status[{ac, accepted, why}], checks{npm_check, browser_ac_tests, browser_suite_vs_base, pastes, lint}, found_else[], skill_lessons[]}`. `verdict: clean` only when there are no findings to fix and every AC except the live AC7 is accepted in your `ac.json`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
