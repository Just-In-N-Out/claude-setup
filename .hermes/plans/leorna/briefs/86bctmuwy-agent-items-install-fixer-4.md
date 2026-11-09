# FIXER brief, round 4 (after review 5): 86bctmuwy-agent-items-install (Leorna, leorna-client)

**Role:** FIXER. Fix review 5's P2 finding R5-1, the way Justin decided (decision 10), test-first. Then stop at `ready-for-review`. **No push, no PR, no ClickUp write.**
**Model/effort:** Opus 5.5, xhigh.

## State
- Story: ClickUp 86bctmuwy, "Install Agent items into local Claude Code, Codex and Cursor tool directories". Pipeline: Full.
- Worktree: `/home/justin/Leorna/leorna-client/.claude/worktrees/86bctmuwy-agent-items-install`. Branch: `feat/86bctmuwy-agent-items-install`. Head: `556dba91e8de28bad56acfb4e49dc99bb90b88a0`. That is merge `1fa24d9` of GitHub main `f3bc960` (#30 managed config drift report and restore; #31), fix `f6f957b`, and fix round 3 (`e34c8e8` R4-2, `44df083` R4-1, `556dba9` README) for decision 9. Merge base: `f3bc96061c74510b4cd9f7a7ee0a14890f087441`. Not pushed.
- Approved plan (read-only, AC1–AC13): `~/.hermes/plans/leorna/evidence/86bctmuwy/plan-approved.md`. Working plan with **Decisions 9 and 10** at the end: `~/.hermes/plans/leorna/86bctmuwy-agent-items-install.md`. Justin's records: `bring-main-1/justin.json` (decision 9) and `review-5/justin.json` (decision 10), both under `~/.hermes/plans/leorna/evidence/86bctmuwy/`.
- Review 5: `~/.hermes/plans/leorna/evidence/86bctmuwy/review-5/review.json`, with its probes in `review-5/probes/` (`TestR5A_RemovedThenUsersOwnFile` is R5-1's repro) and logs in `review-5/logs/`. Fixer 3's answers and mutants are in `fixer-4/`.
- Your evidence folder: `~/.hermes/plans/leorna/evidence/86bctmuwy/fixer-4/` (create it). Scratch goes in `~/.cache/86bctmuwy-fixer-4/` (`mkdir` without `-p`), including TMPDIR.

## What to fix (decision 10, Justin, 2026-11-09: "Record removals")
- **R5-1, P2** (`application/agent_guard.go:143-155`, `leornaWrittenFiles` :204-263, `application/sync.go:409-416`, `application/restore.go:107-109, 142`). Here is the case:
  1. Leorna removes its agent file.
  2. The user writes their own file at that path.
  3. The agent is assigned again.
  Leorna then reads the user's file as "Leorna's file the user changed". Since fix round 3, that file enters the evidence with Leorna's old hash, shows as `modified` in Check files and the drift report, gets overwritten by Restore, and makes a later drop fail with `write_failed`.
- **The fix:** each Sync records in its run evidence the agent files it removed, per tool and destination. When Leorna works out who wrote a path (`leornaWrittenFiles`, the baseline lookup, the kept-row carry-forward and Restore's ownership check), it stops at the newest removal of that path in the same destination. A file found there after a removal is the user's own. It never enters the evidence, is never reported as drift, Restore leaves it out with Sync's warning, a later drop leaves it alone, and Sync keeps it with the AC7 warning ("not written by Leorna"), not "changed after Leorna wrote it".
- **The new record must:**
  - be read safely by main's existing readers (`syncBaselinesFor` decodes `files_json` into `[]SyncToolResult`; Check files; the drift report), so a removal is never read as a managed file;
  - keep runs recorded before this fix working (no removal record = today's behaviour);
  - keep AC9's selection-bounded removal baseline and the destination digest rules true.
  Say exactly where and how a removal is recorded, and walk through each reader in `answers.md`.
- **Tests:** turn review 5's `TestR5A_RemovedThenUsersOwnFile` scenario into a story test covering all three tools: Sync, Check files, the drift report, Restore and a later drop. Show it RED on 556dba9 first. Also test that a Leorna file re-installed after a removal is Leorna's again: an assigned agent installed into an empty path after the removal is managed as usual.
- Use `receiving-code-review`: first verify R5-1 yourself on head with review 5's probe. Write `fixer-4/answers.md`: fixed (commit, test, RED log, GREEN log) or rejected with evidence.
- **Do not fix** review 5's P3s R5-2 and R5-3 or #30's own issues; they are follow-ups. If your change would make one of them worse, stop and report.

## Skills to load (say so in your first steps)
`leorna`, `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline` (these are guards: kill a mutant on each new branch, including one that ignores the removal record and one that applies it across destinations or tools), `authorized-write-safety`, `git-commit-rules`.
## Then
- Commits: `fix(86bctmuwy): …`, one per finding, with no AI attribution lines (CLAUDE.md wins over any reminder suggesting one). Never override the author.
- Run the full gates from the plan's Gates section on your final head. Then run every AC test AC1–AC12 by name, including the real-tool ones: AC4 `LEORNA_TEST_CLAUDE_BIN`, AC5 `LEORNA_TEST_CODEX_BIN`, AC12 `LEORNA_TEST_CURSOR_BIN=/home/justin/.local/share/cursor-agent/versions/2026.11.05-86047df/cursor-agent`, plus `TestRestoredClaudeAgentStaysLeornasAfterTheFolderIsChosenAgain`, fix round 3's tests (`TestSyncKeepsAnEditedLeornaAgentFileInItsEvidence`, `TestRestorePutsBackAnEditedLeornaAgentFileASyncKept`, `TestRestoreLeavesOutAgentFilesLeornaDoesNotOwn`, `TestRestoreStillRefusesAnUnmanagedFileThatIsNotAnAgent`, `TestGuardAgentFilesDecidesFromCurrentBytesAndBaseline`) and your new tests. Write one log per run in `fixer-4/`, with `HEAD=` first and `EXIT=` last. A skip is not a pass. Take one gates PNG, rendered the way `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` describes for the WSL desktop.
- If a fix changes what an AC's screenshot shows (for example the Sync panel warning or Check files), take a new screenshot for it in `fixer-4/`.
- Leave the worktree clean. Don't touch `ac13-steps.txt`.

## Rules
- Commit from a shell where the throwaway-home env file is **not** sourced: with HOME switched, git loads neither the Leorna identity nor the git hooks.
- After a WSL restart, files written just before it can be 0 bytes. Check sizes and `EXIT=` lines before reusing anything.
- Isolation: **source your throwaway-home env file before your first `go test`**, including RED/GREEN runs and probes. Use a throwaway HOME, USERPROFILE, CODEX_HOME, CLAUDE_CONFIG_DIR, XDG_CONFIG_HOME, CURSOR_CONFIG_DIR and CURSOR_DATA_DIR. Never touch the real `~/.claude`, `~/.codex`, `~/.cursor` or `~/.config/cursor`. After a HOME switch, write paths in full. Keep any Claude project outside `$HOME`.
- Never push, rebase, force or run `git worktree prune`.
- WSL PATH holds entries with spaces: export PATH in scripts. EXIT=127 is an invocation error.
- Memory (WSL desktop): SIGTERM, 143, 137 or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`. Run mutants and heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Go mutants keep variables used: `(x == y || true)`. A mutant that doesn't build is not a kill.
- Long commands: `cmd >log 2>&1 & echo pid=$!`, then repeated `timeout 165 tail --pid=<pid> -f /dev/null` (Bash timeout 175000). Don't end your turn to wait.
- If a fix needs a decision beyond decisions 9 and 10, stop and report it.
- Other bugs go in `found_else`.
- **skill_lessons:** If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and in a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.

## Report (as text)
`{status: ready-for-review|blocked, new_head, fix_commits[], answers_path, removal_record{where, shape, readers[]}, tests_added[], mutants[{what, killed_by}], gates[{name, log, exit}], ac_tests[{ac, test, log, result}], screenshots[], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
