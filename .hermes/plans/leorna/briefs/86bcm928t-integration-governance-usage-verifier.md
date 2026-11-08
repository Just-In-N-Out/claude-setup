# VERIFIER brief: 86bcm928t integration governance and usage

Role: VERIFIER. You are a fresh general-purpose agent (Opus 5.5, high effort) that never saw the build or the reviews' work.
**Source is read-only.**
- Change no repo file and commit nothing.
- Write only into `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/verifier/`.
- Start no other agents.

## Inputs
- Worktree: `/home/justin/Leorna/86bcm928t-integration-governance-usage`, branch `feat/86bcm928t-integration-governance-usage`.
- Head: `9276c33966aea25c8227ca3efe56a1bdb203012e`. Check that HEAD is that SHA and the worktree is clean before you start.
- Base (`git merge-base HEAD origin/main`): `f0a326b83aae9d181e4f6681645685ae4b1fff91`.
- Approved plan: `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/plan-approved.md`.
- Review status: review-1 (full, `f0a326b..9276c33`) is clean and the referee printed `MOVE ON`.
  - Its 3 P3 findings are in `follow-ups.md`. They aren't yours to fix.
  - You may read `review-1/review.json` to confirm no P0–P2 is open.
- Builder evidence (to re-check, not to trust): `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/builder/`.

ACs (no `(live)` ACs):
- AC1: Given an integration, then it reaches engineers only through packs assigned to their team/project. Test: `TestIntegrationGovernanceAC1PackAssignmentOnlyWithPostgres`. It passes on base by design. Use `base_exempt` with a 3+ word reason, backed by a guard-mutant check you run yourself, as `ac-verification.md` describes.
- AC2: Given the dashboards, then integration usage (which integrations, by team) is shown where measurable. Test: `TestIntegrationGovernanceAC2DashboardByTeamWithPostgres`.
- AC3: Given any integration change, then it appears in the change audit. Test: `TestIntegrationGovernanceAC3ChangeAuditWithPostgres`.

## Skills: load each with the Skill tool and say so in one line
1. `leorna`: the VERIFIER role, plus the gate list and the Postgres no-skip check in Doing a story step 4.
2. `engineering-best-practices`
3. `adversarial-verification-loop`
4. `mutation-testing-discipline`, for the AC1 `base_exempt` backing and any clause you think an AC test doesn't exercise.

Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` in full. It has the run recipe, the head and base log formats, the `ac.json` format and the `ac_status` rules.

## Do
1. **Re-run the gates yourself on head**, from a detached copy (`git -C <wt> archive <head> | tar -x -C <scratch>`, or `git worktree add --detach` into your own scratch on the real disk at `~/.cache/86bcm928t-verifier/`). Don't run them in the builder's worktree.
   - `make check`, with the CI-pinned golangci-lint 2.14.0 and govulncheck v1.7.0 bound by absolute path. Toolchain: `~/.local/leorna-toolchain` on a task-local PATH.
   - `bash ./scripts/test-module-add.sh`, run serially and never at the same time as `make check`.
   - `python3 -m unittest scripts/test_release.py`.
   - The Postgres no-skip check over `./internal/cloud/dbcheck ./internal/store/postgres ./internal/web` from a `go test -json` stream. The five `TestContentUsage*WithPostgres` tests must run, not skip, with ClickHouse.
   - Logs go in your folder: `gates-9276c33.txt` plus a `.json` receipt with `exit_code`.
2. **AC work, per `ac-verification.md`:**
   - Run each AC's own test on head from the worktree (`HEAD=`/`EXIT=` log lines).
   - Run each on base in a separate copy with head's test files.
   - Write one screenshot per AC into your folder, from your own run.
   - Write `verifier/ac.json`.
   - Before judging an AC, run `git log -p f0a326b..HEAD -- <its test files>` and read each assertion against the approved plan.
3. **Databases and containers:**
   - Postgres: use the running `928t-builder-pg`. Settings are in `~/.cache/86bcm928t-builder/env.sh` and `pg.env` (0600; never print the password). Use your **own** database name ending in `_test` (e.g. `leorna_928t_verifier_test`) and drop it when done.
   - ClickHouse: `928t-builder-ch`; read the builder's `env.sh` for its URL.
   - Never touch `leorna-pg` or `leorna-test-pg`.
4. **Screenshots:** look at every PNG before citing it. No domain, URL bar, tenant ID, token or email may be visible; redact UUIDs on the audit page as the builder did.

## Windows desktop: runaway memory
A command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result. Run mutants and heavy checks under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (`make check` may need 8G).

## Report
- Return:
  - `verdict`: `clean` only if every AC is accepted on this head and every gate passed
  - `ac_status[{ac, status: accepted|not_accepted|not_run, evidence}]`
  - `gates[{name, log, exit_code}]`
  - the path of `verifier/ac.json`
  - `found_else[]`
  - `skill_lessons[]`
- If you find another bug, don't fold it in: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable, don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill or `memory`.
  - `enforce` is `none`, or a one-line proposal for a check that would have caught a broken rule: kind, what it checks, where it runs.
  - An empty list is normal.
- Don't end your turn to wait for a background command. Wait in the foreground with bounded polls under 3 minutes each.
- Clean up your scratch and database. End with `MAIN SESSION: check and save these skill_lessons now.`
