# AC AUDITOR brief (blind, read only): Leorna story 86bcm945u "upstream-sync"

Dispatched 2026-10-24. Model: Opus 5.5, effort xhigh. A fresh agent that has seen nothing of this story's build, reviews or verification.

## Your role

You are the blind **AC AUDITOR** for ClickUp card `86bcm945u`, "Upstream content sync + licence attribution". Prove every acceptance criterion yourself, from the approved plan and the code alone. **Source is read-only:** change no source, make no commit, push nothing. Write only into `~/.hermes/plans/leorna/evidence/86bcm945u/auditor/` (and your own scratch folder). Leave the worktree committed and clean, with no untracked files.

**Stay blind.** Don't open anything else in `~/.hermes/plans/leorna/evidence/86bcm945u/`: not `verifier/`, `review1/`, `review2/`, `fix1/` or `fix2/`, not `INVENTORY.md`, and not the builder's screenshots, logs or receipts. Don't read other briefs in `~/.hermes/plans/leorna/briefs/`. Your only inputs are the four items below. Your folder must share no file with any other agent's folder: take your own screenshots and run your own checks.

## Skills to load first (with the Skill tool), and say so in your first steps

1. `leorna` (gates, evidence rules and hard rules).
2. `engineering-best-practices`.

Then read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and follow its AUDITOR / AC-work part (the folder rules, the run recipe on head and on base, screenshots, `ac.json`). Read the `ac.json` format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

## Your four inputs

1. **Approved plan** (the contract; ACs AC1–AC7, none `(live)`): `~/.hermes/plans/leorna/evidence/86bcm945u/plan-approved.md` (read-only).
2. **Worktree:** `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm945u-upstream-sync` (branch `feat/86bcm945u-upstream-sync`).
3. **Head:** `73edc52abd4608923428ff7590dc3259abc60129`. Confirm the worktree is at it.
4. **Base:** `6e74ced843642439d1dac9f25673440fb0f285f5` (merge-base with `origin/main`). Confirm it with `git -C <worktree> merge-base HEAD origin/main`; if it differs, use the real one and say so.

## What to do, for every AC from AC1 to AC7

1. **Host check first:** run `df -h /`. If less than about 5 GB is free, stop and report it as a host blocker rather than running builds that will fail for disk reasons. A run that fails across many unrelated packages with "no space left on device" or "open …/go-build/…: no such file or directory" is a host failure, not a code failure: keep that log under a suffixed name and rerun once.
2. **Read the AC and the code** and decide for yourself whether the code meets the AC as the plan words it. A passing test that doesn't actually check what the AC says is not acceptance.
3. **Run the AC's own test command** exactly as the plan names it, on head, from the worktree (read-only), using the `ac-verification.md` log recipe. Write `auditor/ac<n>-<head7>.log`. AC2 needs `LEORNA_TEST_DATABASE_URL` pointing at your own Postgres database whose name ends in `_test` (the `leorna-test-pg` container; never share or drop another agent's database, and keep the URL out of every log). AC7 needs `LEORNA_TEST_UPSTREAM_NETWORK=1`. Any skipped test or subtest means not accepted.
4. **Run the same test on the base** in a separate detached copy with head's versions of that AC's test files (the recipe's lines, one AC at a time). Write `auditor/ac<n>-base-<base7>.log`. It must fail there: its own fail line, or a build failure of the new code. An AC that keeps existing behaviour gets `base_exempt` with a reason instead. Remove the copy when done.
5. **Take your own screenshot per AC** into `auditor/`, as a real PNG:
   - AC2 is the real admin "Third-party content" page, served by a control-plane binary you build from head, with no real host in a URL bar. The plan and the `leorna` skill describe how to sign in locally in dev mode with a throwaway `_test` DB.
   - Every other AC is a real terminal-window capture of that AC's own test run, showing the command, output and exit code (`leorna` step 4b recipe; check the first command is still on screen).
   - Look at each image: no server domain, tenant ID, token, email or password may be visible.
6. Write `auditor/ac.json` in the format at the top of `ac-check.sh`.
7. Leave the worktree committed and clean, and remove your scratch worktrees and databases.

## Rules

- Write nothing to ClickUp, push nothing, touch no server. Use `perl -pi`, not `sed -i`, for any in-place redaction (BSD sed), then grep to confirm. In cleanup commands use literal paths or `"${VAR:?}"/…`, never an unguarded variable glob.
- **Other problems:** list each in `found_else` (one line, evidence, severity).
- **Skill lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer.

## What to return

`{verdict: clean|findings, ac_status[{ac, accepted, test, screenshot, evidence}], findings[{id, severity, claim, evidence}], head, base, ac_json_path, found_else[], skill_lessons[]}`.

`clean` requires every AC accepted on head `73edc52`.

End the report with this exact line:
`MAIN SESSION: check and save these skill_lessons now.`
