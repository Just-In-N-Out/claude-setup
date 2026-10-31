# Reviewer brief: web-compare, review round 8 (delta: fix pass 6)

**Role:** a fresh reviewer (Opus 5.5, xhigh), **report only**: change no source, commit nothing, write only into
`~/.hermes/plans/figma-to-bricks/evidence/web-compare/review-8/`. You never saw the build or the earlier reviews' work.
Justin (2026-10-31) said to build the whole importer "straight through" with the recommended answers; make every
finding concrete and reproducible.

**Skills:** load `requesting-code-review` and `code-review-practice` with the Skill tool; read the project skill with
Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its `references/live-site-reading.md`,
`references/testing-pitfalls.md`. Read the review mechanics and Justin's severity scale:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("Rounds and scope", "The
reviewer's duties", "Records") and the `review-fix-cadence` skill.

## What to review

- Job: `web-compare` (J0 of the website importer): the compare tool, the oracle every later importer job is judged by.
  Approved plan: `~/.hermes/plans/figma-to-bricks/evidence/web-compare/plan-approved.md` (with "Amendment 1:
  matching": each word's rect against its twin's through the aligned word sequence; page boxes only name and group
  findings; AC12–AC18).
- **Delta round:** fix pass 6's commits and what they touch: `git diff b40a81d..6fe13b4` (9 commits, branch
  `web-compare-fix-6`; code final at `d60695a`, records after). Your worktree starts at `main`; run `git checkout
  --detach 6fe13b4` and confirm the full SHA with `git rev-parse HEAD`. `src/` must be untouched since `3ea33bb`.
  Anything outside the delta is P3.
- **Earlier rounds:** `evidence/web-compare/review-1/` … `review-7/` (`review.json`; `justin.json` where present), the
  fixers' `fixer-1/` … `fixer-6/answers.md`, `amendment-1/builder/`. Fix pass 6 (`fixer-6/answers.md`, logs, mutants,
  `red/`, `noise-floor/`, `cost/`): **R38** (`test/web/lib/word-rows.ts` `chainOf`, used by `tokenReasons` and
  `word-tops.ts` `bandShifts`): a line pushes the words under it only by the part of its own move that is explained or
  already reported, so moves within tolerance add up down lines and unpainted bands and the first word whose sum
  passes the tolerance is reported, the count restarting there; a band moves as a whole only when one of its words
  moved on its own; each word's explained place, a row's lowest explained bottom. **R39** (ruling, not yet confirmed):
  a one-sided icon's own margin is not part of its room (R35 unchanged). R7-4: the property generator builds the
  reader's single band for `[first unit, wrapper of the rest]`, with a new 6,000-seed property. New corpus family
  `test/web/corpus/review7.ts` (11 probes). Follow-ups left: R7-2 (two neighbouring blocks each moved alone), painted
  sections still reset the chain at their paint edge (probe P6: eight painted sections each 4px taller, 0 findings on
  every tree; changing it touches decision Q10 A), the other reading of R39. `word-rows.ts` is 307 lines. AC16: the
  first floor run read the hero fade-ins alike, so the fixer took a later self-compare's report as the noise file;
  judge whether that meets AC16's text.
  When a finding is the same defect as an earlier one, set `"repeats"` and a 5+ word `"new_fact"`, and say whether it
  is a new variation the rules should cover or one of the named limits.
- **Three trees per probe** (review-loop.md): the first reviewed head `6f47616` (base `3ea33bb` has no compare tool),
  the previous round's head `b40a81d` and head `6fe13b4`.
- **Judge especially**, with hold-out probes of your own that are in neither `test/web/corpus/` nor review 6's or 7's
  probe sets, judged against your own four-edge word truth (pictures' boxes included), both directions (a miss and a
  false alarm): R38 on drift that alternates sign (up then down, so the sum stays small while each step is real), drift
  split between a row move and a band move, a chain that crosses a two-column row (one column drifting, the other
  not), a reported move followed by more drift under it, re-wrapped lines in a chain, and same-look pages built two
  ways (Elementor's widget spacing vs a Bricks gap of the same size; margins vs padding) that must stay silent; whether
  the restart after each report double-counts or hides a second chain; the painted-section limit on a real site shape
  (would a later importer job plausibly hit it?). Check the generator really builds the reader's bands and the corpus
  wants follow the truth, not the tool. Cost (AC17 ≤ 1.25× `c69ef18`) and the live floor (AC16).
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of the plugin-made Bricks site `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`)
  and `https://www.letsgro.ai/`, GET only. The Hostinger site can stop answering for about a minute after several
  back-to-back 16-width compares: keep such runs, check with one curl, re-run into a new folder.
- **This machine (WSL):** `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`;
  Chrome wrapper `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh` as `CHROME_PATH`;
  keep `TMPDIR` short (`~/.cache/wc-r8/tmp`: Chrome won't start with it inside the session scratchpad); a browser/web
  run counts only with `skipped 0`. In this worktree-isolated session write multi-step scripts with the Write tool and
  run `bash <file>`; run git commands as separate plain calls. Another job (`web-capture`) is being fixed in its own
  worktree: leave it alone.

## Output

1. `review-8/review.json` as `review-loop.md` "Records" says: `"round": 8`, `"scope": "delta"`, `"from":
   "b40a81db208e06ac580cc3605d8b6754a07fcc23"`, `"head": "<6fe13b4's full SHA>"`, findings `R8-<k>` (P0–P3,
   `file_line`, `claim`, a 5+ word real-use `scenario` for every P0–P2, `repeats`/`new_fact` where they apply). Empty
   findings when clean.
2. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree>
   --base 3ea33bba9cf413d929923992431e0145bac07477 ~/.hermes/plans/figma-to-bricks/evidence/web-compare`; exit 2 means
   your file is wrong, so fix it. Exit 0/1/3 is the referee's verdict, not yours to act on.
3. Your report: `verdict`, the findings (one line each), `ac_status` (AC1–AC18: holds / doesn't / unproven, one line
   each; AC15 and AC16 are base-exempt), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only;
   `enforce` `none` or a one-line check proposal; empty is normal; never edit skills or memory), ending with:
   `MAIN SESSION: check and save these skill_lessons now.`
