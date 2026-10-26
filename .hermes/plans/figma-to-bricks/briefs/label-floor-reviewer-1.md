# Brief: REVIEWER 1 (review only) for figma-to-bricks feature "label-floor" (Full pipeline)

You are the first of two fresh, independent full reviewers. You never saw the build. Report only: change nothing.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/label-floor` (branch `worktree-label-floor`, HEAD 6cfd9e2, clean). Base: `cd9c1c9` (the merge base). Review `git diff cd9c1c9...HEAD` (14 commits: part 1 8c1f083…b49d6f7, part 2 04beb15…6cfd9e2).
- Approved plan (the contract, read-only): `~/.hermes/plans/figma-to-bricks/evidence/label-floor/plan-approved.md` (AC1–AC15; AC9 is live, owed to Justin). The same plan is in the worktree at `docs/plans/2026-10-26-label-floor.md`; ledger at `.superpowers/sdd/2026-10-26-label-floor/progress.md`.
- Write your report and any scratch to `~/.hermes/plans/figma-to-bricks/evidence/label-floor/review1/` only. Never write in the worktree; restore anything you touch (e.g. a mutation: apply in a scratch copy or `git checkout -- <file>` right after, and confirm `git status` is clean before you finish).
- Note: local `main` has moved to f46f8a2 (feature faq-answer-space merged: `src/core/understand/accordion.ts`, its tests, `docs/HANDOFF.md`). Only HANDOFF overlaps by file. Don't review faq-answer-space; do say if you see a semantic interaction (accordion words are excluded from label-floor's minimum).

## Skills (load first, one line each)
Project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, REVIEWER role, and its `references/rules-summary.md`, `references/rendering-validation.md`; only the worktree `CLAUDE.md` sections you need), `engineering-best-practices`, `requesting-code-review` and `code-review-practice` (skip their "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer, and you can't spawn agents), `mutation-testing-discipline`.

## What was asked (in short)
Justin's rule (2026-10-26): words in a pill get at least 13px and "Learn more"-style links at least 15px, on every screen; text already at or above stays as drawn; every other text keeps Figma's size. Approved answers 1A–5A (round-ended pills; linked go-words or linked words with a → after; list pills keep their size; the size goes on the element, the Figma style's class unchanged so no Import-classes dialog; Chrome for Testing locally). Part 2, Justin's decision "Space gives way": in a row drawn exactly as wide as its items, the gaps give up what the labels grew (6A all gaps alike, 7A at most half each, 8A else the row widens into its column's room, else its words keep their drawn size with a panel note, 9A GRO's other links only recorded). It must be general: no keying on a file's names, ids, words, sizes or colours.

## What to do
- Review the whole diff against the plan and the project's architecture rules (pipeline stages; no stage edits an earlier stage's output; only `adapt/rules/` writes breakpoint styles; rules read widths from the layout plan; deterministic ids; files small; sandbox built-ins only in `src/core`). Look for: wrong recognition (false positives: menu links, footer links, square tags, buttons, table cells, form fields; false negatives), hover/phone copies disagreeing, class or paste nondeterminism, a breakpoint writing a smaller size, layout-plan vs CSS disagreement on laptops/tablets/phones, rows that wrap or spill where main didn't, dead or untested guards, fixtures that don't reach the case in Chrome.
- Run the gates yourself; don't trust summaries: `npm run check` and the browser suite with `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. This machine's browser baseline at main is 349/362 with 12 font-environment failures (names in `~/.hermes/plans/figma-to-bricks/evidence/label-floor/builder/baseline-failures-names.txt`): compare by test name. `npm run corpus` measures nothing here (Mac paths in corpus.json): measure the five files directly (corpus/files/hydraulics-home.json, corpus/files/gro-home.json, repo-root figma-to-bricks-debug-page-1.json, figma-to-bricks-debug-design-inspo-brainstorm.json, and Services = `git show 2199895:figma-to-bricks-debug-page-1.json`) with replay/snap; the builder's scripts are in `~/.hermes/plans/figma-to-bricks/evidence/label-floor/corpus/` (diff-by-id.mjs, spill.ts, labels.ts, labels-compare.mjs). Measure at laptop widths too (1440/1366/1300/1280/1200/1100/1024/992) and 375/360/320.
- Try mutations on the key guards in a scratch copy.
- For each AC1–AC15, run its named check on HEAD and say whether it holds (`ac_status`). AC9 is `not_run: "live: Justin re-pastes Home"`.

## Rules
- Change nothing in the worktree: no commit, push or merge.
- Other bugs outside this feature: `found_else`. Reusable lessons: `skill_lessons[{skill, lesson, evidence}]` (never edit skills or memory; an empty list is normal).

## Return
`{verdict: approve|approve-with-fixes|changes-required, findings[{id, severity, introduced, claim, evidence, suggested_fix}], ac_status[{ac, accepted, test, screenshot, evidence}], found_else[], defect_loop_skills[], skill_lessons[]}`. Save the same report to `review1/report.md`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
