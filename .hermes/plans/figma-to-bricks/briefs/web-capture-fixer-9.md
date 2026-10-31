# Fixer brief: web-capture, fix pass 9 (after the verifier's findings)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin (2026-10-31) said to build the whole importer "straight through" with
the recommended answers: never stop to ask; decide, and record rulings (not yet confirmed) in the ledger and your
report.

**Skills:** load `receiving-code-review`, `test-driven-development`, `engineering-best-practices` and
`mutation-testing-discipline` with the Skill tool; read the project skill with Read:
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its `references/live-site-reading.md` (its
"Writing readers" lines on `var()` shorthands, content-box sizes and CSS font matching come from these findings),
`references/testing-pitfalls.md`, `references/core-constraints.md`.

## Start

Your agent worktree starts at `main`, not on the story. Put your copy on the verified head without rebasing:
`git checkout --detach 3705de1cf7a9174f189b59e42f7d70045781ffd2` then `git switch -c web-capture-fix-9`. Your commits go
on top of `3705de1`; the story's base stays `3ea33bb`. Approved plan:
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/plan-approved.md` (AC3 and AC6 are the ones at stake); spec
`docs/specs/web-capture.md`; ledger `.superpowers/sdd/2026-10-29-web-capture/progress.md` in your copy.

## What to fix

Review 9 was clean, then the independent verifier (`~/.hermes/plans/figma-to-bricks/evidence/web-capture/verifier/`:
`ac.json`, `report.json`, probes in `probe/` with sites in `probe/sites/`, runner `scripts/run-probe.sh`, logs and
`shots/`) accepted 12 of 14 ACs and disproved AC3 and AC6 with three P2s:

- **V-F1 (AC3) `src/web/read/authored.ts` `settle()` (lines 31-39):** a stretchy value written through `var()` inside a
  shorthand is lost. `CSS.getMatchedStylesForNode` lists `padding: 40px var(--side)` / `gap: var(--g)` and then its
  longhands with EMPTY values; `settle()` expands the shorthand and lets each empty longhand overwrite it, so no
  `web.stretchy` entry and no note (probe f: `#a`, `#d` null; controls `#b`, `#c`, `#e` record `4vw`/`2vw`;
  `probe/diag-authored.log` holds DevTools' real list). Real use: custom-property gutters, Elementor's
  `gap: var(--row-gap) var(--column-gap)`. The verifier's one-line scratch change (skip `null` or blank values) made
  5/5 pass: confirm it is the right general rule (an empty longhand after its shorthand is pending substitution, never
  a value) rather than taking it on trust.
- **V-F2 (AC3) `src/web/map/node.ts:110-116`:** a `max-width` whose computed value stays an expression
  (`min(92%, 980px)`) is checked against the border-box width, so on a `content-box` box with side padding the site's
  own value fails the check and a fitted `calc(4vw + 1000px)` is recorded instead; `stretchyOf` drops `keepStretchy`'s
  note, so the swap is silent where the plan says the fallback comes "and a note". Probe a (`#box` vs the border-box
  twin `#box2`). Fix both: check the value against the box it sizes (the content box under `content-box`), and keep
  the note whenever a fitted value replaces the site's own.
- **V-F3 (AC6) `src/web/read/fonts.ts` `usedFaces` (lines 53-56):** faces are matched by exact weight range and style,
  not by CSS font matching, so words drawn at an undeclared weight or style (a 700 run in a family declaring 400/600,
  an italic with no italic face) are listed `system/system/own`, the font source is never asked and there is no note:
  a failing family's words are silently measured with the fallback (probe g: 1/4 pass; probe b's `<strong>`/`<em>`
  runs; live www.letsgro.ai lists its Inter 600 words as `system`). Rule: pick the face the browser's font matching
  picks (CSS Fonts 4 §5.2: weight, then style, with synthesis), then report its load state, stand-in and note as for an
  exact match.
- **Fold in where the same rule covers it, else follow-ups:** the verifier's `found_else` P3s (`report.json`): AC10's
  test lacks a box inset by a one-sided margin (mutant V10a survives it); a max-width that doesn't size the box is
  recorded as `{px: box width}` with no note (an `<img>` with `max-width:100%` at its natural 300px); `target=_blank`
  lost on links that become text runs; the spec's "Floating boxes" step 1 vs ruling B7. Add those you don't fix to
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/follow-ups.md` under a "verifier" heading.

**Verify each first** on `3705de1` with the verifier's probes, then fix test-first (RED on `3705de1`), with generic
fixtures in `test/fixtures/web/` (never keyed on one site's words, colours or sizes), both directions (the site's own
value kept; a value that truly can't be kept gets the fitted one *and* a note). Kill the mutants of each new rule
(e.g. letting an empty longhand win again must fail a test; exact-match face lookup must fail one). Keep AC1–AC14
holding, review 2–9's regression corpus (`review-*/probe/`, the `reveal/*` fixtures) and the live homes the same.

## Rules

- Commit each fix (or close group) to your branch (plain `git commit -m`, no author override, no AI lines; no CLAUDE.md
  staged); batch ledger/record updates into the fix commits; HANDOFF's web-capture section names any new ruling as not
  yet confirmed. Don't push, don't bump `BUILD`, don't edit CLAUDE.md, never bare `git stash`, don't rebase. In this
  worktree-isolated session write multi-step scripts with the Write tool and run `bash <file>`; run git add, diff and
  commit as separate plain calls.
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
  `https://www.letsgro.ai/`, GET only. Never write to any WordPress site.
- Re-run the gates after the fixes and compare by test name with `3705de1` and base `3ea33bb`: typecheck (both configs),
  `npm run check`, `npm run test:web` (`skipped 0` apart from AC14, which you run with `F2B_WEB_SITES=letsgro,plugin-bricks`
  and its captures), the browser suite, and the five real Figma replays byte-identical (AC7/AC8). **This machine
  (WSL):** `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`, Node
  `/home/justin/.local/node-v22.23.3/bin` first on PATH; keep `TMPDIR` short (`~/.cache/wcap-fix9/tmp`); long gates as a
  script with `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, waiting for `EXIT=`. Never edit a script or source a
  running background test is loading; `node --test` options go before file paths.
- General logic only.
- Another job (`web-compare`) is being fixed in its own worktree at the same time: leave it alone.

## Output

- `~/.hermes/plans/figma-to-bricks/evidence/web-capture/fixer-9/answers.md`: for V-F1 to V-F3 and each P3, **fixed**
  (test name, RED log, commit), **follow-up** (why) or **rejected** (the evidence). Logs, probes, mutants and receipts
  beside it; copy scratch scripts into `fixer-9/scripts/` as soon as you write them.
- Report (`ready-for-next-review`): branch, head SHA, the commits, the answers one line each, the gate tallies, then
  `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal;
  empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
