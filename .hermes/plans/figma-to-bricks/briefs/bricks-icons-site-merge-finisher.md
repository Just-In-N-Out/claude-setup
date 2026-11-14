# Finisher brief: after-merge steps for bricks-icons-site (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a worktree).
The session just fast-forwarded local `main` from `84722938` (Build 2026-11-14.1) to `acaec88522c192059769eb8d924cc6a57785596b`
(`bricks-icons-site-final`), accepted: `ac-check.sh` READY FOR THE USER 4/5 on a06ed92d (AC5 live), verifier and auditor clean, then rebased
onto 84722938 under the notes-only rule (HANDOFF-only conflict + a test-only pin commit; delta review 2 MOVE ON; receipt-acaec88.log EXIT=0).
The session holds the merge lock (owner `website-importer`); don't touch it. Never stop to ask. Never load any live site; no logins; never
write to any WordPress site. Start no agents. Touch no other agent's processes, worktrees or branches. Work quickly (10–15 minutes).

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge
into main", the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `acaec88522c192059769eb8d924cc6a57785596b`, branch `main`, clean but for untracked `site-check-out/`.
2. Read `src/shared/build.ts` (now `2026-11-14.1`); bump to the next free `.N` for today (`2026-11-14.2` unless taken). `npm run build` and
   `npm run check` exit 0, run as `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 --working-directory=<repo> /bin/bash -c 'export
   PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; npm run check'`; a timing test failing under load reruns alone.
3. Records in the same commit (docs and `build.ts` only; `git show --stat HEAD` lists each):
   - Ledger: `git mv .superpowers/sdd/2026-11-12-bricks-icons-site/progress.md docs/plans/2026-11-12-bricks-icons-site-ledger.md` (move any
     other file in that folder beside it the same way), add a closing "Merged" line (build, paste check); leave the other `.superpowers/sdd/`
     folders alone.
   - **Paste check id: 3ek** (3ej is the last used; confirm 3ek unused on main's HANDOFF). Replace this job's `<set at merge>` / `<bricks-icons-site
     id at merge>` placeholders in HANDOFF and the ledger with **3ek** and the new BUILD; 3ek is in HANDOFF's "End-of-run check list" (AC5,
     live: `site:import --svg` on bdryswi.com, paste on B-Dry staging, Structure shows Icons, the looks as before at desktop, tablet and phone).
   - HANDOFF bricks-icons-site "Deferred / known limits", one line each if missing, from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons-site/follow-ups.md`.
   - `cmp` the plan copy in `docs/plans/` with `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons-site/plan-approved.md`;
     copy over if they differ.
4. Commit `Build <BUILD>: a scanned site's own drawn icons paste as Bricks' Icon element showing their SVG from the media library, uploaded
   once each with --svg (bricks-icons-site)` (plain `git commit`; no author override, no AI or Co-Authored-By lines; `git diff --cached
   --name-only` without CLAUDE.md or site-check-out); then `git push` (`main` only, as Just-In-N-Out through the repo's own helper).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the date and build line, and one line at the top of the feature list, compact like its
   neighbours, from HANDOFF's bricks-icons-site section (website importer; which drawings become Icons, which stay Code, named; `--svg`
   uploads each distinct drawing once after the typed yes, never to alttext.ai; a site refusing SVG keeps Code elements; pastes without a
   map byte for byte as before; rulings not yet confirmed as HANDOFF names them); paste check **3ek** (AC5, live). If writing CLAUDE.md is
   refused, leave the lines in `~/.hermes/plans/figma-to-bricks/bricks-icons-site-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `acaec885`, `git status` clean but for `site-check-out/`, `git log -1
   --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Build commit SHA and BUILD; push result; files changed; paste check id; CLAUDE.md written or pending; `skill_lessons[{skill, lesson,
evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
