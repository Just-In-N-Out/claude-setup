# Finisher brief: after-merge steps for elementor-map (website importer)

**Role:** after-merge finisher (fresh Opus 5.5, high), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `9b248818`
(Build 2026-11-07.1) to `1a79e64291bc063749d22c69f85cf8a1c9905c1f` (`worktree-agent-a93c32bbf9bbc5ed4`), accepted by
`ac-check.sh --reviews` (READY FOR THE USER 8/10; AC9 and AC10 live, Justin's). The main session holds the merge lock
(`website-importer`); don't touch the lock. Never stop to ask. Never load bdryswi.com; no logins; never write to any
WordPress site.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Merging" steps, the `.superpowers` line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `1a79e64291bc063749d22c69f85cf8a1c9905c1f`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it alone, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-07.1`); bump `BUILD` for today's date (`date +%F`; expect `2026-11-08.1`, or
   `.N+1` if a build already used today). Run `npm run build` and `npm run check`; both must exit 0 (tsc not found →
   `references/testing-pitfalls.md`). Node `/home/justin/.local/node-v22.23.3/bin` first on PATH.
3. Records in the same commit:
   - Move the ledger `.superpowers/sdd/2026-11-06-elementor-map/progress.md` to
     `docs/plans/2026-11-06-elementor-map-ledger.md`; `git ls-files .superpowers/` must be empty.
   - Paste check id: elementor-map's HANDOFF section and end-of-run entry say `<id at merge>` (or similar). Give it the next
     free id after every id used on main and on local branches (`command grep -rhoE --exclude-dir=evidence '\b3[c-z][a-z]\b'
     docs/` on main — 3di is taken — plus `git grep -hoE '\b3d[a-z]\b' <branch> -- docs/` for each of `capture-speed-build`
     and `site-motion-build` if they exist); put it in the heading, the end-of-run entry and the ledger. Replace any "build
     set at the merge" placeholders with the new BUILD.
   - The approved plan's amendment: `diff /home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/plan-approved.md
     docs/plans/2026-11-06-elementor-map.md`. If the approved copy holds an amendment (the AC7 one) the repo plan lacks,
     bring the repo plan to the approved copy's text for that amendment (nothing else).
   - HANDOFF's elementor-map section, known limits: add if missing "Below the capture's narrowest width (320 px) an
     accordion's open look is lost (its open-look rules sit in `@media (min-width: 320px)`); a follow-up." 
4. Commit `Build <BUILD>: Elementor's wrappers fold and its FAQ becomes Bricks' own Accordion (elementor-map)` (plain
   `git commit -m`, no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` must not list
   CLAUDE.md or site-check-out), then `git push` (`main` only, through the repo's credential helper as Just-In-N-Out;
   never switch gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the build line (`Current build <BUILD>`, date in the heading
   `(2026-11-08)`) and one line at the top of the feature list in the house style:
   "**<BUILD> elementor-map (website importer):** with `--elementor`, `npm run site`/`site:check` fold Elementor's
   wrappers so each Elementor element is one Bricks element, and Elementor's and ElementsKit's FAQs become one Bricks
   Accordion (Nestable) that opens and closes like the site, within 2 px at every width (B-Dry's FAQ 0 px at 39 widths);
   the capture keeps hidden parts of shown elements; without the flag pastes are as before. Paste check **<id>** (AC9,
   AC10, live)."
   If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/elementor-map-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `1a79e642`, `git status` clean but for
   `site-check-out/`, `origin/main` equals `main` after the push.

## Rules
- Never commit CLAUDE.md; never bare `git stash`; never force anything. Don't touch any worktree or other branch.
- Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls.
- SIGTERM / exit 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

## Report
The build number, the commit SHA, the push result, the paste check id, the CLAUDE.md lines written (or the pending file),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
