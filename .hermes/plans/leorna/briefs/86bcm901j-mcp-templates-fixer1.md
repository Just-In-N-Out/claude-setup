# FIXER 1 brief: leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs"

Written by the main session (orchestrator) on 2026-10-28. Pipeline: **Full** (`review-fix-cadence`): review 1 → **fixer 1 (you)** → review 2 of the corrected code → fixer 2 → verifier → AC auditor → hand-over. Model: Opus 5.5, xhigh.

## Your role

You are a fresh **FIXER** for review 1's findings. Verify each finding yourself, fix the valid ones **test-first**, push back with evidence on any you find invalid, re-run the gates, commit, and **stop with `status: ready-for-next-review`**. No hand-over yet: no PR text, team message or ClickUp draft. **Never push, open a PR, merge or write to ClickUp.**

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna` (BUILDER/FINISHER rules for gates, evidence and commits; skip its Step 1 full context load)
2. `engineering-best-practices`
3. `receiving-code-review`: verify each finding before fixing; no performative agreement.
4. `test-driven-development`: a failing test before each fix.
5. `security-best-practices`: required for every role on this story.
6. `mutation-testing-discipline`: these are security guards; prove each new or tightened guard's test fails when the guard is loosened.
7. `git-commit-rules`
8. `systematic-debugging` whenever something fails unexpectedly.

## Inputs

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`, branch `feat/86bcm901j-mcp-templates`. Reviewed head `7c2c35a51ee848a86d638f27720988846ae76184`, base `1ee7157` (= `origin/main`).
- **Approved plan:** `~/.hermes/plans/leorna/86bcm901j-mcp-templates.md` (read-only copy `~/.hermes/plans/leorna/evidence/86bcm901j/plan-approved.md`; never edit that copy), including `## Justin's answers (2026-10-28)`. ACs AC1–AC5 and their test names stay exactly as approved.
- **Review 1's evidence:** `~/.hermes/plans/leorna/evidence/86bcm901j/review1/` (probes in `probes/`, mutation runs in `mutations/`, gate logs). Read the cited files; reproduce each finding yourself before fixing.

## Review 1's findings (reviewer's words condensed; verify each)

The reviewer found the four new Go files byte-identical to the plan's code blocks, so these are gaps in the plan's design. Fixing them is authorized as corrections inside this story's approved scope (the card's secure-by-default ACs). **Fix the class each finding names, not only the reviewer's examples,** and port the reviewer's witnesses as tests, so the next review doesn't find one more witness of the same hole. Keep the shipped content passing and keep the approved behaviour for valid templates and configs.

- **R1-1 · Major · the policy skips itself when its own decode fails.** `checkTemplate` returns no failures when `templateServers` can't decode the body (`policy.go`: `templateServers` and `if !ok { return nil }` in `checkTemplate`). The decode is Go's case-insensitive struct decode, while the renderers read exact keys, and the Claude Code renderer only warns about an unknown key (a warning never fails outside rule V). So, in a template that declares only Claude Code, one unused case-variant key of the wrong type turns off rules S, P and V: `"ARGS":1` on the server, a top-level `"MCPSERVERS":1`, or `"URL":[]`. Evidence: `review1/probes/probe4-policy-skipped.txt` (control with unpinned `npx` + literal `GITHUB_TOKEN` FAILED four ways; the same body plus `"ARGS":1` PASSED, and Claude Code's `.mcp.json` still got the unpinned `npx` and the literal token; `http://` URL + literal `Bearer` + `"URL":[]` PASSED). Reviewer's suggested fix: fail closed (a template the policy can't read is a policy failure) and decode with the renderer's exact-key rules.
- **R1-2 · Major · rule L for Codex can be bypassed and is a denylist.** The Codex body goes into `config.toml` unchanged and is read by BurntSushi/toml into a struct, which matches keys case-insensitively in Go map order; real Codex reads exact keys. The body `approval_policy="never"` / `APPROVAL_POLICY="on-request"` / `sandbox_mode="danger-full-access"` / `SANDBOX_MODE="workspace-write"` passed the gate in 154 of 200 runs (`probes/probe2-codex-case-variant-rate.txt`), and real codex-cli 0.165.0 in a throwaway `CODEX_HOME` runs it as `danger-full-access` with approval `never` (`probes/codex-0.165-effective-settings.txt`). Keys the floor doesn't know also pass (`probes/probe1-bypasses.txt`): Codex `notify = [...]`, `[shell_environment_policy] ignore_default_excludes = true`, `[model_providers.x] base_url`, `[projects."/"] trust_level = "trusted"`; Claude Code `env.ANTHROPIC_BASE_URL` (their real-tool effect is predicted from docs, not run). A top-level `profile = "x"` passes the gate but Codex 0.165 refuses to load it, so it isn't a bypass. Why it matters: `gate.go`'s package comment, `policy.go` and the README promise "a config grants nothing a tool would not grant by default". Reviewer's suggested fix: reject case-variant duplicates of known keys, and make the Codex floor an allowlist of known keys and tables (fail closed), like rule P is for launchers. Consider the Claude Code floor the same way.
- **R1-3 · Major · a failure reason repeats a value (a token).** Rule P quotes the first non-flag `npx` argument (`runs npx package %q`) and the command (`runs %q`). With args `["-y","--api-key","<token>","api-mcp@1.0.0"]` the token appears in the JSON report, the CI log line (`WriteLog`) and the Markdown job summary (`WriteMarkdown`), while the secrets stage withholds it (`probe1`: token in JSON report, log text and Markdown summary all true). The same pattern: `permissions.allow pre-approves %q` repeats allow rules, and a Bash pattern can hold a credential. The plan and README say reasons never repeat a value, and AC1's no-repeat subtests only cover env, header and URL. Reviewer's suggested fix: name the server and the argument's position instead of the value; add no-repeat tests for rule P and allow rules. **Check every policy failure reason, not just these two.**
- **R1-4 · Minor · rule P lets npx flags written with `=` through:** `--registry=https://registry.example.invalid/` or `--package=evil-mcp` beside a pinned spec passes (`probe1`). A pinned version from another registry isn't the same package, and `--package` installs an unpinned one (predicted from npx behaviour, not run). Suggested fix: allow only `-y`/`--yes` (and `--`).
- **R1-5 · Minor · rule S doesn't look at args, the URL query, or key names outside its pattern:** `--api-key not-a-reference` in args, `?api_key=not-a-reference` in the URL, and an `env` key named `GITHUB_PAT` all pass the policy (`probe1`). A duplicate `"env"` key passes while the literal stays in the template body. gitleaks only catches token-shaped values, and the README doesn't mention these limits. Suggested fix: refuse credential-looking flags and query parameters, and document the limits that remain.
- **R1-6 · Minor · two guards have no test that fails when loosened:** of 24 mutants, M02 (widening `wholeRef` to "contains a `${VAR}` anywhere") and M23 (skipping configs that render with warnings) survived (`review1/mutations/mutations.txt`). Witnesses (`mutations/survivor-witnesses.txt`): `{"API_TOKEN":"not-a-reference${API_TOKEN}"}` with Codex not declared, and `{"permissions":{"allow":[…]},"vimMode":true}`; each fails on the candidate and passes under its mutant. The code is correct; add both witnesses as AC1/AC2 subtests.
- **R1-7 · Minor (reviewer unsure) · docs overstate `history.persistence = "none"`:** `codex-defaults/item.json` says "no prompt history is kept", and `example.md` implies a pasted secret won't stay in plain text. The setting only stops `history.jsonl`; Codex keeps full session transcripts as `~/.codex/sessions/rollout-*.jsonl`. Make the docs claim only what the setting does (check the Codex config reference; don't run a signed-in session).
- **R1-8 · Nit · test only:** `runTool` in `realtools_test.go` uses `exec.CommandContext` with buffered output and no `WaitDelay`; `codex` here is a node wrapper that starts a native child, so on a hang `Wait` can block until `go test`'s 10-minute limit. Set `WaitDelay`.

Related, from the builder's `found_else` (fix only if your R1-3 change makes it contradict the code): `internal/library/README.md`'s older gate paragraph says "Failure reasons quote the offending text", while policy reasons never repeat a value.

Review 1 agreed with all four builder rulings (make and Zig under `~/.local/leorna-tools` for local gates; the two dropped example clauses; in-sandbox screenshots).

## How to work

- For each finding: reproduce it on `7c2c35a` (a failing test that captures the class), fix, show the test green, and run a mutation that loosens the fix to show the test catches it. One commit per finding or per closely linked group, `fix(86bcm901j): …`.
- If a fix would need a product decision that isn't Justin's already (for example dropping a shipped setting, or changing an approved AC's wording), don't make it: record it as "My ruling, not yet confirmed" if it's safe and reversible, or stop with `status: stopped` and the options if it isn't. Under Justin's standing grant, prefer the scoped secure fix over accepting a weakness.
- Don't change `render/` (it must stay identical to the client), OpenAPI, migrations, `.github/`, the Makefile, the seed or `THIRD_PARTY_NOTICES.md`.

## Gates, environment and evidence

- Windows desktop (Ubuntu under WSL). Reuse the tools under `~/.local/leorna-tools` read-only (Go, CI-pinned golangci-lint and govulncheck, make, Zig as `CGO_ENABLED=1 CC="zig cc"`); never modify or delete them or other sessions' `~/.local/leorna-toolchain`.
- On your final head, run the plan's gates (Task 8): `make check` with the CI-pinned tools bound by absolute path, `bash ./scripts/test-module-add.sh`, gitleaks (branch range), the story-shippable check, `make library-check`, each AC test by name (AC5 with `LEORNA_TEST_CODEX_BIN` and `LEORNA_TEST_CLAUDE_BIN`, throwaway homes only, never the real `~/.codex` or `~/.claude`), and a base-vs-head comparison by test name.
- **Postgres:** Docker inside Ubuntu is still off. Review 1 ran the Postgres gates with the no-sudo PostgreSQL 18.6 recipe in the shared notes (`~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-control-plane-workflow.md`, "No-sudo gate recipe"; TCP only, `-c unix_socket_directories=''`). Do the same in your scratch with your own database `leorna_86bcm901j_fix1_test` on a free port, read results per test from a `go test -json` stream, then stop the server and delete its folder. Never touch another session's database or server.
- **Evidence:** `~/.hermes/plans/leorna/evidence/86bcm901j/`. Save new gate logs `gates-<sha7>-*.txt` with exit codes, re-take the five AC screenshots on your final head (the builder's in-sandbox Chrome route, recorded in `INVENTORY.md`), and add a "Fixer 1" section to `INVENTORY.md` with a disposition per finding (id, valid or not, fix commit, test, evidence). Don't write in `review1/`, `verifier/` or `auditor/`, and never touch `plan-approved.md`.
- **Scratch:** create `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-fixer1/` with `mkdir` (no `-p`) and keep everything there (throwaway homes, base copies, Postgres). The scratchpad is shared by every subagent in this session; never touch other folders in it. Remove your folder at the end (after `git worktree remove` for any copy you added).
- **Never touch** other stories' worktrees (`86bcm901a-agent-definitions`, `86bcm901w-create-pack`, maybe `86bcm901b`), branches, databases or evidence folders, and never switch the main checkout's branch. Commit with the repo's own identity (`Justin Issa <justin@leorna.com>`), no author override, no `Co-Authored-By` or AI line, no `CLAUDE.md`. End with a clean worktree (`git status --porcelain --untracked-files=all` empty).

## Rules

- **Other bugs or problems you find:** don't fold them in; list them in `found_else` (one line each, with evidence and severity).
- **Skill lessons:** if you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`
- If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the last commit and which findings remain.
- If you wait on a long command, wait in the foreground (a bounded poll), not by ending your turn.

## What to return

`{name: "86bcm901j-mcp-templates", status: ready-for-next-review|stopped, summary, reviewed_head: "7c2c35a", last_commit, dispositions[{id, valid, action, commit, test, mutation, evidence}], rulings[], gates[{name, exit, log}], ac_tests[{ac, test, head_log, screenshot}], postgres: ran|not_run, owed[], found_else[], skill_lessons[]}`. Plain words.
