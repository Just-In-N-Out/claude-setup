
# FIXER 2 (client, Windows CI) — leorna-client, story 86bcm902w "Content usage analytics (which items get used)"

Role: the fixer for a CI failure on the open client PR. Verify the failure, fix it test-first, commit, run the client gates, push to the PR branch and watch CI until the Windows job passes, then stop at `ready-for-next-review`. A fresh reviewer reviews your commits next. **Never merge, never post to ClickUp, never run `gh auth switch` or change a remote.** Justin asked for the PR to be opened and verified ("Pull up a PR… rerun audits, verification… create a PR"), so pushing this fix to the same PR branch is in scope; each push asks him through the git guard.

## Where
- Worktree `/home/justin/Leorna/leorna-client/.claude/worktrees/86bcm902w-content-usage-analytics`, branch `feat/86bcm902w-content-usage-analytics` = **client PR #23** (LeornaAI/leorna-client), head **`db3e6b0f76652088c11fafa8c3c54509f62116f7`**, base `f105e27814b6efbec67059687963e722933acec2` (= client `main`). Confirm the head equals `gh pr view 23 -R LeornaAI/leorna-client --json headRefOid` and the worktree is clean.
- The control-plane side is PR #103 (open, CI green); another agent is reviewing it right now: don't touch the control-plane worktree.
- Approved plan (read-only): `~/.hermes/plans/leorna/evidence/86bcm902w/plan-approved.md` (task T9 for `ManagedItems` and `OpenReadOnly`).

## The failure (CI run 40968292489 on `db3e6b0`, job "Windows client executable", windows-latest)
- The job runs `go test -mod=vendor -count=1 ./application ./login ./toolconnector/...` with `LEORNA_TEST_SECURE_STORE=1`. It passes on client `main` `f105e27`; it fails on this branch.
- `TestManagedItemsFromLastSuccessfulSync` (`application/managed_items_test.go`, added in `164014f`): compares `ManagedItems`' project root with `f.project` from `t.TempDir()`. On the runner `t.TempDir()` is the 8.3 short path (`C:\Users\RUNNER~1\…`) while the code returns the long one (`C:\Users\runneradmin\…`).
- `TestOpenReadOnlyNeverMigrates` (same file): the same root comparison fails, and its `t.Fatalf` skips `app.Close()`, so TempDir cleanup then reports "leorna.db … used by another process" (a knock-on).
- Read the job's log yourself (`gh run view 40968292489 -R LeornaAI/leorna-client --log-failed`) before deciding.

## How to work
- Decide, with evidence, whether the fault is only in the tests (compare canonical paths on both sides; close the app in `t.Cleanup`) or also in the product: could a real Windows user's project root and a Claude Code transcript `cwd` differ the same way (short versus long form, case, separators) so the Claude Code detector's folder match (`usage/items_claudecode.go`, `sameFolder`) or `ManagedItems` miscounts? If the product needs a change, make it test-first and keep it minimal; if not, say why in your ruling. Don't widen the story.
- You can't run Windows here. Prove what you can locally: unit tests for any path-normalising helper with Windows-shaped inputs that run on Linux, `GOOS=windows` builds or vets of the touched packages where cgo allows (the leorna skill notes `GOOS=windows go vet` can't typecheck the SQLite adapter without cgo: reproduce that on `main` before calling it a regression). The Windows CI job after your push is the real proof.
- Commits: `fix(86bcm902w): …`, by the repo's configured identity (`Justin Issa <justin@leorna.com>`); never `-c user.*`, `--author` or GIT_AUTHOR/COMMITTER variables; no AI attribution or Co-Authored-By lines.
- Client gates on your final head before pushing: `make check` with a real, non-symlinked `TMPDIR`, `node --test scripts/*-ui.test.cjs`, `make lint audit` with CI's golangci-lint 2.14.0 first on PATH (echo its version), the story's client tests, and both `cmp` checks against the control-plane PR head `fabbec0`'s files (golden upload body, OpenAPI spec). Logs in `~/.hermes/plans/leorna/evidence/86bcm902w/client/fix-2/` (create it) with a `SUMMARY.txt`.
- Push with the HTTPS-through-gh form from the `leorna` skill's step 7.6, URL written out: `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/leorna-client.git feat/86bcm902w-content-usage-analytics:refs/heads/feat/86bcm902w-content-usage-analytics`; fetch it back into `refs/remotes/origin/<branch>` and check `git rev-parse HEAD origin/<branch>` match. Check `gh api user --jq .login` prints `Justin-Leorna` first.
- Watch `gh pr checks 23 -R LeornaAI/leorna-client` in polls under 3 minutes each until every check finishes (a foreground command moves to the background after about 180 s; don't end your turn to wait). If the Windows job fails again, read the log, fix and push once more; after a second failed attempt, stop and report with both logs.
- Update PR #23's body so its Test Plan and Evidence name the new head and CI run (`gh pr edit 23 -R LeornaAI/leorna-client --body-file <file>`; keep the scratch copy `~/.hermes/cache/scratch/leorna-pr-86bcm902w-content-usage-analytics-client.md` equal to the live body).
- Record your disposition, ruling and receipts in `~/.hermes/plans/leorna/evidence/86bcm902w/client/fix-2/dispositions.md`.

## Skills (load them first with the Skill tool and say so)
`leorna` (fixer rules and step 7.6), `engineering-best-practices`, `systematic-debugging` (a CI failure: prove the cause before fixing), `test-driven-development`, `receiving-code-review`, `git-commit-rules`, `github`.

## Rules
- Write only in the client worktree (your fix commits), `~/.hermes/plans/leorna/evidence/86bcm902w/client/fix-2/`, the scratch PR-text copy and your own scratch (`~/.cache/86bcm902w-fix2/`, `mkdir` without `-p`; `/tmp` is a small shared RAM tmpfs). Never touch `plan-approved.md`, other roles' folders, the control-plane worktree, or other stories' worktrees, branches, DBs or evidence. **Never run `git worktree prune`.**
- You can't ask Justin anything and can't start agents. On a real trade-off, rule and write "My ruling, not yet confirmed" in `rulings[]` and `dispositions.md`.
- If you find any other bug or problem along the way, don't fix it. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.

## Output (your final message)
`{name, status: ready-for-next-review|stopped, summary, reviewed_head: "db3e6b0…", new_head, root_cause, product_change: true|false, rulings[], gates[{gate, exit, log}], pushed: true|false, ci{run_url, checks[{name, result}]}, pr_body_updated: true|false, found_else[], stop_reason, skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
