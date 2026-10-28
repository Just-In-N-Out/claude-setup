# REVIEWER 1 brief (review only): leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs"

Written by the main session (orchestrator) on 2026-10-28. Pipeline: **Full**, review 1 of 2 (`review-fix-cadence`: review 1 → fixer → review 2 of the corrected code → fixer → verifier). Model: Opus 5.5, xhigh.

## Your role

You are a **fresh, independent REVIEWER**. You have never seen this build. **Report only: change nothing.** No edit, commit, push, merge, PR or ClickUp write. Anything you touch for a check (a mutation, a probe), restore byte-for-byte; the worktree must end exactly as you found it (`git status --porcelain --untracked-files=all` empty, HEAD unchanged). Prefer `go test -overlay` or a scratch copy over editing the worktree.

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna` (its review rules and gates; skip its Step 1 full context load except the notes the plan points to)
2. `engineering-best-practices`
3. `requesting-code-review`: its security scan and quality gates. **Skip its "independent reviewer subagent" and auto-fix steps:** you are the fresh reviewer, and you can't spawn agents.
4. `code-review-practice`
5. `security-best-practices`: Justin requires it for every role on this story (secrets, supply chain, least privilege).
6. `mutation-testing-discipline`: check that the new policy guards' tests actually fail when the guard is loosened.

## What to review

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`, branch `feat/86bcm901j-mcp-templates`.
- **Candidate:** head `7c2c35a51ee848a86d638f27720988846ae76184`, base `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d` (= `origin/main`). Review `git diff 1ee7157...7c2c35a` (3 commits, 21 files). Record the exact head you reviewed in your report.
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901j/plan-approved.md` (read-only copy; the working copy is `~/.hermes/plans/leorna/86bcm901j-mcp-templates.md`), including `## Justin's answers (2026-10-28)` at its end. Check the diff against the plan, its ACs AC1–AC5, and the `leorna` skill's rules.
- **Builder's rulings to judge** (marked "my ruling, not yet confirmed"):
  1. Installed GNU make 4.4.1 under `~/.local/leorna-tools/make-4.4.1` (no root) for the gates.
  2. Installed Zig 0.15.2 under `~/.local/leorna-tools/` and used `CGO_ENABLED=1 CC="zig cc"` for `go test -race` (CI uses gcc).
  3. Dropped two example-doc clauses it couldn't confirm: Codex "…so nothing is sent anywhere without asking first" and Claude Code "…and never reads secret files".
  4. Took screenshots inside the sandbox with headless Chrome (so the plan's Q6 wasn't needed).
- **Don't trust summaries.** The builder's evidence is in `~/.hermes/plans/leorna/evidence/86bcm901j/` (`INVENTORY.md` indexes it). Use it only as a pointer: run the gates and the AC tests yourself, try mutations yourself, and judge from your own output.

## Things to look at hard (not a limit on your review)

- Secrets: can any credential reach a shipped file, a log, a failure message or a rendered tool file? Does a failure reason ever repeat a value?
- The policy rules S, P, V, L: can each be bypassed (casing, whitespace, alternate keys, header forms, URL tricks, `npx` flag forms, tool aliases)? Do they fail closed?
- Least-privilege defaults: are the shipped Claude Code and Codex configs as strict as the plan and Justin's Q2 answer say, and is every setting documented in its `example.md`?
- Declared tools: does the check prove each declared tool really renders the template whole and reads the same variables?
- Behaviour changes to the existing 901u gate (the four changed fixtures, "warnings never fail" except on a declared tool) and anything else that could break other library items or sibling stories.
- `render/` must be unchanged (it must stay identical to the client). No OpenAPI, migration, CI (`.github/`) or Makefile change.
- AC5 runs real Codex and Claude Code: only in throwaway homes, never Justin's real `~/.codex` or `~/.claude`.

## Gates and environment

- This is the Windows desktop (Ubuntu under WSL). The builder installed tools under `~/.local/leorna-tools` (Go, CI-pinned golangci-lint and govulncheck, make, Zig): reuse them read-only, and don't modify or delete them. Other sessions keep their own tools under `~/.local/leorna-toolchain`; leave those alone.
- Run the plan's gates (Task 8) yourself on the head: `make check` with the CI-pinned tools bound by absolute path, `bash ./scripts/test-module-add.sh`, gitleaks, the story-shippable check, and each AC test by name (AC5 with `LEORNA_TEST_CODEX_BIN` and `LEORNA_TEST_CLAUDE_BIN` set, as the plan says).
- **Postgres:** Docker inside Ubuntu is still off (Justin's step), so the builder recorded the Postgres gates NOT RUN. The shared notes describe a **no-sudo PostgreSQL 18.6** you can run in your own scratch: `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-control-plane-workflow.md`, the "No-sudo gate recipe" line (TCP only, `-c unix_socket_directories=''`). If it works, run the Postgres tests with a database you own named `leorna_86bcm901j_review1_test` on a free port, read the results per test from a `go test -json` stream, then stop your server. If it doesn't work, record them NOT RUN with the reason. Never touch any other session's database or server.
- **Scratch:** create `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-review1/` with `mkdir` (no `-p`; it must not exist yet) and keep everything there, including any base-commit worktree (`git worktree add --detach`, removed when you finish) and throwaway homes. The scratchpad is shared by every subagent in this session; never touch other folders in it. Remove your folder at the end.
- **Your evidence:** copy the logs and captures you cite into `~/.hermes/plans/leorna/evidence/86bcm901j/review1/` (create it). Write nowhere else in the evidence folder, and never touch `plan-approved.md`.
- **Never touch** other stories' worktrees (`86bcm901a-agent-definitions`, `86bcm901w-create-pack`, maybe `86bcm901b`), branches, databases or evidence folders, and never switch the main checkout's branch. Never print a token or password.

## Severity and findings

Use Critical / Major / Minor / Nit. For each finding: an id (R1-1, R1-2…), severity, whether this change introduced it or it was already there, the claim, and evidence you produced (file:line, a command and its output, a failing mutation). Mark anything you are unsure of as such. For each AC, say whether you accept it on this head, with its test, its screenshot path (the builder's or yours) and your evidence.

## Rules

- **Other bugs or problems outside this change:** don't fold them into findings; list them in `found_else` (one line each, with evidence and severity).
- **Skill lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`
- If you wait on a long command, wait in the foreground (a bounded poll), not by ending your turn.

## What to return

`{verdict: clean|findings, reviewed_head, findings[{id, severity, introduced, claim, evidence}], rulings_assessment[{ruling, agree, why}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{name, exit, log}], postgres: ran|not_run (+ why), defect_loop_skills[], found_else[], skill_lessons[]}`. `verdict` and `ac_status` are required. Plain words.
