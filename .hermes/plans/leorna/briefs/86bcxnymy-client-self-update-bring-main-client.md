# FIXER brief: 86bcxnymy client, bring main in

**Role:** FIXER (bring-main) for Leorna story `86bcxnymy` (Client self-update to the admin-approved version, with staged rollout), Part 2: the client. **Model:** Opus 5.5, effort high. You are a fresh agent.

Justin, 2026-11-11: "ok just do a pr, forget about AC8 do not mention it anywhere. I also want you to recheck cause main got moved and all." That is his "make a PR" and his OK to bring `main` in. Your job is only the bring-in; a fresh review, verifier, auditor and a PR finisher follow. **No push, no PR.**

## Where

- Client worktree: `~/Leorna/leorna-client/.claude/worktrees/86bcxnymy-client-self-update`, branch `feat/86bcxnymy-client-self-update`, head `76ed828f75a4e5e44f65fa021a5b35755e36b996`, old base `a7839b3af664efcfa59eb1ed3fe276ec1262a4de`.
- GitHub `main` at dispatch: `7d2e16e` (#34 Go 1.27.4 toolchain; #33 per-user integration credentials, which the plan expected to conflict in `index.html` and `bridge.go`, and adds client migration 9). Fetch fresh over HTTPS through gh (`leorna` step 7.1) and use whatever GitHub main is then; record the SHA.
- Approved plan: `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/plan-approved.md` (ACs AC1–AC7 are agent-run; AC8 is dropped by Justin). Evidence folder for you: `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/bring-main-1/`.
- Control plane: another agent is bringing control-plane main into `feat/86bcxnymy-client-self-update` (worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcxnymy-client-self-update`, read-only for you; it renumbers the story migration to 000033). For the end-to-end ACs and the contract `cmp`, wait (polling, up to ~60 min) until `git -C ~/Leorna/leorna-control-plane merge-base --is-ancestor d3e7391 feat/86bcxnymy-client-self-update` succeeds, then build the binary from **your own detached copy** of that commit; record the head you used. If it never lands, use `54c8f1a` and say so.

## What to do

1. Load skills and say so: `leorna` (fix-pass role; read step 7's bring-in checks; memory folder `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`.
2. **Merge** `origin/main` into the branch (a merge, never a rebase), message `merge: bring main (<sha7>) into feat/86bcxnymy-client-self-update`. Resolve conflicts keeping both meanings (both stories' UI in `index.html`, both stories' bindings in `bridge.go`, and anything else); compile fixes for renamed generated constants (`git diff <old base> <main> -- '*.gen.go'`) or changed fixtures go in a separate `fix(86bcxnymy):` commit, each proven needed by an overlay of the story's original file. If this story's client code reads the contract snapshot, refresh it from the merged control plane only if `leorna` says the client keeps a copy, and say so. Run the `leorna` step 7 merge proofs (one-sided blobs equal; both-sides set; hand-resolved files read and listed; story patch survived; an overlay mutant dropping each side's hunk in each hand-resolved file must be killed by some test, or say none can be and why; `gitleaks dir` on both-sides files).
3. Gates on your final head with **go1.27.4** first on the task PATH (`~/.local/leorna-toolchain/go1.27.4/bin`, then `~/.local/leorna-toolchain/bin`, `~/.local/leorna-tools/bin`; node in `~/.local/bin`): client `make check` (short real `TMPDIR` at `~/.cache/86bcxnymy-bm-cl/tmp`), `make lint audit` (audit should now be green; if not, attribute it on main), `node --test scripts/*-ui.test.cjs`, `PYTHONDONTWRITEBYTECODE=1 python3 -m unittest scripts/test_release.py`, `GOOS=windows go vet ./selfupdate/` (and the cgo Windows vet per `leorna` `references/gates.md`), the contract `cmp`, AC1–AC7 by name with `-v` (AC1, AC2, AC4, AC5 against your control-plane binary with the plan's env vars; AC7 natively on Windows through WSL interop), and the whole `selfupdate` package plus `desktop` natively on Windows with zero `--- FAIL`. Postgres: `leorna-test-pg` with **your own databases named `*_test`**; never drop one you didn't create. Logs with real exit codes in your evidence folder.
4. Identity from `~/.gitconfig`'s includeIf; never override it; no AI attribution or session lines; never commit `CLAUDE.md`; no `.github/` change. Stop at `ready-for-next-review`: no push, PR, merge or post.
5. Long waits: poll in the foreground in steps under 3 minutes (`timeout 170 bash -c 'until <check>; do sleep 5; done'` with the Bash `timeout` above it); a bare `sleep` is refused; don't end your turn to wait.

## Rules

- AC8 is dropped by Justin: never mention it in anything you write into the repo.
- Never send a server domain, URL or tenant ID anywhere; never print tokens. Never write into Justin's real `~/.codex` or `~/.claude`; the client runs in a scratch HOME.
- Anything else you find: `found_else` (one line each, with evidence and severity); don't fix it.
- **skill_lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.
- **Runaway memory (Windows desktop):** a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result; if killed, say so, find what grew, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.

## Return

`{status: ready-for-next-review|stopped, summary, main_sha, merge_commit, last_commit, control_plane_head_used, conflicts[{file, resolution}], merge_proofs[], gates[{name, exit, log}], ac_status[{ac, accepted, test, screenshot, evidence}], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
