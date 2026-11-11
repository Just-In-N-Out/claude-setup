# Role: reviewer (round 3, a delta: the move onto Build 2026-11-11.2 and fix pass 2; report only): capture-refused-styles

You are a fresh reviewer (**Opus 5.5, high**). Review only: change no source or test, commit nothing, start no agents.
Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read them with `git show`).
**Never load bdryswi.com** in any way, B-Dry staging or any live site: the capture runs only against local fixture
servers. No logins; never write to any WordPress site; `site:import` / `site:upload` only against the tests' own
127.0.0.1 stand-in with a made-up password. **Nothing may hide that the importer's Chrome is automated** (no cookie
copied into Node, nothing that presses or types into a check). Justin may be running his own Chrome: never stop a
Chrome you didn't start; touch nothing under `~/Downloads`.

**Importer rule (Justin, 2026-11-02):** P0–P2 only for a bug a real site or normal use hits, each with a concrete
real-use scenario; edge cases are P3. This job unblocks Justin's scan of bdryswi.com (WordPress.com, a 153-picture home
page): a bug that would stop or silently spoil that scan is P1. **Hold the press guard too** (site-menu, merged): while
the capture presses buttons no data-sending request, page load a press starts or WebSocket leaves. From round 3 the
referee asks Justin when only P2 is left: rate each finding exactly.

## What happened
The job was review-clean (review 2: MOVE ON) at `3f114cb8abd676a45cc3938b9f603991c8e10a54` on main `3f4a0718`. Main then
moved to `e16d3d1ea2c752bac7e405ce00bfc25accbc8de9` (site-menu, Build 2026-11-11.2: the capture presses menu buttons
under a guard with a socket gate; `openPictures` downloads the pictures opened boxes show). A stack fixer rebased the
job (only HANDOFF conflicted) and then, test-first:
- **joined the two:** a renewal tab (this job's page load that renews a site's pass at the scan's end) closed once its
  page loads, so none is open beside the design width's presses; site-menu's `openPictures` now downloads through the
  renewal (it used Node, which holds no pass, so a menu's own picture was missing on a site whose check came back);
  new test file `test/web/capture-renew-tabs.test.ts` ("where the sides meet", "where the records meet");
- **review 2's R2-1:** at most one renewal tab open at a time and a cap `RENEWALS = 3` page loads per capture
  (`src/web/renew.ts`); past the cap a refused file still gets its tries, each after its wait alone; on a 153-picture
  page with a host answering 429 above 6 downloads in 2 s: 25 renewals / 4,204 requests / 127.5 s → 3 / 728 / 81.6 s,
  every picture;
- **R2-2:** nothing asked after the stop is decided.
Recorded follow-ups: a 429's `Retry-After` isn't read (each few refused pictures cost the full 30 s wait: ~12 min on
153 pictures); a pass kept per tab rather than in a cookie wouldn't reach the design width's tab. **Nobody has reviewed
the move's join or fix pass 2.**

## Inputs
- Approved plan (read-only; amended A1–A6):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/plan-approved.md` (AC1–AC10; AC9 live).
- Branch `capture-refused-styles-stack2`, head `ebd4dfc8ed78e511b3671985eb2bb3d7f165013e` (moved head with no fix
  `15b6302542c58968553013fa78c1fc1e2d606342`; last code commit `bd823aa3`), base main `e16d3d1e`. In your own worktree:
  `git checkout --detach ebd4dfc8ed78e511b3671985eb2bb3d7f165013e`, confirm HEAD and a clean status. **Your scope:** the
  move (`git range-diff 3f4a0718..3f114cb8 e16d3d1e..15b63025`) and fix pass 2 (`git diff 15b63025..HEAD`), and what
  they touch.
- The fixer's record (read, don't trust): `evidence/capture-refused-styles/stack-2/` (`move-proofs.log`, `resolutions/`,
  `green/`, `mutants/`), the ledger's "Stack 2" and "Fix pass 2", `follow-ups.md`. Review 2's probes:
  `~/.cache/capture-refused-styles-review2/` (`r2-site.ts`, `run.ts`, `cli.ts`, `hook.mjs`).

## Check hardest
1. **The press guard and the renewal never meet:** your own fixture (a check that comes back partway — as the
   pictures download, as the font files download, during the ranges — on a page with a menu button and a pop-up whose
   content holds the site's own picture): no renewal page load while the guard is shut; no press on a renewal's tab;
   no renewal tab open while any page presses (count targets with an anchor after the close); the guard still holds
   (0 writes, 0 page loads, 0 handshakes from presses); the box read, every picture including the box's own, equal to
   the clean capture. Through `npm run capture` **and** `npm run site:import` (stand-in, made-up password, "no").
2. **The cap is right for Justin's page:** 3 renewals per capture — on a site whose check comes back twice in a scan
   (once in the ranges, once at the end), does the end still get a renewal? A 153-picture page on a check that expires
   every N seconds (try 30 s and 60 s passes at the real 30 s waits, or scaled): does it finish, how long, how many
   page loads; past the cap, what does the person see? `Retry-After` unread: is ~12 minutes on a 429-limiting host a
   real-use problem for this job (P2) or a follow-up (P3)? Say what WordPress.com's own rate limiting answers
   (public documentation only; never the site).
3. **Downloads now go through the design width's tab after a renewal:** does that change anything for a site that
   refuses nothing (it must not take the tab route at all: request counts and route per address equal to base), for a
   hotlink-protected site, for pictures on another host? No cookie in Node, ever.
4. **The move:** your own range-diff, patch-ids, and the whole-diff identity; HANDOFF whole (this job's first, main's as
   main has it). site-menu's tests on head (`capture-opens`, `capture-opens-guards`, `press-guard-sockets`,
   `capture-commands-sockets`, `site-opens-proof`).
5. **Gates:** both typechecks and `npm run check` (8G scope); this job's AC files and `capture-renew*`,
   `capture-renew-tabs`, `human-check` whole; every `site-import-*` web file and `capture-cli`; each web file alone
   under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export variables first; no
   `--setenv=PATH`); `dist/` byte-identical to main's. Two mutants of your own under the cap: a renewal allowed while
   the press guard is shut; `openPictures` back on the plain fetcher.

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4", the stacking lines) with
`references/testing-pitfalls.md` and `references/live-site-reading.md` ("Access"; "Holding a Chrome to read-only").
Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/review-3/review.json` (round 3, a
delta from review 2's head `3f114cb8`; `head` the full SHA of your HEAD), then self-check:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
e16d3d1ea2c752bac7e405ce00bfc25accbc8de9 /home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles`
(exit 2 means your file is wrong: fix it).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/crs3/t1`; a
Chrome profile under a long TMPDIR dies with "Socket path too long");
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` (one Chrome job at a time, closed after: stop it by the
PIDs of its own profile path; never `pkill -f <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git
archive` scratch tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin`
on PATH and symlink the main folder's `node_modules` in; a piped, chained or redirected git command, a heredoc, a shell
function or a word containing "git" may be refused: write such steps to a script file with Write and run `bash
<file>`; `git -C <absolute path>`). A fixture trigger aimed at the scan's end keys on `Sec-Fetch-Dest`; Node can't
resolve `*.localhost` here. Use `tail -n 3`, never `tail -3`. Never edit a tree a test is running against. Scripts
under `~/.cache/capture-refused-styles-review3/`. SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom --since
"-30 min" -o short-iso | grep sending`). Waits under 115 s. The PC restarted three times this week: keep notes and
finished probe results on disk; when resumed, read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario) or "none"; the sides-meet table (shape × route →
renewals, tabs open during presses, guard counts, pictures, equal?); the cap table (pass length × pictures →
finishes?, time, page loads); `Retry-After` rated with the reason; the move's proofs; `verdict`; `ac_status`; then
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN
SESSION: check and save these skill_lessons now.`
