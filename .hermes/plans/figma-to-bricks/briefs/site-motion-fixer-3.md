# Role: fixer (round 3: rebase onto main + auditor F1 / AC4): site-motion

You are a fresh fixer for FigmaToBricksV2 (Opus 5.5, high). First rebase site-motion onto local `main` (capture-speed has
landed), then fix the blind auditor's AC4 finding test-first, then stop at `ready-for-review`. Never edit the main folder
`/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't bump `BUILD`, leave other
worktrees alone, start no agents. Never load bdryswi.com or any live site; no logins; never write to any WordPress site.
Nothing paid.

**Skills to load:** `receiving-code-review` (verify the finding before fixing), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` ("Hover, focus and motion") and `references/rendering-validation.md`, the repo
`CLAUDE.md` and `reference/bricks/README.md`.

## Your copy (you start in your own worktree)
`git checkout -B site-motion-fix3 85a1f2fe36124135c6f37c8d1a0b7b9d655b09ec` (site-motion's reviewed head, branch
`worktree-agent-acb4df7f943f7bd4c`), confirm `git rev-parse HEAD` and a clean status (after a machine restart, look for
tracked files of exactly 8388608 bytes and restore them). Report your branch; work only in your own copy.

## Inputs
- Approved plan (read-only, amended): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/plan-approved.md`
  (read its Amendments section; AC4, AC15).
- New base: local `main` `99ff06f46a53fe9f43cfa456e1d42a685bbc36c7` (Build 2026-11-08.2, capture-speed merged; check `git
  rev-parse main`). capture-speed changed `src/web/` (capture.ts, session.ts, read/code.ts, read/authored.ts, the new
  read/matched.ts, replay.ts, lost.ts), `test/browser/chrome.ts` and `test/fixtures/web/check-site.ts`; site-motion also
  changed `src/web/read/code.ts` (the `var()` → `unset` reader change) and the capture (format version 3). Expect overlaps.
- ac-check's line: `NOT ACCEPTED: 1 of 15 ACs on 85a1f2f` (AC4). The auditor's report:
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/auditor/ac.json` and its probes
  `auditor/probe-flat-code-route.log`, `auditor/probe-flat-entrance.log`. The verifier's: `evidence/site-motion/verifier/ac.json`.

## Work
1. `git rebase main`. Keep both sides' meaning on any conflict (HANDOFF sections both stay; capture-speed's matched-styles
   once / descendants derivation must still read everything site-motion's version 3 capture reads — keyframes, hover and
   focus looks with their trigger — and its `var()`/`unset` change must survive). Record each conflict and resolution in the
   ledger. Rerun site-motion's capture tests (`capture-motion`, the `site-motion-proof` web tests) and capture-speed's AC1
   (named, `F2B_BASE_TREE` = a `git archive` of new main) and AC8 (`capture-matched-once`) on the rebased head; stop and
   report if anything new fails.
2. **F1 (AC4, P2):** an element the paste writes flat (`site-flat`, `display: contents`, `src/core/site/classes.ts:146`)
   has no box, so Bricks' Enter-viewport Interaction never starts (IntersectionObserver never reports it): its entrance
   never plays and the text shows still from load. Hit by a code-route `<p>` with its own animation and by every Elementor
   text-editor widget whose wrapper has an entrance (folded into the flat Rich Text). General rule: an element that carries
   an Interaction (or a binding that needs one) always has a box — don't flatten it (or give it one), so it plays as the
   site does; still frames stay within the plan's tolerances. Test first: a browser proof with Bricks 2.3.9's own
   `bricks.min.js`/`animate.min.css` through the renderer on both routes (a code-route `<p>` with an entrance; an Elementor
   text widget whose wrapper fades in) that reads `brx-animated` added once in view and the site's frames playing — RED on
   the rebased head, then GREEN; and a check that every pasted element carrying an `enterView` Interaction has a non-zero
   box. Mutate the guard.
3. Add anything you defer to `evidence/site-motion/follow-ups.md` and HANDOFF's site-motion "Deferred" list.
4. Gates before stopping: both typechecks, `npm run check`, `npm run corpus` (same as main), AC1–AC12 and AC15 tests,
   AC9 and AC11 named on the saved captures the plan names (find the variables' paths from the verifier's logs under
   `evidence/site-motion/verifier/`), the five replays byte-identical to main, `test:web` and `test:browser` file by file
   under the 4 GB cap compared by name with new main (run main's side too).
5. Commit after each passing step (plain `git commit -m`, no author override, no AI or Co-Authored-By lines,
   `git diff --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/fixer-3/` (logs with `HEAD=` first, `EXIT=` last).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sm-f3/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run Chrome too: close every Chrome you
  start (kill by its profile path if Node dies). Worktree `node_modules` may lack `.bin`: see testing-pitfalls. Run
  multi-step commands from a script file written with Write, paths spelled out.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p
  MemorySwapMax=0 <cmd>` with a bounded `--test-timeout`.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, new base SHA, last commit (full SHA), the rebase conflicts and resolutions, F1:
verified?, the rule, fix, tests, RED/GREEN paths, mutation, gates vs main, `found_else`, then `skill_lessons[{skill,
lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
