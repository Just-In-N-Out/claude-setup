# VERIFIER brief: 86bcm901b-prompts-collection [leorna]

**Role:** VERIFIER (read only) for the Leorna story "86bcm901b-prompts-collection" (ClickUp "Curate the reusable prompts collection"), Full pipeline. You are fresh: you never saw the plan being written, the build, the reviews or the fixes. **Change no source:** no edit, commit, push, merge, PR or ClickUp write in the repo; restore anything you touch. You write only in your own evidence folder and scratch folder. After you, if you're clean: a blind AC auditor proves every AC again without seeing your work, and a script compares both reports.

**Machine:** Justin's Windows desktop (WSL Ubuntu 26.04, `/home/justin`), not the Mac. Mac-only recipes in the skills (osascript Terminal captures, `screencapture`, Homebrew paths) don't apply.

## Skills to load first, in this order (say so in your first steps)

1. `leorna` (VERIFIER role; Step 1 context load for the control plane).
2. `engineering-best-practices`.
3. `security-best-practices` and `mutation-testing-discipline` (the plan's specialists; none ends with "Mandatory Validation and Agent Defect Loop").

Then read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and follow its **VERIFIER** part exactly, and read the report format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

## What to verify

- **Repo:** `leorna-control-plane`. **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901b-prompts-collection`, branch `feat/86bcm901b-prompts-collection`.
- **Head: `63afe554f42e593b545741e453a59d560c49cb22`. Base: `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`** (`git merge-base HEAD origin/main`; GitHub `main` was still `1ee7157` at 20:56Z).
- **Approved plan (the acceptance contract):** `/home/justin/.hermes/plans/leorna/evidence/86bcm901b/plan-approved.md` (read-only). It names AC1–AC5, one test per AC, and the command that runs only that test (its "Acceptance criteria" table). AC5 is tagged `(live)`. The live plan `/home/justin/.hermes/plans/leorna/86bcm901b-prompts-collection.md` adds, under "Justin's answers (2026-10-28)", every ⭐ answer and two main-session rulings under Justin's away grant (Review 1 F4, Review 2 R2-2: every prompt's review note and `example.md` say only what the prompt body supports and what this story verified).
- **History to check is closed (read; don't trust):** review 1 `evidence/86bcm901b/review-1/report.md` (F1–F5), fixer 1 `fix-1/report.md`, review 2 `review-2/report.md` (R2-1 to R2-3), fixer 2 `fix-2/report.md` (with a 45-mutant sweep in `fix-2/mutations-fix2-63afe55.txt` and re-run scripts in `fix-2/tools/`).

## Your job

1. **Entry check first, before expensive gates:** fetch `origin/main` (fetch only) and compare with `1ee7157`. If GitHub `main` moved in files this story touches (`internal/library/**`, `cmd/library-upstream/**`, `cmd/library-gate/**`, `delivery/stories.json`), stop early with `verdict: integration-required` and the moved paths.
2. **Re-run the project's gates yourself** on `63afe55`, in a detached copy in your scratch folder (`make check` and `scripts/test-module-add.sh` write into the tree they run in; never run them in the story worktree): `make -s check` with the `GOLANGCI_LINT`, `GOVULNCHECK`, `GITLEAKS` bindings and no cached tests, `scripts/test-module-add.sh`, the `go test -json -run WithPostgres` per-test read (the `leorna` skill's step 4), the stories unittest, branch gitleaks `1ee7157..63afe55`, no `.github` change, plus the two network tests (`LEORNA_TEST_UPSTREAM_NETWORK=1`: `TestShippedImportsMatchTheRealUpstream`, `TestAC7_DryRunSyncAgainstUpstreamHEAD`). The builder's `evidence/86bcm901b/builder-tools/gates.sh` and `INVENTORY.md` show the exact invocations.
3. **Confirm every review finding is closed as a class** (F1–F5, R2-1 to R2-3), with your own probes or mutants where cheap (`go test -overlay`, never editing a source file), and look for regressions the fixes caused. Judge fixer 2's six rulings (in `fix-2/report.md`).
4. **AC work, per `ac-verification.md` → VERIFIER:** for AC1–AC4, run each AC's own test command on head (log `ac<n>-63afe55.log`: first line `HEAD=…`, last line `EXIT=…`, verbose runner output) and on base in a separate detached copy with head's version of that AC's test file copied in, one AC at a time (log `ac<n>-base-1ee7157.log`; AC3 is expected to fail to build on base, which counts). AC4 needs `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks`. Take one **screenshot per AC** of your own run (a terminal capture of the log rendered in a `<pre>` page, screenshotted with this desktop's Chrome recipe in `ac-verification.md`: Chrome for Testing with `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu` and `--headless=new --no-sandbox --disable-gpu --disable-software-rasterizer`; kill only Chrome processes with your own `--user-data-dir`). AC5 (live) gets `"accepted": false, "not_run": "live: Justin runs /review and /spec in Claude Code"`. Write `verifier/ac.json` in the `ac-check.sh` format, then self-check it as `ac-verification.md` says (copy, not link, your `ac.json`, logs and images to a scratch folder outside the evidence tree, run `ac-check.sh` on your own copy twice, delete the copy).
5. **Verdict:** `clean` only if every gate passes, every finding is closed, no regression, and AC1–AC4 are accepted (AC5 `not_run` aside). Otherwise `findings`.

## How to run things

- **Toolchain:** no system Go, make, gcc or Postgres here. Use the story's user-space environment read-only: `export PATH=$HOME/.cache/leorna-86bcm901b/go/bin:$HOME/.cache/leorna-86bcm901b/bin:/usr/local/bin:/usr/bin:/bin GOTOOLCHAIN=local`. Don't change anything under `~/.cache/leorna-86bcm901b/` except creating and dropping your own databases.
- **Database:** PostgreSQL 18.6 on 127.0.0.1:55400 (`~/.cache/leorna-86bcm901b/pg/pg.env`, password in `pg/password`). Create databases named `leorna_86bcm901b_verifier_*_test` and drop them when done. Never use or drop another role's or a sibling story's database. Never print the password or a DB URL.
- **Worktrees:** add detached copies with `git -C <worktree> worktree add --detach <your scratch>/<name> <sha>` and remove them with `git worktree remove` when done. The story worktree must stay clean (`git status --porcelain --untracked-files=all` empty) at `63afe55`.
- **Siblings:** other sessions are working in this repo on 86bcm901a, 86bcm901j and 86bcm901w. Never touch their worktrees, branches, databases, environment folders or evidence folders.
- **Shell gotcha:** in this Bash tool `grep` is a function running Claude Code's ugrep: it skips gitignored and binary files, and bounded repeats like `.\{0,200\}` fail. Use `command grep` in scripts and for log checks.
- **Your folders:** evidence only in `/home/justin/.hermes/plans/leorna/evidence/86bcm901b/verifier/` (create it; every receipt your `ac.json` cites must be inside it). Never write in `auditor/` or any other role's folder. Scratch only in `/tmp/claude-1000/-home-justin-Leorna/b389a035-8205-4322-8956-053806a4a6b1/scratchpad/86bcm901b-verifier-1/`, created fresh with `mkdir` (no `-p`); the scratchpad is shared, so never read or touch other folders there, and remove yours at the end.
- Claude Code refuses report files from subagents, so return your report as your final message. `ac.json` and logs are receipts, not a report; if writing `ac.json` is refused, say so and include its full content in your final message.

## Rules

- You can't ask Justin anything, and you can't start other agents.
- Other bugs outside this story: `found_else` (one line each, evidence, severity).
- Reusable lessons: don't edit any skill or memory file; list them in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section (an empty list is the normal answer), and end your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

JSON matching `{verdict: clean|findings|integration-required, head, base, findings[{id, severity, claim, evidence}], closed[{id, closed, evidence}], rulings[{n, verdict, why}], gates[{name, exit}], ac_status[{ac, accepted, test, log, base_log, screenshot, evidence, not_run?}], ac_json, ac_check_selftest, integration, found_else[], skill_lessons[]}`.
