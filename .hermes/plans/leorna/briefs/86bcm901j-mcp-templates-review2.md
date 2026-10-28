# REVIEWER 2 brief (review only): leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs"

Written by the main session (orchestrator) on 2026-10-28. Pipeline: **Full** (`review-fix-cadence`): review 1 → fixer 1 → **review 2 (you) of the corrected code** → fixer 2 → verifier → AC auditor → hand-over. Model: Opus 5.5, xhigh.

## Your role

You are a **fresh, independent REVIEWER**. You have never seen this build or its fixes. **Report only: change nothing.** No edit, commit, push, merge, PR or ClickUp write. Restore anything you touch byte-for-byte; the worktree must end exactly as you found it (`git status --porcelain --untracked-files=all` empty, HEAD unchanged). Prefer `go test -overlay` or a detached scratch copy over editing the worktree.

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna` (review rules and gates; skip its Step 1 full context load)
2. `engineering-best-practices`
3. `requesting-code-review`: security scan and quality gates. **Skip its "independent reviewer subagent" and auto-fix steps:** you are the fresh reviewer, and you can't spawn agents.
4. `code-review-practice` (note its "Guard vs consumer parsing" bullet: review 1 found exactly that class here)
5. `security-best-practices`: required for every role on this story.
6. `mutation-testing-discipline`

## What to review

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`, branch `feat/86bcm901j-mcp-templates`.
- **Candidate:** head `f36285db13ae4d5189978f35d3e1a9103563c003`, base `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d` (= `origin/main`). Review the **whole** `git diff 1ee7157...f36285d` (12 commits) against the plan, and look hard at the fix delta `7c2c35a..f36285d` (9 commits: `policy.go`, `policy_test.go`, `realtools_test.go`, `internal/library/README.md`, `codex-defaults/{item.json,example.md}`, `content.lock.json`). Record the exact head you reviewed.
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901j/plan-approved.md` (read-only), including `## Justin's answers (2026-10-28)`. ACs AC1–AC5 and their test names are fixed.
- **Review 1** (on `7c2c35a`) found 3 Major, 4 Minor and 1 Nit: R1-1 the policy skipped itself when its own case-insensitive decode failed; R1-2 the Codex floor could be bypassed with case-variant keys and was a denylist (real Codex ran `danger-full-access` + approval `never` in 154/200 gate passes); R1-3 failure reasons repeated a value (a token reached the JSON report, log and Markdown summary); R1-4 npx options written with `=` (`--registry=`, `--package=`) got through; R1-5 rule S ignored args, URL queries and credential names outside its pattern; R1-6 two guards had no killing test; R1-7 docs overstated `history.persistence = "none"`; R1-8 `runTool` had no `WaitDelay`. Review 1's evidence: `~/.hermes/plans/leorna/evidence/86bcm901j/review1/` (probes in `probes/`, mutations in `mutations/`).
- **Fixer 1's claims** (verify, don't trust): all eight valid and fixed, one commit each (a68f3f5 R1-1, e46711c R1-3, d6a9068 R1-2, c07dbc0 R1-4, 30b95b7 R1-5, 93acfde R1-6, 2de54c5 R1-7, 7e06876 R1-8, f36285d fail-closed branch tests); exact-key reads that fail closed, duplicate JSON keys rejected; both config floors are now exact-key allowlists; reasons name the server/key/`args[i]` and never the value; only `-y`/`--yes`/`--` before the npx package, and `npm_config_*`/`NODE_OPTIONS` in env fail; credential-named options and query parameters must use `${VAR}`; 67/67 mutants killed; review 1's probes re-run on the head all fail the gate. Its dispositions are in `~/.hermes/plans/leorna/evidence/86bcm901j/INVENTORY.md` ("Fixer 1") and its receipts in `…/86bcm901j/fixer1/`. Re-run review 1's probes yourself and write your own.
- **Fixer 1's rulings to judge** (marked "not yet confirmed"):
  1. Claude Code settings may set no `env` variable yet; credential-like keys keep the approved message, any other key fails. Nothing shipped sets env.
  2. The Codex allowlist is only `approval_policy = "on-request"`, `sandbox_mode` `workspace-write` or `read-only`, `sandbox_workspace_write.network_access = false`, and `history.persistence` `none` or `save-all`; everything else fails until a rule is added, including `model`. The Claude Code allowlist is `$schema`, `model`, deny, ask, the two "disable" keys and `blockReadsOutsideWorkingDirectories`, plus an empty allow/additionalDirectories and the conservative modes.
  3. The extra credential words (pat, pass, pwd, auth, oauth, cookie, dsn, jwt, bearer, key, sig, signature as whole words) live in the policy only; the tiles' rule in `internal/integration/tile.go` is unchanged. `key` can flag a harmless name like `SORT_KEY`; the fix is to use a `${VAR}`.
  4. The approved AC2 subtest name "…keeps no prompt history" stays (Codex's own term for history.jsonl); only the item docs were corrected.
- **Known and out of scope** (don't report as introduced; list in `found_else` only if you find more): pre-existing on main, 901u `gate.go` `checkFormats` puts BurntSushi's TOML error text, which can quote a value, into the render-stage reason.

## Look hard at (not a limit)

- Did each fix close the **class**, not just the witnesses? Try new variants: other case/Unicode forms, nested or repeated keys, arrays vs strings, TOML dotted keys vs tables, inline tables, quoted keys, JSON escapes in keys, `npx` spellings (`--yes=true`, `-y` after the package, `npm exec`), URL forms (`HTTPS://`, IDN, `@` in path), env value forms.
- Do the new allowlists still accept every shipped item and every valid item the plan expects? Do they break other library items (the siblings' items check their own, but run the full library gate)?
- Does any reason, error or log line still repeat a value? Check `WriteJSON`, `WriteLog` and `WriteMarkdown` paths.
- Regressions the fixes caused, and tests that pass for the wrong reason.

## Gates and environment

- Windows desktop (Ubuntu under WSL). Reuse the tools under `~/.local/leorna-tools` read-only (Go, CI-pinned golangci-lint 2.14.0 and govulncheck v1.7.0, make, Zig as `CGO_ENABLED=1 CC="zig cc"`); never modify or delete them or other sessions' `~/.local/leorna-toolchain`.
- **Disk:** `/tmp` is a 7.9 GB tmpfs shared by every session (88% full now). Put `TMPDIR`, Postgres data, detached gate copies and the Zig cache in `~/.cache/86bcm901j-review2/` on the real disk (create with `mkdir`, no `-p`; remove it at the end). Small notes can go in your scratch folder below.
- Run the plan's gates yourself on the head: `make check` with CI-pinned tools bound by absolute path, `bash ./scripts/test-module-add.sh`, gitleaks (branch range), the story-shippable check, `make library-check`, each AC test by name (AC5 with `LEORNA_TEST_CODEX_BIN` and `LEORNA_TEST_CLAUDE_BIN`, throwaway homes only, never the real `~/.codex` or `~/.claude`), and base vs head by test name.
- **Postgres:** Docker inside Ubuntu is still off. Use the no-sudo PostgreSQL 18.6 recipe in `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-control-plane-workflow.md` ("No-sudo gate recipe"; TCP only, `-c unix_socket_directories=''`), with your own database `leorna_86bcm901j_review2_test` on a free port; read results per test from a `go test -json` stream, then stop the server and delete its data. `TestSetupWizardWithPostgres` can time out under host load: run it alone before calling it a regression.
- **Scratch:** `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-review2/` with `mkdir` (no `-p`). The scratchpad is shared by every subagent in this session; never touch other folders in it. Remove your folders at the end (after `git worktree remove` for any copy).
- **Your evidence:** copy what you cite into `~/.hermes/plans/leorna/evidence/86bcm901j/review2/` (create it). Write nowhere else in the evidence folder; never touch `plan-approved.md`.
- **Never touch** other stories' worktrees (`86bcm901a-agent-definitions`, `86bcm901w-create-pack`, maybe `86bcm901b`), branches, databases or evidence folders, and never switch the main checkout's branch. Never print a token or password.

## Severity and findings

Critical / Major / Minor / Nit. For each finding: an id (R2-1, R2-2…), severity, whether it was introduced by this branch (and whether by the fix delta) or already on main, the claim, and your own evidence (file:line, command and output, a killing or surviving mutant). Say for each R1 finding whether it is closed on this head. For each AC, say whether you accept it on this head, with its test, screenshot path (fixer 1's `ac<n>-…-f36285d.png` or yours) and evidence.

## Rules

- **Other bugs outside this change:** list them in `found_else` (one line each, with evidence and severity).
- **Skill lessons:** if you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`
- If you wait on a long command, wait in the foreground (a bounded poll), not by ending your turn.

## What to return

`{verdict: clean|findings, reviewed_head, r1_closed[{id, closed, evidence}], findings[{id, severity, introduced, claim, evidence}], rulings_assessment[{ruling, agree, why}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{name, exit, log}], postgres: ran|not_run, defect_loop_skills[], found_else[], skill_lessons[]}`. `verdict` and `ac_status` are required. Plain words.
