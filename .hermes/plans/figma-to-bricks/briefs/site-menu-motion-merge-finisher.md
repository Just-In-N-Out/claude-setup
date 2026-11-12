# Finisher brief: after-merge steps for site-menu-motion (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a
worktree). The session just fast-forwarded local `main` from `11f07742` (Build 2026-11-11.5) to
`bc793b50f60afc4bae6ea121731fd80336bae588` (`site-menu-motion-final2`), accepted (READY FOR THE USER 6/7 on `4f0882b1`; rebased
with a HANDOFF-only conflict plus a test-only pin update, review 2 clean, receipt EXIT=0 — Justin's notes-only rule). The session
holds the merge lock (`website-importer-d1`); don't touch it. Never stop to ask. Never load any live site; no logins; never write
to any WordPress site. Start no agents. Touch no other agent's processes, worktrees or branches. Work quickly (10–15 minutes).

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main", the `.superpowers` line, the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `bc793b50f60afc4bae6ea121731fd80336bae588`, branch `main`, clean but for untracked `site-check-out/`.
2. Read `src/shared/build.ts` (now `2026-11-11.5`); bump to `2026-11-11.6` (or the next free `.N` for `date +%F`). `npm run build` and
   `npm run check` (8G scope: `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`) exit 0; Node
   `/home/justin/.local/node-v22.23.3/bin` first on PATH; a timing test failing under load reruns alone.
3. Records in the same commit (docs and `build.ts` only; **`git add` every edited file, including the moved ledger after editing it**):
   - Ledger: `git mv .superpowers/sdd/2026-11-11-site-menu-motion/progress.md docs/plans/2026-11-11-site-menu-motion-ledger.md` (if
     tracked; else copy read-only from `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a82f92ce21a2a2434/.superpowers/sdd/2026-11-11-site-menu-motion/progress.md`);
     `git ls-files .superpowers/` empty.
   - **Paste check id: 3ec** (already this job's in main's HANDOFF; confirm no other merged section uses it). Replace this job's
     `<id at merge>` / "build set at the merge" / `<at merge>` placeholders in HANDOFF and the ledger with **3ec** and the new BUILD.
   - HANDOFF site-menu-motion "Deferred / known limits", add if missing, one line each from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu-motion/follow-ups.md`: R1-3 (do first: a list open at load records
     no slide), R1-4, R1-1, R1-2, R1-5, R1-6, R1-7, the auditor's easing note, R2-1.
   - `cmp` `docs/plans/2026-11-11-site-menu-motion.md` with `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu-motion/plan-approved.md`;
     copy over if they differ.
4. Commit `Build <BUILD>: a menu's sub-list a site's script slides open (Elementor's Nested Accordion in a ☰ drawer) slides open and
   closed in the paste with the site's own timing; reduced motion stands still (site-menu-motion)` (plain `git commit`; no author
   override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md or site-check-out); `git show --stat
   HEAD` must list every edited file with its lines; then `git push` (`main` only, as Just-In-N-Out through the repo's own helper).
5. Update the repo `CLAUDE.md` (not in git) **Status:** the build line and one line at the top of the feature list: "**<BUILD>
   site-menu-motion (website importer):** inside a box a button opens (a ☰ drawer, a pop-up), a `<details>` list whose own height the
   site's script animates when its summary is pressed (Elementor's Nested Accordion: Web Animations, 400 ms linear on B-Dry) is
   recorded by the scan (`CodeNode.slide`: duration, easing) and pastes with a marker class plus one Code element in the Offcanvas
   that plays the same slide opening and closing (a second press turns it back; Escape closes the drawer; reduced motion opens at
   once); needs Regenerate code signatures; Bricks' editor doesn't play it; captures without a slide and Figma designs are byte for
   byte as before. Q1–Q4 A not yet confirmed. Known limit: a list open at load records no slide. Paste check **3ec** (AC7, live:
   re-scan bdryswi.com with this build, paste the header, regenerate code signatures, on a phone Services slides as on the site)."
   If writing CLAUDE.md is refused, leave the lines in `~/.hermes/plans/figma-to-bricks/site-menu-motion-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `bc793b50`, `git status` clean but for `site-check-out/`,
   `git log -1 --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Build commit SHA and BUILD; push result; files changed; paste check id; CLAUDE.md written or pending; `skill_lessons[]` (empty is
normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
