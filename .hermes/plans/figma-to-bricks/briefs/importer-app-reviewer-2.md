# Role: reviewer (round 2, FIX review of fixer 1's commits; report only): importer-app

You are a fresh reviewer who never saw the build or the fix (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no
agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive
-o <absolute path>`, extract separately; scripts with the Write tool, no heredocs). Never load any live site; no logins; never write to any
WordPress site; never call alttext.ai (only `test/fixtures/wp-standin.ts`, local fixtures, a local alttext stand-in, a made-up password and
key). **Touch nothing under `~/Downloads`:** every test that clicks a download runs under a scratch HOME (the fix's `chromeAtHome()`).
**Importer rule:** a second review only checks the major fix; P0–P2 only for bugs a real use hits; a hole in the app's guards is P0/P1.
Keep it to about 30–45 minutes.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/plan-approved.md` (AC1–AC20; AC20 live).
- Review 1 (full, at `de1a5969`): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/review-1/review.json`.
- Fix 1: branch `importer-app-fix1`, head `f2399d4ed48b1f80c957e3829f2a0dfbcd36ceb8` (`git checkout --detach f2399d4e…`); review
  `git diff de1a5969..f2399d4e` and what it touches. Fixer's evidence: `~/.hermes/plans/figma-to-bricks/evidence/importer-app/fixer-1/`.
  Claims: R1-1 `--no-ai-alt` whenever no usable key is saved; R1-4 stdout/stderr error listeners so a dead terminal (EIO) doesn't end the
  app before cleanup; R1-6 a scan opens with its own site and user; R1-7 a command-line folder's route read from its notes; R1-3 the copy
  test's Chrome under its own HOME; R1-9 the S11 wording. Rulings 1–3 (not yet confirmed) in HANDOFF.

## Check hardest
1. R1-1 on every path: key file missing, empty, broken, valid; box ticked or not; the upload never meets the hidden key question.
2. R1-4 with a real pty (`script -qfec`) killed mid-scan, several runs: 0 processes left, previews folder gone; no new path where the app
   keeps running headless with a job and no terminal mark.
3. The guard mutants (g1–g10, p1–p4, r1, c1, c2) still killed on the head; nothing in the fix weakens Host/Origin/key/terminal checks.
4. AC17: without the app's marks `site:upload`/`site:import` byte for byte the base.
5. The S11 wording now keeps the standing rules' meaning (repo CLAUDE.md "One uploader writes to WordPress…").

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/review-2/review.json` (round 2, scope of the fix commits from
`de1a59697adcf564f213d5b17c47d576c3481398`; full SHA `head`), in review-1's format; self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
7f54b0a59f88f3ca4404b6f14bba3b5abea9dcd8 /home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app` and quote its last line; if it
asks for another scope, follow it and say so. Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly; not linked) with `references/testing-pitfalls.md`; read both
`repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/iar2/t1`); scripts under `~/.cache/iar2/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`
(B-Dry 8G). A git-archive tree has no repo (set `GIT_DIR` inside a runner for tests reading `git show`) and no `dist/`. Use `tail -n 3`. Waits
under 115 s in foreground poll chunks (never end your turn to wait). After SIGTERM/143/137/"Killed" check earlyoom's log and `journalctl
--user | grep -E 'oom-kill|OOM killer'`.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; each fix claim: holds or not; Bricks-pro notes; `verdict`;
`ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
