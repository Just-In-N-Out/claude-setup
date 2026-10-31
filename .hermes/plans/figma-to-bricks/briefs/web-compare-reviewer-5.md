# Reviewer brief: web-compare, review round 5 (delta)

**Role:** a fresh reviewer (Opus 5.5, xhigh), **report only**: change no source, commit nothing, write only into
`~/.hermes/plans/figma-to-bricks/evidence/web-compare/review-5/`. You never saw the build or the earlier reviews' work.

**Skills:** load `requesting-code-review` and `code-review-practice` with the Skill tool; read the project skill with
Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its `references/live-site-reading.md`,
`references/testing-pitfalls.md`. Read the review mechanics and Justin's severity scale:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("Rounds and scope", "The
reviewer's duties", "Records") and the `review-fix-cadence` skill.

## What to review

- Job: `web-compare` (J0 of the website importer): the compare tool, the oracle every later importer job is judged by.
  Approved plan: `~/.hermes/plans/figma-to-bricks/evidence/web-compare/plan-approved.md`.
- **Delta round:** only fix pass 4's commits and what they touch: `git diff f136bb0..c69ef18` (2 commits, branch
  `web-compare-fix-4`). Your worktree starts at `main`; run `git checkout --detach
  c69ef1896fd4140c313e50b3cfdde82fda83d528`. Anything else you notice outside the fix commits is P3.
- **Earlier rounds:** `evidence/web-compare/review-1/` … `review-4/` (round 4's `justin.json`: Justin chose "Fix it") (`review.json`, `referee.txt`, round 2's
  `justin.json`: continue), the fixers' answers `fixer-1/` … `fixer-4/answers.md` (fix pass 4: R4-1 fixed with "whole blocks" for boxes
  holding block-level boxes and one-level stacks, paired in a third pass; ruling R22 and three named limits in
  HANDOFF; 11 mutants; truth probes F1–F11 in `fixer-4/logs/`). Judge the R4 fix, R22 and whether its limits are
  acceptable; when a finding is the same
  defect as an earlier one, set `"repeats"` and a 5+ word `"new_fact"` when you have one.
- **Three trees per probe** (review-loop.md): run each probe with the base `3ea33bb`, the previous round's head
  `f136bb0` and head `c69ef18`, so a regression this fix caused shows apart from older behaviour.
- Probe the fixes the way rounds 1–2 found holes: same-look/different-build pairs and count-only cases, both
  directions (a miss and a false alarm). Watch for misses and false alarms the whole-block pass could cause on ordinary
  pages (cards, sections, nested stacks, a wrapper with words of its own; judge findings against the word-by-word
  ground truth). The fixer's new live floor has 2 timing findings on the plugin-made hero's load fade-ins, which it
  attributes to the page's own load-to-load variation (`fixer-4/logs/floor-tally.txt`): check that attribution.
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it.** Live reads only of the plugin-made Bricks
  site `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and `https://www.letsgro.ai/`, GET
  only.
- **This machine (WSL):** `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`;
  Chrome wrapper `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh` as `CHROME_PATH`;
  a browser/web run counts only with `skipped 0`.

## Output

1. `review-5/review.json` as `review-loop.md` "Records" says: `"round": 5`, `"scope": "delta"`, `"from":
   "f136bb0a7605d1d74ca59c12d5c8373c97cffa99"`, `"head": "c69ef1896fd4140c313e50b3cfdde82fda83d528"`, findings `R5-<k>` (P0–P3, `file_line`,
   `claim`, a 5+ word real-use `scenario` for every P0–P2, `repeats`/`new_fact` where they apply). Empty findings when
   clean.
2. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree>
   --base 3ea33bba9cf413d929923992431e0145bac07477 ~/.hermes/plans/figma-to-bricks/evidence/web-compare`; exit 2 means
   your file is wrong, so fix it. Exit 0/1/3 is the referee's verdict, not yours to act on.
3. Your report: `verdict`, the findings (one line each), `ac_status` (AC1–AC11: holds / doesn't / unproven, one line
   each), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check
   proposal; empty is normal; never edit skills or memory), ending with:
   `MAIN SESSION: check and save these skill_lessons now.`
