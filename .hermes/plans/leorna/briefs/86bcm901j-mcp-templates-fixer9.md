# FIXER 9 brief (wording only): leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs" (PR #98)

Written by the main session (orchestrator) on 2026-10-29. Pipeline: **Full**. Verifier round 5 on `96941f4` reported:
- all 5 ACs accepted (self-check `ALL ACCEPTED`);
- gates green;
- V3-1, V4-1, V4-2 and F7-X closed as a class;
- R1–R6 safe, needed and consistent;
- **two Info, wording-only findings**, V5-1 and V5-2.

Then **fixer 9 (you)** → a scoped verifier round 6 → blind AC auditor → `ac-check.sh` → the main session pushes to PR #98. Model: Opus 5.5, xhigh.

## Your role

Fix the two wording items, and **change no behaviour**. Then re-run the gates and the five AC tests, refresh the hand-over texts, commit, and **stop with `status: ready-for-verify`**. **Never push, comment on the PR, merge or write to ClickUp.** New commits go on top of `96941f4`.

**Scope: text only.**
- `internal/library/README.md`.
- Comments in `internal/library/gate/policy.go` and `policy_test.go`.
- Don't change any Go expression, test expectation, reason string or other file.
- Prove it: `git diff 96941f4 -- '*.go'` must show only comment lines. Check it with `gofmt -d` and a comment-stripped compare (for example `go/parser` + `go/printer` with comments dropped, before and after, byte-equal).
- If a wording fix seems to need a code or reason change, stop and report it instead.

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna` (skip its Step 1 full context load)
2. `engineering-best-practices`
3. `receiving-code-review`
4. `security-best-practices`: required for every role on this story.
5. `git-commit-rules`

## The findings (verify each against the receipts in `~/.hermes/plans/leorna/evidence/86bcm901j/verifier-96941f4/`; read only)

**V5-1 · Info · wording only.** `internal/library/README.md:316-321` (rule V) lists the refused header spellings: a non-token name, CR, LF, NUL or a character above U+00FF. It then says "Codex 0.165 connects without that header".
- **What real Codex does:** it sends a value above U+00FF as UTF-8, with the header present. It drops only the other cases.
- **Fix the sentence**, for example: "…; Codex 0.165 connects without that header, except a value above U+00FF, which it sends as UTF-8."
- **Evidence:** `probe-real-tools-96941f4.txt` finding 7, and fixer 6's v-euro, v-emoji and v-u2028 bytes in `fixer6/probe-header-real-tools.txt`.

**V5-2 · Info · wording only.** Three places say Claude Code reads `ANTHROPIC_API_KEY` "as empty toward any server, set or not":
- `internal/library/README.md:344-345`;
- the comment at `policy.go:515`;
- the comment at `policy_test.go:1231-1232`.

**What real Claude Code 2.1.312 does:** it blanks the variable only toward a **remote** server, set or unset. A stdio server gets the real value. Make all three say "toward any remote server", and say the same about `CLAUDE_CODE_OAUTH_TOKEN` wherever it is named. **Evidence:** `probe-real-tools-96941f4.txt` finding 5.

**Also:** grep the README and comments for any other sentence that claims what a real tool does with headers or `${…}`. Check each against the receipts in `fixer6/`, `fixer7/`, `fixer8/` and `verifier-96941f4/`, and fix any that is untrue in the same text-only way. List every sentence you checked.

## Gates, hand-over, environment

- **Gates on your final head**, as fixer 8 ran them (`briefs/86bcm901j-mcp-templates-fixer8.md` and `fixer8/`):
  - `make check`, with CI-pinned tools bound by absolute path and Postgres set. Read the Postgres results per test.
  - `bash ./scripts/test-module-add.sh`
  - gitleaks over the branch range, plus `gitleaks dir` on the both-sides files.
  - The story-shippable unittest.
  - `make library-check`.
  - Each AC test by name, AC5 with the real tools in throwaway homes.
  - Branch hygiene.
  - Save `gates-<sha7>-*.txt`, `ac<n>-<sha7>.log`, five AC screenshots and a gate-summary screenshot on the final head. Take each page height from Chrome as `ac-verification.md` says, and check the bottom crop shows the log's own `EXIT=`.
  - Mutants aren't needed, since no code changes. Instead, prove with the comment-stripped compare that the Go code is byte-identical.
- **Hand-over refresh** in `…/86bcm901j/handover/`:
  - `pr-text.md` and its copy `~/.hermes/cache/scratch/leorna-pr-86bcm901j-mcp-templates.md`: body only. The Test Plan lists only the final head's runs and keeps the earlier records. Add verifier round 5's result: R1–R6 judged safe, awaiting Justin.
  - `clickup-evidence.md` and `review-prompt.md`: update for the new head.
  - `INVENTORY.md`: add a "Fixer 9" section.
- **Environment:** the same as fixer 8. These parts are different for you:
  - Cache folder: `~/.cache/86bcm901j-fixer9/`.
  - Database: `leorna_86bcm901j_fix9_test`. Check the port with `docker port leorna-test-pg 5432`.
  - Receipts: `…/86bcm901j/fixer9/`.
  - Scratch: `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-fixer9/`.
  - `tail -n N`.
  - Foreground Bash calls move to the background after 180 s: poll in steps under 170 s.
- **Never:**
  - touch other stories' worktrees, branches, databases, evidence or caches;
  - switch the main checkout's branch;
  - run real Codex or Claude Code against Justin's real `~/.codex` or `~/.claude`;
  - print a token.
- **Commits:** use the repo identity (`Justin Issa <justin@leorna.com>`), `docs(86bcm901j): …`, with no author override, no AI line and no `CLAUDE.md`. End with a clean worktree, and remove your cache and scratch folders and drop your database.

## Rules

- **Other bugs:** list them in `found_else`, one line each, with evidence and severity.
- **Skill lessons:** don't edit any skill or memory file. List lessons in `skill_lessons[{skill, lesson, evidence, enforce}]` and in a "Skill lessons" section. `enforce` is `none` or a one-line proposal for a check. An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`

## What to return

Return, in plain words:

`{name: "86bcm901j-mcp-templates", status: ready-for-verify|stopped, verified_head: "96941f4", final_head, commits_on_top[], dispositions[{id, valid, action, commit, evidence}], sentences_checked[], code_unchanged_proof, gates[{name, exit, log}], ac_tests[{ac, test, head_log, screenshot}], pr_body_path, handover_files[], owed[], found_else[], skill_lessons[]}`
