# Fixer brief: web-compare, fix pass 6 (after review round 7)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin (2026-10-31) said to build the whole importer "straight through" with
the recommended answers: never stop to ask; decide, and record rulings (not yet confirmed) in the ledger and your
report.

**Skills:** load `receiving-code-review`, `test-driven-development`, `engineering-best-practices` and
`mutation-testing-discipline` with the Skill tool (the compare tool is the oracle every later importer job is judged
by); read the project skill with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
`references/live-site-reading.md`, `references/testing-pitfalls.md` and `references/rendering-validation.md`.

## Start

Your agent worktree starts at `main`, not on the story. Put your copy on the reviewed head without rebasing:
`git checkout --detach b40a81db208e06ac580cc3605d8b6754a07fcc23` then `git switch -c web-compare-fix-6`. Your commits go
on top of `b40a81d`; the story's base stays `3ea33bb`. Approved plan:
`~/.hermes/plans/figma-to-bricks/evidence/web-compare/plan-approved.md` ("Amendment 1: matching": design, Q9–Q11,
R23–R29, AC12–AC18); rulings R30–R32 (builder, `amendment-1/builder/`) and R33–R37 (fix pass 5,
`fixer-5/answers.md`); ledger `.superpowers/sdd/2026-10-29-web-compare/progress.md`.

## What to fix

Round 7 (`~/.hermes/plans/figma-to-bricks/evidence/web-compare/review-7/review.json`; the reviewer's hold-out probes in
`review-7/probes/probe-r7.ts`, scripts in `review-7/scripts/`, logs in `review-7/logs/`: `probes-b6-2.log`,
`probes-1.log`, `probes-c69.log`, `pure-1.log`) found fix pass 5's rules holding and one P2 left:

- **R7-1 (P2) `test/web/lib/word-rows.ts:169`, with `test/web/lib/word-tops.ts:61-63`:** small drift chains with no
  limit. A row's move within `placePx` of the row above's carry is explained (R24), and an unpainted band's reference is
  wherever the band above pushed it (R34), so every row and band can add up to the tolerance and the steps add up
  without bound. Probe B6 (eight Elementor-like boxed sections, 20px widget space vs a 24px gap in the copy: each
  section 8px lower, the page's end 64px lower) exits 0 at all 16 widths on `b40a81d` and `6aaf985`, where `6f47616`
  and `c69ef18` reported it. Same class: B1 (twelve one-line paragraph bands, line-height 22.4 vs 26px, 43px drift),
  B5 (six sections, +5px each, 30px), pure probe C2 (twelve bands each 4px further, 48px). **The reviewer's
  suggested rule:** a push explains only the pusher's move; carry each row's and band's unexplained remainder (its dy
  less the carry, or its shift less the push) down the chain and report the first word whose summed remainder passes
  `placePx`; keep property AC14's one-row growth unchanged. Correct HANDOFF's description of the limit to match what
  the code now does.
- **P3s, fold in where the same rule covers them, else follow-ups:** R7-2 (`word-tops.ts:66`: two neighbouring blocks
  each moved alone past the band tolerance are read as the spaces between them; at 390 neither moved block is named);
  R7-4 (the property generator never builds a wrapper band holding several blocks whose first moves alone: make it
  build the reader's one band for `[first unit, wrapper of the rest]`, or say so in HANDOFF).
- **R7-3 is a ruling** (is a one-sided icon's own margin part of its room?): R35 counts room as the token's width and the
  narrower space beside it, so a mid-sentence icon's `margin-left: 10px` on one side reads as the words after it
  moving; B7's want made that reading deliberate. Weigh both readings against the four-edge word truth, take the one
  you recommend, record it as a ruling for Justin (not yet confirmed) with the probes Q1–Q4 as evidence, and leave
  the other as a follow-up line. Don't widen scope beyond that.

**Verify each first** on `b40a81d` with the reviewer's probes, then fix test-first (RED on `b40a81d`), both directions
(same look: no finding; each real drift chain: one finding on the first word past the tolerance, with the right sign),
judging every finding against the four-edge word truth, never the tool's own output. Add B6, B6x.5, B1, B5 and C2 (and
their same-look controls) to the corpus with wants derived from the truth. Keep AC1–AC18 holding, review 6's probes and
the review-5 misses caught (AC12 5/5). Kill the mutants of each new rule (a mutant that removes the carry must fail a
test; so must one that resets the sum at each band).

## Rules

- Commit each fix (or close group) to your branch (plain `git commit -m`, no author override, no AI lines; no CLAUDE.md
  staged); batch ledger/record updates into the fix commits. Don't push, don't bump `BUILD`, don't edit CLAUDE.md,
  never bare `git stash`, don't rebase. `src/` stays untouched. In this worktree-isolated session write multi-step
  scripts with the Write tool and run `bash <file>`; run git add, diff and commit as separate plain calls.
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
  `https://www.letsgro.ai/`, GET only. Never write to any WordPress site. The Hostinger site can stop answering for
  about a minute after several back-to-back 16-width compares: keep such runs, check with one curl, re-run into a new
  folder.
- Re-run the gates after the fixes and compare by test name with `b40a81d`, `6aaf985` and base `3ea33bb`: typecheck
  (both configs), `npm run check`, `npm run test:web` (`skipped 0`), the browser suite, AC16's live self-compare of
  the plugin-made home and AC17's cost pair. **This machine (WSL):** `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`; keep `TMPDIR` short
  (`~/.cache/wc-fix6/tmp`: Chrome won't start with it inside the session scratchpad); long gates as a script with
  `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, waiting for `EXIT=`. Never edit a script or source file that a
  running background test is loading. `node --test` options go before the file paths.
- General logic only.
- Another job (`web-capture`) is being verified in its own worktree at the same time: leave it alone.

## Output

- `~/.hermes/plans/figma-to-bricks/evidence/web-compare/fixer-6/answers.md`: for R7-1 to R7-4, **fixed** (test name, RED
  log, commit), **ruling** (R7-3: the reading taken and why), **follow-up** (why) or **rejected** (the evidence). Logs,
  probes, mutants and receipts beside it; copy scratch scripts into `fixer-6/scripts/` as soon as you write them.
- Report (`ready-for-next-review`): branch, head SHA, the commits, the answers one line each, the gate tallies, then
  `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal;
  empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
