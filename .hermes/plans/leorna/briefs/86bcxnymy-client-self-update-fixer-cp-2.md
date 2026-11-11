# FIXER brief: 86bcxnymy control plane, fix round 2

**Role:** FIXER for Leorna story `86bcxnymy` (Client self-update to the admin-approved version, with staged rollout), Part 1: the control plane, after review round 2. **Model:** Opus 5.5, effort high. You are a fresh agent.

## Where

- Worktree: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcxnymy-client-self-update`, branch `feat/86bcxnymy-client-self-update`, head `aa05ea1834055cae6179162cb5a0309a6ca78af6`, base `4ef14efb46da789aec30fad1e5a988d8770140e2`.
- Approved plan: `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/plan-approved.md` (D11 requires mutation proof of the tenant filters).
- Review records: `.../evidence/86bcxnymy-client-self-update/control-plane/review-1/review.json` and `review-2/review.json`; round 2's probes, mutants and logs in `control-plane/review-2/` (`probe-zz_rv2_probe_test.go.txt` holds the proven recipe; `mutants-aa05ea1-20261111T041446Z/`). Fix round 1's work: `control-plane/fix-1/`.
- The client half is under review in parallel against this control plane (a reviewer builds its own copy of `aa05ea1`). Don't touch the client repo. If any fix of yours would change the OpenAPI contract, the endpoints' behaviour or the admin form fields, stop and report first; the expected fix is tests only.

## The referee's line (verbatim): fix this one

```
R2-1  P2  internal/store/postgres/client_updates.go:108  Three tenant filters on approved versions survive every story test (mutants N1, N2, N3): the re-approve's read of the stored values (:75), the remove's in-use check (:108) and the remove's DELETE (:114). No fixture has two tenants holding the same release tag, the normal case. Under N3 tenant A's remove deletes tenant B's v1.3.0 too; under N2 A's remove is refused 409 because B pins v1.3.0; under N1 A's same-value re-approve is refused 409. Recipe: review-2/probe-zz_rv2_probe_test.go.txt (TestRV2ProbeSameTagInTwoTenants, TestRV2ProbeSameTagUnpinnedRemove).
REVIEW AGAIN: 1 P0-P2 finding(s) in review-2 at aa05ea1: fix them, then review the fix commits
```

(Read the full entry in `review-2/review.json`; the line above is its summary.)

The P3s R2-2 … R2-6 go to the follow-up list. You may fold in **R2-6** (one line of README test list) and **R2-5** if the R2-1 fixture also pins the `orgScope` check with no production change; leave R2-2, R2-3 and R2-4 alone and say so.

## How to work

1. Load skills and say so: `leorna` (fix-pass role; memory folder `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`, `multi-tenant-auth-management`. A skill's "spawn a subagent" steps are run by the main session, not you.
2. Verify the finding yourself first (`receiving-code-review`): reproduce N1, N2, N3 surviving the current tests on `aa05ea1`. Push back with evidence if it's wrong.
3. Fix test-first in the story's own test files (named for what they prove, not `RV2Probe`): two tenants holding the same release tag; show each new assertion fails on N1, N2 and N3 and passes on the fixed head. Mutation runs by `-overlay` under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`: a no-mutation control first (abort unless it passes), setup failures graded INVALID, never killed, each run in a new folder `.../control-plane/fix-2/mutants-<head7>-<UTC time>/`.
4. Gates on your final head: `make check` (with `command -v tofu` checked first), `bash ./scripts/test-module-add.sh`, `make contracts-check`, the story's tests by name with `-race -v`. Postgres: `leorna-test-pg` with **your own databases named `*_test`**; never drop one you didn't create (the client reviewer uses the same container). Short real `TMPDIR` at `~/.cache/86bcxnymy-fx2/tmp`. Logs with real exit codes in `.../control-plane/fix-2/`.
   - Known, not this story: `make audit` fails on base and head with GO-2026-6859 (attribute with `make audit` on base, then `make secrets library-check build`). `make secrets` can fail on sibling commit `27ca94f` (`feat/86bcm928e-custom-integrations`), which gitleaks finds because it scans every local branch: attribute with `gitleaks git --log-opts='4ef14ef..HEAD'` and `--log-opts=HEAD` plus `git merge-base --is-ancestor 27ca94f HEAD`. `TestCloneStopsAtItsDeadlineWhenTheServerStalls` fails under heavy load: rerun it alone.
5. Commit as `fix(86bcxnymy): …`. Identity comes from `~/.gitconfig`'s includeIf; never override it, no AI attribution or session lines, never commit `CLAUDE.md`. No `.github/` change. Stop at `ready-for-next-review`: no push, PR, merge or post.
6. Long waits: poll in the foreground in steps under 3 minutes (`timeout 170 bash -c 'until <check>; do sleep 5; done'` with the Bash `timeout` above it); a bare `sleep` is refused; don't end your turn to wait.

## Rules

- Never send a server domain, URL or tenant ID anywhere; never print tokens.
- Anything else you find: list it in `found_else` (one line each, with evidence and severity); don't fix it.
- **skill_lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.
- **Runaway memory (Windows desktop):** a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result; if killed, say so, find what grew, and rerun under the cap above.

## Return

`{status: ready-for-next-review|stopped, summary, dispositions[{id, action: fixed|pushed-back|deferred, commit, evidence}], worktree, last_commit, contract_changed: true|false, found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
