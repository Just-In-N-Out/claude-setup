# Finisher brief: after-merge steps for site-menu (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `3f4a0718`
(Build 2026-11-11.1) to `7f7e0ffe53638e2f81a40d28015dc8e9405aa437` (`site-menu-stack14`), accepted by `ac-check.sh
--reviews` (READY FOR THE USER 7/8; AC8 live, Justin's). The main session holds the merge lock (`website-importer`);
don't touch the lock. Never stop to ask. Never load bdryswi.com, B-Dry staging or any live site; no logins; never write
to any WordPress site; never run `npm run site:upload` or `npm run site:import` against anything. Start no agents.
Other agents are running tests and Chrome on this machine: touch none of their processes, worktrees or branches.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main", the `.superpowers` line, the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `7f7e0ffe53638e2f81a40d28015dc8e9405aa437`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it alone, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-11.1`); bump `BUILD` for today (`date +%F`; expect `2026-11-11.2`, or the
   next free `.N`; if the date has rolled over, `<today>.1`). Run `npm run build` and `npm run check`; both must exit 0
   (tsc not found → testing-pitfalls). Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. (If the unit suite is
   killed for memory, check earlyoom and rerun it under `systemd-run --user --scope -p MemoryMax=8G -p
   MemorySwapMax=0`.) This job changes `dist/code.js` by two lines (the Offcanvas Content Block's `deletable` /
   `cloneable`): expected.
3. Records in the same commit (docs only besides `build.ts`):
   - `git ls-files .superpowers/` must be empty (the ledger is `docs/plans/2026-11-09-site-menu-ledger.md`).
   - **Paste check id:** the next free after 3dw. Confirm it is free on main's HANDOFF (`command grep -rhoE
     --exclude-dir=evidence '\b3d[a-z]\b' docs/ | sort -u`) and unclaimed on every local branch's HANDOFF and in the
     plans under `~/.hermes/plans/figma-to-bricks/` (unmerged jobs write `<… id at merge>` placeholders; expect
     **3dx**). Replace every `<site-menu id at merge>` in `docs/HANDOFF.md` and the ledger, and every "build set at the
     merge" / `<at merge>` placeholder of this job with the new BUILD (leave quoted history as history). Its live
     check is AC8 (Justin: a fresh capture of bdryswi.com — once the scan fix is merged — pasted on B-Dry staging: the
     header's ☰ opens the menu as on the site; the section's own numbered steps).
   - **Do every item of the approved plan's last section, "For the merge finisher: site-media-upload's records"**
     (`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md`, from the line `## For the merge
     finisher`): items 1, 3 and 4 (a)–(e) exactly as written there, each fenced block's text as it stands, each anchor
     found exactly once before you replace it (if one isn't, stop and report which). Item 4 (e) copies the approved
     plan over `docs/plans/2026-11-09-site-menu.md` (`cmp` them). Item 4 (f) is not edited.
   - HANDOFF's site-menu section: add if missing, in the section's own style: "Recorded by the blind auditor (P3): the
     'stopped what pressing … tried' note names each kind of attempt once (three refused sockets to the site's own
     address read as one line); a test's own Chrome launched with plain `launchChrome` has no socket gate (prove the
     socket clauses through `npm run capture` / `npm run site:import`); review 10: the helper route never presses, and
     the `capture-chrome` case's `doesNotMatch` doesn't cover `capture-run.ts` itself."
4. Commit `Build <BUILD>: the capture presses a page's menu and pop-up buttons under a guard (no writes, no page
   loads, no sockets) and the paste carries what opens as Bricks' Offcanvas; a menu's own pictures go up with
   site:upload (site-menu)` (plain `git commit -m`, or `-F <file>`; no author override, no AI or Co-Authored-By lines;
   `git diff --cached --name-only` must not list CLAUDE.md or site-check-out), then `git push` (`main` only, through
   the repo's own credential helper as Just-In-N-Out; never switch gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git):
   - **Status:** the build line (`Current build <BUILD>`) and one line at the top of the feature list in the house
     style. A draft; **check every detail against HANDOFF's section and the code (`src/web/press-guard.ts`,
     `src/web/socket-gate.ts`, `src/web/read/opens.ts`, `src/core/site/opens.ts`, `src/core/site/media.ts`) and correct
     what differs**: "**<BUILD> site-menu (website importer):** the capture presses a page's menu, pop-up and drawer
     buttons and reads what opens, under a guard (while it presses, no data-sending request, no page load a press
     starts and no WebSocket handshake or message leaves — sockets go through a gate in the capture's own process,
     every Chrome a capture starts launches through `launchCaptureChrome` — each stopped attempt named); the paste
     carries each box as Bricks' Offcanvas its openers toggle, opening and closing as on the site (its own animation,
     Escape, the dim, ×) and a closed `<details>` keeps its hidden content; a picture the site itself put in an opened
     box goes up with `site:upload` (Justin's 'Upload them too'); a capture without opens pastes as before with a
     'capture again' note. Recorded limit: a page's own same-host live socket that beats during its own press can cost
     that press (F7-1). Paste check **<id>** (AC8, live: after the scan fix, re-capture bdryswi.com and paste; the ☰
     opens the menu)."
   - **The decision bullet** "A scanned page's pictures go to WordPress from the command line": the plan's item 2
     (replace its fourth line with the three lines given there).
   - **One standing rule under "Working in this repo"**: the plan's item 5 text (byte for byte).
   If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/site-menu-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `7f7e0ffe`, `git status` clean but for
   `site-check-out/`, `origin/main` equals `main` after the push.

## Rules
- Never commit CLAUDE.md; never bare `git stash`; never force anything. Don't touch any worktree or other branch. Change
  no source or test file (only `src/shared/build.ts` and docs).
- Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls.
- SIGTERM / exit 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

## Report
The build number, the commit SHA, the push result, the paste check id, each finisher item done (with any anchor not
found), the CLAUDE.md lines written (or the pending file), then `skill_lessons[{skill, lesson, evidence, enforce}]`
(reusable only; empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these
skill_lessons now.`
