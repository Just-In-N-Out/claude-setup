# Fixer brief: web-capture, fix pass 7 (after review round 7)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin is asleep under an away grant
(`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`, the 2026-10-30 evening entry: "go with the
recommended"): never stop to ask; decide, and record rulings (not yet confirmed) in the ledger and your report.

**Skills:** load `receiving-code-review`, `test-driven-development` and `engineering-best-practices` with the Skill
tool, plus `mutation-testing-discipline` (the pointer park is a guard every later capture relies on); read the project
skill with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
`references/live-site-reading.md`, `references/testing-pitfalls.md`, `references/core-constraints.md`.

## Start

Your agent worktree starts at `main`, not on the story. Put your copy on the reviewed head without rebasing:
`git checkout --detach 2e47c23fc97ff0f73c5b12b5d4eeec5e643c54ba` then `git switch -c web-capture-fix-7` (fix pass 6's
branch is `web-capture-fix-6`). Your commits go on top of `2e47c23`; the story's base stays `3ea33bb`. Approved plan:
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/plan-approved.md`; ledger
`.superpowers/sdd/2026-10-29-web-capture/progress.md` in your copy.

## What to fix

Round 7 (`evidence/web-capture/review-7/review.json`, `referee.txt`; probes in `review-7/probe/`, scripts in
`review-7/scripts/`) found the fade wait, the chained marks and "never send a fade's end" sound, and one regression:

- **R7-1 (P2), `src/web/freeze.ts:187`:** fix pass 6's pointer park (13eb39f) stops every root mouseleave/pointerleave
  during the move, so a page never learns the pointer left: custom cursor rings and pointer-following glows that hide
  on leaving are read shown (probe `cursor`: three rings at opacity 1 as "own" floating boxes at the last mouse spot;
  probe `spotlight`: a hero glow at 0.6, which the replay pastes as `"_opacity":"0.6"`). Build and `f66e0c0` read them
  at 0.

The recommended route (`review-7/justin.json`): **fix it as one general rule, not a trade between two events.** The
capture must read the page as it looks loaded with no pointer on it: no hover, no leave-opened pop-up, no
pointer-following decoration shown. Find the mechanism that gets there for both reactions to the same event (round 7
showed one leave both hides a ring and opens an exit pop-up). Research before choosing; candidates to weigh with
evidence, not a prescription: whether the pointer needs to enter the page at all (where and why the capture moves it;
what Chrome does with a pointer that was never dispatched), letting the leave through and closing or ignoring only what
the move itself opened (a full-window box that appeared during the park), or another route you prove. Keep fix pass
6's controls closed (`review-6`/`fixer-6` probes: html mouseleave, document mouseout with `clientY <= 0`, jQuery
mouseleave with `clientY <= 0`, Bricks' `mouseleaveWindow` with its own `bricks.min.js`) and the hover menu closing.

Same code, fold in where the same rule covers them, else leave as follow-ups and say why:
- **R7-3 (P3):** the exit-intent limit reaches further than F30 says: `review-7/probe/sites/exitany` opens four exit
  pop-ups on head (document mouseout with no clientY test, jQuery `$(document).on('mouseleave')` bound as native
  mouseout, a window mouseout listener, a "left through any edge" check). If your rule covers them, fix them; at least
  correct the spec and HANDOFF wording that says the capture "no longer opens exit-intent pop-ups".
- **R7-2 (P3), `src/web/readers/entrances.ts:28`:** a 20 s Ken Burns zoom, a script's endless opacity pulse and a
  script cursor blink hold the wait to its 6 s cap on every page load and leave a false "still playing" note (a 3 s
  text rotator ends after 1 s, as it should). Make the wait tell a decoration that keeps going from an entrance if you
  can do it generally; at least make the note true.
- **R7-4 (P3), `src/web/freeze.ts:140`:** when the scroll-through has spent the freeze's 45 s budget, the wait is
  skipped and the note says "still playing after 0 s" on a still page: give the wait a floor of its own or a true note.

**Regression corpus:** every reveal, fade and leave probe from rounds 2–7 (`review-2/probe/sites/reveal`,
`review-3/probe/`, `review-4/probe/`, `review-5/` `bricksfade`, `review-6/probe/` `bricksreal`/`bricksstagger`,
`review-7/probe/` `cursor`/`spotlight`/`exitany` and the motion probes) plus the fixers' `reveal/*` fixture pages:
captured with `2e47c23` and with your fix, box by box, every difference explained.

**Verify R7-1 first** on the head with the `cursor` and `spotlight` probes; build the fix test-first (a failing test on
a painted leave-hidden ring and glow, beside the exit pop-up controls), and kill the mutants of the new step.

## Rules

- Commit each fix (or close group) to your branch (plain `git commit -m`, no author override, no AI lines; no CLAUDE.md
  staged); batch ledger/record updates into the fix commits. Don't push, don't bump `BUILD`, don't edit CLAUDE.md,
  never bare `git stash`, don't rebase. In this worktree-isolated session write multi-step scripts with the Write tool
  and run `bash <file>`; run git add, diff and commit as separate plain calls.
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
  `https://www.letsgro.ai/`, GET only. Never write to any WordPress site.
- Re-run the gates after the fixes and compare by test name with base `3ea33bb` and with fix pass 6
  (`evidence/web-capture/fixer-6/gates/`): typecheck (both configs), `npm run check`, `npm run test:web` (`skipped 0`
  apart from AC14's env-gated test, which you run with `F2B_WEB_CAPTURES` on the two reachable sites; a live picture
  `fetch failed` is re-fetched with Node and both heads captured back to back before blaming code), the story's
  browser tests, Figma replays byte-identical (the five real files, plain and `--site`), and re-capture the two
  reachable homes, saying what the change costs per page load. **This machine (WSL):** `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`; long gates as a script with
  `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, waiting for `EXIT=`.
- General logic only; `src/web/` stays out of `src/core|plugin|shared|ui` imports and bundles.

## Output

- `~/.hermes/plans/figma-to-bricks/evidence/web-capture/fixer-7/answers.md`: for R7-1 to R7-4, **fixed** (test name,
  RED log, commit), **follow-up** (why) or **rejected** (the evidence). Logs, probes, mutants and receipts beside it.
- Report (`ready-for-next-review`): branch, head SHA, the commits, the answers one line each, the gate tallies, then
  `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal;
  empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
