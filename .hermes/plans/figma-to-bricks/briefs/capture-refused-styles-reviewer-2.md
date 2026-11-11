# Role: reviewer (round 2, a delta: fix pass 1; report only): capture-refused-styles

You are a fresh reviewer who never saw the build or the fix (**Opus 5.5, high**). Review only: change no source or
test, commit nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other
worktrees (read them with `git show`). **Never load bdryswi.com** in any way, B-Dry staging or any live site: the
capture runs only against local fixture servers. No logins; never write to any WordPress site; `site:import` /
`site:upload` only against the tests' own 127.0.0.1 stand-in with a made-up password. **Nothing may hide that the
importer's Chrome is automated** (no `AutomationControlled` flag, no `navigator.webdriver` patch, no new user agent, no
stealth script, nothing that clicks or types into a site's check; **no cookie copied out of the browser into Node**):
a fix that works by disguise is a P0. Justin may be running his own Chrome: never stop a Chrome you didn't start;
touch nothing under `~/Downloads`.

**Importer rule (Justin, 2026-11-02):** P0–P2 only for a bug a real site or normal use hits, each with a concrete
real-use scenario; edge cases are P3. This job exists because Justin cannot scan his client's site (bdryswi.com, on
WordPress.com) at all: a bug that would still stop or silently spoil his next real scan is P1. From round 2 in Mini the
referee asks Justin when a round leaves only P2: rate each finding exactly.

## What happened before you
The job makes the capture survive a site whose check comes back partway through a scan (a range that lost a stylesheet
is read again asking the site for its page; the person may pass the check again; a site that keeps refusing stops
with a line naming who refused what and a `.f2b-refused.json` log; a page whose own stylesheets are all refused from
the first load is the site turning the capture away). Review 1 (`evidence/capture-refused-styles/review-1/review.json`)
found R1-1 (P1: the pictures step at the scan's end asked the site again with no pass renewal, so a refused picture
was only a note and the capture was saved done, `Pictures 0/1`, exit 0; on a self-passing check the invisible route
fetched pictures by Node with no cookies) and R1-2 (P2: `PageKeptReloading` still printed the panel's "Press Capture
to try again" with a stack). Fixer 1: new `src/web/renew.ts` (`renewing()`), wired into the pictures and font-files
steps of `src/web/capture.ts`: a refusal (401, 403, 429) of the site's own file renews the pass by a fresh page load of
the site's page in the same Chrome (`openSession`, the capture's check mode), then fetches that file and every later
own file through that page load's tab (`browserFetcher`, the browser's own cookies; Node is never given one); 3 tries
an address; still refused and the renewal's own page load refused too → `SiteRefused` stop with AC2's line; refused
while the site serves its page → a note (a dead file); `PageKeptReloading` gets the command's words with no stack, and
AC5's test now walks every stop error class with a tripwire.

## Inputs
- Approved plan (read-only; amended A1–A6):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/plan-approved.md` (AC1–AC10; AC9 live).
- Branch `capture-refused-styles-fix1`, head `3f114cb8abd676a45cc3938b9f603991c8e10a54` (code head `98a05b57`; first
  fix commit `291dbc18`), on review 1's head `cc96b92ab929f3662b4067361225d57f3b2f318f`, base main
  `3f4a0718d974ec66167ce788ed3fe2672df9feb6`. In your own worktree: `git checkout --detach
  3f114cb8abd676a45cc3938b9f603991c8e10a54`, confirm HEAD and a clean status. **Your scope (Mini round 2):** `git diff
  cc96b92a..HEAD` and what it touches.
- The fixer's record (read, don't trust): `evidence/capture-refused-styles/fixer-1/` (`red/`, `green/`, `mutants/`,
  `gates/`, `ac3/`, `ac3-run1-load17-failed/`); review 1's probes `review-1/probes/` (the fixture `r1-site.ts`,
  `run-cli.ts`, the press and stop-line probes); `follow-ups.md` (recorded P3s and limits: don't re-report unless you
  rate one higher, with a scenario).

## Check hardest
1. **R1-1 closed on Justin's route and on the invisible route,** on fixtures of your own beside the reviewer's: the pass
   runs out during the pictures step (a person presses again in the visible window; a check that passes itself);
   during the font files; between the last range and the pictures; twice during the pictures (a long page with many
   pictures); a picture on `www.` of the site and on a CDN; a site that answers its page but refuses one picture (a
   dead file: a note, no stop — is that right for a real site's protection that refuses only pictures?). Each: exit,
   `Pictures n/n`, `capture:check`, equal to the clean capture where it should be, the line where it stops.
2. **No disguise and no new exposure:** the tab's download (`browserFetcher`, `Network.loadNetworkResource`) sends what
   a browser sends for that request — what does a site see (no Referer: the fixer says a hotlink-protected site then
   gets notes — how common is that on WordPress and WordPress.com, and does it turn a site that works today into one
   that fails? a site that refuses nothing must never take the tab route); no cookie or header copied into Node;
   nothing presses or types into a check; the renewal page load is an ordinary navigation. The extra requests a
   renewal costs (one page load per renewal, one browser download per refused file) are bounded: no loop that
   hammers a refusing site (count requests on a site that refuses everything after the first pass).
3. **A site that refuses nothing is unchanged:** byte for byte, each address asked no more often, the pictures and
   fonts fetched by the same route as before (the tab route only after a refusal). AC3: its count clause on the edge
   fixture failed once at load 17 (one extra cookie-varying sheet request, 26 vs 25) and passed at load 2.3: is the
   extra request load noise or a real retry this job adds under load? Find out (the request log of the failed run is
   in `fixer-1/ac3-run1-load17-failed/`).
4. **R1-2 closed:** every stop error class prints the command's words with no stack in `npm run capture` and
   site:import's words in `site:import`; the panel keeps its words; the tripwire would catch a new class.
5. **Gates:** both typechecks, `npm run check` (8G scope; by name against base `3f4a0718`), `capture-refused`,
   `capture-refused-import`, `capture-renew`, `human-check` whole, the plan's Task 9 web suites and every
   `site-import-*` web file, each alone under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export
   variables first; no `--setenv=PATH`); `dist/` byte-identical to base's. Two mutants of your own under the cap: the
   renewal's tab route used for every picture from the start; the 3-tries bound removed.

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` ("Access": "A check that comes back partway through a scan"). Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/review-2/review.json` (round 2, a delta from
review 1's head `cc96b92a`; `head` the full SHA of your HEAD), then self-check:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
3f4a0718d974ec66167ce788ed3fe2672df9feb6 /home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles`
(exit 2 means your file is wrong: fix it).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/crs2/t1`, a
separate one per script started at the same time; a Chrome profile under a long TMPDIR dies with "Socket path too
long"); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` (one Chrome job at a time, closed after: stop
it by the PIDs of its own profile path; never `pkill -f <pattern>`). A worktree's `node_modules` may lack `.bin`, and a
`git archive` scratch tree has neither `tsc` nor `node_modules` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
piped, chained or redirected git command, a heredoc, a shell function or a word containing "git" may be refused: write
such steps to a script file with Write and run `bash <file>`; `git -C <absolute path>`). A script hosting a fixture
server in its own process starts the CLI with async `spawn`. Use `tail -n 3`, never `tail -3`. Never edit a tree a
test is running against. Scripts under `~/.cache/capture-refused-styles-review2/`. SIGTERM / 143 / 137 may be earlyoom
(`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). Waits under 115 s. The PC restarted three
times this week: write each log's `EXIT=` line, keep notes on disk; when resumed, read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario) or "none"; the fixture table (shape → exit,
`Pictures`, `capture:check`, the line); the disguise and request-count checks; AC3's extra request explained; R1-1
and R1-2 closed or not; `verdict`; `ac_status` (per AC: what the review saw); then `skill_lessons[{skill, lesson,
evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these
skill_lessons now.`
