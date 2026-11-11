# FIXER brief: 86bcxnymy control plane, bring main in (2)

**Role:** FIXER (bring-main) for Leorna story `86bcxnymy` (Client self-update to the admin-approved version, with staged rollout), control plane. **Model:** Opus 5.5, effort high. Fresh agent.

PR #128 (`feat/86bcxnymy-client-self-update`, pushed head `926997e`) is `BEHIND`: GitHub main moved to `659b832` at 21:41 UTC when #127 (v0.2.0 release notes) merged. Justin, 2026-11-11: **"Bring main in now"**. Your job: the bring-in only. **No push**: a fresh review of your commits comes first.

## Where

- Worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcxnymy-client-self-update`, branch `feat/86bcxnymy-client-self-update`, local head `b389a45` = pushed `926997e` + the unpushed record commit `b389a45 feat(86bcxnymy): record PRs #128 and LeornaAI/leorna-client#36` (`delivery/stories.json` only). Previous merge-base `d3e7391`.
- Evidence folder: `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/control-plane/bring-main-2/`. Earlier bring-in for reference: `control-plane/bring-main-1/` (its `proofs.sh` can be adapted).

## What to do

1. Load skills and say so: `leorna` (fix-pass role; step 7's bring-in checks), `engineering-best-practices`, `receiving-code-review`, `backend-data-migrations`, `git-commit-rules`.
2. Fetch GitHub main fresh (HTTPS through gh) and record its SHA. Merge it into the branch on top of `b389a45` (a merge, never a rebase), message `merge: bring main (<sha7>) into feat/86bcxnymy-client-self-update`. Expect at most a `delivery/stories.json` conflict (take main's file, keep this story's entry last with its `[128]`/`[36]` PR record, append as text, prove main's entries equal by value and in order). Check the migration numbers (`ls internal/store/postgres/migrations | grep '\.up\.sql$' | cut -d_ -f1 | sort | uniq -d` prints nothing; if main took `000033`, renumber this story to the next free number in a separate `fix(86bcxnymy):` commit and update every reference, as `bring-main-1` did). Run the `leorna` step 7 merge proofs; if main brought anything beyond docs/release files, apply the full list (fixtures, router clash check, drop-list probe).
3. Gates on your final head with go1.27.4 first on PATH (`~/.local/leorna-toolchain/go1.27.4/bin`, `~/.local/leorna-toolchain/bin`, `~/.local/leorna-tools/bin`, keep `/usr/local/bin`): `make -k check`, `make contracts-check`, the story's tests by name with `-race -v`, `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`, `scripts/check-story-shippable.py 86bcxnymy` (expect only PR-state BLOCKED lines). Postgres: if `leorna-test-pg` can't start (Windows port reservation over 55432), run your own throwaway `mirror.gcr.io/library/postgres:18.6-alpine3.23` container `86bcxnymy-bm2-pg` on a free loopback port and remove it after. TMPDIR `~/.cache/86bcxnymy-bm2/tmp`. Logs + `SUMMARY.txt` in your folder.
4. Identity from includeIf; no AI lines; no `CLAUDE.md`; no `.github/`. Stop at `ready-for-next-review`; no push, PR edit, merge or post.
5. Long waits: poll in the foreground in steps under 3 minutes (`timeout 170 bash -c 'until <check>; do sleep 5; done'` with the Bash `timeout` above it); a bare `sleep` is refused.

## Rules

- AC8 is dropped by Justin: never mention it. Never send a server domain, URL or tenant ID; never print tokens.
- Anything else: `found_else`. **skill_lessons:** don't edit any skill or memory file: list reusable lessons in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section (`enforce` none or a one-line check proposal). An empty list is normal.
- **Runaway memory:** a SIGTERM/143/137/"Killed" may be earlyoom: `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`; rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.

## Return

`{status, main_sha, merge_commit, last_commit, main_changed_files[], conflicts[], renumber, merge_proofs[], gates[{name, exit, log}], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
