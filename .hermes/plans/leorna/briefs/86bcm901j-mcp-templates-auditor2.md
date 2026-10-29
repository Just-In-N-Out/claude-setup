# AC AUDITOR brief (blind, read only, round 2): leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs"

Written by the main session (orchestrator) on 2026-10-29. Model: Opus 5.5, xhigh.

## Your role

You are a fresh, **blind AC AUDITOR**. Your one job: prove, on your own, whether each acceptance criterion in the approved plan is met on the given head, and write `auditor-f2892bc/ac.json`.

**Change no source.** Make no edit, commit, push, merge, PR comment or ClickUp write. Leave the worktree exactly as you found it: `git status --porcelain --untracked-files=all` empty and HEAD unchanged.

**Stay blind.** You may read only:
- the approved plan, `~/.hermes/plans/leorna/evidence/86bcm901j/plan-approved.md`;
- the code in the worktree and its git history;
- your own folder `~/.hermes/plans/leorna/evidence/86bcm901j/auditor-f2892bc/` (create it);
- the skills and references named below.

**Don't open** anything else under `~/.hermes/plans/leorna/evidence/86bcm901j/`: other roles' folders, logs, screenshots, `INVENTORY.md`, `handover/` or summaries. Also don't open:
- any brief in `~/.hermes/plans/leorna/briefs/` other than this one;
- `~/.hermes/plans/leorna/86bcm901j-handoff.md`, `found-else.md` or the plan's working copy;
- other agents' reports or transcripts.

Every receipt you cite must be one you made, inside `auditor-f2892bc/`.

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna` (skip its Step 1 full context load)
2. `engineering-best-practices`
3. `security-best-practices`: required for every role on this story.

Then read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` in full: the folders, the run recipe for head and base, screenshots, the report and the self-check. Also read the report format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

## The candidate

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`, branch `feat/86bcm901j-mcp-templates`.
- **Head:** `f2892bc2dddb829b46d6c4be3557c3ecdfa89538`.
- **Base commit:** `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f`. Confirm it with `git -C <worktree> merge-base HEAD origin/main`, after fetching main fresh over HTTPS through gh (`leorna` step 7.1).
  - The plan names an older base, `1ee7157`. Main has been merged into the branch since then, so use `6c1709e` for every base run.
- **ACs:** AC1–AC5, as written in the approved plan's "Acceptance criteria" section, with each AC's test name, command and base-commit check (which test files to copy to base). None is `(live)`.

## What to do

For each AC:
1. **Judge the test.** Read the AC and its test in the code, and judge whether the test really checks what the AC says, clause by clause. If a clause seems untested, probe it (for example with a read-only `go test -overlay` mutant of the code it depends on) and record what you found.
2. **Run it on the head.** Run the AC's own test by name from the worktree, saving `auditor-f2892bc/ac<n>-<head7>.log` with `HEAD=` and `EXIT=` lines, exactly as `ac-verification.md` describes.
3. **Run it on the base.** Use a separate detached copy with head's versions of that AC's test files, one AC at a time, following the recipe exactly, and save `auditor-f2892bc/ac<n>-base-<base7>.log`.
   - It must fail there: its own fail line, or a build failure of the new code.
   - A test that never ran doesn't count.
4. **Screenshot it.** Take your own terminal capture of the head run per AC: `auditor-f2892bc/ac<n>-<what>-<head7>.png`.
   - Take the page height from Chrome as `ac-verification.md` says.
   - Look at it: the command, the PASS lines and the log's own `EXIT=` line must be visible in the bottom crop, with no token or server address.

Then write `auditor-f2892bc/ac.json` in the format at the top of `ac-check.sh`, and self-check it as `ac-verification.md` says:
- Copy (never link) your `ac.json`, logs and images to a scratch folder outside the evidence tree.
- Run `ac-check.sh --repo <worktree> --base <base> --plan <evidence>/plan-approved.md <your ac.json> <scratch copy>/ac.json`, and read its last line.
- Delete the copy.

## Environment

- **Machine and tools:** the Windows desktop (Ubuntu under WSL). Go and CI-pinned tools are under `~/.local/leorna-tools`: use them read-only, and never modify or delete them or other sessions' `~/.local/leorna-toolchain`. gcc and make are system-wide; gitleaks 8.30.1 is at `/usr/local/bin/gitleaks`.
- **Shell:** `tail` is uutils, so write `tail -n N`. A foreground Bash call moves to the background after 180 s, so poll in steps under 170 s.
- **AC5:** runs real Codex and Claude Code. Set `LEORNA_TEST_CODEX_BIN` and `LEORNA_TEST_CLAUDE_BIN` as the plan says. They run only in throwaway homes: never run `codex` or `claude` against Justin's real `~/.codex` or `~/.claude`, not even for `--version`.
- **Postgres:** if an AC needs it, use your own database `leorna_86bcm901j_auditor2_test` (and `…_auditor2_base_test`).
  - Read the `leorna-test-pg` password first and abort if it's empty.
  - Check the port with `docker port leorna-test-pg 5432`.
  - Drop your databases at the end.
  - Another agent uses its own databases at the same time, so expect some load.
- **Screenshots:** headless Chrome for Testing works inside the sandbox with the flags in `ac-verification.md` (the WSL desktop line).
- **Disk:** `/tmp` is a small tmpfs shared by every session. Put `TMPDIR`, detached copies and caches in `~/.cache/86bcm901j-auditor2/` (`mkdir`, no `-p`) and remove it at the end.
- **Scratch:** `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-auditor2/` (`mkdir`, no `-p`), for small notes only.
  - Never touch or read other folders in it.
  - Remove your folders at the end, after `git worktree remove` for every copy.
  - Stop any background process you started.
- **Never touch** other stories' or other agents' worktrees, branches, databases or caches, and never switch the main checkout's branch. Never print a token or password.

## Rules

- **Other bugs:** list them in `found_else`, one line each, with evidence and severity.
- **Skill lessons:** don't edit any skill or memory file. List lessons in `skill_lessons[{skill, lesson, evidence, enforce}]` and in a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none` or a one-line proposal for a check (its kind, what it checks, where it runs). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`

## What to return

Return, in plain words:

`{verdict: clean|findings, audited_head, base, ac_status[{ac, accepted, test, screenshot, evidence}], clause_checks[{ac, clause, covered, evidence}], ac_json: "<path>", ac_check_self: "<last line>", found_else[], skill_lessons[]}`

`verdict` and `ac_status` are required.
