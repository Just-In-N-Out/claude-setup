# Brief: FIXER for figma-to-bricks feature "faq-answer-space" (Mini pipeline, round 1)

You are the FIXER. A fresh reviewer checked the build and found three issues. Act on its findings; don't re-plan.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/faq-answer-space`, branch `worktree-faq-answer-space`, head `a503635`, base `cd9c1c9`. Work only there; never edit the main folder.
- Plan: `docs/plans/2026-10-26-faq-answer-space.md` (Justin's ⭐ answers 1A 2A 3A). The approved read-only copy is `~/.hermes/plans/figma-to-bricks/evidence/faq-answer-space/plan-approved.md`: never edit it; never add, rename or re-tag an AC; **never rename the six AC tests** (`AC1 …` … `AC6 …`, their names must stay exactly as they are).
- Evidence: `~/.hermes/plans/figma-to-bricks/evidence/faq-answer-space/`. The reviewer's receipts are in `verifier/` (read them, e.g. `probe-variants-{base,head}.txt`, `finding-painted-1440-{base,head}.png`, `finding-placed-1440-{base,head}.png`, `mutants.log`; never write there). Put your own logs and shots in `fixer/`.

## Skills (load first, say so in one line each)
1. `receiving-code-review` (Skill tool): verify each finding yourself before fixing it; fix the valid ones test first; push back with evidence on any you find wrong.
2. The project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (finisher/fixer role) and `references/rules-summary.md`, plus `references/rendering-validation.md`; read the worktree `CLAUDE.md` only by grep + offset/limit.
3. `engineering-best-practices`, `test-driven-development` and `mutation-testing-discipline` (Skill tool): F1 and F2 are guards, so prove each new guard's test fails when the guard is removed.

## The findings (reviewer's words, shortened)
- **F1 (medium), `src/core/understand/accordion.ts:90-101` (`spaceUnder`):** a fixed-height answer box with a fill, stroke or shadow still qualifies, so its inner space becomes the Content's bottom padding, outside the paint. Chrome at 1440, `framedAnswer` with fill `#E8EEF4`, radius 8: base panel 110px tall with the 26px inside the paint; head panel 84px with 26px of unpainted space under it. The 2px-stroke variant does the same. This breaks "at the design width nothing moves" and CLAUDE.md "Desktop must stay exact at the design width". Reviewer's suggestion: `spaceUnder` returns 0 when the box paints anything CSS draws (fills, stroke, shadows), e.g. via `painted`/`outlined` in `normalise/label-box.ts`, so painted boxes keep today's min height. Test to add: `framedAnswer` with a fill and with a stroke.
- **F2 (low), `accordion.ts:93`:** `kids` leaves out placed (absolute) layers but the box still hugs, so an ABSOLUTE 24px badge pinned to the bottom of a 130px auto-layout answer moves from 102–126 (base, under the words) to 56–80 (head, over the last line) at 1440. Reviewer's suggestion: return 0 when the box has any placed layer (`size.unpin` already keeps the min height for such boxes). Test to add: an answer column with a bottom-pinned ABSOLUTE child.
- **F3 (low), `accordion.ts:98-100`:** two mutants survive every feature test: `no-padding-sub` (the box's own top/bottom padding dropped from the measure: a padded variant would go 30 → 62px) and `no-cross-nudge` (a row layer's vertical offset dropped). Tests to add: an auto-layout answer with padding 16/16, 146px fixed, 84px of words → Content bottom 30, item height as drawn; an inferred row with one layer drawn lower → the space measured under that lower layer.

The suggestions are the reviewer's; the fix is yours to decide. Whatever you choose must keep the design width exact for every variant, keep Justin's Home and Repairs results (25 / 26px at every width from 1728 to 320), keep GRO, brainstorm and the Services save byte-identical to base, and keep all six AC tests passing unchanged. If a finding needs a design decision for Justin, make the ruling, write it as "My ruling, not yet confirmed" in `rulings[]` and the HANDOFF section.

## Checks on this machine
- `npm run check` (exits 0 while 55 unit + 5 performance corpus tests skip: run the `corpus-convert` soundness checks by hand on the repo files). Replay/snap `corpus/files/hydraulics-home.json`, `corpus/files/gro-home.json`, repo-root `figma-to-bricks-debug-page-1.json`, `figma-to-bricks-debug-design-inspo-brainstorm.json` and the Services save (`git show 2199895:figma-to-bricks-debug-page-1.json`) against base: pastes and lint at 390/768/1024/1440/design width.
- Chrome: `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` inline with literal paths (the worktree guard refuses `source`, loops, `$VAR` as a command and compound commands with variables: put multi-step logic in a script in your scratch folder `/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2/d6d1b80e-7af5-449f-b45c-e3ce3431cbe6/scratchpad/fixer-faq-answer-space/` and run it with `bash`/`node`). The AC browser tests run alone must show `skipped 0`; compare the full browser suite by test name with base (12 tests fail on base here too; `woff.test.ts` always skips).

## Rules
- Commit after each passing fix (plain `git commit -m "Review F1: …"`, no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` never lists CLAUDE.md). Don't push, don't bump `BUILD`, don't edit the worktree's `CLAUDE.md`, never bare `git stash`. Update the HANDOFF section and the ledger (`.superpowers/sdd/2026-10-26-faq-answer-space/progress.md`) with what changed.
- Leave the worktree committed and clean (no untracked files) when you stop; remove only your own scratch folder.
- Mini pipeline: if a fix needs more than ~3 source files or a design decision you can't rule on safely, stop with `status: stopped`, `stop_reason: escalate to full`.
- If you find any other bug or problem, don't fix it: list it in `found_else` (one line, evidence, severity).
- If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section. An empty list is the normal answer.

## Return (your final message)
`{name, status: ready-for-verify|stopped, summary, findings[{id, verdict: fixed|rejected, how, test, fails_without_fix}], rulings[], last_commit, checks{npm_check, browser_ac_tests, browser_suite_vs_base, pastes, lint}, shots[], found_else[], skill_lessons[]}` (only `status` and `summary` required). End with the line `MAIN SESSION: check and save these skill_lessons now.`
