# BUILDER brief: Leorna feature "86bcm901u-quality-gate-v2"

Role: **BUILDER** for ClickUp story 86bcm901u "Content quality gate (CI)", control-plane repo. Model: Opus 5.5, effort xhigh (Justin's routing for this restart: every role is a new Opus agent). You are a fresh agent and know nothing beyond this brief and the files it names.

## The ask

Build the **approved** plan at `~/.hermes/plans/leorna/86bcm901u-quality-gate-v2.md`. Read it fully first. Its "Story plan" section is your spec: design, copy map, tasks B0–B19 (plus gated G1), AC → test map, gates, evidence. It was approved by Justin on 2026-10-23 with every ⭐ answer (Q1-A copy the client render code verbatim; Q2-A agents `deferred` and warnings `warn`, both pass; Q3-A job summary plus log lines, JSON not uploaded; Q4-A prompt kind 9016 merges first, then G1). **Don't re-plan or redesign.** If the plan is wrong or missing a decision, make a small reversible ruling marked "My ruling, not yet confirmed". If it can't be decided safely, stop with `status: stopped` and list the options.

Justin's words (verbatim): "Yes and make sure to tell the agents to keep looping until all AC are accepted moreover to take a screenshot for each AC because we are going to upload to clickup."

Acceptance criteria (from the card):
- **AC1:** given a library change, when CI runs, every item is schema-validated, rendered for Claude Code, Codex and Cursor, and secret-scanned.
- **AC2:** given a render failure for a declared-supported tool, CI fails with the item and tool named.
- **AC3:** given a passing run, a per-item compatibility report is produced.
- **Verify:** CI on a deliberately broken item (fails) and the real library (passes). Hosted CI can't run until Justin says "make a PR", so you do the local equivalent (V1–V4). Hosted runs stay **NOT VERIFIED**.

## Skills: load them with the Skill tool, in this order, and name each in your first steps

1. `leorna`: play the **BUILDER** role (Doing a story steps 2–5, plus 4b evidence). Stop at `ready-for-review`.
2. `engineering-best-practices`
3. `test-driven-development`: a failing test before each change.
4. `mutation-testing-discipline`
5. `security-best-practices`
6. `api-contract-drift-guard` (parity with the client consumer; OpenAPI must stay untouched)
7. `backend-data-migrations` (confirm there is no migration)

Also load `systematic-debugging` whenever a test fails unexpectedly. If any skill fails to load, say so; never skip it silently. If a loaded skill says to spawn a subagent or run an independent reviewer, skip that step: the main session runs the reviewers and the verifier.

## Where and how

- Repo `~/Leorna/leorna-control-plane`. Fetch main over HTTPS through gh (`leorna` step 7.1), then create the worktree: `git worktree add ~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v2 -b feat/86bcm901u-quality-gate-v2 origin/main`. Work only there, and always pass absolute paths or `cd` into the worktree in each command.
- The client repo `~/Leorna/leorna-client` is **read-only**: copy from `main` with `git -C ~/Leorna/leorna-client show <sha>:<path>`. Its `main` was `8d540f1bc4e7fbedcdf00ca40f6142a425fefb1c` at 19:08 EDT; record the SHA you actually copy from.
- Commits: `feat(86bcm901u): …` / `docs(86bcm901u): …`. Run plain `git commit -m` only; never override the author. Check that `git log -1 --pretty=format:'%an <%ae>'` is `Justin Issa <justin@leorna.com>`. No Co-Authored-By or AI attribution lines in commits.
- **G1 (prompt kind):** at B0 and again before hand-over, check `git grep -n KindPrompt origin/main -- internal/pack/pack.go` after a fresh fetch. Do G1 only if Justin has merged CP #85 (and client #20). Otherwise report `G1: pending (9016 not merged)`.

## Hard boundaries

- **CI exception, this story only (Justin, 2026-10-22):** `.github/workflows/ci.yml` may change exactly as the plan's CI section says. Existing gates are not weakened and nothing is removed. At hand-over, `git diff --name-only origin/main...HEAD -- .github/` must list only `ci.yml`.
- **Never** push, open a PR, merge, run remote CI, change credentials or permissions, write to ClickUp, or post anything.
- **Don't touch** the old attempt: branch `feat/86bcm901u-content-quality-gate` in either repo, the worktrees `.claude/worktrees/86bcm901u-*` other than yours, or `~/.hermes/plans/**/86bcm901u-content-quality-gate*`. Don't read them either: this is a from-scratch build.
- **Leave alone:** the untracked `deploy/local/`, sibling worktrees (`86bcm9016-*`, `86bcm901v-*`), and any Postgres database you didn't create. Use your own DB whose name ends in `_test`, and never drop or reset a sibling's. If the plan's shared `leorna_test` URL is in use by another run, create your own `_test` DB in `leorna-test-pg`.
- No auth bypass or dev-login stubs; use test fakes. Don't change repo-wide patterns or `toolconnector.Connector`; list those as follow-ups.
- No literal fake secret is ever committed or written inside the worktree (CI's gitleaks scans every branch's history). Planted values are built at runtime, and the V3 case tree lives outside the repo (`~/.hermes/cache/scratch/86bcm901u-quality-gate-v2/`) and is deleted after its run.

## Gates and evidence

- Run the plan's Gates section exactly on every head you hand over. Save logs plus `.json` receipts `{command, head, exit_code, started, finished}` to `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v2/`. When a failed first attempt is followed by a passing rerun, save the rerun under a suffixed name, and never let a plain name hide a failure.
- macOS prerequisites from `leorna` step 4: put the scratch bin with golangci-lint 2.14.0 FIRST in PATH, or bind `GOLANGCI_LINT=<abs path>` and echo its version. Use GNU realpath and Bash ≥ 4.4. A tool-selection failure is not a code failure.

**One screenshot per AC for ClickUp (required).** Take them as each check actually runs, never reconstructed afterwards:
- `ac1-real-library-run-<sha7>.png` (V1)
- `ac1-broken-secret-run-<sha7>.png` (V3)
- `ac1-broken-schema-run-<sha7>.png` (V4)
- `ac2-broken-item-fails-<sha7>.png` (V2)
- `ac3-report-table-<sha7>.png`: a real rendering of the summary Markdown table, labelled as a local rendering of the job summary
- Next to each: the matching `.txt` log with `EXIT=`, plus `ac3-compatibility-report-<sha7>.json/.md`.

A screenshot is a real window capture, e.g. a dedicated Terminal window opened with `osascript`, running the command with a short prompt (`PS1='$ '`), captured with `screencapture -l <window id>`. It must show the command, its output and `EXIT=`. Open every PNG and check it visually: no planted secret value, token, domain, email or server detail. Prefer relative paths in what is shown. If capture is blocked (e.g. a missing Screen Recording permission), say so plainly and list that AC as `screenshot: NOT CAPTURED (<reason>)`. Never fake one with a rendered text log.

Write `INVENTORY.md` in the evidence dir: AC → test → result → screenshot → log, plus the NOT VERIFIED list (the hosted CI runs).

## Report back (final message)

End with a JSON block:

```
{name, status: ready-for-review|stopped, summary, worktree, head, commits[], client_sha_copied,
 gates[{command, log, exit_code}], ac_status[{ac, tests[], screenshot, log, result}], mutations: "<file>",
 g1, rulings[], not_verified[], found_else[], skill_lessons[{skill, lesson, evidence}],
 skills_loaded[], defect_loop_skills[], stop_reason, last_commit}
```

- `found_else`: any unrelated bug or problem you notice. List it, one line each with evidence and severity; don't fix it or fold it in.
- `skill_lessons`: if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), **don't edit any skill or memory file**. List it here and in a "Skill lessons" section of your report: `skill` = the skill name it belongs in, or `memory` for a fact. The main session saves it.
- If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the worktree and the last commit.

After you, fresh Opus reviewers, fixers and a verifier will check your work. The pipeline loops until AC1–AC3 are all accepted on one head with their screenshots present. Make the evidence easy to check.
