# Role: reviewer (Mini, the one review, report only): elementor-footer-fit

You are a fresh reviewer who never saw the build (Opus 5.5, high). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com or any live site; never write to any WordPress site; no logins.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** one review per job; report as
P0–P2 only bugs a real site or normal use hits (a captured Elementor page pasted into Bricks 2.3.9 by `npm run site
--elementor`; the plain route and Figma designs converting as before), each with a concrete real-use scenario. Edge
cases are P3 (follow-ups). A P0–P2 with no concrete real-use scenario is a P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit/plan-approved.md`
  (AC1–AC6; AC6 live). The job: fold rule 9 "Filled boxes" (`filledBoxes` in the new `src/core/site/elementor-measured.ts`,
  rule 8 moved there unchanged; `foldable` ends with `marginBoxes(…) ?? filledBoxes(…)`): a widget whose measured box
  (the first chain element with a capture box) is more than 0.5 px taller than its body plus the inner block margins (px,
  rem, em) at a kept width keeps its elements, named; B-Dry's footer 51.89 px → 1.09 px at 1025. Q1 A / Q2 A taken.
- Branch `elementor-footer-fit-build`, head `4c9f8214b08a9242dc4d7d401116c5469d46f6c1`, base (elementor-phone-fit's head,
  being merged) `dab961f9c30755b1890adc478ee9fdf3d5431516`. In your own worktree: `git checkout --detach 4c9f8214…`,
  confirm HEAD and a clean status. Review `git diff dab961f9...HEAD`.
- The builder's receipts (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit/builder/`.
  Its deviations: base dab961f9 (same source as the plan's 7b7d345f); rules 8 and 9 in a new file (the unchanged-import
  test's file list names it); the tie names the wider width; em reads the font size only for em margins; AC1's base RED
  fails on the note first (a geometry-only variant shows 51.89 px).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the whole diff for real bugs: rule 9 refusing folds it shouldn't on real Elementor sites (a widget box sized by
   its own min-height, padding, a body measured only at some widths, left-out ranges, a picture's box), or folding ones it
   should refuse; rule 8 unchanged by the move; the note; the plain route or Figma designs no longer byte-identical;
   tests that can't fail.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit/review-1/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   dab961f9c30755b1890adc478ee9fdf3d5431516 /home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit`
   (exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/ef-r/tmp`, its
  own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your
  own at a time, closed after. Worktree `node_modules` may lack `.bin`: see testing-pitfalls. Run multi-step commands from
  a script file written with Write.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits
  under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
