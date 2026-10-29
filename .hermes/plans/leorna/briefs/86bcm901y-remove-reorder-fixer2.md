
# FIXER 2 — leorna-control-plane, story 86bcm901y "Remove and reorder items in a pack version"

Role: the fixer after review 2 (`review-fix-cadence`: review 1 → fixer 1 → review 2 → **fixer 2** → verifier). Verify the finding, fix it, run the gates, commit, and stop at `ready-for-verify`. No release, no push.

## Where
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901y-remove-reorder`, branch `feat/86bcm901y-remove-reorder`, base `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f`, reviewed head **`b35d1118472d84da1b0905fed9e33ddfcb7672f6`**. Confirm the worktree is at that head and clean before you start.
- Approved plan (read-only, never edit): `~/.hermes/plans/leorna/evidence/86bcm901y/plan-approved.md`. Review 2's receipts: `~/.hermes/plans/leorna/evidence/86bcm901y/review2/` (`review2-verdict.json`).

## Review 2's verdict and finding (verbatim)
Verdict: findings, one nit, nothing blocking. All five review 1 findings closed; AC1–AC4 accepted on `b35d111`; every gate green on the reviewer's own copy and DB.
- **R2-F1 (nit, introduced in `bc5b410`):** `packAuditRecord.Order`'s field comment still says "only when the save reordered", but the audit now records the order whenever the save names one. Evidence: `internal/store/postgres/pack_builder.go:316` vs `:123` (`if len(spec.Order) > 0`). At `c574cdd` the comment matched its condition (`:314` vs `:121` `if built.Diff.Reordered`). Suggested fix: `// kind/name in the new order, only when the save names an order`.

## What to do
1. Load `leorna` (fix-pass rules), `engineering-best-practices`, `receiving-code-review` and `git-commit-rules`, and say so.
2. Verify R2-F1 by reading the two lines. Check the same wording isn't left stale anywhere else in the story's diff (comments, READMEs); fix only stale text about this condition, nothing else.
3. Commit as `fix(86bcm901y): …` with the repo's configured identity only (never `-c user.*`, `--author` or GIT_AUTHOR/COMMITTER variables; no AI attribution or Co-Authored-By lines).
4. This is a comment-only change, so no new test is needed. Run on the new head: `make check` with `LEORNA_TEST_DATABASE_URL` on your own disposable DB `leorna_86bcm901y_fix2_test` in `leorna-test-pg` (127.0.0.1:55432; never `leorna-pg` on 5432, never another role's DB), CI's golangci-lint 2.14.0 and govulncheck v1.7.0 bound through `GOLANGCI_LINT=`/`GOVULNCHECK=` (paths in the builder's `env.sh.txt` in the evidence folder), `bash ./scripts/test-module-add.sh`, and each AC test by name. Save per-head logs in the evidence folder's root as the earlier roles did (`gates-<sha7>.txt`, `ac<n>-<sha7>.log`), re-render `ac2-sync-lockfile-log.png` and `ac4-refused-log.png` from the new head's logs (keep the `b35d111` renders in `fixer2/superseded/`), look at both, and add a short "Fixer 2" section to `INVENTORY.md`.
5. Leave the worktree committed and clean. Stop with `status: ready-for-verify`. Never push, open a PR, post to ClickUp or merge.

## Boundaries
- Scratch: a fresh `<scratchpad>/86bcm901y-fix2/` (`mkdir` without `-p`); Go `TMPDIR`, binaries and Chrome profiles go in `~/.cache/86bcm901y-fix2/`. Remove only your own folders by literal absolute path, and drop your DB at the end. **Never run `git worktree prune`.**
- Never touch other stories' worktrees, branches, DBs or evidence. The client repo is read-only. The migration-24 collision with sibling worktrees is the hand-over finisher's, not yours.
- A Claude Code foreground command moves to the background after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused).

## Rules for every role
- If you find any other bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable, don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.

## Output (your final message)
`{name, status: ready-for-verify|stopped, summary, reviewed_head: b35d111, new_head, dispositions[{id, verified, action, commit, evidence}], gates[{gate, exit, log}], ac_evidence[{ac, test, log, screenshot}], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
