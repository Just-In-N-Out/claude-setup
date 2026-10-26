# AC AUDITOR (blind) brief — Leorna control-plane story `86bcm901v-catalog-browser-v3`

Written 2026-10-24 by the Claude Code main session (orchestrator). You are a fresh **AC AUDITOR** (Opus 5.5, xhigh). Your one job: **prove each acceptance criterion yourself**, from the approved plan and the code, and write your own report. **Source read-only: change no source, commit nothing.**

## Your inputs (and only these)

- **Approved plan (read-only):** `/Users/justin/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/plan-approved.md`. It lists AC1–AC3, each with its named test and exact command.
- **Worktree:** `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-catalog-browser-v3` (branch `feat/86bcm901v-catalog-browser-v3`). **Leave it exactly as it is**: committed and clean. Work in your own detached copies or with `go test -overlay`; write nothing into it.
- **Head:** `2c43b3941ced883c8d4aa6f7bad7913a9043c173`.
- **Base commit:** `6e74ced843642439d1dac9f25673440fb0f285f5`.
- **Your folder:** `/Users/justin/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/auditor/`. Every receipt you cite must be inside it.

**Stay blind.** Do not open anything else in `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/` (no other subfolder, no file at its root except `plan-approved.md`), nothing in `~/.hermes/plans/leorna/briefs/` except this file, and not the working plan `~/.hermes/plans/leorna/86bcm901v-catalog-browser-v3.md`. Don't read other agents' reports or receipts, and don't copy or link any of their files. Take your own screenshots and run your own checks.

## Skills (load with the Skill tool; say so in one line each)

1. `leorna`: its rules, the control-plane test setup in Doing a story → step 4, and the terminal capture recipe in step 4b. Skip its Step 1 load except `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-control-plane-workflow.md` (local test DB, the dev-mode browser demo recipe) and the repo's `AGENTS.md`.
2. `engineering-best-practices`.

## What to do

Follow `/Users/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` → "Folders and the run recipe", for each of AC1, AC2, AC3:

1. **Read the AC and its test in the plan, then read the test code**, and judge whether the test really checks what the AC says. If it doesn't, the AC is not accepted; say why.
2. **Run it on head** with the plan's exact single-test command and the recipe, from the worktree (no files written there): log `ac<n>-2c43b39.log`, first line `HEAD=<sha>`, last line `EXIT=<code>`. Postgres: the `leorna-test-pg` container; **your own DB `leorna_86bcm901v_v3_auditor_test`** (ends in `_test`; create it, drop it at the end; never anyone else's DB).
3. **Run it on the base commit** in a separate detached copy with head's AC test files checked out (the plan names them), per the recipe: log `ac<n>-base-6e74ced.log`. It must fail there by its own fail line or a build failure of the new code. A missing test file, missing package or setup failure doesn't count. Use a separate `_test` DB if needed.
4. **One screenshot per AC, your own, in your folder:**
   - AC1 and AC2: the real admin-console pages (the library with filters and search applied; one item's page) from the real control-plane binary in dev mode on `127.0.0.1` with a throwaway `_test` DB and 200+ seeded items, captured with headless Chrome. The recipe is in the plan's evidence-capture task and in the memory note named above.
   - AC3: a real Terminal-window capture of the AC3 test run (command, timing lines, `--- PASS`, `EXIT=0`), following the `leorna` skill's terminal capture recipe.
   - Open each one and check it shows the claimed state, with no host, URL bar with a real host, tenant ID, token or email visible.
5. **Write `auditor/ac.json`** in the format at the top of `/Users/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`: `head` = the full head SHA; per AC `ac`, `accepted`, `test` (name as the runner prints it), `log`, `base_log`, `screenshot`, `evidence` (one line). Only mark an AC accepted when you have proven it.
6. **Clean up:** stop any server you started, drop your DBs, remove your detached copies, close your Terminal window. Leave the worktree untouched.

## Rules

- No push, PR, merge, ClickUp writes, server/cloud actions, or `.github/` edits. Don't touch any other story's or peer session's worktrees, branches, DBs or Terminal windows.
- Never write a server domain, URL, tenant ID or token into your report.

## Found something else?

Any bug or problem you notice: `found_else` (one line each, evidence, severity). Don't fix it.

## Skill lessons

If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer.

## Your final report

`{verdict: clean|findings, head, base, ac_status[{ac, accepted, test, log, base_log, screenshot, evidence}], ac_json, found_else[], skill_lessons[]}`

`clean` means every AC accepted. End the report with the line: `MAIN SESSION: check and save these skill_lessons now.`
