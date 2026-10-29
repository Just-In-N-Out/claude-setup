# VERIFIER (round 4) brief, read only: leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs" (PR #98)

Written by the main session (orchestrator) on 2026-10-29. Pipeline: **Full**:
1. PR #98 opened at `17f2ccf`.
2. Verifier round 3: all 5 ACs accepted, gates and hosted CI green, one Low finding V3-1.
3. Justin: "fix it, then push".
4. Fixer 6 (`48858d7` + `d723e04`).
5. **Verifier round 4 (you).**
6. Blind AC auditor.
7. `ac-check.sh`.
8. The main session pushes to PR #98.

Model: Opus 5.5, xhigh.

## Your role

You are a **fresh, read-only VERIFIER**. You never saw the build, the reviews, the fixes or the earlier verifier runs.

**Change no source.** Make no edit, commit, push, merge, PR comment or ClickUp write, and leave the worktree exactly as you found it: `git status --porcelain --untracked-files=all` empty and HEAD unchanged.

**Where you write:** only into `~/.hermes/plans/leorna/evidence/86bcm901j/verifier-d723e04/`. Create it; it doesn't exist yet. Every older folder is read-only history: `verifier/`, `verifier-round1-f368af2/`, `verifier-17f2ccf/`, `fixer1/` to `fixer6/`, `review1/`, `review2/` and `auditor/`. Cite them, but never copy or link their files as your own receipts.

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna` (VERIFIER role: gates and evidence; skip its Step 1 full context load)
2. `engineering-best-practices`
3. `security-best-practices`: required for every role on this story. Read its npx/launcher env paragraph; it records what real Claude Code and Codex do with odd header names and values.
4. `mutation-testing-discipline`

Then read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` in full and follow its **VERIFIER** steps. Also read the report format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

## The candidate

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`, branch `feat/86bcm901j-mcp-templates`.
- **Head:** `d723e0401946ad44e787951f59bf9fb09782d177`, local and **not pushed yet**. PR #98 on GitHub is still at `17f2ccf`; that's expected.
- **Base:** `git -C <worktree> merge-base HEAD origin/main`, expected `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f`. Fetch main fresh over HTTPS through gh (`leorna` 7.1) first, and say if it has moved.
- **Approved plan (the contract):** `~/.hermes/plans/leorna/evidence/86bcm901j/plan-approved.md`.
  - The ACs are **AC1–AC5**, none `(live)`.
  - Each AC's test name and command are in its "Acceptance criteria" section, and its base-commit check is right below it.
- **Decisions after the plan:** every "Justin's answers" section in `~/.hermes/plans/leorna/86bcm901j-mcp-templates.md`, including `## Justin's answers (2026-10-29, PR #98)` with the V3-1 decision, plus `…/86bcm901j/handover/rulings-decided.md`.

## What to verify

1. **Gates.** Re-run the plan's gates (Task 8) yourself on the head, in a detached copy at the same SHA:
   - `make check`, with CI-pinned golangci-lint 2.14.0 and govulncheck v1.7.0 bound by absolute path and Postgres set. Read the Postgres results per test from `go test -json`.
   - `bash ./scripts/test-module-add.sh`
   - gitleaks over the branch range, plus `gitleaks dir` on the files both sides of the two merges changed, taken from the head tree.
   - `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`
   - `make library-check`
   - Base vs head by test name: no test lost.
   - Branch hygiene:
     - No `.github/`, `render/`, OpenAPI, migration, Makefile, seed or `THIRD_PARTY_NOTICES.md` change in `git diff --name-only <base>...HEAD`.
     - Every commit is `Justin Issa <justin@leorna.com>` with no attribution line.
     - No `CLAUDE.md`.
     - A fast-forward from the pushed `17f2ccf`.
   - Also read `gh pr checks 98 -R LeornaAI/leorna-control-plane` (hosted CI on `17f2ccf`). Never re-run or change CI.
2. **What changed since `17f2ccf`:** two commits.
   - **`48858d7`, V3-1:** the fix was decided as follows. A header name must be an RFC 9110 token. A header value may not hold CR, LF, obs-fold or a character above U+00FF; the existing NUL check is kept. Each fails at template level for every tool, naming the header (by sorted position when the name isn't plain) and never the value.
   - **The fixer went further with five rulings, not yet confirmed.** Judge whether each is safe, needed and consistent with Justin's decision:
     - R1: header names that differ only in case fail for every tool.
     - R2: a `Host` header fails for every tool.
     - R3: a `Content-Length` header fails for every tool.
     - R4: `${NAME:-default}` fails for every tool in every field Claude Code expands.
     - R5: a header value with a control character other than tab fails **for Codex only**. Justin's decision listed U+0001 and U+007F as accepted, based on Claude Code alone; Codex drops that header.
   - **`d723e04`:** PR #98 recorded in `delivery/stories.json`. Only this story's entry changed, and the 40 others are equal by value.
   - **Fixer 6's evidence:** `…/86bcm901j/fixer6/`. `probe-header-real-tools.txt` has 96 spellings with real Claude Code 2.1.312 and Codex 0.165 bytes, the probe scripts are saved as `.txt`, plus `v31-mutations-d723e04.txt`, `r13-mutations-d723e04.txt` and the "Fixer 6" section in `INVENTORY.md`.
   - **Try to break the header class yourself** with spellings it didn't list, in every tool. Use real-tool probes in throwaway homes where they decide a question. Confirm the positive controls stay verified: a plain value, `Bearer ${VAR}`, tab, a Latin-1 letter, U+00FF, an empty value, and spaces around a value.
   - **Re-run every earlier round's probe bodies** on the head, and confirm each still fails the gate without repeating any token:
     - review 1, review 2, verifier round 1, verifier round 2 (`verifier/`) and verifier round 3 (`verifier-17f2ccf/`).
     - Take the file list from each earlier log's `<file>_test.go:NN:` prefixes, not from a `*probe*` name search, and diff the outcome lines against that log.
     - Any outcome that changed must be explained by `48858d7`.
3. **AC work** (`ac-verification.md` → VERIFIER). For each AC:
   - Run its own test by name on the head.
   - Run it on the base, in a separate detached base copy with head's versions of that AC's test files, one AC at a time, following the recipe exactly.
   - Save `ac<n>-<head7>.log` and `ac<n>-base-<base7>.log` with `HEAD=` and `EXIT=` lines, and take **your own** screenshot per AC.
   - Check each PNG's last text row has blank rows below it (a cut-off log hides the `EXIT=` line).
   - AC5 needs `LEORNA_TEST_CODEX_BIN` and `LEORNA_TEST_CLAUDE_BIN`. It runs only in throwaway homes, **never** Justin's real `~/.codex` or `~/.claude`, not even for `--version`.

   Then write `verifier-d723e04/ac.json` in the format at the top of `ac-check.sh`, and self-check it as `ac-verification.md` says:
   - Copy (never link) your `ac.json`, logs and images to a scratch folder outside the evidence tree.
   - Run `ac-check.sh` on your report plus the copy.
   - Delete the copy.

`verdict: clean` requires every AC accepted on this head, the gates green, V3-1 closed as a class, no unsafe ruling and no new finding. Otherwise the verdict is `findings`, listing each open item. An unsafe or unneeded ruling is a finding.

## Environment

- **Machine and tools:** the Windows desktop (Ubuntu under WSL). Tools under `~/.local/leorna-tools` are read-only to you (Go, golangci-lint 2.14.0, govulncheck v1.7.0). gcc 15.2 and make are system-wide. gitleaks 8.30.1 is at `/usr/local/bin/gitleaks`.
- **Shell:** `tail` is uutils, so write `tail -n N`. In a subagent, a foreground Bash call moves to the background after 180 s, so split long waits into polls under 170 s each.
- **Postgres:** Docker was just restarted and `leorna-test-pg` is up.
  - Use your own databases `leorna_86bcm901j_verifier4_test` and `…_verifier4_base_test`.
  - Read the container's password first and abort if it's empty.
  - Check the published port with `docker port leorna-test-pg 5432` rather than assuming it.
  - Never touch another session's database, and drop yours at the end.
  - `TestSetupWizardWithPostgres` can time out under load: run it alone and rerun it before calling it a regression.
- **Disk:** `/tmp` is a small tmpfs shared by every session. Put `TMPDIR`, detached copies and caches in `~/.cache/86bcm901j-verifier4/` (`mkdir`, no `-p`) and remove it at the end.
- **Screenshots:** headless Chrome for Testing works with the flags in `ac-verification.md` (the WSL desktop line). Take your own, and open each one: no token, server address or email.
- **Scratch:** `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-verifier4/` (`mkdir`, no `-p`), for small notes only. Never touch other folders in it. Remove yours at the end, after `git worktree remove` for every copy, and stop any background `tail -f` you started.
- **Never touch** other stories' worktrees, branches, databases, evidence or `~/.cache/86bcm90*-*` folders, and never switch the main checkout's branch. Never print a token or password.

## Rules

- **Other bugs outside this change:** list them in `found_else`, one line each, with evidence and severity. These are already PR follow-ups (1 to 13 in `handover/pr-text.md`), so don't report them as open findings:
  - the copied renderers;
  - 901u's `checkFormats`;
  - unmatched credential names;
  - version-manager settings;
  - `CheckTenantItem`;
  - `Library.Required`;
  - the 86bcm9019 record;
  - `ſHELLOPTS`;
  - transport-owned headers (Accept, Content-Type, Mcp-Session-Id…);
  - Latin-1 bytes differing between the tools;
  - the Codex renderer's map order for case-variant `Authorization`.
- **Skill lessons:** don't edit any skill or memory file. List lessons in `skill_lessons[{skill, lesson, evidence, enforce}]` and in a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check (its kind, what it checks, where it runs). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`

## What to return

Return, in plain words:

`{verdict: clean|findings, verified_head, base, ci_state, findings[{id, severity, claim, evidence}], v31_closed{closed, evidence}, rulings_assessment[{ruling, safe, needed, consistent_with_justin, why}], header_probes[], earlier_probes{files, lines, diffs, explained}, ac_status[{ac, accepted, test, screenshot, evidence}], gates[{name, exit, log}], ac_json: "<path>", ac_check_self: "<last line of your self-check>", found_else[], skill_lessons[]}`

`verdict` and `ac_status` are required.
