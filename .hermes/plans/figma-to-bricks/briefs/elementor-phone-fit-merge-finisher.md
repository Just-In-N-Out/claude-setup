# Finisher brief: after-merge steps for elementor-phone-fit (website importer)

**Role:** after-merge finisher (fresh Opus 5.5, high), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `103cbb37`
(Build 2026-11-09.1) to `e94e0311603a70ec35b9b6348cab52747dd97d23` (`elementor-phone-fit-final`), accepted by
`ac-check.sh --reviews` (READY FOR THE USER 5/6; AC6 live, Justin's). The main session holds the merge lock (`website-importer`);
don't touch the lock. Never stop to ask. Never load bdryswi.com; no logins; never write to any WordPress site.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Merging" steps, the `.superpowers` line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `e94e0311603a70ec35b9b6348cab52747dd97d23`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it alone, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-09.1`); bump `BUILD` for today's date (`date +%F`; expect `2026-11-09.2`, or
   the next free `.N`). Run `npm run build` and `npm run check`; both must exit 0. Node
   `/home/justin/.local/node-v22.23.3/bin` first on PATH.
3. Records in the same commit:
   - The ledger is already at `docs/plans/2026-11-08-elementor-phone-fit-ledger.md`; `git ls-files .superpowers/` must be
     empty.
   - Paste check id: elementor-phone-fit's HANDOFF section and end-of-run entry say `<elementor-phone-fit id at merge>`;
     its claimed id is **3dl** — check it's free on main (`command grep -rhoE --exclude-dir=evidence '\b3[c-z][a-z]\b'
     docs/`) and on `elementor-footer-fit-final` (`git grep -hoE '\b3d[a-z]\b' elementor-footer-fit-final -- docs/`);
     use 3dl if free. Its live check is AC6 (Justin pastes the Elementor whole page, `npm run site -- <capture> <out>
     --elementor`, on B-Dry staging and checks 390 px: no line pulled up under the two "Basement Contractors in Southwest
     Indiana" headings). Put it in the heading, the end-of-run entry and the ledger; replace any "build set at the merge"
     placeholders with the new BUILD.
   - `diff /home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-phone-fit/plan-approved.md
     docs/plans/2026-11-08-elementor-phone-fit.md` must be empty; if not, bring the repo plan to the approved copy.
   - HANDOFF: site-motion's limits line naming the Elementor route's 7.59 px at 390 gains "(fixed by elementor-phone-fit,
     <BUILD>)"; elementor-phone-fit's known limits keep the footer row at 1025 "left to elementor-footer-fit".
4. Commit `Build <BUILD>: an Elementor heading whose negative margin outgrows it keeps its own elements, so phones match
   the site (elementor-phone-fit)` (plain `git commit -m`, no author override, no AI or Co-Authored-By lines;
   `git diff --cached --name-only` must not list CLAUDE.md or site-check-out), then `git push` (`main` only, as
   Just-In-N-Out; never switch gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the build line (`Current build <BUILD>`, heading date
   `(2026-11-09)`) and one line at the top of the feature list in the house style:
   "**<BUILD> elementor-phone-fit (website importer):** with `--elementor`, a widget whose inner negative margin outgrows
   its body at a captured width keeps its own elements, named (fold rule 8), so B-Dry's page is within 1.02 px at every
   width (7.59 px on phones before); the plain route and Figma designs are byte for byte as before. Paste check **<id>**
   (AC6, live: B-Dry staging at 390)."
   If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/elementor-phone-fit-claude-md-pending.md`.
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
