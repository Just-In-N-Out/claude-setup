# Brief: FIXER 1 for figma-to-bricks feature "after-faq-sections" (Full pipeline)

You are a fresh fixer. Act on reviewer 1's findings and the approved AC7 amendment: verify each finding first, fix the
valid ones test-first, and push back with evidence on any that are wrong. Don't re-plan and don't widen the job.

## Step 0: your copy
You start in your own throwaway worktree (`isolation: worktree`, made from `main` at dea6296, on its own branch
`worktree-agent-<your id>`). The job so far is commit `a95a19e` on branch `worktree-agent-a1582d79d2caf2309` (the
builder's worktree `.claude/worktrees/agent-a1582d79d2caf2309`: never write or run commands there). In **your own**
worktree run `git merge --ff-only a95a19e` and check `git rev-parse HEAD` is `a95a19e…`. Do all your work and commits
there, on your own branch, and leave the worktree in place when you finish (it holds the job's new head). If
CLAUDE.md or node_modules is missing, copy them from the main folder (`cp /home/justin/Documents/FigmaToBricksV2/
CLAUDE.md <your worktree>/`, `cp -a /home/justin/Documents/FigmaToBricksV2/node_modules <your worktree>/`; never
stage CLAUDE.md). If any of this is refused, stop at once with the exact message.

## Where
- Reviewer 1's report: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/reviewer-1/review.json` (read it
  whole), with its probes (`probe-variants-head.log`, `probe-browser.log`, `probe-browser/A-1440.png`,
  `probe-titles.json`, its mutation notes). Reuse its probe fixtures rather than retyping them.
- Approved plan (read-only): `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/plan-approved.md` and the
  approved amendment `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/ac7-amendment-approved.md`.
- The builder's evidence: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/builder/`; ledger
  `.superpowers/sdd/2026-10-29-after-faq-sections/progress.md`; the B-Dry paste
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v4/`.
- Your evidence: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/fixer-1/`.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
   `references/rules-summary.md`; only the CLAUDE.md sections you need (grep + offset/limit).
2. `engineering-best-practices`, 3. `receiving-code-review`, 4. `test-driven-development`,
5. `mutation-testing-discipline` (each guard you add or keep must have a test that fails without it),
6. `systematic-debugging` whenever a test fails unexpectedly, 7. `git-commit-rules`.

## The findings (reviewer 1, verdict request-changes)
- **F1 (high), `footer-stack.ts` 37–44 (`stackParts` others) and 85–118 (`viewOf`/`gapped`):** in an auto-layout
  footer frame, a narrow flow child (logo, social row, heading, back-to-top) counts as a "small layer" and lands on the
  first part (flow children never overlap); `gapped()` makes it a flow child of that view, the box stretches and
  `space()` gives the next part a large negative margin. A social row between the steps and the links keeps footer
  content on the page and hides the band in Chrome (Steps at 1153 above Consultation at 1244); under the links,
  margin −570; a narrow heading above moves under the band. Base left the whole frame out in each case. Reviewer's
  fix: in auto layout only absolute children may be overlays (a narrow in-flow child means "not a stack"); free-drawn,
  a layer overlapping no part is not given to `bands[0]`; in `gapped()` only the part flows, overlays stay absolute and
  the view's box comes from the part. Tests first: AC3 cases with a narrow flow child above, between and under the
  parts, and a Chrome check that kept sections never overlap.
- **F2 (medium), the section rhythm reads the new `behind` paint as page colour:** `rhythm.ts` `paints()`/`edgeOf`
  look only at the part's own fills. With white sections above an unpainted first part, the space moves to the white
  section above (padBottom 96) and Steps gets padTop 0 where 72 was drawn ("How it works" touches the dark paint's top
  at 1440 and 390); the fixture's parts under white sections get 96/96 where 24/48 was drawn. Fix: the rhythm judges a
  section by what it paints (`section.fills`); add a Chrome test with white sections above the footer. If this touches
  rhythm code the plan didn't name, keep the change to that read and say so.
- **F3 (low):** the note's wording is untested (mutants R1, R2 survived): assert the exact note.
- **F4 (low):** two new `section.ts` branches never run (the frame's paint on a kept part narrower than the page, and
  on a kept part that plays as a slider; R6, R6b, R7 survived): add tests that reach them.
- **F5 (low):** two guards never reached (the header set passed from `designs.ts`, `first < 0`; R4, R8 survived; R4
  changes nothing on any fixture): add tests, or show a guard is dead and remove it, test-first.
- **F6 (low, paste):** step 3's title in Roboto 600 is 322.53px in a 325px box (fits by 2.47px): name it in paste check
  3bt's HANDOFF text.
- **AC7 (approved amendment, test only, no paste change):** in `after-faq-render.test.ts`, at 1024 measure ours from
  the FAQ section's bottom and the real page from `ae04cf6`'s bottom; lay the five real titles out in Roboto 600
  (loaded) in the real 325px title box; shift the real page's later tops and the steps section height by (capture lines
  − Roboto lines) × the line height; never hard-code 1 line. Keep every other sub-check and tolerance. Add the v3 FAQ
  mascot (stacks at 991, not 1024) to HANDOFF as a named follow-up.
- **Not in this job:** reviewer 1's R7 suggestion (allow "the stack plus wordless sections" when a bottom strip sits
  under the footer frame) widens the plan's rule: record it in HANDOFF as a follow-up, don't build it.

## Done means
Every valid finding fixed test-first, each guard's test proven to fail without it, AC7 green under the amendment,
`npm run check` green, the browser tests for this job green with `skipped 0`, the full browser suite compared by test
name with base `dea6296` (no new failures), the AC4/AC5 receipts re-run (five real files × four tick settings still
byte-identical), the v4 paste tests green and its files unchanged unless a finding needs it (say so and give new
hashes), ledger and HANDOFF updated, committed. Stop with `status: ready-for-review` (a second fresh reviewer comes
next): no merge, no BUILD. Report your worktree path, branch and last commit.

## This machine and the guard
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH, the same
profile for base and head. `npm run corpus` measures nothing here; corpus-backed unit tests need scratch `git archive`
trees with `corpus.json` re-pointed (memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/
corpus-paths-on-desktop.md`). The worktree guard refuses Bash it can't prove stays in your worktree (shell variables or
loops around `node`/`git`/`sed`, heredoc then node, `git -C`, the word git inside a grep pattern or a script's text,
the word `source` anywhere, even in a path): write scripts with Write and run `node <absolute script> <absolute args>`,
one plain command per call (a plain `bash <script>` in its own call is allowed). Another job (`header-bar`) is being
fixed in its own worktree: leave it alone.

## Rules
- Commit after each passing fix: plain `git commit -m "…"`, no author override, no `Co-Authored-By` or AI lines; check
  `git diff --cached --name-only` (never CLAUDE.md). Don't push, don't bump BUILD, don't edit CLAUDE.md, never bare
  `git stash`. Files under about 300 lines.
- You can't ask Justin anything. A real trade-off becomes "My ruling, not yet confirmed" in `rulings[]` and the ledger.
- Other bugs: `found_else` (one line each, evidence, severity); don't fix them.
- Lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line proposal for a check
  that would have caught a broken rule). An empty list is normal. Never edit skills or memory.
- Don't start other agents.

## Return (your final message)
`{name, status: ready-for-review|stopped, worktree, branch, last_commit, findings[{id, verdict: fixed|rejected|partly,
commit, test, evidence}], rulings[], ac_status[{ac, accepted, test, evidence}], paste_sha256, shots[], found_else[],
skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
