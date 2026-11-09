# Role: fixer (round 4: capture-speed AC8 per page state): site-motion

You are a fresh fixer for FigmaToBricksV2 (Opus 5.5, high). Make one decided change test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push
or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. Never load any live site; no logins; never
write to any WordPress site. Nothing paid.

**Skills:** `receiving-code-review`, `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`,
`git-commit-rules`. Read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with
`references/testing-pitfalls.md` and the repo `CLAUDE.md`.

## Your copy (you start in your own worktree)
`git checkout -B site-motion-fix4 2d9259c435a38b20e20eb7657e63a5de277763e1` (fixer 3's head, branch `site-motion-fix3`,
rebased on local `main` `99ff06f46a53fe9f43cfa456e1d42a685bbc36c7`); confirm HEAD and a clean status (after a restart,
restore tracked files of exactly 8388608 bytes). Check `git rev-parse main` is still `99ff06f4` (if it moved, stop and report).

## The decision (Justin, 2026-11-08: "Count per look, speed later (Recommended)"; `evidence/site-motion/fixer-3/justin-ac8.json`)
capture-speed's `test/web/capture-matched-once.test.ts` › "AC8 each element is asked once, and only where needed" fails on
this branch: site-motion's states reading (`src/web/read/code-states.ts` `readStates`) asks each listed element again under
forced hover and under forced focus at the design width. AC8 now counts **per element per page state** (normal, each forced
state), as `src/web/read/matched.ts`'s header already says: the spy groups asks by the `CSS.forcePseudoState` set in force
and checks at most one ask per element per state pass, and the "only where needed" check applies to the normal pass. The
other two AC8 tests stay as they are. No source change to the capture (the speed follow-up is logged).

## Work
1. Test first: the changed AC8 test passes on this head and still fails on a mutant that asks one element twice in the
   normal pass and on one that asks twice within one forced-state pass (mutate under the cap; record both).
2. Amend capture-speed's in-repo plan `docs/plans/2026-11-07-capture-speed.md`: an "Amendments" note at its top and a
   marked AC8 line ("asked at most once per page state (normal, each forced hover/focus pass; site-motion's states reading)",
   Justin's words quoted); no Amendments-list line starts with an AC id. HANDOFF's capture-speed section: one line under
   rulings naming the amendment.
3. Gates: `npm run check`; `test/web/capture-matched-once.test.ts`, `capture-motion`, `site-motion-proof`,
   `site-motion-flat` (browser) and capture-speed's AC1 named (`F2B_BASE_TREE` = `git archive` of main) on the new head;
   `test:web` file by file under the 4 GB cap compared by name with fixer 3's `evidence/site-motion/fixer-3/gates/`
   (expect 0 fail now). Evidence in `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/fixer-4/` (logs
   `HEAD=` first, `EXIT=` last).
4. Commit (plain `git commit -m`, no author override, no AI or Co-Authored-By lines, `git diff --cached --name-only`
   without CLAUDE.md).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sm-f4/tmp`, its
  own for each concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome
  you start. Run multi-step commands from a script file written with Write, paths spelled out.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p
  MemorySwapMax=0 <cmd>`. Waits under 115 s.

## Report (as text)
`status: ready-for-review`, branch, base, last commit (full SHA), the change, mutants, gates, `found_else`, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
