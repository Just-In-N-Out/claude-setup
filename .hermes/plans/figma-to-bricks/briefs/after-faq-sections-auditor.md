# AC AUDITOR (blind, read only): after-faq-sections (FigmaToBricksV2)

You are a fresh, blind AC auditor. You get only the approved plan, the code, the head, the base and your own folder.
Never read any other folder under `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/` (no verifier, reviewer,
fixer, builder or planner folders, reports or receipts) and no brief in `~/.hermes/plans/figma-to-bricks/briefs/` but
this one. Prove every AC yourself from the plan's text. Read only: change no source or test, commit nothing, don't edit
skills or memory, don't start other agents.

## Inputs
- **Approved plan (the oracle):** `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/plan-approved.md` (AC1–AC12;
  AC12 is `(live)`; read its Amendments list at the top too). Never change an AC's id, oracle or live tag.
- **Head:** `ca26c835352c43a2a2dc418dc360cef3f9886813`. **Base:** `dea6296a7a4536d986cd47faf49aa7adff3abf81` (local
  `main`, build 2026-10-29.1).
- **Your copy:** you start in your own throwaway worktree (`isolation: worktree`, made from `main` at dea6296). In it run
  `git checkout --detach ca26c83` and confirm `git rev-parse HEAD`, a clean `git status --porcelain
  --untracked-files=all` and `git merge-base HEAD main` = dea6296. Never write or run commands in another worktree.
- The files the plan names outside the repo (the B-Dry paste folder `~/.hermes/plans/figma-to-bricks/evidence/
  bdry-paste/v4/`, v3 beside it, the source capture `~/.hermes/plans/figma-to-bricks/evidence/bdry-source/`) are
  inputs you may read and run, as the plan's ACs name them.
- **Your folder:** `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/auditor/` (write only there) and scratch
  `after-faq-sections-auditor/` (created fresh with `mkdir`, no `-p`) under
  `/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`.
  Point `TMPDIR`, Chrome profiles and built trees at `/home/justin/.cache/after-faq-sections-auditor/`. Copy every
  scratch script into `<your folder>/scripts/` as soon as you write it.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
   `references/rules-summary.md` (auditor role), and `references/testing-pitfalls.md` before any receipt or browser
   measurement.
2. `engineering-best-practices`.
3. `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the run recipe and the AC
   AUDITOR step) and the ac.json schema at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/
   ac-check.sh`.

## The work
For each AC1–AC11: run its named test(s) by themselves on head (Chrome tests must print `skipped 0`), then on base with
head's tests and fixtures in a base `git archive` scratch tree (`npm run build` there first for any test that reads
`dist/`): new behaviour must fail on base for the intended reason; a preservation AC may be `base_exempt` with the
reason. Where a clause isn't exercised by the named test, check it yourself with your own probe or mutant (in your own
scratch copies only). Take your own screenshot per AC (the real rendered page for a visual AC; a Chrome screenshot of
your terminal output otherwise). AC12: `accepted: false`, `not_run: "live: Justin pastes after-faq-sections.json under
the FAQ on /homev2/ and checks it (paste check 3bt)"`. Bound every paste-test run (a harness `open()` can hang).

Write `<your folder>/ac.json` (ac-check.sh's schema, tied to head ca26c83 and base dea6296) and `report.json`.
Self-check by running `ac-check.sh` on a copy of your own files only, `--repo` your own detached worktree.

## This machine
- Chrome: your own wrapper script containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
  --disable-software-rasterizer "$@"` as `CHROME_PATH`, with `/home/justin/.local/node-v22.23.3/bin` first on PATH.
  Never kill browsers globally.
- `npm run corpus` finds no files here (Mac paths); corpus-backed unit tests need scratch trees with `corpus.json`
  re-pointed to local files (memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/
  corpus-paths-on-desktop.md`). Real files: `corpus/files/hydraulics-home.json`, `corpus/files/gro-home.json`,
  repo-root `figma-to-bricks-debug-page-1.json`, `figma-to-bricks-debug-design-inspo-brainstorm.json`, Services via
  `git show 2199895:figma-to-bricks-debug-page-1.json` into your folder.
- Worktree guard: Bash is refused when it can't be proven to stay in your worktree (shell variables or loops around
  `node`/`git`/`sed`, heredoc then node, `git -C`, the word git inside a grep pattern or a script's text, the word
  `source` anywhere, even in a path). Write scripts with Write and run `node <absolute script> <absolute args>`, one
  plain command per call (a plain `bash <script>` in its own call is allowed). Waits: poll in chunks under 170 s.

## Return (your final message)
`{verdict: clean|findings, head, base, ac_status[{ac, accepted, test, evidence, screenshot}], findings[{ac, claim,
repro, evidence}], found_else[], skill_lessons[{skill, lesson, evidence, enforce}]}`. An empty skill_lessons list is
normal. End with the line `MAIN SESSION: check and save these skill_lessons now.`
