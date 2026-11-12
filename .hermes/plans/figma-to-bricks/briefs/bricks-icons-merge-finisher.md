# Finisher brief: after-merge steps for bricks-icons (Figma plugin, Milestone 1)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a worktree).
The session just fast-forwarded local `main` from `6cd6154e` (Build 2026-11-12.2) to `37687fcbb68cf9b3e3bfc4d0eb7e4cffe06b0797`
(`bricks-icons-final2`), accepted (READY FOR THE USER 6/7 on 643109ec, verifier 2 and auditor 2 clean; a HANDOFF-only rebase onto 6cd6154e,
review 4 clean, receipt EXIT=0 — Justin's notes-only rule). The session holds the merge lock (`website-importer-d1`); don't touch it. Never stop
to ask. Never load any live site; no logins; never write to any WordPress site. Start no agents. Touch no other agent's processes, worktrees
or branches. Work quickly (10–15 minutes).

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge
into main", the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `37687fcbb68cf9b3e3bfc4d0eb7e4cffe06b0797`, branch `main`, clean but for untracked `site-check-out/`.
2. Read `src/shared/build.ts` (now `2026-11-12.2`); bump to `2026-11-12.3` (or the next free `.N` for `date +%F`). `npm run build` and `npm
   run check` exit 0, run as `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 --working-directory=<repo> /bin/bash -c 'export
   PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; npm run check'`; a timing test failing under load reruns alone.
3. Records in the same commit (docs and `build.ts` only; `git show --stat HEAD` lists each):
   - Ledger: `git mv .superpowers/sdd/2026-11-11-bricks-icons/progress.md docs/plans/2026-11-11-bricks-icons-ledger.md`, add a
     closing "Merged" line (build, paste check); `git ls-files .superpowers/` empty.
   - **Paste check id: 3ei** (3dz, 3ea–3eh used; confirm 3ei unused on main's HANDOFF). Replace this job's `<set at merge>` and `<… id at
     merge>` placeholders in HANDOFF and the ledger with **3ei** and the new BUILD; make sure 3ei is in HANDOFF's "End-of-run check list".
   - HANDOFF bricks-icons "Deferred / known limits", one line each if missing, from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/follow-ups.md` (R2-1/R2-2 renderer notes, Safari < 16 `overflow: clip`,
     R3-1 the pins' allow-list, AC4's fractional-size tolerance, the skipped Mac-path corpus variants), and that the importer half is the job
     bricks-icons-site (plan `~/.hermes/plans/figma-to-bricks/bricks-icons-site.md`).
   - `cmp` `docs/plans/2026-11-11-bricks-icons.md` with `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/plan-approved.md`;
     copy over if they differ.
4. Commit `Build <BUILD>: with Pictures to WordPress and Icons as SVG, a plain drawn icon becomes Bricks' Icon element (the SVG in
   the media library, its colour and size in the Icon's controls), drawn where the picture was; a site that refuses SVG gets the paste
   without Icons and a note (bricks-icons)` (plain `git commit`; no author override, no AI or Co-Authored-By lines; `git diff --cached
   --name-only` without CLAUDE.md or site-check-out); then `git push` (`main` only, as Just-In-N-Out
   through the repo's own helper).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the build line, and one line at the top of the feature list, compact like its
   neighbours, from HANDOFF's bricks-icons section (Figma panel; which drawings become Icons, the panel's Icons as SVG, the refusal note;
   Icons off byte for byte; Q-rulings not yet confirmed as HANDOFF names them; the importer half is bricks-icons-site); paste check **3ei**
   (AC7, live: in Figma with Pictures to WordPress and Icons as SVG, convert, paste on darksalmon, Structure shows Icons, the looks at
   three widths, recolour an Icon in Bricks). Add the standing rule from the plan's "Docs & records" if it isn't there (an Icon's box rules
   never out-weigh its Width and Height controls). If writing CLAUDE.md is refused, leave the lines in
   `~/.hermes/plans/figma-to-bricks/bricks-icons-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `37687fcb`, `git status` clean but for `site-check-out/`, `git log -1
   --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Build commit SHA and BUILD; push result; files changed; paste check id; CLAUDE.md written or pending; `skill_lessons[]` (empty is normal),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
