# Role: fixer (round 2: R2-1): capture-speed

You are a fresh fixer for FigmaToBricksV2 (Opus 5.5, high). Fix review 2's P2 finding R2-1 test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push
or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. **Never load bdryswi.com** (AC11 is Justin's
live run); no logins; never write to any WordPress site. Nothing paid. Nothing may hide that the importer's Chrome is
automated (repo CLAUDE.md).

**Skills to load:** `receiving-code-review` (verify the finding before fixing), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`, and the repo `CLAUDE.md`.

## Inputs
- Work in `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a37633bdd2f67cfdd`, branch `capture-speed-build`,
  head `e6437fb7004876bcfa25e5ed011ab420dcdca9d8`, base local `main` `7ff9ba4aa7f03e3c761a8814fb1ad4021dd51373` (check
  `git rev-parse main`; if main moved, stop and report — don't rebase).
- Plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-speed/plan-approved.md` (AC5, Q3 A).
- Review: `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-speed/review-2/review.json` (R2-1 P2; R2-2…R2-4 P3).

## Work
1. **R2-1:** a page load answered from the kept page (`replay.ts` `answerFrom`, `Fetch.fulfillRequest`) never fails its
   navigation, so a dropped connection during later ranges goes unseen and the range is read from a half-loaded page.
   General rule: while a page load runs (kept or asked), a network-level failure of the page's own requests (e.g.
   `Network.loadingFailed` / Fetch's `responseErrorReason` with ERR_INTERNET_DISCONNECTED, ERR_NAME_NOT_RESOLVED,
   ERR_CONNECTION_*, ERR_NETWORK_CHANGED, ERR_ADDRESS_UNREACHABLE) counts like a failed navigation: the same tries (10 s,
   then 30 s) and then `PageUnreachable` with its one plain line. A single failed third-party request (an ad, a tracker
   blocked by the site) must not stop a capture: choose which requests count (the page's own origin, stylesheets, its
   pictures), and say your rule. Test first: a web test where replay is on (`F2B_REPLAY=local` or the test's way) and the
   stand-in starts refusing the page's own stylesheet/pictures after the first range — RED on `e6437fb7`, then GREEN; and a
   guard case where only a third-party request fails and the capture carries on. Mutate the guard.
2. Put R2-2, R2-3, R2-4 in `evidence/capture-speed/follow-ups.md` and HANDOFF's capture-speed "Deferred" list.
3. Gates before stopping: both typechecks, `npm run check`, AC1 named (base = a `git archive` of main), AC4, AC5, AC6,
   AC8 and the human-check/capture-retry/capture-unreachable/capture-person-front web tests, `npm run test:web` file by file
   compared by name with fixer 1's receipts (`evidence/capture-speed/fixer-1/`; rerun only differing files on main). Rerun
   AC3's timing on the saved B-Dry page only if your change touches the reading path (say which).
4. Commit after each passing step (plain `git commit -m`, no author override, no AI or Co-Authored-By lines,
   `git diff --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-speed/fixer-2/` (logs with `HEAD=` first, `EXIT=` last).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/cs-f2/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run Chrome too. Close every Chrome you
  start (kill by its profile path if Node dies).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); B-Dry 4-window runs under `systemd-run --user --scope -p MemoryMax=6G -p MemorySwapMax=0`,
  everything else 4G; mutation runs always capped with a bounded `--test-timeout`.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, base, last commit (full SHA), R2-1: verified?, the rule, fix, tests, RED/GREEN paths,
mutation, gates, `found_else`, then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal;
never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
