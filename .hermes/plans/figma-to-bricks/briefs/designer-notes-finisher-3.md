# icon-buttons + rich-text — Finisher, step 3 (in the main folder, one build for both)

**Role:** finisher, CLAUDE.md "Finish" step 3. The session has fast-forwarded local `main` in `/home/justin/Documents/FigmaToBricksV2` to `b86671a2` = Build .7 (93640217) + **icon-buttons** (head 244c522c) + **rich-text** (head b86671a2). Both: `ac-check.sh` READY FOR THE USER (icon-buttons AC8 live; rich-text AC8 live). The session holds the shared merge lock (owner designer-notes-d8): don't release it.

**Skills:** `git-commit-rules`.

**Steps, in the main folder:**
1. Read `src/shared/build.ts` (now `2026-11-04.7`; re-read just before editing) and bump to `2026-11-04.8` unless taken.
2. Paste-check ids: **3dg** for icon-buttons, **3dh** for rich-text (3dc is the importer's; 3de/3df are taken). Replace every "id at merge"/"id at the merge" in those two features' HANDOFF sections and end-of-run entries; put each section heading's build as 2026-11-04.8.
3. `npm run build`, then `npm run check` (must pass). Leave the untracked `site-check-out/` folder alone (another session's; never commit it).
4. Commit only `src/shared/build.ts` and `docs/HANDOFF.md` (check `git diff --cached --name-only`; no CLAUDE.md): "Build 2026-11-04.8: icon pills are Bricks Buttons (icon-buttons) and every text is Rich Text (rich-text)" — plain `git commit -m`, no author override, no Co-Authored-By. Then `git push` (`main` only; the repo's credential helper pushes as Just-In-N-Out; never switch gh accounts or change remotes/helpers). If refused, stop and report.
5. Update this folder's `CLAUDE.md` (not in git; edit directly), compactly:
   - "Current build" line → `2026-11-04.8`.
   - Two Status lines above the `.7` line, from `~/.hermes/plans/figma-to-bricks/icon-buttons-claude-md-pending.md` and `rich-text-claude-md-pending.md`, ids filled (3dg, AC8 live: hydraulics' hero; 3dh, AC8 live: structure panel shows no Basic Text).
   - The decision bullets from those two files (Native Buttons append; replace the F4 sentence under "Links to pages"; the "every text is Rich Text" decision), plus: **a Button stretched wider than its content centres its words and icon** (Justin, 2026-11-04, chose "Centred": the phone-menu panel's "Schedule Now").
   - The working-in-this-repo gotchas from those files: an element's own custom CSS never writes `display`; words elements hold a `<p>` (browser tests measure the inner `p`); Rich Text HTML always goes through `asTyped`; `render.ts` lacks `.brxe-block{align-items:flex-start}`.
   - Also update the existing line "**Native Buttons by shape alone** (2026-10-06)" only by the append above — don't reword other rules. If writing CLAUDE.md is refused, leave the filled lines in the pending files and say so.

Don't touch other features' worktrees. Never bare `git stash`.

**Return:** new BUILD, paste ids, commit SHA, push result, check result, CLAUDE.md updated or pending, `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
