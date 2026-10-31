# Reviewer brief: web-compare, review round 7 (delta: fix pass 5)

**Role:** a fresh reviewer (Opus 5.5, xhigh), **report only**: change no source, commit nothing, write only into
`~/.hermes/plans/figma-to-bricks/evidence/web-compare/review-7/`. You never saw the build or the earlier reviews' work.
This is the last review before Justin's pause ("wrap things up after this review"): its record is what the job resumes
from, so make every finding concrete and reproducible.

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
- **Delta round:** fix pass 5's commits and what they touch: `git diff 6aaf985..b40a81d` (10 commits, branch
  `web-compare-fix-5`; code final at `4a6eec1`, records after). Your worktree starts at `main`; run `git checkout
  --detach b40a81db208e06ac580cc3605d8b6754a07fcc23`. `src/` must be untouched since `3ea33bb`. Anything outside the
  delta is P3.
- **Earlier rounds:** `evidence/web-compare/review-1/` … `review-6/` (`review.json`; `justin.json` in review-2, -4, -5
  and -6, the last the away-grant route "fix the four P2s inside amendment 1's design as general rules"), the
  fixers' `fixer-1/` … `fixer-5/answers.md`, `amendment-1/builder/`. Fix pass 5's rulings (not yet confirmed): R33
  (whitespace ends a word only where drawn), R34 (`test/web/lib/word-tops.ts`: an unpainted band is measured from
  where the content above puts it), R35 (narrows R31: a word after a one-sided change may be pushed by none to all of
  the change's room on that line), R36 (arrangement read in flow order; "to the right but wholly above or below" taken
  from the other page), R37 (a painted band's top is its paint's), a new property generator building the reader's
  bands, and corpus family `review6.ts` (22 probes). Its named remaining limits are in HANDOFF (growth within the band
  tolerance pushes silently and adds up; the page's last block moved alone reads as the space above it; a move no
  bigger than a one-sided token's room reads as its push; a second move after a re-wrap folds into the words finding;
  white on white). When a finding is the same defect as an earlier one, set `"repeats"` and a 5+ word `"new_fact"`,
  and say whether it is a new variation the rules should cover or one of the named limits.
- **Three trees per probe** (review-loop.md): the first reviewed head `6f47616` (base `3ea33bb` has no compare tool),
  the amendment head `6aaf985` and head `b40a81d`.
- **Judge especially**, with hold-out probes of your own that are in neither `test/web/corpus/` nor review 6's probe
  set, judged against your own four-edge word truth (pictures' boxes included), both directions (a miss and a false
  alarm): R34 on stacked unpainted bands (several bands each growing just under the tolerance; a band whose first
  words move while the rest stays; a band moved with the next one not following); R35 on lines with icons, badges,
  inline pictures and glued pieces of different widths on each page; R36 on grids, wrapped flex rows and columns of
  unequal heights; whether the named limits are ones a later importer job would plausibly hit on a real site (an
  Elementor, Divi or plain page against its Bricks copy). Check the property generator really builds the reader's
  bands and that the corpus wants follow the truth, not the tool. Cost (AC17 ≤ 1.25× `c69ef18`) and the live floor
  (AC16).
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of the plugin-made Bricks site `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`)
  and `https://www.letsgro.ai/`, GET only. The Hostinger site can stop answering for about a minute after several
  back-to-back 16-width compares: keep such runs, check with one curl, re-run into a new folder.
- **This machine (WSL):** `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`;
  Chrome wrapper `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh` as `CHROME_PATH`;
  keep `TMPDIR` short (`~/.cache/wc-r7/tmp`: Chrome won't start with it inside the session scratchpad); a browser/web
  run counts only with `skipped 0`. In this worktree-isolated session write multi-step scripts with the Write tool and
  run `bash <file>`; run git commands as separate plain calls.

## Output

1. `review-7/review.json` as `review-loop.md` "Records" says: `"round": 7`, `"scope": "delta"`, `"from":
   "6aaf9859b40ee7d6a5d7f2248e1859fbcced8a7a"`, `"head": "b40a81db208e06ac580cc3605d8b6754a07fcc23"`, findings `R7-<k>`
   (P0–P3, `file_line`, `claim`, a 5+ word real-use `scenario` for every P0–P2, `repeats`/`new_fact` where they apply).
   Empty findings when clean.
2. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree>
   --base 3ea33bba9cf413d929923992431e0145bac07477 ~/.hermes/plans/figma-to-bricks/evidence/web-compare`; exit 2 means
   your file is wrong, so fix it. Exit 0/1/3 is the referee's verdict, not yours to act on.
3. Your report: `verdict`, the findings (one line each), `ac_status` (AC1–AC18: holds / doesn't / unproven, one line
   each; AC15 and AC16 are base-exempt), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only;
   `enforce` `none` or a one-line check proposal; empty is normal; never edit skills or memory), ending with:
   `MAIN SESSION: check and save these skill_lessons now.`
