# Role: fixer (round 1: review 1's R1-1 and R1-2): capture-refused-styles

Review 1 (a full review with the verifier's AC work) ended `REVIEW AGAIN: 2 P0-P2 finding(s)`. You are a fresh fixer
for FigmaToBricksV2 (**Opus 5.5, high**). Fix both test-first, then stop at `ready-for-next-review`. Never edit the
main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't bump `BUILD`,
leave other worktrees alone, start no agents. **Never load bdryswi.com** in any way, B-Dry staging or any live site:
the capture runs only against local fixture servers. No logins; never write to any WordPress site; `site:import` /
`site:upload` only against the tests' own 127.0.0.1 stand-in with a made-up password. **Nothing may hide that the
importer's Chrome is automated** (no `AutomationControlled` flag, no `navigator.webdriver` patch, no new user agent, no
stealth script, nothing that clicks or types into a site's check): a fix that works by disguise is not a fix. Justin
may be running his own Chrome: never stop a Chrome you didn't start; touch nothing under `~/Downloads`.

**Skills to load:** `receiving-code-review` (verify each finding before fixing it; push back with evidence if one is
wrong), `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`. Read
the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with
`references/testing-pitfalls.md` and `references/live-site-reading.md` ("Access": "A check that comes back partway
through a scan" — it now also says how the capture downloads pictures and fonts), and the repo `CLAUDE.md` ("Build
general logic": nothing keyed on bdryswi.com, WordPress.com or any host; "The importer never hides that its Chrome is
automated").

**Mini pipeline:** if the fix needs a design decision beyond the approved plan (Q1–Q6), or would change what a capture
of a site that refuses nothing holds or asks for, stop with `status: stopped`, `stop_reason: needs the planner` and say
exactly what.

## Your copy (you start in your own worktree)
`git checkout -B capture-refused-styles-fix1 cc96b92ab929f3662b4067361225d57f3b2f318f` (the reviewed head, branch
`capture-refused-styles-build`, on main `3f4a0718d974ec66167ce788ed3fe2672df9feb6`, Build 2026-11-11.1). Check `git
rev-parse main` before your final gates: if main moved, rebase onto it (HANDOFF: this job's section first, then main's
lines exactly as main has them), say which commits conflicted, and report main's SHA as your review base.

## Inputs
- Approved plan (read-only; amended A1–A6):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/plan-approved.md` (AC1–AC10; AC9 live).
  AC1's sentence ("a site whose check comes back partway is captured as one that never refused") and AC5's ("the
  command's stop lines say what to type") are what you are bringing the code up to.
- Review 1: `evidence/capture-refused-styles/review-1/review.json`; its probes `review-1/probes/` (the fixture
  `r1-site.ts`; `press-with-picture-head.log` vs `press-with-picture-long-pass-control-head.log`;
  `picture-diff-expire6-w4.log`; the stop-error probe for R1-2); the reviewer's AC work `verifier/` (read; a fresh
  verifier proves the ACs again after you). Recorded P3s (R1-3 … R1-8) are in `follow-ups.md`: not yours unless your
  fix closes one for free — say so if it does; never widen the fix to chase them.

## R1-1 (P1) — the pictures at the scan's end, after a returning check
- **The finding:** the pass is renewed only where a range's stylesheets are checked. The pictures step at the scan's
  end (`src/web/capture.ts:362`) asks the site for every picture's full-size file again, and nothing renews the pass
  there: a refused picture is only a note and the capture is saved as done (exit 0, `Pictures 0/1`, `File:`);
  `capture:check` then fails it ("a shown picture has no bytes"), `site` converts it, and `site:import` only warns
  and keeps the old addresses. On Justin's route (a check a person presses, the visible window, pictures through the
  tab): with a 7 s pass and three presses the scan ends done with the picture answered 403; the control with a pass
  that never runs out gives `Pictures 1/1`. On a check that passes itself (AC1's own fixture shape), the window never
  opens, so pictures are fetched by Node (no cookies) and are refused whatever the timing. AC1's equality holds on the
  plan's fixture only because that page has no picture. HANDOFF's paste check step 3 says the "refused on the way"
  line "is fine: the scan got past it" — not true here.
- **Verify it first** on the reviewer's fixture (RED on your base: the page with its picture ends `Pictures 0/1`, exit
  0).
- **Fix as a general rule (the planner's Q1 A extends to it: a retry asks the site again, the person may pass the
  check again):** when the pictures step (or the fonts step, if it shares the route) gets a refusal (401, 403, 429)
  for the site's own files, it renews the pass the same way a range does — an ordinary page load of the site's page in
  the same Chrome, the person check in the visible window if the site asks — and fetches the refused files again
  through the browser's tab (the route that carries the pass), never by sending Node a cookie it copied and never by
  disguise; still refused after the tries, the capture **stops** with AC2's refusal line and the log (no file a later
  tool would take as clean), exactly as a stylesheet refusal does. A site that refuses nothing: its pictures step
  asks and holds byte for byte as before (AC3's rule: equal captures, each address asked no more often — prove it
  with AC3's paired test or its count clause on a fixture page with pictures). Decide and say, with a test each:
  pictures on another host that refuse (not the site's to renew: a note, as today); a picture the site answers 404
  (a dead link: a note, as today); a check that passes itself (the invisible route: does the renewal give Node's
  fetch the pass? if the only honest route is the tab, say what that costs and whether it needs the planner).
- **Tests:** AC1's cited test's fixture gains a picture (and a script, if cheap) so "captured as one that never
  refused" covers the pictures step — extend under the unchanged test name; the reviewer's press-at-every-check shape
  with a picture (Justin's route) ends with `Pictures 1/1` equal to the clean capture; a site that keeps refusing its
  pictures stops with the refusal line and the log; each RED on your base by its own assertion. Correct HANDOFF's
  paste-check step 3.

## R1-2 (P2) — one stop line still in the panel's words
- **The finding:** `tools/lib/capture-pages.ts:111`: `PageKeptReloading` (`src/web/human.ts:248`) falls through
  `capturePage`'s last branch: a stack, "Press Capture to try again." unchanged, and no log. On head 1 of 7 stop errors
  still names the button. Scenario: Justin's retry meets the check page, which reloads itself three times in one page
  load (his 2026-11-07 capture recorded such reloads).
- **Fix:** every stop error the command prints ends with the command's own words (`npm run capture`: "Run npm run
  capture -- <address> again."; `site:import`: its own words via `again`), with no stack, and writes the log when
  requests were refused; the panel keeps its words. AC5's cited test gains `PageKeptReloading` (and every other stop
  error class the capture can throw: list them from the code and assert each one's line in full, so the next new
  class can't slip through).

## Mutants (4 GB cap), each killed by a cited test on its own assertion
The pictures step not renewing the pass; the refused pictures fetched again by Node instead of the tab (or whichever
route you choose being bypassed); a still-refused picture saved as done; `PageKeptReloading` back to the panel's words;
a stop error printed with its stack.

## Gates before stopping
Both typechecks; `npm run check` (8G scope; by name against base `3f4a0718`); every AC file
(`test/web/capture-refused.test.ts`, `capture-refused-import`, the unit tests named on AC2's and AC10's Also lines),
`human-check` whole, the plan's Task 9 web suites and every `site-import-*` web file, each alone under `systemd-run
--user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export variables first; no `--setenv=PATH`); AC3 at the lowest load
you can get (its table and `uptime`; never retried until green); `dist/` byte-identical to base's build. Each log
starts `HEAD=` and ends with one line `EXIT=`.

## Records and commits
HANDOFF's section and the ledger ("Fix pass 1": each finding verified, the rule as built, RED and GREEN, the mutants,
what stays a limit), the follow-ups appended. Commits: plain `git commit -m` (or `-F <file>`), no author override, no
AI or Co-Authored-By lines, `git diff --cached --name-only` without CLAUDE.md. Evidence in
`/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/fixer-1/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/crsf1/t1`, a
separate one per script started at the same time; a Chrome profile under a long TMPDIR dies with "Socket path too
long"); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (stop it by
the PIDs of its own profile path; never `pkill -f <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git
archive` scratch tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin`
on PATH and symlink the main folder's `node_modules` in; a piped, chained or redirected git command, a heredoc or a
shell function may be refused: write such steps to a script file with Write and run `bash <file>`; `git -C <absolute
path>`). A script hosting a fixture server in its own process starts the CLI with async `spawn`, never `spawnSync`; a
driver script never sits directly in `test/fixtures/`. Use `tail -n 3`, never `tail -3`. Never edit a tree a test is
running against. Scripts under `~/.cache/capture-refused-styles-fixer1/`. SIGTERM / 143 / 137 or "Killed" may be
earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). Waits under 115 s. The PC restarted
three times this week: write each log's `EXIT=` line; after a restart check `git status` and `git cat-file -t HEAD`,
read your finished logs first.

## Report (as text; don't write report files)
`status: ready-for-next-review` (or `stopped` with the reason), branch, base, last commit (full SHA) and the first fix
commit; per finding: verified or not, the rule as built, the cases decided with their tests, RED/GREEN paths; the
mutants and what killed each; AC3's table; gates vs base; what stays a limit; `found_else`; then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
