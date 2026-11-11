# Role: stack fixer (move capture-refused-styles onto main Build 2026-11-11.2, plus review 2's R2-1 and R2-2)

You are a fresh fixer (**Opus 5.5, high**). capture-refused-styles is review-clean (review 2: MOVE ON) at
`3f114cb8abd676a45cc3938b9f603991c8e10a54` (branch `capture-refused-styles-fix1`) on main
`3f4a0718d974ec66167ce788ed3fe2672df9feb6`. Main has moved: site-menu merged as Build 2026-11-11.2, local `main` =
`e16d3d1ea2c752bac7e405ce00bfc25accbc8de9`. (1) Move the job onto it, keeping both sides' meaning; (2) fix review 2's
two P3s test-first (they matter for Justin's real 153-picture page); stop at `ready-for-review` (the move and the fix
are reviewed before the job is verified).

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. **Never load bdryswi.com** in any way, B-Dry staging or any
live site: the capture runs only against local fixture servers. No logins; never write to any WordPress site;
`site:import` / `site:upload` only against the tests' own 127.0.0.1 stand-in with a made-up password. **Nothing may
hide that the importer's Chrome is automated** (no cookie copied into Node, nothing that presses or types into a
check). Justin may be running his own Chrome: never stop a Chrome you didn't start; touch nothing under `~/Downloads`.

**Skills:** `git-commit-rules`, `engineering-best-practices`, `test-driven-development`, `receiving-code-review`,
`mutation-testing-discipline`; read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main", the stacking lines) with `references/testing-pitfalls.md` (fixture triggers for the
downloads key on `Sec-Fetch-Dest`; Node can't resolve `*.localhost` here) and `references/live-site-reading.md`
("Access": "A check that comes back partway through a scan"; "Holding a Chrome to read-only": site-menu's press guard
and socket gate).

## 1. The move
`git checkout -B capture-refused-styles-stack2 3f114cb8abd676a45cc3938b9f603991c8e10a54` then `git rebase --onto main
3f4a0718d974ec66167ce788ed3fe2672df9feb6` (check `git rev-parse main` = `e16d3d1e…`; if main moved again, use it and
say so). site-menu changed `src/web/capture.ts` (`launchCaptureChrome`, the press step and its guard, `CaptureOptions`
near the imports — the plan says keep both), `src/web/read/*`, `src/core/snapshot/web.ts`, `tools/lib/capture-run.ts`
(the launch join), `test/browser/chrome.ts`, and HANDOFF. On each conflict keep both sides' meaning (HANDOFF: this
job's section first, then main's lines exactly as main has them; `<capture-refused-styles id at merge>` stays);
typecheck at each conflicted commit before `git rebase --continue`; save each conflicted file before and after under
`resolutions/`. **Where the sides meet:** (a) a renewal page load (this job) and site-menu's press step run in the same
Chrome: a renewal must never happen while the press guard is shut (a page load the guard would refuse), and a press
must never run on a renewal's tab — find the order in `captureSite` and prove it on a fixture whose check comes back
partway **and** that holds a menu button: the capture ends clean with its box read and every picture; (b) the renewal's
tab and the socket gate: renewals go through the gated Chrome (they must: same Chrome); (c) this job's
"refused on the way" record and site-menu's stopped-write notes don't double-count or mislabel each other.
Proofs: `git range-diff 3f4a0718..3f114cb8 e16d3d1e..<rebased head>`; patch-ids (`--full-index`; `-U0` for
context-only); `git diff -U0 3f114cb8 <rebased head>` equals `git diff -U0 3f4a0718 e16d3d1e` after dropping `^(index
|@@ )` lines, except the conflicted files (each explained).

## 2. Review 2's P3s, test-first (each RED on the rebased head before its fix)
- **R2-1 (`src/web/capture.ts:369`): renewal page loads pile up and stay open.** Each renewal opens a new full page load
  (a tab that loads every picture again), kept until the capture ends; a host answering 429 to more than 6 picture
  downloads in 2 s on a 40-picture page gave 6 renewal tabs, 400 page-load picture requests and 48 s (every picture
  came). Fix: a renewal's session is closed when the next one replaces it (only the newest renewal's tab is open), and
  renewals per capture are capped (choose the cap from evidence — the reviewer's 429 shape and a 153-picture page —
  and say it; past the cap, a still-refused own file is a note if the site serves its page, else the refusal stop).
  Tests: at most one renewal tab open at any time (count targets); the cap holds; every picture still comes on the
  429 shape; the number of requests to the site on the 429 shape with 153 pictures is bounded and reported.
- **R2-2 (`src/web/renew.ts:64`): extra requests after the stop is decided.** `if (failed) return r` comes after the
  fetch, so every remaining picture is still asked once through the tab (44 extra refused downloads on a wall). Fix:
  return before fetching. Test: on a site that walls the capture during its 40 pictures, the tab is asked no file after
  the stop is decided.
- Mutants (4 GB cap), each killed by its new test: the previous renewal's session left open; the cap removed; the
  `failed` check back after the fetch.

## Gates (light; the verifier runs the full ones)
On a `git archive` scratch copy of the new head: both typechecks and `npm run check` (8G scope); this job's AC files
(`capture-refused`, `capture-refused-import`, `capture-renew`, `capture-asked`, `capture-turned-away`, `human-check`
whole) and site-menu's (`capture-opens`, `capture-opens-guards`, `press-guard-sockets`, `capture-commands-sockets`,
`site-opens-proof`), every `site-import-*` web file and `capture-cli`, each alone under `systemd-run --user --scope -p
MemoryMax=4G -p MemorySwapMax=0` (export variables first; no `--setenv=PATH`); `dist/` byte-identical to main's build.
Each log starts `HEAD=` and ends with one line `EXIT=`. Known flakes (F6-5 in `capture-opens-guards`; AC3's count
clause under load; `site-upload-cli`/`-stop` timing tests): rerun alone before judging.

## Records and commits
The ledger ("Stack 2": each conflict and its resolution, where the sides meet; "Fix pass 2": R2-1, R2-2, RED/GREEN,
the cap and why, the mutants), HANDOFF's section (the renewal's cap in plain words; R2-1/R2-2 out of Known limits),
follow-ups. Commits: plain `git commit -m` (or `-F <file>`), no author override, no AI or Co-Authored-By lines, `git
diff --cached --name-only` without CLAUDE.md. Evidence in
`/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/stack-2/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/crss2/t1`; a
Chrome profile under a long TMPDIR dies with "Socket path too long");
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (stop it by the PIDs
of its own profile path; never `pkill -f <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git archive`
scratch tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on
PATH and symlink the main folder's `node_modules` in; a piped, chained or redirected git command, a heredoc or a shell
function may be refused: write such steps to a script file with Write and run `bash <file>`; `git -C <absolute
path>`). A script hosting a fixture server in its own process starts the CLI with async `spawn`. Use `tail -n 3`, never
`tail -3`. Never edit a tree a test is running against. Scripts under `~/.cache/capture-refused-styles-stack2/`.
SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). Waits
under 115 s. The PC restarted three times this week: write each log's `EXIT=` line; after a restart check `git status`
and `git cat-file -t HEAD`, read your finished logs first.

## Report (as text)
`status: ready-for-review`, branch, the new HEAD (full SHA), its base (full SHA), the conflicts and resolutions commit
by commit, where the sides meet (the menu-plus-returning-check probe), R2-1 and R2-2 (the rule as built, the cap and
why, RED/GREEN, the mutants), each gate's result, `found_else`, then `skill_lessons[{skill, lesson, evidence,
enforce}]` (reusable only; empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
