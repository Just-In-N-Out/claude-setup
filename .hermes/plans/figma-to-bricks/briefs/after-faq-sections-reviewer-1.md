# REVIEWER 1 (report only): after-faq-sections (FigmaToBricksV2)

You are a fresh, independent code reviewer. You did not build this. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/reviewer-1/`.

## Step 0: your copy
You start in your own throwaway worktree (`isolation: worktree`, made from `main` at dea6296). The job's commits live on
branch `worktree-agent-a1582d79d2caf2309` (the builder's worktree
`/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a1582d79d2caf2309`: never write there, never run
commands there). In **your own** worktree run `git checkout --detach a95a19e` and check `git rev-parse HEAD` is
`a95a19e…`; review and run everything there. Base: `dea6296` (local `main`, build 2026-10-29.1). The diff to review:
`git diff dea6296...a95a19e`. If the checkout is refused, stop at once with the exact message.

## What to review
- Plugin source: new `src/core/understand/footer-stack.ts`, the hook in `src/core/understand/designs.ts` `designOf`,
  the optional `behind` on `src/core/understand/section.ts` `sectionIR`, a new `gapped` view for the frame's paint
  between kept parts, tests `test/unit/understand-footer-stack.test.ts`, `test/browser/footer-stack.test.ts`, fixture
  `test/fixtures/footer-stack.ts`. Check the full file list yourself.
- The B-Dry paste (part of this job, outside the repo): `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v4/`
  (`home-paste-v4.json` = v3 + four sections after the FAQ `kdfxfl`; `after-faq-sections.json`, 31 elements, what
  Justin pastes on /homev2/; `build-v4.ts`, tests, checks, shots). v3 is
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v3/home-paste-v3.json`. Copies were put in
  `C:\Users\Admin\Downloads\`.
- Approved plan (read-only): `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/plan-approved.md` (ACs
  AC1–AC12; AC12 is Justin's live paste check 3bt). The builder's evidence:
  `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/builder/`; ledger
  `.superpowers/sdd/2026-10-29-after-faq-sections/progress.md` in the branch; the HANDOFF section.
- What Justin asked: after the FAQ, bdryswi.com shows three sections our Home lacks ("Schedule A Consultation" band,
  "Contact us today to get started" with 5 steps, "Customer Reviews" with a reviews carousel); they must come across
  "with the animations and everything". They live in bdryswi.com's Elementor footer template, so no paste ever had
  them. Approved answers (standing auto-go, every ⭐): Q1 A (the plugin keeps page parts drawn inside a footer frame,
  in this job), Q2 A (Home only, under the FAQ, plus a small paste of just them), Q3 A (the same Trustindex widget in
  one Code element), Q4 A (the quote button turns orange under the pointer, as on bdryswi.com).
- **AC7 is red on two sub-checks; Justin is being asked about it. Judge the builder's diagnosis independently:**
  (1) at 1024 "FAQ's last question → band" is 10px vs the real page's 534px, which the builder blames on v3's FAQ
  stacking its mascot at 991 (Bricks) instead of 1024 (Elementor), a v3 part AC6 freezes; (2) at 767/390 step card 3's
  title is on 1 line vs the real page's 2, which it blames on the real page's Roboto 600 face failing to load (fallback
  metrics; `builder/real-site/source-font-767.json`). Are both causes real and outside the new sections? Is anything
  else in AC7 being hidden by them?
- Builder's rulings to judge (not yet confirmed): R6 the paste uses Roboto 600 as bdryswi.com asks; R7 only a footer
  `siteFooter` returns as exactly one section is split (a wordless strip drawn as its own section under the frame keeps
  today's behaviour); R8 the frame's space above a self-painted kept part keeps the frame's paint; wordless parts going
  with the footer leave as one section; the quote button's resting colours live in the `home-quote` class.

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`), `engineering-best-practices`, `requesting-code-review` (its security scan and quality
gates; skip its "independent reviewer subagent" and auto-fix steps: you ARE the fresh reviewer, and you can't spawn
agents), `code-review-practice`, and `mutation-testing-discipline` for the footer-stack guards (exactly one stacked
frame found as the footer, never looking through a wrapper, full-width stacked parts, wordless parts going with the
footer, the note). Read only the CLAUDE.md sections you need (grep + offset/limit).

## What to check
- Correctness against the plan and every AC (AC1–AC11): does each test prove its AC, fail on base where it should, and
  test the general case? Are the mutation receipts (M1–M10, M4) honest?
- "Build general logic, never one-file fixes": nothing keyed on B-Dry's words, colours or sizes. Footers that reach
  the new code: a footer of columns and © only, a wave above the footer, a form in the footer, a footer wrapped in a
  div (All Type), a separate © bar, a background rectangle, a drawn phone pair, the footer and header ticks on and off,
  GRO's free-drawn footer. Is anything that IS the footer now kept on the page, or anything lost?
- The CLAUDE.md architecture rules: no stage edits an earlier stage's output, only `adapt/rules/` writes breakpoint
  styles, typed CSS until emit, deterministic ids, files under ~300 lines, Figma-sandbox-safe code in src/core.
- The B-Dry paste: v3's elements and classes byte-identical; payload checks clean; no class name clashing with the
  site's (memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/bdry-home-copy.md`); custom
  CSS naming only its own element; the Code element's script exactly the source's Trustindex line; links right;
  reduced motion respected; no sideways scroll down to 320; Justin's paste steps correct and plain.
- Bricks facts: `_alignSelf: stretch` never written; layout keys only on layout elements; native elements only from
  samples in `reference/bricks/`; pasted code needs Regenerate code signatures.
- Machine: Linux/WSL. Chrome: your own wrapper script in your scratch containing
  `exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"` as `CHROME_PATH`, with
  `/home/justin/.local/node-v22.23.3/bin` first on PATH. `npm run corpus` measures nothing here; corpus-backed unit tests
  need scratch `git archive` trees with `corpus.json` re-pointed (memory note
  `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`). Real files:
  `corpus/files/hydraulics-home.json`, `corpus/files/gro-home.json`, repo-root `figma-to-bricks-debug-page-1.json`,
  `figma-to-bricks-debug-design-inspo-brainstorm.json`, Services (`git show 2199895:figma-to-bricks-debug-page-1.json`
  into your evidence folder). Another job (`header-bar`) is being fixed in its own worktree: leave it alone.
- Worktree guard: Bash is refused when it can't be proven to stay in your worktree (shell variables or loops around
  `node`/`git`/`sed`, heredoc then node, `git -C`, the word git inside a grep pattern or a script's text, the word
  `source` anywhere, even in a path). Write scripts with Write and run `node <absolute script> <absolute args>`, one
  plain command per call (a plain `bash <script>` in its own call is allowed).

## Report
Return `{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity: critical|high|medium|low, file,
line, claim, evidence, suggested_fix}], ac_status[{ac, accepted, test, evidence}], ac7_diagnosis, rulings_assessment[],
found_else[], skill_lessons[{skill, lesson, evidence, enforce}]}`. `enforce` is `none` or a one-line proposal for a
check that would have caught a broken rule. Never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
