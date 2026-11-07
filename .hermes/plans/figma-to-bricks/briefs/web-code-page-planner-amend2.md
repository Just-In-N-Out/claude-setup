# Role: planner (amendment 2): web-code-page

You are a fresh planner for FigmaToBricksV2 (Opus 5.5, xhigh). Plan only: no product code, no BUILD bump, no merge, no
push, never start other agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` (read it only), never
bare `git stash`, leave other worktrees alone. Never load bdryswi.com; no logins; never write to any WordPress site.

**Skills to load:** the project skill `figma-to-bricks` (with `references/testing-pitfalls.md` and
`references/live-site-reading.md`), `engineering-best-practices`, `implementation-planning`.

## Where you work
The job's copy: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a631038f87d3d7d43`, branch
`web-code-page-build`, head `95097213` (built, reviewed twice, verified: 16 of 17 runnable ACs accepted). Its plan:
`docs/plans/2026-11-04-web-code-page.md` (approved copy, read-only:
`~/.hermes/plans/figma-to-bricks/evidence/web-code-page/plan-approved.md`, AC1–AC19 with Amendment 1).

## Write Amendment 2 (keep every AC id; change only what is listed)
1. **AC2, the slider clause:** write in Justin's ruling of 2026-11-06
   (`~/.hermes/plans/figma-to-bricks/evidence/web-code-page/justin-q4-slider.md`): a slider keeps all its own slides; only the
   copies its script makes for looping (paths with `~`) are left out. It replaces Q4 A for sliders. Say where the named test
   checks it (read `test/unit/site-kinds.test.ts`).
2. **AC3, basic mode vs the proof's golden:** the reset class is now named after its rules (`site-reset-<4 letters>`,
   `src/core/site/classes.ts` `versioned`, review 1 finding R1-3, commit `28927555`) and leaves svg parts' paint to the parts
   (R1-1, `f27f5451`); state that the golden comparison swaps that class in (read `test/unit/site-text.test.ts`).
3. **AC8 stays as written** (`npm run capture` finds Chrome as the helper does, no `CHROME_PATH` on the desktop). The builder
   brief handed that clause to web-capture-steady, which is parked; this job now builds it. Add a task: `tools/capture.ts`
   uses `tools/lib/helper-chrome.ts` `findChrome` (no second finder), with a test (name it) that runs with `CHROME_PATH` unset.
   Note that web-capture-steady (branch `web-capture-steady-build`, parked) touches the same file and will rebase on it.
4. **New AC20 (proposed): bold and italic look as on the site.** The verifier found (evidence
   `~/.hermes/plans/figma-to-bricks/evidence/web-code-page/verifier/logs/finding-bold-head.log` and `verifier/finding-bold/`):
   when a site ships one regular font file and Chrome synthesizes bold/italic from it, the capture lists the used faces
   (700, 700 italic) with that same file and `site-fonts` declares the file at those weights, so Chrome stops synthesizing
   and the paste draws thin upright text (h1 glyph ink 7077 pasted vs 9342 site). The 2 px check can't see it (synthesized
   faces keep widths). Root cause with file:line (read `src/core/site/` fonts and the capture's `web.fonts` reader), the
   general rule (declare a file only at the weight/style it really is, e.g. from the face's own descriptors or the file
   itself; never for a face Chrome synthesized), and one named test that compares glyph ink per heading and bold/italic run,
   site vs paste, on the generic fixture (it must fail on head `95097213`). Check B-Dry's saved page is unaffected (its
   AC9 run stays within 2 px).
Update the tasks list so a fresh fixer knows exactly what to build (AC8's finder and AC20), test-first. Commit the plan
change on the branch (`git commit -m "web-code-page plan amendment 2: …"`, no CLAUDE.md staged, no author override).

## Return
The plan path and commit SHA, the changed and new ACs one line each, any `(live)` ones, questions with ⭐ answers,
`verdict`, `ac_status: n/a (plan)`.

**skill_lessons rule:** list reusable lessons in `skill_lessons[{skill, lesson, evidence, enforce}]` (enforce: `none` or a
one-line check proposal); never edit skills or memory. Empty is normal. Don't write report files: return text. End with
`MAIN SESSION: check and save these skill_lessons now.`
Desktop memory: SIGTERM/143/137/"Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
sending`); cap heavy runs with `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
