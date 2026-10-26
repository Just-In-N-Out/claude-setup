# REVIEWER 2 brief: 86bcm901u-quality-gate-v3 (Leorna, control plane)

You are **REVIEWER 2 (review only)** for the Leorna story **Content quality gate (CI)**, ClickUp card `86bcm901u`, feature `86bcm901u-quality-gate-v3`. Model: Opus 5.5, effort xhigh. You are a fresh agent that never saw the build or the first fix. **Report only: change nothing in the builder's worktree; no commit, push, PR, merge or ClickUp change.** Don't trust summaries (including reviewer 1's and the fixer's): read the code, run the gates yourself, try mutations.

Your job is a **full review of the corrected candidate**: the whole story diff `6e74ced...9ce08f6`, with extra care on the fix delta `a2bc032..9ce08f6` and on whether reviewer 1's findings are really closed.

## 1. Skills to load first (say so in your first steps)

1. `leorna` (its review rules and gates; skip its Step 1 only where this brief already gives you the facts)
2. `engineering-best-practices`
3. `requesting-code-review` and `code-review-practice`. **Skip** their "spawn an independent reviewer subagent" and auto-fix steps: you are the fresh reviewer, and you can't start agents.
4. `security-best-practices` (its "Scanning untrusted trees with gitleaks" section is directly relevant)
5. `mutation-testing-discipline`
6. `api-contract-drift-guard` and `backend-data-migrations`: both end with the Agent Defect Loop; you are its second independent problem-finder. Confirm no contract or migration change.

## 2. What to review

- **Candidate:** branch `feat/86bcm901u-quality-gate-v3`, head **`9ce08f6ba3f8dab094177a2c4759a51b2b900197`**, worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v3` (read only).
- **Base:** `origin/main` = **`6e74ced843642439d1dac9f25673440fb0f285f5`** (GitHub main, unchanged at 09:30 EDT). 11 story commits: the builder's 6 (`d74c5da`…`a2bc032`) and fixer 1's 5 (`fd9f2d2`, `8d80e3a`, `9756f18`, `3c69d00`, `9ce08f6`).
- **Approved plan** (read-only copy, the contract): `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md`. Justin approved every ⭐ answer: Q1-A agent items pass as "skipped" with the reason; Q2-A warnings pass and are listed, while errors, empty output and unparseable files fail; Q3-A the client's transformers are copied into `internal/library/render`, pinned to the client's goldens (client `ea2b8ab`, PR #20 `1f259b0`) with a `SOURCE.md` hash list; Q4-A BurntSushi/toml v1.6.0 parses Codex's config.toml; Q5-A prompt rendering ported now behind a local `kindPrompt`. The live plan's "Away-grant picks" section (`~/.hermes/plans/leorna/86bcm901u-quality-gate-v3.md`) logs every decision since.
- **ACs:** AC1–AC3 (card), AC4 (CI runs the gate with no existing step dropped), AC5 (live: hosted CI, owed to Justin; mark it `accepted: false, not_run: "live: needs push + workflow scope"`). Tests and commands are in the plan's "Acceptance criteria" section.
- **Reviewer 1** (on `a2bc032`; report and probes in `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/review-1/`) found, and the main session decided:
  - **F1 (P2) fix:** gitleaks 8.30.1 `dir` skips text files whose first bytes look binary (`%PDF-`, `{\rtf`, `%!PS`), so a secret in such a file passed the gate.
  - **F2 (P3) fix:** `library.json` wasn't secret-scanned, and its name printed raw in the log header (token echo, log-line injection incl. `::error`).
  - **F3 (P3) fix:** the AC4 test didn't catch `if: false` / `continue-on-error: true` on the gate step.
  - **F4 (P3) → finisher:** Justin's commit email is in the builder's gate receipts; redact before any upload.
  - **F5 (P3) accepted and documented:** failure reasons quote item text; README says so.
  - All 6 builder rulings were confirmed by reviewer 1.
- **Fixer 1's rulings, which you confirm or reject with evidence:**
  1. **F1 design:** a plain header line doesn't close the class: gitleaks `dir` runs `h2non/filetype` on the first read (up to 100 KB) and skips any `application/*` type, and `ustar`@257, `DICM`@128, `CD001`@32769 sit past any short header (the main session reproduced the `ustar` case). So every scan copy starts with `library-gate scan copy <canary>\n`, the canary a token-shaped string built at run time that gitleaks must report (github-pat) on line 1 of every copy; a missing canary fails closed. Canary findings are dropped and other lines shifted back by 1. It lives in the gitleaks adapter, so the Scanner interface and fakes are unchanged. Look hard at: can an item's content suppress, fake or displace the canary report; can gitleaks report the canary but still skip the rest of the file (fragmenting, size limits, max-target-megabytes, decoding); is the canary's entropy always above the rule threshold; any race or reuse across copies; Windows/line-ending effects.
  2. A copy gitleaks didn't read is a **gate error** (exit 2, "secret scan: gitleaks did not read …"), not an item failure.
  3. When `library.json` holds a secret, the library name is **withheld** in log, summary and JSON.
  4. The AC4 check compares each line's YAML key, rejecting any `if`/`continue-on-error` key on "Check content library quality" and "Scan repository for secrets", even `continue-on-error: false`.
  5. Fixer's own regression (dropped `EvalSymlinks(root)`) fixed in `9ce08f6` with `TestGitleaksScansALinkedFolder`.
  6. The canary uses `math/rand/v2`, not `crypto/rand`.
  - Fixer's `found_else`: a **job-level** `if:` / `continue-on-error:` on the "Go quality gates" job isn't caught by AC4 (base ci.yml has none). Classify it: in scope for this story's AC4 or a follow-up, with your recommendation.
- **CI exception (story-only, Justin 2026-10-22, memory `no-ci-changes.md`):** `ci.yml` may carry only plan T6's one added step plus one env block. Check no existing step was removed, reordered or weakened, and the gitleaks command is unchanged. Any other `.github/` change is a finding.
- **Evidence** (read, don't trust): `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/` (`INVENTORY.md`, `gates-9ce08f6.*`, `mutations-fix-1-9ce08f6.txt`, `fix-1-probe-bypass-9ce08f6.txt`, `ac<n>-*-9ce08f6.*`). Check every AC1–AC4 screenshot on `9ce08f6` exists, is a real capture of the run it claims, and shows no token, server domain, URL bar, tenant ID or email. Reusable probe scripts: `~/.hermes/cache/scratch/86bcm901u-v3-fix-1/probe_bypass.sh`, `~/.hermes/cache/scratch/86bcm901u-v3-review-1/probe_bypass.sh`.

## 3. How to run things

- Work in **your own detached review worktree**: `git -C ~/Leorna/leorna-control-plane worktree add --detach ~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-v3-review-2 9ce08f6`. Mutate only there, restore each one, and remove that worktree when done (your own path only).
- Scratch: `~/.hermes/cache/scratch/86bcm901u-v3-review-2/`. Evidence you cite: `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/review-2/`. Never write into the evidence root, `review-1/`, `verifier/` or `auditor/`, and never edit `plan-approved.md`.
- Gates on `9ce08f6` as the plan's Gates/T10 say: CI's golangci-lint 2.14.0 by absolute path (`GOLANGCI_LINT=<path> make check`; echo its `--version`), govulncheck v1.7.0, `make check` with Postgres on **your own** DB `leorna_86bcm901u_v3_review2_test` (`docker exec leorna-test-pg createdb -U leorna leorna_86bcm901u_v3_review2_test`; URL `postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_86bcm901u_v3_review2_test?sslmode=disable`), `bash ./scripts/test-module-add.sh`, `gitleaks git --log-opts=HEAD`, `make library-check`, each AC's own test command. Save each log with its exit code. Drop only the DB you created; never touch any other (`leorna_86bcm901u_v3_test` is the builder's).
- macOS tool notes are in `leorna` step 4 (GNU realpath, Bash with `mapfile`, PATH order). Never put a DB URL or token on a Terminal launch line.

## 4. Boundaries

- Don't touch: the builder's worktree (read only), local `main`, the earlier attempts (`feat/86bcm901u-content-quality-gate`, `feat/86bcm901u-quality-gate-v2`, their worktrees, plans, evidence and DBs), the `86bcm9016-*` and `86bcm901v-*` worktrees and DBs, `deploy/local/`.
- No push, PR, merge, remote CI, token change, ClickUp write. Never print tokens; never write a server domain, URL or tenant ID.
- **Justin is away (away grant):** every finding must carry your **recommended** fix or answer; where it's "fix or accept", say which and why.
- **Found something outside this story?** List it in `found_else` (one line each, evidence, severity); don't fold it in.
- **Skill lessons:** if you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer.

## 5. Your report

Return JSON-shaped output: `{verdict: clean|findings, reviewed_head, base, review1_closure[{id, closed: true|false, evidence}], findings[{id, severity: P0|P1|P2|P3, introduced: story|fix-1|base, claim, evidence, recommended_fix}], rulings_assessment[{ruling, verdict: confirmed|rejected, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{name, log, exit_code}], defect_loop_skills[], found_else[], skill_lessons[]}`. `clean` means no P0–P2 finding and AC1–AC4 accepted. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
