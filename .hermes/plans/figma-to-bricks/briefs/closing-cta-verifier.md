# VERIFIER (read only): closing-cta → section rhythm (FigmaToBricksV2)

You are a fresh, independent verifier. You never saw this build. Prove every acceptance criterion yourself on the final
code and on the old code. Read only: change no source or test, commit nothing, don't rebase or merge, don't edit skills
or memory, don't start other agents. Write only into `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/verifier/`
and your own scratch folder `verifier/` under the session scratchpad
(`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-closing-cta/ecf5994f-8276-4f04-b9c6-a00ab4b226ac/scratchpad`).
Never re-extract into another role's scratch tree. Copy every scratch script into `<your evidence>/scripts/` as soon as you
write it: a session restart empties the scratchpad and kills background runs.

## What to verify
- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/closing-cta`, branch `worktree-closing-cta`, head
  **`3a4ecf7`** (source and tests as of `17e4595`; `3a4ecf7` adds docs only). Base = merge-base with `main` =
  **`5e2f98b`** (build 2026-10-28.3). Local `main` has since moved to `b3addfb` (photo-hotspots, build 2026-10-28.4): don't
  rebase onto it or compare with it. A finisher rebases after acceptance, and a later round re-verifies that head.
  Confirm the head, the merge-base and a clean worktree before you start, and report any difference.
- Approved plan (read only): `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/plan-approved.md`, AC1–AC12
  (lines ~397–525, test notes ~700–725). Its "Amendments" list at the top records Justin's J1/J2 ("put it in a way where
  it looks more aesthetic"): buttons always get the page's section space. A one-row bar holding a call to action is never a
  tight strip. A section ending with buttons gets S under them even with a layer placed on it, unless a placed layer
  would land on its words or buttons or leave the edge it was drawn along. The plan's text is the oracle. Never change an
  AC's id, oracle or live tag.
- What Justin asked: a teammate's screenshot of Home's closing section ("Can we remove the line on the top, reduce the
  spacing on the top, and add more spacing below the buttons in this section?"). Then "make them general changes for
  any other website". Then "Do it for every section, like in the photo. Make sure the spacing is good, including the gap
  between sections. Also apply it to every call-to-action button, not just the closing one."
- **AC12 is live** (Justin's paste check): `accepted: false`, `not_run: "live: Justin re-pastes Home Page Final with the
  header/footer ticks on and checks the spacing in Bricks"`. If you see it failing, record the failure instead.

## Author leads (claims to check, not proof)
- History: builder `572c793`, then review 1 (request-changes), fixer 1 (`177ed95` … `8bdfb28`, with J1/J2), the plan
  amended (`8259f2e`), review 2 (request-changes: R2-F1 hills landing on buttons at 1100–992; R2-F2 a card holding
  placed layers doubling the space; R2-F3 1px frame/gradient dividers not treated as lines; R2-F4/F5 untested guards),
  then fixer 2 (`45ba999` … `3a4ecf7`). Fixer 2 reports:
  - `npm run check` green;
  - unit and browser results compared by test name with base: no new failure, and the same 12 font-environment
    browser failures on both;
  - mutation 63 of 75 killed;
  - all five real files at four tick settings byte-identical to `8259f2e`;
  - GRO and brainstorm byte-identical to base.
  Its report and receipts are in `../fixer-2/`; reviewer 2's report is `../reviewer-2/review.json`. Use them only as
  leads. Don't copy or hard-link any earlier receipt or screenshot.
- **Stale receipt:** the builder's AC8 receipt `../builder/negatives-base-vs-head.txt` predates J2. Don't rely on it:
  make your own.
- Rulings not yet confirmed by Justin (fixer 2):
  - at 992 a landing counts only when it is deeper than with today's spacing there;
  - at the design width, a drawing already on the words counts when the move would lay it deeper;
  - a line section is any section at most 2px tall holding no words and nothing taller;
  - two expectations corrected (AC8 phone 24 → 16, AC5 card holding hills 56/40/32 → 56/27/16).
  A ruling that fits the plan's text isn't a failure. One that contradicts an AC is.
- Recorded as known behaviour, not a failure: R2-F6. A kept footer that paints nothing counts as paint (160 / 112 / 80 at
  1440 / 992 / 390). Also fixer 2's found_else: a narrow drawing pinned beside the buttons doesn't shrink on phones
  (that happens on base too).

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, `references/rules-summary.md`
   first (VERIFIER role). It isn't linked into ~/.claude/skills. Its spacing line (~78) covers:
   - measuring content boxes in Chrome, leaving placed layers out;
   - `size.unpin`, `room()` and `place.ts` constraints;
   - the 992 landing check;
   - laptop widths 1100–1366.
   Read worktree CLAUDE.md sections only as needed (grep + offset/limit).
2. `engineering-best-practices`.
3. `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`. Read the ac.json schema in
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.
4. `mutation-testing-discipline` where you need to test whether a check can fail.

## Independent work
1. **Gates on head:**
   - `npm run check` in the worktree.
   - The full browser suite (`npm run test:browser`) on head and on base. Compare by complete test name: no new
     failure, no lost test, no new skip.
   - Corpus-backed unit tests in scratch `git archive` trees of head and base. In each tree, re-point `corpus.json` to
     local files, link `node_modules`, and put a scratch `bin/tsc` link to `node_modules/typescript/bin/tsc` first on
     PATH (a `.bin/tsc` link dangles). Compare by test name.
   - Record every true exit code.
2. **Each AC1–AC11 alone:** run its named test(s) by themselves on head (Chrome tests must print `skipped 0`), then on
   base with head's tests and fixtures copied into a base scratch tree. A new behaviour must fail on base for the
   intended reason. AC9/AC11 (preservation) may be `base_exempt` with the reason. Then challenge each AC's clauses the
   named test misses, with your own probes:
   - other frame widths;
   - a design wider than 1440;
   - ticks on and off;
   - widths 1440, 1366, 1200, 1100, 1024, 992, 991, 768, 390, 320;
   - bottom-pinned and top-pinned drawings, and one inside an inset card;
   - painted, outlined and fixed-height neighbours;
   - a call-to-action bar;
   - 1px frame and gradient dividers.
   "Build general logic": nothing keyed on Home's numbers, names or order.
3. **AC9 (blast radius):** replay all five real files at four tick settings (off, header, footer, both) on head and on
   base. GRO and brainstorm must be byte-identical to base, and golden `convert-sample.json` unchanged. Home, Services
   and Repairs must change only as the plan's tables say. **AC11:** the lint receipt, base vs head, five files × off/both ×
   the plan's widths.
4. **AC10:** Home converted and measured in Chrome as the plan says.
5. **A fresh screenshot per AC in your own folder:**
   - for a visual AC, the real rendered page;
   - for a non-visual one, a Chrome screenshot of your terminal output.
6. Write `<your evidence>/ac.json` (ac-check.sh's schema, tied to head `3a4ecf7` and base `5e2f98b`) and
   `<your evidence>/report.json`. Self-check the schema by running ac-check.sh on a copy pointed only at your own files;
   fix receipt or schema errors without touching source.
   - **Clean** means AC1–AC11 accepted and every gate qualified.
   - **A valid failure** gets an exact repro and evidence, so the main session can route it to a fixer.
   - Don't finish clean just because the named tests are green if one of your probes disproves an AC.

## This machine
- **Chrome:** your own wrapper script containing
  `exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"` as `CHROME_PATH`, with
  `/home/justin/.local/node-v22.23.3/bin` first on PATH. Use the same wrapper on head and base, and record it.
- **Corpus:** `npm run corpus` finds no files here (Mac paths). Never edit `corpus/corpus.json` in the worktree.
- **Five real files:**
  - Home `corpus/files/hydraulics-home.json`
  - GRO `corpus/files/gro-home.json`
  - Repairs: repo-root `figma-to-bricks-debug-page-1.json`
  - brainstorm: `figma-to-bricks-debug-design-inspo-brainstorm.json`
  - Services: `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/planner-revise/services.json` (never put it in the
    worktree)
- **Leave alone:** a headless Chrome (PID 232915) from 03:10 isn't yours. Never kill browsers globally.
- **Worktree guard:** this session refuses Bash it can't prove stays in the worktree: shell variables or loops around
  `node`/`git`, a heredoc then node, the word git inside a grep pattern.
  - Write scratch scripts with Write.
  - Run `node <absolute script> <absolute args>`, one plain command per call.
  - Send long gates to a log ending in `echo EXIT=$? >> log`, then wait on it.

## Return (your final message)
`{verdict: clean|findings, head, base, findings[{id, ac, severity, claim, repro, evidence}], ac_status[{ac, accepted,
test, evidence, screenshot}], gates[], qualifications[], found_else[], skill_lessons[{skill, lesson, evidence}]}`.
An empty skill_lessons list is normal: list only what a future task needs that the skill doesn't already say. End with
the line `MAIN SESSION: check and save these skill_lessons now.`
