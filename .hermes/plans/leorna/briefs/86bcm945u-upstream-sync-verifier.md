# VERIFIER brief (read only): Leorna story 86bcm945u "upstream-sync" (Full pipeline, round 1)

Dispatched 2026-10-24. Model: Opus 5.5, effort xhigh. A fresh agent that never saw the build. Pipeline position: review 1 → fixer 1 → review 2 → fixer 2 → **verifier (you)** → blind AC auditor → `ac-check.sh` → hand-over.

## Your role

You are the independent **VERIFIER** for ClickUp card `86bcm945u`, "Upstream content sync + licence attribution". **Source is read-only:** change no source, make no commit, push nothing. Write only into `~/.hermes/plans/leorna/evidence/86bcm945u/verifier/` (and your own scratch folder). Leave the worktree committed and clean, with no untracked files: `ac-check.sh` fails on any.

## Skills to load first (with the Skill tool), and say so in your first steps

1. `leorna` (its VERIFIER notes, gates and hard rules).
2. `engineering-best-practices`.

No loaded or planned skill has a "Mandatory Validation and Agent Defect Loop" section, so there are no loop-skill gates beyond the project's own. Then read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and follow its **VERIFIER** part exactly. Also read the `ac.json` format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

## What you verify

- Worktree: `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm945u-upstream-sync`, branch `feat/86bcm945u-upstream-sync`
- **Head** `73edc52abd4608923428ff7590dc3259abc60129`
- **Base** `6e74ced843642439d1dac9f25673440fb0f285f5`. Confirm it with `git -C <worktree> merge-base HEAD origin/main`. If it differs, use the real merge-base and say so.
- Approved plan (the contract; ACs AC1–AC7, no `(live)` ACs): `~/.hermes/plans/leorna/evidence/86bcm945u/plan-approved.md`
- The review rounds, for you to confirm closed:
  - Review 1: `~/.hermes/plans/leorna/evidence/86bcm945u/review1/review1.md` (findings F1–F6). Fixer 1's dispositions are in `fix1/` and the "Fix 1" section of `INVENTORY.md`. Fix commits: 22e2703, 1deb75a, 3eecae7, bc23303.
  - Review 2: `review2/review2.md` (R2-F1 minor: untested per-upstream filters; R2-F2 nit: NEXT STEP wording). Fixer 2's dispositions are in `fix2/` and the "Fix 2" section of `INVENTORY.md`. Fix commits: 446fd80, 73edc52.

## What to do

1. **Re-run the project's gates yourself** on head, in your own detached worktree, e.g. `git -C ~/Leorna/leorna-control-plane worktree add --detach ~/.hermes/cache/scratch/86bcm945u-verifier/head 73edc52`, with your own Postgres database whose name ends in `_test`. Never share or drop another agent's database. The gates are `make check` (CI's golangci-lint version bound by absolute path, as the `leorna` skill says; confirm the Postgres tests really ran) and `bash ./scripts/test-module-add.sh`. Remove your worktrees when done.
2. **Confirm every review finding is closed**: F1–F6 and R2-F1, R2-F2. Look for regressions the fixes caused. Don't trust the fixers' or reviewers' summaries; check the code and run what you need.
3. **AC work** (`ac-verification.md` → VERIFIER), for every AC from AC1 to AC7:
   - Run the AC's own test command exactly as the approved plan names it, on head, from the builder's worktree (read-only), using the log recipe in `ac-verification.md`. Write `verifier/ac<n>-<head7>.log`. AC2 needs `LEORNA_TEST_DATABASE_URL` (your own `_test` DB); AC7 needs `LEORNA_TEST_UPSTREAM_NETWORK=1`. A skipped test, subtests included, means not accepted.
   - Run the same test on the **base** in a separate detached copy with head's versions of that AC's test files (the recipe's four lines, one AC at a time). Write `verifier/ac<n>-base-<base7>.log`. It must fail there: its own fail line, or a build failure of the new code. An AC that keeps existing behaviour gets `base_exempt` with a reason instead.
   - **Take your own screenshot per AC** into `verifier/`: a real PNG. AC2 is the real admin "Third-party content" page from the built server, with no real host in a URL bar. The others are a real terminal-window capture of that AC's own test run, showing the command, output and exit code (`leorna` step 4b has the recipe; check the first command is still on screen). Look at each image. No server domain, tenant ID, token, email or password may be visible. Don't reuse the builder's screenshots: every receipt you cite must be inside `verifier/`.
   - Write `verifier/ac.json` in the format at the top of `ac-check.sh`.
4. Leave the builder's worktree committed and clean.

## Rules

- Write nothing to ClickUp, push nothing, touch no server. Never put a server domain, URL, tenant ID or token in your report or logs. Use `perl -pi`, not `sed -i`, for any in-place redaction (BSD sed), and grep afterwards to confirm.
- **Other problems outside this story:** list each in `found_else` (one line, evidence, severity).
- **Skill lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer.

## What to return

`{verdict: clean|findings, findings[{id, severity, claim, evidence}], closure[{id, closed, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], gates (command → exit → log), head, base, ac_json_path, found_else[], skill_lessons[]}`.

`clean` requires every AC accepted on head `73edc52` (none is `(live)`) and no open critical or major finding.

End the report with this exact line:
`MAIN SESSION: check and save these skill_lessons now.`
