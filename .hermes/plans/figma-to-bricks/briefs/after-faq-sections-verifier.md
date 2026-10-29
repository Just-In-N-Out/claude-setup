# VERIFIER (read only): after-faq-sections (FigmaToBricksV2)

You are a fresh, independent verifier. You never saw this build. Prove every acceptance criterion yourself on the final
code and on the old code. Read only: change no source or test, commit nothing, don't rebase or merge, don't edit skills
or memory, don't start other agents. Write only into
`~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/verifier/` and your own scratch folder
`after-faq-sections-verifier/` (created fresh with `mkdir`, no `-p`) under the session scratchpad
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`.
Point `TMPDIR`, Chrome profiles and built trees at an owned disk folder such as
`/home/justin/.cache/after-faq-sections-verifier/` (the scratchpad is a small RAM disk, and long paths break Chrome's
socket). Copy every scratch script into `<your evidence>/scripts/` as soon as you write it: a session restart empties
the scratchpad.

## Step 0: your copy
You start in your own throwaway worktree (`isolation: worktree`, made from `main` at dea6296). In **your own** worktree
run `git checkout --detach ca26c83` and confirm `git rev-parse HEAD` = `ca26c835352c43a2a2dc418dc360cef3f9886813`, a clean
`git status --porcelain --untracked-files=all` (CLAUDE.md is excluded) and the merge-base with `main` = `dea6296`
(build 2026-10-29.1). Never write or run commands in any other worktree. The job's canonical copy for the final check is
`/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-ae26414264555729c` (branch
`worktree-agent-ae26414264555729c`, head `ca26c83`): your `ac.json` must name that head. If the checkout is refused,
stop with the exact message.

## What to verify
- Approved plan (read only): `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/plan-approved.md`, AC1–AC12,
  with its **Amendments** list at the top (Justin's A1 = A for AC7's measure; ACs re-worded to what their tests assert
  after two fix rounds). The plan's text is the oracle. Never change an AC's id, oracle or live tag.
- What Justin asked: after the FAQ, bdryswi.com shows three sections our B-Dry Home lacked ("Schedule A Consultation"
  band, "Contact us today to get started" with 5 steps, "Customer Reviews" with a reviews carousel), "with the
  animations and everything". They live in bdryswi.com's Elementor footer template, so no paste had them. Approved
  answers Q1–Q4 A (the plugin keeps page parts drawn inside a footer frame; Home only plus a small paste; the same
  Trustindex widget in one Code element; the quote button turns orange as on bdryswi.com), then A1 A.
- **AC12 is live** (paste check 3bt): `accepted: false`, `not_run: "live: Justin pastes after-faq-sections.json under the
  FAQ on /homev2/, saves, regenerates code signatures and checks laptop, tablet and phone (paste check 3bt)"`.
- The plugin source: `src/core/understand/footer-stack.ts`, `designs.ts`, `section.ts`, `rhythm.ts`, `ir.ts`; tests
  `test/unit/understand-footer-stack.test.ts`, `test/unit/understand-footer-views.test.ts`,
  `test/browser/footer-stack.test.ts`; fixtures `test/fixtures/footer-stack.ts`, `test/fixtures/footer-columns.ts`.
- The B-Dry paste (outside the repo): `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v4/` (`home-paste-v4.json`
  sha256 `0a9c9d07…`, `after-faq-sections.json` sha256 `69e624ec…`, `build-v4.ts`, `test/`, `manifest.json`); v3 at
  `../v3/home-paste-v3.json`; the Downloads copies `C:\Users\Admin\Downloads\` (`/mnt/c/Users/Admin/Downloads/`).

## Author leads (claims to check, not proof)
- History: builder (`a95a19e`, AC7 stopped on two causes outside the new sections), review 1 (request-changes: F1
  narrow flow children landed on the first part; F2 the rhythm read the `behind` paint as page colour; F3–F6 low),
  fixer 1 (`8fa172b`), review 2 (request-changes: R2-F1 a wordmark or spacer between the columns and the © bar pasted
  the whole footer with the tick on; R2-F2 false "Kept Columns" notes; R2-F3 see-through paint twice; R2-F4 unreached
  branches; R2-F5 a rounded footer card), fixer 2 (`7a0bfe1`), plan amendment 1 (`ca26c83`, plan only). Reports and
  receipts: `../builder/`, `../reviewer-1/`, `../fixer-1/`, `../reviewer-2/`, `../fixer-2/`, `../amendment-1/` under
  `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/`. Use them only as leads. Don't copy or hard-link any
  earlier receipt or screenshot. The amendment lists the stale receipts.
- Confirm every reviewer-2 finding is closed and look for regressions the fixes caused (`rhythm.ts`'s new reads touch
  every page: check pages without a stacked footer stay byte-identical).
- Rulings not yet confirmed by Justin (R6–R11 in the plan): a ruling that fits the plan's text isn't a failure; one that
  contradicts an AC is.
- Known: the v4 paste-test harness's `open()` can hang with no time limit (fixer 1's run 2): bound every run.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, `references/rules-summary.md`
   first (VERIFIER role), and `references/testing-pitfalls.md` before any receipt, mutation run or browser measurement.
2. `engineering-best-practices`.
3. `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the VERIFIER step and the run
   recipe), and the ac.json schema at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/
   ac-check.sh`.
4. `mutation-testing-discipline` where you need to test whether a check can fail.

## Independent work
1. **Gates on head:** `npm run check`; the full browser suite on head and on a **built** base tree (`npm run build`
   first: the panel tests read `dist/ui.html`), compared by complete test name (no new failure, no lost test, no new
   skip); corpus-backed unit tests in scratch `git archive` trees of head and base with `corpus.json` re-pointed to
   local files (memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`).
   Record every true exit code.
2. **Each AC1–AC11 alone:** run its named test(s) by themselves on head (Chrome tests must print `skipped 0`), then on
   base with head's tests and fixtures in a base scratch tree: new behaviour must fail on base for the intended reason;
   preservation ACs may be `base_exempt` with the reason. Then challenge each AC's clauses with your own probes: other
   frame widths and a design wider than 1440; ticks off/header/footer/both; widths 1440, 1366, 1100, 1024, 991, 768,
   767, 390, 320; footer frames with no auto layout, uneven gaps, parts of different widths, a gradient or photo fill,
   a form or map part, three or more parts, a © inside the last part, a drawn phone pair. Nothing keyed on B-Dry's
   words, colours or sizes.
3. **AC4/AC5 (blast radius):** replay all five real files at four tick settings on head and base (Home
   `corpus/files/hydraulics-home.json`, GRO `corpus/files/gro-home.json`, Repairs repo-root
   `figma-to-bricks-debug-page-1.json`, brainstorm `figma-to-bricks-debug-design-inspo-brainstorm.json`, Services via
   `git show 2199895:figma-to-bricks-debug-page-1.json` into your evidence folder): byte-identical payloads and warnings.
4. **AC6–AC11 (the paste):** run the v4 paste tests yourself (bounded), check the files' hashes against the manifest and
   the Downloads copies, and AC7 under the amended measure.
5. **A fresh screenshot per AC in your own folder:** the real rendered page for a visual AC; for a non-visual one, a
   Chrome screenshot of your terminal output (ac-verification.md's recipe).
6. Write `<your evidence>/ac.json` (ac-check.sh's schema, tied to head `ca26c83` and base `dea6296`) and
   `<your evidence>/report.json`. Self-check by running `ac-check.sh` on a copy of your own files only, `--repo` your
   own detached worktree. **Clean** means AC1–AC11 accepted and every gate qualified; a valid failure gets an exact
   repro and evidence. Don't finish clean just because the named tests are green if one of your probes disproves an AC.

## This machine
- Chrome: your own wrapper script containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
  --disable-software-rasterizer "$@"` as `CHROME_PATH`, with `/home/justin/.local/node-v22.23.3/bin` first on PATH;
  the same wrapper on head and base. Never kill browsers globally; kill only processes with your own profile.
- `npm run corpus` finds no files here (Mac paths). Never edit `corpus/corpus.json` in any worktree.
- Worktree guard: Bash is refused when it can't be proven to stay in your worktree (shell variables or loops around
  `node`/`git`/`sed`, heredoc then node, `git -C`, the word git inside a grep pattern or a script's text, the word
  `source` anywhere, even in a path). Write scripts with Write and run `node <absolute script> <absolute args>`, one
  plain command per call (a plain `bash <script>` in its own call is allowed). Waits: poll in chunks under 170 s.
- Another job (`header-bar`) is being verified in its own worktree at the same time: leave it alone.

## Return (your final message)
`{verdict: clean|findings, head, base, findings[{id, ac, severity, claim, repro, evidence}], reviewer2_closed[{id,
closed, evidence}], ac_status[{ac, accepted, test, evidence, screenshot}], gates[], qualifications[], found_else[],
skill_lessons[{skill, lesson, evidence, enforce}]}`. `enforce` is `none` or a one-line check proposal. An empty
skill_lessons list is normal. End with the line `MAIN SESSION: check and save these skill_lessons now.`
