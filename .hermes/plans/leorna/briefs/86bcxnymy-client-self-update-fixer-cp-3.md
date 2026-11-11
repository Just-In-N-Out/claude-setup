# FIXER brief: 86bcxnymy control plane, fix round 3

**Role:** FIXER for Leorna story `86bcxnymy` (Client self-update to the admin-approved version, with staged rollout), Part 1: the control plane, after review round 3. **Model:** Opus 5.5, effort high. You are a fresh agent.

Justin was asked "only P2 left from round 3 on (R3-1): fix or follow-up?" and answered **"Fix"** (recorded in `control-plane/review-3/justin.json`).

## Where

- Worktree: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcxnymy-client-self-update`, branch `feat/86bcxnymy-client-self-update`, head `581cf77590c8aa38eac8682239335d9b012fbea3`, base `4ef14efb46da789aec30fad1e5a988d8770140e2`.
- Review records: `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/control-plane/review-{1,2,3}/review.json`; round 3's probe `review-3/probe-zz_rv3_probe_test.go.txt`, its mutants harness `review-3/mutants-run.py.txt`. Fix round 2's work: `control-plane/fix-2/`.
- The client half is under review in parallel against this control plane. Don't touch the client repo. Tests only: if the fix would need a production, contract, endpoint or form change, stop and report.

## The referee's line: fix this one

```
R3-1  P2  internal/store/postgres/client_updates.go:108  The remove's in-use check still has an unpinned tenant filter on its rollout branch. TestClientReleaseSameTagInTwoTenantsStaysInItsTenant has tenant B pin v1.3.0 but never roll it out, so the filter is proven for pinned_version only. Mutants P2roll `(tenant_id=$1 AND pinned_version=$2) OR rollout_version=$2` and P2paren (dropped parentheses, `tenant_id=$1 AND pinned_version=$2 OR rollout_version=$2`) survive every story store test. Fix: a third subtest "rolling out in the other tenant": tenant B approves v1.3.0 with its own link and rolls it out at 100% with no pin; tenant A approves and removes its own v1.3.0 (want nil; B's release and rollout intact).
```

(Read the full entry in `review-3/review.json`.)

## How to work

1. Load skills and say so: `leorna` (fix-pass role; memory folder `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`, `multi-tenant-auth-management`.
2. Verify first: reproduce P2roll and P2paren surviving the current tests on `581cf77`. Then add the subtest in the story's own test file; show it fails on P2roll and P2paren for its own assertion (not through an unrelated constraint) and passes on the fixed head. Also re-run N1, N2, N3 and N9 against the new head. Mutation runs by `-overlay` under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`: a no-mutation control first (abort unless it passes), setup failures INVALID, each run in a new folder `.../control-plane/fix-3/mutants-<head7>-<UTC time>/`.
3. Gates on your final head: the story's unit, store and web tests by name with `-race -v`, `make contracts-check`, `make -k check` (with `command -v tofu` checked first; read the failing target in each `make: ***` line). Known outside the story: `audit` fails on base and head with GO-2026-6859 (attribute on base in a git checkout); `make secrets` may fail on sibling commit `27ca94f`; `TestCloneStopsAtItsDeadlineWhenTheServerStalls` and `TestQuickStartPickIsBoundedAndReleasesTheLockWithPostgres` are load-sensitive (rerun alone). Postgres: `leorna-test-pg` with **your own databases named `*_test`**; never drop one you didn't create. Short real `TMPDIR` at `~/.cache/86bcxnymy-fx3/tmp`. Logs with real exit codes in `.../control-plane/fix-3/`.
4. Commit as `fix(86bcxnymy): …`. Identity comes from `~/.gitconfig`'s includeIf; never override it, no AI attribution or session lines, never commit `CLAUDE.md`. Stop at `ready-for-next-review`: no push, PR, merge or post.
5. Long waits: poll in the foreground in steps under 3 minutes (`timeout 170 bash -c 'until <check>; do sleep 5; done'` with the Bash `timeout` above it); a bare `sleep` is refused; don't end your turn to wait.

## Rules

- Never send a server domain, URL or tenant ID anywhere; never print tokens.
- Anything else you find: list it in `found_else`; don't fix it.
- **skill_lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.
- **Runaway memory (Windows desktop):** a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result; if killed, say so, find what grew, and rerun under the cap above.

## Return

`{status: ready-for-next-review|stopped, summary, dispositions[{id, action, commit, evidence}], worktree, last_commit, contract_changed: false, found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
