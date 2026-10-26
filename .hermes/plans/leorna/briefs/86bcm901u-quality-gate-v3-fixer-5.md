# FIXER 5 brief: 86bcm901u-quality-gate-v3 (Leorna, control plane)

You are **FIXER 5** for the Leorna story **Content quality gate (CI)**, ClickUp card `86bcm901u`, feature `86bcm901u-quality-gate-v3`. Model: Opus 5.5, effort xhigh. You are a fresh agent. Make the **class fix** for verifier 3's two P3 findings plus one AC1 test gap, **test only**, test first, commit, and stop at **`ready-for-verify`**. No hand-over, push or PR.

## Why this round is different

Three verifier rounds in a row found one more way to weaken CI or the Makefile that the AC4 test's **text denylists** can't see (V1 → V4/V5 → V6/V7). Each fix patched examples. This round replaces text-matching with **structural checks** so the class is closed, per verifier 3's recommendation. After this round, further P3s in this class go to a follow-up list, not another loop, so make this the fix that holds.

## 0. Disk and shared machine

About 5.3 GB free and falling (other sessions use the disk). Run `df -h /` before each heavy gate; under 3 GB, stop with `status: stopped`, `stop_reason: disk`, deleting nothing that isn't yours. Never run `go clean -cache`. If a gate fails with "open …/go-build/…: no such file or directory" across unrelated packages, that's a host problem: keep the log under a suffixed name and rerun the unchanged gate. Delete your own scratch when done.

## 1. Skills to load first (say so in your first steps)

1. `leorna` (fixer rules and gates; skip its Step 1 only where this brief gives you the facts)
2. `engineering-best-practices`
3. `receiving-code-review`: verify each finding first; push back with evidence on any you find wrong.
4. `test-driven-development`
5. `mutation-testing-discipline` (its "test strengthened in place" note: old and new test on the same mutant via `go test -overlay`)
6. `git-commit-rules`: before your first commit.

## 2. Where things are

- Worktree: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v3`, branch `feat/86bcm901u-quality-gate-v3`, head **`385256e20b71ec4ff704e01365089bd9511bb341`**, base `origin/main` = `6e74ced843642439d1dac9f25673440fb0f285f5`. No upstream; keep it that way.
- Approved plan (read only): `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md`. Live plan ("Away-grant picks"): `~/.hermes/plans/leorna/86bcm901u-quality-gate-v3.md`.
- Verifier 3's receipts and reproduction scripts (read only): `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/verifier-r3/` (`probe-makefile-385256e.log` M1–M7 and K0, `probe-ci-steps-385256e.log` U1–U3 and C1, `probe-ac1-clauses*` A1, `probes/` scripts). Earlier mutation sets: `mutations-fix-3-e488a8c.txt`, `mutations-fix-4-385256e.txt` in the evidence root.

## 3. The findings and the decision on each (Justin is away; verifier 3's recommendations, applied under his away grant)

**V6 (P3, class: CI/Make weakening) — CLASS FIX, test only.** AC4's Makefile check reads lines against a denylist. Verifier 3 showed six forms that make `make library-check` exit 0 on a broken library while AC4 passes: `$(eval GO = true)`, `$(eval export GOFLAGS = -n)`, a tab-prefixed `GO := true` after a variable line (the check skips every tab line, `ci_test.go:232`), `G$(EMPTY)O = true`, a tab-prefixed `MAKEFLAGS += -i`, `$(eval .IGNORE:)`.
Recommended fix: **ask make instead of reading text.**
1. From the repo root, with `MAKEFLAGS`, `GOFLAGS` and `GOENV` unset in the child env, run `make -n -s library-check GITLEAKS=G LIBRARY_SUMMARY=S` and require exactly one output line: `go run ./cmd/library-gate -dir "internal/library/content" -gitleaks "G" -summary "S"` (adjust to the real recipe's exact form; derive it from the current Makefile, don't change the Makefile).
2. Run `make -f Makefile -f <tmp>/probe.mk probe`, where the probe recipe prints `$(origin GOFLAGS)`, `$(origin GOENV)`, `$(origin SHELL)`, `$(origin .SHELLFLAGS)`, `[$(MAKEFLAGS)]` and `$(GO)`; require `GOFLAGS`/`GOENV` undefined (or from the environment you cleared), `SHELL` default, no `i`/`k`/`n` in `MAKEFLAGS`, `GO=go`.
3. Check `make -p -n` output has no `.IGNORE:` target and no exported `GOFLAGS`/`GOENV`.
Keep the existing line checks as a second layer. The test must skip only if `make` isn't on PATH (CI has it; if you add such a skip, it must never trigger on the Mac or CI; prefer failing). Note macOS `/usr/bin/make` is GNU 3.81 and CI's ubuntu has 4.3: use only features both have, and say so in the test comment. M1–M7 must then fail the test; K0 and the earlier controls (K1–K5) still pass; fixer 3's A10–A23 and fixer 4's N1–N5 still fail it.

**V7 (P3, same class) — CLASS FIX, test only.** The step list counts only lines starting `      - name: ` (`ci_test.go:324`), so an unnamed step (`- uses: actions/github-script@v7` with `core.exportVariable("GOFLAGS","-n")`), a name-second step, or `-  name:` with two spaces is invisible; its text merges into the unpinned "Verify story delivery gate" block. Recommended fix: in `steps()`, treat every line that starts with six spaces and `-` as a new step, and fail unless it is exactly `      - name: <name>`. U1–U3 must then fail; C1 still fails as before. If a real YAML parser is already in the module graph (check `go.mod`/`go.sum`; **no new dependency**), you may use it instead; record the choice as a ruling.

**AC1 test gap (verifier 3's found_else, P3) — FIX, test only.** `TestAC1ValidatesRendersAndScansEveryItem` takes the tool list from the package's own `Tools` (`gate_test.go`: `len(Tools)`, `Tools[index]`), so dropping Cursor from `gate.Tools` still passes AC1 (other tests catch it). AC1 says "rendered for Claude Code, Codex and Cursor", so compare against the literal list `claude-code`, `codex`, `cursor`. Mutant: remove Cursor from `Tools` → AC1 fails.

## 4. After the fixes

- Gates on your new head as the plan's Gates/T10 say (CI's golangci-lint 2.14.0 by absolute path, govulncheck v1.7.0, `make check` with Postgres on the builder's DB `leorna_86bcm901u_v3_test` (reuse it; never drop it or touch any other DB), `bash ./scripts/test-module-add.sh`, `gitleaks git --log-opts=HEAD`, `make library-check`, every AC command). Save `gates-<sha7>.txt` + `.json` with exit codes; no email in them.
- Mutations: M1–M7, U1–U3, the AC1 Cursor mutant, plus the earlier CI/Make set (A10–A23, N1–N5, M15–M18-style GITHUB_ENV, K-controls) to show nothing regressed. Show each new one survives the `385256e` test (overlay) and is killed by yours. Save `mutations-fix-5-<sha7>.txt`; restored tree clean and green.
- **Screenshots (Justin's one-per-AC rule):** retake **all four** AC1–AC4 captures on your final head as real Terminal captures (the `leorna` recipe: clean `env -i … TERM=xterm-256color … bash --norc --noprofile`, nothing secret on the launch line, count `EXIT=` markers after `clear`, close the window by id in a trap). Inspect each image. Update `INVENTORY.md`, marking older captures superseded.
- Evidence folder: `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/` (root only; never `verifier/`, `verifier-r*/`, `auditor/`, `review-*/`, never `plan-approved.md`).
- Commits `test(86bcm901u): …` (and `docs(86bcm901u): …` only if the README's AC4 sentence needs to name the new structural checks); author from git config only (`Justin Issa <justin@leorna.com>`); no `Co-Authored-By` or AI attribution lines. End with the worktree committed and clean.

## 5. Boundaries

- `ci.yml`, the Makefile and all non-test Go source stay unchanged.
- No push, PR, merge, remote CI, token change, ClickUp write. Never print tokens; never write a server domain, URL or tenant ID.
- Don't touch: local `main`, the earlier 901u attempts, other stories' worktrees, DBs and scratch, `deploy/local/`.
- **Justin is away (away grant):** on a real trade-off, pick your recommended option and record it as "My ruling (away grant), not yet confirmed". Stop with `status: stopped` only if every option breaks a boundary above or changes the approved ACs; then list options with your recommended one marked.
- **Found something else?** `found_else`; don't fold it in.
- **Skill lessons:** don't edit any skill or memory file; list reusable lessons in `skill_lessons[{skill, lesson, evidence}]`. An empty list is the normal answer.

## 6. Your report

Return JSON-shaped output: `{name, status: ready-for-verify|stopped, summary, reviewed_head: "385256e", last_commit, commits[], dispositions[{id, action: fixed|pushed-back, test, evidence}], rulings[], gates[{name, log, exit_code}], mutations, ac_evidence[{ac, test, log, screenshot}], disk_free_at_end, stop_reason, found_else[], skill_lessons[]}` (`status` and `summary` required). End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
