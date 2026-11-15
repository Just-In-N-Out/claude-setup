# Finisher brief: after-merge steps for shared-palette (one colour is one palette colour, both tools)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a worktree).
The session just fast-forwarded local `main` from `fe29b65d` (Build 2026-11-14.4) to `00aff255cdd2d0b6b6210ecf4e72ec6e925f44fb`
(`shared-palette-final`), accepted on that head: `ac-check.sh` READY FOR THE USER 10/11 (AC11 live), review 6 clean, verifier 3 and auditor 2
clean. The session holds the merge lock (owner `website-importer`); don't touch it. Never stop to ask. Never load any live site; no logins;
never write to any WordPress site; touch nothing under `~/Downloads`. Start no agents. Touch no other agent's processes, worktrees or
branches. Work quickly (15–20 minutes).

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge
into main", the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `00aff255cdd2d0b6b6210ecf4e72ec6e925f44fb`, branch `main`, clean but for untracked `site-check-out/`.
2. Read `src/shared/build.ts` (now `2026-11-14.4`); today on this computer is 2026-11-15: bump to `2026-11-15.1` (or the next free `.N`).
   `npm run build` and `npm run check` exit 0, run as `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 --working-directory=<repo>
   /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; npm run check'`; a timing test failing under load reruns alone.
3. Records in the same commit (docs and `build.ts` only; `git show --stat HEAD` lists each):
   - Ledger: `git mv` the job's `.superpowers/sdd/<shared-palette folder>/progress.md` (`ls .superpowers/sdd/ | grep -i palette`) to
     `docs/plans/<that folder's name>-ledger.md` (move any other file in that folder beside it the same way), add a closing "Merged" line
     (build, paste check); leave the other `.superpowers/sdd/` folders.
   - **Paste check id: the next free one.** Grep main's HANDOFF and every plan under `docs/plans/` and `~/.hermes/plans/figma-to-bricks/*.md`
     for exact ids: 3ep is the last used, **3ek and 3el are reserved by forms-wpforms**, so expect **3eq**; confirm it is unused. Replace this
     job's `<… at merge>` placeholders in HANDOFF and the ledger with that id and the new BUILD; the entry sits at the top of HANDOFF's
     "End-of-run check list" (AC11, live: on B-Dry staging, Style Manager → Colors, import the palette file the next steps name; then a colour
     control in a pasted element offers the site's own colour, from both the importer (`site:import … --colours <his palette export>`) and the
     Figma panel's "Colours already on the site").
   - HANDOFF shared-palette "Deferred / known limits", one line each if missing, from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/follow-ups.md` (review 6's R6-1 to R6-3, the auditor's and verifier's
     notes; R6-3 is a question for Justin: a colours chooser in the importer app).
   - `cmp` the plan copy under `docs/plans/` (`ls docs/plans | grep shared-palette`) with
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/plan-approved.md`; copy over if they differ.
4. Commit `Build <BUILD>: one colour is one palette colour on a Bricks site from both tools; the site's own palette exports are reused
   (--colours, the panel's Colours already on the site) and the palette file holds only what the site lacks (shared-palette)` (plain `git
   commit`; no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md or site-check-out); then `git
   push` (`main` only, as Just-In-N-Out through the repo's own helper).
5. Update the repo `CLAUDE.md` (not in git):
   - **Status:** the date and build line, and one line at the top of the feature list, compact like its neighbours, from HANDOFF's
     shared-palette section (one id and one `--color-<hex>` variable per colour across pages and both tools; `--colours a.json,b.json` on
     `site`/`site:upload`/`site:import`/`replay` and the panel's "Colours already on the site" reuse the site's own palette exports, a
     `--colours` file never overwritten, new colours to `palette-2.json`; the importer app has no colours option yet; without site colours byte
     for byte as before; rulings not yet confirmed as HANDOFF names them); its paste check (AC11, live).
   - Any standing rule the plan lists for CLAUDE.md, word for word.
   If writing CLAUDE.md is refused, leave exactly those lines in `~/.hermes/plans/figma-to-bricks/shared-palette-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `00aff255`, `git status` clean but for `site-check-out/`, `git log -1
   --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Build commit SHA and BUILD; push result; files changed; paste check id; CLAUDE.md written or pending (which lines);
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
