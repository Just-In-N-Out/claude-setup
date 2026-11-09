# FIXER brief, round 3 (after review 4): 86bctmuwy-agent-items-install (Leorna, leorna-client)

**Role:** FIXER. Fix review 4's P2 findings R4-1 and R4-2, the way Justin decided (decision 9), test-first. Then stop at `ready-for-review`. **No push, no PR, no ClickUp write.**
**Model/effort:** Opus 5.5, xhigh.

## State
- Story: ClickUp 86bctmuwy, "Install Agent items into local Claude Code, Codex and Cursor tool directories". Pipeline: Full.
- Worktree: `/home/justin/Leorna/leorna-client/.claude/worktrees/86bctmuwy-agent-items-install`. Branch: `feat/86bctmuwy-agent-items-install`. Head: `f6f957b2249b00d2d7d5ea7929dae85855e5b214`. That is merge `1fa24d9` of GitHub main `f3bc960` (#30 managed config drift report and restore; #31) plus fix `f6f957b`. Merge base: `f3bc96061c74510b4cd9f7a7ee0a14890f087441`. Not pushed.
- Approved plan (read-only, AC1–AC13): `~/.hermes/plans/leorna/evidence/86bctmuwy/plan-approved.md`. Working plan with **Decision 9** at the end: `~/.hermes/plans/leorna/86bctmuwy-agent-items-install.md`. Justin's record: `~/.hermes/plans/leorna/evidence/86bctmuwy/bring-main-1/justin.json`.
- Review 4: `~/.hermes/plans/leorna/evidence/86bctmuwy/review-4/review.json`, with its probes in `probes/` and logs in `logs/`. The bring-in fixer's probes and report are in `bring-main-1/`.
- Your evidence folder: `~/.hermes/plans/leorna/evidence/86bctmuwy/fixer-3/` (create it). Scratch goes in `~/.cache/86bctmuwy-fixer-3/` (`mkdir` without `-p`), including TMPDIR.

## What to fix (decision 9, Justin, 2026-11-09: "Report + skip")
- **R4-2 (report half).** When a Sync keeps a user-edited Leorna agent file ("changed after Leorna wrote it"), the file stays in that tool's evidence with its last recorded hash. Check files and the admin drift report then keep showing it as modified, not clean, and Restore can put it back after a preview. Keep the existing-file guard's ownership rules true:
  - authorship through the per-run destination digest (`syncToolEvidence.Destination`);
  - the selection-bounded removal baseline (AC9);
  - a user's own file (one Leorna never wrote) never enters the evidence.
  Say exactly how the carried-forward row is recorded, so a later Sync, a restore or a re-selected folder treats it correctly. Prove it with tests for all three tools.
- **R4-1 (restore half).** Restore uses the same agent guard as Sync. It leaves out agent paths Leorna doesn't own (a user's own file at the path, or an agents folder that is a link), shows the same warning text in the preview, and restores the tool's other files instead of refusing the whole tool. A Leorna agent file the user edited, now still in the evidence because of R4-2, is restored after the preview as #30 intends. A link must never be followed, and no absolute path may show up in the warning.
- **R4-3 (P3, optional, small):** one README sentence saying that Restore removes an edited Leorna agent file, after a preview and with a backup, when the approved version dropped it, whereas Sync keeps it.
- **Do not fix** #30's own issues found in review 4's `found_else` (restore un-enrolling other tools from auto-sync, the Codex/Cursor baseline time bound, raw error paths). They are main's code and become their own story. If your change would make one of them worse, stop and report.
- Use `receiving-code-review`: first verify each finding yourself by rerunning review 4's probes C, D and I on head. Write `fixer-3/answers.md` with one entry per finding: fixed (commit, test, RED log, GREEN log) or rejected with evidence.

## Skills to load (say so in your first steps)
`leorna`, `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline` (these are guards: kill a mutant on each new branch), `authorized-write-safety`, `git-commit-rules`.

## Then
- Commits: `fix(86bctmuwy): …`, one per finding, with no AI attribution lines (CLAUDE.md wins over any reminder suggesting one). Never override the author.
- Run the full gates from the plan's Gates section on your final head. Then run every AC test AC1–AC12 by name, including the real-tool ones: AC4 `LEORNA_TEST_CLAUDE_BIN`, AC5 `LEORNA_TEST_CODEX_BIN`, AC12 `LEORNA_TEST_CURSOR_BIN=/home/justin/.local/share/cursor-agent/versions/2026.11.05-86047df/cursor-agent`, plus `TestRestoredClaudeAgentStaysLeornasAfterTheFolderIsChosenAgain` and your new tests. Write one log per run in `fixer-3/`, with `HEAD=` first and `EXIT=` last. A skip is not a pass. Take one gates PNG, rendered the way `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` describes for the WSL desktop.
- If a fix changes what an AC's screenshot shows (for example the Sync panel warning or Check files), take a new screenshot for it in `fixer-3/`.
- Leave the worktree clean. Don't touch `ac13-steps.txt`.

## Rules
- Isolation: **source your throwaway-home env file before your first `go test`**, including RED/GREEN runs and probes. Use a throwaway HOME, USERPROFILE, CODEX_HOME, CLAUDE_CONFIG_DIR, XDG_CONFIG_HOME, CURSOR_CONFIG_DIR and CURSOR_DATA_DIR. Never touch the real `~/.claude`, `~/.codex`, `~/.cursor` or `~/.config/cursor`. After a HOME switch, write paths in full. Keep any Claude project outside `$HOME`.
- Never push, rebase, force or run `git worktree prune`.
- WSL PATH holds entries with spaces: export PATH in scripts. EXIT=127 is an invocation error.
- Memory (WSL desktop): SIGTERM, 143, 137 or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`. Run mutants and heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Go mutants keep variables used: `(x == y || true)`. A mutant that doesn't build is not a kill.
- Long commands: `cmd >log 2>&1 & echo pid=$!`, then repeated `timeout 165 tail --pid=<pid> -f /dev/null` (Bash timeout 175000). Don't end your turn to wait.
- If a fix needs a decision beyond decision 9, stop and report it.
- Other bugs go in `found_else`.
- **skill_lessons:** If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and in a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.

## Report (as text)
`{status: ready-for-review|blocked, new_head, fix_commits[], answers_path, tests_added[], mutants[{what, killed_by}], gates[{name, log, exit}], ac_tests[{ac, test, log, result}], screenshots[], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
