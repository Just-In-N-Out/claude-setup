# BUILDER brief: 86bcm9019-curate-skills [leorna]

**Role:** BUILDER for the Leorna story "86bcm9019-curate-skills" (ClickUp 86bcm9019, "Curate the skills collection"). Pipeline: **Full**. After you come reviewer 1 → fixer → reviewer 2 → fixer → verifier → blind AC auditor → finisher; each is a fresh Opus 5.5 xhigh agent. **You build, test first, and stop at `ready-for-review`.** You don't review your own work.

## Skills to load first, in this order (say so in your first steps)

1. `leorna`, BUILDER role (steps 2–5 + 4b).
2. `engineering-best-practices`.
3. `test-driven-development`: a failing test before each change.
4. `security-best-practices` (script review, path safety) and `mutation-testing-discipline` (prove the AC tests and guards can fail), as the plan's `## Skills` section names.
5. `systematic-debugging` whenever a test fails unexpectedly or a gate number gets worse. Find the cause; don't patch around it.

## The approved plan

- Plan: `/Users/justin/.hermes/plans/leorna/86bcm9019-curate-skills.md`. Read it whole; it is your build spec.
- Approved read-only copy: `~/.hermes/plans/leorna/evidence/86bcm9019/plan-approved.md`. Never edit it.
- **Justin's answers (2026-10-25): "go" with every ⭐.** A a, B a, C a, D a, E a, F a, G a, H a, as recorded under `## Justin's answers` in the plan. The plan is already written for those answers.
- ACs: **AC1–AC5** are the card's, each with the named test in the plan. **AC6 (proposed) (live)**, approved, is Justin's manual check of 3 skills × 3 tools. For AC6 you only produce the rendered folders (plan T14, `TestEvidenceSampledSkillsForManualCheck`, which writes into `evidence/86bcm9019/ac6-install/`). **Never write into Justin's real `~/.claude`, `~/.codex` or `~/.cursor`.**
- If the plan turns out wrong or is missing a decision, **stop and report** with `status: stopped` and the exact gap. Don't redesign. A planner fixes the plan.

## Where and how

- Repo: **leorna-control-plane only.** Branch `feat/86bcm9019-curate-skills` from a freshly fetched `origin/main`. Fetch over HTTPS through `gh`, as the `leorna` skill step 7.1 shows; the planner saw `5778350`. If main has moved, use the new tip and record it as the base. Worktree: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm9019-curate-skills` (plan T0). Don't touch local `main`, `deploy/local/` or any other worktree.
- Commit authorship: run `git commit -m "feat(86bcm9019): …"` only. The author must be `Justin Issa <justin@leorna.com>`; check with `git log -1 --pretty=format:'%an <%ae>'`. Never pass `-c user.*` or `--author`. No AI attribution or Co-Authored-By lines.
- Test DB: your own `leorna_86bcm9019_test`, created as the plan T0 says. Read the password through docker and never print it. Never drop another story's DB.
- Upstream: clone addyosmani/agent-skills at exactly `aeac41d4d005` (v0.6.13) into your scratch folder, never into a repo. Use the existing `library-upstream` tool as the plan says.
- **Never push, open a PR, merge, write to ClickUp, or touch `.github/workflows/*`.** The plan has no CI change.
- Scratch: keep everything in the scratchpad's `builder-86bcm9019/` subfolder and remove only that.

## Evidence (leorna 4b; Justin wants one screenshot per AC for ClickUp)

- Folder: `~/.hermes/plans/leorna/evidence/86bcm9019/builder/`. The `verifier/` and `auditor/` folders belong to later roles; don't create files there.
- Before-state captures before changing anything visible (plan T0/T14).
- AC1–AC5: one named test each, one screenshot each, `ac<n>-<what>.png`. For an AC with nothing visual, use a real Terminal window capture of the AC's own test run (command, PASS line, `EXIT=`), following the terminal capture recipe in the `leorna` skill. Also keep a log stamped with the head SHA.
- Gate logs per head: `gates-<sha7>.txt`, plus a `.json` receipt with `exit_code`.
- Show that each AC test fails on the base commit. Use a separate detached worktree, never your story worktree (`references/ac-verification.md` in feature-dispatch has the recipe).
- Inspect every screenshot. No server domain, URL, tenant ID, token or email may be visible.

## Gates (plan `## Gates`)

Run every gate in the plan on your final head. That includes `make check` with CI's pinned golangci-lint 2.14.0 and govulncheck v1.7.0, bound by absolute path; gitleaks 8.30.1; `LEORNA_TEST_DATABASE_URL` pointing at your `_test` DB with the Postgres tests confirmed as PASS, not SKIP; `bash ./scripts/test-module-add.sh`; and library-check. Keep the real output. A failure from a host tool, not the branch, is preserved and explained, never worked around in product code.

## Stop at `ready-for-review`

Stop when every task T0–T16 is done, the worktree is committed and clean (no untracked files), all gates exit 0 on the final head, and AC1–AC5 each have a passing test, a base-fail receipt and a screenshot. The AC6 folders must be rendered too.

## Rules

- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity).
- Rulings you had to make that the plan didn't fix go in `rulings[]`, so the reviewers can check them.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and in a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer. If you list any, end your report with `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON matching `{status: ready-for-review|stopped, stop_reason, branch, worktree, base, head, commits[], gates[{name, exit_code, log}], ac_status[{ac, accepted, test, screenshot, evidence}], ac6_folders, mutations, rulings[], found_else[], skill_lessons[]}`. Write in plain words.
