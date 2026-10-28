# FIXER 2 brief: leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs"

Written by the main session (orchestrator) on 2026-10-28. Pipeline: **Full** (`review-fix-cadence`): review 1 → fixer 1 → review 2 → **fixer 2 (you)** → verifier → AC auditor → hand-over. Model: Opus 5.5, xhigh.

## Your role

You are a fresh **FIXER** for review 2's findings. Verify each finding yourself, fix the valid ones **test-first**, push back with evidence on any you find invalid, re-run the gates, commit, and **stop with `status: ready-for-verify`**. A fresh verifier runs next, so no hand-over yet: no PR text, team message or ClickUp draft. **Never push, open a PR, merge or write to ClickUp.**

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna` (gates, evidence and commit rules; skip its Step 1 full context load)
2. `engineering-best-practices`
3. `receiving-code-review`
4. `test-driven-development`
5. `security-best-practices`: required for every role on this story (see its npx/launcher paragraph).
6. `mutation-testing-discipline`: one mutant per member of any list-valued guard (word lists, allowlists, denylists).
7. `git-commit-rules`
8. `systematic-debugging` whenever something fails unexpectedly.

## Inputs

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`, branch `feat/86bcm901j-mcp-templates`. Reviewed head `f36285db13ae4d5189978f35d3e1a9103563c003`, base `1ee7157` (= `origin/main`).
- **Approved plan:** `~/.hermes/plans/leorna/86bcm901j-mcp-templates.md` (read-only copy `~/.hermes/plans/leorna/evidence/86bcm901j/plan-approved.md`; never edit that copy), including `## Justin's answers (2026-10-28)`. AC1–AC5 and their test names stay exactly as approved.
- **History:** `~/.hermes/plans/leorna/evidence/86bcm901j/INVENTORY.md` (builder and "Fixer 1" sections), review 1's evidence in `…/86bcm901j/review1/`, fixer 1's in `…/fixer1/`, review 2's in `…/review2/` (probes in `probes/`, mutation runs in `mutations/mutations-run-f36285d.txt`).
- **Review 2's verdict:** findings, no Critical or Major. All five ACs accepted on `f36285d`; R1-1 to R1-8 closed (R1-3, R1-4 and R1-5 have the residuals below). Review 2 agreed with all four of fixer 1's rulings (no `env` in Claude Code settings yet; the exact Codex and Claude Code allowlists; the extra credential words in the policy only; the AC2 subtest name kept).

## Review 2's findings (reviewer's words condensed; verify each)

**Fix the class each finding names, not only the witnesses,** port the reviewer's witnesses as tests, keep every shipped item passing, and keep approved behaviour for valid templates and configs.

- **R2-1 · Minor · introduced (fix commit c07dbc0 made the env check a denylist): a local server's env can change which program runs, and the gate still passes.** The policy refuses only `npm_config_*` / `NODE_OPTIONS` (`policy.go:44-47`, `:211-215`). A template whose server env sets `PATH`, `LD_PRELOAD`, `NODE_EXTRA_CA_CERTS`, `NODE_TLS_REJECT_UNAUTHORIZED` or `HOME` passes with all three tools declared (`review2/probes/review2-probes-on-f36285d.txt`). Real proof: Claude Code 2.1.312 in a throwaway HOME (`claude mcp list`) ran a fake `npx` from the server's `env.PATH`; the marker recorded `-y api-mcp@1.0.0` (`review2/probes/r2-1-claude-runs-path-npx.txt`). The README lists only proxy/CA settings as unchecked. Reviewer's suggested fix: also refuse `PATH`, `LD_*`, `DYLD_*`, every `NODE_*`, `HOME`/`XDG_CONFIG_HOME`, or allow only a known set of env keys, with tests; or document the limit. Prefer the fail-closed fix if it keeps the shipped and plan-approved templates valid.
- **R2-2 · Minor · introduced (the R1-3 fix e46711c names keys): policy reasons quote keys word for word, so a token pasted into a key is repeated.** Example: a whole header line pasted as the header name (`"Authorization: Bearer <token>": ""`). With real gitleaks the secrets stage withholds the token, but the policy reason prints it, and it reached the JSON report, the CI log and the job summary (`review2/probes/review2-key-echo-real-gitleaks-f36285d.txt`). The same happens through env keys, server names and Codex inner keys (`policy.go:168, 181-191, 209, 384, 465`). This breaks AC1's "without repeating the value" and the README's "never repeats a value" for that case. Reviewer's suggested fix: name a key only when it looks like a plain name, otherwise refer to it by position; add a `requireNotRepeated` test with a token inside a key. **Check every reason that names a key, server or setting.**
- **R2-3 · Minor · test gap from fix commit 30b95b7: nine mutants survive.** Dropping any one of `auth`, `oauth`, `pwd`, `passphrase`, `dsn`, `jwt`, `bearer` or `sig`/`signature` from `credentialWord` (`policy.go:37`) fails no test (W01–W08), nor does removing the query-name percent-decoding (`:566`, W09). Fixer 1's single all-words-off mutant was killed by the four tested words and hid the rest. Suggested fix: one test case per word, plus an encoded query name such as `t%6Fken=`. Then mutate each member alone.
- **R2-4 · Nit: some credential names and forms still pass** (the README already lists unmatched names and positional tokens as limits, so not blocking). camelCase names (`authKey`, `accessKey`, `privateKey`) pass in env, query or option because the whole-word rule reads `authKey` as one word. Also passing: `--header "Authorization: Bearer <literal>"`, a `NAME=value` arg, a `#access_token=` fragment, `;`-separated query parameters, a second URL inside one value. Suggested improvement: split camelCase names into words before matching. Fix what is cheap and safe; document the rest in the README's limits.
- **R2-5 · Nit (follows the plan's list): wrong reason for `defaultMode: "manual"`.** Claude Code 2.1.312 treats `"manual"` as `"default"` (binary: `e==="manual"?"default":e`). The policy refuses it with the reason "answers questions for the engineer" (`policy.go:49`, `:442`): safe direction, wrong reason. Make the reason accurate (or accept `"manual"` as the default it is, if that is the safer reading of the plan); say which you chose and why.

**Known and out of scope** (leave them; they are recorded as follow-ups): pre-existing on main, the copied renderers (`render/`, which must stay identical to the client) quote keys in their warnings and errors, and 901u `gate.go` `checkFormats` puts BurntSushi's TOML error text into the render-stage reason. Don't change `render/`, OpenAPI, migrations, `.github/`, the Makefile, the seed or `THIRD_PARTY_NOTICES.md`.

## How to work

- For each finding: reproduce it on `f36285d` with a failing test that captures the class, fix, show it green, and run mutants that loosen the fix (one per list member). One commit per finding or closely linked group, `fix(86bcm901j): …` or `test(86bcm901j): …`.
- If a fix needs a product decision that isn't already Justin's, record a safe, reversible choice as "My ruling, not yet confirmed"; if it isn't safe, stop with `status: stopped` and the options. Under Justin's standing grant, prefer the scoped secure fix over accepting a weakness.

## Gates, environment and evidence

- Windows desktop (Ubuntu under WSL). Reuse the tools under `~/.local/leorna-tools` read-only (Go, CI-pinned golangci-lint 2.14.0 and govulncheck v1.7.0, make, Zig as `CGO_ENABLED=1 CC="zig cc"`); never modify or delete them or other sessions' `~/.local/leorna-toolchain`.
- **Disk:** `/tmp` is a 7.9 GB tmpfs shared by every session. Put `TMPDIR`, Postgres data, detached copies and the Zig cache in `~/.cache/86bcm901j-fixer2/` on the real disk (`mkdir`, no `-p`; remove it at the end).
- On your final head, run the plan's gates (Task 8): `make check` with CI-pinned tools bound by absolute path, `bash ./scripts/test-module-add.sh`, gitleaks (branch range), the story-shippable check, `make library-check`, each AC test by name (AC5 with `LEORNA_TEST_CODEX_BIN` and `LEORNA_TEST_CLAUDE_BIN`, throwaway homes only, never the real `~/.codex` or `~/.claude`), base vs head by test name, and a final mutation sweep that includes review 2's W01–W09.
- **Postgres:** Docker inside Ubuntu is still off. Use the no-sudo PostgreSQL 18.6 recipe in `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-control-plane-workflow.md` ("No-sudo gate recipe"; TCP only, `-c unix_socket_directories=''`), with your own database `leorna_86bcm901j_fix2_test` on a free port; read results per test from `go test -json`, then stop the server and delete its data. `TestSetupWizardWithPostgres` can time out under host load: run it alone and rerun before calling it a regression.
- **Evidence:** `~/.hermes/plans/leorna/evidence/86bcm901j/`. Save gate logs `gates-<sha7>-*.txt` with exit codes and the five AC logs `ac<n>-<sha7>.log`, re-take the five AC screenshots on your final head with the in-sandbox Chrome route recorded in `INVENTORY.md`, re-take `gate-summary-<sha7>.png`, and add a "Fixer 2" section to `INVENTORY.md` (a disposition per finding with commit, test and mutation). Receipts go in `…/86bcm901j/fixer2/`. Don't write in `review1/`, `review2/`, `fixer1/`, `verifier/` or `auditor/`; never touch `plan-approved.md`.
- **Scratch:** `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-fixer2/` with `mkdir` (no `-p`), for small notes only. The scratchpad is shared by every subagent in this session; never touch other folders in it. Remove your folders at the end (after `git worktree remove` for any copy).
- **Never touch** other stories' worktrees (`86bcm901a-agent-definitions`, `86bcm901w-create-pack`, maybe `86bcm901b`), branches, databases or evidence folders, and never switch the main checkout's branch. Commit with the repo's own identity (`Justin Issa <justin@leorna.com>`), no author override, no `Co-Authored-By` or AI line, no `CLAUDE.md`. End with a clean worktree (`git status --porcelain --untracked-files=all` empty).

## Rules

- **Other bugs or problems you find:** don't fold them in; list them in `found_else` (one line each, with evidence and severity).
- **Skill lessons:** if you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`
- If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the last commit and which findings remain.
- If you wait on a long command, wait in the foreground (a bounded poll), not by ending your turn.

## What to return

`{name: "86bcm901j-mcp-templates", status: ready-for-verify|stopped, summary, reviewed_head: "f36285d", last_commit, dispositions[{id, valid, action, commit, test, mutation, evidence}], rulings[], gates[{name, exit, log}], ac_tests[{ac, test, head_log, screenshot}], postgres: ran|not_run, owed[], found_else[], skill_lessons[]}`. Plain words.
