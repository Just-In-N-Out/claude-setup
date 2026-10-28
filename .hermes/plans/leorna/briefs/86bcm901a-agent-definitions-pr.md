# FINISHER ("make a PR") — leorna-control-plane, story 86bcm901a "Curate agent definitions"

Role: FINISHER, a fresh agent. Justin said "make a PR" on 2026-10-28: "I want you to make the PR, put it on GitHub, and tell me which file it is or what repo it is. We may have to rerun verifications, auditors, and AC checks on the new head, all right."

That authorizes **push + open a PR**, and nothing more:
- never merge;
- never post to ClickUp;
- don't make the `stories.json` PR-number commit, which needs his separate "push".

Follow the `leorna` skill's "Doing a story" step 7, sub-steps 1–7, exactly.

## Facts
- **Repo:** GitHub `LeornaAI/leorna-control-plane`.
- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901a-agent-definitions`.
- **Branch:** `feat/86bcm901a-agent-definitions`, not on GitHub yet.
- **Accepted head:** `9c13e02c1e6b111d6b33bd415371ac53c025d81b`. BASE `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`, which is also GitHub `main` at the main session's last check.
- **Acceptance:** every AC is accepted on `9c13e02`. AC1–AC4 by the verifier, the blind auditor and `ac-check.sh`; AC5 (live) by Justin.
- **PR text:** `~/.hermes/cache/scratch/leorna-pr-86bcm901a-agent-definitions.md`, with a copy in `$EV/hand-over/pr-text.md` (`$EV` = `~/.hermes/plans/leorna/evidence/86bcm901a/`).
- **PR title:** `feat(86bcm901a): curate agent definitions`.
- **Main-session checks:**
  - `gh api user` is `Justin-Leorna`.
  - `leorna-test-pg` and `leorna-pg` are running.
  - The only open PR is #94 (Yan's draft, `fd63455`), which doesn't conflict with this branch.
  - The sibling branches 901b (`63afe55`), 901j (`66449af`) and 901w (`8a50486`) aren't on GitHub yet. Another session may be opening one of their PRs right now.

## Skills (load with the Skill tool and say so in your first steps)
`leorna` (FINISHER role, step 7; do its Step 1 context load), `git-commit-rules`, `github`, `engineering-best-practices`.

## Steps (from `leorna` step 7)
1. **Fetch a fresh main** over HTTPS through gh, using step 7.1's command. Record `git rev-parse origin/main` and compare it with `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`. **If main has moved past `1ee7157`, stop before pushing.** Report what landed and the `git merge-tree` result. The main session asks Justin about bringing main in.
2. **Pre-flight**, per step 7.2:
   - `git status --porcelain --ignored` is empty;
   - every author in `1ee7157..HEAD` is `Justin Issa <justin@leorna.com>`, with no AI attribution lines;
   - no `.github/` paths in the diff;
   - no tracked `CLAUDE.md`;
   - `git merge-tree --write-tree HEAD origin/main` exits 0;
   - HEAD is still `9c13e02`.
   - Then check whether any sibling PR is now open: `gh pr list -R LeornaAI/leorna-control-plane --state open`. For each one that's open:
     - fetch its head read-only as `pull/<n>/head` into `FETCH_HEAD`;
     - **confirm `git rev-parse FETCH_HEAD` equals `gh pr view <n> --json headRefOid`**;
     - run merge-tree against it.
   - The finisher's recipes for each sibling are in `$EV/hand-over/merge-notes.md`.
3. **Re-run step 4's gates on `9c13e02`** in a detached copy, not the worktree:
   - `make check` with `LEORNA_TEST_DATABASE_URL`;
   - `bash ./scripts/test-module-add.sh`;
   - the Postgres tests, read per test from a `go test -json` stream over the whole DB packages (`./internal/cloud/dbcheck ./internal/store/postgres ./internal/web`). Fail any skip whose reason names `LEORNA_TEST_DATABASE_URL`; only the 2 ClickHouse subtests and the env-gated opt-ins may skip;
   - `make library-check`;
   - AC1–AC4, with AC4's `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks`.

   Setup and logging:
   - Bind golangci-lint 2.14.0 and govulncheck v1.7.0 (CI's pins) through the Make variables, and use a task-local toolchain PATH (`$HOME/.local/leorna-toolchain/...`).
   - Log every step to `$EV/pr-gates-9c13e02/`, plus a `SUMMARY.txt` with one `label EXIT=<rc>` line per step.
   - **A branch failure:** stop and report; don't push.
   - **An outside failure:** follow step 7.4. Still push and open the PR, and say so in the Test Plan.
   - **`TestSetupWizardWithPostgres`:** it can time out under load. If it fails, run it alone and rerun it, and log both.
4. **Update the PR text** (both copies, kept identical):
   - The Test Plan lists only what ran on `9c13e02` in this pipeline: these gate results, and the AC acceptance with its receipts.
   - The Evidence block has the head SHA and the "Go quality gates" check. Add the Actions run URL once CI starts.
   - No server domain, URL, tenant ID or token. The only links allowed are GitHub and the ClickUp card.
5. **Push**, per step 7.6:
   - `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/leorna-control-plane.git feat/86bcm901a-agent-definitions:refs/heads/feat/86bcm901a-agent-definitions`.
   - Fetch it back into `refs/remotes/origin/feat/86bcm901a-agent-definitions`, then `git branch --set-upstream-to=origin/feat/86bcm901a-agent-definitions`.
   - Check that `git rev-parse HEAD origin/feat/86bcm901a-agent-definitions` both give `9c13e02`.
   - **Account check:** if `gh` isn't `Justin-Leorna`, or the push would go as `Just-In-N-Out`, stop. Never run `gh auth switch`, and never change a remote URL or credential helper.
6. **Open the PR**, per step 7.7:
   - `gh pr list -R LeornaAI/leorna-control-plane --head feat/86bcm901a-agent-definitions --state all` must be empty first.
   - `gh pr create -R LeornaAI/leorna-control-plane --base main --head feat/86bcm901a-agent-definitions --title "feat(86bcm901a): curate agent definitions" --body-file <PR text file>`.
   - Read it back with `gh pr view <n> -R LeornaAI/leorna-control-plane --json number,url,state,isDraft,headRefOid,mergeable` and `gh pr checks <n>`.
   - Wait in the foreground (a bounded `node -e` poll, up to about 25 minutes) for "Go quality gates" and any other required checks to finish.
   - Then add the Actions run URL to the Evidence block, using `gh pr edit <n> --body-file`, and in the scratch copy too.
   - If a CI check fails, read its log with `gh run view --log-failed` and report the cause. Don't fix anything: a fix makes a new head, and that goes back through the pipeline.
7. **Don't do step 7.8** (the `stories.json` PR number) **or 7.9** (post). They need Justin's "push" and "post".

## Boundaries
- Don't commit anything. HEAD stays `9c13e02`.
- Never merge, never mark the PR ready from draft or change its state beyond creating it, never comment on other PRs.
- Never touch other stories' worktrees, branches, DBs, evidence or PR texts. Reading their refs and PRs is fine.
- **Postgres:**
  - Reuse `leorna-test-pg` and read its port with `docker port leorna-test-pg 5432`. Never touch `leorna-pg`.
  - Use only your own `leorna_86bcm901a_pr_test` DB, and drop it at the end.
  - Never print a URL or password.
- **Temporary files:** `/tmp` is a small shared tmpfs.
  - `TMPDIR`, the detached copy and caches go in `~/.cache/86bcm901a-pr/` (`mkdir`, no `-p`).
  - Small scratch goes in `/tmp/claude-1000/-home-justin-Leorna/6a5cb64a-ef1e-4913-b9a6-0011ebf1675e/scratchpad/86bcm901a-pr/` (`mkdir`, no `-p`).
  - Remove both at the end. Remove a `git worktree add` copy with `git worktree remove --force`.
- **Waiting:** wait for long commands in the foreground. Ending your turn to wait counts as finishing.

## Rules for every role
- If you find any other bug or problem, don't fix it or fold it in. List it in `found_else`, one line each, with evidence and severity.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.

## Report (final message)
- Status: `PR open` (with its CI result), or `stopped` and why.
- The PR number and URL; the repo and branch; the head SHA on GitHub; the fresh `origin/main` SHA.
- Every gate with its exit code and log path. The CI checks with their result and run URL.
- Any open sibling PRs and the merge-tree result against each.
- The exact notes text for the main session to add to `leorna-workflow.md` (the PR number, head and CI result).
- `found_else[]` and `skill_lessons[]`.
- End with `MAIN SESSION: check and save these skill_lessons now.`
