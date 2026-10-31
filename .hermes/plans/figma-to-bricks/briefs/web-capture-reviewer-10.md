# Reviewer brief: web-capture, review round 10 (delta: fix pass 9, after the verifier)

**Role:** a fresh reviewer (Opus 5.5, xhigh), **report only**: change no source, commit nothing, write only into
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/review-10/`. You never saw the build or the earlier reviews' work.
Justin (2026-10-31) said to build the whole importer "straight through" with the recommended answers; make every
finding concrete and reproducible.

**Skills:** load `requesting-code-review` and `code-review-practice` with the Skill tool; read the project skill with
Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its `references/live-site-reading.md`,
`references/testing-pitfalls.md`, `references/core-constraints.md`. Read the review mechanics and Justin's severity scale:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("Rounds and scope", "The
reviewer's duties", "Records") and the `review-fix-cadence` skill.

## What to review

- Job: `web-capture` (J1 of the website importer): `npm run capture` writes the capture file every later importer job
  builds on. Approved plan: `~/.hermes/plans/figma-to-bricks/evidence/web-capture/plan-approved.md`; format spec
  `docs/specs/web-capture.md`.
- **Delta round:** fix pass 9's commits and what they touch: `git diff 3705de1..adc5d1a` (7 commits, branch
  `web-capture-fix-9`). Your worktree starts at `main`; run `git checkout --detach adc5d1a` and confirm the full SHA with
  `git rev-parse HEAD`. Anything outside the delta is P3.
- **Why this round:** review 9 at `3705de1` was clean, then the independent verifier
  (`evidence/web-capture/verifier/`: `ac.json`, `report.json`, probes `probe/`, runner `scripts/run-probe.sh`) disproved
  AC3 and AC6 with three P2s: V-F1 a `var()` inside a shorthand lost (empty longhands overwrote it), V-F2 an expression
  `max-width` on a content-box padded box checked against the border box and swapped silently for a fitted `calc()`,
  V-F3 faces matched by exact weight/style rather than CSS font matching. Fix pass 9 (`fixer-9/answers.md`, logs,
  probes, mutants, `homes/`): **F37** an empty declared value is skipped; **F39** a size the browser keeps as an
  expression is checked against the box it sizes, `%` against the parent's content box less borders (other ranges'
  `%` paddings were checked against the window), every fitted replacement gets a note in every range, and where a
  min-/max- size doesn't size the box at a width the browser's own value is the measure there (notes on the plugin-made
  home 30 → 38, letsgro 7 → 10); **F38** faces picked by CSS font matching (stretch, style, the spec's weight order), a
  failed pick drawn with the next family, a descriptor group's status loaded, else failed, else first; the font
  source asked for the failed faces as declared. All three rulings are not yet confirmed. Follow-ups it left are in
  `follow-ups.md` ("verifier") and HANDOFF "Deferred".
  When a finding is the same defect as an earlier one, set `"repeats"` and a 5+ word `"new_fact"`.
- **Earlier rounds:** `evidence/web-capture/review-1/` … `review-9/`, `fixer-1/` … `fixer-9/answers.md`. Accepted limits
  and rulings (F29, F31, F32, F35, F36) are not findings unless the delta breaks them.
- **Three trees per probe** (review-loop.md): the build's first reviewed head `c0f0529` (base `3ea33bb` has no
  `src/web`), the previous round's head `3705de1` and head `adc5d1a`.
- **Judge especially**, with hold-out probes of your own that are in neither the verifier's nor the fixer's sets, both
  directions (a value or face lost or wrong; a false note on an ordinary page): `var()` in every shorthand a site uses
  (`margin`, `inset`, `border-radius`, `grid-template`, `font`, `background`), nested `var()` with fallbacks, `!important`
  longhands after a shorthand; expression sizes (`min()`, `max()`, `clamp()`, `calc()` with `%`) on content-box and
  border-box boxes with borders and padding, in every range, under flex and grid parents, `%` of a parent with
  borders; the limit rule (a box at, just under and just over its `max-width`/`min-width`); font matching with
  variable faces (a `font-weight: 100 900` range), `font-stretch`, synthetic bold/italic, `unicode-range` subsets,
  `local()` sources, a family loaded from Google vs self-hosted; whether the new notes stay truthful and few on ordinary
  Elementor, Divi, Bricks and plain pages. Re-run the regression corpus of rounds 2–9 (`review-*/probe/`, the `reveal/*`
  fixtures) and the verifier's probes A, B, F and G on head; the architecture rules (`src/web` never imported by
  core/plugin/shared/ui; the five real Figma files replay byte-identical).
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of the plugin-made Bricks site `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`)
  and `https://www.letsgro.ai/`, GET only. Justin re-pastes the plugin-made site between passes: compare a live
  difference with `3705de1`'s capture taken the same day before blaming the fix.
- **This machine (WSL):** `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`;
  Chrome wrapper `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh` as `CHROME_PATH`,
  Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; keep `TMPDIR` short (`~/.cache/wcap-r10/tmp`); a
  browser/web run counts only with `skipped 0`. In this worktree-isolated session write multi-step scripts with the
  Write tool and run `bash <file>`; run git commands as separate plain calls. Another job (`web-compare`) is being fixed
  in its own worktree: leave it alone.

## Output

1. `review-10/review.json` as `review-loop.md` "Records" says: `"round": 10`, `"scope": "delta"`, `"from":
   "3705de1cf7a9174f189b59e42f7d70045781ffd2"`, `"head": "<adc5d1a's full SHA>"`, findings `R10-<k>` (P0–P3,
   `file_line`, `claim`, a 5+ word real-use `scenario` for every P0–P2, `repeats`/`new_fact` where they apply). Empty
   findings when clean.
2. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree>
   --base 3ea33bba9cf413d929923992431e0145bac07477 ~/.hermes/plans/figma-to-bricks/evidence/web-capture`; exit 2 means
   your file is wrong, so fix it. Exit 0/1/3 is the referee's verdict, not yours to act on.
3. Your report: `verdict`, the findings (one line each), `ac_status` (AC1–AC14 (AC14's bdryswi.com part is owed to
   Justin): holds / doesn't / unproven, one line each), then `skill_lessons[{skill, lesson, evidence, enforce}]`
   (reusable only; `enforce` `none` or a one-line check proposal; empty is normal; never edit skills or memory), ending
   with: `MAIN SESSION: check and save these skill_lessons now.`
