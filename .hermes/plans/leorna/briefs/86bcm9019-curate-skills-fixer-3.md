# FIXER 3 brief: 86bcm9019-curate-skills [leorna], records only

**Role:** fresh FIXER 3 for the Leorna story "86bcm9019-curate-skills" (ClickUp 86bcm9019, "Curate the skills collection"). This is a small **records-only** change after a decision from Justin. Next comes a fresh verifier, then a blind AC auditor. **Stop at `ready-for-verify`.**

## Skills to load first (say so in your first steps)

1. `leorna`.
2. `engineering-best-practices`.
3. `receiving-code-review`.
4. `git-commit-rules`.

## The candidate

- Worktree: `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm9019-curate-skills`, branch `feat/86bcm9019-curate-skills`.
- Head: `13c976fd450ff5bba9e0ac5ef7f9e56ef701ba59`. Base: `57783506979ae1d721b8ed9539f2b3193ed992c7`. Confirm HEAD = `13c976f` and the tree is clean before you start.
- The working plan `~/.hermes/plans/leorna/86bcm9019-curate-skills.md` holds every ruling under `## Justin's answers`.

## The one change

**Justin, 2026-10-25, on `npx tsc`: "Keep, state it in notes."** Four skills say `npx tsc`: ci-cd-and-automation, context-engineering, git-workflow-and-versioning and incremental-implementation. Without `typescript` installed, npx fetches npm `tsc` 2.0.4, "A deprecated release of the TypeScript compiler" (maintainers basarat and orta; the registry receipt is `~/.hermes/plans/leorna/evidence/86bcm9019/fix-2/npm-registry/tsc.json`). In a TypeScript project the local compiler wins.

- In `internal/library/curation/curation.json`, update the review notes of **context-engineering, git-workflow-and-versioning and incremental-implementation**. Each one today calls `npx tsc --noEmit` "an unpinned one-off command, which passes the safety check". Each must also state the fact plainly: without `typescript` installed in the project, `npx tsc` fetches npm `tsc` 2.0.4, a deprecated TypeScript release, not the project's compiler. Safety stays **pass**, per Justin's ruling.
- **ci-cd-and-automation's note already states this.** Check it says the same thing and leave it unless it's inaccurate.
- Keep the wording consistent with the existing notes. **No skill text change, no adaptation, no version or lock change**, and no change to any other file unless a test pins this exact wording. If one does, update that test only as far as the wording requires.

## How

- One commit: `docs(86bcm9019): review notes say what npx tsc fetches without typescript`. Author `Justin Issa <justin@leorna.com>`, set by git config; no `-c user.*`, `--author` or AI lines.
- Afterwards, `git diff --name-only 13c976f..HEAD` must list only `internal/library/curation/curation.json`, or that plus a test the wording forced.
- Run the record checks on the new head:
  - `go test -count=1 ./internal/library/... ./cmd/library-gate/... ./cmd/library-upstream/...`;
  - AC1–AC5 by name, AC4 with `LEORNA_TEST_GITLEAKS_BIN` set to gitleaks 8.30.1;
  - `make -s library-check`;
  - `make check` with golangci-lint 2.14.0 and govulncheck v1.7.0 bound by absolute path, and gitleaks 8.30.1.

  Pinned binaries are in `/private/tmp/claude-501/-Users-justin-Leorna/8269faf7-896a-43a9-8b43-35d27910a4df/scratchpad/builder-86bcm9019/`. Logs go in `~/.hermes/plans/leorna/evidence/86bcm9019/fix-3/gates-<sha7>.txt` + `.json` with `exit_code`.
- `make check` needs `LEORNA_TEST_DATABASE_URL`. Use your own DB `leorna_86bcm9019_fix3_test`, read the password through docker, never print it, and drop the DB when done.
- **Cleanup from a stopped agent:** an earlier verifier was stopped mid-run and may have left the DB `leorna_86bcm9019_verify1_test`. Check whether it exists, drop it if so, and report it. Don't touch any other DB. Also report whether any detached base worktree from it is listed in `git -C ~/Leorna/leorna-control-plane worktree list`, but don't remove it: report only.
- Keep scratch in the scratchpad's `fixer3-86bcm9019/` subfolder and remove only that. Never push, open a PR, write to ClickUp, or write into Justin's real `~/.claude`, `~/.codex` or `~/.cursor`. Don't create files in `verifier/` or `auditor/`.
- Finish with the worktree committed and clean.

## Rules

- If you find a problem outside this change's scope, list it in `found_else`.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and in a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. If you list any, end your report with `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON matching:

```
{status: ready-for-verify|stopped, head, base, commits[], changed_paths[],
 gates[{name, exit_code, log}], cleanup, found_else[], skill_lessons[]}
```
