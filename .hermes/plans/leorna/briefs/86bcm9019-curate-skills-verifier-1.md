# VERIFIER 1 brief: 86bcm9019-curate-skills [leorna]

**Role:** `VERIFIER (read only) for leorna feature "86bcm9019-curate-skills"` (ClickUp 86bcm9019, "Curate the skills collection"). Pipeline: **Full**. The steps so far: builder → reviewer 1 → fixer 1 → reviewer 2 → fixer 2. **You** are a fresh verifier: you never saw the build and **change no source**. After you, a blind AC auditor proves every AC again on its own, then `ac-check.sh` compares your report with the auditor's.

## Skills to load first, in this order (say so in your first steps)

1. `leorna`.
2. `engineering-best-practices`.
3. `security-best-practices` and `mutation-testing-discipline`: you confirm each finding is closed and look for regressions the fixes caused.
4. Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` with Read. It is your AC procedure ("Folders and the run recipe", step 1 VERIFIER). The `ac.json` format is at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

No skill in this story has a "Mandatory Validation and Agent Defect Loop" section, so the gates are the project's.

## The candidate

- Worktree: `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm9019-curate-skills`, branch `feat/86bcm9019-curate-skills`.
- **Head: `13c976fd450ff5bba9e0ac5ef7f9e56ef701ba59`.** **Base: `57783506979ae1d721b8ed9539f2b3193ed992c7`** (`git merge-base HEAD origin/main`). Before you start, confirm HEAD = `13c976f`, the tree is clean, and the merge-base is `5778350`. If `origin/main` has moved, report the new tip but verify against `5778350`.
- **Approved plan, the AC source:** `~/.hermes/plans/leorna/evidence/86bcm9019/plan-approved.md` (read-only). The ACs are AC1–AC5, each with its named test, plus **AC6 (proposed) (live)**.
- Justin's later rulings, recorded in the working plan `~/.hermes/plans/leorna/86bcm9019-curate-skills.md` under `## Justin's answers`:
  - **R1-4:** reword the record, plus the npx rule (a one-off user-requested `npx` is accepted; auto-running config is adapted with a pin note).
  - **`npx vercel`:** keep it as sample CI text.
  - **R2-1:** adapt performance-optimization to `npx @lhci/cli@<reviewed> autorun` (1.0.1).

  Verify the code against these rulings. Don't demand the superseded original wording.

## Findings and fix answers to confirm closed

**Reviewer 1** (`f6df5b7`, verdict clean, 5 P3s), fixed by fixer 1 (`d1f8da7`, `a45889f`, `f78a931`, `f3dfe4e`, `6f60638`):
- **R1-1:** `AdaptationDiff` git environment → allowlisted environment, plus `TestAdaptationDiffIgnoresTheCallersGitSettings`.
- **R1-2:** `adaptation` refusals → exact-message tests.
- **R1-3:** `validSupportPath` → `TestValidateRejectsUnsafeSupportPaths`, and the escape check repaired.
- **R1-4:** record wording plus the npx rule.
- **R1-5:** network test `TestShippedImportsMatchTheRealUpstream`.

**Reviewer 2** (`6f60638`, verdict findings), fixed by fixer 2:
- **R2-1 (P1):** the bare `npx lhci` (a third-party npm placeholder) → `14292c3`: performance-optimization 1.0.1 with `npx @lhci/cli@0.15.1 autorun`, a pin note, a lock line, a generated diff and `safety: adapted`; the migrate-check note reworded.
- **R2-2:** notes and README match the sample-CI ruling → `4559114`.
- **R2-3:** README accuracy row → `df5e761`.
- **R2-4:** README test lists → `13c976f`.
- **R2-5:** temp-dir leak → `cfba3e4`, plus `TestAdaptationDiffRemovesItsScratchFolder`.

The evidence folders `review-1/`, `fix-1/`, `review-2/` and `fix-2/` are under `~/.hermes/plans/leorna/evidence/86bcm9019/`. Read them to find commands, never as proof: check every fact yourself.

## What to do

1. **Gates:** re-run every gate in the plan on `13c976f`:
   - `make check` with golangci-lint 2.14.0 and govulncheck v1.7.0 bound by absolute path, and gitleaks 8.30.1;
   - the Postgres tests, confirmed from a `go test -json -run WithPostgres` stream read per test, not `-v` text. The two ClickHouse subtests of TestTeamsAPIWithPostgres rightly skip;
   - `bash ./scripts/test-module-add.sh`;
   - library-check;
   - the network tests (`LEORNA_TEST_UPSTREAM_NETWORK=1`);
   - the lock **by value** (the plan's literal `grep '^-'` false-fails on a trailing comma);
   - no `.github`, OpenAPI, migration or seed change;
   - authors only `Justin Issa <justin@leorna.com>`, with no AI lines.

   Pinned binaries are in `/private/tmp/claude-501/-Users-justin-Leorna/8269faf7-896a-43a9-8b43-35d27910a4df/scratchpad/builder-86bcm9019/`; check their versions.
2. **Findings:** confirm each one above is closed, with your own check: a test run, an overlay mutant or a content compare. Look for regressions the fixes caused. Compare all 25 imported skills against your own clone of upstream `aeac41d4d005`: 22 should be identical and 3 should differ only by their recorded adaptations.
3. **AC work** (`ac-verification.md`):
   - For **each of AC1–AC5**, run only that AC's named test on head, using the run recipe. The log goes to `verifier/ac<n>-13c976f.log`, with the first line `HEAD=…`, verbose output and the last line `EXIT=…`; AC4 runs with `LEORNA_TEST_GITLEAKS_BIN`.
   - Run the same test on the base in a **separate detached worktree under your scratch**, never the story worktree, with only head's test files for that AC copied in. Follow the Go rule in `ac-verification.md`: copy only the test files the AC test needs, so you get a real `--- FAIL` or `[build failed]` and never `[setup failed]`. The log goes to `verifier/ac<n>-base-5778350.log`.
   - **One real screenshot per AC:** a real Terminal-window capture of that AC's own run on head, following the `leorna` skill's terminal capture recipe, saved as `verifier/ac<n>-*.png`. Inspect each one: no domain, URL, tenant ID, token or email visible.
   - **The screen may be locked** (Justin was away at 17:11). Before any capture, check `ioreg -n Root -d1 -a | plutil -extract IOConsoleUsers xml1 -o - -` for `CGSSessionScreenIsLocked`. If it is locked, do every other step first, then check again. If it is still locked, don't fake or reconstruct an image: return `verdict: blocked` with `blocked_reason: "screen locked; captures owed for ACn…"` and everything else complete. The main session resumes you once the screen is unlocked.
   - **AC6 (live):** `"accepted": false, "not_run": "live: Justin's manual check of 3 sampled skills in Claude Code, Codex and Cursor"`. Do confirm that a fresh render still equals `evidence/86bcm9019/ac6-install/`.
   - Write `~/.hermes/plans/leorna/evidence/86bcm9019/verifier/ac.json` in the format at the top of `ac-check.sh`, with `"head": "13c976fd450ff5bba9e0ac5ef7f9e56ef701ba59"`. Every cited receipt must be inside `verifier/`.
   - **Self-check while staying blind:** `cp` (not `ln`) your `ac.json`, logs and images to a scratch folder outside the evidence tree, then run `ac-check.sh --repo <worktree> --base 5778350… --plan <evidence>/plan-approved.md <your ac.json> <scratch copy>/ac.json` and fix any format, path, head or pass-line slip. Then delete the copy.
4. **Read-only:** change no source and make no commit. Write only into `~/.hermes/plans/leorna/evidence/86bcm9019/verifier/` (it should be empty or absent now; if it holds files, stop and report). Keep scratch in the scratchpad's `verifier1-86bcm9019/` subfolder and remove only that. Use your own test DB `leorna_86bcm9019_verify1_test`: read the password through docker, never print it, drop it when done. Run mutations only through `go test -overlay` or in copies.
5. Never push, open a PR, write to ClickUp, or write into Justin's real `~/.claude`, `~/.codex` or `~/.cursor`.

## Verdict

- `clean` needs no open P0–P2 finding and every AC1–AC5 accepted, each with its test, head log, base-fail log and real screenshot. AC6 stays `not_run`, live.
- `findings` when anything fails.
- `blocked` only for the locked-screen case.

## Rules

- If you find a problem outside this story's scope, list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and in a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. If you list any, end your report with `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON matching:

```
{verdict: clean|findings|blocked, blocked_reason, head, base,
 findings[{id, severity, claim, evidence}],
 closed[{id, closed, check}],
 gates[{name, exit_code, log}],
 ac_status[{ac, accepted, test, screenshot, evidence}],
 ac_json, self_check_last_line,
 found_else[], skill_lessons[]}
```

Write in plain words.
