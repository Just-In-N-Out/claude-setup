# FIXER 3 brief: 86bcm901u-quality-gate-v3 (Leorna, control plane)

You are **FIXER 3** for the Leorna story **Content quality gate (CI)**, ClickUp card `86bcm901u`, feature `86bcm901u-quality-gate-v3`. Model: Opus 5.5, effort xhigh. You are a fresh agent. Fix verifier 1's two P3 findings test first, commit, and stop at **`ready-for-verify`** (a fresh verifier, then the blind AC auditor, run next). No hand-over, push or PR.

## 0. Disk first

The Mac's disk filled up during verifier 1 (268 MB free; the main session cleared the Go build cache, leaving ~9.5 GB). Before each heavy gate run `df -h /`. If free space drops under 3 GB, stop with `status: stopped`, `stop_reason: disk` (don't delete anything that isn't yours). Keep your scratch small and delete your own scratch when you finish.

## 1. Skills to load first (say so in your first steps)

1. `leorna` (fixer rules and gates; skip its Step 1 only where this brief gives you the facts)
2. `engineering-best-practices`
3. `receiving-code-review`: verify each finding before fixing it; push back with evidence on any you find wrong.
4. `test-driven-development`
5. `mutation-testing-discipline`
6. `git-commit-rules`: before your first commit.

## 2. Where things are

- Worktree: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v3`, branch `feat/86bcm901u-quality-gate-v3`, head **`429c2ad9094fa68838094d2d796d06f076444ef9`**, base `origin/main` = `6e74ced843642439d1dac9f25673440fb0f285f5`. No upstream; keep it that way.
- Approved plan (read only): `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md`. Live plan with every decision ("Away-grant picks"): `~/.hermes/plans/leorna/86bcm901u-quality-gate-v3.md`.
- Verifier 1's receipts (read, don't write): `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/verifier/` (`mutations-429c2ad.txt` A12/A13, `makefile-weakening-demo-429c2ad.log`, `probes-429c2ad.txt` section R1). Fixer 2's class audit: `…/fix-2-class-audit.md`.

## 3. The findings and the decision on each (Justin is away; these are verifier 1's recommendations, applied under his away grant)

**V1 (P3, same class as R2-F-R2-3) — FIX, test only (Makefile unchanged).** `TestAC4CIRunsLibraryGateWithoutDroppingGates` checks only the start of the `library-check` recipe (`\nlibrary-check:\n\t$(GO) run ./cmd/library-gate `). Appending ` || true` to the recipe (A12) or adding `.IGNORE: library-check` (A13) makes CI's `make library-check` exit 0 on a failing library while AC4 still passes. Evidence: `verifier/makefile-weakening-demo-429c2ad.log` (unmutated make exits 2; mutated exits 0; TestAC4 passes).
Recommended fix: in `cmd/library-gate/ci_test.go`, compare the whole `library-check` block (its comment, the three `?=` lines, the rule and the recipe) to exact text, as `gateStepText` does; require exactly one `\nlibrary-check:` rule; fail on any `.IGNORE` line; also check `check:` still lists `library-check` (if not already pinned). A12, A13 and a "second library-check rule" mutant must all be killed. Keep the failure messages clear and the test's comment saying later Makefile edits must update it.

**V2 (P3, side effect of the F-R2-1 cap; it fails closed, so it is not a bypass) — SCOPED FIX.** Valid content can render a scan copy over the 100,000-byte cap: an MCP template body of 64,046 bytes (16,000 one-letter args, under the 64 KiB body limit) renders a 208,177-byte `.mcp.json` because the renderer re-indents the JSON, and the gate stops with exit 2. Fixer 2's audit/ruling R1 ("largest valid copy is 73,635 bytes") is wrong, and the README implies only padding reaches the cap. The error says "remove padding or shorten the file" and names a rendered file the author can't edit. Evidence: `verifier/probes-429c2ad.txt` section R1. Real items are under 700 bytes.
Recommended fix (keep it fail-closed; **not** the overlapping-windows alternative): when the oversize copy is a **rendered** file, the error names the item (`<kind>/<name>@<version>`), the tool and the size, and says to shorten the item's `body.md` (or its args); a **source** copy keeps today's message. Test first with a large-args MCP template (exit 2, message names item, tool and size). README: say rendered files (MCP JSON re-indented to about 3×) can also reach the cap. Correct the class-audit line in `fix-2-class-audit.md`? No: that file is fixer 2's receipt; write your correction into your own `fix-3-notes-<sha7>.md` instead.

## 4. After the fixes

- Gates on your new head as the plan's Gates/T10 say (CI's golangci-lint 2.14.0 by absolute path, govulncheck v1.7.0, `make check` with Postgres on the builder's DB `leorna_86bcm901u_v3_test` (reuse it; never drop it or touch any other DB), `bash ./scripts/test-module-add.sh`, `gitleaks git --log-opts=HEAD`, `make library-check`, every AC command). Save `gates-<sha7>.txt` + `.json` with exit codes; no email in them ("authors: 1 identity, matches the Leorna identity").
- Mutations: A12, A13, the second-rule mutant, your V2 mutants (message reverts to the old text; rendered copy treated as source), plus re-run fixer 2's C1–C3 cap mutants. Save `mutations-fix-3-<sha7>.txt`; each killed by its named test on a compiled build; restored tree clean and green.
- **Screenshots (Justin's one-per-AC rule):** retake **all four** AC1–AC4 captures on your final head as real Terminal captures (the `leorna` terminal capture recipe: count `EXIT=` markers after `clear`, nothing secret on the launch line, close the window by id after). Look at every image: no token, domain, URL bar, tenant ID or email. Update `INVENTORY.md`, marking older captures superseded.
- Evidence folder: `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/` (root only; never `verifier/`, `auditor/`, `review-*/`, never `plan-approved.md`).
- Commits `test(86bcm901u): …` / `fix(86bcm901u): …` / `docs(86bcm901u): …`; author from git config only (`Justin Issa <justin@leorna.com>`); no `Co-Authored-By` or AI attribution lines. End with the worktree committed and clean.

## 5. Boundaries

- Story-only CI exception: `ci.yml` stays as it is; the Makefile's `library-check` target stays as it is (V1 is test only).
- No push, PR, merge, remote CI, token change, ClickUp write. Never print tokens; never write a server domain, URL or tenant ID.
- Don't touch: local `main`, the earlier 901u attempts (branches, worktrees, plans, evidence, DBs, scratch), other stories' worktrees, DBs and scratch, `deploy/local/`.
- **Justin is away (away grant):** on a real trade-off, pick your recommended option, apply it and record it as "My ruling (away grant), not yet confirmed" with the reason. Stop with `status: stopped` only if every option breaks a boundary above or changes the approved ACs; then list the options with your recommended one marked.
- **Found something else?** List it in `found_else`; don't fold it in.
- **Skill lessons:** don't edit any skill or memory file; list reusable lessons in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section. An empty list is the normal answer.

## 6. Your report

Return JSON-shaped output: `{name, status: ready-for-verify|stopped, summary, reviewed_head: "429c2ad", last_commit, commits[], dispositions[{id, action: fixed|pushed-back, test, evidence}], rulings[], gates[{name, log, exit_code}], mutations, ac_evidence[{ac, test, log, screenshot}], disk_free_at_end, stop_reason, found_else[], skill_lessons[]}` (`status` and `summary` required). End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
