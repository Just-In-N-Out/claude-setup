# Finisher brief: after-merge steps for site-motion (website importer)

**Role:** after-merge finisher (fresh Opus 5.5, high), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `99ff06f4`
(Build 2026-11-08.2) to `325800747bb29432297dc841b3ad05eb8abdd2ce` (`site-motion-fix5`), accepted by `ac-check.sh
--reviews` (READY FOR THE USER 13/15; AC13 and AC14 live, Justin's). The main session holds the merge lock (`website-importer`);
don't touch the lock. Never stop to ask. Never load bdryswi.com; no logins; never write to any WordPress site.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Merging" steps, the `.superpowers` line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `325800747bb29432297dc841b3ad05eb8abdd2ce`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it alone, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-08.2`); bump `BUILD` for today's date (`date +%F`; expect `2026-11-09.1`, or
   the next free `.N`). Run `npm run build` and `npm run check`; both must exit 0 (tsc not found → testing-pitfalls). Node
   `/home/justin/.local/node-v22.23.3/bin` first on PATH.
3. Records in the same commit:
   - Move the ledger `.superpowers/sdd/2026-11-07-site-motion/progress.md` to `docs/plans/2026-11-07-site-motion-ledger.md`;
     `git ls-files .superpowers/` must be empty.
   - Paste check id: site-motion's HANDOFF section and end-of-run entry say `<site-motion id at merge>` (or similar); its
     claimed id is **3dj** — check `command grep -rhoE --exclude-dir=evidence '\b3[c-z][a-z]\b' docs/` on main (3dm is the
     newest on main) and `git grep -hoE '\b3d[a-z]\b' <branch> -- docs/` for `elementor-phone-fit-build` (3dl) and
     `elementor-footer-fit-build`; use 3dj if no one else uses it, else the next free id. Its live checks are AC13 (Justin
     captures bdryswi.com, pastes header, page and footer into B-Dry staging and compares the motion, Reduce motion too)
     and AC14 (`tools/site-motion-live.ts` read-only check after his paste and save). Put it in the heading, the end-of-run
     entry and the ledger. Replace any "build set at the merge" placeholders with the new BUILD.
   - The approved plan: `diff /home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/plan-approved.md
     docs/plans/2026-11-07-site-motion.md` must be empty (amendments 1–4 are in both); if not, bring the repo plan to the
     approved copy.
   - HANDOFF's site-motion section, known limits: check it names the Elementor route's 7.59 px at 390 (as on base; fixed
     by elementor-phone-fit, merging next) and the speed follow-up (the states reading asks every listed element under
     forced hover and focus at the design width).
4. Commit `Build <BUILD>: a captured site's animations, hovers and entrances move in the paste (site-motion)` (plain
   `git commit -m`, no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` must not list
   CLAUDE.md or site-check-out), then `git push` (`main` only, through the repo's credential helper as Just-In-N-Out;
   never switch gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the build line (`Current build <BUILD>`, heading date
   `(2026-11-09)`) and one line at the top of the feature list in the house style:
   "**<BUILD> site-motion (website importer):** the capture (format 3) keeps each `@keyframes` and each element's hover and
   focus looks with their trigger; the code-method paste carries the keyframes under the page's name, keeps hover, focus
   and transition looks, plays entrances once as they come into view through Bricks' own Interaction (an entrance that
   starts hidden takes a type Bricks hides on load; an element that plays one keeps a box; a drawing plays from load),
   and stands still for reduced motion with every entrance shown; older captures and Figma designs paste byte for byte
   as before. Paste check **<id>** (AC13, AC14, live)."
   Also, in "Decisions the user made" → the website importer bullets, replace "a site's CSS animations stay still (no
   `@keyframes`)" in the web-code-page Status line only if it now contradicts (leave the history line, add nothing else).
   If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/site-motion-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `32580074`, `git status` clean but for
   `site-check-out/`, `origin/main` equals `main` after the push.

## Rules
- Never commit CLAUDE.md; never bare `git stash`; never force anything. Don't touch any worktree or other branch.
- Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls.
- SIGTERM / exit 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

## Report
The build number, the commit SHA, the push result, the paste check id, the CLAUDE.md lines written (or the pending file),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
