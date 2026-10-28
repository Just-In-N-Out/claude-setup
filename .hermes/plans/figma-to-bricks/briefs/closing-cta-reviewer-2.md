# REVIEWER 2 (report only): closing-cta → section rhythm (FigmaToBricksV2)

You are a fresh, independent code reviewer. You did not build this. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/reviewer-2/`. Scratch: your own
`reviewer-2/` folder under the session scratchpad; never re-extract into another role's scratch tree.

- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/closing-cta`, branch `worktree-closing-cta`,
  head `8259f2e`, base `main` (`5e2f98b`, build 2026-10-28.3). The diff to review: `git diff main...HEAD`.
- Approved plan (read-only copy, amended 2026-10-28; its "Amendments" list at the top says what changed and why):
  `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/plan-approved.md` (AC1–AC12; AC12 is Justin's live paste
  check 3bp). Ledger `.superpowers/sdd/2026-10-28-closing-cta/progress.md`; HANDOFF's section rhythm part.
- What Justin asked: a teammate's screenshot of Home's closing section ("Can we remove the line on the top, reduce the
  spacing on the top, and add more spacing below the buttons in this section?"), "make them general changes for any
  other website", then "Do it for every section, like in the photo. Make sure the spacing is good, including the gap
  between sections. Also apply it to every call-to-action button, not just the closing one." Approved answers Q1A–Q6A.
  Mid-build, asked about two edge cases, he said "put it in a way where it looks more aesthetic", ruled as J1/J2:
  buttons always get the page's section space (a bar holding a call to action is never a tight strip; a section ending
  with buttons gets S under them though a layer is placed on it, unless a placed layer would land on its words or
  buttons or leave the edge it was drawn along).
- This is the second, fresh review of the corrected code. A first review (request-changes) found: a fixed-height
  section's neighbour collapsing to 0px from 991 down (F1); an inset card's padding outside the arithmetic (F2); a line
  above a ticked footer doubling the space (F3); a kept footer drawn over the last section (F4); a mislabelled
  equivalent mutant (F5); untested guards (F6); one non-monotone side (F7, answered without a change); a top bar
  demoting the hero (F8). A fixer fixed them and built J1/J2 (commits 177ed95 … 8bdfb28). Its report and evidence:
  `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/fixer-1/`. Review the whole feature yourself, not only those
  fixes, and look hardest at code the first review never saw: `src/core/understand/rhythm-buttons.ts` (`lands`),
  `widgets.ts` `ctaAt`, `SectionInfo.beside`, `IRNode.padOff` / `style/lines.ts` `unpadded`, the page-top reading
  via `topBars`/`heroOf`.
- Rulings to judge (not yet confirmed by Justin): the builder's R4a (tight means a one-row strip), R6a (outlined counts
  as painted; a fixed-height inset card counts as fixed), a side with a `beside` slides whatever its size; the fixer's
  eight (an unpainted inset card padded more than S shows S; the page's top keeps its own and never votes; beside a
  fixed-height section the side slides only to its tablet value minus the slack; J2 keeps today's spacing where a
  placed layer would land or leave its edge; a hanging layer keeps today's spacing, buttons or not; an inset card
  holding placed layers keeps its own padding; "ends with buttons" means the last layer down its flow through boxes
  that paint nothing is a call to action, not a button inside a painted box; F7's exact pair over a monotone side).

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; it isn't linked into ~/.claude/skills), `engineering-best-practices`,
`requesting-code-review` (its security scan and quality gates; skip its "independent reviewer subagent" and auto-fix
steps: you ARE the fresh reviewer, and you can't spawn agents), `code-review-practice`, `mutation-testing-discipline`
for the rhythm's and the buttons' guards. Read only the worktree CLAUDE.md sections you need (grep + offset/limit).

## What to check
- Correctness against the amended plan and every AC (AC1–AC11): does each test really prove its AC, fail on the base,
  and test the general case rather than one fixture? Are the mutation receipts honest (round 3: 35 killed, one named
  equivalent F2-card-zero; R4, R13, R24 survivors named as outside the brief: are they real gaps)?
- "Build general logic, never one-file fixes": nothing keyed on Home's numbers, names or order. Probe the designs that
  reach the rhythm: no section voting ≥ 40px, a tie for S, one section only, every section painted, a fixed-height
  hero with centred words, sections inside a wrapper frame, a design wider than 1440, negative gaps, the ticks on and
  off, a drawn phone design beside a desktop one, a call-to-action bar, a decorated closing (bottom-pinned and
  top-pinned drawings, one inside an inset card), a section whose buttons sit in a painted box. Does each give the
  page's space where the plan says, and today's output elsewhere?
- Chrome at 1440 → 320 (including 1366–992 and 991/768/390): no two sections' content closer than the plan allows, no
  drawing landing on words or buttons, no space doubled. The skill's lines on measuring content boxes, `size.unpin`,
  `room()` and `place.ts` constraints apply.
- The repo's architecture rules (CLAUDE.md "Architecture rules"): no stage edits an earlier stage's output, only
  `adapt/rules/` writes breakpoint styles, rules read `PageFacts`, typed CSS until emit, deterministic ids, files under
  ~300 lines (`style.ts` at 300), Figma-sandbox-safe code in src/core.
- Blast radius: GRO and brainstorm byte-identical to base at four tick settings; golden `convert-sample.json`
  unchanged; Home/Services/Repairs as the plan's tables say; fixtures only as the plan names.
- Bricks facts: `_alignSelf: stretch` never written; layout keys only on layout elements; Bricks caps every element at
  its parent's width; Bricks wraps every Section/Container/Block from 767px down.
- Machine: Linux/WSL. Chrome: your own wrapper script containing
  `exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"` as `CHROME_PATH`, with
  `/home/justin/.local/node-v22.23.3/bin` first on PATH. `npm run corpus` finds no files here; corpus-backed unit tests
  need scratch `git archive` trees with `corpus.json` re-pointed, `node_modules` linked and a scratch `bin/tsc` link
  first on PATH (memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`).
  Five real files: Home `corpus/files/hydraulics-home.json`, GRO `corpus/files/gro-home.json`, Repairs repo-root
  `figma-to-bricks-debug-page-1.json`, brainstorm `figma-to-bricks-debug-design-inspo-brainstorm.json`, Services
  `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/planner-revise/services.json`. Long gates to a log ending in
  `echo EXIT=$? >> log`. Copy every scratch script into your evidence `scripts/` as soon as you write it (a session
  restart empties the scratchpad). A headless Chrome (PID 232915) left from 03:10 isn't yours: leave it alone.
- Worktree guard: this session refuses Bash it can't prove stays in the worktree (shell variables or loops around
  `node`/`git`, heredoc then node, the word git inside a grep pattern). Write scratch scripts with Write and run
  `node <absolute script> <absolute args>`, one plain command per call.

## Report
Return `{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity: critical|high|medium|low, file,
line, claim, evidence, suggested_fix}], ac_status[{ac, accepted, test, evidence}], rulings_assessment[], found_else[],
skill_lessons[{skill, lesson, evidence}]}`. If you find any other problem outside this feature, list it in `found_else`
(don't fix it). If you learn something reusable, list it in `skill_lessons` (an empty list is normal); never edit skills
or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
