# Brief: REVIEWER 2 (review only) for figma-to-bricks feature "label-floor" (Full pipeline)

You are the second fresh, independent full reviewer. You never saw the build or review 1's run. Report only: change nothing.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/label-floor` (branch `worktree-label-floor`, HEAD 72c47b4, clean). Base: `cd9c1c9`. Review the whole `git diff cd9c1c9...HEAD`, with extra care on the fix delta `6cfd9e2..72c47b4` (review 1's fixes).
- Approved plan (the contract, read-only): `~/.hermes/plans/figma-to-bricks/evidence/label-floor/plan-approved.md` (AC1–AC15; AC9 live, owed to Justin). Worktree copy `docs/plans/2026-10-26-label-floor.md`; ledger `.superpowers/sdd/2026-10-26-label-floor/progress.md`; HANDOFF section in `docs/HANDOFF.md`.
- Review 1's findings and the ruling on each are in `~/.hermes/plans/figma-to-bricks/briefs/label-floor-fixer-1.md`; its evidence in `~/.hermes/plans/figma-to-bricks/evidence/label-floor/review1/`; the fixer's in `…/fix1/`. Confirm each of F1–F4 is closed as ruled, and look for regressions the fixes caused, but don't stop there: review everything.
- Put scratch (copies made with `git archive`, mutation runs, replays, shots) under `~/.hermes/plans/figma-to-bricks/evidence/label-floor/review2/`. If the harness refuses a report file write, return the full report as text. Never write in the worktree; `git status --porcelain` must be empty when you finish.
- Local `main` has moved to f46f8a2 (faq-answer-space merged: `understand/accordion.ts`, its tests, HANDOFF). Say if you see a semantic interaction; don't review that feature.

## Skills (load first, one line each)
Project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, REVIEWER role, plus `references/rules-summary.md` and `references/rendering-validation.md`; only the worktree `CLAUDE.md` sections you need), `engineering-best-practices`, `requesting-code-review` and `code-review-practice` (skip their "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer), `mutation-testing-discipline`.

## What was asked
Justin's rule (2026-10-26): words in a pill at least 13px and "Learn more"-style links at least 15px on every screen; text at or above stays; every other text keeps Figma's size. Answers 1A–5A (round-ended pills; linked go-words or linked words with a → after; list pills keep their size; the size on the element, the Figma style's class unchanged; Chrome for Testing locally). Part 2, his "Space gives way": a row drawn exactly as wide as its items gives the growth out of its gaps (6A all alike, 7A at most half each, 8A else widen into the column's room, else words keep their drawn size with a note, 9A GRO's other links recorded only). Fix-round rulings (not yet confirmed by Justin): menus and footer link lists, and a menu's current item in a pill, keep their drawn size; a tight row inside a row passes its widening up the chain. General logic only: never keyed on a file's names, ids, words, sizes or colours.

## What to do
- Review against the plan and the architecture rules (stages; no stage edits an earlier stage's output; only `adapt/rules/` writes breakpoint styles; rules read widths from the layout plan; deterministic ids; small files; sandbox built-ins only). Hunt for false positives and negatives of the pill / link / menu / tight-row recognition with designs that fool them (free-drawn groups, mixed columns, nested rows, hover and phone copies, drawn phone designs, sliders, lists, accordions, forms), layout-plan vs CSS disagreements at laptop/tablet/phone tiers, and paste nondeterminism.
- Run the gates yourself: `npm run check`; the browser suite with `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b` (this machine's baseline: 12 font-environment failures, names in `~/.hermes/plans/figma-to-bricks/evidence/label-floor/builder/baseline-failures-names.txt`; compare by name). `npm run corpus` measures nothing here (Mac paths); in a scratch copy re-point corpus.json's hydraulics/gro entries to `corpus/files/` to un-skip 22 corpus unit tests. Measure the five files (corpus/files/hydraulics-home.json, corpus/files/gro-home.json, repo-root figma-to-bricks-debug-page-1.json, figma-to-bricks-debug-design-inspo-brainstorm.json, Services = `git show 2199895:figma-to-bricks-debug-page-1.json`) with replay/snap and the scripts in `~/.hermes/plans/figma-to-bricks/evidence/label-floor/corpus/`, at 1728/1440/1366/1300/1280/1200/1100/1024/992/768/480/390/375/360/320.
- Try mutations on the key guards in a scratch copy (review 1's `review1/scripts/mutate.mjs` works).
- For each AC1–AC15, run its named check on HEAD and report `ac_status`. AC9: `not_run: "live: Justin re-pastes Home"`.

## Rules
- Change nothing in the worktree. Other bugs outside this feature: `found_else`. Lessons: `skill_lessons[{skill, lesson, evidence}]` (never edit skills or memory; an empty list is normal).

## Return
`{verdict: approve|approve-with-fixes|changes-required, findings[{id, severity, introduced, claim, evidence, suggested_fix}], review1_closed[{id, closed, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], found_else[], defect_loop_skills[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
