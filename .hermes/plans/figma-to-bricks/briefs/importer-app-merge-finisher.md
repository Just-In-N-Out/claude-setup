# Finisher brief: after-merge steps for importer-app (website importer's local app)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a worktree).
The session just fast-forwarded local `main` from `392f67e2` (Build 2026-11-14.2) to `5848e82922256291b0b9d230094b9dc41850e217`
(`importer-app-final`), accepted: `ac-check.sh` READY FOR THE USER 19/20 on 7ff5f664 (AC20 live), verifier and auditor clean, then rebased onto
392f67e2 under the notes-only rule as Justin extended it on 2026-11-14 (HANDOFF-only conflicts + test-only commits 7b602c5b and 5848e829;
delta review 4 MOVE ON; receipt-5848e82.log EXIT=0). The session holds the merge lock (owner `website-importer`); don't touch it. Never stop to
ask. Never load any live site; no logins; never write to any WordPress site; touch nothing under `~/Downloads`. Start no agents. Touch no
other agent's processes, worktrees or branches. Work quickly (15–20 minutes).

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge
into main", the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `5848e82922256291b0b9d230094b9dc41850e217`, branch `main`, clean but for untracked `site-check-out/`.
2. Read `src/shared/build.ts` (now `2026-11-14.2`); bump to the next free `.N` for today (`2026-11-14.3` unless taken). `npm run build` and
   `npm run check` exit 0, run as `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 --working-directory=<repo> /bin/bash -c 'export
   PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; npm run check'`; a timing test failing under load reruns alone.
3. Records in the same commit (docs and `build.ts` only; `git show --stat HEAD` lists each):
   - Ledger: `git mv .superpowers/sdd/2026-11-13-importer-app/progress.md docs/plans/2026-11-13-importer-app-ledger.md` (move any other file
     in that folder beside it the same way), add a closing "Merged" line (build, paste check); leave the other `.superpowers/sdd/` folders.
   - **Paste check id: the next free one.** Grep main's HANDOFF and every plan under `docs/plans/` and `~/.hermes/plans/figma-to-bricks/*.md`
     for exact ids: 3en is the last used, **3ek and 3el are reserved by forms-wpforms**, so expect **3eo**; confirm it is unused. Replace this
     job's `<… at merge>` placeholders in HANDOFF and the ledger with that id and the new BUILD; the entry sits at the top of HANDOFF's
     "End-of-run check list" (AC20, live: `npm run importer` from his terminal, scan bdryswi.com, paste on B-Dry staging, one upload with his
     own password and alttext.ai key).
   - HANDOFF importer-app "Deferred / known limits", one line each if missing, from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/follow-ups.md` (and review 4's R4-1 AC18 resize-timing flake with its
     one-line test fix, and R4-2 structure.txt not in the app's file lists, from `evidence/importer-app/review-4/review.json`).
   - `cmp` the plan copy in `docs/plans/2026-11-13-importer-app.md` with
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/plan-approved.md`; copy over if they differ.
4. Commit `Build <BUILD>: npm run importer, a local app on 127.0.0.1 to scan a page, preview and copy its pastes, and upload its pictures with
   the password box and alttext.ai key section (importer-app)` (plain `git commit`; no author override, no AI or Co-Authored-By lines; `git
   diff --cached --name-only` without CLAUDE.md or site-check-out); then `git push` (`main` only, as Just-In-N-Out through the repo's own helper).
5. Update the repo `CLAUDE.md` (not in git):
   - **Status:** the date and build line, and one line at the top of the feature list, compact like its neighbours, from HANDOFF's importer-app
     section (what the app does in short; 127.0.0.1 only, per-run key, Host/Origin checks, a real-site upload only when started from a
     terminal; the password only to `site:upload`'s input; the key 0600, shown as its last four; `site:upload`/`site:import` byte for byte as
     before without the app; rulings not yet confirmed as HANDOFF names them); its paste check (AC20, live).
   - **The uploader rule in "Working in this repo":** the plan's Security S11 item 1 changes **word for word** (heading, password, key, who;
     the rest of the rule unchanged) from `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/plan-approved.md` "S11"; and any
     other S11 item the plan lists, word for word.
   If writing CLAUDE.md is refused, leave exactly those lines in `~/.hermes/plans/figma-to-bricks/importer-app-claude-md-pending.md`.
   Return the plan's proposed `rules-summary.md` line (S11 / Docs item 5) in your report; don't write it.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `5848e829`, `git status` clean but for `site-check-out/`, `git log -1
   --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Build commit SHA and BUILD; push result; files changed; paste check id; CLAUDE.md written or pending (which lines); the rules-summary line;
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
