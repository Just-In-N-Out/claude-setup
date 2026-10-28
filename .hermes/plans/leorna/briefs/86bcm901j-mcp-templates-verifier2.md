# VERIFIER (round 2) brief, read only: leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs"

Written by the main session (orchestrator) on 2026-10-28. Pipeline: **Full**: review 1 → fixer 1 → review 2 → fixer 2 → verifier round 1 (findings: V-1) → fixer 3 → **verifier round 2 (you)** → blind AC auditor → `ac-check.sh` → finisher hand-over. Model: Opus 5.5, xhigh.

## Your role

You are a **fresh, read-only VERIFIER**. You never saw the build, the reviews, the fixes or the first verifier's run. **Change no source:** no edit, commit, push, merge, PR or ClickUp write, and leave the worktree exactly as you found it (`git status --porcelain --untracked-files=all` empty, HEAD unchanged). Write only into `~/.hermes/plans/leorna/evidence/86bcm901j/verifier/` (create it; it doesn't exist yet). The first verifier's folder, `verifier-round1-f368af2/`, is read-only history for you: cite it, never copy or link its files as your own receipts.

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna` (VERIFIER role: gates, evidence; skip its Step 1 full context load)
2. `engineering-best-practices`
3. `security-best-practices`: required for every role on this story (read its npx/launcher env paragraph).
4. `mutation-testing-discipline`

Then read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` in full and follow its **VERIFIER** steps, and read the report format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

## The candidate

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`, branch `feat/86bcm901j-mcp-templates`.
- **Head:** `66449af4572d4bf9a4f431973b27cdb124d2a784`. **Base:** `git -C <worktree> merge-base HEAD origin/main` (expected `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`). 19 commits.
- **Approved plan (the contract):** `~/.hermes/plans/leorna/evidence/86bcm901j/plan-approved.md`, including `## Justin's answers (2026-10-28)`. ACs **AC1–AC5**, none `(live)`; AC4 and AC5 were proposed and approved. Each AC's test name and command are in the plan's "Acceptance criteria" section, and its base-commit check (which test files to copy to base) right below it.

## What to verify

1. **Gates:** re-run the plan's gates (Task 8) yourself on the head, in a detached copy at the same SHA: `make check` with CI-pinned golangci-lint 2.14.0 and govulncheck v1.7.0 bound by absolute path and Postgres set, `bash ./scripts/test-module-add.sh`, gitleaks on the branch range, the story-shippable check (`python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`), `make library-check`, base vs head by test name, and branch hygiene (no `.github/`, `render/`, OpenAPI, migration, Makefile, seed or `THIRD_PARTY_NOTICES.md` change; every commit `Justin Issa <justin@leorna.com>` with no attribution line; no `CLAUDE.md`).
2. **Every finding is closed, with no regression from the fixes.** Review 1 (on `7c2c35a`): R1-1 policy skipped itself when its decode failed; R1-2 Codex floor bypass by case-variant keys + denylist; R1-3 reasons repeated a value; R1-4 npx `=` options; R1-5 rule S blind spots; R1-6 two untested guards; R1-7 `history.persistence` doc overclaim; R1-8 `runTool` WaitDelay. Review 2 (on `f36285d`): R2-1 server env (PATH, LD_*, NODE_*…) could change what runs; R2-2 reasons quoted a token pasted into a key; R2-3 untested credential words; R2-4 camelCase names and other forms; R2-5 wrong reason for `defaultMode: "manual"`. Verifier round 1 (on `f368af2`): **V-1** env keys carrying `=` (`"PATH=/dir:"`, `"PREFIX=/x"`, `"SHELLOPTS=xtrace:"`…) passed rule P for claude-code and cursor, and real Claude Code ran a fake `npx` from that PATH; it was the second witness of R2-1's class. **Fixer 3** (`66449af`) claims to close the class: every env key in every server must match `^[A-Za-z_][A-Za-z0-9_]*$`, checked after the launch-setting list, with 20 new AC4 subtests (the six witnesses, 12 more spellings: empty, leading/trailing space, NUL, line break, DEL, full-width, Cyrillic look-alike, `${…}`, leading digit, `-`, `.`, a remote server) and a positive control. **Try to break it yourself** with spellings it didn't list, in every tool, and confirm every earlier fix still holds. Evidence: `…/86bcm901j/review1/`, `…/review2/`, `…/verifier-round1-f368af2/` (probes in `probes-f368af2.log`, V-1 in `v1-env-key-with-equals-real-claude.txt`), fixer receipts `…/fixer1/`, `…/fixer2/`, `…/fixer3/`, dispositions in `…/INVENTORY.md`. Re-run the reviewers' and round 1's probe bodies on the head and confirm each fails the gate without repeating any token in the JSON report, log or summary.
3. **Rulings** (not yet confirmed by Justin; say whether each is safe): fixer 1: no `env` in Claude Code settings; exact-key allowlists for both floors (Codex `model` refused); extra credential words in the policy only; AC2 subtest name kept. Fixer 2: refused launch-settings list rather than an env allowlist (`LOG_LEVEL=debug` allowed); positions in sorted key order; `"manual"` refused with the true reason. Fixer 3: the name rule covers every server, not only stdio; keys with `-` or `.` now fail; no new rule for env values (tools refuse a NUL themselves).
4. **AC work (`ac-verification.md` → VERIFIER):** for each AC, run its own test by name on the head and on the base (in a separate detached base copy, with head's versions of that AC's test files, one AC at a time, following the recipe exactly), save `ac<n>-<head7>.log` and `ac<n>-base-<base7>.log` with `HEAD=` and `EXIT=` lines, and take **your own** screenshot per AC. AC5 needs `LEORNA_TEST_CODEX_BIN` and `LEORNA_TEST_CLAUDE_BIN` and runs only in throwaway homes, **never** Justin's real `~/.codex` or `~/.claude`, even for `--version`. Write `verifier/ac.json` in the format at the top of `ac-check.sh`, then self-check it as `ac-verification.md` says (copy, never link, your `ac.json`, logs and images to a scratch folder outside the evidence tree, run `ac-check.sh` on your own report plus the copy, then delete the copy).

`verdict: clean` requires every AC accepted on this head, every finding closed and the gates green. Otherwise `findings`, with each open item.

## Environment

- Windows desktop (Ubuntu under WSL). Tools under `~/.local/leorna-tools` read-only (Go, golangci-lint 2.14.0, govulncheck v1.7.0); gcc 15.2 and make are system-wide. Never modify or delete `~/.local/leorna-tools` or other sessions' `~/.local/leorna-toolchain`.
- **Postgres:** Docker is on and `leorna-test-pg` is running. Use your own databases `leorna_86bcm901j_verifier2_test` (and `…_verifier2_base_test` if needed); read the container's password first and abort if it's empty; never touch another session's database. Read results per test from a `go test -json` stream. `TestSetupWizardWithPostgres` can time out under load: run it alone and rerun before calling it a regression. Drop your databases at the end.
- **Disk:** `/tmp` is a small tmpfs shared by every session. Put `TMPDIR`, detached copies and caches in `~/.cache/86bcm901j-verifier2/` on the real disk (`mkdir`, no `-p`; remove it at the end).
- **Screenshots:** headless Chrome for Testing works inside the sandbox with the flags in `ac-verification.md` (the WSL desktop line) and `INVENTORY.md`. Take your own.
- **Scratch:** `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-verifier2/` with `mkdir` (no `-p`), small notes only. The scratchpad is shared by every subagent in this session; never touch other folders in it. Remove your folders at the end (after `git worktree remove` for every copy). If you run a Monitor or background `tail -f`, stop the tail itself afterwards.
- **Never touch** other stories' worktrees (`86bcm901a-agent-definitions`, `86bcm901b-prompts-collection`, `86bcm901w-create-pack`), branches, databases, evidence or `~/.cache/86bcm901[abw]-*` folders, and never switch the main checkout's branch. Never print a token or password.

## Rules

- **Other bugs outside this change:** list them in `found_else` (one line each, with evidence and severity). Already recorded as follow-ups (don't re-report as open findings): the copied renderers quote keys in their warnings (`render/`, out of scope); 901u `gate.go` `checkFormats` puts TOML error text in the render reason; unmatched credential names (`DB_CREDS`, `PASSKEY`) are a documented limit; a NUL in an env value passes the gate but real Claude Code refuses to start that server.
- **Skill lessons:** don't edit any skill or memory file: list them in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`
- If you wait on a long command, wait in the foreground (a bounded poll), not by ending your turn.

## What to return

`{verdict: clean|findings, verified_head, base, findings[{id, severity, claim, evidence}], closed[{id, closed, evidence}], rulings_assessment[{ruling, safe, why}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{name, exit, log}], ac_json: "<path>", ac_check_self: "<last line of your self-check>", found_else[], skill_lessons[]}`. `verdict` and `ac_status` are required. Plain words.
