# Role: builder (Mini): footer-icon-list (website importer, a bug: a box side the site writes by two names keeps the site's winner)

You are a fresh builder for FigmaToBricksV2 (**Opus 5.5, high**). Build the approved plan test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never
push or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging
or any live site (saved captures and local fixtures only); no logins; never write to any WordPress site. Nothing paid.
Nothing may hide that the importer's Chrome is automated.

**Mini pipeline:** if the fix needs more than about 3 source files, a design decision, or touches auth, data or API
areas, stop with `status: stopped`, `stop_reason: escalate to full`.

**Skills to load:** `engineering-best-practices`, `test-driven-development`, `git-commit-rules` (the root cause is
already proved in the plan; if a test fails in a way the plan doesn't predict, load `systematic-debugging` and find
why before patching). Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` ("Code-route paste traps") and `references/rendering-validation.md`, and the repo
`CLAUDE.md` in full ("Build general logic": nothing keyed on B-Dry, a class name or a value from it; "Architecture
rules": CSS stays typed, never regex or string-match CSS; "Code Figma runs uses only the language's built-ins":
`src/core` has no `URL`, DOM or web classes).

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/plan-approved.md`
  (AC1–AC6, all proposed; AC6 live). Under this repo's standing auto-go **take every ⭐ answer (Q1 A, Q2 A, Q3 A)**
  unless the main session tells you Justin changed one. The planner's evidence, probes and prototype:
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/planner/` (`notes.md` lists every receipt;
  read only; copy what you need). The plan's code blocks were applied to a copy of main and passed: still write each
  test first and see it fail on base for the reason the plan names.
- The report in one line: since Build 2026-11-10.4 the checks draw B-Dry's footer icon list 69 px off, and the checks
  are right: the site's reset writes `margin-top: 0; padding-bottom: 0` on each row, Elementor's rule then spaces the
  rows by the logical names (`margin-block-start`, `padding-block-end`), the capture keeps both names, and the paste
  prints the physical zeros as class controls at `.<class>.brxe-<el>` (0,2,0) above the logical ones in custom CSS
  (0,1,0), so the zeros win in real Bricks.
- Your own worktree (you start in it): `git checkout -B footer-icon-list-build
  7eeca437ea100c821bcfb82cdbbe516a023ff097` (local `main`, Build 2026-11-10.4; check `git rev-parse main` and say if
  it moved: if so, use it). Your review base is that commit. Report your branch.
- Jobs moving beside you (not merged; keep your change in the functions the plan names): staging-fit-cancels edits
  `src/core/site/blocks.ts` (never `statesOf`: expect at most a context conflict at the import line later);
  site-native-structure and site-menu don't touch `blocks.ts` or `sides.ts`.
- The paste check id: write `<footer-icon-list id at merge>` in HANDOFF and the docs (never the fixed id the plan
  mentions: other jobs claim ids first).

## Work
1. Follow the plan's tasks in order, each test first (RED on base, then GREEN), one commit each. Task 0: copy the plan
   to `docs/plans/2026-11-10-footer-icon-list.md`; keep the ledger at
   `docs/plans/2026-11-10-footer-icon-list-ledger.md` (in git, committed with each task; not `.superpowers/`: `git
   ls-files .superpowers/` stays empty); `npm run corpus` before Task 1 and at the close.
2. **Think about the class of pages, not B-Dry:** the same side written by both names in other orders (logical first,
   physical later: the physical wins and stays); written at one width range only; equal values (left byte for byte);
   `margin` / `padding` shorthands beside a logical longhand, and the logical shorthands (`margin-block`,
   `padding-block`) beside physical longhands — what does the capture store for those, and does the rule read them
   right or leave them alone, said plainly; `inset-block-*` beside `top` / `bottom`; `border-block-*`; another
   `writing-mode` (left alone). Handle what the plan's rule covers, add a test for each variant you handle, and record
   what you leave (HANDOFF "Known limits", follow-ups).
3. Gates before stopping: both typechecks (`tsconfig.sandbox.json` too; `test/unit/sandbox-convert.test.ts`), `npm run
   check`, `npm run corpus` (same as base; v1's Mac files are missing on this machine), every AC's test with a log
   starting `HEAD=` and ending with one line `EXIT=` (each cited test name whole on one plan line: it is), AC4's byte
   receipt on the saved captures (base's converter beside yours: only parts holding a differing pair change),
   `test/unit/plugin-convert.test.ts`, the five Figma replays byte-identical to main, `test:web` and `test:browser`
   file by file under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export variables first; no
   `--setenv=PATH`; B-Dry files 8G) compared by name with base (five browser files fail on main on this desktop:
   composition-clipping, fonts, hero-pair, peer-sides, pill-holder; known flakes: the code-page fixture's 5.09 px
   load flake, `capture-windows` AC7, `capture-entrances` R8-1, `site-elementor-button` pixels-at-rest: rerun a flake
   alone before calling it a failure), a screenshot per AC (site | paste of the generic fixture's list at 1440 and 390
   before and after for AC2; B-Dry's footer before and after for AC1; a terminal capture for a non-visual AC).
   B-Dry's stand-in for the named test:
   `~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/inputs/standin-capture-0581852c.json` or the file
   the plan names.
4. HANDOFF: the section the plan's Task 6 describes (the plain-words fix; the 69 px proof; that Build 2026-11-09.3's
   footer claim was hidden by the old renderer's print order; known limits; the found-elsewhere `--whole` page item;
   Justin's numbered steps for the live check, one action at a time; paste check `<footer-icon-list id at merge>`),
   and the exact CLAUDE.md lines for the merge finisher (the Status line and the standing rule the plan proposes),
   written in the ledger for it to copy.
5. Commits: plain `git commit -m` (or `-F <file>` when the message holds a backslash or parentheses with colons), no
   author override, no AI or Co-Authored-By lines, `git diff --cached --name-only` without CLAUDE.md. Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/builder/`.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters and a separate one
  for each script you start at the same time (`~/.cache/fil-b/t1`, `t2`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Several agents run Chrome: close every Chrome you
  start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`: it kills the tool's own shell). A
  worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
  `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in).
  One `bash <file>` per Bash call (scripts written with Write, kept under `~/.cache/fil-b/`; a restart empties
  `/tmp`); run long gates on a scratch copy, never in the worktree while you edit it.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`) or a scope oom-kill; `compare-corpus.test.ts` needs `--test-timeout=3600000`. Waits under
  115 s.
- The PC lost power twice this week, and agents can be stopped by a usage limit: write each log's `EXIT=` line (wait
  on `^EXIT=`); after a restart check `git status` for half-written tracked files (exactly 8388608 bytes) and `git
  cat-file -t HEAD` (a commit made in the last seconds can leave empty objects: point the branch back to the last good
  commit with `git update-ref`, make the content differ, commit again); read your finished logs first and never start
  a second driver on a suite one is still working through.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, base, last commit (full SHA), per AC: test, RED/GREEN paths, screenshot; the
variants handled and left; gates vs base; deviations from the plan; `found_else`; then `skill_lessons[{skill, lesson,
evidence, enforce}]` (reusable only; empty is normal; `enforce` is `none` or a one-line check proposal; never edit
skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
