# VERIFIER (round 5) brief, read only: leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs" (PR #98)

Written by the main session (orchestrator) on 2026-10-29. Pipeline: **Full**:
1. PR #98 opened at `17f2ccf`.
2. Verifier round 3 found V3-1.
3. Fixer 6 (`48858d7`, `d723e04`).
4. Verifier round 4 found V4-1 and V4-2, both wording.
5. Fixer 7 (`2ead9c8`, `de9dbde`), which found F7-X.
6. Fixer 8 (`095cff0`, `96941f4`).
7. **Verifier round 5 (you).**
8. Blind AC auditor.
9. `ac-check.sh`.
10. The main session pushes to PR #98.

Model: Opus 5.5, xhigh.

## Your role

You are a **fresh, read-only VERIFIER**. You never saw the build, the reviews, the fixes or the earlier verifier runs.

**Change no source.** Make no edit, commit, push, merge, PR comment or ClickUp write, and leave the worktree exactly as you found it: `git status --porcelain --untracked-files=all` empty and HEAD unchanged.

**Where you write:** only into `~/.hermes/plans/leorna/evidence/86bcm901j/verifier-96941f4/`. Create it. Every other folder under `…/86bcm901j/` is read-only history: cite it, but never copy or link its files as your own receipts.

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna` (VERIFIER role: gates and evidence; skip its Step 1 full context load)
2. `engineering-best-practices`
3. `security-best-practices`: required for every role on this story. Read its npx/launcher env paragraph; it records the real header and `${…}` behaviour of Claude Code 2.1.312 and Codex 0.165.
4. `mutation-testing-discipline`

Then read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` in full and follow its **VERIFIER** steps. Also read the report format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

## The candidate

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`, branch `feat/86bcm901j-mcp-templates`.
- **Head:** `96941f47013f62546d0806824c4885641326fce0`, local and **not pushed yet**. PR #98 on GitHub is still at `17f2ccf`; that's expected.
- **Base:** `git -C <worktree> merge-base HEAD origin/main`, expected `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f`. Fetch main fresh over HTTPS through gh (`leorna` 7.1) first, and say if it has moved.
- **Approved plan (the contract):** `~/.hermes/plans/leorna/evidence/86bcm901j/plan-approved.md`.
  - The ACs are **AC1–AC5**, none `(live)`.
  - Each AC's test name and command are in its "Acceptance criteria" section, and its base-commit check is right below it.
- **Decisions after the plan:** every "Justin's answers" section in `~/.hermes/plans/leorna/86bcm901j-mcp-templates.md`, including the V3-1 decision ("fix it", 2026-10-29), plus `…/86bcm901j/handover/rulings-decided.md`.

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
2. **What changed since `17f2ccf`:** six commits.
   - **`48858d7` (V3-1):** header names must be RFC 9110 tokens. Header values may not hold CR, LF, obs-fold, NUL or a character above U+00FF. Each fails for every tool, naming the header and never the value. It also carries rulings R1–R5:
     - R1: case-variant names fail.
     - R2: `Host` fails.
     - R3: `Content-Length` fails.
     - R4: a valid `${NAME:-default}` fails.
     - R5: a control character other than tab fails for Codex only.
     - Verifier round 4 judged all five safe, needed and consistent.
   - **`d723e04`:** PR #98 recorded in `delivery/stories.json`.
   - **`2ead9c8` (V4-1):** a line break only at either end of a header value gets its own true reason ("Claude Code trims it and sends the rest, and Codex drops the header"). An inside one still says "refuses to connect".
   - **`de9dbde` (V4-2):** `defaultRef` is now Claude Code's own pattern, `\$\{[A-Za-z_][A-Za-z0-9_]*:-[^}]*\}`, so an unclosed `${NAME:-x` is plain text that rule S still checks.
   - **`095cff0` + `96941f4` (F7-X):**
     - Claude Code expands header values twice, so `$${EMPTY}{SET}` reads SET, which the policy never counted.
     - Command, args, env values and url get one pass.
     - A header value now fails for every tool when `$` or an unfinished `${` comes directly before a reference, or `{` directly after one. References are found with Claude Code's own pattern.
     - **Ruling R6, not yet confirmed:** header values only, and every tool.
     - Fixer 8 found that Claude Code reads `ANTHROPIC_API_KEY` and `CLAUDE_CODE_OAUTH_TOKEN` as empty toward a remote server even when unset.
   - **Judge R6** (safe, needed, consistent with Justin's decisions). Re-check that R1–R5 still hold.
   - **Fixers' evidence:** `…/86bcm901j/fixer6/`, `fixer7/` and `fixer8/` (real-tool probes with raw bytes, mutation receipts), plus the "Fixer 6", "Fixer 7" and "Fixer 8" sections of `INVENTORY.md`.
   - **Try to break the whole header and `${…}` class yourself**, with spellings the fixers didn't list, in every tool and every field Claude Code expands. Use real-tool probes in throwaway homes where they decide a question. Confirm the positive controls stay verified: a plain value, `Bearer ${VAR}`, tab, a Latin-1 letter, U+00FF, an empty value, spaces around a value, `$` and `{` elsewhere, `$$`, two plain references side by side, and the same join text in args, env or url.
   - **Check the README claims.** Every claim in rules S, P and V must match the code and the real tools.
   - **Re-run every earlier round's probe bodies** on the head, and confirm each still fails the gate without repeating any token:
     - review 1, review 2, and verifier rounds 1, 2, 3 (`verifier-17f2ccf/`) and 4 (`verifier-d723e04/`).
     - Take the file list from each earlier log's `<file>_test.go:NN:` prefixes, not from a `*probe*` name search, and diff the outcome lines against that log.
     - Any outcome that changed must be explained by a commit listed above.
3. **AC work** (`ac-verification.md` → VERIFIER). For each AC:
   - Run its own test by name on the head.
   - Run it on the base, in a separate detached base copy with head's versions of that AC's test files, one AC at a time, following the recipe exactly.
   - Save `ac<n>-<head7>.log` and `ac<n>-base-<base7>.log` with `HEAD=` and `EXIT=` lines, and take **your own** screenshot per AC.
   - Take the page height from Chrome as `ac-verification.md` says, and check that each PNG's bottom crop shows the log's own `EXIT=` line.
   - AC5 needs `LEORNA_TEST_CODEX_BIN` and `LEORNA_TEST_CLAUDE_BIN`. It runs only in throwaway homes, **never** Justin's real `~/.codex` or `~/.claude`, not even for `--version`.

   Then write `verifier-96941f4/ac.json` in the format at the top of `ac-check.sh`, and self-check it as `ac-verification.md` says:
   - Copy (never link) your `ac.json`, logs and images to a scratch folder outside the evidence tree.
   - Run `ac-check.sh` on your report plus the copy.
   - Delete the copy.

`verdict: clean` requires every AC accepted on this head, the gates green, V3-1, V4-1, V4-2 and F7-X closed as a class, no unsafe or unneeded ruling and no new finding. Otherwise the verdict is `findings`, listing each open item.

**Severity matters:** label wording-only items (right result, imprecise text) as **Info** and say so plainly, so the main session can tell them apart from wrong results.

## Environment

- **Machine and tools:** the Windows desktop (Ubuntu under WSL). Tools under `~/.local/leorna-tools` are read-only to you (Go, golangci-lint 2.14.0, govulncheck v1.7.0). gcc 15.2 and make are system-wide. gitleaks 8.30.1 is at `/usr/local/bin/gitleaks`.
- **Shell:** `tail` is uutils, so write `tail -n N`. A foreground Bash call moves to the background after 180 s, so poll in steps under 170 s.
- **Postgres:** `leorna-test-pg` is up.
  - Use your own databases `leorna_86bcm901j_verifier5_test` and `…_verifier5_base_test`.
  - Read the container's password first and abort if it's empty.
  - Check the port with `docker port leorna-test-pg 5432`.
  - Never touch another session's database, and drop yours at the end.
  - `TestSetupWizardWithPostgres` can time out under load: run it alone and rerun it before calling it a regression.
- **Disk:** `/tmp` is a small tmpfs shared by every session. Put `TMPDIR`, detached copies and caches in `~/.cache/86bcm901j-verifier5/` (`mkdir`, no `-p`) and remove it at the end.
- **Screenshots:** headless Chrome for Testing works with the flags in `ac-verification.md` (the WSL desktop line). Take your own, and open each one: no token, server address or email.
- **Scratch:** `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-verifier5/` (`mkdir`, no `-p`), for small notes only. Never touch other folders in it. Remove yours at the end, after `git worktree remove` for every copy, and stop any listener, Chrome or `tail -f` you started.
- **Never touch** other stories' worktrees, branches, databases, evidence or `~/.cache/86bcm90*-*` folders, and never switch the main checkout's branch. Never print a token or password.

## Rules

- **Other bugs outside this change:** list them in `found_else`, one line each, with evidence and severity. Don't report the existing PR follow-ups (1 to 14 in `handover/pr-text.md`) as open findings. They include:
  - the copied renderers;
  - 901u's `checkFormats`;
  - unmatched credential names;
  - version-manager settings;
  - `CheckTenantItem`;
  - `Library.Required`;
  - the 86bcm9019 record;
  - `ſHELLOPTS`;
  - transport-owned headers;
  - Latin-1 bytes differing between the tools;
  - the Codex renderer's map order;
  - a variable whose own value holds `${OTHER}` (the engineer's environment).
- **Skill lessons:** don't edit any skill or memory file. List lessons in `skill_lessons[{skill, lesson, evidence, enforce}]` and in a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check (its kind, what it checks, where it runs). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`

## What to return

Return, in plain words:

`{verdict: clean|findings, verified_head, base, ci_state, findings[{id, severity, wording_only, claim, evidence}], closed[{id, closed, evidence}], rulings_assessment[{ruling, safe, needed, consistent_with_justin, why}], probes[], earlier_probes{files, lines, diffs, explained}, ac_status[{ac, accepted, test, screenshot, evidence}], gates[{name, exit, log}], ac_json: "<path>", ac_check_self: "<last line of your self-check>", found_else[], skill_lessons[]}`

`verdict` and `ac_status` are required.
