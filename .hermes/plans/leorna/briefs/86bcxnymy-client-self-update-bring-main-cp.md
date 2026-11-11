# FIXER brief: 86bcxnymy control plane, bring main in

**Role:** FIXER (bring-main) for Leorna story `86bcxnymy` (Client self-update to the admin-approved version, with staged rollout), Part 1: the control plane. **Model:** Opus 5.5, effort high. You are a fresh agent.

Justin, 2026-11-11: "ok just do a pr, forget about AC8 do not mention it anywhere. I also want you to recheck cause main got moved and all." That is his "make a PR" and his OK to bring `main` in. Your job is only the bring-in; a fresh review, verifier, auditor and a PR finisher follow. **No push, no PR.**

## Where

- Worktree: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcxnymy-client-self-update`, branch `feat/86bcxnymy-client-self-update`, head `54c8f1ae6fcd7a6e88630a69e8840366d34d188b`, old base `4ef14efb46da789aec30fad1e5a988d8770140e2`.
- GitHub `main` at dispatch: `d3e7391` (#124 Go 1.27.4, #123 launcher audit, #125 OIDC SSO with `000032_tenant_sso`, #126 integration connection test). Fetch fresh over HTTPS through gh (`leorna` step 7.1) and use whatever GitHub main is then; record the SHA.
- Approved plan: `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/plan-approved.md`. Evidence folder for you: `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/control-plane/bring-main-1/`.
- The client half is being brought in by another agent in parallel; don't touch the client repo. It will build its control-plane binary from your final commit, so commit as soon as the merge is proven.

## What to do

1. Load skills and say so: `leorna` (fix-pass role; read step 7's bring-in checks in full; memory folder `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`), `engineering-best-practices`, `receiving-code-review`, `backend-data-migrations`, `mutation-testing-discipline`, `git-commit-rules`.
2. **Merge** `origin/main` into the branch (a merge, never a rebase), commit message `merge: bring main (<sha7>) into feat/86bcxnymy-client-self-update`. Expected: conflicts in `delivery/stories.json` (take main's file, append this story's entry last as text, prove earlier entries unchanged by value) and `internal/store/postgres/store_test.go` (keep both drop lists). **Renumber** this story's `000032_client_updates.{up,down}.sql` to `000033` (inside the merge or as a separate `fix(86bcxnymy):` commit, your call; say which), update every reference (README rollback note → `version=33`, tests, docs), and check `ls internal/store/postgres/migrations | grep '\.up\.sql$' | cut -d_ -f1 | sort | uniq -d` prints nothing. Grep `git diff <old base> <main> -- '*_test.go' '*.gen.go'` for fixture/constant changes the story's own tests must follow. Run the `leorna` step 7 merge proofs (one-sided blobs equal; both-sides set; hand-resolved files read; story patch survived; renumber blobs equal; overlay probe `ApplyMigrations, resetDatabase, ApplyMigrations` for the drop list; `go test -count=1 ./internal/web/` with no DB URL for router clashes; `gitleaks dir` on both-sides files). Any real code conflict beyond those two files: resolve keeping both meanings and say exactly what you did.
3. Gates on your final head with **go1.27.4** first on the task PATH (`~/.local/leorna-toolchain/go1.27.4/bin`, then `~/.local/leorna-toolchain/bin`, `~/.local/leorna-tools/bin`): `make -k check` (with `command -v tofu` checked; read each failing target), `make contracts-check`, the story's unit, store and web tests by name with `-race -v`. `make audit` should now be green; if not, attribute it on main. Postgres: `leorna-test-pg` with **your own databases named `*_test`**; never drop one you didn't create. Short real `TMPDIR` at `~/.cache/86bcxnymy-bm-cp/tmp`. Logs with real exit codes in your evidence folder. Known load-sensitive tests: `TestCloneStopsAtItsDeadlineWhenTheServerStalls`, `TestQuickStartPickIsBoundedAndReleasesTheLockWithPostgres`, `TestSetupWizardWithPostgres` (rerun alone before calling a regression).
4. Identity from `~/.gitconfig`'s includeIf; never override it; no AI attribution or session lines; never commit `CLAUDE.md`; no `.github/` change. Stop at `ready-for-next-review`: no push, PR, merge or post.
5. Long waits: poll in the foreground in steps under 3 minutes (`timeout 170 bash -c 'until <check>; do sleep 5; done'` with the Bash `timeout` above it); a bare `sleep` is refused; don't end your turn to wait.

## Rules

- AC8 is dropped by Justin: never mention it in anything you write into the repo.
- Never send a server domain, URL or tenant ID anywhere; never print tokens.
- Anything else you find: `found_else` (one line each, with evidence and severity); don't fix it.
- **skill_lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.
- **Runaway memory (Windows desktop):** a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result; if killed, say so, find what grew, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.

## Return

`{status: ready-for-next-review|stopped, summary, main_sha, merge_commit, last_commit, renumber{how, files}, conflicts[{file, resolution}], merge_proofs[], gates[{name, exit, log}], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
