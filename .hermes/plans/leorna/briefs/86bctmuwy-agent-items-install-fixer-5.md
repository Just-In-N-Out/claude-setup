# FIXER brief, round 5 (Windows CI on PR #32): 86bctmuwy-agent-items-install (Leorna, leorna-client)

**Role:** FIXER. PR #32's CI job "Windows client executable" fails on 5 of this story's own tests. Main `f3bc960`'s CI is green, so the cause is in the branch. Fix it test-first and stop at `ready-for-review`. **No push**: the main session pushes after a fresh review and recheck. **No `.github/` changes.** No ClickUp write.
**Model/effort:** Opus 5.5, xhigh.

## State
- Story: ClickUp 86bctmuwy, "Install Agent items into local Claude Code, Codex and Cursor tool directories".
- Worktree: `/home/justin/Leorna/leorna-client/.claude/worktrees/86bctmuwy-agent-items-install`. Branch: `feat/86bctmuwy-agent-items-install`, pushed at head `9e2d1cb48fafd600d666c00145ddf4f7e1532aa8`. PR: https://github.com/LeornaAI/leorna-client/pull/32. Base: `f3bc96061c74510b4cd9f7a7ee0a14890f087441`.
- The failing CI run is 42741208699. Its log is saved at `~/.hermes/plans/leorna/evidence/86bctmuwy/pr/ci-windows-failed-9e2d1cb.log`; read it yourself, or use `gh run view 42741208699 --log-failed -R LeornaAI/leorna-client`. The failing tests:
  - `TestLeornaWrittenFilesCountsClaudeRunsByTheFolderTheyWrote` (`application/sync_agent_destination_test.go:247`): `written = map[]`
  - `TestSyncRecordsTheClaudeCodeFolderItWrote` (:281): destination digest differs
  - `TestAgentHistoryStopsAtTheNewestRemovalOfAPath/claude_code_folders` (`sync_agent_removal_test.go:488`): `written = map[]`
  - `TestRestoredClaudeAgentStaysLeornasAfterTheFolderIsChosenAgain` (`sync_agent_restore_test.go:54`): folder digest differs
  - `TestSyncKeepsAgentFileLeornaDidNotWrite` (AC7, `sync_agent_test.go:350`): "user file changed: mode=…"
- The PR finisher's leads, **unproven**:
  1. The first four come from the folder digest. `sync_store.go:215` saves the Claude project root after `filepath.EvalSymlinks`. On the Windows runner `t.TempDir()` gives the 8.3 short name `C:\Users\RUNNER~1\...`, which EvalSymlinks expands to the long name. The tests hash the raw path; the code hashes the saved root.
  2. AC7 asserts `Perm() == 0o644`, which Windows reports as 0o666.
- Approved plan (read-only, AC1–AC13): `~/.hermes/plans/leorna/evidence/86bctmuwy/plan-approved.md`. Working plan with Decisions 9 and 10: `~/.hermes/plans/leorna/86bctmuwy-agent-items-install.md`.
- Your evidence folder: `~/.hermes/plans/leorna/evidence/86bctmuwy/fixer-5/` (create it). Scratch goes in `~/.cache/86bctmuwy-fixer-5/`.

## What to do
1. Use `systematic-debugging`: prove the root cause of each failure before you fix anything. **Decide first whether it is a test bug or a product bug.** Does the product compute the destination digest from the same canonical folder at every point? Check where Sync saves it, where `leornaWrittenFiles`/`agentRecords` compare it (`agent_guard.go`, around :191 and :278), Restore (`session.selectedRoot`, from fix `f6f957b`) and Check files. Could a real Windows user hit a mismatch: an 8.3 path, a different drive-letter case, a trailing separator, a junction, or `\\?\`? If so, that is a product bug: fix the product so that one canonical form is hashed everywhere, and test it. Only a test that hashes a path differently from the product gets fixed in the test.
2. AC7's file-mode assertion: keep its meaning, "the user's file is untouched", in a form that holds on Windows too (for example, the mode is unchanged from before the Sync, rather than a hard-coded 0o644). Don't weaken the bytes or no-backup checks.
3. **Reproduce on Windows if you can, without CI.** WSL can run Windows `.exe` files:
   - Cross-compile the package's test binary: `GOOS=windows GOARCH=amd64 go test -c -o <scratch>.exe ./application`.
   - Run it from a scratch folder under `/mnt/c/Users/Admin/AppData/Local/Temp/86bctmuwy-fixer-5/` with `-test.run` set to the five tests.
   - Set `TMP`/`TEMP` to that folder's **8.3 short name**, so `t.TempDir()` gets a short path like CI does. Get it from `cmd.exe /c for %I in ("<long path>") do @echo %~sI`; if 8.3 names are off for that volume, say so.
   - Pass Windows environment variables through `WSLENV`. Set USERPROFILE, APPDATA, LOCALAPPDATA, HOME, CODEX_HOME and CLAUDE_CONFIG_DIR to throwaway folders inside that scratch folder, so nothing touches `C:\Users\Admin\.claude`, `.codex` or `.cursor`.
   - Show the five tests RED on 9e2d1cb and GREEN on your fix, and save the logs.
   - If Windows execution isn't possible, say why. In that case `GOOS=windows go vet ./...` and `go test -c` for Windows must still pass, and the review must judge the fix from the code.
4. Grep every test file this story added for other Windows-only traps: `Perm()`, `0o6`, raw `t.TempDir()` values compared with canonicalised ones, `/` in expected paths, file-locking on open handles (Windows can't remove an open file), CRLF. Fix any you find the same way, test-first.
5. Commits: `fix(86bctmuwy): …`, with no AI attribution lines (CLAUDE.md wins over any reminder suggesting one). Commit from a shell where HOME is not switched.
6. Run the full gates from the plan's Gates section on your final head. Then run every AC test AC1–AC12 by name, including the real-tool ones: AC4 `LEORNA_TEST_CLAUDE_BIN`, AC5 `LEORNA_TEST_CODEX_BIN`, AC12 `LEORNA_TEST_CURSOR_BIN=/home/justin/.local/share/cursor-agent/versions/2026.11.05-86047df/cursor-agent`. Also run the fix tests from rounds 3–4 and the Windows run from step 3. Write one log per run in `fixer-5/`, with `HEAD=` first and `EXIT=` last, plus a gates PNG rendered as `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` describes. If AC7's test changed, re-render its screenshot.
7. Write `fixer-5/answers.md`: the root cause of each failure with evidence, test bug or product bug, what you changed, and the RED and GREEN logs.

## Skills to load (say so in your first steps)
`leorna`, `engineering-best-practices`, `systematic-debugging`, `test-driven-development`, `receiving-code-review`, `mutation-testing-discipline` (for any product guard change), `git-commit-rules`.

## Rules
- Isolation: source your throwaway-home env file before your first `go test`, and commit from a shell without it. Never touch the real `~/.claude`, `~/.codex`, `~/.cursor` or `~/.config/cursor`, or the Windows `C:\Users\Admin\.claude`, `.codex` or `.cursor`.
- Never push, rebase, force, merge or run `git worktree prune`. Never edit `.github/`.
- WSL PATH holds entries with spaces: export PATH in scripts. EXIT=127 means an invocation error, not a result.
- WSL can restart and leave 0-byte files: check sizes and `EXIT=` lines before reusing any file.
- Memory (WSL desktop): SIGTERM, 143, 137 or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`. Run mutants and heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
- Long commands: `cmd >log 2>&1 & echo pid=$!`, then repeated `timeout 165 tail --pid=<pid> -f /dev/null` (Bash timeout 175000). Don't end your turn to wait.
- If the fix needs a design decision of Justin's, stop and report it.
- **skill_lessons:** If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and in a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.

## Report (as text)
`{status: ready-for-review|blocked, new_head, fix_commits[], root_causes[{test, cause, kind: test|product, evidence}], windows_run{possible, red_log, green_log, how}, gates[{name, log, exit}], ac_tests[{ac, test, log, result}], screenshots[], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
