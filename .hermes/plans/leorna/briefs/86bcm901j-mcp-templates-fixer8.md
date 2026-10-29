# FIXER 8 brief: leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs" (PR #98)

Written by the main session (orchestrator) on 2026-10-29. Pipeline: **Full**. PR #98 is at `17f2ccf` on GitHub; the local head is `de9dbde` (fixer 7, V4-1 and V4-2 fixed, ready for verify). Then **fixer 8 (you)** → fresh verifier → blind AC auditor → `ac-check.sh` → the main session pushes to PR #98 (Justin OK'd pushing the fix). Model: Opus 5.5, xhigh.

## Your role

You are a fresh **FIXER** for one gap fixer 7 found. Verify it yourself, fix it **test-first as a class**, re-run the gates and the five AC tests, refresh the hand-over texts, commit, and **stop with `status: ready-for-verify`**. **Never push, comment on the PR, merge or write to ClickUp.** New commits go on top of `de9dbde`; no rebase.

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna` (skip its Step 1 full context load)
2. `engineering-best-practices`
3. `receiving-code-review`
4. `test-driven-development`
5. `security-best-practices`: required for every role on this story. Its npx/launcher paragraph now records Claude Code's expansion pattern and its second pass.
6. `mutation-testing-discipline`
7. `git-commit-rules`
8. `systematic-debugging` whenever something fails unexpectedly.

## The gap (fixer 7's words condensed; verify it)

**F7-X · Low · rule V/S class (the template reads a variable the policy never sees).**
- Real Claude Code 2.1.312 expands `${NAME}` / `${NAME:-default}` **twice**.
- So the template value `$${EMPTY}{SET}`, with EMPTY set but empty, sends SET's value. After the first pass, `$` + `{SET}` forms `${SET}`.
- The policy passes that template for Claude Code and Cursor as reading only EMPTY. A template could then read any variable in the engineer's environment, a secret included, and send it to a server, with no rule S or V check on SET.
- Codex sends the text as written.
- **Evidence:** `~/.hermes/plans/leorna/evidence/86bcm901j/fixer7/probe-real-tools-fixer7.txt` (cases d-double-pass, d-nested) and `fixer7/found-else-double-expansion.txt`. Read them, but don't write in `fixer7/`.

**Close the class, not the example.** The goal: no template text can make Claude Code read a variable the policy didn't count, in any field it expands (command, args, env values, url, headers).
- Build the rule from Claude Code's real behaviour, with real-tool probes in throwaway homes.
  - How many passes does it make?
  - Does a reference's own value get expanded again, or only text the template wrote?
  - Which neighbours of a reference can form a new one: a `$` just before, a `{` just after, an empty default, a nested default?
- One safe shape: fail any template whose text, after every reference is replaced by an empty string (and by `$`), still contains a reference the first pass didn't, or `$` directly before a reference, or a reference directly followed by `{`. Choose what the probes show is tight and true.
- Keep every shipped item and plan-approved template valid. Keep every earlier fix's behaviour: plain `${NAME}` and `Bearer ${VAR}` pass, and a valid `${NAME:-x}` still fails (R4).
- The reason names the field (and the header, by sorted position when its name isn't plain), never the value.
- Add AC3 subtests: one per refused spelling, plus positive controls (`$` as plain text elsewhere, `$$` with no reference, `{x}` as plain text, two plain references side by side).
- Run one overlay mutant per new check, including dropping it and putting the value at the **end** of the reason.
- Re-run every earlier mutant set: ruling 13's 9 and fixer 7's 58.
- Update README rule V or S to match exactly.
- **Scope:** `internal/library/gate/policy.go`, its tests and `internal/library/README.md` only. Don't change `render/`, OpenAPI, migrations, `.github/`, the Makefile, the seed or `THIRD_PARTY_NOTICES.md`.

## Gates, hand-over, environment

- **Gates on your final head**, exactly as fixer 7 ran them (`briefs/86bcm901j-mcp-templates-fixer7.md` and its receipts in `fixer7/`):
  - `make check`, with CI-pinned tools bound by absolute path and Postgres set. Read the Postgres results per test from `go test -json`.
  - `bash ./scripts/test-module-add.sh`
  - gitleaks over the branch range, plus `gitleaks dir` on the both-sides files.
  - The story-shippable unittest.
  - `make library-check`.
  - Each AC test by name, AC5 with the real tools in throwaway homes.
  - Branch hygiene.
  - Save `gates-<sha7>-*.txt`, `ac<n>-<sha7>.log`, five AC screenshots and a gate-summary screenshot on the final head.
  - Open each image, and check that the bottom crop shows the log's own `EXIT=` line. Take the page height from Chrome rather than estimating it from line wraps.
- **Hand-over refresh** in `…/86bcm901j/handover/`:
  - `pr-text.md` and its copy `~/.hermes/cache/scratch/leorna-pr-86bcm901j-mcp-templates.md`: body only. The Test Plan lists only the final head's runs and keeps the earlier records.
  - `clickup-evidence.md` and `review-prompt.md`: update for the new head.
  - `INVENTORY.md`: add a "Fixer 8" section.
- **Environment:** the same as fixer 7. These parts are different for you:
  - Cache folder: `~/.cache/86bcm901j-fixer8/`.
  - Database: `leorna_86bcm901j_fix8_test`. Check the port with `docker port leorna-test-pg 5432`.
  - Receipts: `…/86bcm901j/fixer8/`.
  - Scratch: `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-fixer8/`.
  - `tail` is uutils: write `tail -n N`.
  - Foreground Bash calls move to the background after 180 s: poll in steps under 170 s.
- **Never:**
  - touch other stories' worktrees, branches, databases, evidence or caches;
  - switch the main checkout's branch;
  - run real Codex or Claude Code against Justin's real `~/.codex` or `~/.claude`, not even for `--version`;
  - print a token.
- **Commits:** use the repo identity (`Justin Issa <justin@leorna.com>`), `fix(86bcm901j): …`, with no author override, no AI line and no `CLAUDE.md`. End with a clean worktree, and remove your cache and scratch folders and drop your database.

## Rules

- **Product decisions:** if a safe fix needs one, record it as "My ruling, not yet confirmed". If it isn't safe, stop with `status: stopped` and the options.
- **Other bugs:** list them in `found_else`, one line each, with evidence and severity.
- **Skill lessons:** don't edit any skill or memory file. List lessons in `skill_lessons[{skill, lesson, evidence, enforce}]` and in a "Skill lessons" section. `enforce` is `none` or a one-line proposal for a check (its kind, what it checks, where it runs). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`

## What to return

Return, in plain words:

`{name: "86bcm901j-mcp-templates", status: ready-for-verify|stopped, verified_head: "de9dbde", final_head, commits_on_top[], dispositions[{id, valid, action, commit, test, mutation, evidence}], class_covered[], real_tool_probes[], rulings[], gates[{name, exit, log}], ac_tests[{ac, test, head_log, screenshot}], pr_body_path, handover_files[], owed[], found_else[], skill_lessons[]}`
