# Finisher brief: after-merge steps for site-fonts-match (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a worktree).
The session just fast-forwarded local `main` from `56b5076b` (Build 2026-11-12.1) to `c8ad17b88a345eb9f1dbcb7946bca7e236a837c2`
(`site-fonts-match-fix2`), accepted (READY FOR THE USER 8/9 on c8ad17b8: review 3 clean, verifier 2 and auditor 2 clean). The session holds the merge lock (`website-importer-d1`); don't touch it. Never stop
to ask. Never load any live site; no logins; never write to any WordPress site. Start no agents. Touch no other agent's processes, worktrees
or branches. Work quickly (10–15 minutes).

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge
into main", the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `c8ad17b88a345eb9f1dbcb7946bca7e236a837c2`, branch `main`, clean but for untracked `site-check-out/`.
2. Read `src/shared/build.ts` (now `2026-11-12.1`); bump to `2026-11-12.2` (or the next free `.N` for `date +%F`). `npm run build` and `npm
   run check` exit 0, run as `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 --working-directory=<repo> /bin/bash -c 'export
   PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; npm run check'`; a timing test failing under load reruns alone.
3. Records in the same commit (docs and `build.ts` only; `git show --stat HEAD` lists each):
   - Ledger: `git mv .superpowers/sdd/2026-11-11-site-fonts-match/progress.md docs/plans/2026-11-11-site-fonts-match-ledger.md`, add a
     closing "Merged" line (build, paste check); `git ls-files .superpowers/` empty.
   - **Paste check id: 3eh** (3dz, 3ea–3eg used; confirm 3eh unused on main's HANDOFF). Replace this job's `<set at merge>` and `<… id at
     merge>` placeholders in HANDOFF and the ledger with **3eh** and the new BUILD; make sure 3eh is in HANDOFF's "End-of-run check list".
   - HANDOFF site-fonts-match "Deferred / known limits", one line each if missing, from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/follow-ups.md` (the verifier's mixed site/Google family note, the
     auditor's two site:check stand-in notes, M4/M3 equivalent mutants).
   - `cmp` `docs/plans/2026-11-11-site-fonts-match.md` with `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/plan-approved.md`;
     copy over if they differ.
4. Commit `Build <BUILD>: a scanned page carries exactly the font files its visitors get: a family the site serves itself pastes under the
   page's name with its own @font-face (Bricks' Google scan no longer adds it), a refused face is asked again at the scan's end and named
   when it stays refused (site-fonts-match)` (plain `git commit`; no author override, no AI or Co-Authored-By lines; `git diff --cached
   --name-only` without CLAUDE.md or site-check-out); then `git push` (`main` only, as Just-In-N-Out
   through the repo's own helper).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the build line, and one line at the top of the feature list, compact like its
   neighbours, from HANDOFF's site-fonts-match section (what a scan keeps of a site's fonts, the page-named family and @font-face, the
   re-ask at the scan's end and the note, `site:check` drawing a failed face with the stand-in, captures made before this build byte for
   byte; Q-rulings not yet confirmed as HANDOFF names them, incl. Q1 "copy the broken heading font"); paste check **3eh** (AC9, live: rescan
   bdryswi.com with this build — `npm run site:import` — paste on B-Dry staging and compare the fonts at desktop and phone width). If
   writing CLAUDE.md is refused, leave the lines in `~/.hermes/plans/figma-to-bricks/site-fonts-match-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `c8ad17b8`, `git status` clean but for `site-check-out/`, `git log -1
   --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Build commit SHA and BUILD; push result; files changed; paste check id; CLAUDE.md written or pending; `skill_lessons[]` (empty is normal),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
