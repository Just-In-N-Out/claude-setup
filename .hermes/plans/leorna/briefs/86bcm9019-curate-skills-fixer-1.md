# FIXER 1 brief: 86bcm9019-curate-skills [leorna]

**Role:** fresh FIXER 1 for the Leorna story "86bcm9019-curate-skills" (ClickUp 86bcm9019, "Curate the skills collection"). Pipeline: **Full** (`review-fix-cadence`). Reviewer 1 is done → **you** fix its valid findings → a fresh reviewer 2 reviews the corrected code → fixer 2 → verifier → blind AC auditor. Stop at `ready-for-review` for reviewer 2.

## Skills to load first, in this order (say so in your first steps)

1. `leorna`.
2. `engineering-best-practices`.
3. `receiving-code-review`: **verify each finding before you fix it**, fix the valid ones test-first, and push back with evidence on the rest.
4. `test-driven-development`: a failing test before each fix.
5. `security-best-practices` (R1-1 environment isolation) and `mutation-testing-discipline` (each new test must kill the mutant the reviewer saw survive).
6. `git-commit-rules`.

## The candidate

- Worktree: `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm9019-curate-skills`, branch `feat/86bcm9019-curate-skills`.
- Reviewed head: `f6df5b7af76384bdfb367e00b00f789630475ffc`. Base: `57783506979ae1d721b8ed9539f2b3193ed992c7` (origin/main). Before you start, confirm HEAD = `f6df5b7` and the tree is clean.
- Approved plan (read-only): `~/.hermes/plans/leorna/evidence/86bcm9019/plan-approved.md`. Justin's answers: every ⭐ (A–H a).
- ACs: AC1–AC5 (card) and AC6 (proposed) (live), which is Justin's manual check, owed to him.
- Reviewer 1's evidence: `~/.hermes/plans/leorna/evidence/86bcm9019/review-1/` (mutations/, receipts, probe test files).

## Reviewer 1's verdict

**clean**: no P0–P2, AC1–AC5 accepted on `f6df5b7`, all gates exit 0, all 14 builder rulings valid. It made 5 P3 findings, written out below from its report.

- **R1-1 (P3): `AdaptationDiff` output is not fixed under a developer's environment.** The doc claim "the same item always gives the same bytes" is false.
  - Evidence: `internal/library/upstream/adaptation.go:34-35` makes the claim. `adaptation.go:80` adds only `GIT_CONFIG_GLOBAL` and `GIT_CEILING_DIRECTORIES`. `git.go:237-247` passes on every variable except the repository-location ones.
  - With `GIT_DIFF_OPTS=-u0` the output gives a zero-context hunk `@@ -25,4 +25 @@`. With `GIT_CONFIG_COUNT=1` + `diff.suppressBlankEmpty=true`, blank context lines lose their leading space. Mutation M13 (drop `GIT_CONFIG_GLOBAL`) survives.
  - Receipts: `review-1/mutations/adaptation-GIT_DIFF_OPTS-u0.diff`, `adaptation-GIT_CONFIG_COUNT-suppressBlankEmpty.diff`, `M13-diff-keeps-global-config.log`. The main session reproduced both effects with a plain `git diff --no-index`.
  - The pre-existing clone and show calls in `gitCommand` have the same pass-through. That is 945u code, out of scope: put it in `found_else`, don't fix it.
  - Recommended fix: **⭐ b**, run the diff command with a minimal allowlisted environment, like the test helper (PATH, HOME=scratch, `GIT_CONFIG_NOSYSTEM=1`, `GIT_CONFIG_GLOBAL=/dev/null`, the ceiling directory). Option a is to keep `gitCommand` and strip `GIT_DIFF_OPTS`, `GIT_CONFIG_PARAMETERS`, `GIT_CONFIG_COUNT`, `GIT_CONFIG_KEY_*`, `GIT_CONFIG_VALUE_*` and `GIT_EXTERNAL_DIFF`.
  - Either way, add a test that runs `adaptation` with those variables set and a HOME whose `.gitconfig` sets `diff.suppressBlankEmpty=true`, and asserts the bytes equal a clean run. That test also kills M13.
- **R1-2 (P3): two refusals of `library-upstream adaptation` are untested.**
  - The check before cloning is at `cmd/library-upstream/main.go:343-346`. With it removed (M8), the "an unadapted item" case still passes, because `AdaptationDiff` refuses later, after the clone; the suite fails only through a nil-pointer panic in the "a Leorna item" case.
  - The `--upstream` check is at `main.go:347`. Deleting it (M7) leaves every test green.
  - Receipts: `review-1/mutations/M7-*.log`, `M8-*.log`.
  - Fix: in `TestAdaptationRefuses`, run the refusal cases with `--from` set to a path that doesn't exist and assert the exact refusal text. Add a `--upstream other` case expecting `is imported from <name>, not other`.
- **R1-3 (P3): the render copy's `validSupportPath` is untested** (`internal/library/render/render.go:165`).
  - Mutation M5 (accept any non-empty path) leaves the render, gate and library-gate suites green. The parser checks first (`pack.ValidSupportPath`, `pack.go:241`), so the gate isn't exposed today.
  - Separately, at `internal/library/adaptation_test.go:61`, `files/../x` lands inside the view folder, so that check can never fail. The `ErrInvalid` assertion in the same loop does kill M10.
  - Fix: add a table test in `render_test.go`. `Pack.Validate` rejects supporting files at `''`, `../x`, `a/../b`, `/abs`, `a:b`, `a\\b`, `.hidden/x`, `x.`, `x ` and `a//b`, and accepts `references/a.md`. Optionally assert `validSupportPath(p) == pack.ValidSupportPath(p)` over the same list to pin parity. Either drop the line-61 check or make it look outside `<dir>/skill/things/files`.
- **R1-4 (P3): two statements in the review record are stronger than the content supports.** **HELD: this is Justin's decision** (he owns the reviews, E ⭐). **Don't change anything for R1-4** unless the main session sends you his answer while you work; if it does, apply exactly that answer. For reference:
  - (a) `curation.json:514` says code-review-and-quality covers every point of the removed 6-line checklist. "Contracts and docs updated when behavior changes" and "a rollback path" appear nowhere in it.
  - (b) The browser-testing adaptation rests on `-y` skipping npx's prompt. But npm assumes `--yes` whenever stdin is not a TTY, and other skills marked safety=pass still tell the agent to run unpinned `npx <tool>`: `references/performance-checklist.md:195-203`, `references/accessibility-checklist.md:127-128`, `ci-cd-and-automation body.md:147, 202`.
  - Options: ⭐ a, reword the demo reason to name the two uncovered points and add one sentence to the safety definition (README checklist) and to those skills' notes: one-off `npx <tool>` examples run on request are accepted, while persistent config that runs automatically (an MCP server entry) is adapted. b, adapt those skills with pin notes.
- **R1-5 (P3): the AC2 proof is offline and trusts the recorded `upstreamSha256`.** An edit that also rewrites the fingerprint (plus version and lock) would pass AC1/AC2. This is predicted from the source; the reviewer checked independently that all 25 current values are right.
  - Optional fix: add the reviewer's overlay test (`review-1/mutations/zz_review1_upstream_test.go`) as a network-gated test behind the existing `LEORNA_TEST_UPSTREAM_NETWORK=1` switch, like TestAC7.

## How

- Verify each finding yourself first (`receiving-code-review`). Then fix test-first, one commit per finding, message `fix(86bcm9019): …` or `test(86bcm9019): …`. Show each new test failing before the fix, or killing the surviving mutant (M5, M7, M8, M13) through `go test -overlay`.
- Don't change AC test names or weaken any AC test. Don't touch upstream skill text, the lock's published entries, `.github/`, OpenAPI or the seed pack.
- Commit authorship: run `git commit -m …` only. The author must be `Justin Issa <justin@leorna.com>`. No `-c user.*`, `--author` or AI attribution lines.
- After the fixes, run every gate in the plan on the new head: `make check` with golangci-lint 2.14.0 and govulncheck v1.7.0 bound by absolute path, gitleaks 8.30.1, the Postgres tests confirmed PASS not SKIP, `bash ./scripts/test-module-add.sh`, and AC1–AC5 each by name with its PASS line. The builder's pinned binaries are in `/private/tmp/claude-501/-Users-justin-Leorna/8269faf7-896a-43a9-8b43-35d27910a4df/scratchpad/builder-86bcm9019/`; check their versions.
- **Your own test DB:** `leorna_86bcm9019_fix1_test`. Read the password through docker and never print it; drop the DB when done.
- Evidence goes only in `~/.hermes/plans/leorna/evidence/86bcm9019/fix-1/`: per-finding test/mutant logs and `gates-<sha7>.txt` + `.json` with `exit_code`. Keep scratch in the scratchpad's `fixer1-86bcm9019/` subfolder and remove only that.
- If the AC6 render output changes, re-render `evidence/86bcm9019/ac6-install/`. The render test refuses an existing folder: move the old one to `ac6-install-f6df5b7/` first. Otherwise leave it alone.
- Never push, open a PR, write to ClickUp, or write into Justin's real `~/.claude`, `~/.codex` or `~/.cursor`.
- Finish with the worktree committed and clean.

## Rules

- If you find a problem outside this story's scope, list it in `found_else` (one line each, with evidence and severity). Don't fix it.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and in a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. If you list any, end your report with `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON matching:

```
{status: ready-for-review|stopped, stop_reason, head, base, commits[],
 findings[{id, verdict: fixed|pushed-back|held, test, evidence, note}],
 gates[{name, exit_code, log}],
 ac_status[{ac, accepted, test, screenshot, evidence}],
 found_else[], skill_lessons[]}
```

Write in plain words.
