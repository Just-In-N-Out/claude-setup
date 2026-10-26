# REVIEWER 2 brief: 86bcm9019-curate-skills [leorna]

**Role:** fresh full REVIEWER 2 (report only) for the Leorna story "86bcm9019-curate-skills" (ClickUp 86bcm9019, "Curate the skills collection"). Pipeline: **Full** (`review-fix-cadence`): reviewer 1 → fixer 1 → **you** (a fresh full review of the corrected candidate, which also checks fixer 1's fixes) → fixer 2 → verifier → blind AC auditor. You never saw the build or reviewer 1's work. **Change no source, make no commit, apply no auto-fix.**

## Skills to load first, in this order (say so in your first steps)

1. `leorna`.
2. `engineering-best-practices`.
3. `requesting-code-review`. **Skip its "independent reviewer subagent" and auto-fix steps:** you are the fresh reviewer, and you can't spawn agents.
4. `code-review-practice`.
5. `security-best-practices`.
6. `mutation-testing-discipline`.

## What to review

- Worktree: `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm9019-curate-skills`, branch `feat/86bcm9019-curate-skills`.
- **Candidate head: `6f60638472a344394366a9a6c682e97f3681f6d8`.** Base: `57783506979ae1d721b8ed9539f2b3193ed992c7` (origin/main). Review the **whole** `git diff 5778350...6f60638` (19 commits), not only the fix commits. Before you start, confirm HEAD = `6f60638` and the tree is clean.
- Approved plan (read-only): `~/.hermes/plans/leorna/evidence/86bcm9019/plan-approved.md`. Justin's answers: every ⭐ (A–H a). **Plus R1-4 (Justin, 2026-10-25, "Reword + one rule"),** recorded in the working plan `~/.hermes/plans/leorna/86bcm9019-curate-skills.md` under `## Justin's answers`:
  - the demo-skill reason names the 2 points code-review-and-quality doesn't cover;
  - safety rule: a one-off `npx <tool>` the user asks for is accepted; persistent config that runs automatically (e.g. an MCP server entry) is adapted with a pin note;
  - no skill text changes.
- ACs: AC1–AC5 (card) plus **AC6 (proposed) (live)**, Justin's manual 3 skills × 3 tools check. Mark AC6 `not_run` for that reason.
- Repo: leorna-control-plane only. No OpenAPI, migration, seed or CI change.

## Reviewer 1's findings (on `f6df5b7`) and fixer 1's answers: check each fix holds and broke nothing

Reviewer 1's verdict was clean: no P0–P2, AC1–AC5 accepted. Its 5 P3s, and fixer 1's answers:

- **R1-1:** `AdaptationDiff` output depended on the caller's git environment (`GIT_DIFF_OPTS`, `GIT_CONFIG_COUNT`/`PARAMETERS`, global config). **Fixer 1:** `d1f8da7` runs git with an allowlisted environment (PATH, HOME=<scratch>, `GIT_CONFIG_NOSYSTEM=1`, `GIT_CONFIG_GLOBAL=/dev/null`, `GIT_ATTR_NOSYSTEM=1`, ceiling dir), with a new test `TestAdaptationDiffIgnoresTheCallersGitSettings` (7 hostile cases, including global attributes files). It says both stored diffs regenerate byte-identical.
- **R1-2:** two refusals of `library-upstream adaptation` were untested. **Fixer 1:** `a45889f` strengthens `TestAdaptationRefuses` with exact messages, a non-existent `--from` and an "another upstream" case.
- **R1-3:** the render copy's `validSupportPath` was untested, and one escape check could never fail. **Fixer 1:** `f78a931` adds `TestValidateRejectsUnsafeSupportPaths` with parity against `pack.ValidSupportPath`, and repairs the escape check.
- **R1-4:** the review record overclaimed. **Fixer 1:** `6f60638` rewords the demo reason, adds the npx rule to the README safety definition and to the review notes of 9 skills, and rests the browser-testing note on the rule. No skill text, version, lock or diff change.
- **R1-5:** the AC2 proof trusted the recorded `upstreamSha256`. **Fixer 1:** `f3dfe4e` adds `TestShippedImportsMatchTheRealUpstream` behind `LEORNA_TEST_UPSTREAM_NETWORK=1`.

Fixer 1's evidence is in `~/.hermes/plans/leorna/evidence/86bcm9019/fix-1/`. Use it to find commands, not as proof: check the facts yourself.

### Focus areas

- **AC truth on `6f60638`:** each AC test proves every clause of its card AC, for all 25 upstream skills plus incident-postmortem.
- **The gate change:** the render copy handles whole folders and secret-scans `files/`. Look for any path where a supporting file or script skips rendering or scanning, an unapproved script ships, or a path escapes.
- **`AdaptationDiff` and `library-upstream adaptation`:** is the new allowlisted environment complete and correct on macOS, Linux and Windows CI? Check temp-dir cleanup, error paths and the output cap.
- **Review record (`internal/library/curation/curation.json`) and README:** do they say only what the content supports? Is the npx rule applied consistently? One edge case is the `npx vercel` preview/rollback jobs in ci-cd-and-automation, which fixer 1 recorded as "an example the user asks for" with the fact stated. Judge whether that reading holds under the rule, and report it either way.
- **Imported content:** spot-check several of the 20 imports byte-for-byte against your own clone of upstream `aeac41d4d005` (clone into your scratch). Look for secrets, prompt-injection-like instructions and unsafe commands.
- **Regressions:** the 945q multi-file skills, lock immutability, admin preview, the seed pack.

## How

- Run every gate in the plan on `6f60638` yourself:
  - `make check` with golangci-lint 2.14.0 and govulncheck v1.7.0 bound by absolute path, and gitleaks 8.30.1;
  - the Postgres tests, confirmed PASS not SKIP;
  - `bash ./scripts/test-module-add.sh`;
  - AC1–AC5 by name.

  Pinned binaries are in `/private/tmp/claude-501/-Users-justin-Leorna/8269faf7-896a-43a9-8b43-35d27910a4df/scratchpad/builder-86bcm9019/`; check their versions.
- **Your own test DB:** `leorna_86bcm9019_review2_test`. Read the password through docker and never print it; drop the DB when done.
- **Mutations:** use `go test -overlay` for Go source. Run-time data files go in a copy, never the worktree: you are read-only.
- Write evidence only into `~/.hermes/plans/leorna/evidence/86bcm9019/review-2/`. Keep scratch in the scratchpad's `reviewer2-86bcm9019/` subfolder and remove only that.
- Never push, open a PR, write to ClickUp, or write into Justin's real `~/.claude`, `~/.codex` or `~/.cursor`.

## Severity

- **P0/P1:** security hole, a shipped secret, a gate bypass, an AC that is false.
- **P2:** a real bug or a test that can't fail.
- **P3:** quality or docs.

Each finding needs file:line evidence and a concrete fix recommendation, marked ⭐ when there are options. When a finding is Justin's decision (scope, review policy), say so.

## Rules

- If you find a problem outside this story's scope, list it in `found_else` (one line each, with evidence and severity), not as a finding.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and in a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer: list only what the skills don't already say. If you list any, end your report with `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON matching:

```
{verdict: clean|findings, reviewed_head, base,
 findings[{id, severity, claim, evidence, fix, justins_call}],
 r1_fixes[{id, holds, note}],
 gates[{name, exit_code, log}],
 ac_status[{ac, accepted, test, screenshot, evidence}],
 found_else[], skill_lessons[]}
```

Use ids `R2-1`, `R2-2`… `verdict: clean` only when there are no P0–P2 findings and every AC1–AC5 is accepted. AC6 stays `accepted: false, not_run: "live: …"`. Write in plain words.
