# Finisher brief: after-merge steps for media-reuse (a picture already in the site's Media is used from there, both tools)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a worktree).
The session just fast-forwarded local `main` from `fbd28935` to `4439dca43281f50bd9695adccf42bb27834525b4` (`media-reuse-rebased`), accepted:
`ac-check.sh` READY FOR THE USER on 7ca8e41a (AC22 live), rebased onto standin-drift with a HANDOFF-only conflict, delta review 4 clean and
rebase receipt 24/24 EXIT=0. Never stop to ask. Never load any live site; no logins; never write to any WordPress site; never read
`~/.config/figma-to-bricks/site-passwords.json` or `alttext-key`; touch nothing under `~/Downloads`. Start no agents. Touch no other agent's
processes, worktrees or branches, and not the merge lock. Files only with Write/Edit (no heredocs, no `sed -i`); plain `git`, each command
alone. Leave the untracked `site-check-out/` alone. Work quickly (20–25 minutes). TMPDIR ~/.cache/mrmf/t1.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge
into main") and the repo `CLAUDE.md` "Finish" step 3. Machine rules: `/home/justin/.hermes/plans/figma-to-bricks/briefs/_reviewer-common-2026-11-15.md`
(its review.json part doesn't apply).

## Steps
1. Confirm `git rev-parse HEAD` = `4439dca43281f50bd9695adccf42bb27834525b4`, branch `main`, clean but for untracked `site-check-out/`.
2. Read `src/shared/build.ts` (now `2026-11-17.5`); today is 2026-11-18, so set `2026-11-18.1` unless a `2026-11-18.N` is already used (then
   the next free N). `npm run build`.
3. Records in the same commit (docs and `build.ts` only):
   - `git mv .superpowers/sdd/2026-11-17-media-reuse/progress.md docs/plans/2026-11-17-media-reuse-ledger.md` and add a closing "Merged"
     line (build, paste check 3fn).
   - HANDOFF's media-reuse section (line 7) and paste check 3fn are already in place; put the new BUILD in the section heading or its
     first lines the way neighbouring sections name theirs, and confirm 3fn appears once in "End-of-run check list" with no other job using it.
   - HANDOFF media-reuse "Deferred / known limits": one line each, if missing, from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/media-reuse/follow-ups.md` (skip merge and process lines).
   - `docs/plans/2026-11-17-media-reuse.md` already equals `plan-approved.md` (checked); leave it.
4. Commit `Build <BUILD>: a picture already in the site's Media is used from there, never uploaded twice (media-reuse)` (plain `git commit`;
   no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md or site-check-out). Then run
   `npm run check` under `systemd-run --user --scope -p MemoryMax=9G -p MemorySwapMax=0 --working-directory=<repo> /bin/bash -c 'export
   PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; npm run check'`; a timing or drawing test failing under load reruns alone. If the check
   fails for real, stop before pushing and report. Then `git push` (`main` only, as Just-In-N-Out through the repo's own helper).
5. Update the repo `CLAUDE.md` (not in git):
   - **Status:** the date in the heading `## Status (2026-11-18)`; the build line `**Current build `<BUILD>`**`; one line at the top of
     the feature list, compact like its neighbours, from HANDOFF's media-reuse section (both tools: before a picture goes up, Media is asked
     whether it already holds that very file; if so the paste uses that item, no second upload; an empty Media alt is filled with the old
     site's words only on the tool's own items; Decorative empties Media's alt only for a picture this conversion uploaded; a panel note when
     Media can't be read; rulings not yet confirmed as HANDOFF names them), with paste check **3fn** (AC22, live) worded as the ledger's
     line 177 says.
   - The ledger's "For the finisher: CLAUDE.md lines" (progress.md line 134 on, now in `docs/plans/2026-11-17-media-reuse-ledger.md`),
     with the later amendments at its lines ~177 and ~198 applied (the standing rule reads "Decorative empties Media's alt text only for a
     picture this conversion uploaded; one already in Media keeps its words"), word for word, in "One uploader writes to WordPress" and
     wherever else the ledger says.
   If writing CLAUDE.md is refused, leave exactly those lines in `~/.hermes/plans/figma-to-bricks/media-reuse-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `4439dca4`, `git status` clean but for `site-check-out/`,
   `git log -1 --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Build commit SHA and BUILD; push result; check result; files changed; CLAUDE.md written or pending (which lines);
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
