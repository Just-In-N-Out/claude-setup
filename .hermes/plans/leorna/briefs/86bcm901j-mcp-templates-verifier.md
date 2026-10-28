# VERIFIER brief (read only): leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs"

Written by the main session (orchestrator) on 2026-10-28. Pipeline: **Full**: review 1 → fixer 1 → review 2 → fixer 2 → **verifier (you)** → blind AC auditor → `ac-check.sh` → finisher hand-over. Model: Opus 5.5, xhigh.

## Your role

You are a **fresh, read-only VERIFIER**. You never saw the build, the reviews or the fixes being made. **Change no source:** no edit, commit, push, merge, PR or ClickUp write, and leave the worktree exactly as you found it (`git status --porcelain --untracked-files=all` empty, HEAD unchanged). Write only into `~/.hermes/plans/leorna/evidence/86bcm901j/verifier/`.

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna` (VERIFIER role: gates, evidence; skip its Step 1 full context load)
2. `engineering-best-practices`
3. `security-best-practices`: required for every role on this story.
4. `mutation-testing-discipline`: spot-check that key guards' tests still fail when the guard is loosened.

Then read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` in full and follow its **VERIFIER** steps, and read the report format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

## The candidate

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`, branch `feat/86bcm901j-mcp-templates`.
- **Head:** `f368af2199dffef71609818938a07c1aa26ce644`. **Base:** `git -C <worktree> merge-base HEAD origin/main` (expected `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`). 18 commits.
- **Approved plan (the contract):** `~/.hermes/plans/leorna/evidence/86bcm901j/plan-approved.md`, including `## Justin's answers (2026-10-28)`. ACs **AC1–AC5**, none `(live)`; AC4 and AC5 were proposed and approved. Each AC's test name and command are in the plan's "Acceptance criteria" section, and its base-commit check (which test files to copy to base) right below it.

## What to verify

1. **Gates:** re-run the plan's gates (Task 8) yourself on the head, in a detached copy at the same SHA: `make check` with CI-pinned golangci-lint 2.14.0 and govulncheck v1.7.0 bound by absolute path and Postgres set, `bash ./scripts/test-module-add.sh`, gitleaks on the branch range, the story-shippable check (`python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`), `make library-check`, base vs head by test name, and branch hygiene (no `.github/`, `render/`, OpenAPI, migration, Makefile, seed or `THIRD_PARTY_NOTICES.md` change; every commit `Justin Issa <justin@leorna.com>` with no attribution line; no `CLAUDE.md`).
2. **Every review finding is closed, with no regression from the fixes.** Review 1 (on `7c2c35a`): R1-1 policy skipped itself when its decode failed; R1-2 Codex floor bypass by case-variant keys + denylist; R1-3 reasons repeated a value; R1-4 npx `=` options; R1-5 rule S blind spots (args, URL queries, names); R1-6 two untested guards; R1-7 `history.persistence` doc overclaim; R1-8 `runTool` WaitDelay. Review 2 (on `f36285d`): R2-1 server env (PATH, LD_*, NODE_*…) could change what runs; R2-2 reasons quoted a token pasted into a key; R2-3 nine untested credential words; R2-4 camelCase names and other forms; R2-5 wrong reason for `defaultMode: "manual"`. Their evidence and probes: `…/86bcm901j/review1/` and `…/review2/`; the fixers' dispositions are in `…/86bcm901j/INVENTORY.md` ("Fixer 1", "Fixer 2"). Re-run the reviewers' probe bodies on the head yourself and confirm each now fails the gate without repeating any token in the JSON report, log or summary.
3. **The fixers' rulings** (not yet confirmed by Justin; say whether each is safe): fixer 1: no `env` in Claude Code settings; exact-key allowlists for both floors (Codex `model` refused); extra credential words in the policy only; AC2 subtest name kept. Fixer 2: R2-1 uses a refused list of launch settings, not an env allowlist (so `LOG_LEVEL=debug` stays allowed); R2-2 positions in sorted key order; `"manual"` still refused with the true reason.
4. **AC work (`ac-verification.md` → VERIFIER):** for each AC, run its own test by name on the head and on the base (in a separate detached base copy, with head's versions of that AC's test files, one AC at a time, following the recipe exactly), save `ac<n>-<head7>.log` and `ac<n>-base-<base7>.log` with `HEAD=` and `EXIT=` lines, and take **your own** screenshot per AC (a terminal capture of the run). AC5 needs `LEORNA_TEST_CODEX_BIN` and `LEORNA_TEST_CLAUDE_BIN` and runs only in throwaway homes, never Justin's real `~/.codex` or `~/.claude`. Write `verifier/ac.json` in the format at the top of `ac-check.sh`, then self-check it as `ac-verification.md` says (copy, never link, your `ac.json`, logs and images to a scratch folder outside the evidence tree, run `ac-check.sh` on your own report plus the copy, then delete the copy).

`verdict: clean` requires every AC accepted on this head, every finding closed, and the gates green. Otherwise `findings`, with each open item.

## Environment

- Windows desktop (Ubuntu under WSL). Tools under `~/.local/leorna-tools` (Go, golangci-lint 2.14.0, govulncheck v1.7.0, make, Zig): use them read-only, never modify or delete them or other sessions' `~/.local/leorna-toolchain`. gcc and make are now also installed system-wide.
- **Postgres:** Docker is now on inside Ubuntu and `leorna-test-pg` is running. Either use it with a database you own, `leorna_86bcm901j_verifier_test` (read the container's password first and abort if it's empty; never touch another session's database), or the no-sudo PostgreSQL 18.6 recipe in `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-control-plane-workflow.md`. Read Postgres results per test from a `go test -json` stream. `TestSetupWizardWithPostgres` can time out under host load: run it alone and rerun before calling it a regression. Drop your own database (or stop and delete your own server) at the end.
- **Disk:** `/tmp` is a 7.9 GB tmpfs shared by every session. Put `TMPDIR`, detached copies, Postgres data and build caches in `~/.cache/86bcm901j-verifier/` on the real disk (`mkdir`, no `-p`; remove it at the end).
- **Screenshots:** headless Chrome for Testing works inside the sandbox with the flags recorded in `ac-verification.md` (line on the WSL desktop) and in `…/86bcm901j/INVENTORY.md`. Take your own; never copy or link another role's image.
- **Scratch:** `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-verifier/` with `mkdir` (no `-p`), for small notes only. The scratchpad is shared by every subagent in this session; never touch other folders in it. Remove your folders at the end (after `git worktree remove` for every copy you added).
- **Never touch** other stories' worktrees (`86bcm901a-agent-definitions`, `86bcm901b-prompts-collection`, `86bcm901w-create-pack`), branches, databases or evidence folders, and never switch the main checkout's branch. Never print a token or password.

## Rules

- **Other bugs outside this change:** list them in `found_else` (one line each, with evidence and severity).
- **Skill lessons:** if you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`
- If you wait on a long command, wait in the foreground (a bounded poll), not by ending your turn.

## What to return

`{verdict: clean|findings, verified_head, base, findings[{id, severity, claim, evidence}], closed[{id, closed, evidence}], rulings_assessment[{ruling, safe, why}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{name, exit, log}], ac_json: "<path>", ac_check_self: "<last line of your self-check>", found_else[], skill_lessons[]}`. `verdict` and `ac_status` are required. Plain words.
