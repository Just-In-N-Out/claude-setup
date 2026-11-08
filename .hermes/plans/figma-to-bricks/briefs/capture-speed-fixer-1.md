# Role: fixer (round 1: rebase onto main + R1-1, R1-2): capture-speed

You are a fresh fixer for FigmaToBricksV2 (Opus 5.5, high). First rebase capture-speed onto local `main` (elementor-map
has landed), then fix review 1's two P2 findings test-first, then stop at `ready-for-review`. Never edit the main folder
`/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't bump `BUILD`, leave other
worktrees alone, start no agents. **Never load bdryswi.com** (AC11 is Justin's live run); no logins; never write to any
WordPress site. Nothing paid. Nothing may hide that the importer's Chrome is automated (repo CLAUDE.md).

**Skills to load:** `receiving-code-review` (verify each finding before fixing), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`, and the repo `CLAUDE.md`.

## Inputs
- Work in `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a37633bdd2f67cfdd`, branch `capture-speed-build`,
  head `d2174dcc4c39bb5e28bde959ef65ef8afb9310e1`, base `9b2488186cd3a83a3df0f5df3abd0d3c8ab8e96c`.
- New base: local `main` at `7ff9ba4aa7f03e3c761a8814fb1ad4021dd51373` (Build 2026-11-08.1, elementor-map merged; check
  `git rev-parse main`; if it differs, use it and say so). elementor-map changed `src/web/` capture code (hidden parts of
  shown elements, `marks`), so expect overlaps in `src/web/read/` and the capture.
- Plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-speed/plan-approved.md`.
- Review: `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-speed/review-1/review.json` (R1-1, R1-2 P2; R1-3, R1-4 P3).

## Work
1. `git rebase main`. Keep both sides' meaning on any conflict (HANDOFF sections both stay; elementor-map's hidden-parts
   reading must survive your matched-styles changes, and AC1/AC2 "captures as it did before" now means as main does). Record
   each conflict and resolution in the ledger. Rerun AC1 (named, `F2B_BASE_TREE` = a `git archive` of the new main) and AC8,
   plus elementor-map's capture tests (`test/web/capture-hidden-parts.test.ts` and the elementor web tests); stop and report
   if anything new fails.
2. **R1-1:** while any session is waiting for a person ("I am human"), no other range's reading may raise its window over
   that one (`session.ts` `still`/`front`, `human.ts`). General rule, smallest fix (e.g. a shared "a person is needed" flag
   that holds other sessions' `bringToFront`, and/or the waiting tab raised again on each poll). Test first: a web test in a
   visible-mode stand-in (or the CDP calls recorded) where one range meets a check while others read, RED on the rebased
   head, then GREEN; mutate the guard.
3. **R1-2:** `PageUnreachable` in `tools/lib/capture-pages.ts` handled like `HumanCheckFailed`: one plain line
   (`e.message`, no stack) and `stopped` with `--all`, so no later page retries against a dead connection. Test first (the
   CLI's output and the remaining pages not tried), RED then GREEN.
4. Put R1-3 and R1-4 in `evidence/capture-speed/follow-ups.md` and HANDOFF "Deferred".
5. Gates before stopping: both typechecks, `npm run check`, `npm run corpus`, `npm run test:web` and `npm run test:browser`
   file by file, compared by name with the new main (run main's side too). Rerun AC3's timing (base = new main, same run)
   under the 6G cap.
6. Commit after each passing step (plain `git commit -m`, no author override, no AI or Co-Authored-By lines,
   `git diff --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-speed/fixer-1/` (logs with `HEAD=` first, `EXIT=` last).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/cs-f/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run Chrome too. Close every Chrome you
  start (kill by its profile path if Node dies).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); B-Dry 4-window runs under `systemd-run --user --scope -p MemoryMax=6G -p MemorySwapMax=0`,
  everything else 4G; mutation runs always capped.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, new base SHA, last commit (full SHA), the rebase conflicts, per finding: verified?,
fix, test, RED/GREEN paths, mutation, gates vs main, AC3 times, `found_else`, then `skill_lessons[{skill, lesson,
evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
