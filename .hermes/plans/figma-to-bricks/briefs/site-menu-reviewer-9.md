# Role: reviewer (round 9, a delta: fix pass 7, R8-1; report only): site-menu

You are a fresh reviewer who never saw the build or the fixes (**Opus 5.5, high**). Review only: change no source or
test, commit nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other
worktrees (read them with `git show`). Never load bdryswi.com, B-Dry staging, a widget vendor's host or any live site
(the capture runs only against local fixture servers; saved files otherwise); never write to any WordPress site; no
logins; never run `npm run site:upload` against anything but the tests' own 127.0.0.1 stand-in. Nothing may hide that
the importer's Chrome is automated. Justin may be running his own Chrome: never stop a Chrome you didn't start.

**Importer rule (Justin, 2026-11-02):** P0–P2 only for bugs a real site or normal use hits, each with a concrete
real-use scenario; edge cases are P3. **This job's guard is P0/P1 when it fails: while the capture presses a page's
buttons, no data-sending request, no page load a press starts, and no WebSocket handshake or message may leave**
(from the pressed tab, a window a press opens, a frame or a worker). From round 3 on the referee asks Justin when a
round leaves only P2: rate each finding exactly.

## What happened before you
Review 8 found R8-1 (P2): the socket gate (fix pass 6, `src/web/socket-gate.ts`, a SOCKS5 relay in the capture's own
process, shut by the press guard while a page presses) charged every refused socket to every page pressing at that
moment, so a site's own socket in one window deleted another window's menu opener (3 of 3 at 4 windows). Justin:
"Fix it" (`evidence/site-menu/review-8/justin.json`). Fixer 7 changed how a refusal is charged (the gate itself still
refuses and cuts as before): a refusal counts against a press only when that pressing page's own sessions reported
the socket (its second session, each frame and worker it holds — new children now wait attached until held and
watched —, each window a press opened), paired by kind and `host:port` within 2 s in either order, a report of a
known address before one of none (the "settle"); a refusal no pressing page claims blames no press and is listed apart
in the notes; a page with a child whose `Network.enable` isn't answered in 5 s is charged every unclaimed refusal,
saying so. Recorded limits: F7-1 (a page's own heartbeat inside its own press costs that press), F7-2, F7-3.

## Inputs
- Approved plan (read-only; amended): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md`
  (AC1–AC8; AC8 live). Its "Sockets" paragraph isn't amended yet (the fixer's draft is in the ledger's "Fix pass 7",
  "For the planner"): judge the fix against it and say whether the draft is true.
- Branch `site-menu-fix7`, head `058ec3ea04203d4793e862b1f882c7a1fdbb7695` (first fix commit `54a3cd53`), on review
  8's head `86fc55467cb4b7892eed8f50f14fa50bf3ec042e`, base main `11e885fda5d08863a5875f939085350c007ac732`. In your own
  worktree: `git checkout --detach 058ec3ea04203d4793e862b1f882c7a1fdbb7695`, confirm HEAD and a clean status. **Your
  scope:** `git diff 86fc5546..HEAD` (`src/web/press-guard.ts`, `src/web/read/opens.ts`, the tests, HANDOFF, ledger)
  and what it touches.
- The fixer's record (read, don't trust): `evidence/site-menu/fixer-7/` (`red-*.log`, `green-*.log`, `mutants/`,
  `r8-probe/`, `gates/`), `~/.cache/site-menu-fixer7/probe-sessions.ts` and its log; review 8's probes
  `~/.cache/site-menu-review8/` (`gate-shut-probe.ts`, the `loadonly` case); `evidence/site-menu/follow-ups.md` (F6-*,
  F7-*, R8-2..R8-4: don't re-report what is recorded unless you rate it higher, with a scenario).

## Check hardest
1. **The guard did not get weaker.** Every socket a press itself starts, from every place (the pressed page, a running
   dedicated worker, a new worker, a blob worker, a worker's worker, a cross-site frame, a nested frame, a window a
   press opens, a service worker), is still refused or cut at the gate (0 handshakes, 0 message bytes at your
   server), **and** still counts against that press (its box gets no opener from it) and is named. Find a way a
   press's own socket ends up "unclaimed" and so blames nothing: a report that never comes (a child that attaches
   after the refusal; a page whose twin is slow; a socket to an IPv6 literal or a name the resolver rules map, where
   the reported `host:port` and the gate's differ; a default port written or not; upper-case host; a trailing dot), a
   report that comes after 2 s, a page that opens many sockets at once so the pairing swaps them. Any such path where
   a press that tried to send counts as an opener is a P1 for this guard. Probe each on your own local page.
2. **R8-1 is closed:** review 8's `loadonly` probe on head (the site-menu fixture plus one same-site socket with a 2 s
   heartbeat) at 4 windows, 5 runs: every box keeps the openers the no-socket fixture gives it, apart from F7-1's
   recorded case (a page's own heartbeat inside its own press): measure how often, and say whether F7-1 is a fair P3
   for a real site (a chat or notifications socket with a 10–30 s heartbeat: try one) or must be higher.
3. **The new waits:** children now attach with `waitForDebuggerOnStart` and are held until watched; a page with a child
   that doesn't answer in 5 s. Can a page's frame or worker be left paused for good (a capture that hangs, a box
   read wrong because its frame never ran)? Every exit path lets them go. The capture's time on a fixture with frames
   and workers, base (`86fc5546`) against head at the same load, three runs each: a slow-down a person would notice
   is a finding.
4. **Nothing else moved:** pastes of the opens fixtures byte for byte as on `86fc5546` (by element id); the offline
   B-Dry stand-in reads the same five boxes with 0 requests that aren't a GET and 0 handshakes (8G scope, if load
   allows; else say so).
5. **Gates:** both typechecks, `npm run check` (8G scope); unit `socket-gate`, `web-press-guard`, `capture-chrome`;
   web `press-guard-sockets` (three times), `capture-opens-guards` (alone, low load; F6-5 is a known flake in its
   "…service worker" cases: rerun alone before judging), `capture-opens`, `site-opens-proof`, `site-check-opens`,
   each alone under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`. Two mutants of your own under
   the cap, with networking off for any that lets a socket through (`unshare -rn sh -c 'ip link set lo up && exec
   unshare --user --map-user=1000 --map-group=1000 node --test …'`): the 2 s window widened to forever; the address
   compared without the port.

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` ("Holding a Chrome to read-only"). Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/review-9/review.json` (round 9, a delta from review 8's
head `86fc5546`; `head` the full SHA of your HEAD), then self-check:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
11e885fda5d08863a5875f939085350c007ac732 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu` (exit 2 means
your file is wrong: fix it).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sm-r9/t1`, a
separate one per script started at the same time; a Chrome profile under a long TMPDIR dies with "Socket path too
long"); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` (one Chrome job at a time, closed after: stop
it by the PIDs of its own profile path; never `pkill -f <pattern>`); a worktree's `node_modules` may lack `.bin`, and
a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
piped, chained or redirected git command, a heredoc or a shell function is refused: write such steps to a script file
with Write and run `bash <file>`; `git -C <absolute path>`). Use `tail -n 3`, never `tail -3`. Scripts under
`~/.cache/site-menu-review9/`. SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
short-iso | grep sending`). The machine is loaded by other jobs (load 20–60): time base and head alternately at the
same load. Waits under 115 s. The PC restarted three times this week: keep notes and finished probe results on disk;
when resumed, read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario) or "none"; the guard table (each place a press's own
socket can start → reached the server? counted against the press? named?); R8-1 closed or not (the `loadonly` runs);
F7-1's rate with a realistic heartbeat; the waits and the time; whether the fixer's plan sentence is true;
`verdict`; `ac_status`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or
memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
