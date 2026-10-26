# REVIEWER 1 brief: 86bcm901u-quality-gate-v3 (Leorna, control plane)

You are **REVIEWER 1 (review only)** for the Leorna story **Content quality gate (CI)**, ClickUp card `86bcm901u`, feature `86bcm901u-quality-gate-v3`. Model: Opus 5.5, effort xhigh. You are a fresh agent that never saw the build. **Report only: change nothing in the builder's worktree, and make no commit, push, PR, merge or ClickUp change.** Don't trust summaries: read the code, run the gates yourself, try mutations.

## 1. Skills to load first (say so in your first steps)

1. `leorna` (its review rules and gates; skip its Step 1 only where this brief already gives you the facts)
2. `engineering-best-practices`
3. `requesting-code-review` and `code-review-practice`. **Skip** their "spawn an independent reviewer subagent" and auto-fix steps: you are the fresh reviewer, and you can't start agents.
4. `security-best-practices` (the gate execs gitleaks, writes temp files, handles secret findings)
5. `mutation-testing-discipline` (the declared-tool and secret-scan guards)
6. `api-contract-drift-guard` and `backend-data-migrations`: both end with the Agent Defect Loop; you are its independent problem-finder. Confirm no contract or migration change.

## 2. What to review

- **Candidate:** branch `feat/86bcm901u-quality-gate-v3`, head **`a2bc032bb9253df40209b2bac188e812a811bb81`**, in the builder's worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v3` (read it, never edit it).
- **Base:** `origin/main` = **`6e74ced843642439d1dac9f25673440fb0f285f5`** (GitHub main, unchanged at 08:40 EDT). Review `git diff 6e74ced...a2bc032` (6 commits, 52 files, +3869/−5).
- **Approved plan** (read-only copy, the contract you review against): `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md`. Justin approved every ⭐ answer: Q1-A agent items pass as "skipped" with the reason; Q2-A warnings pass and are listed, while errors, empty output and unparseable files fail; Q3-A the client's transformers are copied into `internal/library/render`, pinned byte-for-byte to the client's goldens (client `ea2b8ab`, PR #20 `1f259b0`) with a `SOURCE.md` hash list; Q4-A BurntSushi/toml v1.6.0 parses Codex's config.toml; Q5-A prompt rendering ported now behind a local `kindPrompt`.
- **ACs:** AC1–AC3 from the card, AC4 (CI runs the gate with no existing step dropped), AC5 (live: hosted CI, owed to Justin; mark it `accepted: false, not_run: "live: needs push + workflow scope"`). Each AC's test and command are in the plan's "Acceptance criteria" section.
- **The builder's rulings, which you confirm or reject with evidence:**
  1. The plan's real-gitleaks env test can't detect M11 (gitleaks 8.30.1 gives `--config` precedence over `GITLEAKS_CONFIG*`). The builder kept it and added `TestGitleaksPassesNoGitleaksSettingsToTheScanner` (a recording fake scanner checks env scrub, flags and the default-rules config). It says this kills M11, M11b, M19 and M20.
  2. PR #20's prompt code lives in `prompt.go` with a header naming client `1f259b0`. `claudecode.go`, `codex.go` and `cursor.go` are `ea2b8ab` copies plus only PR #20's switch and warning lines, made by a mechanical rename script.
  3. errcheck fixes to the plan's code: `defer func() { _ = os.RemoveAll(x) }()` and `_, _ = fmt.Fprintf(stderr, …)`.
  4. Two README sentences were tightened to be true as written.
  5. One equivalent mutant (the `.json` branch of `checkFormats`) was left unrun as unreachable.
  6. T7 (swap to `pack.KindPrompt`) skipped because PR #85 is still open.
- **CI exception (story-only, Justin 2026-10-22, memory `no-ci-changes.md`):** this story may change `.github/workflows/ci.yml` as plan T6 says (one added step plus one env block). Check that no existing step was removed, reordered or weakened, and the gitleaks command is unchanged. Any other `.github/` change is a finding.
- **Builder's evidence** (you may read it, not trust it): `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/` (`INVENTORY.md`, `gates-a2bc032.*`, `mutations-a2bc032.txt`, `ac<n>-*-a2bc032.*`, screenshots). Check that every AC1–AC4 screenshot exists, is a real capture of the run it claims, and shows no token, server domain, URL bar, tenant ID or email.

Look especially at: correctness of the gate's exit codes and failure lines (AC2's `FAIL <kind>/<name>@<version> <tool>: render: <reason>`); whether a declared-supported tool can fail silently (empty output, dropped file, swallowed error); whether the secret scan can be bypassed (allowlists, inline allow comments, env, path handling, temp-file cleanup, symlinks); whether the render copy really matches the client and stays pinned; test strength (would each AC test fail if the behaviour broke?); and the plan's own risks.

## 3. How to run things

- Work in **your own detached review worktree**: `git -C ~/Leorna/leorna-control-plane worktree add --detach ~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-v3-review-1 a2bc032`. Do mutations only there, restore each one, and remove that worktree when you're done (`git worktree remove --force` on your own path only).
- Scratch: `~/.hermes/cache/scratch/86bcm901u-v3-review-1/`. Evidence you cite: `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/review-1/`. Never write into the evidence folder's root, `verifier/` or `auditor/`, and never edit `plan-approved.md`.
- Gates on `a2bc032`, as the plan's Gates/T10 say: CI's golangci-lint 2.14.0 bound by absolute path (`GOLANGCI_LINT=<path> make check`; echo its `--version`), govulncheck v1.7.0, `make check` with Postgres on **your own** DB `leorna_86bcm901u_v3_review1_test` (`docker exec leorna-test-pg createdb -U leorna leorna_86bcm901u_v3_review1_test`; URL `postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_86bcm901u_v3_review1_test?sslmode=disable`), `bash ./scripts/test-module-add.sh`, `gitleaks git --log-opts=HEAD`, `make library-check`, each AC's own test command. Save each log with its exit code. You may drop only the DB you created; never touch any other DB (`leorna_86bcm901u_v3_test` is the builder's).
- macOS tool notes are in `leorna` step 4 (GNU realpath, Bash with `mapfile`, PATH order).

## 4. Boundaries

- Don't touch: the builder's worktree (read only), local `main`, the earlier attempts (`feat/86bcm901u-content-quality-gate`, `feat/86bcm901u-quality-gate-v2`, their worktrees, plans, evidence and DBs), the `86bcm9016-*` and `86bcm901v-*` worktrees and DBs, `deploy/local/`.
- No push, PR, merge, remote CI, token change, ClickUp write. Never print tokens; never write a server domain, URL or tenant ID.
- **Justin is away (away grant):** every question or finding must carry your **recommended** fix or answer, so the main session can apply it without asking him. Where a finding is "fix it or accept it", say which you recommend and why.
- **Found something outside this story?** Don't fold it in: list it in `found_else` (one line each, with evidence and severity).
- **Skill lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer.

## 5. Your report

Return JSON-shaped output: `{verdict: clean|findings, reviewed_head, base, findings[{id, severity: P0|P1|P2|P3, introduced: story|base, claim, evidence, recommended_fix}], rulings_assessment[{ruling, verdict: confirmed|rejected, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{name, log, exit_code}], defect_loop_skills[], found_else[], skill_lessons[]}`. `clean` means no P0–P2 finding and AC1–AC4 accepted. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
