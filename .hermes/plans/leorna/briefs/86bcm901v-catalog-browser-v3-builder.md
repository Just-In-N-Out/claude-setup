# BUILDER brief — Leorna control-plane story `86bcm901v-catalog-browser-v3`

Written 2026-10-24 by the Claude Code main session (orchestrator). You are a fresh **BUILDER** (Opus 5.5, xhigh). Build the approved plan test-first and stop at `ready-for-review`.

## The approved plan

- **Read and follow:** `/Users/justin/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/plan-approved.md` (read-only copy; the working copy is `~/.hermes/plans/leorna/86bcm901v-catalog-browser-v3.md`, identical at approval).
- It is approved with every ⭐ answer (**Q1A–Q8A**; see its "Justin's answers" section at the end): HTML-only pages (OpenAPI unchanged), newest version per item, goldmark v1.7.17 for the Markdown preview with raw HTML off, single-value AND filters, dev-mode screenshots on 127.0.0.1 with headless Chrome, AC3 timing in-test (median of 3, 240 items).
- **AC1–AC3** are the card's ACs, none live or proposed. Each has its named test and exact single-test command in the plan.
- **You never redesign.** If the plan is wrong, missing a decision, or a step can't work as written, stop with `status: stopped` and say exactly what and why; the fix goes back to a planner. Small mechanical deviations (a renamed helper, an import) are fine; list every one under `deviations`.

### Justin's words (verbatim)

> Hey, I need to do a user story. Make sure that you're taking photos for each acceptance criterion. … Library catalog browser

> do a v3

He picked the Full pipeline and "Keep going like v2" (⭐ answers count as his through the hand-over).

## Skills (load with the Skill tool, in this order; say so in one line each)

1. `leorna`, in the **BUILDER** role (Doing a story → steps 2–5 and 4b; you may skip its Step 1 context load except `leorna-control-plane-workflow.md`, `clickup-evidence.md` and the repo's `AGENTS.md`).
2. `engineering-best-practices`.
3. `test-driven-development`: a failing test before each change.
4. `mutation-testing-discipline`: for the guards (admin-only routes, tenant fail-closed store reads, the HTML-safety of the preview). The plan's B10 lists the mutations.
5. Specialists: `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard` (confirm no contract drift: no `contracts/` or `packages/contracts/` diff; contracts check green).
6. `systematic-debugging` whenever a test fails unexpectedly or a gate gets worse: find the cause, don't patch around it.

## Branch, worktree, evidence

- **Branch:** `feat/86bcm901v-catalog-browser-v3`, created from **updated `origin/main`** (planned against `6e74ced`). Fetch first with the HTTPS-through-gh command in `leorna` step 7.1. If `origin/main` has moved past `6e74ced`, base on the new tip and note it in your report (and check the plan still applies; stop if it doesn't).
- **Worktree:** `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-catalog-browser-v3` (`git -C ~/Leorna/leorna-control-plane worktree add -b feat/86bcm901v-catalog-browser-v3 <path> origin/main`). Don't touch the main working tree (it has untracked `.claude/` and `deploy/local/`, which stay as they are).
- **Commits:** `feat(86bcm901v): …`, plain `git commit -m` (identity `Justin Issa <justin@leorna.com>` comes from git config; check with `git log -1 --pretty=format:'%an <%ae>'`). Never override author metadata, no AI attribution or Co-Authored-By lines, never commit `CLAUDE.md`.
- **At the end the worktree must be committed and clean** (`git status --porcelain` empty, no untracked files): the later `ac-check.sh` fails on any. Keep scratch outside the worktree.
- **Evidence folder:** `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/` (your files at its root; never write into `verifier/` or `auditor/`; never modify `plan-approved.md`).
- **Your test database:** `leorna_86bcm901v_v3_test` in the `leorna-test-pg` container (name ends in `_test`). Never use, reset or drop another agent's or story's DB.

## What you deliver

1. Plan tasks **B0–B13**, test-first, in order.
2. **One test per AC**, named exactly as in the plan, runnable alone with its command, passing on head. Confirm the plan's claim that each fails on the base commit (build failure because the new code is missing) by running it there per `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (separate detached worktree in your scratchpad, removed afterwards).
3. **One screenshot per AC** (Justin wants a photo for every AC; they go to ClickUp), per plan B12 and `leorna` step 4b:
   - `ac1-library-filtered.png`, `ac2-item-detail.png`: the real admin-console pages from the real dev-mode binary on 127.0.0.1 with the seeded items, captured as the check runs.
   - `ac3-timing-terminal.png`: a real Terminal-window capture of the AC3 test run (command, output, exit code), plus its log.
   - Before-state shots where the plan asks for them.
   - **Open every screenshot and check it visually**: it shows the claimed state, and no server domain, URL bar with a real host, tenant ID, token, device code or email is visible. A staged screenshot that claims an unrun check never counts. If the dev-mode binary won't start, stop and report (plan B12), don't substitute.
4. **Gates on the final head** (plan B11 and "Gates the builder, reviewers, verifier and auditor run"): `make check` with Postgres (`-v` evidence in a separate `go test -v` run), `bash ./scripts/test-module-add.sh`, CI's golangci-lint version bound by absolute path as the `leorna` skill says, the contracts check, govulncheck/audit for the new dependency. Save per-head logs `gates-<sha7>.txt` with real exit codes. Read each log before citing it.
5. The plan's mutation checks (B10), with receipts.
6. README note and the plan's Docs & records items that belong to the build (not `delivery/stories.json`: that comes after a PR exists).

## Hard rules

- No push, PR, merge, ClickUp writes, server/cloud actions, or `.github/workflows/*` edits (no CI exception for this story).
- No auth bypass or dev-login stub in code; the existing gated dev mode is used only locally for screenshots. Don't change repo-wide patterns or `toolconnector.Connector`.
- **Other work in this repo:** `86bcm901u-quality-gate-v3` (another session) and the superseded 901v attempts (`feat/86bcm901v-library-catalog-browser`, `feat/86bcm901v-catalog-browser-v2` and their worktrees). Don't touch any of them, or any peer session's worktrees, branches or databases.
- Never write a server domain, URL, tenant ID or token into code, logs you cite, or the report.

## Found something else?

If you find any other bug or problem along the way, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity).

## Skill lessons

If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill it belongs in (or `memory` for a fact). An empty list is the normal answer. One specific thing to report either way: whether the plan's dev-mode headless-Chrome screenshot recipe worked end to end on the real binary (the planner proved only its parts).

## Your final report

`{status: ready-for-review|stopped, stop_reason, branch, worktree, base_sha, head_sha, commits[], ac_status[{ac, test, command, head_result, base_result, screenshot, log}], gates[{name, exit_code, log}], mutations[{guard, result, receipt}], deviations[], diff_stat, found_else[], skill_lessons[]}`

End the report with the line: `MAIN SESSION: check and save these skill_lessons now.`
