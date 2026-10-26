# VERIFIER brief (round 5, after the rebase onto PR #88): 86bcm901u-quality-gate-v3 (Leorna, control plane)

You are the **VERIFIER (read only)** for the Leorna story **Content quality gate (CI)**, ClickUp card `86bcm901u`. Model: Opus 5.5, effort xhigh. You are a fresh agent that never saw the build or the fixes. **Change no source.** Write only into `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/verifier/` (empty for you) and your own scratch. Justin asked for a **full re-verify** on the new head before anything is pushed.

## Context

- The story was verified clean and AC-accepted on head `f7dff509de5053d647084b2f6171262b91f005c9` (base `6275a4e`): verifier round 4 (`…/verifier-r4/`, incl. a focused review) and the blind auditor (`…/auditor-r1/`), `ac-check.sh` → `READY FOR THE USER`. You may read `verifier-r4/` for what was proven; don't copy its receipts.
- Then **PR #88 (86bcm901v, Library catalog browser) merged**; GitHub `main` is now **`b446a89caa98b180148179dd732cbf0594df5ee9`**. Justin chose "Rebase onto new main". Fixer 7 rebased: new head **`0cf18f10796d067782eee4069eb41089cdb5acd1`**, local backup `backup/86bcm901u-v3-pre-rebase-3` = `f7dff50`. The only conflict was `delivery/stories.json` (main's file kept; this story's entry appended last). Fixer 7 says the story's patch outside `stories.json` has the same patch-id as `f7dff50`'s and every story source file is byte-identical. Its receipts: evidence root `gates-0cf18f1.*`, `base-ac-runs-b446a89.txt`, `mutations-fix-7-0cf18f1.txt`, `fix-7-story-checks-0cf18f1.txt`, `INVENTORY.md` (Fixer 7 section). Don't trust; re-prove.

## 0. Disk and shared machine

About 6 GB free; other sessions write too. `df -h /` before heavy gates; under 3 GB stop with `verdict: blocked`, reason `disk`. Never run `go clean -cache`. A gate failing with "open …/go-build/…: no such file or directory" across unrelated packages is a host problem: keep the log under a suffixed name and rerun. Compare GitHub main (`gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`) with `b446a89` at the start and before your AC runs; if it moved, say so (don't rebase). Delete your scratch and containers at the end.

## 1. Skills to load first (say so in your first steps)

1. `leorna`: the **VERIFIER** role.
2. `engineering-best-practices`
3. `api-contract-drift-guard` and `backend-data-migrations`: as the Agent Defect Loop's independent verifier, run their validation (contracts check, empty contract and migration diff vs base, `TestMigrationRoundTrip` green).
4. `security-best-practices`, `mutation-testing-discipline`
5. Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the report format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

## 2. What you verify

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v3`, branch `feat/86bcm901u-quality-gate-v3`, head `0cf18f1…` (clean, no upstream). Never edit, commit or leave files in it. **Base:** `b446a89…` (`git merge-base HEAD b446a89` must print it).
- **Approved plan (the contract):** `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md` (its "on base `6e74ced`" notes predate the rebases: use `b446a89`). Decisions since approval: live plan `~/.hermes/plans/leorna/86bcm901u-quality-gate-v3.md` → "Justin's answers", "Away grant", "Away-grant picks".
- **ACs:** AC1–AC4 proven; **AC5 `(live)`**: `"accepted": false, "not_run": "live: needs a push and the gh token's workflow scope, both Justin's"`.

### Checks

1. **The rebase is pure:** `git range-diff 6275a4e..backup/86bcm901u-v3-pre-rebase-3 b446a89..HEAD`, patch-id comparison of `6275a4e..f7dff50` vs `b446a89..0cf18f1` outside `delivery/stories.json`, and byte-identity of every file the story changes (except `stories.json`). If true, round 4's closures and review hold on this code; spot-check three of them on a gate you build from `0cf18f1` (a `%PDF-` secret found; a scan copy over 100,000 bytes stops with exit 2; one CI/Make weakening fails AC4). If not true, review the differences as a reviewer would.
2. **`delivery/stories.json`:** valid JSON, main's entries (incl. `86bcm901v`'s `prs: [82, 88]`) unchanged, `86bcm901u` appended last with an empty PR list, bytes equal `json.dumps(data, indent=2)` plus a newline.
3. **Interaction with PR #88:** #88 added Go code to `internal/library` (catalog, preview) and web/store changes. Confirm the story's gate and tests are unaffected and #88's tests pass on this head; `make library-check` passes on main's real library (10 items); `go.mod`/`go.sum` hold both new dependencies.
4. **Gates on `0cf18f1`** (the plan's Gates/T10): CI's golangci-lint 2.14.0 by absolute path (echo its `--version`), govulncheck v1.7.0, `make check` with Postgres on **your own** DB `leorna_86bcm901u_v3_verify5_test` (create it; URL `postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_86bcm901u_v3_verify5_test?sslmode=disable`; confirm Postgres tests ran with `-v`, incl. #88's `…WithPostgres` tests), `bash ./scripts/test-module-add.sh`, `gitleaks git --log-opts=HEAD`, `make library-check`, the loop skills' validation, and `.github/` = `ci.yml` only with 5 added / 0 deleted vs `b446a89` (story-only CI exception). Logs with exit codes in `verifier/`. Drop only your DB.
5. **AC work, exactly as `ac-verification.md` says,** all receipts in `verifier/`: each AC's own test command on head (`HEAD=` first line, `EXIT=` last, `LEORNA_TEST_GITLEAKS_BIN` set so nothing skips) and on base `b446a89` in your own detached copy with head's test files copied in per the Go rule (only the AC test's file plus the test files of new packages it imports; `[setup failed]` doesn't count). Use a `#!/opt/homebrew/bin/bash` script for loops (zsh arrays start at 1 and don't word-split). **One real screenshot per AC1–AC4, taken by you** (Justin's rule; these may go to ClickUp): the `leorna` Terminal capture recipe (clean `env -i … TERM=xterm-256color … bash --norc --noprofile`, wait up to 90 s for the first prompt, commands as osascript argv, nothing secret on the launch line, count `EXIT=` after `clear`, first command on screen, close the window by id in a trap). Inspect each. Write `verifier/ac.json` (format at the top of `ac-check.sh`, `head` = full `0cf18f1…` sha) and self-check it blind: `cp` your report, logs and images to scratch outside the evidence tree, run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh --repo <worktree> --base b446a89caa98b180148179dd732cbf0594df5ee9 --plan ~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md verifier/ac.json <scratch>/ac.json`, then delete the copy. Expected: `READY FOR THE USER` (AC5 owed).
6. The convergence rule from the live plan still applies: further P3 test-sensitivity findings in the CI/Make-weakening class go under `found_else`; P0–P2 anywhere or any AC not accepted is a finding.

## 3. Boundaries

- Read only: no source edit, commit, push, PR, merge, remote CI, token change, ClickUp write. Don't touch the `backup/*` branches (read only).
- Don't read or write `auditor*/`; don't edit `plan-approved.md`; don't write into the evidence root, `handover/`, `review-*/` or `verifier-r*/`.
- Don't touch: local `main`, other worktrees, DBs and scratch (`leorna_86bcm901u_v3_test` is the builder's), `deploy/local/`.
- Never print tokens; never write a server domain, URL or tenant ID.
- Justin is back (the away grant has ended): give every finding a recommended fix; the main session asks him if a decision is his.
- **Found something outside this story?** `found_else`. **Skill lessons:** don't edit skills or memory; list them in `skill_lessons[{skill, lesson, evidence}]` (empty is normal).

## 4. Your report

Return JSON-shaped output: `{verdict: clean|findings|blocked, head, base, github_main_at_end, rebase_pure: true|false, rebase_evidence, stories_json_ok, pr88_interaction, findings[{id, severity: P0|P1|P2|P3, claim, evidence, recommended_fix}], ac_status[{ac, accepted, test, screenshot, evidence}], ac_json, ac_check_self_check_last_line, gates[{name, log, exit_code}], defect_loop_skills[], disk_free_at_end, found_else[], skill_lessons[]}`. `clean` requires no P0–P2 finding and AC1–AC4 accepted (AC5 `not_run`). End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
