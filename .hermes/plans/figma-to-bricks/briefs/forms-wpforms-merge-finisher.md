# Finisher brief: after-merge steps for forms-wpforms (a WPForms form pastes as a real WPForms form, from a scanned site or a Figma design)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a worktree).
The session just fast-forwarded local `main` from `4774bb5e` to `33c650c236a3b33e661b7b2533faf41ac7729531` (`forms-wpforms-on-main3`), accepted on
that head: `ac-check.sh` READY FOR THE USER 16/18 (AC17, AC18 live), review 8 clean, verifier 5 and auditor 5 clean. The session holds the merge lock
(owner `website-importer`); don't touch it. Never stop to ask. Never load any live site; no logins; never write to any WordPress site; touch
nothing under `~/Downloads`. Start no agents. Touch no other agent's processes, worktrees or branches. Files only with Write/Edit (no heredocs,
no `sed -i`); plain `git`, each command alone. Work quickly (20–25 minutes). TMPDIR ~/.cache/fwmf/t1.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge
into main", the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `33c650c236a3b33e661b7b2533faf41ac7729531`, branch `main`, clean but for untracked `site-check-out/`.
2. Read `src/shared/build.ts` (now `2026-11-15.4`); bump to the next free `2026-11-15.N` (expect `.5`). `npm run build`. Commit first, then run
   `npm run check` (8G scope: `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 --working-directory=<repo> /bin/bash -c 'export
   PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; npm run check'`), so `offline-tally-compare` doesn't refuse the uncommitted bump; a
   timing or drawing test failing under load reruns alone. If check fails for real, stop before pushing and report.
3. Records in the same commit (docs and `build.ts` only; `git show --stat HEAD` lists each):
   - Move the ledger `.superpowers/sdd/2026-11-13-forms-wpforms/progress.md` to `docs/plans/2026-11-13-forms-wpforms-ledger.md`
     (`git mv` if tracked, else copy and `git add`) and add a closing "Merged" line (build, paste checks).
   - **Paste check ids 3ek and 3el** are this job's (already named in HANDOFF line 7; confirm the entries exist and no other job uses them).
     Replace `<set at merge>` in HANDOFF (line 7 and any other) and the ledger with the new BUILD; make sure both entries sit at the top of
     HANDOFF's "End-of-run check list", above 3et (AC17 importer and AC18 plugin, live, from plan lines 295–296).
   - HANDOFF forms-wpforms "Deferred / known limits", one line each if missing, from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/forms-wpforms/follow-ups.md` (skip the merge line; include R8-1: site-headline-marker's
     AC13 test hard-codes B-Dry's Code count, now stale, and Task 14's surviving weight-prefix mutant M12).
   - `cmp` `docs/plans/2026-11-13-forms-wpforms.md` with `/home/justin/.hermes/plans/figma-to-bricks/evidence/forms-wpforms/plan-approved.md`;
     copy over if they differ.
4. Commit `Build <BUILD>: a WPForms form pastes as a real WPForms form (an import file plus Bricks' Shortcode), from a scanned site or a Figma design (forms-wpforms)`
   (plain `git commit`; no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md or site-check-out);
   run the check (step 2); then `git push` (`main` only, as Just-In-N-Out through the repo's own helper).
5. Update the repo `CLAUDE.md` (not in git):
   - **Status:** the build line, and one line at the top of the feature list, compact like its neighbours, from HANDOFF's forms-wpforms
     section (rulings not yet confirmed as HANDOFF names them); its paste checks **3ek** (AC17) and **3el** (AC18), live.
   - Word for word from plan lines ~447–452: the two standing rules ("A WPForms form is shown by Bricks' Shortcode element…", "No tool writes
     a form to WordPress…"), the added clause in "One uploader writes to WordPress" naming the WPForms form-list read, the Decisions (the
     importer's WPForms ruling; the plugin's "Forms become" choice, starting on Bricks form), "Waiting on the user" (his Shortcode element copy
     and his export of form 559) and the WPForms line there marked decided for both tools.
   If writing CLAUDE.md is refused, leave exactly those lines in `~/.hermes/plans/figma-to-bricks/forms-wpforms-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `33c650c2`, `git status` clean but for `site-check-out/`, `git log -1
   --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Build commit SHA and BUILD; push result; files changed; paste check id; CLAUDE.md written or pending (which lines);
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
