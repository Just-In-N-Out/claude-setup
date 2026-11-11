# FIXER brief: 86bcxnymy control plane, fix round 1

**Role:** FIXER for Leorna story `86bcxnymy` (Client self-update to the admin-approved version, with staged rollout), Part 1: the control plane, after review round 1. **Model:** Opus 5.5, effort high. You are a fresh agent.

## Where

- Worktree: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcxnymy-client-self-update`, branch `feat/86bcxnymy-client-self-update`, head `2d640f123d84bb396ef6581f481280628e8a653e`, base `4ef14efb46da789aec30fad1e5a988d8770140e2`.
- Approved plan: `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/plan-approved.md` (D11 requires mutation proof of the tenant filters).
- Review record and the reviewer's logs, probes and mutants: `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/control-plane/review-1/` (`review.json`; `probe-store_probe_test.go.txt` holds two proven fixture recipes; `mutants-summary.json`, `mutants-run.py.txt`).
- Builder 1's evidence: `.../builder-cp/`.
- Builder 2 (the client) is building in parallel against the control-plane head `2d640f1`, from its own detached copy. Don't touch the client repo. If any fix of yours would change the OpenAPI contract, the endpoints' behaviour or the admin form fields, stop and report first; the expected fixes are tests only.

## The referee's lines (verbatim) — fix these two

```
R1-1  P2  internal/web/client_update_test.go:253  The team-targeting receipt can't fail on a wrong-team join: dropping `m.team_id=rt.team_id` from the check-in query (internal/store/postgres/client_updates.go:449) or from the page's In-rollout query (:383) leaves every story test green (reviewer mutants V12, V12o survive the store and web story tests). Every fixture's outsider is in no team at all, so 'member of the ticked team' and 'member of any team' can't be told apart. The plan names this test as the only proof of team targeting (the dev-mode end-to-end run can't show teams). Proven recipe: an engineer in a second, unticked team must get no target and In rollout = No (review-1/probe-store_probe_test.go.txt, TestRV1ProbeOtherTeamMember: passes on head, fails on V12 and V12o).
R1-2  P2  internal/store/postgres/client_updates.go:275  Tenant isolation of the rollout group is not pinned by any test: five tenant filters can be removed with every story test green (reviewer mutants V10, V10t, V11, V16, V17): the policy read's ticked team and client IDs (:181, :184), the save's `DELETE FROM client_rollout_teams/_installations WHERE tenant_id=$1` (:275), and the page's ticked team names and engineer emails (:336, :338). With V11 tenant A's save removes every tenant's rollout group; with V16/V17 tenant A's page lists tenant B's team names and engineer emails; with V10/V10t tenant B's IDs land in tenant A's audit record. No fixture gives two tenants a rollout group at once. D11 requires mutation proof of the tenant filters and the builder's table has none for these lines. Proven recipe: both tenants save a rollout with a ticked team and client, tenant A saves again, then assert tenant A's overview holds none of B's group and tenant B's group is intact (TestRV1ProbeSameInstallationIDInTwoTenants: passes on head, fails on all five).
REVIEW AGAIN: 2 P0-P2 finding(s) in review-1 at 2d640f1: fix them, then review again (Full: round 2 reviews the whole story from 4ef14ef; Mini: review the fix commits)
```

The P3s in the same `review.json` (R1-3 … R1-9) go to the follow-up list; you may fold in R1-3 since the R1-2 fixture kills it (the reviewer says so), and the R1-8 README rollback note (docs only, proven in `review-1/migration-fill.log`) if it is a few lines. Leave R1-4, R1-5, R1-6, R1-7 and R1-9 alone and say so.

## How to work

1. Load skills and say so: `leorna` (fixer/FINISHER fix-pass role; memory folder `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`, `multi-tenant-auth-management`. A skill's "spawn a subagent" steps are run by the main session, not you.
2. Verify each finding yourself first (`receiving-code-review`): reproduce the survivors on the head with the reviewer's overlays. Push back with evidence if one is wrong.
3. Fix test-first: add the fixtures/tests (into the story's own test files, named for what they prove, not `RV1Probe`), show each new assertion fails on the matching mutants (V12, V12o, V10, V10t, V11, V16, V17, plus V2, V3 if you take R1-3) and passes on the fixed head. Mutation runs by `-overlay` under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, written into a new folder `.../control-plane/fix-1/mutants-<head7>-<UTC time>/`, never an earlier run's folder.
4. Re-run the gates on your final head: `make check` (with `tofu` on PATH and `command -v tofu` checked first: without it `TestGoldenHCLPassesTofuValidate` skips silently), `bash ./scripts/test-module-add.sh`, `make contracts-check`, and the story's tests by name with `-race -v`. Postgres: `leorna-test-pg` with **your own database name** (builder 2 uses the same container; never drop a database you didn't create). Short real `TMPDIR` at `~/.cache/86bcxnymy-fx1/tmp`. Logs with real exit codes go in `.../control-plane/fix-1/`.
5. Commit as `fix(86bcxnymy): …` (one commit per finding is fine). Identity comes from `~/.gitconfig`'s includeIf; never override it, no AI attribution or session lines, never commit `CLAUDE.md`. No `.github/` change. Stop at `ready-for-next-review`: no push, PR, merge or post.
6. Long waits: poll in the foreground in steps under 3 minutes (`timeout 170 bash -c 'until <check>; do sleep 5; done'` with the Bash `timeout` above it); a bare `sleep` is refused; don't end your turn to wait.

## Rules

- Never send a server domain, URL or tenant ID anywhere; never print tokens.
- Anything else you find: list it in `found_else` (one line each, with evidence and severity); don't fix it.
- **skill_lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.
- **Runaway memory (Windows desktop):** a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result; if killed, say so, find what grew, and rerun under the cap above.

## Return

`{status: ready-for-next-review|stopped, summary, dispositions[{id, action: fixed|pushed-back|deferred, commit, evidence}], worktree, last_commit, contract_changed: true|false, found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
