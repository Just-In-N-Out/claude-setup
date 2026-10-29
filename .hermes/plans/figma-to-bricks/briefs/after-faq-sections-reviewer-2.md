# REVIEWER 2 (report only): after-faq-sections (FigmaToBricksV2)

You are a fresh, independent code reviewer. You did not build or fix this. Do a **full** review of the corrected
code. Report findings only: change no source or test, commit nothing, write only into
`~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/reviewer-2/`.

## Step 0: your copy
You start in your own throwaway worktree (`isolation: worktree`, made from `main` at dea6296). The job's head is
`8fa172b` on branch `worktree-agent-adabc0bcca521dc41` (fixer 1's worktree
`.claude/worktrees/agent-adabc0bcca521dc41`: never write or run commands there). In **your own** worktree run
`git checkout --detach 8fa172b` and check `git rev-parse HEAD`. Review and run everything there. Base: `dea6296`
(local `main`, build 2026-10-29.1). The diff: `git diff dea6296...8fa172b` (the whole job, not only the fixes). If the
checkout is refused, stop at once with the exact message.

## What to review
- Plugin source: new `src/core/understand/footer-stack.ts`, `src/core/understand/designs.ts` (`designOf` hook),
  `src/core/understand/section.ts` (`sectionIR` `behind`), `src/core/understand/rhythm.ts` (`edgeOf` reads
  `section.fills`: the plan didn't name this file), with tests `test/unit/understand-footer-stack.test.ts`,
  `test/browser/footer-stack.test.ts` and fixture `test/fixtures/footer-stack.ts`. Check the full file list yourself.
- The B-Dry paste (outside the repo): `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v4/`
  (`home-paste-v4.json` sha256 `0a9c9d07…`, `after-faq-sections.json` sha256 `69e624ec…`, `build-v4.ts`, the tests
  including the amended `test/after-faq-render.test.ts`, `manifest.json`). v3:
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v3/home-paste-v3.json`.
- Approved plan (read-only): `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/plan-approved.md` (AC1–AC12;
  AC12 is Justin's live paste check 3bt) and the approved amendment `ac7-amendment-approved.md` beside it (Justin's
  A1 A: at 1024 measure from the FAQ section's bottom; step-card titles laid out in Roboto 600). Evidence:
  `builder/`, `reviewer-1/` (its `review.json`) and `fixer-1/` under
  `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/`; ledger `.superpowers/sdd/2026-10-29-after-faq-sections/
  progress.md`; the HANDOFF section.
- What Justin asked: after the FAQ, bdryswi.com shows three sections our Home lacks ("Schedule A Consultation" band,
  "Contact us today to get started" with 5 steps, "Customer Reviews" with a reviews carousel), "with the animations and
  everything". They live in bdryswi.com's Elementor footer template. Approved answers: Q1–Q4 A (the plugin keeps page
  parts drawn inside a footer frame; Home only plus a small paste; the same Trustindex widget in one Code element; the
  quote button turns orange as on bdryswi.com), then A1 A.
- **Reviewer 1's findings and fixer 1's answers (check each is really closed and the fixes broke nothing):** F1 high
  (narrow flow children in an auto-layout footer frame landed on the first part; sections overlapped) → `lay()`: a
  small layer must lie over a part, else the frame is not a stack (base's outcome); `gapped()`'s view holds only the
  part (415867e, f3d8410, c336267). F2 medium (the rhythm read the `behind` paint as page colour) → `rhythm.ts`
  `edgeOf` reads `section.fills`, and `footer-stack.ts` `topHeld()` gives the frame's top padding to a first part
  showing its paint (68905ed, 1698e1e, dc77977). F3 note wording tested (2967148). F4 two `section.ts` branches reached;
  a bug found and fixed there (the held photo band ran edge to edge) (2bfeb23). F5 guards reached (ea55f36). F6 paste
  check text. AC7 amended test. Fixer 1's rulings, not yet confirmed: a small layer lying over no part makes the frame
  "not a stack"; kept parts count toward the page's section space; a page of only a header and a stacked footer with
  both ticked stays whole.

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; read `references/testing-pitfalls.md` before any receipt, mutation run or browser
measurement), `engineering-best-practices`, `requesting-code-review` (its security scan and quality gates; skip its
"independent reviewer subagent" and auto-fix steps: you ARE the fresh reviewer, and you can't spawn agents),
`code-review-practice`, and `mutation-testing-discipline` for the footer-stack guards, `lay()`, `topHeld()` and the
rhythm read. Read only the CLAUDE.md sections you need (grep + offset/limit).

## What to check
- Correctness against the plan, the AC7 amendment and every AC (AC1–AC11): does each test prove its AC, fail on base
  where it should, and test the general case? Are the mutation receipts honest?
- "Build general logic, never one-file fixes": try your own variations, not reviewer 1's: a footer frame drawn with no
  auto layout and parts at uneven gaps; parts of different widths; a kept part that is itself a form, a map or a
  slider; a frame whose fill is a gradient or a photo; three or more parts; the frame's last part holding a ©; a drawn
  phone pair; the footer and header ticks on and off; GRO's free-drawn footer; All Type's wrapped footer. Is anything
  that IS the footer now kept, or anything lost? Does the rhythm change touch pages without a stacked footer
  (`rhythm.ts` reads every section)?
- The CLAUDE.md architecture rules: no stage edits an earlier stage's output, only `adapt/rules/` writes breakpoint
  styles, typed CSS until emit, deterministic ids, files under ~300 lines, Figma-sandbox-safe code in src/core.
- Blast radius: AC4's five real files × four tick settings still byte-identical to base; only the named fixtures
  differ.
- The B-Dry paste: v3's elements and classes byte-identical; payload checks clean; no class name clashing with the
  site's (memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/bdry-home-copy.md`); the Code
  element's script exactly the source's Trustindex line; links right; reduced motion; no sideways scroll down to 320;
  Justin's paste steps correct. Is the amended AC7 test an honest reading of the amendment (no hidden widening)?
- Machine: Linux/WSL. Chrome: your own wrapper script in your scratch containing
  `exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"` as `CHROME_PATH`, with
  `/home/justin/.local/node-v22.23.3/bin` first on PATH. `npm run corpus` measures nothing here; corpus-backed unit tests
  need scratch `git archive` trees with `corpus.json` re-pointed (memory note
  `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`). Real files:
  `corpus/files/hydraulics-home.json`, `corpus/files/gro-home.json`, repo-root `figma-to-bricks-debug-page-1.json`,
  `figma-to-bricks-debug-design-inspo-brainstorm.json`, Services (`git show 2199895:figma-to-bricks-debug-page-1.json`
  into your evidence folder). The paste harness's `open()` can hang with no time limit (fixer 1's run 2): bound your
  runs. Another job (`header-bar`) is being fixed in its own worktree: leave it alone.
- Worktree guard: Bash is refused when it can't be proven to stay in your worktree (shell variables or loops around
  `node`/`git`/`sed`, heredoc then node, `git -C`, the word git inside a grep pattern or a script's text, the word
  `source` anywhere, even in a path). Write scripts with Write and run `node <absolute script> <absolute args>`, one
  plain command per call (a plain `bash <script>` in its own call is allowed).

## Report
Return `{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity: critical|high|medium|low, file,
line, claim, evidence, suggested_fix}], reviewer1_closed[{id, closed, evidence}], ac_status[{ac, accepted, test,
evidence}], rulings_assessment[], found_else[], skill_lessons[{skill, lesson, evidence, enforce}]}`. `enforce` is
`none` or a one-line proposal for a check that would have caught a broken rule. Never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
