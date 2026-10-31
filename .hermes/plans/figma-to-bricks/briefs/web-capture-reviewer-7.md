# Reviewer brief: web-capture, review round 7 (delta)

**Role:** a fresh reviewer (Opus 5.5, xhigh), **report only**: change no source, commit nothing, write only into
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/review-7/`. You never saw the build or the earlier reviews' work.

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
- **Delta round:** only fix pass 6's commits and what they touch: `git diff f66e0c0..2e47c23` (5 commits, branch
  `web-capture-fix-6`). Your worktree starts at `main`; run `git checkout --detach
  2e47c23fc97ff0f73c5b12b5d4eeec5e643c54ba`. Anything else you notice outside the fix commits is P3.
- **Earlier rounds:** `evidence/web-capture/review-1/` … `review-6/` (`review.json`, `referee.txt`; `justin.json` in
  review-5 "Fix it now" and review-6 "Wait for all fades"), the fixers' answers `fixer-1/` … `fixer-6/answers.md`.
  Fix pass 6 carried out Justin's review-6 direction as one general mechanism: before each page load is read, the page
  plays its own entrances at the top until none has run for 1 s (6 s cap; `src/web/readers/entrances.ts`
  `awaitEntrances`, freeze order in `src/web/freeze.ts`); Bricks is never sent a fade's end any more; boxes chained to
  another's fade below the first screen show from the marks (`src/web/readers/libraries.ts` `revealOwned`); the
  capture's pointer leaves sideways at mid-height with root mouseleave/pointerleave stopped during the move (exit-intent
  pop-ups). Rulings F27–F31 in the ledger; its pushback: chained steps more than 1 s apart, mark-less reveals below the
  first screen, the scroll-through's own triggers (F29) and a pop-up the page opens on its own timer read open (F31).
  The fade-in/reveal family has recurred in rounds 2–6: when a finding is the same defect as an earlier one, set
  `"repeats"` and a 5+ word `"new_fact"` when you have one, and say plainly whether it is a new variation the general
  mechanism should have covered or a known limit the fixer already named.
- **Three trees per probe** (review-loop.md): run each probe with the base's oldest reviewed head `c0f0529` (the base
  `3ea33bb` has no `src/web`), the previous round's head `f66e0c0` and head `2e47c23`, so a regression this fix caused
  shows apart from older behaviour.
- Probe the fixes the way earlier rounds found holes: same-look/different-build pairs and count-only cases, both
  directions (a miss and a false alarm). Watch especially:
  - the wait on ordinary pages: endless spinners, marquees, sliders, videos, cursors and tickers that must not hold it
    to its cap; an entrance that never ends; a page whose script tweens inline opacity forever; the cost on a long
    multi-range capture (the fixer measured +1 s per page load where nothing enters);
  - what the wait now lets play that wasn't read before (a first-screen entrance whose end opens or hides something,
    a timer pop-up, F31), and whether such a box is then recorded as the page shows it to a visitor at the top;
  - the chained-reveal marks (`animationId`, a box's own earlier `startAnimation`, cycles), Elementor/AOS marks too;
  - the pointer move: menus a hover opened still close, root leave listeners stopped only during the move, sites
    whose exit intent watches `mouseout` on document or a bottom/side edge;
  - the architecture rules (`src/web` never imported by core/plugin/shared/ui; Figma replays byte-identical).
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of the plugin-made Bricks site `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`)
  and `https://www.letsgro.ai/`, GET only. Justin re-pastes the plugin-made site between passes: compare a live
  difference with `f66e0c0`'s capture taken the same day before blaming the fix. Probe Bricks Interactions with the
  site's own `bricks.min.js` and `bricksData` served locally (GET the theme file), as round 6 did.
- **This machine (WSL):** `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`;
  Chrome wrapper `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh` as `CHROME_PATH`;
  a browser/web run counts only with `skipped 0`. In this worktree-isolated session write multi-step scripts with the
  Write tool and run `bash <file>`; run git commands as separate plain calls.

## Output

1. `review-7/review.json` as `review-loop.md` "Records" says: `"round": 7`, `"scope": "delta"`, `"from":
   "f66e0c0abae470be24cfff8c1984881d0197f804"`, `"head": "2e47c23fc97ff0f73c5b12b5d4eeec5e643c54ba"`, findings `R7-<k>`
   (P0–P3, `file_line`, `claim`, a 5+ word real-use `scenario` for every P0–P2, `repeats`/`new_fact` where they apply).
   Empty findings when clean.
2. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree>
   --base 3ea33bba9cf413d929923992431e0145bac07477 ~/.hermes/plans/figma-to-bricks/evidence/web-capture`; exit 2 means
   your file is wrong, so fix it. Exit 0/1/3 is the referee's verdict, not yours to act on.
3. Your report: `verdict`, the findings (one line each), `ac_status` (AC1–AC14 (AC14's bdryswi.com part is owed to
   Justin): holds / doesn't / unproven, one line each), then `skill_lessons[{skill, lesson, evidence, enforce}]`
   (reusable only; `enforce` `none` or a one-line check proposal; empty is normal; never edit skills or memory), ending
   with: `MAIN SESSION: check and save these skill_lessons now.`
