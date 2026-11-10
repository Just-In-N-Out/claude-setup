# Role: fixer (round 3, small: three hardening steps of the read-only guard from review 3's P3s): staging-fit-renderer

You are a fresh fixer for FigmaToBricksV2 (Fable 5.2, high). Review 3 was clean (no P0–P2). Three of its P3s concern
Justin's own rule for `site:live` — "Never write to any WordPress site; GET/read only" — and each has a smallest step
the reviewer named, so the main session has them fixed before the job is verified, test-first, in one small round. Then
stop at `ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`,
never push or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry
staging or any live site (local stand-in servers only); no logins; never write to any WordPress site. Nothing paid.
Nothing may hide that the tool's Chrome is automated.

**Skills to load:** `receiving-code-review` (verify each finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (the line "Holding a Chrome to read-only"), and the repo `CLAUDE.md`.

## Your copy (you start in your own worktree)
`git checkout -B staging-fit-renderer-fix3 b6bccface956c47689d5f687d280a6707c489cd8` (the reviewed head, branch
`staging-fit-renderer-fix2`), confirm `git rev-parse HEAD` and a clean status. Its base is the old `main`
`fd1986dcdbc8cf35f114b80be456e94279346743`; **don't rebase** (local `main` has moved to `3cfc54ac`; a later step rebases
this job onto a stack of other jobs). Report your branch; work only in your own copy.

## Inputs
- Approved plan (read-only, amended 1–3): `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/plan-approved.md`
  (AC2). Don't change the plan or any AC.
- Review 3: `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/review-3/review.json`, its probes
  (`probeA.ts`, `probeB.ts`, `probeE.ts`, `detached.js`, run scripts) and `logs/` in that folder.

## The three steps (each: verify, test first RED on `b6bccfac`, fix, GREEN)
1. **R3-1 (`tools/site-live.ts:115`):** only SIGINT, SIGTERM and SIGHUP run the closing. Since Chrome now has a process
   group of its own, Ctrl+\ (SIGQUIT) leaves it open and unguarded (80 POSTs in 3.5 s, 17 processes left; 0 at the
   round-2 head). Add SIGQUIT to the handled signals (exit 131). A parent's SIGKILL to the tool can't be handled:
   leave it recorded.
2. **R3-3 (`tools/site-live.ts:105`):** a Ctrl+C between Chrome starting and the handlers being set leaves the detached
   Chrome running. Register the handlers before `launchChrome` (they must cope with a Chrome that hasn't started or is
   starting).
3. **R3-2 (`tools/lib/read-only.ts:53`):** Chrome's own Reporting API uploads (`Reporting-Endpoints` / `Report-To` /
   NEL: the network service POSTs `application/reports+json` about 60 s after a report is queued, https pages only)
   pass the CDP Fetch guard. Launch the guarded Chrome with the Reporting features off
   (`--disable-features=Reporting,NetworkErrorLogging,DocumentReporting`, merged with any `--disable-features` the
   launcher already passes; only for the guarded launch, never for other `launchChrome` callers). Test: the reviewer's
   shape (a local https page with a self-signed certificate, `--ignore-certificate-errors` for that test launch only,
   naming a reports endpoint and breaking its own report-only CSP; the guard holding 70 s; the server received no
   POST). It is slow: put it where the slow web tests are and say how long it takes. Confirm the reading of a page is
   unchanged with the features off.
4. **R3-4 (test gaps), if cheap:** the closing tests don't fail when Chrome is ended with SIGTERM instead of SIGKILL or
   when a signal exits at once without the closing. Add an assertion that pins each only if a real difference can be
   observed on this Chrome; otherwise leave them as recorded.
5. Mutate what you add (the SIGQUIT handler removed; the handlers registered after launch; the features flag removed)
   under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
6. Records batched into your commits: HANDOFF's staging-fit-renderer section (the closing rule's signals, the Reporting
   line, "Deferred": a tool killed outright or by a group SIGKILL; `site:check` and capture have no guard — R3-5, Justin's
   to rule) and the ledger ("Fix pass 3").
7. Gates: both typechecks, `npm run check`, the 8 story files plus the new test (each exit 0, one Chrome job at a time),
   `report.json` of your head equal to `b6bccfac`'s on the same capture apart from the fields that must differ. Commit
   after each passing step (plain `git commit -m`, no author override, no AI or Co-Authored-By lines; `git diff --cached
   --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/fixer-3/` (logs `HEAD=` first, `EXIT=` last).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfr-f3/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run Chrome too: after each probe check
  by your own profile path that none of yours is left, and never signal a process group other agents' Chromes are in.
  Worktree `node_modules` may lack `.bin`: see testing-pitfalls. Run multi-step commands from a script file written
  with Write; keep scripts and logs under `~/.cache/sfr-f3/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); say so, find what grew, rerun under the cap.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, last commit (full SHA), per step: verified?, the fix, tests, RED/GREEN paths,
mutations; gates vs the reviewed head; `found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable
only; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
