# Role: fixer (round 2: review 2's R2-1, the read-only guard at the end of a run): staging-fit-renderer

You are a fresh fixer for FigmaToBricksV2 (Fable 5.2, high). Fix review 2's one P1 test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never
push or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging or
any live site (local stand-ins and saved files only); no logins; never write to any WordPress site. Nothing paid. Nothing
may hide that the tool's Chrome is automated.

**Skills to load:** `receiving-code-review` (verify the finding before fixing), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline` (this is a guard), `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (the line "Holding a Chrome to read-only"), the repo `CLAUDE.md` and
`reference/bricks/README.md`.

## Your copy (you start in your own worktree)
`git checkout -B staging-fit-renderer-fix2 b512ec6a4d0e5add0c29455190dbde3df8c1b9ff` (the reviewed head, branch
`staging-fit-renderer-fix1`), confirm `git rev-parse HEAD` and a clean status (after a machine restart, look for tracked
files of exactly 8388608 bytes and restore them). Base: local `main` `fd1986dcdbc8cf35f114b80be456e94279346743`. Report
your branch; work only in your own copy.

## Inputs
- Approved plan (read-only, amended 1–3): `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/plan-approved.md`
  (AC2 as amended: "every other request (a POST, PUT, DELETE, a beacon) is refused before it leaves"). Don't change the
  plan or any AC.
- Review 2: `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/review-2/review.json`, its probes
  `probe2.ts`/`probe2.log` (which closing step lets POSTs out) and `probe5.ts`/`probe5.log` (through `site:live` itself, 5
  of 5 runs, OK path and both exit-2 paths).

## The finding
**R2-1 (P1, `tools/site-live.ts:246`, repeats R1-3 with a new fact):** the read-only guard holds only while the tool is
connected to Chrome. The tool closes its tabs and then Chrome at once (lines 205–206, 246; the stop paths go straight to
246), so what the published page sends as it hides or goes (`navigator.sendBeacon`, a keepalive `fetch` on `pagehide` /
`visibilitychange`) reaches the published site, on the OK path and on every stop path, while `report.json` `readOnly`
says only the earlier ones were refused. Real use: a WordPress page with Burst Statistics, Matomo or Cloudflare Web
Analytics writes a time-on-page record on every `site:live` run, against Justin's "Never write to any WordPress site;
GET/read only".

The reviewer measured: tab closed then Chrome closed at once → 6 POSTs arrived; Chrome closed with the tab open → 1; tab
closed, 3 s waited, then Chrome closed → 0; the tab sent to `about:blank` first → 0.

## Work
1. Verify the finding yourself first (the reviewer's probes, or your own stand-in).
2. **Test first (RED on `b512ec6a`):** in `test/web/site-live.test.ts` (or a file beside it), a published stand-in whose
   page sends `navigator.sendBeacon` and a keepalive POST on `visibilitychange` and on `pagehide` (and one on `unload`
   if Chrome still fires it). Run `site:live` on the OK path, on the "no paste on the page" stop and on the login-page
   stop; then, at least 3 s after the tool's process has exited, assert the stand-in server received nothing but
   GET/HEAD/OPTIONS. Also assert `report.json` `readOnly` names the refused closing requests where a report is written.
3. **Fix, as a rule on every exit path** (one shared closing function, never per path): the page's tabs are emptied or
   closed while the guard still answers, the guard keeps refusing until nothing more comes (a bounded wait, measured,
   not a blind sleep where an event can say it is done), and only then does Chrome end; if a graceful `Browser.close`
   can itself release held requests, end Chrome without it. An error thrown mid-run (a crash, Ctrl+C / SIGINT, a
   timeout) must close the same way: a `finally`, plus a signal handler if the tool has none. The reading itself must
   not change (worst difference and the mapped counts as before).
4. Mutate the guard: with the new closing step removed (and, separately, with the wait removed) the new test fails;
   run mutations under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
5. `found_else`: the same closing pattern elsewhere in this job's tools (`tools/lib/read-only.ts` users). Don't change
   capture's own Chrome handling (another job); name it in your report if it has the same shape.
6. R2-2 and R2-3 are P3: leave them; they are already in `follow-ups.md`.
7. Gates before stopping: both typechecks, `npm run check`, the story's test files (the 7 the reviewer ran, each exit
   0), `test:web` file by file under the 4 GB cap compared by name with the reviewed head. Commit after each passing
   step (plain `git commit -m`, no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only`
   without CLAUDE.md). Evidence in `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/fixer-2/`
   (logs with `HEAD=` first, `EXIT=` last).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfr-f2/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run Chrome too: close every Chrome you
  start (kill by its profile path if Node dies). Worktree `node_modules` may lack `.bin`: see testing-pitfalls. Run
  multi-step commands from a script file written with Write, paths spelled out; keep scripts and logs under
  `~/.cache/sfr-f2/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); say so, find what grew, rerun under the cap.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, last commit (full SHA), R2-1: verified?, the rule, the fix, tests, RED/GREEN paths,
mutations, gates vs the reviewed head, `found_else`, then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable
only; empty is normal; `enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
