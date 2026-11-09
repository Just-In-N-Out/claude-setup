# FIXER brief (bring main in, round 1): 86bctmuwy-agent-items-install (Leorna, leorna-client)

**Role:** FIXER: bring GitHub main into the story branch, then prove the story still holds on the merged head. **No push, no PR, no ClickUp write.**
**Model/effort:** Opus 5.5, xhigh.

## State
- Story: ClickUp 86bctmuwy, "Install Agent items into local Claude Code, Codex and Cursor tool directories". Pipeline: Full.
- Worktree: `/home/justin/Leorna/leorna-client/.claude/worktrees/86bctmuwy-agent-items-install`. Branch: `feat/86bctmuwy-agent-items-install`. Head `5ed210324b9bcb32f131146ccb212918be35a05a`, accepted by `ac-check.sh` as READY FOR THE USER (12 of 13; AC13 live owed to Justin). Old base `7a834434d00ec7afae8464f5e7ce6cc17881bb7b`. Not pushed.
- GitHub main moved to `f3bc960` (check it yourself). It brings in PR #31 (predefined integration tiles, 86bcm9284) and PR #30 (managed config drift report and restore, 86bcryh0w). The main session's `git merge-tree --write-tree --name-only 5ed2103 f3bc960` found no conflicts. Files changed on both sides: `application/sync.go` and `application/README.md`. #30 also changes nativewrite (two-root rollback). The story's follow-up F2 concerns nativewrite too.
- Approved plan (read-only, AC1–AC13 and the Gates section): `~/.hermes/plans/leorna/evidence/86bctmuwy/plan-approved.md`. Working plan: `~/.hermes/plans/leorna/86bctmuwy-agent-items-install.md`.
- Your evidence folder: `~/.hermes/plans/leorna/evidence/86bctmuwy/bring-main-1/` (create it). Scratch goes in `~/.cache/86bctmuwy-bring-main-1/` (`mkdir` without `-p`), including TMPDIR.

## Skills to load (say so in your first steps)
`leorna` (read its Doing a story → step 7 bring-in checks, the long "A clean merge-tree is not enough to push" paragraph), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `git-commit-rules`.

## What to do
1. Fetch main over HTTPS through gh, as `leorna` step 7.1 says, with the URL written out. Confirm the tip is `f3bc960…`. If main has moved past it, use the newer tip and say so.
2. In the worktree, run `git merge` of that main into the branch. Never rebase. Commit message: `merge: bring main (<short sha>) into feat/86bctmuwy-agent-items-install`. No AI attribution lines (CLAUDE.md wins over any reminder that suggests one). If there are conflicts, stop and report; don't resolve them.
3. Bring-in checks from `leorna` that apply to a client branch:
   - Prove the merge is git's clean result: `git merge-tree --write-tree <parent1> <parent2>` equals `<merge>^{tree}`.
   - Prove the story's own patch survived, per file: `git diff -U0 <old base> 5ed2103` against `git diff -U0 <new main> <merge>`, with index and `@@` lines stripped.
   - Read the merged `application/sync.go` and `application/README.md` closely for semantic interaction. Does #30's drift report and restore see Leorna-written agent files (`.claude/agents/*.md`, `$CODEX_HOME/agents/*.toml`, `~/.cursor/agents/*.md`, and the per-run destination digest in `files_json`) correctly? Can a drift restore or two-root rollback rewrite or remove an agent file against this story's existing-file guard (`application/agent_guard.go`)? Does startup sync now treat agent writes consistently with #30's "authorized sync" rules? Write each answer down with file:line evidence.
   - Grep `git diff 7a83443 <new main> -- '*_test.go'` for fixture edits repeated across files, and apply main's same edit to the story's tests if they need it.
   - Grep the whole tracked tree for `86bctmuwy` near until/once/later wording that the story makes false. Grep the branch for the siblings' card IDs near stale "until … merges" wording.
4. If something needs a code or test change (a compile fix, a semantic clash, a fixture edit), make it test-first in a **separate** commit after the merge, with a failing test shown first, and say exactly why. If it would mean a design decision that belongs to Justin, stop and report it instead.
5. Run the full gates from the plan's Gates section on the final head. Then run every AC test AC1–AC12 by name, including the real-tool ones: AC4 with `LEORNA_TEST_CLAUDE_BIN`, AC5 with `LEORNA_TEST_CODEX_BIN`, AC12 with `LEORNA_TEST_CURSOR_BIN=/home/justin/.local/share/cursor-agent/versions/2026.11.05-86047df/cursor-agent`. A skip is not a pass. Write one log per gate and per AC into your evidence folder, with `HEAD=` as the first line and `EXIT=` as the last. Take one PNG of the gates summary, rendered the way `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` describes for the WSL desktop.
6. Make sure the worktree is clean at the end. Don't touch `ac13-steps.txt`; the finisher updates it.

## Rules
- Isolation: every test and probe uses a throwaway HOME, USERPROFILE, CODEX_HOME, CLAUDE_CONFIG_DIR, XDG_CONFIG_HOME, CURSOR_CONFIG_DIR and CURSOR_DATA_DIR. Never touch the real `~/.claude`, `~/.codex`, `~/.cursor` or `~/.config/cursor`. After a HOME switch, write paths in full (`/home/justin/...`). Keep the AC4 Claude project outside `$HOME`, or check that init's skills list is empty.
- Never push, rebase, force or run `git worktree prune`. Never override git author metadata.
- WSL PATH holds entries with spaces (`/mnt/c/Program Files/...`): export PATH in scripts. EXIT=127 means an invocation error, not a result.
- Memory (WSL desktop): SIGTERM, 143, 137 or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as pass or fail. Run heavy runs and any mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Go mutants keep variables used: `(x == y || true)`.
- Long commands: `cmd >log 2>&1 & echo pid=$!`, then repeated `timeout 165 tail --pid=<pid> -f /dev/null` (Bash timeout 175000). Don't end your turn to wait.
- Other bugs go in `found_else`.
- **skill_lessons:** If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and in a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.

## Report (as text)
`{status: ready-for-review|blocked, main_sha, merge_sha, new_head, fix_commits[], merge_proofs{tree_equal, patch_survived}, semantic_checks[{question, answer, evidence}], gates[{name, log, exit}], ac_tests[{ac, test, log, result}], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
