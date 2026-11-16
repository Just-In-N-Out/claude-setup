# Finisher brief: after-merge steps for importer-parity (an importer paste keeps the site's names and uses Bricks' own settings and elements)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a worktree).
The session just fast-forwarded local `main` from `201218fa` to `f23ba8d5bcf2f400371c19fb0857cd45c8eb6924` (`importer-parity-fix11`), accepted on
that head: `ac-check.sh` READY FOR THE USER 21/22 (AC22 live), review 13 clean, verifier 7 and auditor 5 clean. The session holds the merge lock
(owner `website-importer`); don't touch it. Never stop to ask. Never load any live site; no logins; never write to any WordPress site; touch
nothing under `~/Downloads`. Start no agents. Touch no other agent's processes, worktrees or branches. Files only with Write/Edit (no heredocs,
no `sed -i`); plain `git`, each command alone. Work quickly (20–25 minutes). TMPDIR ~/.cache/ipmf/t1.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge
into main", the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `f23ba8d5bcf2f400371c19fb0857cd45c8eb6924`, branch `main`, clean but for untracked `site-check-out/`.
2. Read `src/shared/build.ts` (now `2026-11-15.2`); bump to the next free `2026-11-15.N` (expect `.3`). `npm run build` and `npm run check`
   exit 0, run as `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 --working-directory=<repo> /bin/bash -c 'export
   PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; npm run check'`; a timing or drawing test failing under load reruns alone.
3. Records in the same commit (docs and `build.ts` only; `git show --stat HEAD` lists each):
   - The ledger is already at `docs/plans/2026-11-11-importer-parity-ledger.md`: add a closing "Merged" line (build, paste check).
   - **Paste check id: 3es** (reserved for this job; confirm it is unused by grepping main's HANDOFF, `docs/plans/` and
     `~/.hermes/plans/figma-to-bricks/*.md`). Replace this job's `<set at merge>` and `<importer-parity id at merge>` placeholders in HANDOFF
     (lines 138, 325, 14705 and any other) and the ledger with `3es` and the new BUILD; the check entry sits at the top of HANDOFF's
     "End-of-run check list" (AC22, live: scan bdryswi.com again with this build, `site:import … --elementor`, paste B-Dry's home on staging
     /homev2/: the menu is a Nav with its name, links and buttons keep the site's names, borders/shadows/hovers are Bricks settings, painted
     Buttons Style Primary, a Divider, Accordion, Slider and Video where the site has them; the browser's Accessibility pane names them).
   - HANDOFF importer-parity "Deferred / known limits", one line each if missing, from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/follow-ups.md` (reviews' P3s, verifier 6/7's and auditor 4/5's
     notes: the cols/content-box textarea sizes, Swiper arrow size, form field padding by field id, parsedFirst on the other site:live tests).
     One question for Justin: a folded wrapper's aria-label renames its link (site "Read more", paste "Wrapper name") as AC2 says: keep that?
   - `cmp` `docs/plans/2026-11-11-importer-parity.md` with `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/plan-approved.md`;
     copy over if they differ.
4. Commit `Build <BUILD>: an importer paste keeps the site's names and uses Bricks' own settings and elements: Nav, Form, Video, Divider,
   Accordion, Slider, Primary Buttons, borders and shadows as settings (importer-parity)` (plain `git commit`; no author override, no AI or Co-Authored-By
   lines; `git diff --cached --name-only` without CLAUDE.md or site-check-out); then `git push` (`main` only, as Just-In-N-Out through the
   repo's own helper).
5. Update the repo `CLAUDE.md` (not in git):
   - **Status:** the date and build line, and one line at the top of the feature list, compact like its neighbours, from HANDOFF's
     importer-parity section (what the paste now keeps and makes; rulings not yet confirmed as HANDOFF names them); its paste check **3es**
     (AC22, live).
   - The standing rules and decisions the plan lists word for word (`docs/plans/2026-11-11-importer-parity.md` lines ~672–681: "A website
     paste keeps the site's accessibility names…", "The importer and the plugin write a Nav, a Form's fields and a Video's keys through
     `emit/nav-shape.ts`, `form-shape.ts`, `video-shape.ts`", "A top element's position stays custom CSS on the importer…"; the three
     decisions; the samples line loses nothing), plus "A site:live test that serves a printed stand-in holds its draw with `parsedFirst`
     (`test/web/lib/bricks-printed.ts`)" in "Working in this repo". The WPForms line under "Waiting on the user" stays as it is.
   If writing CLAUDE.md is refused, leave exactly those lines in `~/.hermes/plans/figma-to-bricks/importer-parity-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `f23ba8d5`, `git status` clean but for `site-check-out/`, `git log -1
   --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Build commit SHA and BUILD; push result; files changed; paste check id; CLAUDE.md written or pending (which lines);
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
