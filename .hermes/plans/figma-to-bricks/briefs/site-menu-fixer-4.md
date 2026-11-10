# Role: fixer (round 4, narrow: review 4's R4-1 — a window a press opens loads through the site's service worker): site-menu

**NOT DISPATCHED YET (2026-11-10).** Review 4 ended `ASK JUSTIN: review-4: 1 P0-P2, no fewer than review-3's 1`. This
brief is ready for the moment Justin says "fix it"; if he says "ship it as a known limit", it is not used and R4-1 goes
to `follow-ups.md` and HANDOFF "Deferred". His answer goes in `evidence/site-menu/review-4/justin.json`
(`{"words": "…", "continue": true|false}`) before `review-check.sh` is run again.

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). Fix review 4's one finding test-first, plus two small
P3 steps named below, then stop at `ready-for-review`. Never edit the main folder
`/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't bump `BUILD`, don't rebase,
leave other worktrees alone, start no agents. **Never load bdryswi.com, B-Dry staging** or any live site (local fixtures
and saved files only); no logins; never write to any WordPress site. Nothing paid. Nothing may hide that the importer's
Chrome is automated.

**Skills to load:** `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (the lines on a capture that presses page controls and "Holding a Chrome to
read-only"), and the repo `CLAUDE.md`.

## Your copy (you start in your own worktree)
`git checkout -B site-menu-fix4 06b50a9791069fff808651a9edf54f0cf08e648b` (the reviewed head, branch `site-menu-fix3`, on
`main` `3cfc54ac`), confirm `git rev-parse HEAD` and a clean status. Report your branch.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md`.
- Review 4: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/review-4/review.json`; probes and logs under
  `~/.cache/smn-r4/` (`probe-writes.ts`, `probe-undo.ts`, `logs/probe-writes.log` variant o, `probe-undo.log`).

## The finding
**R4-1 (P1, `src/web/press-guard.ts:130`; open since fix round 2, not caused by round 3):** a window a press opens still
loads its page from the client's site when the site's service worker answers page loads. The bypass is set only on the
pressed tab (`:115`); the new window's page load is answered by the worker, whose own session (attached at `:128`) lets
every GET through (`:131`), and the browser-wide Fetch never sees the request. With no worker the load is stopped and
named; with a page-load worker, or one answering every request, `GET /quote/` reached the server and no note named it
(that page's own POST and `sendBeacon` were still stopped; the paste is unaffected). Real use: a client site with a PWA
plugin whose pop-up "Book online" button opens `/booking/` in a new window by script.

## Work
1. Verify it yourself first.
2. **Test first (RED on `06b50a97`):** the `worker` fixture case gains a drawer button calling `window.open('/quote/')`
   (and one with `target="_blank"` set by script on a link without an address), run with the `nav` and `all` workers:
   the server lists no request for `/quote/`, the press is named in the notes, the × stays the only closer, no window
   or Chrome tab is left open.
3. **Fix as a rule:** while the guard is on, a page load a press starts is failed before it leaves, whatever target it
   starts in and whatever answers it. The reviewer's idea: bypass the worker on each window a press opens before its
   first request (browser-wide auto-attach with `waitForDebuggerOnStart`, `Network.setBypassServiceWorker` on the new
   page, then `Runtime.runIfWaitingForDebugger`), or fail the page load on the worker's own session while the guard
   holds (a GET whose resource type is a document, started after the guard began) — choose what you can prove on both
   worker modes, and undo it fully when the guard stops.
4. **Small, each a few lines with a test, else leave recorded:** R4-3 — `Promise.all(held)` has no time limit: a child
   session that disappears before it answers `Fetch.enable` must not hang the guard's start (bound it; a child that
   never answers is dropped and noted). R4-4 — a nested cross-site frame already in the page (auto-attach on each
   attached child too).
5. Mutate what you add, under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
6. Records batched into your commits: HANDOFF's site-menu section and "Deferred" (R4-2: a box whose content exists only
   in the worker reads differently while the guard holds; what stays of R4-4; a dedicated worker already running; GETs
   by design) and the ledger ("Fix pass 4"); append what you defer to `evidence/site-menu/follow-ups.md`.
7. Gates: both typechecks, `npm run check`, `capture-opens-guards`, `capture-opens`, `capture-opens-styled`,
   `site-opens-more`, `site-opens-proof`, `site-check-opens`, `capture-matched-once`, the unit `web-press-guard`,
   `web-opens-read`, `site-opens-through` (each alone under the 4 GB cap, one Chrome job at a time), the offline B-Dry
   dry run (8G; the same 5 boxes, 0 non-GET requests, no other page asked for). Commit after each passing step (plain
   `git commit -m`, or `-F <file>`; no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only`
   without CLAUDE.md). Evidence in `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/fixer-4/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smn-f4/tmp`, a
separate one per script started at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close
every Chrome you start; a worktree's `node_modules` may lack `.bin` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). Scripts written with Write under `~/.cache/smn-f4/`.
SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). Waits
under 115 s.

## Report (as text)
`status: ready-for-review`, branch, last commit (full SHA), R4-1: verified?, the rule, the fix, tests, RED/GREEN paths,
mutation; step 4 done or left; gates; `found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable
only; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
