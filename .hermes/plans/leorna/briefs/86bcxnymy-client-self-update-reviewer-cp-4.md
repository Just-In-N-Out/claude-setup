# REVIEWER brief: 86bcxnymy control plane, review round 4 (delta)

**Role:** REVIEWER (review only) for Leorna story `86bcxnymy` (Client self-update to the admin-approved version, with staged rollout), Part 1: the control plane. Round 4, a **delta** review of the fix commit since round 3. **Model:** Opus 5.5, effort high. You are a fresh reviewer: you never saw the build or the fixes.

## What to review

- Worktree: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcxnymy-client-self-update`, branch `feat/86bcxnymy-client-self-update`, head `54c8f1ae6fcd7a6e88630a69e8840366d34d188b`. Story base `4ef14efb46da789aec30fad1e5a988d8770140e2`.
- **Scope:** `git diff 581cf77..54c8f1a` (one commit, fix round 3: `internal/store/postgres/client_updates_test.go` +28/−5) **and what it touches**: the production code those tests exercise in `internal/store/postgres/client_updates.go` (the remove's in-use check (both branches of its OR) and DELETE). Not the whole story.
- Earlier records (read them so you don't re-report a closed finding; a repeat needs `repeats` and a `new_fact`): `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/control-plane/review-1/review.json` and `review-2/review.json`.
- Fixer 3's disposition (verify, don't trust): R3-1 fixed in `54c8f1a`, tests only: `TestClientReleaseSameTagInTwoTenantsStaysInItsTenant`'s `setup` now takes tenant B's policy, and a new subtest "rolling out in the other tenant" (B approves v1.3.0 with its own link and rolls it out at 100% with no pin; A approves and removes its own v1.3.0, want nil; B's release, policy and check-in target intact). It reports P2roll and P2paren killed by that subtest's own assertion, and N1, N2, N3, N9, P2pin still killed. Its evidence: `.../control-plane/fix-3/` (mutants on the old and new tests, with a no-mutation control).
- Approved plan: `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/plan-approved.md` (D11 requires mutation proof of the tenant filters).

## Known, outside this story

- `make audit` fails on base and head with GO-2026-6859 (net/http in go1.27.3). A `make check` EXIT=2 is not proof of it: read the failing target in the `make: *** [Makefile:N: <target>]` line; `make -k check` reports every target. Attribute audit on base (a git checkout or `git init -q` in an archive), then `make secrets library-check build`.
- `make secrets` may fail on sibling commit `27ca94f` (`feat/86bcm928e-custom-integrations`): gitleaks scans every local branch. Attribute with `gitleaks git --log-opts='4ef14ef..HEAD'` and `--log-opts=HEAD` and `git merge-base --is-ancestor 27ca94f HEAD`.
- Load-sensitive tests from other stories: `TestCloneStopsAtItsDeadlineWhenTheServerStalls`, `TestQuickStartPickIsBoundedAndReleasesTheLockWithPostgres`. Rerun alone before attributing.

## How to work

1. Load skills and say so: `leorna` (REVIEWER role; skip its Step 1 full load beyond what the review needs; memory folder `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`), `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `multi-tenant-auth-management`, `mutation-testing-discipline`. Skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer.
2. In a **detached scratch copy** of `54c8f1a` (`git worktree add --detach ~/.cache/86bcxnymy-rv4/cp 54c8f1a`; remove it with `git worktree remove --force <that path>`; never a repo-wide prune): run the story's store, web and unit tests by name with `-race -v`, `make contracts-check`, and `make -k check` (with `command -v tofu` checked first). Three trees per probe where useful: base `4ef14ef`, previous head `581cf77`, head `54c8f1a`. Postgres: `leorna-test-pg` with **your own databases named `*_test`**; never drop one you didn't create (the client fixer uses the same container).
3. Re-run N1, N2, N3, N9, P2pin, P2roll, P2paren and try your own mutants of the lines the new tests claim to pin, via `-overlay` under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`: a no-mutation control first (abort unless it passes), setup failures INVALID, each run in a new folder under `control-plane/review-4/`. Check the new tests really fail for the reason they claim, not through an unrelated constraint.
4. Change nothing in the story worktree; restore anything you touch.
5. Severity: P0/P1 a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2 a bug a real person or agent could plausibly hit, anything that breaks an AC or the UI, or a test that can't fail. P3 cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has. A P0–P2 needs a concrete real-use scenario, or it is P3.
6. **Write** `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/control-plane/review-4/review.json` exactly in the format of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` → "Records": `round: 4`, `scope: "delta"`, `from: "581cf77590c8aa38eac8682239335d9b012fbea3"` (the previous round's head), `head: "54c8f1ae6fcd7a6e88630a69e8840366d34d188b"`, `findings[]` with ids `R4-<k>` (empty when clean). Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo ~/Leorna/leorna-control-plane/.claude/worktrees/86bcxnymy-client-self-update --base 4ef14efb46da789aec30fad1e5a988d8770140e2 ~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/control-plane`; exit 2 means your file is wrong, fix it; exit 0/1/3 is the referee's verdict, not yours. Return your prose report as text.
7. Long waits: poll in the foreground in steps under 3 minutes (`timeout 170 bash -c 'until <check>; do sleep 5; done'` with the Bash `timeout` above it); a bare `sleep` is refused; don't end your turn to wait.

## Rules

- Never send a server domain, URL or tenant ID anywhere; never print tokens. Never push, post or touch ClickUp.
- If you find another bug or problem outside this story, list it in `found_else` (one line each, with evidence and severity).
- **skill_lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.
- **Runaway memory (Windows desktop):** a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result; if killed, say so, find what grew, and rerun under the cap above.

## Return

`{verdict: clean|findings, findings[{id, severity, file_line, claim, scenario, repeats, new_fact}], ac_status[{ac, accepted, test, screenshot, evidence}], found_else[], skill_lessons[]}` (AC tests live in the client repo: mark AC1–AC8 `not_run` with a note on the control-plane receipts). End with `MAIN SESSION: check and save these skill_lessons now.`
