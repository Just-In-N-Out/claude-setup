# Finisher brief: after-merge steps for site-headline-marker (a highlighted headline draws its marker as on the site, from one Heading)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a worktree).
The session just fast-forwarded local `main` from `ef651f48` to `d2b577f0c21d625902ce4eabf2e1a3e71f4f40c5` (`site-headline-marker-on-main2`), accepted
(verifier and auditor clean on e37e4c0, reviews clean through 5, a pure rebase plus a test-only pin since; receipt EXIT=0 on d2b577f0). The session holds the merge lock
(owner `website-importer`); don't touch it. Never stop to ask. Never load any live site; no logins; never write to any WordPress site; touch
nothing under `~/Downloads`. Start no agents. Touch no other agent's processes, worktrees or branches. Files only with Write/Edit (no heredocs,
no `sed -i`); plain `git`, each command alone. Work quickly (20–25 minutes). TMPDIR ~/.cache/hmmf/t1.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge
into main", the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `d2b577f0c21d625902ce4eabf2e1a3e71f4f40c5`, branch `main`, clean but for untracked `site-check-out/`.
2. Read `src/shared/build.ts` (now `2026-11-15.3`); bump to the next free `2026-11-15.N` (expect `.4`). `npm run build`. Commit first, then run
   `npm run check` (8G scope: `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 --working-directory=<repo> /bin/bash -c 'export
   PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; npm run check'`), so `offline-tally-compare` doesn't refuse the uncommitted bump; a
   timing or drawing test failing under load reruns alone. If check fails for real, stop before pushing and report.
3. Records in the same commit (docs and `build.ts` only; `git show --stat HEAD` lists each):
   - Move the ledger `.superpowers/sdd/2026-11-14-site-headline-marker/progress.md` to `docs/plans/2026-11-14-site-headline-marker-ledger.md`
     (`git mv` if tracked, else copy and `git add`) and add a closing "Merged" line (build, paste check).
   - **Paste check id: 3et** (confirm it is unused on main's HANDOFF, every local branch's HANDOFF and `~/.hermes/plans/figma-to-bricks/*.md`).
     Replace `<set at merge>` and `<site-headline-marker id at merge>` in HANDOFF (line 7 and any other) and the ledger with `3et` and the new
     BUILD; add the check entry at the top of HANDOFF's "End-of-run check list", above 3es (AC14, live, from plan line 313: Justin's own
     `npm run site:import -- https://bdryswi.com/ <B-Dry staging> --elementor`, import `palette.json`, paste the home on staging /homev2/, in a
     private window the red circle draws around "60 Years" as the headline comes into view, as on bdryswi.com, at desktop and phone width; in
     Bricks he changes the Heading's words…, as the plan says).
   - HANDOFF site-headline-marker "Deferred / known limits", one line each if missing, from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-headline-marker/follow-ups.md` (skip the merge-rule line, which stays there).
   - `cmp` `docs/plans/2026-11-14-site-headline-marker.md` with `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-headline-marker/plan-approved.md`;
     copy over if they differ.
4. Commit `Build <BUILD>: a highlighted headline draws its marker as on the site, from one Heading whose words stay editable (site-headline-marker)`
   (plain `git commit`; no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md or site-check-out);
   run the check (step 2); then `git push` (`main` only, as Just-In-N-Out through the repo's own helper).
5. Update the repo `CLAUDE.md` (not in git):
   - **Status:** the build line, and one line at the top of the feature list, compact like its neighbours, from HANDOFF's site-headline-marker
     section (what the paste now draws; rulings not yet confirmed as HANDOFF names them); its paste check **3et** (AC14, live).
   - The standing rule, word for word (plan line ~442): "an importer animation that isn't an entrance takes a type with no 'in' in it", under
     "Working in this repo".
   If writing CLAUDE.md is refused, leave exactly those lines in `~/.hermes/plans/figma-to-bricks/site-headline-marker-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `d2b577f0`, `git status` clean but for `site-check-out/`, `git log -1
   --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Build commit SHA and BUILD; push result; files changed; paste check id; CLAUDE.md written or pending (which lines);
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
