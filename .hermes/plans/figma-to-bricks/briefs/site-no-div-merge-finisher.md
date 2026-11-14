# Finisher brief: after-merge steps for site-no-div (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a worktree).
The session just fast-forwarded local `main` from `7f54b0a5` (Build 2026-11-12.3) to `cf4f887de2a52ad8d7cb757486cc1916f3e3f4f4`
(`site-no-div-final`), accepted: `ac-check.sh` READY FOR THE USER 13/14 on cf4f887 (AC14 live), review 5 clean, verifier 2 and auditor 2 clean.
The session holds the merge lock (owner `website-importer`); don't touch it. Never stop to ask. Never load any live site; no logins; never
write to any WordPress site. Start no agents. Touch no other agent's processes, worktrees or branches. Work quickly (10–15 minutes).

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge
into main", the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `cf4f887de2a52ad8d7cb757486cc1916f3e3f4f4`, branch `main`, clean but for untracked `site-check-out/`.
2. Read `src/shared/build.ts` (now `2026-11-12.3`); bump to `<date +%F>.1` (or the next free `.N` for today). `npm run build` and `npm run
   check` exit 0, run as `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 --working-directory=<repo> /bin/bash -c 'export
   PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; npm run check'`; a timing test failing under load reruns alone.
3. Records in the same commit (docs and `build.ts` only; `git show --stat HEAD` lists each):
   - Ledger: `git mv .superpowers/sdd/2026-11-11-site-no-div/progress.md docs/plans/2026-11-11-site-no-div-ledger.md` (move any other file in
     that folder beside it the same way), add a closing "Merged" line (build, paste check); `git ls-files .superpowers/` empty.
   - **Paste check id: 3ej** (3dz, 3ea–3ei used; confirm 3ej unused on main's HANDOFF). Replace this job's `<set at merge>` / `<… id at
     merge>` placeholders in HANDOFF and the ledger with **3ej** and the new BUILD; make sure 3ej is in HANDOFF's "End-of-run check list"
     (AC14, live: paste B-Dry's home on staging /homev2/ with this build's pastes, Structure shows Sections / Containers / Blocks and Bricks'
     own elements with no Div, every Block labelled, the page looks as before at 1440 and 390, ☰ and one pop-up open).
   - HANDOFF site-no-div "Deferred / known limits", one line each if missing, from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/follow-ups.md` (including R5-1: each lifted Section copies the root's
     text settings) and auditor 2's notes: a hover a site gives only at phone widths isn't captured (`web.code.statesAt` is the design
     width's range; base too); "kept as Blocks: N boxes" in the notes counts boxes, not pasted Blocks.
   - `cmp` `docs/plans/2026-11-11-site-no-div.md` with `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/plan-approved.md`;
     copy over if they differ.
4. Commit `Build <BUILD>: a website paste holds no Div: Sections, Containers and Blocks, Bricks' own Text links, Buttons, Images and Rich
   Text, every Block labelled, wrappers that add nothing folded, the page drawn as before (site-no-div)` (plain `git commit`; no author
   override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md or site-check-out); then `git push` (`main`
   only, as Just-In-N-Out through the repo's own helper).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the date and build line, and one line at the top of the feature list, compact like
   its neighbours, from HANDOFF's site-no-div section (website importer, both routes; what becomes what; folding; labels; structure.txt
   and the Structure note; the native step off and Figma designs byte for byte; Q-rulings not yet confirmed as HANDOFF names them); paste
   check **3ej** (AC14, live). Add any standing rule from the plan's "Docs & records" if it isn't there. If writing CLAUDE.md is refused,
   leave the lines in `~/.hermes/plans/figma-to-bricks/site-no-div-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `cf4f887d`, `git status` clean but for `site-check-out/`, `git log -1
   --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Build commit SHA and BUILD; push result; files changed; paste check id; CLAUDE.md written or pending; `skill_lessons[{skill, lesson,
evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
