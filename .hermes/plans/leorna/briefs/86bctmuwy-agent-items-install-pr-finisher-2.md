# FINISHER brief (PR #32 update after the Windows CI fix): 86bctmuwy-agent-items-install (Leorna, leorna-client)

**Role:** FINISHER, finishing "make a PR". Justin said "Push pr and click up" on 2026-11-10. [PR #32](https://github.com/LeornaAI/leorna-client/pull/32) is open at `9e2d1cb`, and CI's "Windows client executable" job failed on 5 test-only bugs (run 42741208699). Fix round 5 fixed them on `d42aa58`. Push `d42aa58` to the same branch, refresh the PR body, wait for CI and report. **Never merge.** **Hold the ClickUp post** until the PR is merged (`leorna` 7.9); the main session posts it.
**Model/effort:** Opus 5.5, high.

## State
- Worktree: `/home/justin/Leorna/leorna-client/.claude/worktrees/86bctmuwy-agent-items-install`. Branch: `feat/86bctmuwy-agent-items-install`. Local head: `d42aa5875d2bb6290ff048cc3a1ae592f65d67b0`. `origin/feat/86bctmuwy-agent-items-install` is at `9e2d1cb`. Base: `f3bc96061c74510b4cd9f7a7ee0a14890f087441`.
- The fix commits are `20fe7b5`, `3514f6e`, `bf5e6fe` and `d42aa58`. They change test files only; no product code and no `.github/`. The root causes:
  - The tests hashed Windows' 8.3 temp path, while the product hashes the resolved folder.
  - AC7 asserted POSIX file permissions.
  - Write-up: `~/.hermes/plans/leorna/evidence/86bctmuwy/fixer-5/answers.md`.
- Review 7 is clean (MOVE ON at `d42aa58`). Verifier 3 and blind auditor 3 are both clean. `ac-check.sh --reviews` printed `READY FOR THE USER: 12 of 13 ACs proven on d42aa58; live ACs owed to the user: AC13`.
- Receipts on `d42aa58`: `~/.hermes/plans/leorna/evidence/86bctmuwy/verifier-3/` (gates, AC1–AC12 head and base logs, `win-full-d42aa58.log`: native Windows `./application` 107/107) and `auditor-3/`.
- PR body file: `/home/justin/.hermes/cache/scratch/leorna-pr-86bctmuwy-agent-items-install.md`. ClickUp draft: `/home/justin/.hermes/cache/scratch/leorna-clickup-86bctmuwy.md`. Your earlier PR receipts: `~/.hermes/plans/leorna/evidence/86bctmuwy/pr/`. Reusable scripts: `~/.cache/86bctmuwy-pr/scripts/`.
- Your evidence folder: `~/.hermes/plans/leorna/evidence/86bctmuwy/pr-2/` (create it).

## Skills to load (say so in your first steps)
`leorna` (step 7), `engineering-best-practices`, `git-commit-rules`, `github`.

## What to do
1. Fetch main over HTTPS through gh, as `leorna` 7.1 says. If main moved past `f3bc960`, **stop and report**. Run the pre-flight (`leorna` 7.2): clean status, `HEAD` equals `d42aa58`, one Leorna identity, no AI attribution lines, no `.github/` paths, a clean merge-tree, merge-base equal to `origin/main`. Check `gh pr view 32 --json state` is OPEN.
2. Re-run the plan's three Linux gates on `d42aa58` (`make check`, `node --test scripts/*-ui.test.cjs`, `make lint audit` with CI's pinned golangci-lint 2.14.0 and govulncheck 1.7.0) with a throwaway HOME. Write logs and a `SUMMARY.txt` into `pr-2/`. Don't rerun the AC tests: cite verifier 3 and auditor 3 on this exact head.
3. Refresh the PR body file.
   - Test Plan: this session's gates on `d42aa58` (`pr-2/`); verifier 3 and auditor 3 on `d42aa58`, with AC1–AC12; native Windows `./application` 107/107 (`verifier-3/win-full-d42aa58.log`); AC13 unchecked and owed.
   - A short note: "CI's Windows job failed on 9e2d1cb on 5 test-only bugs (8.3 temp paths, POSIX file modes); fixed in tests, no product change."
   - Keep the note that main was brought in at `f3bc960`, and decisions 9 and 10.
   - Add the new P3 follow-ups from `~/.hermes/plans/leorna/evidence/86bctmuwy/follow-ups.md` (2026-11-10 lines), and main's Windows junction issue from `~/.hermes/plans/leorna/found-else.md` as a note about main.
   - No AI attribution, URL, email or bare card ID.
4. Push, using the HTTPS gh form with the URL written out (`leorna` 7.6): `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/leorna-client.git feat/86bctmuwy-agent-items-install:refs/heads/feat/86bctmuwy-agent-items-install`. This is a fast-forward from `9e2d1cb`; never force. Fetch it back, then check `git rev-parse HEAD origin/<branch>` match. If git-guard asks, Justin said "push pr".
5. Update the PR body with `gh pr edit 32 -R LeornaAI/leorna-client --body-file <file>`. Read it back with `gh pr view 32 --json number,url,state,headRefOid,mergeable,mergeStateStatus`; `headRefOid` must be `d42aa58…`.
6. Wait for CI on `d42aa58` with bounded waits, and report every check, especially "Windows client executable". If a check fails, save its failed log into `pr-2/` and stop and report; don't fix anything.
7. After CI, re-read GitHub main and the open PRs, and merge-tree any new one against this head.
8. Records: add a dated line to the shared `leorna-workflow.md` (memory folder `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`; use the real folder) giving the PR, head `d42aa58`, the CI result, "AC13 owed", and "ClickUp post held until merge". The `skill_lessons` rule covers skills and lessons only; this status line is your job. Also update the head and Test Plan facts in the ClickUp draft, leaving the merge facts as placeholders.

## Rules
- Never merge, rebase, force-push, `gh auth switch`, or change a remote or credential helper. Never override the author. Make no new commits.
- Isolation: a throwaway HOME and tool config folders for every test. Never touch the real `~/.claude`, `~/.codex`, `~/.cursor` or `~/.config/cursor` beyond the memory note above.
- WSL PATH holds entries with spaces: export PATH in scripts. EXIT=127 means an invocation error, not a result.
- WSL can restart and leave 0-byte files: check sizes and `EXIT=` lines before citing anything.
- Memory (WSL desktop): SIGTERM, 143, 137 or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`. Run heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
- Long commands: `cmd >log 2>&1 & echo pid=$!`, then repeated `timeout 165 tail --pid=<pid> -f /dev/null` (Bash timeout 175000). Don't end your turn to wait.
- **skill_lessons:** If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and in a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.

## Report (as text)
`{status: pr-ready|ci-red|blocked, pr{number, url, head, state, mergeable, mergeStateStatus}, ci[{check, result}], gates[{name, log, exit}], main_now, open_prs_merge_tree[], records_updated[], clickup: "held until merge", found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
