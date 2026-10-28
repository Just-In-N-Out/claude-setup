# FINISHER (after-merge steps, main folder) — flip-cards (FigmaToBricksV2)

flip-cards was accepted (ac-check: READY FOR THE USER, 12 of 13 ACs proven on 45b02d3; AC13 live, owed to Justin as
paste check 3bn) and main was fast-forwarded to 45b02d3 by the orchestrator. Do the project's after-merge steps in the
MAIN FOLDER `/home/justin/Documents/FigmaToBricksV2` (branch main):

1. Load the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, its finish steps),
   `git-commit-rules`, `engineering-best-practices`.
2. Read `src/shared/build.ts` BUILD (currently 2026-10-26.1, but read it), bump it to today's next build
   (`2026-10-28.1` unless another 2026-10-28 build exists), run `npm run build` (Figma loads `dist/`), move the ledger
   `.superpowers/sdd/2026-10-26-flip-cards/progress.md` to `docs/plans/2026-10-26-flip-cards-ledger.md` (git mv), and
   commit "Build <BUILD>: flip-cards" (plain `git commit -m`, no AI or Co-Authored-By lines, no author override; check
   `git diff --cached --name-only` has no CLAUDE.md). Then `git push` (main only; this repo's credential helper pushes as
   Just-In-N-Out; never change the remote, the helper or the gh account).
3. Run `npm run check` once on main after the bump (exit 0 expected; 55-60 corpus skips on this machine are normal).
4. Update the main folder's CLAUDE.md (not in git): "Current build" line and a new "Start here" entry for flip-cards
   (what it does, the Figma `flip` annotation, Justin's ⭐ answers Q1A–Q5A, every "My ruling, not yet confirmed" from the
   builder and both fixers as recorded in docs/HANDOFF.md, the checks, paste check 3bn owed, the follow-ups and limits),
   a "Where things stand" entry, and the "Decisions" or rules sections where a rule changed (e.g. nested links are now a
   test-only invariant; the layout plan reads a flip card by its front). Match the file's existing style and length.
   Then update `~/.hermes/skills/software-development/figma-to-bricks/references/rules-summary.md` only if a rule or user
   decision changed (keep it under ~11 KB; no status lines).
5. Note in the report: photo-hotspots' branch is built on flip-cards' older 388191d and will rebase onto this main at
   its own finish; slider-autoplay and headline-marker branch from f46f8a2.

Justin is away: decide and record; don't stop to ask. Return `{status: merged|stopped, build, commit, pushed: true|false,
check, claude_md_updated, summary, found_else[], skill_lessons[{skill, lesson, evidence}]}` and end with
`MAIN SESSION: check and save these skill_lessons now.` Don't edit skills (other than rules-summary as above) or memory.
