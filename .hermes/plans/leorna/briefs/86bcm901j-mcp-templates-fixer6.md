# FIXER 6 brief: leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs" (PR #98)

Written by the main session (orchestrator) on 2026-10-29. Pipeline: **Full**. PR #98 is open at `17f2ccf` → verifier round 3 (findings: V3-1) → **fixer 6 (you)** → fresh verifier → blind AC auditor → `ac-check.sh` → the main session pushes. Model: Opus 5.5, xhigh.

## Your role

You are a fresh **FIXER** with three jobs:
1. Verify V3-1 yourself and fix it **test-first as a class**.
2. Record PR #98 in `delivery/stories.json`.
3. Run the gates and the five AC tests on your final head, refresh the hand-over texts, commit, and **stop with `status: ready-for-verify`**.

**Never push, comment on the PR, merge or write to ClickUp.** The main session pushes after the verification passes. Don't rebase or rewrite existing commits: new commits go on top of `17f2ccf`.

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna`. Skip its Step 1 full context load. Read Doing a story → step 7.8 for the `stories.json` PR record and its check command.
2. `engineering-best-practices`
3. `receiving-code-review`
4. `test-driven-development`
5. `security-best-practices`: required for every role on this story. Read its npx/launcher env paragraph; it now records what real Claude Code refuses in header names and values.
6. `mutation-testing-discipline`
7. `git-commit-rules`
8. `systematic-debugging` whenever something fails unexpectedly.

## Inputs

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`, branch `feat/86bcm901j-mcp-templates`, head `17f2ccf09d79d53a2b8ffa0eac03011271b0a111`, which is PR #98's head on GitHub. The base is GitHub main `6c1709e`; fetch it fresh over HTTPS through gh and say if it has moved.
- **Approved plan:** `~/.hermes/plans/leorna/86bcm901j-mcp-templates.md`, including every "Justin's answers" section and the newest one, `## Justin's answers (2026-10-29, PR #98)`. A read-only copy is at `…/evidence/86bcm901j/plan-approved.md`: never edit it. AC1–AC5 and their test names stay exactly as approved.
- **Verifier round 3's report folder:** `~/.hermes/plans/leorna/evidence/86bcm901j/verifier-17f2ccf/`. Read it, but never write in it. The key files are `probes-17f2ccf.log` (the `V3PROBE B` lines) and `probe-real-claude-17f2ccf.txt`.
- **Ruling 13's change:** commit `5070d4a` and its receipts in `…/86bcm901j/fixer4/` (`r13-mutations.txt`, `probe-nul-real-claude.txt`).

## The finding (verifier's words condensed; verify it)

**V3-1 · Low · same class as ruling 13.** Rule V and ruling 13 report Claude Code, Codex and Cursor as "verified" for a remote server whose headers real Claude Code 2.1.312 refuses to connect with:
- **Header values** holding LF, CR, CR LF (`"a\r\nX-Injected: 1"`) or a character above U+00FF. Claude Code says "Header 'X-Client' has invalid value".
- **Header names** holding a NUL or a line break, containing a space or a colon, or empty. Claude Code says "Invalid header name".
- **Controls that go ahead** (to ECONNREFUSED): a plain value, a Latin-1 letter, a tab, U+0001 and U+007F.

No shipped template is affected: github-mcp's only header is `Authorization: Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}`.

**Justin's decision (2026-10-29):** fix it.
- Header names must be RFC 9110 field-name tokens.
- Header values may not hold CR, LF, NUL or a character above U+00FF.
- Each fails at template level for every tool, naming the header (by sorted position if the name isn't a plain token, as the policy already does) and never the value.
- Add AC3 subtests: one per refused spelling, plus positive controls for the accepted ones (tab, U+0001, U+007F, a Latin-1 letter, a plain value, `Bearer ${VAR}`).

**Close the class, not the example.** The next verifier will try more spellings. Think about every way a header name or value can reach the HTTP request differently from how the policy reads it, and decide each one with a real-tool probe where you can, in a throwaway HOME. Spellings to consider include:
- names differing only in case (`Authorization` plus `authorization`);
- leading or trailing spaces in a value;
- obs-fold;
- Unicode look-alikes in names;
- a `${VAR}` reference inside a name;
- an empty value.

Refuse only what's provably refused or provably unsafe, and keep every shipped item and plan-approved template valid. Run one overlay mutant per new check (including dropping it entirely, and repeating the value in the reason). Update the README's rule V text, the ruling 13 sentence, to match the new rule exactly.

## Also in this round

- **Record PR #98 in `delivery/stories.json`** (`leorna` step 7.8). Change only this story's entry, which is last. Check it with `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` and with `python3 scripts/check-story-shippable.py 86bcm901j`, read-only. Report that check's output as it is: it may block on PR #98 not being merged yet, which is expected. Use a separate commit: `docs(86bcm901j): record PR #98 in the delivery inventory`.
- **Out of scope (already PR follow-ups; leave them):**
  - the copied renderers (`render/`) quoting keys;
  - 901u's `checkFormats` putting TOML text in the reason;
  - unmatched credential names;
  - version-manager settings;
  - `gate.CheckTenantItem` not running the policy;
  - `Library.Required`;
  - the 86bcm9019 PR record;
  - `ſHELLOPTS`.

  Don't change `render/`, OpenAPI, migrations, `.github/`, the Makefile, the seed or `THIRD_PARTY_NOTICES.md`.

## Gates, environment and evidence

- **Gates on your final head**, exactly as fixer 5 ran them (`briefs/86bcm901j-mcp-templates-fixer5.md` task 4 and its receipts in `fixer5/`):
  - `make check`, with CI-pinned tools bound by absolute path and Postgres set. Read the Postgres results per test from `go test -json`.
  - `bash ./scripts/test-module-add.sh`
  - gitleaks over the branch range, plus `gitleaks dir` on the both-sides files.
  - The story-shippable unittest.
  - `make library-check`.
  - Each AC test by name, AC5 with `LEORNA_TEST_CODEX_BIN` and `LEORNA_TEST_CLAUDE_BIN`, in throwaway homes only.
  - Branch hygiene.
  - Ruling 13's NUL mutants re-run with `go test -overlay`.
  - Save `gates-<sha7>-*.txt` and `ac<n>-<sha7>.log` with `HEAD=` and `EXIT=` lines, plus five AC screenshots and a gate-summary screenshot on the final head, and open each one.
- **Refresh the hand-over** in `…/86bcm901j/handover/` for your final head:
  - **`pr-text.md` and its copy `~/.hermes/cache/scratch/leorna-pr-86bcm901j-mcp-templates.md`:**
    - Body only, no `Title:` line.
    - The Summary and rule V line mention header names and values.
    - The `stories.json` line says PR #98 is recorded.
    - The Test Plan lists only what ran on the final head, keeping the `66449af` ac-check record. Hosted CI on `17f2ccf` passed (Go quality gates, merge state CLEAN). The new head's CI, the new verifier, the auditor and `ac-check.sh` stay unchecked; the main session updates them after.
  - **`clickup-evidence.md` and `review-prompt.md`:** update for the new head.
  - **`INVENTORY.md`:** add a "Fixer 6" section.
  - The main session will edit the live PR body with `gh pr edit` after the push. You don't touch the PR.
- **Environment:** the same as fixer 4: read "Environment" in `briefs/86bcm901j-mcp-templates-fixer4.md`. These parts are different for you:
  - Cache folder: `~/.cache/86bcm901j-fixer6/`.
  - Database: `leorna_86bcm901j_fix6_test`.
  - Receipts: `…/86bcm901j/fixer6/`.
  - Scratch: `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-fixer6/`.
  - `tail` is uutils: write `tail -n N`.
  - In a subagent, a foreground Bash call moves to the background after 180 s, so split long waits into polls under 170 s each.
- **Never:**
  - touch other stories' worktrees, branches, databases, evidence or caches;
  - switch the main checkout's branch;
  - run real Codex or Claude Code against Justin's real `~/.codex` or `~/.claude`, not even for `--version`;
  - print a token.
- **Commits:** use the repo's own identity (`Justin Issa <justin@leorna.com>`): no author override, no `Co-Authored-By` or AI line, no `CLAUDE.md`. Use `fix(86bcm901j): …` for the fix and `docs(86bcm901j): …` for the record. End with a clean worktree, and remove your cache and scratch folders and drop your database.

## Rules

- **Product decisions:** if a safe fix needs one, record it as "My ruling, not yet confirmed". If it isn't safe, stop with `status: stopped` and the options.
- **Other bugs:** list them in `found_else`, one line each, with evidence and severity.
- **Skill lessons:** don't edit any skill or memory file. List lessons in `skill_lessons[{skill, lesson, evidence}]` and in a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`
- **Out of steps:** if you run low, commit what passes and stop with `status: stopped` and `stop_reason: out of steps`.

## What to return

Return, in plain words:

`{name: "86bcm901j-mcp-templates", status: ready-for-verify|stopped, verified_head: "17f2ccf", origin_main, final_head, commits_on_top[], dispositions[{id, valid, action, commit, test, mutation, evidence}], class_covered[], real_tool_probes[], rulings[], stories_json{commit, unittest, check_story_shippable_output}, gates[{name, exit, log}], ac_tests[{ac, test, head_log, screenshot}], pr_body_path, handover_files[], owed[], found_else[], skill_lessons[]}`
