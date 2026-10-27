# REVIEWER 1 (report only) — slider-autoplay (FigmaToBricksV2)

You are a fresh, independent code reviewer. You did not build this. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/reviewer-1/`.

- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/slider-autoplay`, branch `worktree-slider-autoplay`,
  head `172e7f1`, base `main` (`f46f8a2`). The diff to review: `git diff main...HEAD`.
- Approved plan (read-only copy): `~/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/plan-approved.md`
  (paste check 3bm). Justin lifted the plan's Bricks-sample gate on 2026-10-27: the slider keys come from Bricks' schema
  2.4.3 and the live page's printed data-splide, archived as reference/bricks/slider-autoplay-documented.json; AC13
  (live) is the proof of the keys. Judge whether that evidence supports every key written.
- Builder's rulings to judge (not yet confirmed by Justin): variants that look exactly the same stay still with a note;
  an instance without interactions of its own takes its main's; dots (one painted unlike the others marks the slide)
  and arrows (on one line, middles within 2px) must sit at the same place on every slide; a link on the slider's own
  layer holds it still; each slide is a Block holding its variant or band; speed from the first change's duration;
  number settings go out as strings and a fade also rewinds; the renderer prints Bricks' full options for every slider
  (the phone sliders' paste unchanged); the renderer's stand-in arrow icons. The planner's R1–R8 (delay under 50 read as
  seconds; Figma's easing/direction not carried; edge to edge with words in the 1440 Container; pause on hover and
  focus; Bricks' own arrows; slide 1 keeps the instance's overrides; phone sliders never autoplay; no gap).

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; it isn't linked into ~/.claude/skills), `engineering-best-practices`,
`requesting-code-review` (its security scan and quality gates; skip its "independent reviewer subagent" and auto-fix
steps: you ARE the fresh reviewer, and you can't spawn agents), `code-review-practice`, `mutation-testing-discipline`
for the loop recognition and control guards. Read only the main-folder CLAUDE.md sections you need.

## What to check
- Correctness against the plan and every AC (AC1–AC12; AC13 is Justin's live check): does each test really prove its AC,
  fail on the base, and test the general case rather than one fixture?
- The repo's architecture rules (CLAUDE.md "Architecture rules"): no stage edits an earlier stage's output, typed CSS
  until emit, only adapt/rules write breakpoint styles, deterministic ids, files under ~300 lines, Figma-sandbox-safe
  code in src/core (no URL/TextEncoder/DOM), no element naming another element's id in custom CSS.
- "Build general logic, never one-file fixes"; "Only Figma's animations"; nothing changes without the mark (corpus
  byte-identity).
- Bricks facts: `_alignSelf: stretch` never written; layout keys only on layout elements; Bricks caps every element at
  its parent's width (`[class*=brxe-]{max-width:100%}`); `.brxe-block` defaults to align-items:flex-start on the live
  site (the renderer lacks it).
- Autoplay timing, pause on hover and focus, reduced motion, Splide's loop clones (duplicate ids and h1s), the hero and phone rules around a slider, links and Call buttons on every slide, arrows over full-width phone buttons, and whether every Bricks key written is backed by the documented evidence.
- Machine: Linux/WSL. `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. `npm run corpus` finds no files
  here (memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`).
  Run gates in the foreground (a session restart kills background runs).

## Report
Return `{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity: critical|high|medium|low, file,
line, claim, evidence, suggested_fix}], ac_status[{ac, accepted, test, evidence}], rulings_assessment[], found_else[],
skill_lessons[{skill, lesson, evidence}]}`. If you find any other problem outside this feature, list it in `found_else`
(don't fix it). If you learn something reusable, list it in `skill_lessons` (an empty list is normal); never edit skills
or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
