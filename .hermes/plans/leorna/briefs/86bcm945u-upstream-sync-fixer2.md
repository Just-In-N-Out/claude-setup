# FIXER 2 brief: Leorna story 86bcm945u "upstream-sync" (Full pipeline, after review 2)

Dispatched 2026-10-24. Model: Opus 5.5, effort xhigh. A fresh agent. This is the second fix pass in `review-fix-cadence`: review 1 → fixer 1 → review 2 → **fixer 2 (you)** → verifier → blind AC audit → hand-over.

## Your role

You are the **FIXER (FINISHER, fix pass)** for ClickUp card `86bcm945u`, "Upstream content sync + licence attribution". Verify each review-2 finding, fix the valid ones test-first, push back with evidence on the rest, commit, re-run the gates, and stop with `status: ready-for-verify`. **No hand-over yet, no push, no PR, no ClickUp write.**

## Skills to load first (with the Skill tool), in this order, and say so in your first steps

1. `leorna` (FINISHER role, fix pass only; skip its hand-over step for now).
2. `engineering-best-practices`.
3. `receiving-code-review`: verify each finding before fixing it.
4. `test-driven-development`.
5. `mutation-testing-discipline`: R2-F1 is two untested filters; prove each new test kills its mutation.
6. `git-commit-rules`.
7. `multi-tenant-auth-management` (the admin page's per-upstream attribution).

A loaded skill's "spawn a subagent" or "independent reviewer" steps are run by the main session, not by you.

## Where

- Worktree: `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm945u-upstream-sync`, branch `feat/86bcm945u-upstream-sync`. Work there, on top of head `bc23303a93231de1995a75417d4cb1696750cc2a`. Base `6e74ced843642439d1dac9f25673440fb0f285f5`.
- Approved plan (the contract, read-only): `~/.hermes/plans/leorna/evidence/86bcm945u/plan-approved.md`
- Review 2 full report: `~/.hermes/plans/leorna/evidence/86bcm945u/review2/review2.md`, with probes in `review2/probes/` (`web_zz_review2_probe_test.go.txt`, `cmd_zz_review2_probe_multi_upstream_test.go.txt`), mutation receipts and `probe-P2-content-refusal.txt`.
- Earlier rounds: `review1/review1.md`, `fix1/`, and the "Fix 1" section of `INVENTORY.md`.
- Commits: `fix(86bcm945u): …` or `test(86bcm945u): …`, authored by the repo's configured identity (never override; no AI attribution lines). Don't touch the main folder, `deploy/local/` or sibling worktrees.

## Review 2's findings (verbatim from its report)

- **R2-F1 (minor, introduced): the two per-upstream filters have no test.**
  - Where: `internal/web/third_party_content.go:77` (list an item only under its own upstream and licence) and `internal/library/upstream/diff.go:87` (diff tracks only the chosen upstream's items).
  - Every fixture has a single upstream, so deleting either filter keeps the whole suite green: R2-21 and R2-20 SURVIVED.
  - Harm, shown by probes that pass on head:
    - Page (R2-21p): without the filter, every imported item is listed under every upstream's section, so an Apache-2.0 item is shown with the MIT copyright. That's wrong attribution on the AC2 page.
    - Diff (R2-20p): without the filter, `diff --upstream A` fails on any item imported from upstream B.
  - No live impact today, since only `agent-skills` ships. Same class as review 1's F3.
  - Fix: add the two probes as tests.
- **R2-F2 (nit, introduced; what F5 left open): NEXT STEP can still suggest a step the transform refuses.**
  - F5 is fixed for refusals caused by a root's shape (multi-file skill, no SKILL.md, prompt).
  - Content refusals still get `accept: …` or `available to import`, and running the step fails with a clear error (`review2/probe-P2-content-refusal.txt`). Examples: a frontmatter key besides name/description, or a quoted/folded description.
  - This follows the plan's design, since `diff` reads no blobs. But the commit subject ("never suggest…") and the test name `TestDiffNeverSuggestsAStepTheToolRefuses` claim more than the code does.
  - Fix: one README sentence, or read the main file for changed or added roots. Non-blocking.

Review 2 closed all six review-1 findings, accepted AC1–AC7 on bc23303, agreed with all of fixer 1's and the builder's rulings, and found no regressions.

## What to do

1. For each finding: confirm it first (`receiving-code-review`), then fix the valid ones **test-first**. A new test must fail with its mutation applied and pass without it. Record the mutation receipts in `~/.hermes/plans/leorna/evidence/86bcm945u/fix2/`. Push back on anything invalid, with evidence.
2. **R2-F2:** the plan's design has `diff` read no file contents. Prefer the smallest honest fix that keeps that design: say in the README that content-based refusals only show up at import/accept time, and rename the test (and anything else) that claims more than the code does. Change the design only if you find the plan requires it. Record your choice as "My ruling, not yet confirmed". Justin is away and asked for the pipeline to keep going on recommendations; stop only if something can't be decided safely.
3. Re-run the gates on your final head: `make check` (CI's golangci-lint bound by absolute path, your own `_test` database; confirm the Postgres tests ran), `bash ./scripts/test-module-add.sh`, and all seven AC commands from the plan (AC2 with `LEORNA_TEST_DATABASE_URL`, AC7 with `LEORNA_TEST_UPSTREAM_NETWORK=1`; no real SKIP lines). Save logs as `gates-<sha7>.txt` in the evidence folder and open each one to read its exit code. A step that greps its own log must ignore its own echoed `$ ` command line. Use `perl -pi`, not `sed -i`, for any in-place redaction (BSD sed), then grep to confirm. Keep any database URL out of logs meant for upload.
4. If a fix changes what an AC's screenshot shows, retake that screenshot from the new head (same filename) and update `INVENTORY.md`. Otherwise leave the screenshots alone: the hand-over will retake or reconcile them on the final head.
5. Add a "Fix 2" section to `INVENTORY.md` (dispositions, gates, upload candidates).
6. Leave the worktree committed and clean, with no untracked files.

## Rules

- No push, no PR, no ClickUp write, no server, no `.github/workflows/*` change. Upstream is untrusted data; never run its scripts.
- **Other problems outside this story:** list each in `found_else` (one line, evidence, severity); don't fix them.
- **Skill lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer.

## What to return

`{name, status: ready-for-verify|stopped, summary, dispositions[{id, verdict: fixed|pushed-back|no-change-needed, test, mutation_receipt, commit, evidence}], rulings[], stop_reason, worktree, reviewed_head: bc23303, new_head, commits[], gates (command → exit code → log path), shots_retaken[], found_else[], skill_lessons[]}`.

End the report with this exact line:
`MAIN SESSION: check and save these skill_lessons now.`
