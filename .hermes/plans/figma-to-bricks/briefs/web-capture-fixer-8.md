# Fixer brief: web-capture, fix pass 8 (after review round 8)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin is asleep under an away grant
(`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`, the 2026-10-30 evening entry: "go with the
recommended"): never stop to ask; decide, and record rulings (not yet confirmed) in the ledger and your report.

**Skills:** load `receiving-code-review`, `test-driven-development`, `engineering-best-practices` and
`mutation-testing-discipline` with the Skill tool; read the project skill with Read:
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its `references/live-site-reading.md`,
`references/testing-pitfalls.md`, `references/core-constraints.md`.

## Start

Your agent worktree starts at `main`, not on the story. Put your copy on the reviewed head without rebasing:
`git checkout --detach a2ef3ba1afa3a47e1ddd5299be1988209b41fc33` then `git switch -c web-capture-fix-8` (fix pass 7's
branch is `web-capture-fix-7`). Your commits go on top of `a2ef3ba`; the story's base stays `3ea33bb`. Approved plan:
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/plan-approved.md`; ledger
`.superpowers/sdd/2026-10-29-web-capture/progress.md` in your copy.

## What to do (the recommended route, `review-8/justin.json`)

Round 8 (`evidence/web-capture/review-8/review.json`, `referee-selfcheck.txt`; probes in `review-8/probe/`, scripts in
`review-8/scripts/`) found the pointer rule (F32), the time-left skip and the floor sound, and one regression:

- **R8-1 (P2), `src/web/readers/entrances.ts:66`:** fix pass 7's loop rule (F33: a box whose own inline
  opacity/visibility turns back twice is a loop) stops waiting for a finite in-out-in entrance: the word-swap intro
  `review-8/probe/sites/swap8` is read at opacity 0.575 (pasted as `"_opacity":"0.57"`; `2e47c23` read 1), a fade
  restarted mid-way (`entr8?hero`) at 0.857, a bounce-eased fade at 0.991.

The fade-in family has now recurred through rounds 2–8, each fix's heuristic opening a new variation. Justin was told
that a further variation would be met by accepting a limit rather than another heuristic. So: **stop counting turns.
Remove F33's loop rule** so every finite entrance is waited for to its end as on `2e47c23` (any turn threshold N is
beaten by an entrance with N turns: don't replace it with a higher one). **Keep** F32 (no pointer on the page), F33's
"a finite animation longer than the wait's time left doesn't hold it" (same readings), and F34's floor. **R7-2's cost
becomes an accepted known limit:** a script that pulses or blinks a box's opacity forever holds the wait up to its 6 s
cap; make the note it leaves true (motion still running at the cap, not "entrances still playing"), record the limit
and its measured cost in the spec, HANDOFF and ledger, and keep the pulse/blink fixture cases as tests of the note and
the cap. Prove with tests that `swap8`, the restarted fade and the bounce fade are read at 1 (RED on `a2ef3ba`), that
fix pass 7's reveal/entrances/decor cases still give the readings they gave, and kill the mutants of what you change.

- **R8-2 (P3), `src/web/freeze.ts:177`:** F32's named cost reaches further than its wording: a chat bubble added on
  `mousemove`/`touchstart` is lost at every width (a box that only appears in a phone page load isn't added; probe
  `wakersmq`), and `mouseover`- or `pointermove`-only loaders aren't woken either, with no note. Correct the wording in
  `docs/specs/web-capture.md:153`, `docs/HANDOFF.md:171` and the ledger (the capture never sends a key press; say what a
  touch wakes and what is dropped), and add a note in the capture when the page listens for mouse or pointer moves
  (or `mouseover`/`touchstart` on the window/document/body) and the capture never sent one, so the importer's panel can
  say a widget may be missing. Don't add a mouse move back.

**Regression corpus:** every reveal, fade, leave and wake probe from rounds 2–8 (`review-2/probe/sites/reveal`,
`review-3/probe/`, `review-4/probe/`, `review-5/` `bricksfade`, `review-6/probe/`, `review-7/probe/`,
`review-8/probe/`) plus the fixers' `reveal/*` fixture pages: captured with `a2ef3ba` and with your fix, box by box,
every difference explained (the expected ones: the in-out-in entrances read at 1, pulse/blink pages waiting to the cap
with the true note).

## Rules

- Commit each fix (or close group) to your branch (plain `git commit -m`, no author override, no AI lines; no CLAUDE.md
  staged); batch ledger/record updates into the fix commits. Don't push, don't bump `BUILD`, don't edit CLAUDE.md,
  never bare `git stash`, don't rebase. In this worktree-isolated session write multi-step scripts with the Write tool
  and run `bash <file>`; run git add, diff and commit as separate plain calls; never edit a script a background bash is
  still running.
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
  `https://www.letsgro.ai/`, GET only. Never write to any WordPress site.
- Re-run the gates after the fixes and compare by test name with base `3ea33bb` and with fix pass 7
  (`evidence/web-capture/fixer-7/gates/`): typecheck (both configs), `npm run check`, `npm run test:web` (`skipped 0`
  apart from AC14's env-gated test, which you run with `F2B_WEB_CAPTURES` on the two reachable sites; a live picture
  `fetch failed` is re-fetched with Node and both heads captured back to back before blaming code), the story's
  browser tests, Figma replays byte-identical (the five real files, plain and `--site`), and re-capture the two
  reachable homes, saying the wait per page load. **This machine (WSL):** `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`; keep `TMPDIR` short
  (`~/.cache/wcap-fix8/tmp`); long gates as a script with `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, waiting
  for `EXIT=`.
- General logic only; `src/web/` stays out of `src/core|plugin|shared|ui` imports and bundles.

## Output

- `~/.hermes/plans/figma-to-bricks/evidence/web-capture/fixer-8/answers.md`: for R8-1 and R8-2, **fixed** (test name,
  RED log, commit), **follow-up** (why) or **rejected** (the evidence), plus the R7-2 limit as recorded. Logs, probes,
  mutants and receipts beside it.
- Report (`ready-for-next-review`): branch, head SHA, the commits, the answers one line each, the gate tallies, then
  `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal;
  empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
