# FIXER 1 brief: 86bcm901u-quality-gate-v3 (Leorna, control plane)

You are **FIXER 1** for the Leorna story **Content quality gate (CI)**, ClickUp card `86bcm901u`, feature `86bcm901u-quality-gate-v3`. Model: Opus 5.5, effort xhigh. You are a fresh agent. Fix reviewer 1's findings test first, commit, and stop at **`ready-for-next-review`** (a second fresh reviewer comes next). No hand-over, push or PR.

## 1. Skills to load first (say so in your first steps)

1. `leorna` (fixer/finisher rules and gates; skip its Step 1 only where this brief gives you the facts)
2. `engineering-best-practices`
3. `receiving-code-review`: verify each finding before fixing it; fix the valid ones test first; push back with evidence on any you find wrong.
4. `test-driven-development`: a failing test before each change.
5. `mutation-testing-discipline`: F1 and F3 change guards; prove each new test can fail.
6. `security-best-practices`: its "Scanning untrusted trees with gitleaks" section covers F1.
7. `git-commit-rules`: before your first commit.

## 2. Where things are

- Worktree: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v3`, branch `feat/86bcm901u-quality-gate-v3`, current head **`a2bc032bb9253df40209b2bac188e812a811bb81`**, base `origin/main` = `6e74ced843642439d1dac9f25673440fb0f285f5`. No upstream; keep it that way.
- Approved plan (read only): `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md`. Live plan with the decisions log: `~/.hermes/plans/leorna/86bcm901u-quality-gate-v3.md` (read its "Justin's answers" and "Away grant" sections).
- Reviewer 1's full report and probes: `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/review-1/` (`probe-bypass.txt`, `probe-gitmode.txt`, `probe-library-name-newline.log`, `probe-diagnostic-echo.log`, `mutations-review1.txt`). Its reusable probe script: `~/.hermes/cache/scratch/86bcm901u-v3-review-1/probe_bypass.sh` (works against any built gate binary).

## 3. The findings and the decision on each (Justin is away; these are the reviewer's recommendations, applied under his away grant)

**F1 (P2, story) — FIX.** The gate's secret scan can be bypassed: gitleaks 8.30.1 `dir` skips any file whose first bytes match a binary magic number (`%PDF-`, `{\rtf`, `%!PS`), even plain text. A token in such a file passes the gate with exit 0. Affected: `example.md` of any item kind (never rendered, only its source copy is scanned), an agent's `body.md` (renders no files), and a Cursor-only prompt body. Evidence: `review-1/probe-bypass.txt` cases B, D, E, F exit 0 with "library-gate: PASSED"; controls A and C exit 1. `review-1/probe-gitmode.txt`: same file, `gitleaks git` exit 1, `gitleaks dir` exit 0, `dir` with one header line exit 1.
Recommended fix: in `scan.go`'s `write` helper, prepend one fixed text line (e.g. `library-gate secret-scan copy\n`) to every file written into the scan folder; where findings are mapped back, subtract 1 from Line (min 1). Test first: `TestSecretBehindBinaryMagicStillFails` (real gitleaks via `gitleaksForTest`): in the sample library, a skill's `example.md` = `%PDF-1.4\nUse <fakeGitHubToken()> here.\n` and an agent body with the same text; expect `report.Passed == false` and secrets failures for both items, with `example.md`/`body.md` on line 2. Mutation: remove the prefix → the new test must fail. Also make the AC1 secret subtest assert the `body.md` line number, so the offset is pinned. Add one README sentence: "every scan copy starts with a header line, so gitleaks never skips a text file as binary". If you find a better fix that closes the whole class (any binary-magic prefix, not just these three), you may use it; prove it the same way.

**F2 (P3, story) — FIX.** `library.json` ships (go:embed) but is never secret-scanned, and its `name` (up to 200 runes, newlines allowed) is printed raw in the log header: a token in the name passes and is echoed; a newline injects arbitrary log lines, including a GitHub `::error` workflow command and a forged "library-gate: PASSED" line. Evidence: `review-1/probe-bypass.txt` case H; `review-1/probe-library-name-newline.log`. The Markdown summary is already escaped by `cell()`.
Recommended fix: (a) in `scanSecrets`, also copy `library.json` to `library/library.json` with origin item `""`; in `Run`, turn its findings into `Failure{Stage: StageSecrets, Reason: "library.json: secret rule ..."}` (`subject()` already prints "library"). (b) In `WriteLog`, pass `report.Library.Name`, `report.Library.Version` and `report.Scanner` through `oneLine()`. Tests first: `TestLibraryHeaderIsSecretScanned` (real gitleaks, token in the name, expect a library secrets failure) and `TestLogHeaderIsOneLine` (name `"Lib\n::error::x"`, expect no log line starting with `::`).

**F3 (P3, story) — FIX.** `TestAC4CIRunsLibraryGateWithoutDroppingGates` checks only the step's name, order and run line, so `if: false` or `continue-on-error: true` on "Check content library quality" still passes. Evidence: `review-1/mutations-review1.txt` R19, R20 SURVIVED. Recommended fix: in TestAC4, fail when any trimmed line of the gate step's block starts with `if:` or `continue-on-error:`; apply the same check to "Scan repository for secrets". Then R19 and R20 must be killed. **Don't change `ci.yml` itself** unless the fix truly needs it; it is correct as is.

**F4 (P3) — NOT YOURS.** The finisher redacts Justin's commit email in gate receipts before any upload. But don't make it worse: in the new gate logs you write, print the authors check as "authors: 1 identity, matches the Leorna identity" (no email).

**F5 (P3) — ACCEPT AND DOCUMENT.** Render and schema failure reasons quote item text into the CI log and job summary (TOML errors quote values; unknown keys are quoted). Accepted limit, no redaction logic now. Add one README sentence: "failure reasons quote the offending text; the repository secret scan runs before the gate".

All six builder rulings were confirmed by reviewer 1; don't revisit them.

## 4. After the fixes

- Re-run the gates on your new head, exactly as the plan's Gates/T10 say (CI's golangci-lint 2.14.0 by absolute path, govulncheck v1.7.0, `make check` with Postgres on the builder's DB `leorna_86bcm901u_v3_test` (yours to reuse; never drop it or touch any other DB), `bash ./scripts/test-module-add.sh`, `gitleaks git --log-opts=HEAD`, `make library-check`, every AC command). Save logs with `.json` exit-code receipts as `gates-<sha7>.txt` etc.
- Run reviewer 1's `probe_bypass.sh` against your built gate: B, D, E, F (and H) must now exit 1. Save the output as `fix-1-probe-bypass-<sha7>.txt`.
- Run your new mutations (F1 prefix removed, F2 scan/oneLine removed, R19, R20) and save `mutations-fix-1-<sha7>.txt`: each must be killed by its named test, and the restored tree must be clean and green.
- **Screenshots (Justin's one-per-AC rule):** the AC1 and AC4 tests change, so retake `ac1-…-<sha7>.png` and `ac4-…-<sha7>.png` on your final head as real Terminal captures (the `leorna` terminal capture recipe; never put a DB URL or token on the launch line). Retake AC2/AC3 too if their output changed. Look at every screenshot: no token, domain, URL bar, tenant ID or email. Update `INVENTORY.md`, marking older captures superseded.
- Evidence folder: `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/` (root only; never `verifier/`, `auditor/`, `review-*/`, never `plan-approved.md`).
- Commits `fix(86bcm901u): …` / `docs(86bcm901u): …`; author from git config only (`git log -1 --pretty=format:'%an <%ae>'` must be `Justin Issa <justin@leorna.com>`); no `Co-Authored-By` or AI attribution lines. End with the worktree committed and clean.

## 5. Boundaries

- Story-only CI exception (memory `no-ci-changes.md`): `ci.yml` may only carry the plan's one added step and env block; no existing step removed, reordered or weakened.
- No push, PR, merge, remote CI, token change, ClickUp write. Never print tokens; never write a server domain, URL or tenant ID.
- Don't touch: local `main`, the earlier 901u attempts (branches, worktrees, plans, evidence, DBs), the `86bcm9016-*` and `86bcm901v-*` worktrees and DBs, `deploy/local/`.
- **Justin is away (away grant):** on a real trade-off, pick your recommended option, apply it and record it as "My ruling (away grant), not yet confirmed" with the reason. Stop with `status: stopped` only if every option breaks a boundary above or changes the approved ACs; then list the options with your recommended one marked.
- **Found something else?** List it in `found_else`; don't fold it in.
- **Skill lessons:** if you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer.

## 6. Your report

Return JSON-shaped output: `{name, status: ready-for-next-review|stopped, summary, reviewed_head: "a2bc032", last_commit, commits[], dispositions[{id, action: fixed|accepted-documented|deferred-to-finisher|pushed-back, test, evidence}], rulings[], gates[{name, log, exit_code}], mutations, ac_evidence[{ac, test, log, screenshot}], stop_reason, found_else[], skill_lessons[]}` (`status` and `summary` required). End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
