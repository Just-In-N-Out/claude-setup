# Fixer brief: web-capture, fix pass 10 (after review round 10)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin (2026-10-31) said to build the whole importer "straight through" with
the recommended answers: never stop to ask; decide, and record rulings (not yet confirmed) in the ledger and your
report.

**Skills:** load `receiving-code-review`, `test-driven-development`, `engineering-best-practices` and
`mutation-testing-discipline` with the Skill tool; read the project skill with Read:
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its `references/live-site-reading.md` ("Writing
readers": `var()` shorthands, content-box sizes, `%` bases, font matching, counting notes before turning a silent
fallback into a note), `references/testing-pitfalls.md`, `references/core-constraints.md`.

## Start

Your agent worktree starts at `main`, not on the story. Put your copy on the reviewed head without rebasing:
`git checkout --detach adc5d1a6bc4fe4a2f0d673d0853626bea65a55ec` then `git switch -c web-capture-fix-10`. Your commits
go on top of `adc5d1a`; the story's base stays `3ea33bb`. Approved plan:
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/plan-approved.md` (AC3, AC6); spec `docs/specs/web-capture.md`
(its notes contract: a note for "a stretchy value that didn't reproduce"); ledger
`.superpowers/sdd/2026-10-29-web-capture/progress.md` in your copy; fix pass 9's rulings F37–F39 in
`evidence/web-capture/fixer-9/answers.md`.

## What to fix

Round 10 (`~/.hermes/plans/figma-to-bricks/evidence/web-capture/review-10/review.json`; probes `review-10/probe/`
(`r10blocks`, `r10blocks2`, `r10type`, `r10size`, …), corpus runs `review-10/corpus/`, scripts `review-10/scripts/`):

- **R10-1 (P2, a regression from fix pass 9) `src/web/map/ranges.ts:40`:** commit `1b17f25` made `lengthAt` pass on
  every `keepStretchy` note, including lengths the site never set as a stretchy value (an inherited font size, em
  padding): `keepStretchy` fits them whenever their px change across a range and notes "a size didn't reproduce the
  drawn px; fitted calc(…)" though nothing was replaced and the fitted value reproduces the px. One note per element
  per non-design range: a block-theme page with fluid type and ids on every element (as Bricks writes them) 118 notes
  vs 2 on both older trees; without ids 14 vs 2; a smaller fluid-type page 11 vs 1. **Rule:** a note only where a value
  the site set could not be kept and something else stands in its place (the spec's contract); a length the site never
  set as stretchy, or a fitted value that reproduces the px with nothing of the site's lost, gets no note. Keep fix pass
  9's true notes (a site value really replaced: V-F2's `#box`, its limit cases).
- **P3s, fix while you are in these files** (wave 2 reads `px[]`, so a wrong base there will become a real bug):
  - **R10-2 `src/web/map/stretchy.ts:122`:** the `%` base and the limit rule use the mapped parent's content box, but a
    grid item's `%` is of its grid area and a placed box's is of its positioned parent's padding box (`#gi`: a
    `min(80%, 500px)` item drawn 362.66 recorded `px [500…]`; grid children under Bricks' `max-width: 100%` recorded
    with the grid's width; `#abs`: a placed bar spanning the padding box gets a new note and loses the site's 100%).
  - **R10-5 `src/web/map/sizing.ts:54`:** V-F2's defect in the sizing path: `width: 40%` on a content-box flex item
    with side padding is checked against its border box, so it is fitted and the 40% lost. Use the same "the box it
    sizes" rule F39 set, from one shared helper rather than a second copy.
  - **R10-3 `src/web/read/authored.ts:18`** (`font` and `grid-template` shorthands through `var()` not expanded) and
    **R10-4 `src/web/read/fonts.ts:85`** (font usage keyed without `font-stretch`; a latin subset failed but latin-ext
    loaded reads "loaded, own"): fix if the same rules cover them cleanly, else follow-ups in `follow-ups.md`
    ("review 10") and HANDOFF "Deferred".

**Verify each first** on `adc5d1a` with the reviewer's probes, then fix test-first (RED on `adc5d1a`) with generic
fixtures in `test/fixtures/web/` (a fluid-type page with ids on every element; a grid with `%`/`min()` items; a placed
bar; a content-box flex item with `%` width), both directions: no note where nothing of the site's was lost; a true
note where it was. **Count the notes** on the reviewer's fluid-type probes, the regression corpus and both live homes
with `adc5d1a` and with your head, and report the counts. Kill the mutants of each new rule. Keep AC1–AC14 holding,
the verifier's probes (A, A2, B, F, G), review 2–10's regression corpus (`review-*/probe/`, the `reveal/*` fixtures)
and the live homes the same apart from intended changes.

## Rules

- Commit each fix (or close group) to your branch (plain `git commit -m`, no author override, no AI lines; no CLAUDE.md
  staged); batch ledger/record updates into the fix commits; HANDOFF's web-capture section names any new ruling as not
  yet confirmed. Don't push, don't bump `BUILD`, don't edit CLAUDE.md, never bare `git stash`, don't rebase. In this
  worktree-isolated session write multi-step scripts with the Write tool and run `bash <file>`; run git add, diff and
  commit as separate plain calls.
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
  `https://www.letsgro.ai/`, GET only. Never write to any WordPress site.
- Re-run the gates after the fixes and compare by test name with `adc5d1a` and base `3ea33bb`: typecheck (both
  configs), `npm run check`, `npm run test:web` (`skipped 0` apart from AC14, which you run with
  `F2B_WEB_SITES=letsgro,plugin-bricks` on fresh captures), the browser suite, and the five real Figma replays
  byte-identical (AC7/AC8). **This machine (WSL):** `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`, Node
  `/home/justin/.local/node-v22.23.3/bin` first on PATH; keep `TMPDIR` short (`~/.cache/wcap-fix10/tmp`); long gates as
  a script with `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, waiting for `EXIT=`. Never edit a script or source
  a running background test is loading; `node --test` options go before file paths.
- General logic only.
- Another job (`web-compare`) is being fixed in its own worktree at the same time: leave it alone.

## Output

- `~/.hermes/plans/figma-to-bricks/evidence/web-capture/fixer-10/answers.md`: for R10-1 to R10-5, **fixed** (test name,
  RED log, commit), **follow-up** (why) or **rejected** (the evidence); the note counts before and after. Logs, probes,
  mutants and receipts beside it; copy scratch scripts into `fixer-10/scripts/` as soon as you write them.
- Report (`ready-for-next-review`): branch, head SHA, the commits, the answers one line each, the gate tallies, then
  `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal;
  empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
