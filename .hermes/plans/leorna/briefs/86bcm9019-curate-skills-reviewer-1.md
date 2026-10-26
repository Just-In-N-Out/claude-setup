# REVIEWER 1 brief: 86bcm9019-curate-skills [leorna]

**Role:** fresh full REVIEWER 1 (report only) for the Leorna story "86bcm9019-curate-skills" (ClickUp 86bcm9019, "Curate the skills collection"). Pipeline: **Full** (`review-fix-cadence`): reviewer 1 (you) → fixer → reviewer 2 of the corrected code → fixer → verifier → blind AC auditor. You never saw the build. **Change no source, make no commit, apply no auto-fix.**

## Skills to load first, in this order (say so in your first steps)

1. `leorna` (review rules, gates, hard rules).
2. `engineering-best-practices`.
3. `requesting-code-review`: its security scan and quality gates. **Skip its "independent reviewer subagent" and auto-fix steps:** you *are* the fresh reviewer, and you can't spawn agents.
4. `code-review-practice`.
5. `security-best-practices`: path safety, script handling, the git/temp-dir use in `AdaptationDiff`, secret scanning.
6. `mutation-testing-discipline`: check that the AC tests and guards can actually fail.

## What to review

- Worktree: `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm9019-curate-skills`, branch `feat/86bcm9019-curate-skills`.
- **Candidate head: `f6df5b7af76384bdfb367e00b00f789630475ffc`.** Base: `57783506979ae1d721b8ed9539f2b3193ed992c7` (origin/main). Review `git diff 5778350...f6df5b7`, all 14 commits. Before you start, confirm HEAD equals `f6df5b7` and the tree is clean.
- Approved plan: `~/.hermes/plans/leorna/evidence/86bcm9019/plan-approved.md` (read-only). Justin's answers: every ⭐ (A–H a), recorded under `## Justin's answers` in that copy.
- The ACs are AC1–AC5 (card) plus **AC6 (proposed) (live)**. AC6 is Justin's manual check of 3 skills × 3 tools, so mark it `not_run` for that reason.
- Repo: leorna-control-plane only. No OpenAPI, migration or CI change was planned; confirm that.

### The builder's rulings to check (each one valid, or a finding)

1. T2–T4 were made in one commit (4857e1b) so that no commit leaves the tree red.
2. `renderSkillFolder`, `validSupportPath` and `isScriptFile` were copied into `internal/library/render` rather than delegated to `pack`. Check parity with client PR #22 / client `RenderSkillFolder`.
3. Scripts needing admin approval appear both as a log line and as a job-summary section.
4. Importer: `asImported` is built from `resolveRoot` + `readRoot`. Import keeps its name and duplicate checks before any upstream read; Accept is unchanged.
5. `AdaptationDiff` caps git stderr at the existing 2 KiB `limitedBuffer` (the plan said 4 KiB) and resolves temp-dir symlinks for `GIT_CEILING_DIRECTORIES`.
6. `library-upstream adaptation` refuses before cloning, and refuses a `--upstream` that differs from the item's source.
7. The `.gitattributes` line for `internal/library/curation/**` was added at T9.
8. Lock: the 14 published entries are unchanged by value, and the literal grep's one `-` line is only a trailing comma.
9. `delivery/stories.json` was appended as text, with earlier entries checked unchanged by value.
10. `TestEvidenceSampledSkillsForManualCheck` moved to `cmd/library-gate/evidence_test.go`, so that AC4's base run is a real `--- FAIL` and not a build failure. `skills_test.go` is unchanged since T1.
11. The AC6 render test refuses an existing `ac6-install` folder rather than deleting it.
12. Upstream text is kept verbatim (H ⭐). Upstream defects and slash-command/agent mentions are in the `curation.json` notes only. The only adaptations are browser-testing-with-devtools (pin note) and idea-refine (script excluded).
13. README byte-size claim updated to 20,586 bytes.
14. ac6-checklist warns that Justin's personal `~/.claude/skills/test-driven-development` may shadow the sampled skill in Claude Code.

### Focus areas (on top of a normal full review)

- **AC truth:** does each AC test prove its card AC, every clause, for all 25 upstream skills plus incident-postmortem? Examples: name/version/commit recorded (AC1); owner named and the diff proven to reverse to upstream (AC2); scripts reviewed and either Windows-safe or excluded with a reason (AC3); gate passes for Claude Code, Codex and Cursor *including supporting files* (AC4); every demo skill accounted for (AC5).
- **Gate change (B ⭐):** the gate's render copy now handles whole folders and secret-scans `files/`. Look for a way supporting files or scripts could skip rendering or scanning, an unapproved script could ship, or a path could escape (`..`, absolute, drive letters, symlinks).
- **`library-upstream adaptation` / `AdaptationDiff`:** shelling out to git, temp dirs, env isolation (no global/system config, ceiling dir), output caps, error paths.
- **Imported content:** spot-check several of the 20 imports byte-for-byte against upstream `aeac41d4d005`. The builder's clone is at the scratchpad path below, or clone your own into your scratch. Look for secrets, prompt-injection-like instructions aimed at the agent, and unsafe commands that should have been an adaptation trigger under the plan's rule (broken paths, security, scripts).
- **Licence:** MIT notice still correct; `THIRD_PARTY_NOTICES.md` unchanged by design.
- **Regressions:** the existing multi-file skills from 945q, seed pack, lock immutability, the admin preview.

## How

- Run the project's gates yourself on `f6df5b7` (the `leorna` skill step 4 and the plan's `## Gates`): `make check` with CI's golangci-lint 2.14.0 and govulncheck v1.7.0 bound by absolute path, gitleaks 8.30.1, Postgres tests confirmed PASS not SKIP, and `bash ./scripts/test-module-add.sh`. The builder's pinned binaries are in `/private/tmp/claude-501/-Users-justin-Leorna/8269faf7-896a-43a9-8b43-35d27910a4df/scratchpad/builder-86bcm9019/`; you may reuse them after checking their versions.
- **Your own test DB:** `leorna_86bcm9019_review1_test`. Read the password through docker and never print it. Never touch `leorna_86bcm9019_test` or another story's DB.
- For mutation checks, use `go test -overlay` for Go source. Run-time data files go in a copy, never the worktree: you are read-only.
- Write evidence only into `~/.hermes/plans/leorna/evidence/86bcm9019/review-1/`. Keep scratch in the scratchpad's `reviewer1-86bcm9019/` subfolder and remove only that.
- Don't read the builder's evidence folder as proof; check the facts yourself. You may look at it to find commands.
- Never push, open a PR, write to ClickUp, or write into Justin's real `~/.claude`, `~/.codex` or `~/.cursor`.

## Severity

- **P0/P1:** security hole, a shipped secret, a gate bypass, an AC that is false.
- **P2:** a real bug or a test that can't fail.
- **P3:** quality or docs.

Each finding needs file:line evidence and a concrete fix recommendation, marked ⭐ when there are options.

## Rules

- If you find a problem outside this story's scope, list it in `found_else` (one line each, with evidence and severity), not as a finding.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and in a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. If you list any, end your report with `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON matching:

```
{verdict: clean|findings, reviewed_head, base,
 findings[{id, severity, claim, evidence, fix}],
 rulings[{n, valid, note}],
 gates[{name, exit_code, log}],
 ac_status[{ac, accepted, test, screenshot, evidence}],
 found_else[], skill_lessons[]}
```

Use ids `R1-1`, `R1-2`… `verdict: clean` only when there are no P0–P2 findings and every AC1–AC5 is accepted. AC6 stays `accepted: false, not_run: "live: …"`. Write in plain words.
