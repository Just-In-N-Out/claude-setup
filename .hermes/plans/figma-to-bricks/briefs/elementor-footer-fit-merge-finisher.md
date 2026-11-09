# Finisher brief: after-merge steps for elementor-footer-fit (website importer)

**Role:** after-merge finisher (fresh Opus 5.5, high), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `b06d8267`
(Build 2026-11-09.2) to `8c45dff5810a393b9714957f381693d098c5f25d` (`elementor-footer-fit-final2`), accepted by
`ac-check.sh --reviews` (READY FOR THE USER 5/6; AC6 live, Justin's). The main session holds the merge lock (`website-importer`);
don't touch the lock. Never stop to ask. Never load bdryswi.com; no logins; never write to any WordPress site.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Merging" steps, the `.superpowers` line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `8c45dff5810a393b9714957f381693d098c5f25d`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it alone, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-09.2`); bump `BUILD` for today's date (`date +%F`; expect `2026-11-09.3`, or
   the next free `.N`). Run `npm run build` and `npm run check`; both must exit 0. Node
   `/home/justin/.local/node-v22.23.3/bin` first on PATH.
3. Records in the same commit:
   - The ledger is already at `docs/plans/2026-11-08-elementor-footer-fit-ledger.md`; `git ls-files .superpowers/` must be
     empty.
   - Paste check id: elementor-footer-fit's HANDOFF section, its end-of-run entry, its plan and ledger say
     `<elementor-footer-fit id at merge>`; give it the next free id after every id used on main (3dm is the newest; check
     `command grep -rhoE --exclude-dir=evidence '\b3[c-z][a-z]\b' docs/`), expect **3dn**. Its live check is AC6
     (Justin pastes the Elementor whole page, `npm run site -- <capture> <out> --elementor`, on B-Dry staging and checks
     1025 px: the footer's two "Areas We Serve" town lists sit as on the site, and Bricks' structure panel shows the second
     list kept as its own elements). Replace any "build set at the merge" placeholders with the new BUILD.
   - `diff /home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit/plan-approved.md
     docs/plans/2026-11-08-elementor-footer-fit.md`: if the approved copy differs only by the paste-check placeholder you
     filled, leave it; otherwise bring the repo plan to the approved copy.
   - HANDOFF: elementor-phone-fit's known limit about the footer row at 1025 gains "(fixed by elementor-footer-fit,
     <BUILD>)"; elementor-map's open "Facebook" footer row is marked fixed by this job if not already.
4. Commit `Build <BUILD>: an Elementor widget its row stretches past its words keeps its own elements, so the footer
   matches the site at every width (elementor-footer-fit)` (plain `git commit -m`, no author override, no AI or Co-Authored-By lines;
   `git diff --cached --name-only` must not list CLAUDE.md or site-check-out), then `git push` (`main` only, as
   Just-In-N-Out; never switch gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the build line (`Current build <BUILD>`, heading date
   `(2026-11-09)`) and one line at the top of the feature list in the house style:
   "**<BUILD> elementor-footer-fit (website importer):** with `--elementor`, a widget whose measured box is stretched
   past its body plus inner margins at a captured width keeps its own elements, named (fold rule 9), so B-Dry's whole
   page (header, page, footer) is within 2 px at every width (footer 51.89 px at 1025 before); the plain route and Figma
   designs are byte for byte as before. Paste check **<id>** (AC6, live: B-Dry staging at 1025)."
   If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/elementor-footer-fit-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `e94e0311`, `git status` clean but for
   `site-check-out/`, `origin/main` equals `main` after the push.

## Rules
- Never commit CLAUDE.md; never bare `git stash`; never force anything. Don't touch any worktree or other branch.
- Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls.
- SIGTERM / exit 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

## Report
The build number, the commit SHA, the push result, the paste check id, the CLAUDE.md lines written (or the pending file),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
