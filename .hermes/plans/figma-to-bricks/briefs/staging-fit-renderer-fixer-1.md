# Role: fixer (round 1: R1-1, R1-2, and GET-only): staging-fit-renderer

You are a fresh fixer for FigmaToBricksV2 (**Fable 5.2, high**). Fix review 1's two P2 findings and hold Justin's
"GET/read only" rule in `site:live`, test-first, then stop at `ready-for-review`. Never edit the main folder
`/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't bump `BUILD`, leave other
worktrees alone, start no agents. **Never load bdryswi.com** or any live site (your tests use local servers; `*.localhost`
resolves to loopback in Chrome); no logins; never write to any WordPress site. Nothing paid.

**Skills to load:** `receiving-code-review` (verify each finding before fixing), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`, and the repo `CLAUDE.md`.

## Your copy (you start in your own worktree)
`git checkout -B staging-fit-renderer-fix1 f32ed6c2c04af48935edccc6999d23bf41ffe670` (branch
`staging-fit-renderer-build2`, on local `main` `fd1986dcdbc8cf35f114b80be456e94279346743`); confirm HEAD and a clean
status (after a restart, restore tracked files of exactly 8388608 bytes). Check `git rev-parse main` is still `fd1986dc`
(if it moved, say so; don't rebase). Report your branch.

## Inputs
- Plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/plan-approved.md` (AC2, AC4).
- Review: `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/review-1/review.json` (R1-1, R1-2 P2;
  R1-3…R1-7 P3) and its probes beside it (`probe1..3.ts/.log`, `tests.log`).

## Work
1. **R1-1 (`tools/site-live.ts:200`):** an element the page holds in another's place (`differs`) is left out of both
   comparisons and never fails the run, so `site:live` prints OK / exit 0 on a page that visibly differs (a 386×300 box
   where the paste has a 50×50 icon). General rule: a page that doesn't hold the paste's element where the paste has it
   is a difference — each such element is named and the run fails (exit 1), unless its drawn box agrees with the
   capture's within the tolerance; nothing is "left out" silently. `test/web/site-live.test.ts:242` asserts the exit
   code. Keep AC4's flip-face explanation true (say in HANDOFF what the check now does with staging's swapped Code
   elements).
2. **R1-2 (`tools/site-live.ts:83`):** the old site's host is mapped to NOTFOUND with `MAP *.<host>`, and the published
   page's hostname is only dropped from the list, never excluded from the wildcard, so a published page on a subdomain of
   the old site's host (`staging.<client's domain>`, e.g. a capture of `growithgro.com` pasted on
   `…staging.growithgro.com`) can't be read. General rule: the published page's own host (and what it needs to draw) is
   always reachable; everything else under the old site's host stays unreachable. Test with `agency.localhost` /
   `client.staging.agency.localhost` (the review's probe 2).
3. **GET/read only (Justin's standing rule: "Never write to any WordPress site; GET/read only"; review's R1-3 and the
   WebSocket half of R1-4):** `site:live`'s Chrome lets the published page's own scripts send POSTs and beacons. Make
   the tool hold the rule itself: every request that isn't a GET (or HEAD/OPTIONS preflight) from that Chrome is refused
   before it leaves (Fetch at Request stage for all requests, not only those naming the old site), WebSockets too, and
   the report counts what was refused. The "GET only" test (`site-live.test.ts:132`) runs on a page whose script POSTs,
   beacons and opens a WebSocket, and asserts the server saw none.
   Test each first (RED on `f32ed6c2`, then GREEN); mutate each guard under the cap.
4. Put R1-4 (the host list), R1-5, R1-6, R1-7 in HANDOFF's staging-fit-renderer "Deferred" list (they are in
   `evidence/staging-fit-renderer/follow-ups.md`).
5. Gates before stopping: both typechecks, `npm run check`, AC1–AC4's tests, `test:web` file by file under the 4 GB cap
   compared by name with the builder's `evidence/staging-fit-renderer/builder/cont/gates/` (a `git archive` scratch copy;
   rerun only differing files on main).
6. Commit after each passing step (plain `git commit -m`, no author override, no AI or Co-Authored-By lines,
   `git diff --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/fixer-1/` (logs `HEAD=` first, `EXIT=` last).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfc-f/tmp`,
  its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Several agents run
  Chrome: close every Chrome you start. One `bash <file>` per Bash call (scripts written with Write); start long drivers
  with `setsid --fork` and wait on their final marker.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`) or a scope oom-kill (`journalctl --user`); heavy and mutation runs under `systemd-run --user
  --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits under 115 s.

## Report (as text)
`status: ready-for-review`, branch, base, last commit (full SHA), per item: verified?, the rule, fix, tests, RED/GREEN
paths, mutation; gates; `found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is
normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
