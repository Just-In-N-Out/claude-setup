# Role: fixer (round 7: review 8's R8-1 — the socket gate blames the wrong page's press): site-menu

Review 8 (a delta of fix pass 6) confirmed that sockets are blocked while the capture presses and that a pop-up's own
pictures go up, and left one P2. The referee asked Justin ("only P2 left from round 3 on (R8-1): fix or
follow-up?"); he chose **"Fix it (Recommended)"** (`evidence/site-menu/review-8/justin.json`).

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). Fix R8-1 test-first, then stop at
`ready-for-next-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`,
never push or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. **Never load bdryswi.com, B-Dry
staging, a widget vendor's host** or any live site (the capture runs only against local fixture servers and the
offline B-Dry stand-in site); no logins; never run `npm run site:upload` or any upload against anything but the tests'
own 127.0.0.1 stand-in; use no real login, password or key and never look for one. Nothing paid. Nothing may hide that
the importer's Chrome is automated.

**Skills to load:** `receiving-code-review` (verify the finding before fixing it; push back with evidence if it is
wrong), `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`.
Read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with
`references/testing-pitfalls.md` and `references/live-site-reading.md` ("Holding a Chrome to read-only": it ends with
fix pass 6's socket gate), and the repo `CLAUDE.md` in the main folder ("Build general logic").

## Your copy (you start in your own worktree)
`git checkout -B site-menu-fix7 86fc55467cb4b7892eed8f50f14fa50bf3ec042e` (the reviewed head, branch `site-menu-fix6`,
on main `11e885fda5d08863a5875f939085350c007ac732`, Build 2026-11-10.8). Check `git rev-parse main` before your final
gates: if main moved, rebase onto it (HANDOFF: this job's section first, then main's lines exactly as main has them;
the `<site-menu id at merge>` placeholders stay), say which commits conflicted, and report main's SHA as your review
base. Report your branch.

## Inputs
- Approved plan (read-only; amended): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md`
  (AC1–AC8; AC8 live).
- Review 8: `evidence/site-menu/review-8/review.json`; its probes and logs `~/.cache/site-menu-review8/`
  (`gate-shut-probe.ts` with the `loadonly` case; `probes/live-head-w4*.txt`, `live-nogate-w4-*.txt`,
  `live-head-w1*.txt`; `notes.md`). Fix pass 6's record: `evidence/site-menu/fixer-6/` and the ledger's "Fix pass 6".
  Deferred items: `evidence/site-menu/follow-ups.md` (R8-2, R8-3, R8-4 are recorded P3s: not yours unless your fix
  closes one for free — say so if it does; never widen the fix to chase them).

## R8-1 (P2), `src/web/press-guard.ts:113`
- **The finding:** the gate can't tell which page a refused socket came from, so `socket` records every refused
  connection or message against every page pressing at that moment (`for (const p of this.pressing) record(p, url,
  w)`). A same-site socket goes to `tried`, and a press that tried something counts for nothing and is never an
  opener at any width. With the default `--windows 4`, a site's own WebSocket in one page load (its hello or
  heartbeat, sent by no press) lands on another page load's press and deletes that box's opener: 3 runs out of 3 on
  the site-menu fixture plus one same-site socket that says hello and beats every 2 s; with no gate, and on review
  7's head, every opener is kept. At 1 window, 1 run of 2 lost a drawer's opener to the page's own heartbeat (the
  HTTP guard's accepted same-site timer class).
- **Verify it first** on the reviewer's probe (RED: an opener lost at 4 windows on your base).
- **Fix as a rule (the reviewer's direction; prove it or better it):** a gate refusal counts against a press only
  when that pressing page's own sessions reported the socket (`Network.webSocketCreated` / `webSocketFrameSent` on
  its twin, its frames and its workers); a refusal no pressing page claims is listed apart, as the stopped writes of
  another site are, and blames no press. **The guard must not get weaker:** the gate still refuses every new socket
  and cuts every sending one while any page presses (0 handshakes, 0 message bytes at the server from anything a
  press started: fix pass 6's tests and mutants G1–G6, P1–P5, L1–L2 still killed), and a socket a press itself
  opens or sends on still counts against that press, still named. Say what you decide, with a test each, for: a
  socket a pressing page's worker or cross-site frame opens (which sessions report it? a dedicated worker already
  running has no Network domain: what then — blame, list apart, or name as unknown; choose the side that never
  loses a guard and say what it costs in openers); a heartbeat on the pressing page's own socket opened at load (the
  1-window case: is "sent by the page's own timer, not by the press" tellable — by the frame's timing against the
  press, by the initiator? If not, say so and keep the HTTP guard's accepted class, recorded as a limit); two pages
  pressing at once, each with its own socket.
- **Tests:** a web test on the fixture with a same-site heartbeat socket at 4 windows and at 1: every box keeps the
  openers the no-socket fixture gives it (compare with the capture of the same fixture without the socket), run 3
  times in the test or with a deterministic trigger (a flaky proof is no proof: make the heartbeat land inside a
  press by construction); unit tests on the guard's bookkeeping (a refusal claimed by one of two pressing pages; one
  claimed by none; one claimed after the refusal arrives — the order of the gate's refusal and the session's event
  is not guaranteed: handle both orders). Each RED on your base by its own assertion.
- **Mutants** (4 GB cap; any that lets a socket through with networking off: `unshare -rn sh -c 'ip link set lo up &&
  exec unshare --user --map-user=1000 --map-group=1000 node --test …'`): every pressing page blamed again; no page
  ever blamed (a press's own socket no longer counts against it); the unclaimed list dropped from the notes; the
  claim matched by host only instead of the socket's address. Each killed by a named test.

## Gates before stopping
Both typechecks, `npm run check` (8G scope for the parallel unit suite); the guard set, each web file alone under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export variables first; no `--setenv=PATH`):
`capture-opens-guards` (twice, at low load), `capture-opens`, `capture-opens-styled`, `site-opens-more`,
`site-opens-proof`, `site-check-opens`, `capture-matched-once`, `site-upload-page`; unit `socket-gate`,
`web-press-guard`, `capture-chrome`; the capture's time on the site-menu fixture against your base (three runs each);
the offline B-Dry stand-in dry run reads the same five boxes with 0 requests that aren't a GET and 0 socket
handshakes (8G scope). Each log starts `HEAD=` and ends with one line `EXIT=`. Known flake: `capture-opens-guards`
"…it answers every request" (R4-5's boxes-equal comparison under load, F6-5): rerun alone before judging.

## Records
HANDOFF's site-menu section and the ledger ("Fix pass 7": the finding verified, the rule as built, RED and GREEN,
the mutants, what stays a limit); append what you leave to `evidence/site-menu/follow-ups.md`; the exact plan
sentence for the planner (the "Sockets" paragraph: how a refusal is charged) in the ledger. Commits: plain `git
commit -m` (or `-F <file>`), no author override, no AI or Co-Authored-By lines, `git diff --cached --name-only`
without CLAUDE.md. Evidence in `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/fixer-7/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sm-f7/t1`,
a separate one per script started at the same time; a Chrome profile under a long TMPDIR dies with "Socket path too
long"); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Several agents run Chrome, and Justin may run
his own: close every Chrome **you** start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`). A
worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
piped, chained or redirected git command is refused: one plain git command per call, `git -C <absolute path>`). Use
`tail -n 3`, never `tail -3`. One `bash <file>` per Bash call (scripts written with Write under
`~/.cache/site-menu-fixer7/`); run long gates on a scratch copy, never in the worktree while you edit it. SIGTERM /
143 / 137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). Waits
under 115 s. The PC restarted three times this week and agents were stopped by a usage limit twice: write each log's
`EXIT=` line; after a restart check `git status` and `git cat-file -t HEAD`, read your finished logs first.

## Report (as text; don't write report files)
`status: ready-for-next-review`, branch, base, last commit (full SHA) and the first fix commit; R8-1: verified or
not, the rule as built, each decided case with its test, RED/GREEN paths; the mutants and what killed each; what
stays a limit; gates vs your base; `found_else`; the plan sentence for the planner; then `skill_lessons[{skill,
lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending with: `MAIN
SESSION: check and save these skill_lessons now.`
