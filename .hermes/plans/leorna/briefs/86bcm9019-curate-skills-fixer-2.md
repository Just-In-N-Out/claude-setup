# FIXER 2 brief: 86bcm9019-curate-skills [leorna]

**Role:** fresh FIXER 2 for the Leorna story "86bcm9019-curate-skills" (ClickUp 86bcm9019, "Curate the skills collection"). Pipeline: **Full** (`review-fix-cadence`). The steps so far: reviewer 1 → fixer 1 → reviewer 2 (findings). **You** fix reviewer 2's valid findings. After you, a fresh verifier and a blind AC auditor. **Stop at `ready-for-verify`.**

## Skills to load first, in this order (say so in your first steps)

1. `leorna`.
2. `engineering-best-practices`.
3. `receiving-code-review`: **verify each finding before you fix it**, fix the valid ones test-first, and push back with evidence on the rest.
4. `test-driven-development`.
5. `security-best-practices` (R2-1) and `mutation-testing-discipline`.
6. `git-commit-rules`.

## The candidate

- Worktree: `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm9019-curate-skills`, branch `feat/86bcm9019-curate-skills`.
- Reviewed head: `6f60638472a344394366a9a6c682e97f3681f6d8`. Base: `57783506979ae1d721b8ed9539f2b3193ed992c7` (origin/main). Before you start, confirm HEAD = `6f60638` and the tree is clean.
- Approved plan (read-only): `~/.hermes/plans/leorna/evidence/86bcm9019/plan-approved.md`. The working plan, `~/.hermes/plans/leorna/86bcm9019-curate-skills.md`, holds `## Justin's answers`: every ⭐ (A–H a), plus three later rulings:
  - **R1-4 "Reword + one rule":** a one-off `npx <tool>` the user asks for is accepted; persistent config that runs automatically (e.g. an MCP server entry) is adapted with a pin note.
  - **`npx vercel` "Keep as example":** the ci-cd-and-automation preview/rollback jobs are sample CI text the user copies on request. Safety pass, the risk stated in the note, no adaptation.
  - **R2-1 "Adapt to @lhci/cli"** (below).
- ACs: AC1–AC5 (card) and AC6 (proposed) (live), Justin's manual check, owed to him.
- Reviewer 2's evidence: `~/.hermes/plans/leorna/evidence/86bcm9019/review-2/`. Its full JSON is `review-2/review-2.json`; the npm registry receipts are in `review-2/npm-registry/`.

## Reviewer 2's findings (verdict: findings; all of reviewer 1's fixes hold; AC1–AC5 accepted)

- **R2-1 (P1, security): JUSTIN DECIDED "Adapt to @lhci/cli" (⭐ a). Apply exactly this.**
  - The problem: performance-optimization's "Enforce in CI" (`body.md:198-204`) tells the agent to run `npx lhci autorun`. On npm, `lhci` is **not** Lighthouse CI. It is a third-party "placeholder anupamas0x1" package (4.1.2, maintainer `0e.vcmaa`) whose `lhci` bin prints a hello line. The real tool is `@lhci/cli` (its bin is also `lhci`; the main session saw 0.15.1 as latest on 2026-10-25). The review record passes the line as a safe one-off.
  - **Do:** adapt performance-optimization **1.0.0 → 1.0.1**. Replace the bare `npx lhci autorun` with `npx @lhci/cli@<reviewed version> autorun` and add a short Leorna pin note in the same style as browser-testing-with-devtools' note. Find every `npx lhci` occurrence in that item, the body and its supporting files.
    - Pick and record the reviewed version: check its registry metadata and that `npx @lhci/cli@<v> autorun --help` really resolves the `lhci` bin of `@lhci/cli` (use a scratch dir and a scratch npm cache; don't install anything globally).
    - Record it in `curation.json` as an adaptation with `safety: adapted` and the reason.
    - Generate the stored diff with `library-upstream adaptation --item skill/performance-optimization`, never by hand.
    - Add the new lock line for 1.0.1 and never change published lock lines. Follow the README's version and lock rules.
    - Check whether `library.json` needs its version bumped again (it is 0.5.0, unreleased in this story), and follow the existing rule.
  - Also reword the deprecation-and-migration review note: `npx migrate-check` names an npm "Reserved name placeholder" (0.0.1-security, no executable today). **No skill text change there.**
  - Tests: AC1, AC2 and the other library tests must pass, with the new adaptation covered the way the existing two are (the stored diff reverses to upstream, the fingerprint matches). If a test hard-codes "exactly 2 adapted" (the network test, the review counts), update it to 3, because Justin's ruling changes the expected data. Don't weaken any check.
- **R2-2 (P3): record wording against Justin's rulings.**
  - The ci-cd-and-automation note bases its pass on the one-off clause, but the preview job runs on every PR. The note omits that the newest Vercel CLI gets `secrets.VERCEL_TOKEN` on every run. Its "they use the project's locked versions" claim only holds when the project lists those packages. And it calls the rollback sample sound even though it puts `${{ inputs.version }}` straight into `run:`.
  - The performance-optimization note calls its CI lines one-off. This is moot once R2-1 adapts them, but make the note match.
  - The README safety rule doesn't record the sample-CI ruling.
  - Fix: reword the two notes to cite Justin's "sample CI text the user copies on request" ruling and state the token risk and the `inputs.version` injection plainly. Add one clause to the README safety rule recording the ruling. No skill text change for ci-cd-and-automation.
- **R2-3 (P3): `accuracy: pass` on skills whose own notes list wrong advice**, against the README definition "technically sound and current". ⭐ Reword the README accuracy row to say "sound overall; known nits listed in notes". Don't add a new check value: that would be Justin's call.
- **R2-4 (P3): the README Verification lists leave out fixer 1's three tests**: `TestAdaptationDiffIgnoresTheCallersGitSettings`, `TestValidateRejectsUnsafeSupportPaths` and `TestShippedImportsMatchTheRealUpstream` (the last behind `LEORNA_TEST_UPSTREAM_NETWORK=1`). Add them.
- **R2-5 (P3, nit): `AdaptationDiff` leaks its temp folder when `EvalSymlinks` fails** (`internal/library/upstream/adaptation.go:54-63`): the deferred cleanup reads the reassigned `scratch`. Fix: resolve into a new variable. The same pattern in `gate/scan.go:265-273` predates this story; put it in `found_else`, don't fix it.
- **Info:** the plan's gate-5 recipe (`git diff | grep '^-'` on the lock) false-fails on the trailing comma. Prove the lock gate **by value** (all published entries unchanged), as the builder and both reviewers did.

## How

- Verify each finding yourself first, then fix test-first with one commit per finding: `fix(86bcm9019): …`, `docs(86bcm9019): …` or `test(86bcm9019): …`. For R2-5, show a test or overlay mutant that fails before the fix. Records/docs-only changes need no new test, but every existing test must stay green.
- Commit authorship: run `git commit -m …` only. The author must be `Justin Issa <justin@leorna.com>`. No `-c user.*`, `--author` or AI lines.
- Don't touch other upstream skill text, published lock lines, `.github/`, OpenAPI or the seed pack. Don't rename or weaken AC tests.
- After the fixes, run every gate on the new head:
  - `make check` with golangci-lint 2.14.0 and govulncheck v1.7.0 bound by absolute path, and gitleaks 8.30.1;
  - the Postgres tests, confirmed PASS not SKIP;
  - `bash ./scripts/test-module-add.sh`;
  - AC1–AC5 by name;
  - the network tests (`LEORNA_TEST_UPSTREAM_NETWORK=1`: `TestShippedImportsMatchTheRealUpstream`, TestAC7);
  - the lock by value.

  Pinned binaries are in `/private/tmp/claude-501/-Users-justin-Leorna/8269faf7-896a-43a9-8b43-35d27910a4df/scratchpad/builder-86bcm9019/`; check their versions.
- AC6: performance-optimization isn't one of the three sampled skills, so check that a fresh render still equals `evidence/86bcm9019/ac6-install/`. If it doesn't, move the old folder to `ac6-install-6f60638/` and re-render.
- **Your own test DB:** `leorna_86bcm9019_fix2_test`. Read the password through docker and never print it; drop the DB when done.
- Evidence goes only in `~/.hermes/plans/leorna/evidence/86bcm9019/fix-2/`, including `gates-<sha7>.txt` + `.json` with `exit_code`. Keep scratch in the scratchpad's `fixer2-86bcm9019/` subfolder and remove only that. Don't create files in `verifier/` or `auditor/`.
- Never push, open a PR, write to ClickUp, open an upstream issue, or write into Justin's real `~/.claude`, `~/.codex` or `~/.cursor`.
- Finish with the worktree committed and clean (no untracked files).

## Rules

- If you find a problem outside this story's scope, list it in `found_else` (one line each, with evidence and severity). Don't fix it.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and in a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. If you list any, end your report with `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON matching:

```
{status: ready-for-verify|stopped, stop_reason, head, base, commits[],
 findings[{id, verdict: fixed|pushed-back, test, evidence, note}],
 lhci_version_reviewed,
 gates[{name, exit_code, log}],
 ac_status[{ac, accepted, test, screenshot, evidence}],
 found_else[], skill_lessons[]}
```

Write in plain words.
