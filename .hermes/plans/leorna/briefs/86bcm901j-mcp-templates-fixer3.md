# FIXER 3 brief: leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs"

Written by the main session (orchestrator) on 2026-10-28. Pipeline: **Full**: review 1 → fixer 1 → review 2 → fixer 2 → verifier (findings) → **fixer 3 (you)** → fresh verifier → blind AC auditor → `ac-check.sh` → hand-over. Model: Opus 5.5, xhigh.

## Your role

You are a fresh **FIXER** for the verifier's one open finding, V-1. Verify it yourself, fix it **test-first as a class**, re-run the gates, commit, and **stop with `status: ready-for-verify`**. No hand-over: no PR text, team message or ClickUp draft. **Never push, open a PR, merge or write to ClickUp.**

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna` (gates, evidence and commit rules; skip its Step 1 full context load)
2. `engineering-best-practices`
3. `receiving-code-review`
4. `test-driven-development`
5. `security-best-practices`: required for every role on this story (read its npx/launcher env paragraph).
6. `mutation-testing-discipline`
7. `git-commit-rules`
8. `systematic-debugging` whenever something fails unexpectedly.

## Inputs

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`, branch `feat/86bcm901j-mcp-templates`. Verified head `f368af2199dffef71609818938a07c1aa26ce644`, base `1ee7157` (= `origin/main`).
- **Approved plan:** `~/.hermes/plans/leorna/86bcm901j-mcp-templates.md` (read-only copy `~/.hermes/plans/leorna/evidence/86bcm901j/plan-approved.md`; never edit that copy), including `## Justin's answers (2026-10-28)`. AC1–AC5 and their test names stay exactly as approved.
- **History:** `~/.hermes/plans/leorna/evidence/86bcm901j/INVENTORY.md` (builder, "Fixer 1", "Fixer 2"), review folders `review1/`, `review2/`, fixer receipts `fixer1/`, `fixer2/`, and the verifier's folder `verifier/` (read only for you).
- **Verifier's verdict on `f368af2`:** findings. All five ACs accepted, every gate green, R1-1..R1-8 and R2-2..R2-5 closed, all seven fixer rulings judged safe. Only V-1 is open.

## The finding (verifier's words condensed; verify it)

**V-1 · Minor · same class as R2-1, so R2-1 isn't fully closed.** Rule P's launch-setting list matches whole key names only (`policy.go:339-347`, `launchSetting`: `upper == setting.name || strings.HasSuffix(setting.name, "_") && strings.HasPrefix(upper, setting.name)`). An env key that carries `=` is therefore not caught: `"PATH=/dir:"`, `"PREFIX=/x"`, `"SHELLOPTS=xtrace:"`, `"PS4=$(id)"`, `"BASH_ENV=/x"`, `"SSL_CERT_FILE=/x"`. Such a template passes the gate when it lists claude-code and cursor (Codex's renderer refuses keys that aren't variable names, so listing Codex fails at the render stage, not in the policy). Prefix entries (`LD_`, `NODE_`…) are still caught. **Real effect, Claude Code 2.1.312 in a throwaway HOME:** keys `PREFIX=/tmp/evil` and `SHELLOPTS=xtrace:` reached the server as `PREFIX=/tmp/evil=x` and `SHELLOPTS=xtrace:=`; with key `PATH=<fakebin>:` and no npx on the inherited PATH, the fake npx ran. Evidence: `verifier/probes-f368af2.log` ("VPROBE V" lines) and `verifier/v1-env-key-with-equals-real-claude.txt`. Verifier's suggested fix: refuse every env key that is not a variable name `^[A-Za-z_][A-Za-z0-9_]*$` (the rule `render/codex.go` `envName` already applies), for every server.

**This is the second witness of the same class.** The next verifier will try more spellings, so close the class, not the example: think about every way an env key or value can reach a launched process differently from how the policy reads it (`=` in a key, other non-name characters, empty keys, NUL or control characters, Unicode look-alikes, leading/trailing spaces, keys that differ only after a character the tool strips). Apply the safe behaviour (refuse) only where the key is provably not a plain variable name; keep every shipped item and plan-approved template valid, keep `LOG_LEVEL=debug`-style plain settings allowed, and keep the earlier fixes' behaviour. Port the verifier's six witnesses as AC4 tests (tools claude-code and cursor), add class-level controls (positives that must still pass), and run one mutant per new check (including dropping it entirely).

**Out of scope (leave them; already recorded as follow-ups):** the copied renderers (`render/`, which must stay identical to the client) quote keys in their warnings; 901u `gate.go` `checkFormats` puts TOML error text in the render reason; names that match no credential word (`DB_CREDS`, `PASSKEY`) are a documented limit. Don't change `render/`, OpenAPI, migrations, `.github/`, the Makefile, the seed or `THIRD_PARTY_NOTICES.md`. Update `internal/library/README.md`'s rule P text if the rule changes.

## Gates, environment and evidence

- Windows desktop (Ubuntu under WSL). Tools under `~/.local/leorna-tools` read-only (Go, CI-pinned golangci-lint 2.14.0 and govulncheck v1.7.0); gcc 15.2 and make are now system-wide, so `-race` works with gcc. Never modify or delete `~/.local/leorna-tools` or other sessions' `~/.local/leorna-toolchain`.
- **Disk:** `/tmp` is a small tmpfs shared by every session (it was down to ~100 MB free). Put `TMPDIR`, detached copies and caches in `~/.cache/86bcm901j-fixer3/` on the real disk (`mkdir`, no `-p`; remove it at the end).
- **Postgres:** Docker is on and `leorna-test-pg` is running. Use your own database `leorna_86bcm901j_fix3_test` (read the container's password first and abort if it's empty; never touch another session's database) and drop it at the end; read results per test from `go test -json`. `TestSetupWizardWithPostgres` can time out under load: run it alone and rerun before calling it a regression.
- On your final head, run the plan's gates (Task 8): `make check` with CI-pinned tools bound by absolute path and Postgres set, `bash ./scripts/test-module-add.sh`, gitleaks (branch range), the story-shippable check, `make library-check`, each AC test by name (AC5 with `LEORNA_TEST_CODEX_BIN` and `LEORNA_TEST_CLAUDE_BIN`, throwaway homes only, never the real `~/.codex` or `~/.claude`, including for `--version`), base vs head by test name, and the verifier's probe bodies re-run on your head (all must fail the gate without repeating any token).
- **Evidence:** `~/.hermes/plans/leorna/evidence/86bcm901j/`: gate logs `gates-<sha7>-*.txt` with exit codes, AC logs `ac<n>-<sha7>.log`, five AC screenshots on your final head (the in-sandbox Chrome route in `INVENTORY.md`), and a "Fixer 3" section in `INVENTORY.md`. Receipts go in `…/86bcm901j/fixer3/`. Don't write in `review1/`, `review2/`, `fixer1/`, `fixer2/`, `verifier/` or `auditor/`; never touch `plan-approved.md`.
- **Scratch:** `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-fixer3/` with `mkdir` (no `-p`), small notes only. The scratchpad is shared by every subagent in this session; never touch other folders in it. Remove your folders at the end (after `git worktree remove` for any copy).
- **Never touch** other stories' worktrees (`86bcm901a-agent-definitions`, `86bcm901b-prompts-collection`, `86bcm901w-create-pack`), branches, databases or evidence folders, or their `~/.cache/86bcm901*-*` folders, and never switch the main checkout's branch. Commit with the repo's own identity (`Justin Issa <justin@leorna.com>`), `fix(86bcm901j): …`, no author override, no `Co-Authored-By` or AI line, no `CLAUDE.md`. End with a clean worktree.

## Rules

- If a safe fix needs a product decision, record it as "My ruling, not yet confirmed"; if it isn't safe, stop with `status: stopped` and the options.
- **Other bugs:** list them in `found_else` (one line each, with evidence and severity).
- **Skill lessons:** don't edit any skill or memory file: list them in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`
- If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`.
- If you wait on a long command, wait in the foreground (a bounded poll), not by ending your turn.

## What to return

`{name: "86bcm901j-mcp-templates", status: ready-for-verify|stopped, summary, verified_head: "f368af2", last_commit, dispositions[{id, valid, action, commit, test, mutation, evidence}], class_covered[], rulings[], gates[{name, exit, log}], ac_tests[{ac, test, head_log, screenshot}], owed[], found_else[], skill_lessons[]}`. Plain words.
