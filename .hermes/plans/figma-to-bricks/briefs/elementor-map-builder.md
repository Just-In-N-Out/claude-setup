# Role: builder: elementor-map (Phase A now, Phase B later)

You are a fresh builder for FigmaToBricksV2 (Opus 5.5, xhigh at Justin's word). Build the approved plan test-first and
stop at the point named below. Never touch the main folder `/home/justin/Documents/FigmaToBricksV2` (read it only), never
bare `git stash`, never push or merge into main, don't bump `BUILD`, leave every other worktree alone (read other branches
with `git show <branch>:<path>`), start no agents. Never load bdryswi.com; no logins; GET-only reads of Justin's Hostinger
site (`?f2b=`) if the plan needs them; never write to any WordPress site.

**Skills to load:** `engineering-best-practices`, `test-driven-development`, plus `mutation-testing-discipline` for guards;
read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with
`references/testing-pitfalls.md` and `references/live-site-reading.md`, the repo `CLAUDE.md` and `reference/bricks/README.md`.

## The plan (approved under the standing auto-go, ⭐ Q1–Q8 taken)
- Read-only copy: `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/plan-approved.md` (AC1–AC10; AC9 and
  AC10 live, Justin's). Use each AC's exact test name. Planner's probes: `evidence/elementor-map/planner/`.
- Your copy: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a93c32bbf9bbc5ed4`, branch
  `worktree-agent-a93c32bbf9bbc5ed4` (plan commit `3e0a435f` on main `ea504778`).
- **Dependency:** web-code-page is being built right now by another builder in `agent-a631038f87d3d7d43` (branch
  `web-code-page-build`; it is rebasing onto main `ea504778` first). Its Amendment 1 stores Elementor markers in
  **`CodeNode.marks`** (and over-long values in `WebCode.capped`), **not** in `CodeNode.attrs` as this plan assumed: Task 0's
  check applies, adapt `markersOf` to `marks` (read `git show web-code-page-build:docs/plans/2026-11-04-web-code-page.md`,
  "Amendment 1").
- **Start point:** instead of the plan's `git merge --ff-only`, bring your branch onto web-code-page's head with
  `git rebase web-code-page-build` (your plan commit on top) once `git merge-base --is-ancestor main web-code-page-build`
  is true (its rebase done). If it isn't yet, do Phase A work that doesn't need it and rebase later. Record the base SHA.

## Work
1. Ledger `.superpowers/sdd/2026-11-06-elementor-map/progress.md` (commit it); T0 baselines as the plan says.
2. **Phase A (Tasks 0–4) now.** Each task test-first: RED saved, then GREEN; commit after each passing task (plain
   `git commit -m`, no author override, no AI or Co-Authored-By lines, no CLAUDE.md staged).
3. **Then stop and report `status: phase-a-done`** with what Phase B needs from web-code-page (which of its tasks, by
   number). The main session resumes you for Phase B when they land; don't wait idle.
4. Evidence in `E/builder/` (E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map`): per AC its test log
   (`HEAD=` first, `EXIT=` last, skipped 0), a picture or terminal capture, RED logs.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/em-b/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your own at a time, closed after each
  step. The worktree's `node_modules` may lack `.bin`: see testing-pitfalls.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; mutation
  runs always capped.
- Write scripts with Write and run `bash <file>` / `python3 -I <script>`; git commands as separate plain calls.

## Report (as text; don't write report files)
`status`, branch and last commit (full SHA), base SHA, per task one line, per AC its test, RED/GREEN and evidence paths,
gates, `found_else`, then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit
skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
