# Fixer brief: web-compare, fix pass 7 (after review round 8)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin (2026-10-31) said to build the whole importer "straight through" with
the recommended answers: never stop to ask; decide, and record rulings (not yet confirmed) in the ledger and your
report.

**Skills:** load `receiving-code-review`, `test-driven-development`, `engineering-best-practices` and
`mutation-testing-discipline` with the Skill tool; read the project skill with Read:
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its `references/live-site-reading.md`,
`references/testing-pitfalls.md` (its page-compare oracle entry holds the chain rule) and
`references/rendering-validation.md`.

## Start

Your agent worktree starts at `main`, not on the story. Put your copy on the reviewed head without rebasing:
`git checkout --detach 6fe13b451526bc36938f81bec65733185fb1ede0` then `git switch -c web-compare-fix-7`. Your commits
go on top of `6fe13b4`; the story's base stays `3ea33bb`. Approved plan:
`~/.hermes/plans/figma-to-bricks/evidence/web-compare/plan-approved.md` ("Amendment 1: matching", Q10 A: a painted band
is measured from its paint); rulings R30–R39 (builder, `fixer-5/answers.md`, `fixer-6/answers.md`); ledger
`.superpowers/sdd/2026-10-29-web-compare/progress.md`.

## What to fix: the last pass for the drift family

Round 8 (`~/.hermes/plans/figma-to-bricks/evidence/web-compare/review-8/review.json`; probes `review-8/probes/`,
scripts `review-8/scripts/`, logs `review-8/logs/`: `probes-1.log`, `probes-2.log`, `pure-1.log`, `live-tally-a.txt`,
`noise-offline.log`). The referee said `ASK JUSTIN` (R8-1 repeats R7-1); the route taken under Justin's word is in
`review-8/justin.json`: **one last fix pass for the drift family, as a single general rule with no boundary left.**

- **R8-1 (P2) `test/web/lib/word-tops.ts:57`:** fix pass 6's R38 carries small drifts down rows and unpainted bands,
  but a band both pages paint restarts the chain at its paint edge: its height is judged alone against the band
  tolerance and nothing it leaves unreported carries on. Probe P4 (eight sections with alternating painted
  backgrounds and a painted footer, padding 60 vs 62px: each section 4px taller, the footer's words 34px lower) gives 0
  findings at 1440, 1100 and 390 on every tree; P3 (60 vs 65, footer 85px lower) 0 at 1100/880/600; P2 and P1 likewise.
  Builder pages paint most sections and the footer, so this is the common shape.
  **The rule:** list every place the chain can restart today (between rows, between unpainted bands, at a band painted
  on one page or both, at the header/footer parts' edges, at the page's end, after a report) and make each carry its
  unreported remainder, both the place remainder and the section-height difference, into what follows, restarting
  only after a report. Keep painted words measured from their paint (Q10 A unchanged): carry each painted band's
  unreported height difference into the next band's section-height check and report the band where the sum passes the
  band allowance. Write the list of boundaries in HANDOFF beside the rule, so a reader can see none is left.
- **R8-2 (P3) `word-tops.ts:74`:** a section-height number includes the move of a box inside it that is reported too
  (M1 at 1100: "section 2 15px taller" and "heading 2 moved 9px down" where the section is 6px taller first words to
  first words). Make a section-height number exclude what is already reported inside it, so a reader acting on both
  numbers corrects nothing twice.
- **R8-3 (P3) `test/web/lib/compare.ts:66`, AC16:** the hero fade-ins' load race varies in either of two fields,
  trigger (load → scroll) or duration (1000 → 1500), and a timing finding's noise key includes the field, so a floor
  that read one never mutes the other (`noise-offline.log`: `head-b-1` with `head-a-1` as noise exits 1). Key the noise
  so a raced element's timing is muted whichever field its load reading varied in, without muting a real timing
  difference on an element that didn't race; say so in HANDOFF.

**Verify each first** on `6fe13b4` with the reviewer's probes, then fix test-first (RED on `6fe13b4`), both directions:
same-look pages stay silent (review 8's S1–S4 and the painted twin of each: Elementor widget margins vs a Bricks gap,
margin vs padding, collapsed margins vs a flex gap, line-height vs padding, all on painted sections), and each drift
chain gives one finding on the first word or band past the tolerance, with the right sign, at every default width,
the in-between widths (loosest tolerances) included. Judge every finding against the four-edge word truth, never the
tool's own output. Add P1–P4 and their painted same-look controls to the corpus with wants derived from the truth.
Keep AC1–AC18 holding, review 6–8's probes and the review-5 misses caught. Kill the mutants of each boundary's carry
(dropping any one boundary's carry must fail a test).

**If a boundary can't take the carry without a false alarm on a same-look page,** don't add a special case: leave
that boundary as a named limit in HANDOFF with its probe, and say so in your answers. This is the drift family's last
fix pass; the next review judges whether what is left is a named limit.

## Rules

- Commit each fix (or close group) to your branch (plain `git commit -m`, no author override, no AI lines; no CLAUDE.md
  staged); batch ledger/record updates into the fix commits. Don't push, don't bump `BUILD`, don't edit CLAUDE.md,
  never bare `git stash`, don't rebase. `src/` stays untouched. `word-rows.ts` is already 307 lines: split by
  responsibility if your change grows it. In this worktree-isolated session write multi-step scripts with the Write
  tool and run `bash <file>`; run git add, diff and commit as separate plain calls.
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
  `https://www.letsgro.ai/`, GET only. Never write to any WordPress site. The Hostinger site can stop answering for
  about a minute after several back-to-back 16-width compares: keep such runs, check with one curl, re-run into a new
  folder.
- Re-run the gates after the fixes and compare by test name with `6fe13b4`, `b40a81d` and base `3ea33bb`: typecheck
  (both configs), `npm run check`, `npm run test:web` (`skipped 0`), the browser suite, AC16's live self-compare of
  the plugin-made home (its floor and a second self-compare with it as the noise file) and AC17's cost pair. **This
  machine (WSL):** `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`;
  keep `TMPDIR` short (`~/.cache/wc-fix7/tmp`); long gates as a script with `exec > <log> 2>&1` and
  `trap 'echo EXIT=$?' EXIT`, waiting for `EXIT=`. Never edit a script or source a running background test is loading;
  `node --test` options go before file paths.
- General logic only.
- Another job (`web-capture`) is being fixed in its own worktree at the same time: leave it alone.

## Output

- `~/.hermes/plans/figma-to-bricks/evidence/web-compare/fixer-7/answers.md`: the boundary list; for R8-1 to R8-3,
  **fixed** (test name, RED log, commit), **named limit** (the boundary, its probe, why a carry there would raise a
  false alarm) or **rejected** (the evidence). Logs, probes, mutants and receipts beside it; copy scratch scripts into
  `fixer-7/scripts/` as soon as you write them.
- Report (`ready-for-next-review`): branch, head SHA, the commits, the answers one line each, the gate tallies, then
  `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal;
  empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
