# Brief: FINISHER (after-merge steps) for figma-to-bricks feature "faq-answer-space"

You are the FINISHER. The feature is merged: local `main` in the main folder `/home/justin/Documents/FigmaToBricksV2` was fast-forwarded to `worktree-faq-answer-space` at `ac603ff`. `ac-check.sh` said `READY FOR THE USER: 6 of 7 ACs proven on ac603ff; live ACs owed to the user: AC7`. Do the project's after-merge steps (project CLAUDE.md "Working in this repo" → "Finish", step 4) **in the main folder only**. Don't touch the worktree copy.

## Skills (load first, say so in one line each)
1. The project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (its finish / merge step).
2. `git-commit-rules` (Skill tool).
3. `engineering-best-practices` (Skill tool).

## Steps
1. `git status` first: if the main folder has uncommitted changes you didn't make, leave them alone (never commit, stash or discard them); stop and report if they block you.
2. **Ledger:** move `.superpowers/sdd/2026-10-26-faq-answer-space/progress.md` to `docs/plans/2026-10-26-faq-answer-space-ledger.md` (check where it is tracked first: `git ls-files .superpowers docs/plans | grep faq`).
3. **BUILD:** read `src/shared/build.ts` first (another session may have bumped it), then bump it: today is 2026-10-26, so `2026-10-26.N` with N one above today's highest, or `2026-10-26.1` if none.
4. `npm run build` (Figma loads `dist/`), then `npm run check` (it passes while 55 corpus tests skip on this machine because `corpus.json` has Mac paths: that is known).
5. Commit "Build <BUILD>: faq-answer-space" (plain `git commit -m`, no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` must not list CLAUDE.md). Then `git push` (`main` only; this repo's credential helper pushes as Just-In-N-Out: never switch the gh account or change the remote or helper). Confirm `git status -sb` shows `main` even with `origin/main`.
6. **Main folder `CLAUDE.md`** (not in git; edit it with the Edit tool, keeping its plain style and the line width of the entries around it):
   - In "Start here": change "**Current build `2026-10-23.3`.**" to the new build, and add an entry at the top of the list for this build, written like its neighbours: Justin's ask ("Can we add more space under the FAQ when it's open? Under the answer."), the cause, what it does now (`understand/accordion.ts` `spaceUnder` / `underAnswers`: an answer box Figma draws at a fixed height with its words at its top hugs its words, and the space drawn under them becomes the item Content's bottom padding, the same on every screen; boxes that paint something of their own or hold a placed layer keep today's min height), Justin's ⭐ answers 1A 2A 3A under auto-go, the review (fresh opus, approve with fixes; F1 painted/outlined boxes, F2 placed layers, F3 tests, all fixed test first), checks (`npm run check` count, browser suite equal to main's by name), pastes (Home 5 answers 25px, Repairs 26px; GRO, brainstorm, Services byte-identical), rulings not yet confirmed, and **paste check 3bl owed** (re-paste Home and Repairs; copy the 4 answers Justin typed in Bricks first, they come back as placeholders). Read the facts from `docs/HANDOFF.md`'s section for this feature and from the commits; don't invent numbers.
   - In "Where things stand": a short entry for this build at the end of the dated entries, pointing at HANDOFF and the plan/ledger.
   - In "Known open bugs and limits" (or a follow-ups line in the entry): a badge pinned to the bottom of a fixed-height box lands on its words on phones (pre-existing, `size.unpin` drops the min height from 991px down); the same frozen-space pattern exists outside FAQs.
7. Report the new BUILD, the commit, the push result and what you wrote in CLAUDE.md.

## Rules
- Work only in `/home/justin/Documents/FigmaToBricksV2`. Never bare `git stash`. Never force anything.
- If you find any other bug or problem, don't fix it: list it in `found_else`.
- Reusable lessons: don't edit any skill or memory file; list them in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section. An empty list is the normal answer.

## Return (your final message)
`{status: done|stopped, build, commit, pushed, claude_md_changes, found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
