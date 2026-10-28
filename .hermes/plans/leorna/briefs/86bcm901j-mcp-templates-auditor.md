# AC AUDITOR brief (blind, read only): leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs"

Written by the main session (orchestrator) on 2026-10-28. Model: Opus 5.5, xhigh.

## Your role

You are a fresh, **blind AC AUDITOR**. Your one job: prove, on your own, whether each acceptance criterion in the approved plan is met on the given head, and write `auditor/ac.json`. **Change no source:** no edit, commit, push, merge, PR or ClickUp write; leave the worktree exactly as you found it (`git status --porcelain --untracked-files=all` empty, HEAD unchanged).

**Stay blind.** You may read only:
- the approved plan: `~/.hermes/plans/leorna/evidence/86bcm901j/plan-approved.md`;
- the code in the worktree and its git history;
- your own folder `~/.hermes/plans/leorna/evidence/86bcm901j/auditor/` (create it);
- the skills and references named below.

**Don't open** anything else under `~/.hermes/plans/leorna/evidence/86bcm901j/` (other roles' folders, logs, screenshots, `INVENTORY.md`, summaries), any other brief in `~/.hermes/plans/leorna/briefs/`, `~/.hermes/plans/leorna/86bcm901j-handoff.md` or `found-else.md`. Don't look for other agents' reports or transcripts. Every receipt you cite must be one you made, inside `auditor/`.

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna` (skip its Step 1 full context load)
2. `engineering-best-practices`
3. `security-best-practices` (required for every role on this story)

Then read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` in full (the folders, the run recipe for head and base, screenshots, the report and the self-check) and the report format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

## The candidate

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`, branch `feat/86bcm901j-mcp-templates`.
- **Head:** `66449af4572d4bf9a4f431973b27cdb124d2a784`.
- **Base commit:** `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d` (confirm with `git -C <worktree> merge-base HEAD origin/main`).
- **ACs:** AC1–AC5 as written in the approved plan's "Acceptance criteria" section, with each AC's test name, command, and base-commit check (which test files to copy to base). None is `(live)`.

## What to do

For each AC:
1. Read the AC and its test in the code, and judge whether the test really checks what the AC says (every clause). If a clause seems untested, probe it (for example with a `go test -overlay` mutant of the code it depends on, read only) and record what you found.
2. Run the AC's own test by name on the head (from the worktree), saving `auditor/ac<n>-<head7>.log` with `HEAD=` and `EXIT=` lines, exactly as `ac-verification.md` describes.
3. Run it on the base in a separate detached copy with head's versions of that AC's test files, one AC at a time, following the recipe exactly, saving `auditor/ac<n>-base-<base7>.log`. It must fail there (its own fail line, or a build failure of the new code); a test that never ran doesn't count.
4. Take your own screenshot per AC (a terminal capture of the head run): `auditor/ac<n>-<what>-<head7>.png`, and look at it (command, PASS lines and EXIT visible; no token or server address).

Then write `auditor/ac.json` in the format at the top of `ac-check.sh` and self-check it as `ac-verification.md` says: copy (never link) your `ac.json`, logs and images to a scratch folder outside the evidence tree, run `ac-check.sh --repo <worktree> --base <base> --plan <evidence>/plan-approved.md <your ac.json> <scratch copy>/ac.json`, read its last line, then delete the copy.

## Environment

- Windows desktop (Ubuntu under WSL). Go and CI-pinned tools are under `~/.local/leorna-tools` (use read-only; never modify or delete them or other sessions' `~/.local/leorna-toolchain`); gcc and make are system-wide; gitleaks 8.30.1 is at `/usr/local/bin/gitleaks`.
- **AC5** runs real Codex and Claude Code: set `LEORNA_TEST_CODEX_BIN` and `LEORNA_TEST_CLAUDE_BIN` as the plan says. They run only in throwaway homes; never run `codex` or `claude` against Justin's real `~/.codex` or `~/.claude`, even for `--version`.
- **Screenshots:** headless Chrome for Testing works inside the sandbox with the flags recorded in `ac-verification.md` (the WSL desktop line).
- **Disk:** `/tmp` is a small tmpfs shared by every session. Put `TMPDIR`, detached copies and caches in `~/.cache/86bcm901j-auditor/` on the real disk (`mkdir`, no `-p`; remove it at the end).
- **Scratch:** `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-auditor/` with `mkdir` (no `-p`), small notes only. The scratchpad is shared by every subagent in this session; never touch or read other folders in it. Remove your folders at the end (after `git worktree remove` for every copy). If you start a background `tail -f`, stop the tail itself afterwards.
- **Never touch** other stories' worktrees, branches, databases or caches (`86bcm901a`, `86bcm901b`, `86bcm901w`), and never switch the main checkout's branch. Never print a token or password.

## Rules

- **Other bugs:** list them in `found_else` (one line each, with evidence and severity).
- **Skill lessons:** don't edit any skill or memory file: list them in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`
- If you wait on a long command, wait in the foreground (a bounded poll), not by ending your turn.

## What to return

`{verdict: clean|findings, audited_head, base, ac_status[{ac, accepted, test, screenshot, evidence}], clause_checks[{ac, clause, covered, evidence}], ac_json: "<path>", ac_check_self: "<last line>", found_else[], skill_lessons[]}`. `verdict` and `ac_status` are required. Plain words.
