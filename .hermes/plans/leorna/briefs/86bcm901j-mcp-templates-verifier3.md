# VERIFIER (round 3, PR head) brief, read only: leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs"

Written by the main session (orchestrator) on 2026-10-29. Pipeline: **Full**. Earlier record: `ac-check.sh` accepted `66449af` → fixer 4 (main brought in, ruling 13, README B) → fixer 5 (main brought in after #96) → **PR #98 opened** at `17f2ccf` → **verifier round 3 (you)** → blind AC auditor → `ac-check.sh`. Model: Opus 5.5, xhigh.

Justin, 2026-10-29: "After you put out the PR, run verifications to make sure everything's good."

## Your role

You are a **fresh, read-only VERIFIER**. You never saw the build, the reviews, the fixes or the earlier verifier runs.

**Change no source.** Make no edit, commit, push, merge, PR comment or ClickUp write, and leave the worktree exactly as you found it: `git status --porcelain --untracked-files=all` empty and HEAD unchanged.

**Where you write:** only into `~/.hermes/plans/leorna/evidence/86bcm901j/verifier-17f2ccf/`. Create it; it doesn't exist yet. The older folders `verifier/` (round 2 on `66449af`) and `verifier-round1-f368af2/` are read-only history. Cite them, but never copy or link their files as your own receipts.

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna` (VERIFIER role: gates and evidence; skip its Step 1 full context load)
2. `engineering-best-practices`
3. `security-best-practices`: required for every role on this story. Read its npx/launcher env paragraph.
4. `mutation-testing-discipline`

Then read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` in full and follow its **VERIFIER** steps. Also read the report format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

## The candidate

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`, branch `feat/86bcm901j-mcp-templates`.
- **PR:** #98, open, on `LeornaAI/leorna-control-plane`.
- **Head:** `17f2ccf09d79d53a2b8ffa0eac03011271b0a111`, the PR's head on GitHub. Check `gh pr view 98 -R LeornaAI/leorna-control-plane --json headRefOid` and stop if it differs.
- **Base:** `git -C <worktree> merge-base HEAD origin/main`, expected `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f`, which is GitHub main with #95, #94, #97 and #96 merged. Fetch main fresh over HTTPS through gh (`leorna` 7.1) first, and say if it has moved.
- **Approved plan (the contract):** `~/.hermes/plans/leorna/evidence/86bcm901j/plan-approved.md`, including `## Justin's answers (2026-10-28)`.
  - The ACs are **AC1–AC5**, none `(live)`.
  - Each AC's test name and command are in the plan's "Acceptance criteria" section, and its base-commit check (which test files to copy to base) is right below it.
- **Decisions made after the plan:** `…/86bcm901j/handover/rulings-decided.md`, plus the second "Justin's answers" section in `~/.hermes/plans/leorna/86bcm901j-mcp-templates.md`.

## What to verify

1. **Gates.** Re-run the plan's gates (Task 8) yourself on the head, in a detached copy at the same SHA:
   - `make check`, with CI-pinned golangci-lint 2.14.0 and govulncheck v1.7.0 bound by absolute path and Postgres set. Read the Postgres results per test from `go test -json`.
   - `bash ./scripts/test-module-add.sh`
   - gitleaks over the branch range. A merge commit's own diff is skipped by `gitleaks git`, so also `gitleaks dir` the files both sides changed, taken from the head tree.
   - `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`
   - `make library-check`
   - Base vs head by test name: no test lost.
   - Branch hygiene:
     - No `.github/`, `render/`, OpenAPI, migration, Makefile, seed or `THIRD_PARTY_NOTICES.md` change in `git diff --name-only <base>...HEAD`.
     - Every commit is `Justin Issa <justin@leorna.com>` with no attribution line.
     - No `CLAUDE.md`.
   - Also read the hosted CI state with `gh pr checks 98 -R LeornaAI/leorna-control-plane` and report it. Never re-run or change CI.
2. **What changed since the accepted `66449af`.** Check each change yourself:
   - **Two merge commits:** `31be4f8` brought in `a8d1465` (#95, #94, #97), and `17f2ccf` brought in `6c1709e` (#96).
     - Every file changed on only one side must equal that side's version.
     - Each file changed on both sides must keep both sides' meaning: `delivery/stories.json` (main's entries unchanged by value, this story's entry last), `internal/library/content/library.json` (0.8.0), `internal/library/content.lock.json` (every line kept), and `internal/library/README.md` (both stories' text).
     - The branch's own diff against main must be the story's change and nothing else.
   - **Ruling 13** (`5070d4a`): `checkTemplate` refuses a NUL in a decoded env value, header value or argument for every tool, naming the field and never the value. There are new AC3 subtests and a positive control (a line break still passes). **Try to break it yourself** with spellings it didn't list, and confirm the earlier fixes still hold.
   - **README B** (`5a74e96`): rule P's sentence now says the env "sets none of these npm, node, corepack, git and shell launch settings", and the version-manager homes are listed as not covered. Check that the README's claims match what the code does.
   - **Main's new content against this story's policy:** main's agents, prompts, item templates (#94) and pack builder (#96) all pass with the policy on, and nothing was weakened to make them pass.
   - **Earlier receipts** (read only): `…/86bcm901j/fixer4/`, `…/fixer5/`, and the "Fixer 4" and "Fixer 5" sections of `INVENTORY.md`. Earlier findings R1-1..R1-8, R2-1..R2-5 and V-1 are listed in `INVENTORY.md`. Re-run the probe bodies in `verifier-round1-f368af2/probes-f368af2.log` and `verifier/` on the head, and confirm each one still fails the gate without repeating any token.
3. **AC work** (`ac-verification.md` → VERIFIER). For each AC:
   - Run its own test by name on the head.
   - Run it on the base, in a separate detached base copy with head's versions of that AC's test files, one AC at a time, following the recipe exactly.
   - Save `ac<n>-<head7>.log` and `ac<n>-base-<base7>.log` with `HEAD=` and `EXIT=` lines, and take **your own** screenshot per AC.
   - AC5 needs `LEORNA_TEST_CODEX_BIN` and `LEORNA_TEST_CLAUDE_BIN`. It runs only in throwaway homes, **never** Justin's real `~/.codex` or `~/.claude`, not even for `--version`.

   Then write `verifier-17f2ccf/ac.json` in the format at the top of `ac-check.sh`, and self-check it as `ac-verification.md` says:
   - Copy (never link) your `ac.json`, logs and images to a scratch folder outside the evidence tree.
   - Run `ac-check.sh` on your own report plus the copy.
   - Delete the copy.

`verdict: clean` requires every AC accepted on this head, the gates green, the merges correct and no new finding. Otherwise the verdict is `findings`, listing each open item.

## Environment

- **Machine and tools:** the Windows desktop (Ubuntu under WSL). Tools under `~/.local/leorna-tools` are read-only to you (Go, golangci-lint 2.14.0, govulncheck v1.7.0). gcc 15.2 and make are system-wide. gitleaks 8.30.1 is at `/usr/local/bin/gitleaks`. `tail` is uutils: write `tail -n N`.
- **Postgres:** Docker is on and `leorna-test-pg` publishes on 127.0.0.1:55432.
  - Use your own databases `leorna_86bcm901j_verifier3_test` and `…_verifier3_base_test`.
  - Read the container's password first and abort if it's empty.
  - Never touch another session's database, and drop yours at the end.
  - `TestSetupWizardWithPostgres` can time out under load: run it alone and rerun it before calling it a regression.
- **Disk:** `/tmp` is a small tmpfs shared by every session. Put `TMPDIR`, detached copies and caches in `~/.cache/86bcm901j-verifier3/` (`mkdir`, no `-p`) and remove it at the end.
- **Screenshots:** headless Chrome for Testing works inside the sandbox with the flags in `ac-verification.md` (the WSL desktop line) and `INVENTORY.md`. Take your own, and open each one: no token, server address or email.
- **Scratch:** `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-verifier3/` (`mkdir`, no `-p`), for small notes only. Never touch other folders in it. Remove yours at the end, after `git worktree remove` for every copy, and stop any background `tail -f` you started.
- **Never touch** other stories' worktrees, branches, databases, evidence or `~/.cache/86bcm901*-*` folders, and never switch the main checkout's branch. Never print a token or password.

## Rules

- **Other bugs outside this change:** list them in `found_else`, one line each, with evidence and severity. These are already PR follow-ups, so don't report them as open findings:
  - The copied renderers quote keys in their warnings.
  - 901u's `checkFormats` puts TOML error text in the render reason.
  - Unmatched credential names are a documented limit.
  - The version managers' settings are not on the launch list.
  - `gate.CheckTenantItem` doesn't run the policy.
  - #96 doesn't call `Library.Required`.
  - `stories.json` has no PR for 86bcm9019.
  - AC4 has no case for `ſHELLOPTS`.
- **Skill lessons:** don't edit any skill or memory file. List lessons in `skill_lessons[{skill, lesson, evidence}]` and in a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`
- **Long commands:** wait in the foreground with bounded polls under 170 s each; don't end your turn to wait.

## What to return

Return, in plain words:

`{verdict: clean|findings, verified_head, base, ci_state, findings[{id, severity, claim, evidence}], merge_checks[{merge, ok, evidence}], ruling13_probes[], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{name, exit, log}], ac_json: "<path>", ac_check_self: "<last line of your self-check>", found_else[], skill_lessons[]}`

`verdict` and `ac_status` are required.
