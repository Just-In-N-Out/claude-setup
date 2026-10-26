# VERIFIER brief (round 2): 86bcm901u-quality-gate-v3 (Leorna, control plane)

You are the **VERIFIER (read only)** for the Leorna story **Content quality gate (CI)**, ClickUp card `86bcm901u`, feature `86bcm901u-quality-gate-v3`. Model: Opus 5.5, effort xhigh. You are a fresh agent that never saw the build, the reviews or the fixes being made. **Change no source.** Write only into `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/verifier/` (empty for you) and your own scratch. Your verdict decides whether the story goes to the blind AC auditor or back to a fixer.

## 0. Disk first

The Mac's disk filled up earlier today (about 9.6 GB free now). Run `df -h /` before each heavy gate; under 3 GB free, stop with `verdict: blocked`, reason `disk`, and delete nothing that isn't yours. Keep scratch small and delete your own when done. Another session may be running Go builds at the same time: never run `go clean -cache`. If a gate fails with "open …/go-build/…: no such file or directory" across unrelated packages, that's a host problem: keep the log under a suffixed name and rerun the unchanged gate.

## 1. Skills to load first (say so in your first steps)

1. `leorna`: the **VERIFIER** role.
2. `engineering-best-practices`
3. `security-best-practices` (its "Scanning untrusted trees with gitleaks" section lists the known gitleaks gaps)
4. `api-contract-drift-guard` and `backend-data-migrations`: you are their Agent Defect Loop's **independent verifier**: run each skill's Required Validation Gates yourself (contracts check, empty contract diff; no migration, `TestMigrationRoundTrip` green).
5. `mutation-testing-discipline`
6. Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the VERIFIER part and the run recipe) and the report format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

A skill's "spawn a subagent" step is the main session's job; you can't start agents.

## 2. What you verify

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v3`, branch `feat/86bcm901u-quality-gate-v3`, head **`e488a8cdc3df1ffba3c2db270d9bc749efa83da8`** (committed, clean, no upstream). Run head checks from it, but never edit, commit or leave files in it.
- **Base:** `origin/main` = **`6e74ced843642439d1dac9f25673440fb0f285f5`** (`git -C <worktree> merge-base HEAD 6e74ced` must print it).
- **Approved plan (the contract):** `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md` ("Acceptance criteria" names each AC's test and command). Decisions since approval, under Justin's away grant: live plan `~/.hermes/plans/leorna/86bcm901u-quality-gate-v3.md` → "Away-grant picks".
- **ACs:** AC1–AC4 must each be proven; **AC5 is `(live)`**: `"accepted": false, "not_run": "live: needs a push and the gh token's workflow scope, both Justin's"`.
- **Findings to confirm closed on `e488a8c`** (reports: `…/review-1/`, `…/review-2/`, the previous verifier round `…/verifier-r1/`; fixer receipts in the evidence root: `fix-1-*`, `fix-2-*` incl. `fix-2-class-audit.md`, `fix-3-*` incl. `fix-3-notes-e488a8c.md`). Re-prove; don't trust.
  - **R1-F1 (P2):** gitleaks `dir` skipped text files starting with binary magic → canary header every scan copy must report on line 1, fail closed (exit 2) when missing.
  - **R1-F2 (P3):** `library.json` scanned; log header one line; name withheld when it holds a secret.
  - **R1-F3 / R2-F-R2-3 (P3):** AC4 compares the `on:` block, the quality job settings, the secret-scan step and the gate step exactly (` || true`, `shell:`, job `if:`, trigger edits all fail it).
  - **R1-F4 (P3):** email in old receipts `gates-a2bc032.*`, `gates-a3a2b23.*`: **deferred to the finisher**. Check only that no `e488a8c` receipt contains an email.
  - **R1-F5 (P3):** failure reasons quote item text: accepted, documented in the README.
  - **R2-F-R2-1 (P2):** gitleaks reads 100,000-byte chunks → any scan copy over 100,000 bytes (header included) stops the gate with exit 2.
  - **R2-F-R2-2 (P3):** vowel-free canary; header line ends ` #`.
  - **V1 (P3, verifier round 1):** AC4 now also pins the whole `library-check` Makefile block and rejects Makefile-wide weakenings (`.IGNORE`, `MAKEFLAGS` `-i`/`-n`, `SHELL`/`.SHELLFLAGS`, a second or reassigned `GO`, a second rule, `include`); Makefile itself unchanged. Note macOS `/usr/bin/make` is GNU 3.81 (ignores `.SHELLFLAGS`); CI has 4.3.
  - **V2 (P3, verifier round 1):** a valid MCP template can render a copy over the cap; it still fails closed, and the error for a rendered copy now names item, tool, file and size and says to shorten `body.md` (source copies keep the old message). README updated.
  - **Accepted limits (not defects):** gitleaks' default global allowlist drops *real* secrets containing "false" in every default-rules scan, CI's included (upstream follow-up; no config key removes it). Agents pass as "skipped" (Q1-A). Warnings pass and are listed (Q2-A).
- **CI exception (story-only, memory `no-ci-changes.md`):** `.github/` holds only `ci.yml`, 5 added / 0 deleted vs base; no existing step removed, reordered or weakened; gitleaks command unchanged.
- Look for **regressions the last fix caused** (`scan.go` and the AC4 test changed again), and any remaining way a secret or a render failure for a declared-supported tool lets the gate exit 0. Classify any new bypass as the same class (a copy gitleaks doesn't read whole, a dropped finding, a CI/Make weakening the AC4 test can't see) or new.

## 3. The work

1. **Gates on `e488a8c`** (the plan's Gates/T10): CI's golangci-lint 2.14.0 by absolute path (`GOLANGCI_LINT=<path> make check`; echo its `--version`), govulncheck v1.7.0, `make check` with Postgres on **your own** DB `leorna_86bcm901u_v3_verify2_test` (`docker exec leorna-test-pg createdb -U leorna leorna_86bcm901u_v3_verify2_test`; URL `postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_86bcm901u_v3_verify2_test?sslmode=disable`; confirm Postgres tests ran with `-v`), `bash ./scripts/test-module-add.sh`, `gitleaks git --log-opts=HEAD`, `make library-check`, the loop skills' validation. Logs with exit codes in `verifier/`. Drop only the DB you created.
2. **Findings:** re-prove each closure with your own probes on a gate you build from `e488a8c` (outside the worktree). Mutations only in your own detached copy (`git -C <worktree> worktree add --detach <your scratch>/head-e488a8c e488a8c`), restored and removed after.
3. **AC work, exactly as `ac-verification.md` says,** all receipts inside `verifier/`:
   - each AC's own test command on head: `( set -o pipefail; echo "HEAD=$(git -C <worktree> rev-parse HEAD)"; <command>; echo "EXIT=$?" ) > verifier/ac<n>-e488a8c.log 2>&1`, with `LEORNA_TEST_GITLEAKS_BIN` set so no subtest skips;
   - each on the base in a separate detached copy of `6e74ced`, with head's test files copied in (Go: the AC test's own file plus the test files of any new package it imports; `[setup failed]` counts as never run);
   - **one real screenshot per AC1–AC4, taken by you** (Justin's rule; they go to ClickUp): a Terminal capture of your own head run (the `leorna` terminal capture recipe: clean `env -i … TERM=xterm-256color … bash --norc --noprofile`, nothing secret on the launch line, count `EXIT=` markers after `clear`, close the window by id in a trap). Inspect each: no token, domain, URL bar, tenant ID or email;
   - write `verifier/ac.json` in the format at the top of `ac-check.sh` (`head` = full `e488a8c…` sha);
   - self-check while staying blind: `cp` your `ac.json`, logs and images to a scratch folder outside the evidence tree, run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh --repo <worktree> --base 6e74ced843642439d1dac9f25673440fb0f285f5 --plan ~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md verifier/ac.json <scratch>/ac.json`, then delete the copy. Expected last line: `READY FOR THE USER` (AC5 owed).
4. Finish with the worktree still clean, your detached copies removed, your DB dropped, your scratch deleted.

## 4. Boundaries

- Read only: no source edit, commit, push, PR, merge, remote CI, token change, ClickUp write.
- Don't read or write `auditor/`; don't edit `plan-approved.md`; don't write into the evidence root, `review-*/` or `verifier-r1/`.
- Don't touch: local `main`, the earlier 901u attempts, other stories' worktrees, DBs and scratch (`leorna_86bcm901u_v3_test` is the builder's), `deploy/local/`.
- Never print tokens; never write a server domain, URL or tenant ID.
- **Justin is away (away grant):** every finding needs your **recommended** fix.
- **Found something outside this story?** `found_else`, one line each with evidence and severity.
- **Skill lessons:** don't edit any skill or memory file; list reusable lessons in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section. An empty list is the normal answer.

## 5. Your report

Return JSON-shaped output: `{verdict: clean|findings|blocked, head, base, closure[{id, closed: true|false, evidence}], findings[{id, severity: P0|P1|P2|P3, class: same|new, claim, evidence, recommended_fix}], ac_status[{ac, accepted, test, screenshot, evidence}], ac_json, ac_check_self_check_last_line, gates[{name, log, exit_code}], defect_loop_skills[], disk_free_at_end, found_else[], skill_lessons[]}`. `clean` requires no P0–P2 finding and AC1–AC4 accepted (AC5 `not_run`). End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
