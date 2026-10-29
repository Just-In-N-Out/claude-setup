# REVIEWER 2 (report only): header-bar (FigmaToBricksV2)

You are a fresh, independent code reviewer. You did not build or fix this, and you haven't seen the first review's
reasoning beyond what is named here. Do a **full** review of the corrected code. Report findings only: change no
source or test, commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/header-bar/reviewer-2/`.

- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar`, branch `worktree-header-bar`, head
  `e630f4d`, base `main` (`dea6296`, build 2026-10-29.1). The diff to review: `git diff main...HEAD` (the whole job,
  not only the fixes). Plugin source: `src/core/understand/site-header.ts`, new `src/core/understand/bar-parts.ts`
  (predicates split out of site-header.ts), new `src/core/understand/header-bar.ts`, `src/core/understand/
  understand.ts`, `src/core/understand/ir.ts`, `src/core/style/style.ts`, their tests and `test/fixtures/
  header-bar.ts`. Check the full file list yourself.
- The B-Dry header paste (part of this job, outside the repo):
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/header-v1/` (`header-paste.json`, sha256
  `f48783e50da30d89d963d60e57b372d3cfb31f3e416c9927e5b0b8cbf96bba3e`; the previous one in `previous/`).
- Approved plan (read-only copy): `~/.hermes/plans/figma-to-bricks/evidence/header-bar/plan-approved.md` (AC1–AC16;
  AC14, the ☰ menu, waits for Justin's Offcanvas + Toggle sample and is not built; AC16 is Justin's live paste check
  3bs). Justin's later answer: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/justin-answers.md` (H1 = A: a
  design drawn wider than 1440 keeps its header inside the 1440 Container; Q6 A's window edges apply only to designs
  1440 wide or narrower). Evidence: `builder/`, `reviewer-1/` (its `review.json`) and `fixer-1/` under
  `~/.hermes/plans/figma-to-bricks/evidence/header-bar/`; ledger `.superpowers/sdd/2026-10-29-header-bar/progress.md`;
  the HANDOFF section.
- What Justin asked: the B-Dry staging site's top bar should look and work like bdryswi.com's (slim, gradient, logo at
  the left edge, button and ☰ at the right edge); the logo goes home, the phone number calls, the ☰ opens a menu. No
  debug file: the staging header was found to be the site's own hand-built template (an inference). Approved answers:
  Q1–Q7 all A (both plugin rules and a B-Dry paste; menu slides in from the right; menu waits for the sample; moving
  shimmer, still for reduced motion; sticky bar; wide screens 64px from the edges; the plugin's own Offcanvas emitter
  is a later job), then H1 A.
- **Reviewer 1's findings and the fixer's answers (check each is really closed, and that the fixes broke nothing):**
  F1 high (title band / phone strip / call band taken as the header) → fixed in 968a1ab, 0b0faa6 (P2b covered only
  where an icon-first strip sits over a logo bar); F2 medium (the menu-icon note named a linked button's arrow on
  hydraulics/page-1/Services) → fixed in 968a1ab, receipts now pin each note's label per page; F3 medium (the first
  layer taken as the logo) → fixed in 512ebe6, a3a953e (a shop header links its logo and names its left ☰); F4 low
  (guards without tests) → tests in e2f9346 (R5, R8 called no-ops on screen); F5 low (B-Dry phone line not centred at
  768–1024) → paste rule changed, AC9 now measures the words' ink; H1 A → dbf64b8. The fixer's rulings, not yet
  confirmed: a "☰ Menu" box counts as a menu item (not named); a shop header names its left ☰; an icon-first strip
  joins the logo bar under it; the tablet phone line uses bdryswi.com's 43/92px gaps.

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; it isn't linked into ~/.claude/skills), `engineering-best-practices`,
`requesting-code-review` (its security scan and quality gates; skip its "independent reviewer subagent" and auto-fix
steps: you ARE the fresh reviewer, and you can't spawn agents), `code-review-practice`, and
`mutation-testing-discipline` for the header-recognition guards, the logo-link guards, the note's guards and H1's cap.
Read only the worktree CLAUDE.md sections you need (grep + offset/limit).

## What to check
- Correctness against the plan, the H1 answer and every built AC (AC1–AC13, AC15): does each test prove its AC, fail
  on base where it should, and test the general case? Are the mutation receipts honest?
- "Build general logic, never one-file fixes": nothing keyed on B-Dry's numbers, names or words. Try your own
  variations, not reviewer 1's: a nav bar with a logo, links and a button but no phone; a header with two rows (a top
  contact strip and a nav bar) drawn in one frame; a centred logo with links on both sides; a logo typed as words; a
  header drawn without auto layout (GRO); a drawn phone design; 1440-, 1728- and 1920-wide designs; the header and
  footer ticks on and off. Does recognition ever leave out something that isn't the header, keep two headers, or link
  the wrong layer?
- The logo link: equal to a designer's own Figma link to `/`? Never a link inside another link (`emit-nested-links`
  must include this new link producer)? Through `emit/page-addresses.ts` and the panel's `relink`?
- The repo's architecture rules (CLAUDE.md "Architecture rules"): no stage edits an earlier stage's output, only
  `adapt/rules/` writes breakpoint styles, typed CSS until emit, deterministic ids, files under ~300 lines,
  Figma-sandbox-safe code in src/core.
- Blast radius: the AC7 list stays byte-identical to base; hydraulics, page-1 and Services differ only by the logo's
  home link; no unexpected panel note on any real file.
- The B-Dry paste: payload checks clean, no class names that clash with the site's (memory note
  `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/bdry-home-copy.md`), custom CSS naming only its own
  element, links (`/`, `tel:8124362379`, `/contact-us/`), reduced motion, no sideways scroll down to 320, sticky header
  with nothing hidden under it, the phone line's words centred as on bdryswi.com at every width.
- Machine: Linux/WSL. Chrome: write your own wrapper script in your scratch containing
  `exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"` and use it as
  `CHROME_PATH`, with `/home/justin/.local/node-v22.23.3/bin` first on PATH. `npm run corpus` finds no files here;
  corpus-backed unit tests need scratch `git archive` trees with `corpus.json` re-pointed (memory note
  `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`). Real files:
  `corpus/files/hydraulics-home.json`, `corpus/files/gro-home.json`, repo-root `figma-to-bricks-debug-page-1.json`,
  `figma-to-bricks-debug-design-inspo-brainstorm.json`, Services (`git show 2199895:figma-to-bricks-debug-page-1.json`
  into your evidence folder). Another job (`after-faq-sections`) is being fixed in its own worktree: leave it alone.
- Worktree guard: this session refuses Bash it can't prove stays in the worktree (shell variables or loops around
  `node`/`git`/`sed`, heredoc then node, `git -C`, the word git inside a grep pattern or a script's text, the word
  `source` anywhere, even in a path). Write scratch scripts with Write and run `node <absolute script> <absolute args>`,
  one plain command per call (a plain `bash <script>` in its own call is allowed).

## Report
Return `{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity: critical|high|medium|low, file,
line, claim, evidence, suggested_fix}], reviewer1_closed[{id, closed, evidence}], ac_status[{ac, accepted, test,
evidence}], rulings_assessment[], found_else[], skill_lessons[{skill, lesson, evidence, enforce}]}`. `enforce` is
`none` or a one-line proposal for a check that would have caught a broken rule. Never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
