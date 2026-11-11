# Role: builder (Mini): capture-refused-styles (website importer, a bug: a site whose check comes back partway through a scan refuses its stylesheets, and nothing is captured)

You are a fresh builder for FigmaToBricksV2 (**Opus 5.5, xhigh**). Build the approved plan test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never
push or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. **Never load bdryswi.com** (no Chrome,
no curl, no fetch: Justin's rule is "never without me"), B-Dry staging or any live site: the capture runs only against
local fixture servers. No logins; never write to any WordPress site; never run `npm run site:upload` or `site:import`
against anything. Nothing paid. **Nothing may hide that the importer's Chrome is automated** (CLAUDE.md: no
`AutomationControlled` flag, no `navigator.webdriver` patch, no new user agent, no stealth script, nothing that clicks
or types into a site's check): the fix passes a site's check only by letting the person at the visible window pass
it again; it never disguises, never answers a check itself, never reuses refused bytes (the plan's Q2 B).

**Mini pipeline:** if the fix needs a design decision beyond the plan's Q1–Q5, or grows well past the plan's size
(about 10 lines of rule, a recorder of about 90, about 30 for the line and words, a fixture and tests), stop with
`status: stopped`, `stop_reason: escalate to full`.

**Skills to load:** `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` (the guard:
"a retry after a refusal asks the site for the page itself"; "a capture read without the site's styles is never
saved as clean"), `git-commit-rules` (the root cause is proved in the plan; if a test fails in a way the plan doesn't
predict, load `systematic-debugging` and find why before patching). Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` ("Access", "Writing readers", "Holding a Chrome to read-only"), and the repo
`CLAUDE.md` in full ("Build general logic": a general rule for every scanned site, nothing keyed on bdryswi.com,
WordPress.com or any host; "The importer never hides that its Chrome is automated").

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/plan-approved.md`
  (AC1–AC9, all proposed; AC9 is `(live)`, Justin's own scan: never yours). Under this repo's standing auto-go **take
  every ⭐ answer (Q1 A, Q2 B, Q3 A, Q4 B, Q5 B)** unless the main session tells you Justin changed one; mark them
  "not yet confirmed" in HANDOFF. The planner's evidence, probes, prototype and test code:
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/planner/` (`notes.md` is the index;
  `pfull-src.diff`, `pfull-tools.diff`, `plan-code/`; read only; copy what you need). The prototype passed on copies:
  still write each test first and see it fail on your base for the reason the plan names.
- The report in one line: since capture-speed, a public site's later page loads (and the retries of a range that lost
  a stylesheet) are answered with the page the capture kept for that kind of visitor, never by the site; so once a
  site's check runs out partway through a scan, no page load can meet it again and every retry of the stylesheet gets
  403: Justin's two real runs on 2026-11-10 ended "The page loads for widths … never got the site's stylesheet
  https://bdryswi.com/_jb_static/ (answered 403) in 3 tries … Press Capture to try again." (the last sentence is the
  Figma panel's wording, printed in the terminal).
- **A finding from another job to fold in or record:** site-one-command's builder saw that a styled site whose
  stylesheet never arrives on **any** load (refused from the first load on) is captured "clean". Check it on your
  fixture; if the plan's rule doesn't already stop it, say so in `found_else` with a probe (don't widen the plan on
  your own: it may need the planner).
- **Your base:** local `main` `11e885fda5d08863a5875f939085350c007ac732` (Build 2026-11-10.8). In your own worktree:
  `git checkout -B capture-refused-styles-build 11e885fda5d08863a5875f939085350c007ac732`. Report your branch. If the
  main session tells you main moved, say so and wait for word on rebasing.
- Jobs moving beside you (not merged; keep your change in the lines the plan names and say where you touched theirs):
  site-menu (`site-menu-fix6`: `src/web/capture.ts` near the imports and `CaptureOptions`, a new shared launch
  `launchCaptureChrome` with a WebSocket gate, the press step and its guard); site-one-command
  (`site-one-command-build`: moves `tools/capture.ts`'s launch into `tools/lib/capture-run.ts` and edits `one()` in
  `tools/lib/capture-pages.ts`; its `site:import` must get this fix through the shared capture code: keep the fix in
  the shared code, the command's own words behind an option as the plan says); footer-icon-list (the capture's
  reader `src/web/read/code*.ts`: no shared file).
- The paste check id: write `<capture-refused-styles id at merge>` wherever HANDOFF needs it (the plan names 3dw as
  free today; the id is taken at the merge).

## Work
1. Follow the plan's tasks in order, each test first (RED on your base, then GREEN), one commit each. Task 0: copy the
   plan to `docs/plans/2026-11-10-capture-refused-styles.md`; keep the ledger at
   `docs/plans/2026-11-10-capture-refused-styles-ledger.md` (in git, committed with each task; `git ls-files
   .superpowers/` stays empty); `npm run corpus` before Task 1 and at the close.
2. **Think about the class of sites:** a check that comes back after a time, after a number of requests, per window,
   once per kind of visitor (the capture reads a page as several kinds); a site that refuses only one stylesheet, a
   script, a picture; a site that refuses the page itself on the retry (the person check shows again: the visible
   window, the wait, the same words as the first check); a person who doesn't pass it the second time (the plain
   line, no capture); a site that never refuses (byte for byte as before, no extra request). Add a test for each the
   plan names; record what you leave (HANDOFF "Known limits", follow-ups).
3. **The guards, proven to fail** (mutants under the 4 GB cap, each killed by an AC's cited test on its own
   assertion, recorded in the ledger): the retry answered from the kept page again; the refusal line without what
   answered; a capture saved though a range never got its styles; the log holding a cookie or an `Authorization`
   header; the panel route printing the command's words (and the reverse).
4. Gates before stopping: both typechecks (`tsconfig.sandbox.json` too), `npm run check`, `npm run corpus` (same as
   your base; v1's Mac files are missing on this machine), every AC's test with a log starting `HEAD=` and ending
   with one line `EXIT=` (AC3's named-only run with its variables set and a `git archive` of your base at the same
   build number, as the plan says), the web suites the plan's Task 9 lists, each file alone under `systemd-run --user
   --scope -p MemoryMax=4G -p MemorySwapMax=0` (export variables first; no `--setenv=PATH`), compared by name with
   your base (known flakes: the code-page fixture's 5.09 px load flake, `capture-windows` AC7, `capture-entrances`
   R8-1, `site-elementor-button` pixels-at-rest, `capture-opens-guards`' worker comparison: rerun a flake alone before
   calling it a failure), `test/web/human-check.test.ts` whole (AC7), `test/unit/plugin-convert.test.ts`, `dist/code.js`
   and `dist/ui.html` byte-identical to your base's build unless the plan says the panel's words change (say which
   bytes), the capture's time on a heavy local fixture against base (twice each, same load), a terminal capture per
   AC (AC1: the whole run with the check coming back partway; AC2: the refusal line and the log file's content).
5. HANDOFF: a section for this job in plain words (what happened on Justin's runs; the cause; what the scan does now;
   what he may see: "I am human" once more partway through; the refusal line and the `.f2b-refused.json` log; Q1–Q5
   "not yet confirmed"; known limits; Q5 B's follow-up about no-store stylesheets), Justin's numbered check for the
   live AC (his own scan, in his terminal; what to paste back to us if it fails), and in the ledger the exact
   CLAUDE.md lines for the merge finisher (the Status line; a standing rule if the plan proposes one).
6. Commits: plain `git commit -m` (or `-F <file>`), no author override, no AI or Co-Authored-By lines, `git diff
   --cached --name-only` without CLAUDE.md. Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/builder/`.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters and a separate one
  for each script you start at the same time (`~/.cache/crs-b/t1`, `t2`; a Chrome profile under a long TMPDIR dies
  with "Socket path too long"); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Several agents run
  Chrome, and Justin may run his own: close every Chrome **you** start (stop it by the PIDs of its own profile path;
  never `pkill -f <pattern>`, never a Chrome you didn't start). A worktree's `node_modules` may lack `.bin`, and a
  `git archive` scratch tree has neither `tsc` nor `node_modules` (put
  `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
  piped, chained or redirected git command is refused: one plain git command per call, `git -C <absolute path>`). A
  test that serves a fixture site in its own process spawns the CLI with async `execFile`, never `execFileSync`; a
  driver script never sits directly in `test/fixtures/` (four unit tests import every file there). Use `tail -n 3`,
  never `tail -3`. One `bash <file>` per Bash call (scripts written with Write, kept under
  `~/.cache/capture-refused-styles-builder/`; a restart empties `/tmp`); run long gates on a scratch copy, never in
  the worktree while you edit it.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`) or a scope oom-kill. Waits under 115 s.
- The PC restarted three times this week, and agents were stopped by a usage limit twice: write each log's `EXIT=`
  line (wait on `^EXIT=`); after a restart check `git status` for half-written tracked files (exactly 8388608 bytes)
  and `git cat-file -t HEAD`; read your finished logs first and never start a second driver on a suite one is still
  working through.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, base, last commit (full SHA), per AC: test, RED/GREEN paths, terminal capture; the
classes of sites handled and left; the mutants and what killed each; gates vs base (the capture's time too);
deviations from the plan; `found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty
is normal; `enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with: `MAIN SESSION:
check and save these skill_lessons now.`
