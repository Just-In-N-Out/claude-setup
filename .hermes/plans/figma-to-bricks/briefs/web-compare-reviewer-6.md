# Reviewer brief: web-compare, review round 6 (delta: amendment 1, the new matching)

**Role:** a fresh reviewer (Opus 5.5, xhigh), **report only**: change no source, commit nothing, write only into
`~/.hermes/plans/figma-to-bricks/evidence/web-compare/review-6/`. You never saw the build or the earlier reviews' work.

**Skills:** load `requesting-code-review` and `code-review-practice` with the Skill tool; read the project skill with
Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its `references/live-site-reading.md`,
`references/testing-pitfalls.md`. Read the review mechanics and Justin's severity scale:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("Rounds and scope", "The
reviewer's duties", "Records") and the `review-fix-cadence` skill.

## What to review

- Job: `web-compare` (J0 of the website importer): the compare tool, the oracle every later importer job is judged by.
  Approved plan: `~/.hermes/plans/figma-to-bricks/evidence/web-compare/plan-approved.md` (now with "Amendment 1:
  matching": design, Q9–Q11 (⭐ A taken), rulings R23–R29, AC12–AC18, tasks A0–A10; the pre-amendment copy is
  `plan-approved-v1-before-amendment-1.md`).
- **Why the amendment exists:** rounds 3–5 kept finding new text-pairing misses (review-5's `justin.json`: Justin chose
  "Rethink the matching"). Amendment 1 compares each word's rect with its twin's through the aligned word sequence; page
  boxes only name and group findings. The goal: same look gives no finding by construction, and a real difference is
  found whatever markup draws it.
- **Delta round:** the amendment's commits and what they touch: `git diff c69ef18..6aaf985` (14 commits, branch
  `web-compare-matching`, the plan commit `69a6fa7` first). Your worktree starts at `main`; run `git checkout --detach
  6aaf9859b40ee7d6a5d7f2248e1859fbcced8a7a`. `src/` must be untouched since `3ea33bb`. Anything outside the delta is P3.
- **Earlier rounds:** `evidence/web-compare/review-1/` … `review-5/` (`review.json`, `referee.txt`, `justin.json` in
  review-2, -4 and -5), the fixers' `fixer-1/` … `fixer-4/answers.md`, the amendment planner's spike and probe set
  `amendment-1/planner/`, and the builder's evidence `amendment-1/builder/` (AC receipts, RED logs on `c69ef18`, gates,
  25 mutants, cost, noise floor). When a finding is the same defect as an earlier one, set `"repeats"` and a 5+ word
  `"new_fact"` when you have one, and say plainly whether the new matching should have covered it by construction.
- **Three trees per probe** (review-loop.md): run each probe with the base `3ea33bb`, the previous reviewed head
  `c69ef18` and head `6aaf985`, so a regression shows apart from older behaviour.
- **Judge especially:**
  - **Hold-out probes, not the corpus:** the builder drafted `corpus/wants.ts` by hand from its own dump. Build your own
    same-look/different-build pairs and different-look/same-box pairs that are not in `test/web/corpus/` or the
    planner's probe set (other builders' markup: Elementor/Divi/plain, grids, inline-blocks, `display:contents`,
    letter-spacing, pictures, icons in text, RTL-free multi-column text, sticky/fixed boxes, embeds), both directions
    (a miss and a false alarm), judged against your own word-by-word ground truth (all four edges of each word's Range
    rect, pictures' boxes). Check that the corpus wants follow that truth, not the tool's output.
  - **The builder's own rulings** (not yet confirmed): R30 (a finding names the words its boxes draw on both pages),
    R31 (after a word change in a box, the words' later positions in that box belong to the `words` finding; its named
    limit: a second real move after a word change in the same box is folded in, a possible miss), R32 (the row above
    found through a line), and the embed-section fix (first section counts embeds from the page top, last to the page
    end). Is R31's limit a miss a later importer job would plausibly hit?
  - **The property test** (`test/unit/web-compare-words.test.ts`): do its generated structures stay ones browsers draw,
    and do its properties really pin "same look ⇒ no finding" and "a real move ⇒ a finding"? Mutate to check.
  - **Test removals:** the only changed or removed existing tests must be the ones Task A7 lists (12 align pairing
    tests and 5 test/web names); any other changed result is a finding.
  - **Cost and the live floor:** AC17 (≤1.25× `c69ef18` on a live self-compare) and AC16 (a self-compare of the
    plugin-made home: 0 layout findings; 2 timing findings on the hero's load fade-ins marked noise on the second run).
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of the plugin-made Bricks site `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`)
  and `https://www.letsgro.ai/`, GET only. The Hostinger site can stop answering for about a minute after several
  back-to-back 16-width compares: keep such runs, check with one curl, re-run into a new folder. Justin re-pastes the
  plugin-made site between passes: compare a live difference with `c69ef18`'s reading taken the same day first.
- **This machine (WSL):** `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`;
  Chrome wrapper `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh` as `CHROME_PATH`;
  a browser/web run counts only with `skipped 0`. In this worktree-isolated session write multi-step scripts with the
  Write tool and run `bash <file>`; run git commands as separate plain calls.

## Output

1. `review-6/review.json` as `review-loop.md` "Records" says: `"round": 6`, `"scope": "delta"`, `"from":
   "c69ef1896fd4140c313e50b3cfdde82fda83d528"`, `"head": "6aaf9859b40ee7d6a5d7f2248e1859fbcced8a7a"`, findings `R6-<k>`
   (P0–P3, `file_line`, `claim`, a 5+ word real-use `scenario` for every P0–P2, `repeats`/`new_fact` where they apply).
   Empty findings when clean.
2. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree>
   --base 3ea33bba9cf413d929923992431e0145bac07477 ~/.hermes/plans/figma-to-bricks/evidence/web-compare`; exit 2 means
   your file is wrong, so fix it. Exit 0/1/3 is the referee's verdict, not yours to act on.
3. Your report: `verdict`, the findings (one line each), `ac_status` (AC1–AC18: holds / doesn't / unproven, one line
   each; AC15 and AC16 are base-exempt), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only;
   `enforce` `none` or a one-line check proposal; empty is normal; never edit skills or memory), ending with:
   `MAIN SESSION: check and save these skill_lessons now.`
