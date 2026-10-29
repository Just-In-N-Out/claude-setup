# FIXER ("bring main in", round 2) — leorna-control-plane, story 86bcm901a "Curate agent definitions"

Role: FIXER, a fresh agent. While PR #97 was being re-verified, Yan merged PR #94 (86bcm9021, create items from templates) into `main`. Justin's words: "Can you double check that we don't have conflicts? Can you make sure that we're doing it on the main file?"

Your job:
- Merge the new `origin/main` into this branch.
- Prove the merged result works: #94 changed the library gate and CI, in the same areas as this story's tests.
- Stop at `ready-for-review` with the new head.

**Don't push.** That needs Justin's "push". Never merge into main.

## Facts
- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901a-agent-definitions`, branch `feat/86bcm901a-agent-definitions`.
- **Current head:** `55abda3d8d7d188692ff1032280d826d9e2be641`, verified and audited clean against the old main `db3406e`. It is local only; PR #97 on GitHub is still at `9c13e02`.
- **New `origin/main`:** `da8a4b08a841d9d4db4266abea1f937e5abc8cba`, which equals GitHub, fetched fresh by the main session. It is "Merge pull request #94". The main checkout's `main` is fast-forwarded to it.
- **Conflicts:** `git merge-tree --write-tree --name-only 55abda3 da8a4b0` exits 0, so there are no text conflicts.
- **What #94 changed** (`git diff --stat db3406e da8a4b0`: 24 files, +2243/−9). The paths near this story:
  - `.github/workflows/ci.yml`
  - `cmd/library-gate/ci_test.go`, the same package as this story's AC3 test
  - `delivery/stories.json`
  - `internal/library/gate/tenant.go` and `tenant_test.go`
  - admin item-creation code: "validate agent and prompt forms", agent templates
  - "fix(ci): build packaged scanner with patched Go dependencies". Check whether `go.mod`/`go.sum` changed.
- `$EV` = `~/.hermes/plans/leorna/evidence/86bcm901a/`. Round 2's verifier and auditor folders were moved to `$EV/round2-55abda3/`. Don't create `verifier/` or `auditor/`.

## Skills (load with the Skill tool and say so in your first steps)
`leorna` (FIXER role; do its Step 1 context load), `engineering-best-practices`, `git-commit-rules`, `test-driven-development` (if anything needs a fix).

## Tasks
1. **Re-fetch main** over HTTPS through gh (`leorna` step 7.1) and confirm `origin/main` is still `da8a4b0`. If it moved again, stop and report what landed.
2. **Check the worktree:** HEAD must be `55abda3` and `git status --porcelain --ignored` must be empty.
3. **Merge:** `git merge --no-ff origin/main`, a regular merge with no rebase, so no force-push is needed.
   - **If git reports a conflict,** stop, `git merge --abort`, and report it.
   - **Commit:** a plain `git commit` with a message like `merge(86bcm901a): bring main in after #94 (86bcm9021 item templates)`.
     - No `-c user.*`, no `--author`, no AI attribution line.
     - Never commit `CLAUDE.md`.
4. **Check the merged files by value:**
   - **`delivery/stories.json`:**
     - main's entries are unchanged, including #94's;
     - this story's entry is still last and still lists `[97]`;
     - `python3 -B -m unittest discover -s scripts -p 'test_story_shippable.py'` passes.
   - **`content.lock.json`:** it keeps every line from main and from `55abda3`.
   - **`.github/`:** `git diff --name-only origin/main...HEAD -- .github/` must still be empty. The workflow change is main's, not this branch's.
5. **Read #94's changes that touch this story's area:**
   - `internal/library/gate/tenant.go`;
   - `cmd/library-gate/ci_test.go`;
   - the admin validation for agent and prompt forms;
   - the CI workflow diff.

   Say in your report whether any of them changes how agent items are validated, rendered, gated or shipped, and whether CI now runs anything this story's tests must satisfy.
6. **Gates on the new head**, the full canonical set, run in a detached copy and never in the worktree:
   - `make check` with `LEORNA_TEST_DATABASE_URL`;
   - `bash ./scripts/test-module-add.sh`;
   - the Postgres tests, read per test from a `go test -json` stream over the whole DB packages (`./internal/cloud/dbcheck ./internal/store/postgres ./internal/web`), failing any skip whose reason names `LEORNA_TEST_DATABASE_URL`;
   - `make library-check`;
   - this story's AC1–AC4 tests, with AC4's `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks`, plus the `--version`, T8 upgrade and curation tests, plus `TestAC4CIRunsLibraryGateWithoutDroppingGates`;
   - 901b's AC tests: `TestAC1_NineUpstreamCommandsArePromptItemsWithSourceCommit`, `TestAC2_EachPromptRendersAsANativeCommandOrIsSkippedWithAReason`, `TestAC3_EachPromptFlagsTheSkillsItInvokesAsDependencies`, `TestAC4_EveryPromptPassesTheContentQualityGate`;
   - #94's new tests in `internal/library/gate` and `cmd/library-gate`, and its admin item-creation tests.

   Also:
   - If CI's workflow now runs a step that `make check` doesn't, run its local equivalent too and name it.
   - Bind golangci-lint 2.14.0 and govulncheck v1.7.0 through the Make variables (check whether #94 changed CI's pins), and use a task-local toolchain PATH.
   - Log every step to `$EV/gates-<newhead7>/` and `$EV/gates-<newhead7>.txt`, one `label EXIT=<rc>` line per step.
   - `TestSetupWizardWithPostgres` can time out under load. If it fails, run it alone and rerun it, and log both runs.

   **If a test fails because of the interaction between this story and #94,** fix it test-first, in a separate commit. If the fix would change behaviour, a test's meaning, an AC or a decision, stop and report it instead.
7. **At the end:** the tree is clean, and `git merge-base HEAD origin/main` = `da8a4b0`.

## Boundaries
- **Never:** push, open or edit a PR, post to ClickUp, merge into main, or touch the main checkout.
- **Other stories:** never touch their worktrees, branches, DBs or evidence. Reading refs is fine.
- **Postgres:**
  - Reuse `leorna-test-pg` and read its port with `docker port leorna-test-pg 5432`. Never touch `leorna-pg`.
  - Use only your own `leorna_86bcm901a_mainin2_test` DB, and drop it at the end.
  - Never print a URL or password.
- **Scratch space:** `/tmp` is a small shared tmpfs.
  - `TMPDIR`, the detached copy and caches go in `~/.cache/86bcm901a-mainin2/` (`mkdir`, no `-p`).
  - Small scratch goes in `/tmp/claude-1000/-home-justin-Leorna/6a5cb64a-ef1e-4913-b9a6-0011ebf1675e/scratchpad/86bcm901a-mainin2/` (`mkdir`, no `-p`).
  - Remove both at the end. Remove `git worktree add` copies with `git worktree remove --force`.
- **Waiting:** a foreground Bash call is moved to the background after 180 s, so split long waits into polls under 170 s each (a bounded `node -e` loop re-reading the log). Ending your turn to wait counts as finishing.

## Rules for every role
- If you find any other bug or problem, don't fix it or fold it in. List it in `found_else`, one line each, with evidence and severity.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.

## Report (final message)
- Status: `ready-for-review` or `stopped`, and why.
- The new HEAD SHA, the commit list since `55abda3`, the merge base (= `da8a4b0`), and `git diff --stat origin/main..HEAD`.
- What #94 changed that touches this story, and your conclusion for each item.
- The by-value checks: `stories.json`, the lock, `.github`.
- Every gate with its exit code and log path. The results of this story's tests, 901b's AC tests and #94's tests.
- `found_else[]` and `skill_lessons[]`.
- End with `MAIN SESSION: check and save these skill_lessons now.`
