# Finisher (step 1, in a copy): stack 1 — rebase site-faq, site-reviews and site-slider onto main, one on top of the other

You are a fresh finisher (Fable 5.2, high). Three website-importer jobs are review-clean on the old `main` (`fd1986dc`).
`main` has moved to `3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1` (Build 2026-11-09.4, staging-fit-capture merged). You
rebase them into one stack so each is verified once on the head it will merge at:

    main 3cfc54ac  ←  site-faq  ←  site-reviews  ←  site-slider

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging or any live site; no
logins; never write to any WordPress site. The one network exception is site-reviews' own named-only AC8, which may
reach `cdn.trustindex.io` only, GET only. Nothing paid.

**Skills:** `git-commit-rules`, `engineering-best-practices`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Merging", the `.superpowers` line) with
`references/testing-pitfalls.md`, and the repo `CLAUDE.md` "Finish" step 1.

## Your copy (you start in your own worktree; all three branches live there)
1. `git checkout -B site-faq-stack1 a4b74bcb87213a6403e9796b4bda9367c71b7723` then `git rebase main`
   (check `git rev-parse main` = `3cfc54ac…`; if main moved again, use it and say so).
2. `git checkout -B site-reviews-stack1 6fb06ea2b1d3f451d3a3a6c51cd53915fca0b117` then
   `git rebase --onto site-faq-stack1 fd1986dcdbc8cf35f114b80be456e94279346743`.
3. `git checkout -B site-slider-stack1 a97b102c3e8325394bb9bf9d554245b13fa3d9a8` then
   `git rebase --onto site-reviews-stack1 fd1986dcdbc8cf35f114b80be456e94279346743`.

## Rules for each rebase
- Keep both sides' meaning on every conflict (HANDOFF sections all stay, newest job's section first, main's lines as main
  has them; each job's `<… id at merge>` placeholders stay). staging-fit-capture changed `src/web/capture.ts`,
  `src/web/session.ts`, `src/core/snapshot/web.ts`, `tools/site.ts`, `tools/site-check.ts`, the panel's capture reader and
  `docs/HANDOFF.md`; site-reviews changed `src/web/session.ts`, `src/web/read/embeds.ts`, `src/web/assemble.ts`,
  `tools/site*.ts`; site-slider changed `src/core/site/{convert,elementor-slider,slider-css,slider-look}.ts` and
  `test/web/lib/site-check.ts`; site-faq `src/core/site/elementor-accordion.ts` and its tests. Never drop the capture
  fix's refusal or its re-read; never drop a job's guard.
- Record every conflict and its resolution in **that job's** ledger (`docs/plans/2026-11-09-<job>-ledger.md`), committed
  on that job's branch as its last commit ("<job> stack 1: the rebase onto … and the gates"). A rebase with no conflict
  still gets that ledger commit.
- Confirm with `git range-diff` (old base..old head against new base..new head) that each job's patches are unchanged
  apart from the resolved hunks; list every commit whose patch changed.
- Commits: plain `git commit -m`, no author override, no AI or Co-Authored-By lines, `git diff --cached --name-only`
  without CLAUDE.md.

## Gates (on each new head, in order; a later head also runs the earlier jobs' AC test files)
- Both typechecks and `npm run check` (unit and performance; the parallel unit suite may need an 8G scope).
- That job's AC test files, unit and web, each file alone under the 4 GB cap with a log starting `HEAD=` and ending
  `EXIT=` (find each job's files and the named-only tests' variables in its approved plan
  `~/.hermes/plans/figma-to-bricks/evidence/<job>/plan-approved.md` and in the receipts under
  `evidence/site-faq/verifier/`, `evidence/site-reviews/fixer-2/gates/`, `evidence/site-slider/fixer-2/logs/`):
  - site-faq: its unit tests, `test/web/site-elementor-faq*.test.ts`, the named-only AC7.
  - site-reviews: `capture-embeds`, `capture-live-widget`, `capture-widget-alone`, `site-widget-codes`,
    `site-widget-places`, `site-live-widget`, `site-check-live-widget`, `capture-replay`, `human-check`, `human-reload`,
    `capture-lost`, `capture-not-the-page`, the named-only AC7 (Justin's capture against main's goldens) and AC8.
  - site-slider: `site-elementor-slider`, `site-elementor-carousels`, `site-elementor-swiper8`, `site-slider-reset`,
    `site-check-settle`, the named-only AC9 (`site-slider-bdry`).
  - staging-fit-capture's own (they must keep passing on every head): `capture-styled-ranges`, `capture-styled-loads`,
    `site-cli`, `test/unit/site-styled-ranges.test.ts`.
- **The named-only tests that read Justin's 2026-11-09 capture** (`/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`:
  site-faq AC7, site-reviews AC7, site-slider AC9): staging-fit-capture now refuses that capture in `npm run site`,
  `site:check`, `capture:check` and the panel's reader (styleless at 768–991). Run each test as it is. If the refusal
  reaches it (it fails or can't run because the capture is refused), do **not** weaken the refusal, change the test's
  meaning or point it at another file: record the exact failure, and report it per job under "needs a plan amendment".
  Everything else continues.
- The five Figma replays byte-identical to main, and `npm run corpus` printing what main prints (v1's Mac files are
  missing here), on the top head only.
- Don't run the full `test:web` / `test:browser` suites: the verifiers do. Stop a job's gates and report if anything new
  fails; still finish the rebases above it if they apply cleanly.

## Evidence
`/home/justin/.hermes/plans/figma-to-bricks/evidence/<job>/stack-1/` for each job (logs, `range-diff.txt`,
`conflicts.txt`), scripts under `~/.cache/stk1/` copied to `evidence/site-faq/stack-1/scripts/`.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/stk1/tmp`, its
  own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run
  Chrome too: close every Chrome you start. The worktree's `node_modules` may lack `.bin`: see testing-pitfalls. Run
  multi-step commands from a script file written with Write; never run gates in the worktree while you rebase in it: use
  `git archive` scratch copies of each head (with `dist/` built by `npm run check` there).
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso |
  grep sending`) or a scope oom-kill (`journalctl --user`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G
  -p MemorySwapMax=0 <cmd>` (B-Dry 8G). Waits under 115 s. After a machine restart, look for tracked files of exactly
  8388608 bytes and restore them.

## Report (as text)
Per job: branch, the new HEAD (full SHA), its new base (full SHA), conflicts and resolutions (file by file, or "none: a
pure rebase"), the commits whose patch changed, each gate's result, "needs a plan amendment" items; then `found_else`,
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
