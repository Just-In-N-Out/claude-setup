# REVIEWER 1 (report only): closing-cta → section rhythm (FigmaToBricksV2)

You are a fresh, independent code reviewer. You did not build this. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/reviewer-1/`.

- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/closing-cta`, branch `worktree-closing-cta`,
  head `572c793`, base `main` (`5e2f98b`, build 2026-10-28.3). The diff to review: `git diff main...HEAD` (15 files;
  the source is `src/core/understand/{rhythm,designs,ir,section}.ts`, `src/core/style/{lines,style}.ts`,
  `src/core/adapt/rules/space.ts`; tests `test/unit/{understand-rhythm,understand-site-gaps,corpus-section-rhythm}.test.ts`,
  `test/browser/section-rhythm.test.ts`, fixture `test/fixtures/closing-cta.ts`).
- Approved plan (read-only copy): `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/plan-approved.md`
  (rulings R1–R13 at its line ~267, ACs AC1–AC12, AC12 is Justin's live paste check 3bp). The builder's evidence and
  receipts: `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/builder/`; ledger
  `.superpowers/sdd/2026-10-28-closing-cta/progress.md` in the worktree; HANDOFF section "section rhythm".
- What Justin asked: a teammate's screenshot of Home's closing section ("Can we remove the line on the top, reduce the
  spacing on the top, and add more spacing below the buttons in this section?"), then: "make them general changes for
  any other website", then "Do it for every section, like in the photo. Make sure the spacing is good, including the
  gap between sections. Also apply it to every call-to-action button, not just the closing one." He chose the page
  rhythm 120 / 84 / 64 on Home. Approved answers Q1A–Q6A (one section space S between two sections' words; S = the
  space most sections share; lines go except between touching painted bands; painted sections keep their inside
  padding; the first section keeps its own; free-drawn pages and drawn phone designs stay as drawn).
- Builder's rulings to judge (not yet confirmed by Justin): **R4a** "tight" means a strip (under 40px above and under
  its words AND its words in one row), because the plan's R4 would leave 0 under a closing CTA drawn with no gaps;
  **R6a** an outlined section counts as painted (keeps its padding inside its outline); an inset card drawn at a fixed
  height counts as fixed (keeps its own, never votes); a side carrying a `rest` slides whatever its size. Part 1's
  rulings (round 1): keepBeside notes carry the paired-design prefix; header/footer gaps are measured only inside one
  selected frame.

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; it isn't linked into ~/.claude/skills), `engineering-best-practices`,
`requesting-code-review` (its security scan and quality gates; skip its "independent reviewer subagent" and auto-fix
steps: you ARE the fresh reviewer, and you can't spawn agents), `code-review-practice`, `mutation-testing-discipline`
for the rhythm's guards (who votes for S, the paint/own/rhythm edge kinds, tight/fixed/placed/overlap exceptions, lines
kept between touching painted bands, Part 1's keepBeside). Read only the worktree CLAUDE.md sections you need (grep +
offset/limit).

## What to check
- Correctness against the plan and every AC (AC1–AC11): does each test really prove its AC, fail on the base, and test
  the general case rather than one fixture? Are the mutation receipts (28/28 rhythm, 8/8 lines, 8/8 Part 1, three named
  equivalents M9c, M19b, M22) honest: is each "equivalent" truly equivalent?
- "Build general logic, never one-file fixes": nothing keyed on Home's numbers, names or order. Think of the designs
  that reach `rhythm.ts`: no section voting ≥ 40px, a tie between two values, one section only, every section
  painted, a hero drawn at a fixed height, a section with an absolutely placed layer, sections inside a wrapper frame,
  a design wider than 1440, negative gaps, a page with the header/footer ticks on and off, a drawn phone design beside
  a desktop one. Does each fall back to today's output?
- The repo's architecture rules (CLAUDE.md "Architecture rules"): no stage edits an earlier stage's output (understand
  decides, style writes, only `adapt/rules/` writes breakpoint styles, emit folds the fluid tier), rules read
  `PageFacts`, typed CSS until emit, deterministic ids, files under ~300 lines (`style.ts` is now at 300),
  Figma-sandbox-safe code in src/core (no URL/TextEncoder/DOM).
- `space.ramp`'s new `rest` stepping (`step(pad + rest) − step(rest)`): monotone, whole pixels, never negative, the
  same at every tier as the plan's tables; interaction with Part 1's `marginBottom` and with the ≥ 40px clamp.
- Divider lines (`IRNode.noLine`, `style/lines.ts` `unlined`): only lines facing a rhythm boundary go; outlines, FAQ
  item rules, table rules, a box's full outline and the lines between touching painted bands stay; a section drawn
  only as a line is left out without losing anything else.
- Calls to action: every section ending with buttons gets S under them (AC7), with `markCtas`'s whole predicate.
- Blast radius: GRO and brainstorm byte-identical at four tick settings; golden `convert-sample.json` unchanged; only
  the fixtures the plan names change; Home/Services/Repairs change only as the plan's tables say. Phones will look
  tighter than today (64 on Home, 40 on Services between sections): judge whether that is what the approved plan says.
- Bricks facts: `_alignSelf: stretch` never written; layout keys only on layout elements; Bricks caps every element at
  its parent's width; Bricks wraps every Section/Container/Block from 767px down.
- Machine: Linux/WSL. Chrome: write your own wrapper script in your scratch containing
  `exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"` and use it as
  `CHROME_PATH`, with `/home/justin/.local/node-v22.23.3/bin` first on PATH (the default profile stalls). `npm run corpus`
  finds no files here; corpus-backed unit tests need scratch `git archive` trees with `corpus.json` re-pointed,
  `node_modules` linked and a scratch `bin/tsc` link first on PATH (memory note
  `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`). Five real files: Home
  `corpus/files/hydraulics-home.json`, GRO `corpus/files/gro-home.json`, Repairs repo-root
  `figma-to-bricks-debug-page-1.json`, brainstorm `figma-to-bricks-debug-design-inspo-brainstorm.json`, Services
  `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/planner-revise/services.json`. Run gates in the foreground, or to
  a log ending in `echo EXIT=$? >> log`. A headless Chrome (PID 232915) left from 03:10 isn't yours: leave it alone.
- Worktree guard: this session refuses Bash it can't prove stays in the worktree (shell variables or loops around
  `node`/`git`, heredoc then node, the word git inside a grep pattern). Write scratch scripts with Write and run
  `node <absolute script> <absolute args>`, one plain command per call.

## Report
Return `{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity: critical|high|medium|low, file,
line, claim, evidence, suggested_fix}], ac_status[{ac, accepted, test, evidence}], rulings_assessment[], found_else[],
skill_lessons[{skill, lesson, evidence}]}`. If you find any other problem outside this feature, list it in `found_else`
(don't fix it). If you learn something reusable, list it in `skill_lessons` (an empty list is normal); never edit skills
or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
