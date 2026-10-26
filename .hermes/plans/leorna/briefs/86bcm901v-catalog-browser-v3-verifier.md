# VERIFIER (read only) brief — Leorna control-plane story `86bcm901v-catalog-browser-v3`

Written 2026-10-24 by the Claude Code main session (orchestrator). You are a fresh **VERIFIER** (Opus 5.5, xhigh). You never saw the build, the reviews or the fixes being made. **Change no source and commit nothing; write only into your own folder.**

## The candidate

- **Worktree:** `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-catalog-browser-v3`, branch `feat/86bcm901v-catalog-browser-v3`. **Leave it exactly as it is** (committed and clean; the later `ac-check.sh` fails on any change). Do your work in your own detached copies or with `go test -overlay` (no files written into the worktree).
- **Head:** `2c43b3941ced883c8d4aa6f7bad7913a9043c173`. **Base:** `6e74ced843642439d1dac9f25673440fb0f285f5` (= `git -C <worktree> merge-base HEAD origin/main`; re-check it).
- **Approved plan (read-only):** `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/plan-approved.md`. Justin's later decisions: the working plan `~/.hermes/plans/leorna/86bcm901v-catalog-browser-v3.md`, last sections ("Away grant", "Decisions applied under the away grant").
- **Your folder:** `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/verifier/`. Every receipt you cite (logs, screenshots, `ac.json`) must be inside it. Don't read, copy or link files from any other agent's folder as your receipts; take your own screenshots and run your own checks.
- **Your test DB:** `leorna_86bcm901v_v3_verifier_test` in the `leorna-test-pg` container (ends in `_test`; create, drop at the end). A separate one for the base copy if you need it (also ending `_test`). Never use another agent's or story's DB.

## The ACs (ClickUp card 86bcm901v "Library catalog browser"; none live, none proposed)

- **AC1:** Given the admin console, when I open the library, then I can filter by kind, category, tag and supported tool and search by text. Test `TestLibraryAC1FilterAndSearchWithPostgres`.
- **AC2:** Given an item, when I open it, then I see description, example, version, supported tools and a rendered preview. Test `TestLibraryAC2ItemDetailWithPostgres`.
- **AC3:** Given 200+ items, then filtering stays responsive (<300 ms server time). Test `TestLibraryAC3FilteringUnder300msWithPostgres`.

Exact commands are in the plan (`go test -v -count=1 -run '^<name>$' ./internal/web/` with `LEORNA_TEST_DATABASE_URL` pointing at your own `_test` DB). The AC test files are `internal/web/library_test.go` and `internal/web/packs_test.go`.

## Findings the fixes had to close (confirm each, and look for regressions they caused)

- **Review 1 (on 1571fcd, all P3), fixed in `8886bfc`, `3411814`, `9787a33`, `266603e`:**
  - F1: docs claimed goldmark empties every `data:` URL; it keeps `data:image/png|gif|jpeg|webp|svg+xml`. Fixer: corrected the `preview.go` comment and `internal/web/README.md`, pinned the behaviour with `TestRenderMarkdownKeepsDataURLsOnlyForImageTypes`.
  - F2: no test pinned trimming of the search text. Fixer: subtest `search_ignores_surrounding_spaces` (`?q=++review+`).
  - F3: table alignment used inline `style=` blocked by the nonce-only admin CSP. Fixer: goldmark `TableCellAlignAttribute` plus `.markdown [align=…]` rules in the nonce'd `libraryCSS`.
  - F4: a 400 page cleared the admin's input. Fixer: `libraryFormFilter` refills valid choices and a valid (escaped) search.
- **Review 2 (on 266603e):** clean; one P3: the Markdown preview's worst-case cost (goldmark pads short table rows to the header's column count; a 16 KB table → 80 MB HTML / 1.8 GiB). **Decision (Justin's away grant, reviewer's recommendation A): follow-up, no guard code**, recorded as a README "Limits" line in `2c43b39`. Check that line is accurate; don't treat the missing guard as a defect of this story.

## Skills (load with the Skill tool, in this order; say so in one line each)

1. `leorna` (VERIFIER role; control-plane gates in Doing a story → step 4; skip its Step 1 load except `leorna-control-plane-workflow.md` and the repo's `AGENTS.md`).
2. `engineering-best-practices`.
3. `api-contract-drift-guard` — the story's Agent Defect Loop skill: re-run its Required Validation Gates (no contract drift: `make contracts-check`, no `contracts/` / `packages/contracts/` diff).
4. `mutation-testing-discipline` for a spot check that the AC tests can fail.
5. `security-best-practices`, `multi-tenant-auth-management` as needed to confirm the guards.

## What to do

1. **Gates on head**, with CI's tool versions bound by absolute path (golangci-lint 2.14.0, govulncheck v1.7.0, per the `leorna` skill): `make check` with Postgres, a separate verbose `go test -v` run, `bash ./scripts/test-module-add.sh`, `make contracts-check`, story-range gitleaks, and a check that `base...HEAD` has no `.github/`, `contracts/` or `packages/contracts/` paths and every commit author is `Justin Issa <justin@leorna.com>`. Logs with real exit codes in your folder.
2. **Confirm each finding above is closed** and look for regressions.
3. **Integration check (information, not a blocker):** fetch `origin/main` with the HTTPS-through-gh command (`leorna` step 7.1). Report whether it moved past `6e74ced`, and whether `git merge-tree --write-tree --name-only HEAD origin/main` is clean.
4. **The AC work**, exactly per `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` → "Folders and the run recipe":
   - Run each AC's test on head with the recipe (log `ac<n>-<head7>.log`, first line `HEAD=…`, last line `EXIT=…`).
   - Run it on the base commit in a separate detached copy with head's AC test files checked out (log `ac<n>-base-<base7>.log`); it must fail there by its own fail line or a build failure of the new code.
   - **One screenshot per AC, your own**, in your folder: AC1 and AC2 = the real admin-console pages from the real dev-mode binary on 127.0.0.1 with a throwaway DB and 200+ seeded items, captured with headless Chrome (the recipe is in the plan's B12 and the shared memory note `leorna-control-plane-workflow.md`); AC3 = a real Terminal-window capture of the AC3 test run (command, timing lines, `--- PASS`, `EXIT=0`), following the `leorna` skill's terminal capture recipe. Check each visually: it shows the claimed state, and no host, URL bar with a real host, tenant ID, token or email.
   - Write `verifier/ac.json` in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` (`head` = the full head SHA; per AC: `ac`, `accepted`, `test`, `log`, `base_log`, `screenshot`, `evidence`).
5. Clean up: remove your detached copies, stop any server you started, drop your DBs. Leave the worktree untouched.

## Rules

- No push, PR, merge, ClickUp writes, server/cloud actions, or `.github/` edits. Don't touch `86bcm901u-quality-gate-v3`, the older 901v attempts, or any peer session's worktrees, branches, DBs or Terminal windows.
- Never write a server domain, URL, tenant ID or token into your report.
- A decision that isn't yours goes in `questions` with lettered options and a recommended one (Justin is away; the orchestrator applies recommendations).

## Found something else?

Any other bug or problem: `found_else` (one line each, evidence, severity).

## Skill lessons

If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer.

## Your final report

`{verdict: clean|findings, head, base, findings[{id, severity, claim, evidence}], findings_closed[{id, closed, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], ac_json, gates[{name, exit_code, log}], integration{origin_main, moved, merge_tree_clean}, questions[], found_else[], skill_lessons[]}`

`clean` requires every AC accepted with its test, log, base log and screenshot, and no open P0–P2 finding. End the report with the line: `MAIN SESSION: check and save these skill_lessons now.`
