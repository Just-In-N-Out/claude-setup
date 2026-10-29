# REVIEWER 1 (report only): header-bar (FigmaToBricksV2)

You are a fresh, independent code reviewer. You did not build this. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/header-bar/reviewer-1/`.

- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar`, branch `worktree-header-bar`, head
  `eb23695`, base `main` (`dea6296`, build 2026-10-29.1; the branch was rebased onto it before any commit). The diff to
  review: `git diff main...HEAD`. Plugin source: `src/core/understand/site-header.ts`, new
  `src/core/understand/header-bar.ts`, `src/core/understand/understand.ts`, `src/core/understand/ir.ts`,
  `src/core/style/style.ts`, with their tests and the fixture `test/fixtures/header-bar.ts`. Check the full file list
  yourself.
- The B-Dry header paste (part of this job, outside the repo):
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/header-v1/` (`header-paste.json`, sha256
  `b379abba985695c0f6832e82d052b26792432792d0e2dfe27a915eaa8bc34bb0`, `manifest.json`, `scripts/`, `test/`, `shots/`).
- Approved plan (read-only copy): `~/.hermes/plans/figma-to-bricks/evidence/header-bar/plan-approved.md` (ACs
  AC1–AC16; AC14, the ☰ menu, waits for Justin's Offcanvas + Toggle sample and is not built; AC16 is Justin's live
  paste check 3bs). The builder's evidence and receipts: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/builder/`
  and `~/.hermes/plans/figma-to-bricks/shots/header-bar/`; ledger `.superpowers/sdd/2026-10-29-header-bar/progress.md`
  in the worktree; the HANDOFF section for header-bar.
- What Justin asked: the B-Dry staging site's top bar should look and work like bdryswi.com's (slim, gradient, logo at
  the left edge, button and ☰ at the right edge); the logo goes home, the phone number calls, the ☰ opens a menu. No
  debug file (his words: "just do it without the debug and figure it out"): the plan's root cause, that the staging
  header is the site's own hand-built template, is an inference from the live sites. Approved answers (standing
  auto-go, every ⭐): Q1 A (both the plugin's rules and a B-Dry paste), Q2 A (menu slides in from the right), Q3 A
  (menu waits for the sample), Q4 A (moving shimmer, still for reduced motion), Q5 A (sticky bar), Q6 A (wider than
  the design: logo and buttons 64px from the window's edges), Q7 A (the plugin's own Offcanvas emitter is a later job).
- Builder's rulings to judge (not yet confirmed by Justin): a wrapper's own Figma max width keeps its cap on wide
  screens (so hydraulics/page-1/Services gain only the logo link); a design wider than 1440 spans the window from 1441px
  up; the B-Dry logo is media 23 in a clipping figure, scaled to its ink; the paste's tablet rules use
  `@media (min-width: 768px) and (max-width: 1024px)` and replace the plugin's 34 tablet/phone keys (listed in
  `manifest.json`); the ☰ is a Div showing an SVG that opens nothing until the sample arrives. Its Task 4b (bands) was
  found by its own AC7 receipt.

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; it isn't linked into ~/.claude/skills), `engineering-best-practices`,
`requesting-code-review` (its security scan and quality gates; skip its "independent reviewer subagent" and auto-fix
steps: you ARE the fresh reviewer, and you can't spawn agents), `code-review-practice`, and
`mutation-testing-discipline` for the header-recognition guards (`contactLine`, `action`, `logoThenActions`, the
existing negatives, `hasMenu` and the footer left alone) and the logo-link guards (own link, Figma click, linked word,
linked bar; no nested links). Read only the worktree CLAUDE.md sections you need (grep + offset/limit).

## What to check
- Correctness against the plan and every built AC (AC1–AC13, AC15): does each test really prove its AC, fail on the
  base where it should (AC3 and AC5 are marked as guards true on base: is that honest?), and test the general case
  rather than one fixture? Are the mutation receipts honest, and is M3b's "equivalent" truly equivalent?
- "Build general logic, never one-file fixes": nothing keyed on B-Dry's numbers, names or words. Think of the bars
  that reach `site-header.ts` now: a title band with a button, a nav bar without a phone, a phone line in a hero, a
  footer with a logo and a phone, a bar drawn with absolute positioning (GRO), a drawn phone design, a 1728-wide
  design, the header and footer ticks on and off. Does widening recognition ever leave out something that isn't the
  header (lost content), or make two headers?
- The logo link: equal to a designer's own Figma link to `/`? Never a link inside another link (the
  `emit-nested-links` test must include this new link producer, per CLAUDE.md)? Does it go through
  `emit/page-addresses.ts` and the panel's `relink` like every other link kind?
- The repo's architecture rules (CLAUDE.md "Architecture rules"): no stage edits an earlier stage's output (is
  `IRNode.edges` recorded by the stage that knows it?), only `adapt/rules/` writes breakpoint styles, typed CSS until
  emit, deterministic ids, files under ~300 lines, Figma-sandbox-safe code in src/core (no URL/TextEncoder/DOM).
- Blast radius: the plan's AC7 list stays byte-identical to base; the only changes are those the plan's tables name.
- The B-Dry paste: payload checks clean, no class names that clash with the site's (memory note
  `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/bdry-home-copy.md` lists them), custom CSS naming
  only its own element (Bricks renames ids on paste), links correct (`/`, `tel:8124362379`, `/contact-us/`), reduced
  motion respected, no sideways scroll down to 320, sticky header with nothing hidden under it. Compare its shots with
  bdryswi.com's.
- Bricks facts: `_alignSelf: stretch` never written; layout keys only on layout elements; Bricks caps every element at
  its parent's width; Bricks wraps every Section/Container/Block from 767px down; a native element only from a sample
  in `reference/bricks/`.
- Machine: Linux/WSL. Chrome: write your own wrapper script in your scratch containing
  `exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"` and use it as
  `CHROME_PATH`, with `/home/justin/.local/node-v22.23.3/bin` first on PATH (the default profile stalls). `npm run corpus`
  finds no files here; corpus-backed unit tests need scratch `git archive` trees with `corpus.json` re-pointed,
  `node_modules` linked and a scratch `bin/tsc` link first on PATH (memory note
  `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`). Real files:
  `corpus/files/hydraulics-home.json`, `corpus/files/gro-home.json`, repo-root `figma-to-bricks-debug-page-1.json`,
  `figma-to-bricks-debug-design-inspo-brainstorm.json`, Services (`git show 2199895:figma-to-bricks-debug-page-1.json`
  into your evidence folder). Run gates in the foreground, or to a log ending in `echo EXIT=$? >> log`. Another job
  (`after-faq-sections`) is building in its own worktree at the same time: leave its worktree and processes alone.
- Worktree guard: this session refuses Bash it can't prove stays in the worktree (shell variables or loops around
  `node`/`git`/`sed`, heredoc then node, `git -C`, the word git inside a grep pattern or a script's text, the word
  `source` anywhere, even in a path). Write scratch scripts with Write and run `node <absolute script> <absolute args>`,
  one plain command per call.

## Report
Return `{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity: critical|high|medium|low, file,
line, claim, evidence, suggested_fix}], ac_status[{ac, accepted, test, evidence}], rulings_assessment[], found_else[],
skill_lessons[{skill, lesson, evidence, enforce}]}`. `enforce` is `none`, or, when the lesson is about a rule that was
broken or nearly broken, a one-line proposal for a check that would have caught it (its kind, what it checks, where it
runs). If you find any other problem outside this feature, list it in `found_else` (don't fix it). If you learn
something reusable, list it in `skill_lessons` (an empty list is normal); never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
