# VERIFIER brief (round 1): 86bcm901u-quality-gate-v3 (Leorna, control plane)

You are the **VERIFIER (read only)** for the Leorna story **Content quality gate (CI)**, ClickUp card `86bcm901u`, feature `86bcm901u-quality-gate-v3`. Model: Opus 5.5, effort xhigh. You are a fresh agent that never saw the build, the reviews or the fixes being made. **Change no source.** Write only into `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/verifier/` (and your own scratch). Your verdict decides whether the story goes to the blind AC auditor or back to a fixer.

## 1. Skills to load first (say so in your first steps)

1. `leorna`: the **VERIFIER** role.
2. `engineering-best-practices`
3. `security-best-practices` (the gate's secret scan; its "Scanning untrusted trees with gitleaks" section lists the known gitleaks gaps)
4. `api-contract-drift-guard` and `backend-data-migrations`: both end with "Mandatory Validation and Agent Defect Loop". You are that loop's **independent verifier**: run each skill's Required Validation Gates yourself (contracts check and an empty contract diff; no migration, `TestMigrationRoundTrip` unchanged and green).
5. `mutation-testing-discipline`, for spot-checking that the fixes' tests can fail.
6. Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the VERIFIER part and the run recipe) and the report format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

A skill's "spawn a subagent" step is the main session's job; you can't start agents.

## 2. What you verify

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v3`, branch `feat/86bcm901u-quality-gate-v3`, head **`429c2ad9094fa68838094d2d796d06f076444ef9`** (committed, clean, no upstream). Run head checks from it, but never edit, commit or leave files in it: it must still be clean when you finish.
- **Base:** `origin/main` = **`6e74ced843642439d1dac9f25673440fb0f285f5`** (`git -C <worktree> merge-base HEAD 6e74ced` must print it).
- **Approved plan (the contract):** `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md`. Its "Acceptance criteria" section names each AC's test and command. Justin approved every ⭐ answer (Q1-A to Q5-A, listed in the plan). Decisions since then, made under Justin's away grant, are logged in the live plan `~/.hermes/plans/leorna/86bcm901u-quality-gate-v3.md` → "Away-grant picks".
- **ACs:** AC1–AC4 must each be proven; **AC5 is `(live)`** (hosted CI, owed to Justin): `"accepted": false, "not_run": "live: needs a push and the gh token's workflow scope, both Justin's"`.
- **Findings to confirm closed on `429c2ad`** (full reports in `…/evidence/86bcm901u-quality-gate-v3/review-1/` and `review-2/`; fixer receipts in the evidence root: `fix-1-probe-bypass-9ce08f6.txt`, `mutations-fix-1-9ce08f6.txt`, `fix-2-class-audit.md`, `fix-2-probes-429c2ad.txt`, `fix-2-tdd-429c2ad.txt`, `mutations-fix-2-429c2ad.txt`). Don't trust them; re-prove.
  - **R1-F1 (P2):** gitleaks `dir` skipped text files starting with binary magic (`%PDF-`, `{\rtf`, `%!PS`), so a secret passed. Fixed by a canary header line every scan copy must report on line 1, failing closed (exit 2) when missing.
  - **R1-F2 (P3):** `library.json` wasn't secret-scanned and its name printed raw in the log (token echo, `::error` injection). Fixed: scanned, header through `oneLine()`, name withheld when it holds a secret.
  - **R1-F3 (P3):** AC4 test missed `if: false` / `continue-on-error: true`.
  - **R1-F4 (P3):** Justin's email in the old gate receipts `gates-a2bc032.*`, `gates-a3a2b23.*`: **deferred to the finisher** (redact before upload). Check only that no `429c2ad` receipt contains an email.
  - **R1-F5 (P3):** failure reasons quote item text: **accepted and documented** in the README.
  - **R2-F-R2-1 (P2):** gitleaks reads 100,000-byte chunks (+25,000 peek), so a token across the cut in a padded `item.json`/`library.json` passed and a library-name token printed raw. Fixed: any scan copy over 100,000 bytes (header included) stops the gate with exit 2.
  - **R2-F-R2-2 (P3):** the random canary could contain "false" (dropped by gitleaks' default global allowlist `(?i)^true|false|null$`) or bind with item text into a false generic-api-key finding. Fixed: vowel-free canary, header line ends ` #`.
  - **R2-F-R2-3 (P3):** AC4 missed ` || true`, `shell:` overrides, job-level `if:`, trigger edits. Fixed test-only: exact block comparison; `ci.yml` unchanged.
  - **Accepted limits (not defects):** gitleaks' global allowlist also drops *real* secrets containing "false" in every default-rules scan, CI's included (upstream follow-up, no config key can remove it). Agents pass as "skipped" (Q1-A). Warnings pass and are listed (Q2-A).
- **CI exception (story-only, Justin 2026-10-22, memory `no-ci-changes.md`):** `.github/` must contain only `ci.yml`, with plan T6's one added step plus one env block (5 added / 0 deleted vs base), no existing step removed, reordered or weakened, gitleaks command unchanged.
- Also look for **regressions the fixes caused** (the scan path changed twice), and for any way a secret or a render failure for a declared-supported tool can still let the gate exit 0. If you find a new bypass, say whether it is the same class the fixes target (a copy gitleaks doesn't read whole, or a dropped finding) or a new one.

## 3. The work

1. **Gates on `429c2ad`** (the plan's Gates/T10): CI's golangci-lint 2.14.0 bound by absolute path (`GOLANGCI_LINT=<path> make check`; echo its `--version` from the same PATH), govulncheck v1.7.0, `make check` with Postgres on **your own** DB `leorna_86bcm901u_v3_verify1_test` (`docker exec leorna-test-pg createdb -U leorna leorna_86bcm901u_v3_verify1_test`; URL `postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_86bcm901u_v3_verify1_test?sslmode=disable`; confirm Postgres tests ran with `-v`), `bash ./scripts/test-module-add.sh`, `gitleaks git --log-opts=HEAD`, `make library-check`, the loop skills' validation. Logs with exit codes in `verifier/`. Drop only the DB you created.
2. **Findings:** re-prove each closure above with your own probes on a gate you build from `429c2ad` (outside the worktree). Any mutation goes in your own detached copy (`git -C <worktree> worktree add --detach <your scratch>/head-429c2ad 429c2ad`), restored and removed after.
3. **AC work, exactly as `ac-verification.md` says,** all receipts inside `verifier/`:
   - each AC's own test command (from the plan) on head: `( set -o pipefail; echo "HEAD=$(git -C <worktree> rev-parse HEAD)"; <command>; echo "EXIT=$?" ) > verifier/ac<n>-429c2ad.log 2>&1`, with `LEORNA_TEST_GITLEAKS_BIN` set so no subtest skips;
   - each on the base in a separate detached copy of `6e74ced`, with head's test files copied in. **Go: copy every `_test.go` in `git diff --name-only 6e74ced 429c2ad`**, not only the AC's own, or Go prints `[setup failed]` (counts as never run) instead of `[build failed]`;
   - **one real screenshot per AC1–AC4, taken by you** (Justin's rule; they go to ClickUp): a Terminal capture of your own head run showing the command, output and exit code (the `leorna` terminal capture recipe: clean `env -i … bash --norc --noprofile`, nothing secret on the launch line, close the window by id after). Look at each: no token, domain, URL bar, tenant ID or email;
   - write `verifier/ac.json` in the format at the top of `ac-check.sh` (`head` = full `429c2ad…` sha);
   - self-check it while staying blind: `cp` your `ac.json`, logs and images to a scratch folder outside the evidence tree, run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh --repo <worktree> --base 6e74ced843642439d1dac9f25673440fb0f285f5 --plan ~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md verifier/ac.json <scratch>/ac.json`, then delete the copy. Its last line should be `READY FOR THE USER` (AC5 owed).
4. Finish with the worktree still clean, your detached copies removed, your DB dropped.

## 4. Boundaries

- Read only: no source edit, commit, push, PR, merge, remote CI, token change, ClickUp write.
- Don't read or write `auditor/` (the blind auditor's folder) or edit `plan-approved.md`. Don't write into the evidence root or `review-*/`.
- Don't touch: local `main`, the earlier 901u attempts (branches, worktrees, plans, evidence, DBs), other stories' worktrees and DBs (`leorna_86bcm901u_v3_test` is the builder's), `deploy/local/`.
- Never print tokens; never write a server domain, URL or tenant ID.
- **Justin is away (away grant):** every finding needs your **recommended** fix.
- **Found something outside this story?** `found_else`, one line each with evidence and severity.
- **Skill lessons:** don't edit any skill or memory file; list reusable lessons in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section. An empty list is the normal answer.

## 5. Your report

Return JSON-shaped output: `{verdict: clean|findings, head, base, closure[{id, closed: true|false, evidence}], findings[{id, severity: P0|P1|P2|P3, class: same|new, claim, evidence, recommended_fix}], ac_status[{ac, accepted, test, screenshot, evidence}], ac_json, ac_check_self_check_last_line, gates[{name, log, exit_code}], defect_loop_skills[], found_else[], skill_lessons[]}`. `clean` requires no P0–P2 finding and AC1–AC4 accepted (AC5 `not_run`). End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
