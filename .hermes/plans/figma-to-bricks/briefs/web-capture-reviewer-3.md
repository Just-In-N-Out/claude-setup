# Reviewer brief: web-capture, review round 3 (delta)

**Role:** a fresh reviewer (Opus 5.5, xhigh), **report only**: change no source, commit nothing, write only into
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/review-3/`. You never saw the build or the earlier reviews' work.

**Skills:** load `requesting-code-review` and `code-review-practice` with the Skill tool; read the project skill with
Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its `references/live-site-reading.md`,
`references/testing-pitfalls.md`, `references/core-constraints.md`. Read the review mechanics and Justin's severity scale:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("Rounds and scope", "The
reviewer's duties", "Records") and the `review-fix-cadence` skill.

## What to review

- Job: `web-capture` (J1 of the website importer): `npm run capture` writes the capture file every later importer job
  builds on.
  Approved plan: `~/.hermes/plans/figma-to-bricks/evidence/web-capture/plan-approved.md`; format spec
  `docs/specs/web-capture.md`.
- **Delta round:** only fix pass 2's commits and what they touch: `git diff 519dab4..453d2dc` (5 commits, branch
  `web-capture-fix-2`). Your worktree starts at `main`; run `git checkout --detach
  453d2dc0521dff8b53323f7368b99613e10be86e`. Anything else you notice outside the fix commits is P3.
- **Earlier rounds:** `evidence/web-capture/review-1/` and `review-2/` (`review.json`, `referee.txt`, round 2's
  `justin.json`: continue), the fixers' answers `fixer-1/answers.md` and `fixer-2/answers.md` (fix pass 2: all five
  R2 findings fixed; rulings F12–F17; mutants and probes in `fixer-2/`). Judge each R2 fix; when a finding is the same
  defect as an earlier one, set `"repeats"` and a 5+ word `"new_fact"` when you have one.
- **Three trees per probe** (review-loop.md): run each probe with the base `3ea33bb`, the previous round's head
  `519dab4` and head `453d2dc`, so a regression this fix caused shows apart from older behaviour.
- Probe the fixes the way rounds 1–2 found holes: same-look/different-build pairs and count-only cases, both
  directions (a miss and a false alarm). Watch what the new look switch points, per-range look records, the reveal check
  (pointer moved away, window-only scroll) and the no-`<main>` page parts could break on ordinary pages, and the
  architecture rules (`src/web` never imported by core/plugin/shared/ui; Figma replays byte-identical).
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it.** Live reads only of the plugin-made Bricks
  site `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and `https://www.letsgro.ai/`, GET
  only.
- **This machine (WSL):** `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`;
  Chrome wrapper `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh` as `CHROME_PATH`;
  a browser/web run counts only with `skipped 0`.

## Output

1. `review-3/review.json` as `review-loop.md` "Records" says: `"round": 3`, `"scope": "delta"`, `"from":
   "519dab4f5ca94d14ddbf68b05aac4c3df517257f"`, `"head": "453d2dc0521dff8b53323f7368b99613e10be86e"`, findings `R3-<k>` (P0–P3, `file_line`,
   `claim`, a 5+ word real-use `scenario` for every P0–P2, `repeats`/`new_fact` where they apply). Empty findings when
   clean.
2. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree>
   --base 3ea33bba9cf413d929923992431e0145bac07477 ~/.hermes/plans/figma-to-bricks/evidence/web-capture`; exit 2 means
   your file is wrong, so fix it. Exit 0/1/3 is the referee's verdict, not yours to act on.
3. Your report: `verdict`, the findings (one line each), `ac_status` (AC1–AC14 (AC14's bdryswi.com part is owed to Justin): holds / doesn't / unproven, one line
   each), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check
   proposal; empty is normal; never edit skills or memory), ending with:
   `MAIN SESSION: check and save these skill_lessons now.`
