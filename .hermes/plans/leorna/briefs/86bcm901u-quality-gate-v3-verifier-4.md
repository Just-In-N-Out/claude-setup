# VERIFIER brief (round 4, with a focused review of the integration delta): 86bcm901u-quality-gate-v3 (Leorna, control plane)

You are the **VERIFIER (read only)** for the Leorna story **Content quality gate (CI)**, ClickUp card `86bcm901u`, feature `86bcm901u-quality-gate-v3`. Model: Opus 5.5, effort xhigh. You are a fresh agent that never saw the build, the reviews or the fixes being made. **Change no source.** Write only into `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/verifier/` (empty for you) and your own scratch. Your verdict decides whether the story goes to the blind AC auditor or back to a fixer.

This round has two jobs: (A) a **focused fresh review** of the integration delta (new behaviour no reviewer has seen), and (B) the usual **verification and AC work** on the new head and base.

## 0. Disk and shared machine

About 8 GB free; other sessions write too. Run `df -h /` before heavy gates; under 3 GB, stop with `verdict: blocked`, reason `disk`, deleting nothing that isn't yours. Never run `go clean -cache`. A gate failing with "open …/go-build/…: no such file or directory" across unrelated packages is a host problem: keep the log under a suffixed name and rerun the unchanged gate. `refs/remotes/origin/main` is shared by every worktree and another session's fetch can move it: compare against GitHub's main (`gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`) and check `git merge-base --is-ancestor <that sha> HEAD` at the start and before your final AC runs; if GitHub main moved past this base, say so in the report (don't rebase). Delete your own scratch and any container you start.

## 1. Skills to load first (say so in your first steps)

1. `leorna`: the **VERIFIER** role.
2. `engineering-best-practices`
3. `requesting-code-review` and `code-review-practice` for job (A). **Skip** their "spawn an independent reviewer" and auto-fix steps.
4. `security-best-practices` (its "Scanning untrusted trees with gitleaks" section)
5. `api-contract-drift-guard` and `backend-data-migrations`: you are their Agent Defect Loop's **independent verifier**: run each skill's Required Validation Gates yourself (contracts check, empty contract diff vs base; no story migration, `TestMigrationRoundTrip` green).
6. `mutation-testing-discipline`
7. Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the VERIFIER part and the run recipe) and the report format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

A skill's "spawn a subagent" step is the main session's job; you can't start agents.

## 2. What you verify

- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v3`, branch `feat/86bcm901u-quality-gate-v3`, head **`f7dff509de5053d647084b2f6171262b91f005c9`** (committed, clean, no upstream). Run head checks from it, but never edit, commit or leave files in it.
- **Base:** GitHub `main` = **`6275a4e6ae4700ebd23d494bbe0990d22b879760`** (`git -C <worktree> merge-base HEAD 6275a4e` must print it). It contains two sibling stories merged today: **PR #85** (86bcm9016 prompt kind: `prompt/pr-description` item, `pack.KindPrompt`, migration 21, contracts) and **PR #89** (86bcm945u upstream sync: `internal/library/content/upstreams/<name>/{upstream.json,LICENSE}`, an imported skill).
- **Approved plan (the contract):** `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md` ("Acceptance criteria" names each AC's test and command; its "on base `6e74ced`" notes predate the rebase: use `6275a4e`). Decisions since approval, under Justin's away grant: live plan `~/.hermes/plans/leorna/86bcm901u-quality-gate-v3.md` → "Away-grant picks" (read it: it explains every round, the AC4 boundary and the convergence rule).
- **ACs:** AC1–AC4 must each be proven; **AC5 is `(live)`**: `"accepted": false, "not_run": "live: needs a push and the gh token's workflow scope, both Justin's"`.

### (A) Focused fresh review of the integration delta

Fixer 6's report and receipts: evidence root `fix-6-*`, `gates-f7dff50.*`, `mutations-fix-6-f7dff50.txt`, `client-repin-17f7c1b.txt`, `base-ac-runs-6275a4e.txt`, `INVENTORY.md` (Fixer 6 section). The three commits on top of the replayed story: `ed009c6` (T7: `kindPrompt` → `pack.KindPrompt`), `c46116b` (render port re-pinned to client main `17f7c1b`), `f7dff50` (**the gate accepts `content/upstreams/` and secret-scans `upstream.json` and `LICENSE`**). Also check the rebase itself: the replayed story commits must be the same change as before (compare `git range-diff 6e74ced..backup/86bcm901u-v3-pre-rebase 6275a4e..HEAD`; expected differences: the README conflict resolution and the three new commits).
Review for: does accepting `upstreams/` open any way for content to ship unvalidated or unscanned (other files or folders under `upstreams/`, symlinks, nested dirs, a non-upstream name, huge LICENSE files vs the 100,000-byte cap, how findings map back and whether the library name or an upstream's text leaks into logs)? Is the layout check still strict everywhere else? Does `library.Parse` on main read anything under `upstreams/` the gate now ignores? Is the T7 swap behaviour-neutral? Is the re-pin honest (byte-identical copies, SOURCE.md hashes)? Report each issue as a finding with severity and a recommended fix.

### (B) Findings to confirm closed on `f7dff50`

Re-prove, don't trust (reports in `review-1/`, `review-2/`, `verifier-r1/`, `verifier-r2/`, `verifier-r3/`; fixer receipts `fix-1-*` … `fix-6-*` in the evidence root):
- **R1-F1 (P2):** gitleaks `dir` skipped text files starting with binary magic → canary header every scan copy must report on line 1; missing canary fails closed (exit 2).
- **R1-F2 (P3):** `library.json` scanned; log header one line; name withheld when it holds a secret.
- **R1-F3, F-R2-3, V1, V4, V5, V6, V7 (P3, the CI/Make-weakening class):** AC4 pins the `on:` block, quality job settings, secret-scan and gate steps, counts every list item as a step (`- name:` first), rejects earlier steps writing `GITHUB_ENV`/`GITHUB_PATH`, and asks make itself (exact `make -n -s library-check` output, a differential stand-in-recipe probe vs an empty makefile, no GNUmakefile/makefile/include, `make -p -n` without `.IGNORE`/GOFLAGS/GOENV). Fixer 5 and 6 checked it on GNU Make 3.81 (Mac) and 4.3 (CI's ubuntu, in a container).
- **R1-F4 (P3):** email in old receipts `gates-a2bc032.*`, `gates-a3a2b23.*` and the harness `fix-*-gates.sh`: **deferred to the finisher**. Check only that no `f7dff50` receipt contains an email.
- **R1-F5 (P3):** failure reasons quote item text: accepted, documented.
- **F-R2-1 (P2):** any scan copy over 100,000 bytes (header included) stops the gate (exit 2). **V2 (P3):** for a rendered copy the error names item, tool, file and size.
- **F-R2-2 (P3):** vowel-free canary; header line ends ` #`.
- **V3 (P3):** the AC3 test pins the summary's header, separator, one row per item and 5 cells with each tool's result. **AC1 gap:** the AC1 test compares against the literal tool list `claude-code`, `codex`, `cursor`.
- **AC4's stated boundary and the convergence rule:** sabotage inside another step's script or command text is code-review territory, and further P3 test-sensitivity findings in the CI/Make-weakening class go under `found_else`, not findings. P0–P2 anywhere, or any AC not accepted, is still a finding.
- **Accepted limits (not defects):** gitleaks' default global allowlist drops *real* secrets containing "false" in every default-rules scan, CI's included (upstream follow-up). Agents pass as "skipped" (Q1-A). Warnings pass and are listed (Q2-A).
- **CI exception (story-only, memory `no-ci-changes.md`):** `.github/` holds only `ci.yml`, 5 added / 0 deleted vs `6275a4e`; no existing step removed, reordered or weakened.

## 3. The work

1. **Gates on `f7dff50`** (the plan's Gates/T10): CI's golangci-lint 2.14.0 by absolute path (`GOLANGCI_LINT=<path> make check`; echo its `--version`), govulncheck v1.7.0, `make check` with Postgres on **your own** DB `leorna_86bcm901u_v3_verify4_test` (`docker exec leorna-test-pg createdb -U leorna leorna_86bcm901u_v3_verify4_test`; URL `postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_86bcm901u_v3_verify4_test?sslmode=disable`; confirm Postgres tests ran with `-v`, incl. main's prompt-kind tests), `bash ./scripts/test-module-add.sh`, `gitleaks git --log-opts=HEAD`, `make library-check` (10 items incl. the prompt and the imported skill), the loop skills' validation. Logs with exit codes in `verifier/`. Drop only the DB you created.
2. **Review (A)** and **closures (B)** with your own probes on a gate built from `f7dff50` (outside the worktree). Mutations only in your own detached copy or with `go test -overlay`, restored after.
3. **AC work, exactly as `ac-verification.md` says,** all receipts inside `verifier/`:
   - each AC's own test command on head: `( set -o pipefail; echo "HEAD=$(git -C <worktree> rev-parse HEAD)"; <command>; echo "EXIT=$?" ) > verifier/ac<n>-f7dff50.log 2>&1`, with `LEORNA_TEST_GITLEAKS_BIN` set so no subtest skips;
   - each on the base `6275a4e` in a separate detached copy, with head's test files copied in (Go: the AC test's own file plus the test files of any new package it imports; `[setup failed]` counts as never run). Use bash arrays for file lists (zsh doesn't word-split);
   - **one real screenshot per AC1–AC4, taken by you** (Justin's rule; they go to ClickUp): a Terminal capture of your own head run (the `leorna` terminal capture recipe: clean `env -i … TERM=xterm-256color … bash --norc --noprofile`, wait up to 90 s for the first prompt, nothing secret on the launch line, count `EXIT=` markers after `clear`, close the window by id in a trap, pipe any `docker exec` step through `| cat` with pipefail). Inspect each: no token, domain, URL bar, tenant ID or email;
   - write `verifier/ac.json` in the format at the top of `ac-check.sh` (`head` = full `f7dff50…` sha);
   - self-check while staying blind: `cp` your `ac.json`, logs and images to a scratch folder outside the evidence tree, run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh --repo <worktree> --base 6275a4e6ae4700ebd23d494bbe0990d22b879760 --plan ~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md verifier/ac.json <scratch>/ac.json`, then delete the copy. Expected last line: `READY FOR THE USER` (AC5 owed).
4. Finish with the worktree still clean, your detached copies removed, your DB dropped, your scratch and containers deleted.

## 4. Boundaries

- Read only: no source edit, commit, push, PR, merge, remote CI, token change, ClickUp write. Don't touch the `backup/86bcm901u-v3-pre-rebase*` branches (read them only).
- Don't read or write `auditor/`; don't edit `plan-approved.md`; don't write into the evidence root, `review-*/` or `verifier-r*/`.
- Don't touch: local `main`, the earlier 901u attempts, other stories' worktrees, DBs and scratch (`leorna_86bcm901u_v3_test` is the builder's), `deploy/local/`.
- Never print tokens; never write a server domain, URL or tenant ID.
- **Justin is away (away grant):** every finding needs your **recommended** fix.
- **Found something outside this story?** `found_else`, one line each with evidence and severity.
- **Skill lessons:** don't edit any skill or memory file; list reusable lessons in `skill_lessons[{skill, lesson, evidence}]`. An empty list is the normal answer.

## 5. Your report

Return JSON-shaped output: `{verdict: clean|findings|blocked, head, base, github_main_at_end, review_findings[{id, severity: P0|P1|P2|P3, claim, evidence, recommended_fix}], closure[{id, closed: true|false, evidence}], findings[{id, severity, class: same|new, claim, evidence, recommended_fix}], ac_status[{ac, accepted, test, screenshot, evidence}], ac_json, ac_check_self_check_last_line, gates[{name, log, exit_code}], defect_loop_skills[], disk_free_at_end, found_else[], skill_lessons[]}`. `clean` requires no P0–P2 finding (review or verification) and AC1–AC4 accepted (AC5 `not_run`). End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
