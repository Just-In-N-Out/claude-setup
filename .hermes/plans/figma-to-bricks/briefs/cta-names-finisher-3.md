# cta-names — Finisher, step 3 (in the main folder, after the merge)

**Role:** finisher, CLAUDE.md "Finish" step 3. The session has fast-forwarded local `main` in `/home/justin/Documents/FigmaToBricksV2` to `f78fef98` (cta-names). `ac-check.sh`: READY FOR THE USER (AC6 live, owed to Justin).

**Skills:** `git-commit-rules`.

**Steps, in the main folder `/home/justin/Documents/FigmaToBricksV2`:**
1. Read `src/shared/build.ts` (now `2026-11-04.4`; another session may have bumped it — re-read just before editing) and bump to the next number for today (`2026-11-04.5` unless taken).
2. Give the paste check its id: HANDOFF's "End-of-run check list" — take the next free id after the last one used (3dd was the latest known; read the list) and replace "id at merge" in cta-names' HANDOFF section and end-of-run entry.
3. `npm run build`, then `npm run check` (must pass).
4. Commit "Build <BUILD>: every call to action has an accessible name (cta-names)" — plain `git commit -m`, no author override, no Co-Authored-By; check `git diff --cached --name-only` has no CLAUDE.md. Then `git push` (`main` only; the repo's own credential helper pushes as Just-In-N-Out; never switch gh accounts or change remotes/helpers). If the push is refused, stop and report.
5. Update this folder's `CLAUDE.md` **Status** (it is not in git; edit the file directly): the "Current build" line to the new BUILD, and add the feature's status line and the decision bullet from `~/.hermes/plans/figma-to-bricks/cta-names-claude-md-pending.md` with `<BUILD>` and `<id>` filled. Keep it compact (CLAUDE.md says: no build narratives). If writing CLAUDE.md is refused, leave the filled lines in that pending file and say so.

Don't touch other features' worktrees. Never bare `git stash`. If the main folder has uncommitted changes you didn't make, leave them and don't commit them.

**Return:** new BUILD, the paste-check id, commit SHA, push result, check result, CLAUDE.md updated or pending, and `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
