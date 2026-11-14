# Role: reviewer (round 3, FIX review of fixer 2's commits; report only): importer-app

You are a fresh reviewer who never saw the build or the fix (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no
agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive
-o <absolute path>`, extract separately; scripts with the Write tool, no heredocs). Never load any live site; no logins; never write to any
WordPress site; never call alttext.ai (only `test/fixtures/wp-standin.ts`, local fixtures, a local alttext stand-in, a made-up password and
key). **Touch nothing under `~/Downloads`:** every test that clicks a download runs under a scratch HOME (the fix's `chromeAtHome()`).
**Importer rule:** a second review only checks the major fix; P0–P2 only for bugs a real use hits; a hole in the app's guards is P0/P1.
Keep it to about 20–30 minutes.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/plan-approved.md` (AC1–AC20; AC20 live).
- Review 2 (at `f2399d4e`): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/review-2/review.json` (R2-1 P2: the site and
  user boxes reset to the scan's saved values after any job; Justin chose "Fix now").
- Fix 2: branch `importer-app-fix2`, head `7ff5f664abec6005c5cd5b083c7bd2b06bf70c46` (`git checkout --detach 7ff5f664…`); review `git diff
  f2399d4ed48b1f80c957e3829f2a0dfbcd36ceb8..7ff5f664` and what it touches. Fixer's evidence: `~/.hermes/plans/figma-to-bricks/evidence/importer-app/fixer-2/`
  (a head start, not proof). Claims: `page/upload.ts` fills the boxes only when a different scan is opened (`r.id !== row?.id`); a web test
  types a site, runs List pictures and a failed Log in and check, opens another scan and back; rulings (not yet confirmed): a re-open of the
  same scan never fills, going from no scan to a scan always fills.

## Check hardest
1. R2-1 on every path a person takes: List pictures, a failed and a passing Log in and check (stand-in only), an upload that writes a new
   importer.json, opening another scan and back, a scan with no saved site, a page reload: the boxes never switch to another site's values
   behind the person's back, and the yes question names the site.
2. The new test fails on f2399d4e on its own assertion (not a timing read); the guard mutants (g1–g10, p1–p4, r1, c1, c2) still killed.
3. AC17: without the app's marks `site:upload`/`site:import` byte for byte the base.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/review-3/review.json` (round 3, scope of the fix commits from
`f2399d4ed48b1f80c957e3829f2a0dfbcd36ceb8`; full SHA `head`), in review-1's format; self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
7f54b0a59f88f3ca4404b6f14bba3b5abea9dcd8 /home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app` and quote its last line; if it
asks for another scope, follow it and say so. Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly; not linked) with `references/testing-pitfalls.md`; read both
`repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/iar3/t1`); scripts under `~/.cache/iar3/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`
(B-Dry 8G). A git-archive tree has no repo (set `GIT_DIR` inside a runner for tests reading `git show`) and no `dist/`. Use `tail -n 3`. Waits
under 115 s in foreground poll chunks (never end your turn to wait). After SIGTERM/143/137/"Killed" check earlyoom's log and `journalctl
--user | grep -E 'oom-kill|OOM killer'`.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; each fix claim: holds or not; Bricks-pro notes; `verdict`;
`ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
