# Reviewer brief: web-capture, review round 9 (delta)

**Role:** a fresh reviewer (Opus 5.5, xhigh), **report only**: change no source, commit nothing, write only into
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/review-9/`. You never saw the build or the earlier reviews' work.
This is the last review before Justin's pause ("wrap things up after this review"): its record is what the job resumes
from, so make every finding concrete and reproducible.

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
- **Delta round:** only fix pass 8's commits and what they touch: `git diff a2ef3ba..3705de1` (5 commits, branch
  `web-capture-fix-8`). Your worktree starts at `main`; run `git checkout --detach
  3705de1cf7a9174f189b59e42f7d70045781ffd2`. Anything else you notice outside the fix commits is P3.
- **Earlier rounds:** `evidence/web-capture/review-1/` … `review-8/` (`review.json`, `referee.txt`; `justin.json` in
  review-5 to review-8; review-8's is the away-grant route: stop adding heuristics, remove the turn-counting loop rule,
  accept the endless pulse/blink cost as a known limit with a true note, fix R8-2's wording and add a note when a page
  listens for mouse moves), the fixers' answers `fixer-1/` … `fixer-8/answers.md`.
  Fix pass 8: `src/web/readers/entrances.ts`'s tween counting is `2e47c23`'s again (time-left skip and floor kept); the
  6 s note reworded (ruling F35, the accepted limit); a new `src/web/readers/listeners.ts` note naming mouse/pointer
  moves and mouseovers the page listens for that the capture never sent (ruling F36: touchstart left out because
  Splide binds it on every Bricks slider page). When a finding is the same defect as an earlier one, set `"repeats"`
  and a 5+ word `"new_fact"`, and say whether it is a new variation or the accepted limit F35 already names (a pulse or
  blink holding the wait to 6 s is that limit, not a finding).
- **Three trees per probe** (review-loop.md): the build's first reviewed head `c0f0529` (base `3ea33bb` has no
  `src/web`), the previous round's head `a2ef3ba` and head `3705de1`.
- **Judge especially:** that every finite entrance is read at its end again (review 8's `swap8`, `entr8` and the
  fixture `reveal/entrances/again`, plus your own in-out-in shapes); that F32's pointer rule and the time-left skip
  still hold; the new listeners note on ordinary pages, both directions (a false "may be missing" on pages where
  nothing is missing: sliders, analytics, cursor effects, Elementor/Divi/plain pages; a real mouse-move-only widget
  with no note), its cost, and that it names no secret or page data beyond event types and places; the regression
  corpus of rounds 2–8 (`review-*/probe/` and the fixers' `reveal/*` fixtures); the architecture rules (`src/web`
  never imported by core/plugin/shared/ui; Figma replays byte-identical).
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of the plugin-made Bricks site `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`)
  and `https://www.letsgro.ai/`, GET only. Justin re-pastes the plugin-made site between passes: compare a live
  difference with `a2ef3ba`'s capture taken the same day before blaming the fix.
- **This machine (WSL):** `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`;
  Chrome wrapper `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh` as `CHROME_PATH`;
  keep `TMPDIR` short (`~/.cache/wcap-r9/tmp`); a browser/web run counts only with `skipped 0`. In this
  worktree-isolated session write multi-step scripts with the Write tool and run `bash <file>`; run git commands as
  separate plain calls.

## Output

1. `review-9/review.json` as `review-loop.md` "Records" says: `"round": 9`, `"scope": "delta"`, `"from":
   "a2ef3ba1afa3a47e1ddd5299be1988209b41fc33"`, `"head": "3705de1cf7a9174f189b59e42f7d70045781ffd2"`, findings `R9-<k>`
   (P0–P3, `file_line`, `claim`, a 5+ word real-use `scenario` for every P0–P2, `repeats`/`new_fact` where they apply).
   Empty findings when clean.
2. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree>
   --base 3ea33bba9cf413d929923992431e0145bac07477 ~/.hermes/plans/figma-to-bricks/evidence/web-capture`; exit 2 means
   your file is wrong, so fix it. Exit 0/1/3 is the referee's verdict, not yours to act on.
3. Your report: `verdict`, the findings (one line each), `ac_status` (AC1–AC14 (AC14's bdryswi.com part is owed to
   Justin): holds / doesn't / unproven, one line each), then `skill_lessons[{skill, lesson, evidence, enforce}]`
   (reusable only; `enforce` `none` or a one-line check proposal; empty is normal; never edit skills or memory), ending
   with: `MAIN SESSION: check and save these skill_lessons now.`
