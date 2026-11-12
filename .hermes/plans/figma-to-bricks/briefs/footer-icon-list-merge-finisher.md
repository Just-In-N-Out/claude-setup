# Finisher brief: after-merge steps for footer-icon-list (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `20ce41a8`
(Build 2026-11-11.8) to `8490829d8d4124ef5a3fdacb2d806c218ce820c7` (`footer-icon-list-final2`). It was accepted READY
FOR THE USER 9/10 (AC6 live, Justin's). It then moved onto main with HANDOFF-only conflicts and two test-only pin commits,
taking Justin's notes-only path: delta reviews 5 and 6 clean, receipt `evidence/footer-icon-list/rebase/receipt-8490829.log`
EXIT=0. The main session holds the merge lock (`website-importer`); don't touch the lock. Never stop to ask. Justin is asleep.
Never load bdryswi.com, B-Dry staging or any live site; no logins; never write to any WordPress site; never run
`site:upload` or `site:import` against anything. Start no agents. Another session's agents run tests and Chrome on
this machine: touch none of their processes, worktrees or branches.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main", the `.superpowers` line, the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `8490829d8d4124ef5a3fdacb2d806c218ce820c7`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it alone, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-11.8`). Bump `BUILD` for today (`date +%F`; expect `2026-11-11.9`, or the
   next free `.N`). Run `npm run build` and `npm run check`; both must exit 0. Put Node
   `/home/justin/.local/node-v22.23.3/bin` first on PATH. Run check under `systemd-run --user --scope -p MemoryMax=8G -p
   MemorySwapMax=0`. If it is killed, check earlyoom.
3. Records go in the same commit (docs only, besides `build.ts`):
   - `git ls-files .superpowers/` must be empty.
   - **Paste check id: 3dz**, reserved for this job by agreement with the other session (it took 3ea–3ee). Confirm 3dz
     is free on main's HANDOFF and on the other local branches. Replace every `<footer-icon-list id at merge>` (3 in
     `docs/HANDOFF.md`) and this job's "build set at the merge" / `<at merge>` placeholders in HANDOFF and
     `docs/plans/2026-11-10-footer-icon-list-ledger.md` with 3dz and the new BUILD. Its live check is AC6: after a
     re-scan of bdryswi.com with this build and a re-paste of B-Dry's whole home on staging, `npm run site:live` shows
     the footer contact list within 2 px of the site.
   - Copy `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/plan-approved.md` over
     `docs/plans/2026-11-10-footer-icon-list.md` (`cmp` them).
   - In HANDOFF's footer-icon-list section, under "Known limits" / "Deferred", add each of these that is missing, in the
     section's own style. Take the wording from `evidence/footer-icon-list/follow-ups.md`:
     - R2-2: layered `!important` (a side set `!important` in an earlier cascade layer than a later plain one) isn't
       ordered the way the browser orders layers;
     - R3-1: the older-capture note counts elements, not sides;
     - AC10's margin is thin (the timing check's measured slowdown sits close to its 15% limit on this PC).
4. Commit `Build <BUILD>: a box side a site writes by two names (a reset's margin: 0 and a later margin-block-start) keeps
   the site's winner, so B-Dry's footer contact list keeps its spacing (footer-icon-list)`. Use a plain `git commit -m`
   or `-F <file>`: no author override, no AI or Co-Authored-By lines. Check that `git diff --cached --name-only` lists
   neither CLAUDE.md nor site-check-out. Then `git push` (`main` only, through the repo's own credential helper as
   Just-In-N-Out; never switch gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git) **Status:** set the build line (`Current build`), and add one line at the top
   of the feature list in the house style. Check it against HANDOFF's section and the code (`src/web/read/code-sides.ts`,
   `src/core/site/sides.ts`): "**<BUILD> footer-icon-list (website importer):** the capture keeps each box side and size
   by one name, the one the site's cascade applied (a reset's physical `margin: 0` then Elementor's logical
   `margin-block-start`, at every range, under hover and focus, a logical side read by the element's own writing mode
   and direction; `web.code.oneName`), so B-Dry's footer contact list no longer pastes 69 px short (Bricks' class
   setting beat the custom CSS); captures made before this build paste byte for byte as before with one 'capture the
   page again' note where a top/bottom side or size has two names (Q4 A not yet confirmed); Figma designs byte for byte
   as before. Paste check **3dz** (AC6, live: re-scan bdryswi.com, re-paste B-Dry's home, `site:live`: footer within
   2 px)." If writing CLAUDE.md is refused, leave the lines in
   `~/.hermes/plans/figma-to-bricks/footer-icon-list-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `8490829d`; `git status` is clean but for
   `site-check-out/`; `origin/main` equals `main` after the push.

## Rules
Never commit CLAUDE.md; never bare `git stash`; never force anything. Change no source or test file (only
`src/shared/build.ts` and docs). Write multi-step scripts with Write and run them with `bash <file>`; run git commands
as separate plain calls. SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso |
grep -E 'sending SIG[A-Z]* to process'`).

## Report
The build number, the commit SHA, the push result, the paste check id, the CLAUDE.md lines written (or the pending
file), then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check
and save these skill_lessons now.`
