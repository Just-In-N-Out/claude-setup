# Role: planner (plan amendment 3, AC9's input only): site-slider

You are a fresh planner (**Opus 5.5, high**). Amend one thing in the approved plan: which capture file AC9's named-only
B-Dry test reads. Change no source or test, commit nothing, start no agents. Never edit the main folder or any worktree;
never load any live site. Work under `~/.cache/ssl-pa3/`.

**Skills:** `implementation-planning`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
(the plan-amendment paragraph: changed lines marked, the Amendments list extended, receipts encoding an old expectation
named, `ac-check.sh`'s `ac_start`, `bad_id` and `live` regexes run on old and new with ids, live set and cited test
names unchanged, no Amendments-list line starting with an AC id, each cited test name whole on one line).

## Why
AC9 is named-only on Justin's saved capture `/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`
(`F2B_BDRY_CAPTURE`). Since Build 2026-11-09.4 (staging-fit-capture, merged on `main` `3cfc54ac`), `npm run site`,
`site:check`, `capture:check` and the panel's reader refuse that capture: it read widths 768–991 px from a page load
without the site's stylesheets. On the job's rebased head the stack finisher found
(`evidence/site-slider/stack-1/`, the "named-only AC9" lines of its logs): AC9's first two tests pass ("B-Dry's hero is
one Slider … 7.5 s"; "outside 768–991 … where main's paste draws them"), and its third ("B-Dry's site:check gives no
new failing row but inside the hero slider") fails with `ENOENT … report.json`, because it runs
`tools/site-check.ts <capture> --all --elementor`, which now exits 2 with the refusal. The refusal is right and stays.

## Inputs
- Approved copy, amended 1–10 (read-only, your base text): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/plan-approved.md`.
- Head of the job on the stack: `7d9754ed8adb5308bd525b309e7ba4672e284104` (branch `site-slider-stack1-fix3`; read with
  `git -C /home/justin/Documents/FigmaToBricksV2 show 7d9754ed:<path>`): `test/web/site-slider-bdry.test.ts` (what each
  of its three tests reads and asserts, and its variables), `docs/HANDOFF.md` (site-slider section).
- Clean B-Dry captures on this machine (no styleless range; made from the saved 2026-10-29 home page served locally,
  never the live site): find them and check each with the head's own check (`npm run capture:check -- <file>` on a
  `git archive` of `7d9754ed`, or `unstyledRanges` from `src/core/site/styled-ranges.ts`):
  `~/.hermes/plans/figma-to-bricks/evidence/elementor-phone-fit/planner/bdry-standin.f2b-capture.json`,
  `~/.cache/sm-b/bdry-standin-v3.f2b-capture.json`, and any newer stand-in under
  `~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/fixer-1/` or `evidence/site-menu/fixer-1/bdry-dryrun/`.
  Say which hold the code version the head reads and which you recommend (path, capturedAt, code version, ranges).

## What to amend (continue the numbering: amendment 11)
- AC9 reads **a clean B-Dry capture**: Justin's re-capture made with Build 2026-11-09.4 or later once it exists; until
  then the saved stand-in you recommend (say plainly in the plan that it is a stand-in of the saved 2026-10-29 page, not
  the live site, and that the live proof is AC10's). Keep AC9's three clauses and its cited test name; reword only what
  names the file and the "outside 768–991" clause if it no longer makes sense on a capture whose every range is styled
  (say what that test then compares, from the test's own code; if the test's code itself assumes the styleless ranges,
  say so under "needs a fixer" instead of rewording around it).
- Name the old receipts that ran on the refused capture (`fixer-2/logs/` AC9 lines, the review-3 run) as "on the capture
  main now refuses".
- Change nothing else. Don't add, remove or renumber an AC.

## Output
1. Write the amended plan to `/home/justin/.hermes/plans/figma-to-bricks/site-slider-amended-3.md` (the whole plan).
   Don't touch `plan-approved.md`.
2. Show the regex checks' output (current approved copy vs new) and `ac-check`'s whole-line match for each cited name.

## Report (as text)
The amendment, the capture you recommend and why, what AC9's three tests do on it (by reading the test; say if you ran
anything), "needs a fixer" items if any, the regex check, then `skill_lessons[{skill, lesson, evidence, enforce}]`
(reusable only; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
