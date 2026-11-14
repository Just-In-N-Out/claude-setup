# Role: fixer (fix round 1, Mini) + move onto main: site-tests-offline

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review` (verify each finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
(directly) with `references/testing-pitfalls.md`. Read both `repeat-mistakes.md` files first. **Never load any live site.** Until your fix is in,
run any test that captures the B-Dry stand-in or draws Justin's scan only with no outside network (`unshare -rn sh -c 'ip link set lo up &&
exec unshare --user --map-user=1000 --map-group=1000 <cmd>'`) or under the job's sink; never write to any WordPress site; touch nothing
under `~/Downloads`. Commit to your branch only (plain `git commit -m`, no author override, no AI lines, never CLAUDE.md); don't push; don't
bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. Plain `git` in your own worktree, each command alone (never `git
-C` the main folder; no git piped into another command; files only with Write/Edit, never heredocs; scripts run as `bash <file>`). Tests
only: if a fix needs `src/` or `tools/`, stop with `stop_reason: escalate to full`.

## State
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-tests-offline/plan-approved.md` (AC1–AC4).
- Head `4b8b757397a69abe8afb65a5607085f3b51cd144` (branch `site-tests-offline-build`, base `392f67e2`). Review 1:
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-tests-offline/review-1/review.json` (REVIEW AGAIN) with the verifier's probes in
  `evidence/site-tests-offline/verifier/probe-*.txt`.
- Local main is now `fe29b65d94da2c6f4e1ecb881354b9e9b9842cef` (Build 2026-11-14.4: importer-app and site-shared-styles merged since the
  base). **First:** `git checkout -B site-tests-offline-fix1 4b8b7573…`; `git rebase fe29b65d…`; record conflicts in
  `evidence/site-tests-offline/fixer-1/conflicts.txt` (keep both sides' meaning); convert every test file main added since 392f67e2 that the
  guard names (and the ones R1-2 finds), each launch one line.

## Fix (each test first: RED, GREEN, a one-line mutant killed)
- **R1-1 (P2):** a stand-in capture test still sends Node-side GETs (`captureSite` downloads pictures and fonts with Node's fetch:
  `src/web/capture.ts:405`, `src/web/read/pictures.ts:15`; no test passes a `fetcher`; the stand-in's `css2.css` names 28 font files on
  growithgro1.wpcomstaging.com). Add one shared offline fetcher beside `launchOffline` (127.0.0.1 and localhost answered, every other host
  refused with a clear error, no request sent) and pass it to every `captureSite` call in a test file that captures a site; the guard fails a
  capturing test file whose `captureSite` call passes no fetcher. Prove with the verifier's probe shape (a logging/refusing
  `globalThis.fetch` on a fixture with a 127.0.0.2 outside host, and the real stand-in under no network): 0 non-loopback requests. Tests whose
  result changes because a font now fails: compare base and head behind the same refusal and say so.
- **R1-2 (P2):** the guard checks a file only when it names a drawing helper itself, so a test whose Chrome a helper launches is never
  checked (`test/fixtures/importer-app.ts:113` `openApp()`, used by eight importer-app files). Make the guard follow a drawing file's local
  imports under the walked folders, and convert `openApp` to `launchOffline({ googleFonts: false, … })`. A plain-launch mutant of `openApp`
  must fail the guard.
- **R1-3 (P3, but a test that can't fail):** AC2's test (`test/web/site-tests-offline-scan.test.ts:66`) passes when one of its two files draws
  nothing: require exit 0 and at least one launch per file.
- R1-4 to R1-6: P3, to `evidence/site-tests-offline/follow-ups.md` (fix R1-4's `DRAWS` misses — `checkParts`, `renderPage` on site pastes — if
  it is one line each; correct HANDOFF's heading per R1-6).

## Gates
Both typechecks, `npm run check` (8G); AC1–AC4 by their plan names on your head; AC4's tally base vs head on main's tree. Ledger: a "Fixer 1"
section. Stop at `ready-for-next-review`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/stof/t1`); scripts under `~/.cache/stof/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (a `user-data-dir=` pattern ends in
`/`; sweep `user-data-dir=$TMPDIR/f2b-chrome-` after each Chrome step); before each Chrome suite check `/proc/loadavg`; one Chrome suite at a
time under `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH";
…'`. An archive tree has no `node_modules/.bin` (a `tsc` wrapper first on PATH) and no repo (set `GIT_DIR`). Foreground Bash moves to the
background after about 180 s: wait in bounded steps of 160 s or less from a script file. Use `tail -n 3`. SIGTERM/143/137/"Killed": check
earlyoom's log first. Write summaries as .txt/.json.

## Report (as text)
Branch, head (full SHA), the main it sits on; conflicts; per finding: verified or pushed back, RED/GREEN, mutant; gates; `ac_status`;
`skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
