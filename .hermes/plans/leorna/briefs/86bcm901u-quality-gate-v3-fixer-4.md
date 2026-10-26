# FIXER 4 brief: 86bcm901u-quality-gate-v3 (Leorna, control plane)

You are **FIXER 4** for the Leorna story **Content quality gate (CI)**, ClickUp card `86bcm901u`, feature `86bcm901u-quality-gate-v3`. Model: Opus 5.5, effort xhigh. You are a fresh agent. Fix verifier 2's three P3 findings (all **test only**, plus one README sentence), test first, commit, and stop at **`ready-for-verify`**. No hand-over, push or PR. Keep it small.

## 0. Disk and shared machine

About 8.5 GB free. Run `df -h /` before heavy gates; under 3 GB, stop with `status: stopped`, `stop_reason: disk`. Never run `go clean -cache` (other sessions build at the same time). If a gate fails with "open …/go-build/…: no such file or directory" across unrelated packages, that's a host problem: keep the log under a suffixed name and rerun the unchanged gate. Delete your own scratch when done.

## 1. Skills to load first (say so in your first steps)

1. `leorna` (fixer rules and gates; skip its Step 1 only where this brief gives you the facts)
2. `engineering-best-practices`
3. `receiving-code-review`: verify each finding before fixing it; push back with evidence on any you find wrong.
4. `test-driven-development`
5. `mutation-testing-discipline`
6. `git-commit-rules`: before your first commit.

## 2. Where things are

- Worktree: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v3`, branch `feat/86bcm901u-quality-gate-v3`, head **`e488a8cdc3df1ffba3c2db270d9bc749efa83da8`**, base `origin/main` = `6e74ced843642439d1dac9f25673440fb0f285f5`. No upstream; keep it that way.
- Approved plan (read only): `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md`. Live plan with every decision: `~/.hermes/plans/leorna/86bcm901u-quality-gate-v3.md` ("Away-grant picks").
- Verifier 2's receipts and reproduction scripts (read only): `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/verifier-r2/` (`source-mutations-v2-e488a8c.log`, `source-mutations-e488a8c.log`, `ac4-mutations-e488a8c.log` N1–N4, `scripts/overlay_mutations_v2.py` and the other scripts).

## 3. The findings and the decision on each (Justin is away; these are verifier 2's recommendations, applied under his away grant)

**V3 (P3, new: an AC clause its test doesn't pin) — FIX, test only.** AC3's "one column per tool, plus secrets" is pinned by no test; `TestAC3PassingRunWritesPerItemCompatibilityReport` checks only a ``| `key` | `` row prefix, the append and the JSON. The code is correct today (header `Item | Claude Code | Codex | Cursor | Secrets`, 5 cells per row). Survivors: AC3-secrets-col-v2 (header and cells dropped), AC3-tool-col-v2 (Cursor cell dropped), AC3-secrets-col (header only dropped).
Recommended fix: in the AC3 test, assert the summary contains the exact header and separator rows, and that each item row splits into exactly 5 cells (split on ` | ` not preceded by `\`), with the last cell `clean` for the real library. Show all three survivors are then killed (reuse `verifier-r2/scripts/overlay_mutations_v2.py` or your own `go test -overlay` mutants).

**V4 (P3, same class as V1) — FIX, test only.** `export GOFLAGS = -n`, `export GOFLAGS = -exec=true`, or the target-specific `%-check: export GOFLAGS = -n` in the Makefile makes `make library-check` exit 0 on a failing library while AC4 passes (N1–N3). Recommended fix: in `cmd/library-gate/ci_test.go`, add `GOFLAGS` and `GOENV` to `makeSetting`'s name alternation (`(?:GO|GOFLAGS|GOENV|SHELL|\.SHELLFLAGS|MAKEFLAGS)`), keep `GOLANGCI_LINT`/`GOVULNCHECK` lines accepted as controls, kill N1–N3, update the function comment. No Makefile or ci.yml change.

**V5 (P3, same class) — SCOPED FIX, test only + one sentence.** An earlier quality step can append `GOFLAGS=-n` to `$GITHUB_ENV` (e.g. `run: make fmt && echo "GOFLAGS=-n" >> "$GITHUB_ENV"`), neutering the gate step; AC4 passes (N4). Today no step before the gate writes `GITHUB_ENV` or `GITHUB_PATH`. Recommended fix: AC4 fails if any quality step **before** the gate step mentions `GITHUB_ENV` or `GITHUB_PATH`; kill N4.
**Class boundary (verifier 2's recommendation, now the story's decision):** the "CI or Make weakening AC4 can't see" class is open-ended, so state its boundary once, in the AC4 test's comment and one README sentence: AC4 pins the workflow's triggers, quality job settings, secret-scan and gate steps, the step list, the Makefile's `library-check` block and Makefile-wide settings (incl. `GOFLAGS`/`GOENV`), and earlier steps writing `GITHUB_ENV`/`GITHUB_PATH`; sabotage inside the script or command text of another step remains code-review territory. Don't go beyond this boundary.

## 4. After the fixes

- Gates on your new head as the plan's Gates/T10 say (CI's golangci-lint 2.14.0 by absolute path, govulncheck v1.7.0, `make check` with Postgres on the builder's DB `leorna_86bcm901u_v3_test` (reuse it; never drop it or touch any other DB), `bash ./scripts/test-module-add.sh`, `gitleaks git --log-opts=HEAD`, `make library-check`, every AC command). Save `gates-<sha7>.txt` + `.json` with exit codes; no email in them.
- Mutations: the three V3 survivors, N1–N4, plus re-run fixer 3's Makefile set (A10–A23, K1–K3) to show nothing regressed. Save `mutations-fix-4-<sha7>.txt`; restored tree clean and green.
- **Screenshots (Justin's one-per-AC rule):** retake **all four** AC1–AC4 captures on your final head as real Terminal captures (the `leorna` recipe: clean `env -i … TERM=xterm-256color … bash --norc --noprofile`, nothing secret on the launch line, count `EXIT=` markers after `clear`, close the window by id in a trap). Inspect each image. Update `INVENTORY.md`, marking older captures superseded.
- Evidence folder: `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/` (root only; never `verifier/`, `verifier-r*/`, `auditor/`, `review-*/`, never `plan-approved.md`).
- Commits `test(86bcm901u): …` / `docs(86bcm901u): …`; author from git config only (`Justin Issa <justin@leorna.com>`); no `Co-Authored-By` or AI attribution lines. End with the worktree committed and clean.

## 5. Boundaries

- `ci.yml`, the Makefile and all non-test Go source stay unchanged (README sentence only).
- No push, PR, merge, remote CI, token change, ClickUp write. Never print tokens; never write a server domain, URL or tenant ID.
- Don't touch: local `main`, the earlier 901u attempts, other stories' worktrees, DBs and scratch, `deploy/local/`.
- **Justin is away (away grant):** on a real trade-off, pick your recommended option and record it as "My ruling (away grant), not yet confirmed". Stop with `status: stopped` only if every option breaks a boundary above or changes the approved ACs; then list options with your recommended one marked.
- **Found something else?** `found_else`; don't fold it in.
- **Skill lessons:** don't edit any skill or memory file; list reusable lessons in `skill_lessons[{skill, lesson, evidence}]`. An empty list is the normal answer.

## 6. Your report

Return JSON-shaped output: `{name, status: ready-for-verify|stopped, summary, reviewed_head: "e488a8c", last_commit, commits[], dispositions[{id, action: fixed|pushed-back, test, evidence}], rulings[], gates[{name, log, exit_code}], mutations, ac_evidence[{ac, test, log, screenshot}], disk_free_at_end, stop_reason, found_else[], skill_lessons[]}` (`status` and `summary` required). End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
