# VERIFIER (read only): header-bar (FigmaToBricksV2)

You are a fresh, independent verifier. You never saw this build. Prove every acceptance criterion yourself on the final
code and on the old code. Read only: change no source or test, commit nothing, don't rebase or merge, don't edit skills
or memory, don't start other agents. Write only into `~/.hermes/plans/figma-to-bricks/evidence/header-bar/verifier/`
and your own scratch folder `header-bar-verifier/` (created fresh with `mkdir`, no `-p`) under the session scratchpad
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`.
Point `TMPDIR`, Chrome profiles and built trees at an owned disk folder such as
`/home/justin/.cache/header-bar-verifier/` (the scratchpad is a small RAM disk, and long paths break Chrome's socket).
Copy every scratch script into `<your evidence>/scripts/` as soon as you write it: a session restart empties the
scratchpad.

## What to verify
- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar`, branch `worktree-header-bar`, head
  **`11dfd5e`** (source and tests as of `44d87b3`; `5ad18c1` adds records, `11dfd5e` the plan amendment). Base =
  merge-base with `main` = **`dea6296`** (build 2026-10-29.1). Confirm the head, the merge-base and a clean
  `git status --porcelain --untracked-files=all` before you start, and report any difference.
- Approved plan (read only): `~/.hermes/plans/figma-to-bricks/evidence/header-bar/plan-approved.md`: AC1–AC13, AC15,
  AC16 (AC14 was moved to the later `header-menu` job by Justin, "Ship now, menu later"; see the plan's Amendments list
  and its "Deferred to the header-menu job" section: don't verify the menu). The Amendments list also records H1 = A (a
  design drawn wider than 1440 keeps its header inside the 1440 Container) and the AC lines reworded to what the tests
  assert after two fix rounds. The plan's text is the oracle. Never change an AC's id, oracle or live tag.
- What Justin asked: the B-Dry staging site's top bar should look and work like bdryswi.com's (slim, gradient, logo at
  the left edge, button and ☰ at the right edge); the logo goes home, the phone number calls, the ☰ opens a menu (now
  deferred). No debug file: the staging header was found to be the site's own hand-built template (an inference).
  Approved answers Q1–Q7 A, H1 A, then the deferral.
- **AC16 is live** (paste check 3bs): `accepted: false`, `not_run: "live: Justin pastes header-paste.json into the
  site's Header template, sets the front page and checks the bar on staging and his iPhone (paste check 3bs)"`.
- The B-Dry header paste (outside the repo): `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/header-v1/`
  (`header-paste.json` sha256 `f48783e50da30d89d963d60e57b372d3cfb31f3e416c9927e5b0b8cbf96bba3e`, `manifest.json`,
  `scripts/`, `test/`, `oracle-derived/`).

## Author leads (claims to check, not proof)
- History: builder (`eb23695`), review 1 (request-changes: F1 non-header bars taken as the header; F2 the menu-icon note
  named a linked button's arrow on the real files; F3 the first layer taken as the logo; F4 untested guards; F5 the
  B-Dry phone line not centred at 768–1024), fixer 1 (`e630f4d`, plus H1 A), review 2 (request-changes: F1 a regression,
  a small-logo header handing itself over to a band; F2 a badge strip leaving two headers; F3 title rows ending in an
  arrow; F4 small logos, a gap; F5 the note naming a cart; F6 H1 only browser-tested), fixer 2 (`44d87b3`, records
  `5ad18c1`; F4 a follow-up, F5 partly: a lone icon with no drawing to read is still named), amendment 1 (`11dfd5e`).
  Reports and receipts: `builder/`, `reviewer-1/`, `fixer-1/`, `reviewer-2/`, `fixer-2/`, `amendment-1/` under
  `~/.hermes/plans/figma-to-bricks/evidence/header-bar/`. Use them only as leads. Don't copy or hard-link any earlier
  receipt or screenshot. The amendment lists the stale receipts (the current pinned receipts script is
  `fixer-2/receipts.test.ts`: make your own run of it, don't reuse its output).
- Confirm every reviewer-2 finding is closed (or is the named follow-up), and look for regressions the fixes caused.
- Rulings not yet confirmed by Justin (in the plan and HANDOFF): a ruling that fits the plan's text isn't a failure;
  one that contradicts an AC is.
- Known records lag (not your failure to fix; report it): HANDOFF's header-bar section and the ledger still say the menu
  "waits for the sample"; the finisher will reword them as "deferred to header-menu by Justin".

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
2. **Each AC1–AC13 and AC15 alone:** run its named test(s) by themselves on head (Chrome tests must print `skipped 0`),
   then on base with head's tests and fixtures in a base scratch tree: new behaviour must fail on base for the intended
   reason; guards may be `base_exempt` with the reason. Then challenge each AC's clauses with your own probes: header
   bars with and without a logo, phone line, button or ☰; logos typed or drawn, small marks, badges; a contact strip
   over a real bar; a title band or call band first; a shop header; bars drawn without auto layout (GRO); drawn phone
   designs; designs 1280, 1440, 1728 and 1920 wide; ticks off/header/footer/both; widths 1920, 1440, 1366, 1024, 991,
   768, 767, 390, 320. Nothing keyed on B-Dry's words, colours or sizes.
3. **AC7/AC8 (blast radius):** replay all five real files at four tick settings on head and base (Home
   `corpus/files/hydraulics-home.json`, GRO `corpus/files/gro-home.json`, Repairs repo-root
   `figma-to-bricks-debug-page-1.json`, brainstorm `figma-to-bricks-debug-design-inspo-brainstorm.json`, Services via
   `git show 2199895:figma-to-bricks-debug-page-1.json` into your evidence folder): only the plan's named differences
   (the logo's home link; no false menu-icon note on any real file).
4. **AC9–AC13, AC15 (the paste):** run the header paste tests yourself, check the file's hash against the manifest and
   that the plugin inputs rebuilt on head match the manifest's.
5. **A fresh screenshot per AC in your own folder:** the real rendered page for a visual AC; for a non-visual one, a
   Chrome screenshot of your terminal output (ac-verification.md's recipe).
6. Write `<your evidence>/ac.json` (ac-check.sh's schema, tied to head `11dfd5e` and base `dea6296`) and
   `<your evidence>/report.json`. Self-check by running `ac-check.sh` on a copy of your own files only. **Clean** means
   AC1–AC13 and AC15 accepted and every gate qualified; a valid failure gets an exact repro and evidence. Don't finish
   clean just because the named tests are green if one of your probes disproves an AC.

## This machine
- Chrome: your own wrapper script containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
  --disable-software-rasterizer "$@"` as `CHROME_PATH`, with `/home/justin/.local/node-v22.23.3/bin` first on PATH;
  the same wrapper on head and base. Never kill browsers globally; kill only processes with your own profile.
- `npm run corpus` finds no files here (Mac paths). Never edit `corpus/corpus.json`.
- Worktree guard: Bash is refused when it can't be proven to stay in the worktree (shell variables or loops around
  `node`/`git`/`sed`, heredoc then node, `git -C`, the word git inside a grep pattern or a script's text, the word
  `source` anywhere, even in a path). Write scripts with Write and run `node <absolute script> <absolute args>`, one
  plain command per call (a plain `bash <script>` in its own call is allowed). Waits: poll in chunks under 170 s.
- Another job (`after-faq-sections`) is being verified in its own worktree at the same time: leave it alone.

## Return (your final message)
`{verdict: clean|findings, head, base, findings[{id, ac, severity, claim, repro, evidence}], reviewer2_closed[{id,
closed, evidence}], ac_status[{ac, accepted, test, evidence, screenshot}], gates[], qualifications[], found_else[],
skill_lessons[{skill, lesson, evidence, enforce}]}`. `enforce` is `none` or a one-line check proposal. An empty
skill_lessons list is normal. End with the line `MAIN SESSION: check and save these skill_lessons now.`
