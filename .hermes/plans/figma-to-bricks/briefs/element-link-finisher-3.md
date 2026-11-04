# element-link — Finisher, step 3 (in the main folder, after the merge)

**Role:** finisher, CLAUDE.md "Finish" step 3. The session has fast-forwarded local `main` in `/home/justin/Documents/FigmaToBricksV2` to `27e69d18` (element-link). `ac-check.sh`: READY FOR THE USER (AC10 live, owed to Justin).

**Skills:** `git-commit-rules`.

**Steps, in the main folder `/home/justin/Documents/FigmaToBricksV2`:**
1. Read `src/shared/build.ts` (now `2026-11-04.5`; another session may have bumped it — re-read just before editing) and bump to the next number for today (`2026-11-04.6` unless taken).
2. Give the paste check its id: HANDOFF's "End-of-run check list" — take the next free id after the last one used (3de was the latest used by this session and 3dc is reserved by the website-importer session; use 3df unless taken) and replace "id at merge" in element-link' HANDOFF section and end-of-run entry.
3. `npm run build`, then `npm run check` (must pass).
4. Commit "Build <BUILD>: a text that is all one link carries it in Link to (element-link)" — plain `git commit -m`, no author override, no Co-Authored-By; check `git diff --cached --name-only` has no CLAUDE.md. Then `git push` (`main` only; the repo's own credential helper pushes as Just-In-N-Out; never switch gh accounts or change remotes/helpers). If the push is refused, stop and report.
5. Update this folder's `CLAUDE.md` **Status** (it is not in git; edit the file directly): the "Current build" line to the new BUILD, and add the feature's status line (compose it from the HANDOFF section "Whole-text links use Link to": one line, with the paste-check id and "AC10, live") and one bullet under "Decisions the user made" → near "Call and email links"/"Links to pages": "**A text that is all one link carries it in Link to** (the designer Niklas, through Justin, 2026-11-04; ⭐ answers not yet confirmed): email `mailto:`, phone `tel:`, a whole Figma link or page link go in the element's Link to (External URL), never as an `<a>` in its words; a link inside a sentence stays inline; headings too (`understand/text-link.ts`, `elementLink(ir)`)". Keep it compact (CLAUDE.md says: no build narratives). If writing CLAUDE.md is refused, leave the filled lines in that pending file and say so.

Don't touch other features' worktrees. Never bare `git stash`. If the main folder has uncommitted changes you didn't make, leave them and don't commit them.

**Return:** new BUILD, the paste-check id, commit SHA, push result, check result, CLAUDE.md updated or pending, and `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
