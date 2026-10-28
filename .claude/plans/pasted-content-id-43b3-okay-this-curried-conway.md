# 86bcm901u-quality-gate-v2: Content quality gate (CI), fresh start

## Context

Justin wants ClickUp story [Content quality gate (CI)](https://app.clickup.com/t/86bcm901u) (control plane, PI-2, p1-high) rebuilt from scratch. An earlier Hermes pipeline left a local-only attempt on `feat/86bcm901u-content-quality-gate`: 6 commits / 44 files in the control plane, 2 / 3 in the client, never pushed, stopped on an unanswered P3 question.

The card's acceptance criteria:
- **AC1:** on a library change, CI schema-validates every item, renders it for Claude Code, Codex and Cursor, and secret-scans it.
- **AC2:** a render failure for a declared-supported tool fails CI and names the item and the tool.
- **AC3:** a passing run produces a per-item compatibility report.

Verify: CI on a deliberately broken item (fails) and on the real library (passes).

### Justin's decisions (2026-10-23)

- **Pipeline:** the Full pipeline from Hermes `feature-dispatch`, with **Opus 5.5 xhigh in every role** in place of Sol. Each role is a new, fresh agent.
- **Old attempt:** left untouched (branches, 6 worktrees, plan, briefs, evidence, held test DBs). The new branch is `feat/86bcm901u-quality-gate-v2`.
- **Planner:** fully blind to the old attempt. Done: its transcript shows no access to the old work, and all 7 required skills were loaded.
- **Q1-A:** copy the client's render code verbatim into the control plane, proven against the client's own goldens and tests.
- **Q2-A:** agents count as `deferred` and render warnings as `warn`; both pass.
- **Q3-A:** report goes to the job-summary table plus log lines. The JSON is written but not uploaded.
- **Q4-A:** prompt kind 86bcm9016 (CP #85, client #20) merges first. This branch then adds prompt rendering (gated task G1).
- **Skill lessons:** agents write down anything that can go into a skill; this main session saves it (Part B).
- **CI exception:** the story-only exception (2026-10-22, `no-ci-changes.md`) covers `.github/workflows/ci.yml` changes. Existing gates are not weakened. Push, PR, remote CI and credentials stay behind Justin's own words.

## Pipeline (Opus 5.5, effort xhigh, each a new background agent; one agent per call)

| # | Role | Agent | Stops at |
|---|---|---|---|
| 1 | PLANNER | Plan agent, done | plan below |
| 2 | **BUILDER** | general-purpose, works in `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v2` | `ready-for-review` |
| 3 | **REVIEWER 1** | general-purpose, never saw the build; own detached review worktree `…/86bcm901u-v2-review-r1` at the builder head | report only |
| 4 | FIXER 1 | general-purpose; skipped if review 1 is clean | `ready-for-next-review` |
| 5 | **REVIEWER 2** | fresh; full `origin/main...HEAD` plus the fix delta, carrying report 1 | report only |
| 6 | FIXER 2 | fresh; skipped if clean | `ready-for-verify` |
| 7 | **VERIFIER** | fresh, read-only; re-runs the gates and the loop skills' validation, closes each finding, and rules **accepted / not accepted per AC** | `clean` + every AC accepted, or `findings` |
| 8 | FINISHER | fresh; hand-over only | diff stat, PR text, review prompt, team message, ClickUp evidence draft with every AC screenshot |

**Keep looping until every AC is accepted (Justin, 2026-10-23).**
- Each reviewer and each verifier returns `ac_status[{ac, accepted: true|false, test, screenshot, evidence}]` for AC1, AC2 and AC3.
- If any AC is not accepted, or any critical or major finding is open, another fresh FIXER runs, then another fresh VERIFIER, until all three are accepted on the same head with their screenshots present.
- There is no fixed round cap; that replaces `feature-dispatch`'s "ask after 3 rounds" for this story.
- I stop and ask Justin only in two cases:
  - a fix needs a decision that is his (scope, a permission or credential, an AC wording);
  - a round makes no progress (the same finding reopened with no new fact), so repeating it would just spin.
- "Accepted" is local acceptance. The hosted CI run in Verify stays **NOT VERIFIED until "make a PR"**, and is named that way rather than counted as accepted.

Rules for every role:
- **Brief file:** each role's brief is saved to `~/.hermes/plans/leorna/briefs/86bcm901u-quality-gate-v2-<role>.md` and the dispatch says "read it first". Reviewer findings are written into the next brief from the result message.
- **Skills, in order:**
  - every role: `leorna`, then `engineering-best-practices`;
  - builder: `test-driven-development`, `mutation-testing-discipline`, `security-best-practices`, `api-contract-drift-guard`, `backend-data-migrations` (confirms no migration);
  - reviewers: `requesting-code-review`, `code-review-practice`, `mutation-testing-discipline`. They skip the "spawn a reviewer" and auto-fix steps;
  - fixers and finisher: `receiving-code-review`, `git-commit-rules`, `test-driven-development`;
  - verifier: `api-contract-drift-guard` and `backend-data-migrations`, both loop skills.
  
  I check each agent's transcript for real Skill calls.
- **Agent Defect Loop applies** (two loop skills), so hand-over waits for a clean VERIFIER.
- **Every brief carries:**
  - the CI exception scope;
  - "never push, PR, merge, post or change ClickUp";
  - "don't touch the old `86bcm901u-content-quality-gate` branch, worktrees or held DBs";
  - "use your own `_test` DB, never drop a sibling's";
  - `found_else[]`;
  - `skill_lessons[]` (Part B).
- **G1 (prompt kind):** runs only after Justin merges CP #85 and client #20. If that happens after the review chain, G1 gets its own fresh Opus focused review and verifier before hand-over.

## Part B: agents report skill lessons (Justin, 2026-10-23)

Rule: **agents write lessons down; this main session saves them.** Subagents never edit `SKILL.md` or memory. Parallel agents would overwrite each other's edits to shared skill files, and reviewers and the verifier are read-only.

1. **Every brief** gets this line and an output field: "If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong or missing), don't edit any skill: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of your report."
2. **On each result,** I check each lesson, then make a small edit to the named `SKILL.md` under `~/.claude/skills` (shared with Hermes) or a memory note. I tell Justin in one line what was saved. Duplicates and story-only facts are dropped; story facts go to `leorna-workflow.md`.
3. **Hook** `~/.claude/hooks/skill-review-nudge.sh`, test first:
   - In `~/.claude/hooks/tests/skill-review-nudge.test.sh`, add failing cases: a subagent PostToolUse fires a subagent-worded nudge on its 15th call; counters are separate per agent; main-session behaviour is unchanged.
   - Then change the script. When `agent_id` is set, count that agent's own PostToolUse calls (`<session>.<agent>.tools`, id sanitized), and every 15 inject: "note skill-worthy lessons for your final report's Skill lessons section; do not edit skills or memory yourself."
   - Run the whole test file: the 13 existing cases plus the new ones.
   - Live check: one throwaway Explore agent (haiku) runs past 15 tool calls and reports whether the nudge arrived. If it doesn't arrive, the brief line (1) remains the mechanism, and I say so.
4. **Make it last:**
   - `feature-dispatch` SKILL.md: add `skill_lessons[]` next to the `found_else` line (line 249) and to the builder, reviewer and verifier output schemas, plus "main chat saves them on intake".
   - `periodic-skill-review.md` memory note and its `MEMORY.md` line.
   - One line in `~/.claude/CLAUDE.md` → "Skills to Load While Coding".
5. **Lessons from the planner to save** (each checked first):
   - `feature-dispatch` (and the `leorna` loop wording): anchor the Agent Defect Loop grep on `^## Mandatory Validation and Agent Defect Loop`. A plain `grep -l 'Agent Defect Loop'` false-matches `leorna`.
   - memory `leorna-control-plane-workflow.md`: `scripts/verify-workspace.sh:12-15` machine-enforces the no-client-import rule.
   - memory `leorna-workflow.md`: fix the stale `local/` branch-flow line and the stories.json-timing contradiction with `leorna` step 7.8.
   - Dropped as too narrow: the `rev-parse` tip and the `mdfind` tip.

## Story plan (planner's, Opus 5.5 xhigh; base CP `main` 0da9f54, client `main` 8d540f1)

### Design

Every CI run (so every library change) runs, inside the required **"Go quality gates"** job:

1. **Preflight:** the source must be a real directory with no symlinks or irregular files, each file ≤ 128 KiB, and ≤ `3*library.MaxItems+1` files. Any violation fails before anything else runs.
2. **Secret scan:** CI's pinned gitleaks 8.30.1 scans the raw tree with the repo `.gitleaks.toml`. Each finding is attributed to `items/<kind>/<name>/…`, or library-level otherwise.
3. **Schema:** the unchanged `library.Parse(os.DirFS(dir))` (`internal/library/source.go:61`). It fails fast and already names the item.
4. **Render:** each item goes into a one-item pack `{Name: lib.Name, Version: lib.Version, Items: [{Kind, Name, Version, Description, Body}]}`, which mirrors client `application/sync.go:420`. That pack goes through `claudecode`, `codex` and `cursor` `Transformer{}.Transform`. **Declared** means `item.Tools` contains the transformer's `ID()`. A declared tool with no renderer fails closed.
5. **Classify:**
   - error → `fail`;
   - no files and kind agent → `deferred`;
   - no files otherwise → `fail`, with a reason naming the `<tool>-` prefix rule;
   - warnings → `warn`;
   - otherwise → `pass`.
   
   `Blocking = declared && status == fail`. An item passes when its scan is clean and nothing is blocking. The library passes when schema passed, there are no library-level findings, and all items passed. `ctx.Err()` is checked between items.

New packages:
- **`internal/toolrender/`**: a verbatim copy of the client render step (copy map below).
- **`internal/library/qualitygate/`** with `gate.go`, `preflight.go`, `secrets.go`, `gitleaks.go`, `report.go`, `README.md`.
- **`cmd/library-check/`**.

**Interfaces**

```go
type Status string // pass | warn | deferred | fail
type SecretScanner interface {
	Name(ctx context.Context) (string, error)
	Scan(ctx context.Context, dir string) ([]Finding, error) // File slash-relative to dir
}
type Finding struct{ File string; Line int; Rule string } // never the secret value
type Options struct{ Dir string; Scanner SecretScanner }  // nil Scanner = error (fail closed)
func Run(ctx context.Context, opts Options) (Report, error) // error only when the gate couldn't run
```

**Report fields** (JSON, `schemaVersion: 1`)
- Top level: `{library{name,version}, source, secretScanner, schema{status,error}, libraryFindings[], items[], passed}`.
- Item: `{key kind/name@version, kind, name, version, checksum, declaredTools[], schema, secretScan{status,findings[]}, tools[claude-code,codex,cursor]{tool, declared, status, blocking, files[{path,bytes,sha256}], warnings[], error}, passed}`.
- Deterministic: no timestamps, sorted slices, `[]` never `null`.
- Methods: `Problems()`, `WriteJSON`, `WriteMarkdown`, `WriteText`.

**Gitleaks scanner:** `Gitleaks{Binary, Config}`.
- The directory path is made absolute first, so it can't begin with `-` (GO-INJECT-002).
- A temp dir holds the report.
- `exec.CommandContext`, no shell, this exact argv:

```
dir <abs> --config <Config> --report-format json --report-path <tmp>/gitleaks.json
--exit-code 0 --no-banner --no-color --redact --ignore-gitleaks-allow
--gitleaks-ignore-path <tmp> --log-level error --max-target-megabytes 1 --timeout 120
```

- Any non-zero exit is an error (fail closed).
- The report is read with an 8 MiB cap, decoding only `RuleID`, `File` and `StartLine`. `Secret`/`Match` are never decoded.
- Stderr tail is capped at 4 KiB, on one line.
- `Name` runs `Binary version` (256 B cap).

**Output**
- Every line starts with `library-check: `.
- Content text goes through `oneLine()`, which escapes CR/LF, control runes and U+2028/2029. That blocks `::error::` / `::add-mask::` injection.
- Example lines:

```
library-check: config/codex-defaults@1.1.0 schema=pass secrets=pass claude-code=not-declared codex=pass cursor=not-declared
library-check: FAIL mcp_template/docs-mcp@1.0.0 codex: render failed: toolconnector: capability not supported by connector: MCP server "docs" in "docs-mcp" is a remote server, which Codex cannot express
library-check: FAIL skill/commit-message-style@1.0.0 secret-scan: items/skill/commit-message-style/example.md:3 matched gitleaks rule github-pat (value redacted)
library-check: FAIL schema: library content is invalid: skill/incident-postmortem: unknown tool vim
library-check: FAILED: 2 problems; see the compatibility report
library-check: PASSED: 8 items checked for claude-code, codex and cursor; secret scan clean (gitleaks 8.30.1)
```

- Undeclared-tool failures are never FAIL lines. They stay in the JSON (`declared:false, blocking:false`) and show as `not-declared`.
- Markdown:
  - heading `## Content library quality gate: PASSED|FAILED`;
  - an info line;
  - table `| Item | Claude Code | Codex | Cursor | Secret scan |` with cells `pass`, `warn (n)`, `deferred`, `not declared`, `FAIL`, `clean`;
  - a legend, plus `### Problems` and `### Warnings` sections when needed.
  - Cells are escaped: `oneLine` → `html.EscapeString` → `|`→`\|`, `` ` ``→``\` ``.
- Exit codes: **0** passed, **1** content problems (including source and schema), **2** the gate couldn't run.

**Command `cmd/library-check`**
- Signature: `run(ctx, args, stdout, stderr, newScanner) int`, using its own `flag.NewFlagSet(ContinueOnError)`.
- Flags: `-dir` (default `internal/library/content`), `-gitleaks` (`gitleaks`), `-gitleaks-config` (`.gitleaks.toml`), `-report` (JSON, overwritten), `-summary` (Markdown, appended), `-timeout` (`2m`).
- Writes both outputs on pass and on fail.
- Local output goes to `.library-check/` (new, gitignored). In CI, `$GITHUB_STEP_SUMMARY` gets the table and the JSON goes to `${RUNNER_TEMP}/library-check/`, not uploaded (Q3-A).

**Makefile**

```make
LIBRARY_DIR ?= internal/library/content
LIBRARY_OUT ?= .library-check
check: workspace contracts-check fmt vet test lint audit secrets library-check build   # + .PHONY
library-check:
	@mkdir -p "$(LIBRARY_OUT)" && rm -f "$(LIBRARY_OUT)/summary.md"
	$(GO) run ./cmd/library-check -dir "$(LIBRARY_DIR)" -gitleaks "$(GITLEAKS)" \
		-gitleaks-config "$(CURDIR)/.gitleaks.toml" -report "$(LIBRARY_OUT)/compatibility.json" \
		-summary "$${GITHUB_STEP_SUMMARY:-$(LIBRARY_OUT)/summary.md}"
```

**CI** (`.github/workflows/ci.yml`, job `quality`, the one exception-scoped change): the test step gains `LEORNA_TEST_GITLEAKS_BIN="${RUNNER_TEMP}/gitleaks"`, and a new step goes right after "Test with the race detector":

```yaml
      - name: Test with the race detector
        run: LEORNA_TEST_GITLEAKS_BIN="${RUNNER_TEMP}/gitleaks" make test

      - name: Check content library quality
        run: |
          GITLEAKS="${RUNNER_TEMP}/gitleaks" \
          LIBRARY_OUT="${RUNNER_TEMP}/library-check" \
            make library-check
```

- It reuses the gitleaks binary the existing step downloads and checksum-verifies.
- Nothing is removed. `permissions: contents: read` is unchanged. No new action, no path filter.
- It sits inside the required job because a separate job would need a branch-protection change.

### Copy map (client `8d540f1`, the only edits allowed)

| Client | Control plane | Edits |
|---|---|---|
| `toolconnector/errors.go` | `internal/toolrender/errors.go` | keep `ErrInvalid`, `ErrUnsupported`, `ErrConflict` exactly |
| `toolconnector/types.go` | `internal/toolrender/types.go` | keep `ToolID`, `ConfigBundle` only |
| `toolconnector/pack.go`, `transform.go` | same names | verbatim |
| `toolconnector/internal/golden/golden.go` (+test) | `internal/toolrender/internal/golden/` | verbatim |
| `toolconnector/{claudecode,codex,cursor}/config.go` | `internal/toolrender/<tool>/config.go` | verbatim; plus `claudecode/id.go` `const ID tc.ToolID = "claude-code"` |
| tests `{pack,transform,agent_transform}_test.go`, `<tool>/config_test.go` | same paths | drop tests needing a real tool binary or connector code (`TestClaudeReadsGoldenConfig`, `TestCodexParsesGoldenConfig`, anything calling `New`/`ApplyConfig`/`Detect`); copy any helpers they use |
| testdata `pack.json`, `<tool>/testdata/golden/**`, `claudecode/testdata/invalid-permissions-pack.json` | same paths | verbatim |

Mechanical edits:
- package `toolconnector` → `toolrender` (and `_test`).
- Import path → `github.com/LeornaAI/leorna-control-plane/internal/toolrender`, keeping the aliases.
- Add a header line, then a blank line: `// Mirrored from leorna-client <path> at 8d540f1; keep behaviour identical (internal/toolrender/README.md).`
- New `doc.go` carries the package doc.

**Expected result on the real library:**
- agents (2): `deferred` ×3;
- `config/claude-code-settings`: claude-code `pass` (`.claude/settings.json`), others not declared;
- `config/codex-defaults`: codex `pass` (`config.toml`), others not declared;
- `mcp_template/github-mcp`: `pass` ×3 (`.mcp.json` / `config.toml` / `mcp.json`);
- 3 skills: `pass` ×3.

### Tasks (worktree as the working directory; `RUN=go test -count=1`; each task: RED → change → check)

- **B0 Setup (10 min).**
  - Fetch main over HTTPS through gh (`leorna` 7.1).
  - `git worktree add ~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v2 -b feat/86bcm901u-quality-gate-v2 origin/main`.
  - Record the CP head and the client `main` SHA. If the client moved off 8d540f1, copy from the new SHA and record it.
  - Probe tools; baseline `make check` into `gates-<main7>-baseline.txt` with its exit code.
  - Classify `make secrets` failures by commit membership only.
- **B1–B4 Copy (10–15 min each)**, for the root, then `claudecode`, `codex`, `cursor`.
  - RED: copied tests fail to build.
  - Copy with `git -C ~/Leorna/leorna-client show 8d540f1:<src> > <dest>`, then apply the mechanical edits.
  - GREEN: `TestTransformMatchesGolden`, `TestTransformRejectsPacksItCannotRender`, the cursor `${env:GITHUB_TOKEN}` golden.
  - Check: `diff` against the client shows only package, import and header lines.
- **B5 Parity proof (10 min).** Diffs into `parity-diff-<sha7>.txt`; mutations M14–M16, M19. Commit `feat(86bcm901u): mirror the client render step for content checks`.
- **B6 Gate skeleton and schema step (10 min).**
  - `helpers_test.go` adds `writeLibrary`, `validLibrary()` and `fakeScanner{findings, err, dirs}`. `validLibrary()` holds:
    - `skill/write-tests` [all 3 tools];
    - `mcp_template/docs-mcp` with a URL server [claude-code, cursor];
    - `config/codex-strict` [codex].
  - RED `TestGateRejectsSchemaErrors`, then `Run` steps 1 and 4.
- **B7 Render and classify (15 min).**
  - RED: `TestGateValidatesRendersAndScansEveryItem`, `TestGateFailsNamingItemAndToolWhenADeclaredToolCannotRender` (exact FAIL line), `TestGateIgnoresFailuresForUndeclaredTools`, `TestGateFailsWhenADeclaredToolRendersNothing`, `TestGateDefersAgents`, `TestGateFailsClosedForAToolWithoutARenderer`.
  - Mutations M1–M5, M8, M9.
- **B8 Preflight (10 min).** RED `TestGateRejectsUnsafeSource`, with subtests: symlinked file, symlinked folder, file over 128 KiB, FIFO (skip on Windows), too many files via a lowered internal limit. Mutation M12.
- **B9 Secret attribution (10 min).** RED `TestGateFailsOnSecretFinding`, `TestGateFailsOnLibraryLevelFinding`, `TestGateScansTheParsedFolder`, `TestGateFailsClosedWhenTheScanCannotRun`, `TestGateRequiresAScanner`. Mutations M6, M7.
- **B10 Gitleaks (15 min).**
  1. Capture the real output shape with 8.30.1 in `~/.hermes/cache/scratch/86bcm901u-quality-gate-v2/shape/`. The planted value is written by `python3 -I` and never echoed. Save the sanitized output as `testdata/gitleaks-report.json`.
  2. RED tests:
     - `TestGitleaksArguments` (exact argv);
     - `TestGitleaksReportParsing`;
     - `TestGitleaksScannerFailsClosed` (missing binary; non-zero exit via a helper process; malformed or missing report);
     - env-gated `TestGitleaksScannerFindsPlantedSecret` (`LEORNA_TEST_GITLEAKS_BIN`). It plants values in `item.json`, `body.md` and `example.md`, checks that `gitleaks:allow` is still found and that a clean tree has zero findings, and checks that the gate's JSON and text never contain the value.
  3. Planted values are built at runtime only: `"ghp_" + hex(sha256("leorna-qualitygate-planted"))[:36]`, or a private-key block built from fragments. Variable names avoid `token`, `secret`, `key` and `password`. Mutations M10, M11.
- **B11 Report (15 min).** RED `TestGateProducesAPerItemCompatibilityReport` (goldens `report.golden.{json,md,txt}`, `-update-golden`) and `TestReportEscapesUntrustedText`. Mutation M13.
- **B12 Real library (5 min).** `TestShippedLibraryPassesTheQualityGate` asserts the exact matrix above. It may start green; prove it can fail with M2/M8. Commit `feat(86bcm901u): check every library item for each tool and for secrets`.
- **B13 Command (15 min).** `TestLibraryCheckPassesOnTheRealLibraryAndWritesTheReport` (exit 0, all 8 keys, table header), `TestLibraryCheckFailsOnABrokenItemNamingItemAndTool` (exit 1, exact FAIL line, report written with `passed:false`), `TestLibraryCheckFailsClosedWithoutTheScanner` (exit 2), `TestLibraryCheckRejectsBadFlags` (exit 2). Mutations M17, M18.
- **B14 Makefile, `.gitignore` (`/.library-check/`), `.gitattributes` (`internal/toolrender/**/testdata/** text eol=lf`, `internal/library/qualitygate/testdata/** text eol=lf`) (5–10 min).** Check `make library-check` exits 0, the output is not in `git status`, and `git check-attr` shows `eol: lf`.
- **B15 CI (10 min).** Edit as above.
  - Ruby YAML parse: "Check content library quality" must sit right after "Test with the race detector", with all existing steps unchanged and in order.
  - `git diff origin/main -- .github/ > ci-diff-<sha7>.txt` shows additions plus the one changed `run:` line.
  - Commit `feat(86bcm901u): run the content quality gate in CI`.
- **B16 Local Verify runs V1–V4 (15 min).** See Evidence.
- **B17 Docs (10–15 min).**
  - `internal/toolrender/README.md`: source SHA, file map, "copy only", re-sync commands.
  - `internal/library/qualitygate/README.md`: what is checked, statuses, how "declared" is decided, FAIL format, report fields and locations, commands, test names, limits.
  - `internal/library/README.md`: appended "Quality gate" pointer.
  - Root `README.md`: line 95.
  - Commit `docs(86bcm901u): document the content quality gate`.
- **B18 Full gates and mutation sweep (30–45 min)** on the final head; `mutations-<sha7>.txt`.
- **B19 Hand-off (10 min).**
  - `git diff --stat origin/main..HEAD`.
  - `git diff --name-only origin/main...HEAD -- .github/` must be `.github/workflows/ci.yml` only.
  - Evidence `INVENTORY.md`; stop at `ready-for-review`.
- **G1 prompt kind (30–45 min), gated on Justin merging CP #85 and client #20.**
  - Precondition: `git grep -n KindPrompt origin/main -- internal/pack/pack.go`.
  - Rebase the branch.
  - RED: `TestShippedLibraryPassesTheQualityGate` fails for `prompt/pr-description`.
  - Copy the client `toolconnector/prompt.go`, the prompt branches in each `config.go`, the kind constant, `prompt_transform_test.go` and any goldens. Re-diff, update the README SHA, add the matrix row, rerun the gates.
  - Required before any PR.

### AC → test map (each mutation turns the test red, then is restored)

| AC | Tests | Failure cases | Mutations |
|---|---|---|---|
| AC1 | `TestGateValidatesRendersAndScansEveryItem`; `TestGitleaksScannerFindsPlantedSecret` (runs in CI); `TestShippedLibraryPassesTheQualityGate` | `TestGateRejectsSchemaErrors`, `…FailsOnSecretFinding`, `…FailsOnLibraryLevelFinding`, `…FailsClosedWhenTheScanCannotRun`, `…RequiresAScanner`, `…RejectsUnsafeSource`, `TestGitleaksScannerFailsClosed` | M4 skip cursor; M5 skip last item; M6 no scan; M7 attribute by kind only; M10 drop `--ignore-gitleaks-allow`; M11 ignore exec error; M12 drop symlink check; ignore the Parse error |
| AC2 | `TestGateFailsNamingItemAndToolWhenADeclaredToolCannotRender` (exact string); `TestLibraryCheckFailsOnABrokenItemNamingItemAndTool` (exit 1) | `…IgnoresFailuresForUndeclaredTools`, `…FailsWhenADeclaredToolRendersNothing`, `…FailsClosedForAToolWithoutARenderer`, `…DefersAgents` | M1 `Blocking=false`; M2 ignore declared; M3 drop tool from FAIL line; M8 drop zero-files rule; M9 defer all zero-file kinds; M17 exit 0 on failure |
| AC3 | `TestGateProducesAPerItemCompatibilityReport` (goldens); `TestLibraryCheckPassesOnTheRealLibraryAndWritesTheReport` | `TestReportEscapesUntrustedText` | M13 remove escaping; M18 skip writing on success; unsorted output |
| Parity | copied client tests (goldens ×3, refusal tables, agent warnings, MCP and skill validation, pack Validate) | client refusal tables | M14 codex accepts URL servers; M15 cursor drops `${env:` rewrite; M16 claude accepts `bypassPermissions`; M19 Validate accepts unknown kinds |

DoD: unit = qualitygate and toolrender tests; integration = the command's happy path and one failure, plus real gitleaks. No API, DB or tenancy change, so OpenAPI and migrations are N/A. The builder confirms `git diff --name-only origin/main...HEAD -- contracts packages/contracts internal/store/postgres/migrations` is empty.

Mutation hygiene:
- Edit only the function under test.
- Use never-true comparisons rather than `false`.
- Commit before each round; restore with `git checkout -- <file>`.

### Gates (exact; logs plus `.json` receipts with the exit code in `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v2/`)

```bash
export PATH="$HOME/.hermes/cache/scratch/leorna-bin:/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/bin:$HOME/go/bin:$PATH"
verified_linter="$HOME/.hermes/cache/scratch/leorna-bin/golangci-lint"; "$verified_linter" --version   # 2.14.0 = CI pin
realpath --relative-to=/ /tmp && bash -c 'mapfile -d "" x </dev/null'; gitleaks version   # 8.30.1; go1.27.3 via go.work toolchain
open -a Docker; docker start leorna-test-pg
export LEORNA_TEST_DATABASE_URL='postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_test?sslmode=disable'
export LEORNA_TEST_GITLEAKS_BIN="$(command -v gitleaks)"
GOLANGCI_LINT="$verified_linter" make check            # now includes library-check -> gates-<sha7>.txt
bash ./scripts/test-module-add.sh                        # -> module-add-<sha7>.txt
go test -v -count=1 ./internal/toolrender/... ./internal/library/... ./cmd/library-check/...   # story-tests
go test -v -count=1 -run TestEnsureLibraryWithPostgres ./internal/store/postgres/             # proves PG ran
gitleaks git --redact --no-banner --log-opts="origin/main..HEAD"                               # story scan
make library-check                                                                              # real library
```

- ClickHouse tests skip locally: record them as "not run locally".
- A local-toolchain `make audit` stdlib CVE is an environment baseline (CI runs Go 1.27.3).
- A wrong-linter "export data version" failure is fixed by the PATH order or the binding, never by a code change.
- The DB name must end in `_test`. Never share or drop a sibling's DB.

### Evidence (builder captures while building; `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v2/`)

Scratch trees go in `~/.hermes/cache/scratch/86bcm901u-quality-gate-v2/`. Each run is `make library-check LIBRARY_DIR=… LIBRARY_OUT=…; echo EXIT=$?`.

**One screenshot per AC for ClickUp (Justin, 2026-10-23).**
- Every AC gets at least one real screenshot of its run, taken at the moment the check runs: a terminal window showing the command, its output and `EXIT=`. AC3 also gets the rendered report table.
- The text log next to each screenshot is the proof behind it.
- Every screenshot is opened and checked visually: no paths outside the repo, no domains, tokens, emails or planted secret values. It gets cropped or retaken if needed.
- After each fix round, screenshots whose output changed are retaken on the new head. The filename gets the head's `<sha7>`, and the finisher's list uses only current-head files.
- The finisher's ClickUp draft lists every screenshot plus the gate logs, matched to their exit-code receipts. **Upload happens only when Justin says "post"**; the card status is never changed.

| AC | Run | Artifact |
|---|---|---|
| AC1 | **V1** real library: 8 item lines, exit 0 | `ac1-real-library-run.txt/.png` |
| AC1 | **V3** planted secret in `skill/commit-message-style/example.md`: exit 1, item/file/line/rule named and redacted; `grep -c` of the value = 0 | `ac1-broken-secret-run.txt/.png` |
| AC1 | **V4** `skill/incident-postmortem` `tools:["vim"]`: exit 1 `FAIL schema` | `ac1-broken-schema-run.txt/.png` |
| AC2 | **V2** `github-mcp` body set to a URL server: exit 1, `FAIL mcp_template/github-mcp@2.0.0 codex: render failed: … remote server …`; the other two tools pass | `ac2-broken-item-fails.txt/.png` |
| AC3 | the V1 report | `ac3-compatibility-report.json/.md`, `ac3-report-table.png` |
| Parity, mutations, gates, CI diff | see the tasks | `parity-diff-*`, `mutations-*`, `gates-*`, `ci-diff-*`, `ci-yaml-steps-*` |
| Hosted CI (real library and broken item) | **NOT VERIFIED until Justin says "make a PR"** | — |

Before anything leaves the Mac:
- Read each log's recorded exit code. A plain `gates-<sha7>.txt` may hold a failed first attempt.
- Inspect every screenshot: no paths outside the repo, domains, tokens or emails.

### Assumptions and risks

**Assumptions**
- The `item.json` `tools` field is the declared list.
- Library item to pack item = `{kind,name,version,description,body}`.
- Each item is rendered in a one-item pack. Conflicts between items belong to the E11 pack builder.
- Tool ID strings are the same in both repos.

**Security**
- gitleaks coverage is pattern plus entropy. A low-entropy literal password in an MCP `env` can slip through (follow-up: a structural rule requiring `${VAR}`).
- Content is untrusted. It is never executed; output gets the fixed prefix and is escaped.
- DoS bounds: 128 KiB per file, a file-count cap, gitleaks 1 MB and 120 s, an 8 MiB report read, a 2 min context.
- Symlinks are rejected.
- No literal fake secret is ever committed, because CI's all-refs gitleaks scan would fail every PR.

**Correctness**
- **Copy drift** after later client changes is the main risk (follow-up: a drift check or a shared rules artifact).
- Codex TOML isn't validated; that is copied client behaviour.
- `Parse` reports one schema error per run.

**CI**
- The hosted run is unverified; YAML is checked with Ruby only.
- Pushing workflow files needs SSH unlocked (`ssh-add --apple-use-keychain ~/.ssh/id_ed25519_leorna`) or a `workflow`-scoped gh token. That is Justin's call later.
- The new step depends on `${RUNNER_TEMP}/gitleaks` from the earlier step, and fails closed if that is missing.

**Forecast**
- Builder: 3.5–5 h; full pipeline: 7–10 h wall time; G1 adds 30–45 min. Confidence medium-low.
- Assumes Docker / `leorna-test-pg` are available and no concurrent DB use.

**Overlap**
- 9016: non-overlapping hunks in `internal/library/README.md` and the root `README.md`, plus `stories.json`; the behaviour overlap is G1.
- 901v: no shared files.
- Order: 9016 (CP #85 → client #20) → this story → 901v (independent).

## Docs & records

**Before dispatch**
- Save this plan as `~/.hermes/plans/leorna/86bcm901u-quality-gate-v2.md`, marked "Approved by Justin 2026-10-23", with the answers above.
- Write the briefs to `~/.hermes/plans/leorna/briefs/86bcm901u-quality-gate-v2-<role>.md` and create the evidence dir.
- Board via `python3 -I ~/.hermes/scripts/dispatch_board.py`:
  - mark the old `86bcm901u-content-quality-gate` entry superseded (`phase=stopped`, which clears its unanswered P3 ask, note "superseded by v2 fresh start");
  - add `86bcm901u-quality-gate-v2` with `phase=building` and `model="opus-5.5 xhigh (all roles)"`;
  - update it at every phase change.
- Memory:
  - `leorna-workflow.md`: a dated status line (fresh start, all-Opus, v2 branch, old attempt preserved and superseded, Q1–Q4 = A) plus the `MEMORY.md` one-liner;
  - `no-ci-changes.md`: the exception also covers the v2 branch.
  - `clickup-evidence.md`: Justin wants one screenshot per AC, taken during the run, for the ClickUp upload (2026-10-23).
  - The story line records the "loop until every AC is accepted" rule for this story.
- `found-else.md`: a dated heading with the planner's 6 items:
  1. `verify-workspace.sh` picks up `.claude/worktrees` go.mod files (low);
  2. library version has no length bound, while the client caps it at 50 (low);
  3. agents are declared for every tool but the client installs none (medium);
  4. Codex TOML is unchecked (medium);
  5. the client ignores `tools` (known);
  6. stale memory lines.

**During build and finish**
- Module READMEs (B17); evidence `INVENTORY.md` (AC → test → result → artifact, plus NOT VERIFIED).
- Status lines at each stage.
- After merge: the `make library-check` / `LEORNA_TEST_GITLEAKS_BIN` facts in `leorna-control-plane-workflow.md`.
- `delivery/stories.json` **only after the PR exists**.
- Finisher hand-over: PR text (plain style; security, migration "none", rollback "revert the commit"), review prompt, team message, ClickUp evidence draft. **Never push or post.**

## Verification

- **Story:** the builder and then each reviewer and the verifier run the gates above on the exact head.
  - The `make check` exit is 0 and includes `library-check`. `test-module-add.sh` passes. The Postgres test ran, not skipped.
  - The story-test `-v` log lists every AC test.
  - The mutation table shows each M1–M19 red, then restored green.
  - V1 exits 0 and produces the report; V2, V3 and V4 exit 1 with exact FAIL lines.
  - `.github/` diff = `ci.yml` only, additions plus one `run:` line.
  - Story-scoped gitleaks is clean.
- **Before hand-over:** I check `git -C <worktree> log` and the author identity (`Justin Issa <justin@leorna.com>`), and that nothing was pushed (`git ls-remote` shows no v2 branch).
- **Hosted CI** stays NOT VERIFIED until "make a PR".
- **Part B:** the hook test file passes in full (13 existing cases plus the new ones). The live Explore-agent check reports whether the nudge arrived. Each skill or memory edit is read back after writing.
