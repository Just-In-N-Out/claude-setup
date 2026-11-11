# Role: fixer (small): site-native-structure — re-record AC13's stale pins and name every named-only test's result

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review`, `engineering-best-practices`,
`test-driven-development`, the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
(with `references/testing-pitfalls.md`: the "stack move" line). Read
`/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first. Never load any live site;
never write to any WordPress site; touch nothing under `~/Downloads`. Commit to your branch only; don't push; don't bump
BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`.

## Finding (planner amendment 2, 2026-11-11)
AC13's cited test fails on head `2a38027faad44e16bcb885d264317d8be9df6f57` (branch `site-native-structure-stack6`): 8 of
144 pins differ. Not this job's change: the head's 144 plain-route hashes equal base `731707c5`'s, all of them; the pins
file `test/fixtures/site-native-pins.json` still holds `fd1986dc`'s hashes, and main's site-menu (`e16d3d1e`) reworded one
note of the fixture page's header (8 `pageCode` header hashes). Stack 6's gates ran it only as SKIP (named-only).
Receipts: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/planner-amend-2/receipts/`
(`pins-base-731707c5.json`, `ac13-pins-*.log`, `scripts/pins-cmp.ts`). The approved plan is now amendment 2
(`evidence/site-native-structure/plan-approved.md`, read-only; AC13's base is `git merge-base HEAD main`).

## Do
1. In your own worktree: `git checkout -B site-native-structure-stack7 2a38027faad44e16bcb885d264317d8be9df6f57`.
2. Re-record `test/fixtures/site-native-pins.json` from a `git archive` tree of base `731707c5` with
   `test/unit/lib/site-pins.ts` (the pins' own generator); it must equal `receipts/pins-base-731707c5.json` key for key.
   Bring the test's comment and skip message (they name `fd1986dc`) to the base; the test's name stays. RED: the test by
   name on `2a38027f` (`not ok`, 8 differ); GREEN on your head. Commit.
3. **Run every named-only AC test the approved plan cites, by name, with its variables set**, on your head (each alone
   under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, B-Dry 8G): each must print its own `ok N -
   <name>` line and no `# SKIP`. List each with its variables and result in
   `evidence/site-native-structure/fixer-5/named-only.md`. Any other stale pin: re-record the same way (from the base's own
   generator, proof that head equals base on the job-independent keys) and commit separately.
4. `npm run check` (8G scope) exit 0.
5. **If main has moved** (footer-icon-list's build commit, Build 2026-11-11.4: `git -C /home/justin/Documents/FigmaToBricksV2
   log -1 main`), rebase your branch onto the new main (one build commit: `src/shared/build.ts` and docs), keep both sides
   on any conflict (HANDOFF, CLAUDE.md never), rerun step 2's comparison with `receipts/scripts/pins-cmp.ts <head tree>
   <base tree>` and step 3, and report whether the rebase was pure.
6. Stop at `ready-for-review`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sn7/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (`pgrep -f
'[u]ser-data-dir=<path>'`; never `pkill -f`). Piped/chained git commands may be refused (script files, `bash <file>`;
`git -C <absolute path>`). Use `tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`.
SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending
SIG[A-Z]* to process'` first.

## Report (as text), stop at `ready-for-review`
Branch, head, base; RED/GREEN for AC13; the named-only table; any other pin re-recorded with proof; the rebase (if any) and
whether it was pure; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
