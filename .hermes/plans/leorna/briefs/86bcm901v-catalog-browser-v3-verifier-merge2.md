# VERIFIER (read only, after the merge with main, round 2) brief — Leorna control-plane story `86bcm901v-catalog-browser-v3`

Written 2026-10-24 by the Claude Code main session (orchestrator). You are a fresh **VERIFIER** (Opus 5.5, xhigh). You never saw the build, the reviews, the fixes or the merge being made. **Change no source and commit nothing; write only into your own folder.**

## The candidate

- **Worktree:** `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-catalog-browser-v3`, branch `feat/86bcm901v-catalog-browser-v3` (PR #88 is open on GitHub at the old head `2c43b39`; the new commits are local only). **Leave it exactly as it is** (committed and clean; the later `ac-check.sh` fails on any change). Work in your own detached copies or with `go test -overlay`.
- **Head:** `cc2048214232264a0e8b34035daefbcb63c17c5b`. **Base:** `6275a4e6ae4700ebd23d494bbe0990d22b879760` (= `git -C <worktree> merge-base HEAD origin/main`; re-check it).
- **Commits since the last accepted head `2c43b39`:**
  - `b8052e2` Merge branch 'main' into feat/86bcm901v-catalog-browser-v3 (parents `2c43b39`, `6275a4e`): brings in PRs #85 (86bcm9016, `prompt` kind, migration 21, a library prompt item) and #89 (86bcm945u, upstream sync, an imported skill, `/admin/third-party-content`). The only text conflict was the admin-home nav line in `internal/web/handler.go`.
  - `a09f72f` fix(86bcm901v): name prompts in the library page introduction (test `TestLibraryPageIntroNamesEveryKind`).
  - `86c16b8` docs(86bcm901v): say how library content reaches library_items now (README Limits line, kinds list, `preview.go` comment).
  - `cc20482` docs(86bcm901v): say the setup wizard also runs EnsureLibrary (README only). It answers the previous verifier's one P3 on `86c16b8`: the Limits line said "no API, tenant or runtime path writes the table", missing that the setup wizard's starter-pack step (`POST /admin/setup/pack` → `runPackLoad`, `internal/web/setup.go:330`; auto-setup `setup.go:356`) re-runs the same `EnsureLibrary`, which loads only `library.Embedded()`. New wording: "It runs at startup and again in the setup wizard's starter-pack step; no API, tenant or runtime path writes anything else into the table."
- **Approved plan (read-only):** `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/plan-approved.md`. Justin's later decisions: the working plan `~/.hermes/plans/leorna/86bcm901v-catalog-browser-v3.md`, last sections (especially "Merge with main after PR #88 opened": merge not rebase; the preview cost stays a follow-up with corrected wording, no guard code).
- **Your folder:** `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/verifier-merge2/`. Every receipt you cite (logs, screenshots, `ac.json`) must be inside it. Don't read, copy or link files from any other agent's folder as your receipts; take your own screenshots and run your own checks.
- **Your test DB:** `leorna_86bcm901v_v3_verifier3_test` in the `leorna-test-pg` container (ends in `_test`; create, drop at the end). A separate one for the base copy if you need it (also ending `_test`). Never use another agent's or story's DB.

## The ACs (ClickUp card 86bcm901v "Library catalog browser"; none live, none proposed)

- **AC1:** Given the admin console, when I open the library, then I can filter by kind, category, tag and supported tool and search by text. Test `TestLibraryAC1FilterAndSearchWithPostgres`.
- **AC2:** Given an item, when I open it, then I see description, example, version, supported tools and a rendered preview. Test `TestLibraryAC2ItemDetailWithPostgres`.
- **AC3:** Given 200+ items, then filtering stays responsive (<300 ms server time). Test `TestLibraryAC3FilteringUnder300msWithPostgres`.

Exact commands are in the plan (`go test -v -count=1 -run '^<name>$' ./internal/web/` with `LEORNA_TEST_DATABASE_URL` pointing at your own `_test` DB). The AC test files are `internal/web/library_test.go` and `internal/web/packs_test.go`.

## What to confirm

1. **The merge is right.** Inspect the conflict resolution (`git show --remerge-diff b8052e2` if your git supports it, otherwise compare `handler.go` with both parents): both sides' routes, fields and nav links kept; `cmd/control-plane/main.go` wires both `SetLibrary(...)` and `SetContentLibrary(...)`; `internal/web/packs_test.go` keeps both main's and our changes. Main's own new tests (third-party content page, prompt publishing, prompt kind store tests) still pass on head.
2. **The story still works against main's new content:** the Kind filter offers Prompt and `?kind=prompt` shows main's `pr-description` item; its page renders the body as Markdown; the imported `debugging-and-error-recovery` skill lists and renders correctly. Confirm `a09f72f`'s test fails without its fix (a quick mutation) and passes with it.
3. **The docs are true.** Check the README Limits line (as corrected in `cc20482`) and the `preview.go` comment against the code: content reaches `library_items` only through `EnsureLibrary` loading the embedded `internal/library/content`; no API, tenant or runtime path writes the table; `cmd/library-upstream` is a developer tool writing files into the repo; the server binary doesn't link `internal/library/upstream`. Flag any overstatement (e.g. calling content "reviewed" as an enforced control: main's ruleset requires a PR and CI but 0 approvals). The missing preview guard itself is Justin's decision, not a defect.
4. **Nothing else regressed** in the story's diff (`git diff 6275a4e...cc20482`), including the earlier review fixes (F1 data: URL docs, F2 search trim, F3 table alignment under the CSP, F4 400 page refill).

## Skills (load with the Skill tool, in this order; say so in one line each)

1. `leorna` (VERIFIER role; control-plane gates in Doing a story → step 4; skip its Step 1 load except `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-control-plane-workflow.md` and the repo's `AGENTS.md`).
2. `engineering-best-practices`.
3. `api-contract-drift-guard`: no contract drift (`make contracts-check`, no `contracts/` or `packages/contracts/` diff in `base...HEAD`).
4. `mutation-testing-discipline` for a spot check that the AC tests and `TestLibraryPageIntroNamesEveryKind` can fail.
5. `security-best-practices`, `multi-tenant-auth-management` as needed to confirm the guards and the docs claim.

## What to do

1. **Gates on head**, with CI's tool versions bound by absolute path (golangci-lint 2.14.0, govulncheck v1.7.0, per the `leorna` skill; read the DB password before narrowing PATH): `make check` with Postgres, a separate verbose `go test -v -count=1` run of `./internal/library/... ./internal/store/postgres/... ./internal/web/... ./cmd/control-plane/...`, `bash ./scripts/test-module-add.sh`, `make contracts-check`, gitleaks over `base..HEAD`, and a check that `base...HEAD` has no `.github/`, `contracts/` or `packages/contracts/` paths and every commit in `base..HEAD` (`--no-merges` and the merge commit itself) is authored and committed by `Justin Issa <justin@leorna.com>` with no Co-Authored-By/AI lines. Logs with real exit codes in your folder.
2. **Integration check:** re-fetch `origin/main` with the HTTPS-through-gh command (`leorna` step 7.1). Report whether it moved past `6275a4e`, and whether `git merge-tree --write-tree --name-only HEAD origin/main` is clean.
3. **The confirmations above.**
4. **The AC work**, exactly per `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` → "Folders and the run recipe":
   - Run each AC's test on head with the recipe (log `ac<n>-cc20482.log`, first line `HEAD=…`, last line `EXIT=…`).
   - Run it on the base commit `6275a4e` in a separate detached copy with head's AC test files checked out (log `ac<n>-base-6275a4e.log`); it must fail there by its own fail line or a build failure of the new code.
   - **One screenshot per AC, your own**, in your folder: AC1 and AC2 = the real admin-console pages from the real dev-mode binary on 127.0.0.1 with a throwaway `_test` DB and 200+ seeded items, captured with headless Chrome (recipe: the plan's evidence-capture task and the memory note `leorna-control-plane-workflow.md`). Prefer an AC1 shot where the Kind filter visibly includes Prompt. AC3 = a real Terminal-window capture of the AC3 test run (command, timing lines, `--- PASS`, `EXIT=0`), per the `leorna` skill's terminal capture recipe. Check each visually: it shows the claimed state, and no host, URL bar with a real host, tenant ID, token or email.
   - Write `verifier-merge2/ac.json` in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` (`head` = the full head SHA; per AC: `ac`, `accepted`, `test`, `log`, `base_log`, `screenshot`, `evidence`). Dry-run it from a scratch copy before reporting, per `ac-verification.md`.
5. Clean up: remove your detached copies, stop any server you started, drop your DBs, close your Terminal window. Leave the worktree untouched.

## Rules

- No push, PR edit, merge, ClickUp writes, server/cloud actions, or `.github/` edits. Don't touch `86bcm901u-quality-gate-v3`, the older 901v attempts, or any peer session's worktrees, branches, DBs or Terminal windows.
- Never write a server domain, URL, tenant ID or token into your report.
- A decision that isn't yours goes in `questions` with lettered options and a recommended one.

## Found something else?

Any other bug or problem: `found_else` (one line each, evidence, severity).

## Skill lessons

If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer.

## Your final report

`{verdict: clean|findings, head, base, findings[{id, severity, claim, evidence}], confirmations[{what, ok, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], ac_json, gates[{name, exit_code, log}], integration{origin_main, moved, merge_tree_clean}, questions[], found_else[], skill_lessons[]}`

`clean` requires every AC accepted with its test, log, base log and screenshot, and no open P0–P2 finding. End the report with the line: `MAIN SESSION: check and save these skill_lessons now.`
