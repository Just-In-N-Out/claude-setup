# Finisher brief: after-merge steps for capture-speed (website importer)

**Role:** after-merge finisher (fresh Opus 5.5, high), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `7ff9ba4a`
(Build 2026-11-08.1) to `e455130b1149b8f087409e4927d50a3c145a5266` (`capture-speed-build`), accepted by `ac-check.sh
--reviews` (READY FOR THE USER 10/11; AC11 live, Justin's). The main session holds the merge lock (`website-importer`);
don't touch the lock. Never stop to ask. Never load bdryswi.com; no logins; never write to any WordPress site.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Merging" steps, the `.superpowers` line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `e455130b1149b8f087409e4927d50a3c145a5266`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it alone, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-08.1`); bump `BUILD` for today's date (`date +%F`; expect `2026-11-08.2`, or
   the next free `.N`). Run `npm run build` and `npm run check`; both must exit 0 (tsc not found → testing-pitfalls). Node
   `/home/justin/.local/node-v22.23.3/bin` first on PATH. (Unit tests listed at Mac corpus paths skip on this desktop: fine.)
3. Records in the same commit:
   - Move the ledgers `.superpowers/sdd/2026-11-07-capture-speed/progress.md` to
     `docs/plans/2026-11-07-capture-speed-ledger.md` and `.superpowers/sdd/2026-11-04-web-capture-steady/progress.md` to
     `docs/plans/2026-11-04-web-capture-steady-ledger.md` (if that name exists already, append its content under a
     heading instead); `git ls-files .superpowers/` must be empty.
   - Paste check id: if capture-speed's HANDOFF section or end-of-run entry has an id placeholder (or none), give it the
     next free id after every id used on main and on local branches (`command grep -rhoE --exclude-dir=evidence
     '\b3[c-z][a-z]\b' docs/` on main — 3dk is the newest — plus `git grep -hoE '\b3d[a-z]\b' <branch> -- docs/` for each of
     `worktree-agent-acb4df7f943f7bd4c` (site-motion, claims 3dj) and `elementor-phone-fit-build` if it exists); its live
     check is AC11 (Justin's `npm run capture -- https://bdryswi.com/` under 10 min, "I am human" at most twice, no "Not the
     page itself" line, `site:check --all` lists every width). Put it in the heading, the end-of-run entry and the ledger.
     Replace any "build set at the merge" placeholders with the new BUILD.
   - The approved plan: `diff /home/justin/.hermes/plans/figma-to-bricks/evidence/capture-speed/plan-approved.md
     docs/plans/2026-11-07-capture-speed.md`; if the approved copy holds an amendment the repo plan lacks, bring the repo
     plan to it for that amendment (nothing else).
   - HANDOFF's capture-speed section, known limits: add if missing "The page is kept per kind of visitor only for public
     addresses (Chrome's Local Network Access): a capture of a site on this computer or the local network asks the site
     once per range." and "A site that keeps refusing now takes about 40 s more per page load before it is read with its
     note (the 10 s + 30 s retries)."
4. Commit `Build <BUILD>: captures run about ten times faster, side by side, and stop with one line when the wifi drops
   (capture-speed)` (plain `git commit -m`, no author override, no AI or Co-Authored-By lines; `git diff --cached
   --name-only` must not list CLAUDE.md or site-check-out), then `git push` (`main` only, through the repo's credential
   helper as Just-In-N-Out; never switch gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the build line (`Current build <BUILD>`; heading date stays
   `(2026-11-08)`) and one line at the top of the feature list in the house style:
   "**<BUILD> capture-speed (website importer):** `npm run capture` reads up to 4 width ranges side by side in separate
   Chrome windows (`--windows <n>`), asks Chrome's matched styles once per element, asks the site for the page once per
   kind of visitor (public addresses), loads a failed page again in the same window and stops with one plain line when the
   connection stays down (a lost connection is seen in the page's own requests too), asks "I am human" at most once per
   kind, and prints `Took …`; the saved B-Dry home captures in 3.4–3.7 min (base 33–35 min), the same capture as before.
   Paste check **<id>** (AC11, live: bdryswi.com under 10 min)."
   Also edit the existing **"Website captures"** or importer bullet only if a standing rule changed (none expected).
   If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/capture-speed-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `e455130b`, `git status` clean but for
   `site-check-out/`, `origin/main` equals `main` after the push.

## Rules
- Never commit CLAUDE.md; never bare `git stash`; never force anything. Don't touch any worktree or other branch.
- Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls.
- SIGTERM / exit 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

## Report
The build number, the commit SHA, the push result, the paste check id, the CLAUDE.md lines written (or the pending file),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
