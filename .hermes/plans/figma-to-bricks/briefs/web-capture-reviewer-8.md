# Reviewer brief: web-capture, review round 8 (delta)

**Role:** a fresh reviewer (Opus 5.5, xhigh), **report only**: change no source, commit nothing, write only into
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/review-8/`. You never saw the build or the earlier reviews' work.

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
- **Delta round:** only fix pass 7's commits and what they touch: `git diff 2e47c23..a2ef3ba` (5 commits, branch
  `web-capture-fix-7`). Your worktree starts at `main`; run `git checkout --detach
  a2ef3ba1afa3a47e1ddd5299be1988209b41fc33`. Anything else you notice outside the fix commits is P3.
- **Earlier rounds:** `evidence/web-capture/review-1/` … `review-7/` (`review.json`, `referee.txt`; `justin.json` in
  review-5 "Fix it now", review-6 "Wait for all fades", review-7 the away-grant route "fix R7-1 as one general rule:
  read the page as loaded with no pointer"), the fixers' answers `fixer-1/` … `fixer-7/answers.md`.
  Fix pass 7: the capture's pointer never comes onto the page (fix pass 6's `parkPointer`/`holdLeave` removed; the
  first-input wake sends only a `mouseWheel` with no `mouseMoved`, which Chrome delivers as a trusted wheel while the
  pointer's place stays unknown); the entrance wait skips a finite animation longer than its time left, treats a box
  whose own inline opacity/visibility turns back twice as a loop, and keeps a floor of one still spell
  (`src/web/readers/entrances.ts`, `src/web/freeze.ts`). Rulings F32 (replaces F30; **changes the approved plan's "a
  first mouse move and wheel" to a wheel only**: a widget that waits only for a mouse move stays as it loads), F33, F34
  in the ledger; follow-ups in HANDOFF. When a finding is the same defect as an earlier one, set `"repeats"` and a 5+
  word `"new_fact"` when you have one, and say whether it is a new variation the rule should have covered or a limit
  the fixer already named.
- **Three trees per probe** (review-loop.md): run each probe with the build's first reviewed head `c0f0529` (the base
  `3ea33bb` has no `src/web`), the previous round's head `2e47c23` and head `a2ef3ba`.
- **Judge especially:**
  - F32 against the plan and AC4: which real first-input loaders wake on a wheel and which wait for a mouse move
    (lazy chat widgets, review/Trustindex loaders, analytics-gated embeds, `mousemove`-only lazy loaders); whether a
    wheel with no pointer place behaves the same on a body-scroller page; whether any reader still dispatches mouse
    input (grep every `Input.dispatchMouseEvent`/`Page.touch`) and what the hover readers rely on;
  - the loop and skip rules on ordinary pages: an entrance that genuinely fades in and out once, a slider's crossfade,
    a long hero entrance (2–4 s) that a wrong "longer than time left" cut would freeze mid-way, a carousel that pauses;
    the regression corpus of rounds 2–7 (`review-2/probe/sites/reveal`, `review-3/probe/`, `review-4/probe/`,
    `review-5/` `bricksfade`, `review-6/probe/`, `review-7/probe/` and the fixers' `reveal/*` fixtures) stays right;
  - the architecture rules (`src/web` never imported by core/plugin/shared/ui; Figma replays byte-identical).
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of the plugin-made Bricks site `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`)
  and `https://www.letsgro.ai/`, GET only. Justin re-pastes the plugin-made site between passes: compare a live
  difference with `2e47c23`'s capture taken the same day before blaming the fix. Probe Bricks Interactions with the
  site's own `bricks.min.js` and `bricksData` served locally (GET the theme file).
- **This machine (WSL):** `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`;
  Chrome wrapper `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh` as `CHROME_PATH`;
  keep `TMPDIR` short (`~/.cache/wcap-r8/tmp`: Chrome won't start with it inside the session scratchpad); a
  browser/web run counts only with `skipped 0`. In this worktree-isolated session write multi-step scripts with the
  Write tool and run `bash <file>`; run git commands as separate plain calls.

## Output

1. `review-8/review.json` as `review-loop.md` "Records" says: `"round": 8`, `"scope": "delta"`, `"from":
   "2e47c23fc97ff0f73c5b12b5d4eeec5e643c54ba"`, `"head": "a2ef3ba1afa3a47e1ddd5299be1988209b41fc33"`, findings `R8-<k>`
   (P0–P3, `file_line`, `claim`, a 5+ word real-use `scenario` for every P0–P2, `repeats`/`new_fact` where they apply).
   Empty findings when clean.
2. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree>
   --base 3ea33bba9cf413d929923992431e0145bac07477 ~/.hermes/plans/figma-to-bricks/evidence/web-capture`; exit 2 means
   your file is wrong, so fix it. Exit 0/1/3 is the referee's verdict, not yours to act on.
3. Your report: `verdict`, the findings (one line each), `ac_status` (AC1–AC14 (AC14's bdryswi.com part is owed to
   Justin): holds / doesn't / unproven, one line each), then `skill_lessons[{skill, lesson, evidence, enforce}]`
   (reusable only; `enforce` `none` or a one-line check proposal; empty is normal; never edit skills or memory), ending
   with: `MAIN SESSION: check and save these skill_lessons now.`
