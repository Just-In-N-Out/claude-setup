# VERIFIER (round 6, scoped) brief, read only: leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs" (PR #98)

Written by the main session (orchestrator) on 2026-10-29. Pipeline: **Full**:
- Verifier round 5 on `96941f4`: all 5 ACs accepted, gates green, every finding class closed, R1–R6 safe, plus two Info wording findings, V5-1 and V5-2.
- Fixer 9 made text-only commits `d594bf2` and `f2892bc`.
- **Verifier round 6 (you)**, scoped to that change, with the blind AC auditor running at the same time on its own.
- Then `ac-check.sh`, and the main session pushes to PR #98.

Model: Opus 5.5, xhigh.

## Your role

You are a **fresh, read-only VERIFIER**.

**Change no source.** Make no edit, commit, push, merge, PR comment or ClickUp write, and leave the worktree exactly as you found it: `git status --porcelain --untracked-files=all` empty and HEAD unchanged.

**Where you write:** only into `~/.hermes/plans/leorna/evidence/86bcm901j/verifier-f2892bc/`. Create it. Every other folder under `…/86bcm901j/` is read-only history; cite it, never copy or link it. A blind AC auditor is working in `auditor-f2892bc/` at the same time: don't read or touch that folder.

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna` (VERIFIER role; skip its Step 1 full context load)
2. `engineering-best-practices`
3. `security-best-practices`: required for every role on this story.
4. `receiving-code-review`: its stale-comment line says how to prove a wording-only change left the code unchanged.

Then read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` in full and follow its **VERIFIER** steps. Also read the report format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

## The candidate

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`.
- **Head:** `f2892bc2dddb829b46d6c4be3557c3ecdfa89538`, local and not pushed. PR #98 is at `17f2ccf` on GitHub.
- **Base:** `git merge-base HEAD origin/main`, expected `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f`. Fetch main fresh over HTTPS through gh first, and say if it has moved.
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901j/plan-approved.md` (AC1–AC5, none `(live)`).
- **Round 5's full report:** `…/86bcm901j/verifier-96941f4/`, read only. **The change since then:** `git diff 96941f4 f2892bc`. Fixer 9's receipts are in `…/86bcm901j/fixer9/` (`sentences-checked.txt`, `code-unchanged-proof.txt`).

## What to verify (scoped)

1. **The change is text only.** Prove it yourself; don't reuse fixer 9's tool.
   - Comment-stripped `go/parser` + `go/printer` output of `policy.go` and `policy_test.go` at `96941f4` and at `f2892bc` must be byte-equal. Fail closed on empty output or a non-zero exit, and run a control edit that must show as different. `go` is at `~/.local/leorna-tools/go/bin`.
   - `git diff 96941f4 f2892bc` touches only `internal/library/README.md`, Go comment lines and nothing else.
2. **The new sentences are true.** Check V5-1 and V5-2 against the raw receipts:
   - V5-1: Codex 0.165 sends a header value above U+00FF as UTF-8 and drops the other refused cases.
   - V5-2: Claude Code blanks `ANTHROPIC_API_KEY` toward a remote server only.
   - Raw receipts: `verifier-96941f4/probe-real-tools-96941f4.txt` (findings 5 and 7), `fixer6/probe-header-real-tools.txt` and `fixer8/probe-real-tools-fixer8.txt`.
   - Spot-check at least 10 of the 47 sentences in `fixer9/sentences-checked.txt` the same way, and say whether you agree with each.
3. **Gates on the head**, in a detached copy:
   - `make check`, with CI-pinned golangci-lint 2.14.0 and govulncheck v1.7.0 by absolute path and Postgres set. Read the Postgres results per test from `go test -json`.
   - `bash ./scripts/test-module-add.sh`
   - gitleaks over the branch range.
   - `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`
   - `make library-check`
   - Branch hygiene: no forbidden paths, all commits Justin Issa with no attribution line, no `CLAUDE.md`, a fast-forward from `17f2ccf`.
   - Read `gh pr checks 98 -R LeornaAI/leorna-control-plane`. Never re-run CI.
4. **AC work** (`ac-verification.md` → VERIFIER). For each AC:
   - Run its test by name on the head, and on the base in a separate detached base copy with head's versions of that AC's test files, one AC at a time.
   - Save `ac<n>-<head7>.log` and `ac<n>-base-<base7>.log` with `HEAD=` and `EXIT=` lines, and take your own screenshot per AC.
   - Take the page height from Chrome as `ac-verification.md` says, and check that the bottom crop shows the log's own `EXIT=` line.
   - AC5 needs `LEORNA_TEST_CODEX_BIN` and `LEORNA_TEST_CLAUDE_BIN`, in throwaway homes only.

   Then write `verifier-f2892bc/ac.json` in the `ac-check.sh` format, and self-check it as `ac-verification.md` says: copy it, run `ac-check.sh` on your report plus the copy, then delete the copy.

**Not in scope:** no new class hunting. Round 5 did that on identical code. If you notice something anyway, report it with its severity, and mark it `wording_only` where it is.

`verdict: clean` requires every AC accepted on this head, the gates green, the change proven text-only and V5-1 and V5-2 true.

## Environment

- **Shell:** `tail -n N`. A foreground Bash call moves to the background after 180 s: poll in steps under 170 s.
- **Postgres:** use your own databases `leorna_86bcm901j_verifier6_test` and `…_verifier6_base_test`. Read the `leorna-test-pg` password first and abort if it's empty, check the port with `docker port leorna-test-pg 5432`, and drop your databases at the end. The auditor uses its own databases at the same time, so expect some load; rerun `TestSetupWizardWithPostgres` alone before calling a timeout a regression.
- **Cache:** `~/.cache/86bcm901j-verifier6/` (`mkdir`, no `-p`). **Scratch:** `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-verifier6/`. Remove both at the end.
- **Never:**
  - touch other stories' worktrees, branches, databases, evidence or caches;
  - touch the auditor's folders (`auditor-f2892bc/`, `~/.cache/86bcm901j-auditor2/`, its databases);
  - switch the main checkout's branch;
  - run real Codex or Claude Code against Justin's real `~/.codex` or `~/.claude`;
  - print a token.

## Rules

- **Other bugs:** list them in `found_else`, one line each, with evidence and severity. Don't re-report the PR follow-ups (1 to 14 in `handover/pr-text.md`).
- **Skill lessons:** list them in `skill_lessons[{skill, lesson, evidence, enforce}]` and in a "Skill lessons" section. `enforce` is `none` or a one-line proposal for a check. An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`

## What to return

Return, in plain words:

`{verdict: clean|findings, verified_head, base, ci_state, findings[{id, severity, wording_only, claim, evidence}], text_only_proof, v5_checks[], sentences_spot_checked[], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{name, exit, log}], ac_json: "<path>", ac_check_self: "<last line>", found_else[], skill_lessons[]}`

`verdict` and `ac_status` are required.
