# Role: fixer (round 3, narrow: review 3's R3-1, P1 — the press guard and a page's service worker): site-menu

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). Fix review 3's one P1 test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never
push or merge, don't bump `BUILD`, don't rebase, leave other worktrees alone, start no agents. **Never load bdryswi.com,
B-Dry staging** or any live site (local fixtures and saved files only); no logins; never write to any WordPress site.
Nothing paid. Nothing may hide that the importer's Chrome is automated.

**Skills to load:** `receiving-code-review` (verify the finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline` (this is a guard), `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (the lines on a capture that presses page controls, on the form guard, and "Holding a
Chrome to read-only"), and the repo `CLAUDE.md`.

## Your copy (you start in your own worktree)
`git checkout -B site-menu-fix3 66dc86a5e7ad9ff278326986e2097ae6336140dc` (the reviewed head, branch `site-menu-fix2`, on
local `main` `3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1`), confirm `git rev-parse HEAD` and a clean status. Report your
branch; work only in your own copy.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md`. Don't
  change the plan or any AC.
- Review 3: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/review-3/review.json`; its probes and logs
  under `~/.cache/smn-r3/` (`logs/probe-g.log`, `probe-sw.log`, `probe-wct.log`, `probe-whatif.log`). Fixer 2's receipts:
  `evidence/site-menu/fixer-2/`.

## The finding
**R3-1 (P1, `src/web/press-guard.ts:101`):** while the capture presses, the page's requests are held only by Fetch on
the twin session. A request the page's **service worker** answers (`respondWith(fetch(…))`) is made by the worker's own
target, which neither Fetch session sees. Probed on the site-menu fixture, the server's requests counted after the
capture:
- with a navigate-only, network-first worker (the usual offline/PWA pattern), a drawer button with
  `onclick="location.href='/quote/'"` left the page: `GET /quote/` reached the server, that button was recorded as the
  drawer's closer, the × was lost, and no note was written (without the worker the same press is stopped and named);
- with a worker that answers every request, `form.submit()` of a POST form from outside the form sent
  `POST /ext-post/` to the site, and a press's `fetch` `POST /swpost/` got through.
Real use: a WordPress site running a PWA or offline plugin; a form post sent by a press's script reaches the client's
site. The reviewer's what-if, inside its probe only: `Network.enable` plus
`Network.setBypassServiceWorker({ bypass: true })` on the twin session fixes all of these.

## Work
1. Verify it yourself first.
2. **Test first (RED on `66dc86a5`):** `test/web/capture-opens-guards.test.ts` (or beside it) gains fixture pages that
   register (a) a navigate-only network-first service worker and (b) a worker answering every request, each with: a
   button in an opened box whose script sets `location.href` to another page, a `form.submit()` of a POST form from
   outside the form, and a press whose script `fetch`es a POST. After the capture the fixture server lists no non-GET
   request and no request for another page; none of those controls is an opener or closer; the real × still closes the
   box; each stopped press is named in the notes.
3. **Fix as a rule:** while the guard is on, nothing a press starts may reach the network through a path the guard
   doesn't see. Bypass the page's service worker for the guard's span (and restore what was there after, so the rest of
   the capture reads the page as before), on every session the guard holds requests on. If turning the bypass on or off
   could change what the page shows (a page that only works through its worker), prove on the fixture that the boxes
   read with the worker registered equal the boxes read without it, or say what differs.
4. **If the same mechanism covers them in a few lines, with a test each; otherwise leave them recorded** (review 3's
   R3-4, P3): a worker already running that posts when a press messages it; a cross-site frame already in the page that
   posts to its own site (attach the guard to every target of the page that exists when the guard starts, not only to
   the tab and to targets created afterwards).
5. Mutate what you add (the bypass removed; restored too early), under `systemd-run --user --scope -p MemoryMax=4G -p
   MemorySwapMax=0`.
6. Records batched into your commits: HANDOFF's site-menu section (the guard's rule; "Deferred": R3-2 — a same-site
   report on every click makes every opener count for nothing, with the note it prints —, R3-3 — a write started more
   than 300 ms after its press is charged to the next press —, what stays of R3-4 including GETs passing by design, such
   as a pop-up plugin's open beacon —, R3-5 — the guard costs about 30 % more capture time) and the ledger ("Fix pass
   3"); append what you defer to `evidence/site-menu/follow-ups.md`.
7. Gates: both typechecks, `npm run check`, `capture-opens-guards`, `capture-opens`, `capture-opens-styled`,
   `site-opens-more`, `site-opens-proof`, `site-check-opens`, `capture-matched-once`, the unit `web-press-guard`,
   `web-opens-read`, `site-opens-through` (each alone under the 4 GB cap, one Chrome job at a time), the offline B-Dry
   dry run (8G; the same 5 boxes, 0 non-GET requests, no other page asked for). Commit after each passing step (plain
   `git commit -m`, or `-F <file>` when the message holds a backslash or parentheses with colons; no author override, no
   AI or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/fixer-3/` (logs `HEAD=` first, `EXIT=` last).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smn-f3/tmp`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  Other agents run Chrome too: close every Chrome you start. A worktree's `node_modules` may lack `.bin` and a scratch
  tree has no `tsc` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). Multi-step commands from a
  script file written with Write; scripts and logs under `~/.cache/smn-f3/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); say so, find what grew, rerun under the cap.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, last commit (full SHA), R3-1: verified?, the rule, the fix, tests, RED/GREEN paths,
mutation; step 4 done or left; gates vs the reviewed head; `found_else`; then `skill_lessons[{skill, lesson, evidence,
enforce}]` (reusable only; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
