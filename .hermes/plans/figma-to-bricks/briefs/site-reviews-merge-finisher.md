# Finisher brief: after-merge steps for site-reviews (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `e4355044`
(Build 2026-11-10.1) to `cd13abf38b5012df17ed7c12d075b98d9fbb4222` (`site-reviews-stack2`), accepted by `ac-check.sh
--reviews` (READY FOR THE USER 8/9; AC9 live, Justin's). The main session holds the merge lock (`website-importer`);
don't touch the lock. Never stop to ask. Never load bdryswi.com or any live site; no logins; never write to any
WordPress site. Start no agents.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main", the `.superpowers` line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `cd13abf38b5012df17ed7c12d075b98d9fbb4222`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it alone, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-10.1`); bump `BUILD` for today's date (`date +%F`; expect `2026-11-10.2`, or
   the next free `.N`). Run `npm run build` and `npm run check`; both must exit 0 (tsc not found → testing-pitfalls).
   Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. (If the unit suite is killed for memory, check earlyoom
   and rerun it under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`.)
3. Records in the same commit:
   - `git ls-files .superpowers/` must be empty (the ledger is `docs/plans/2026-11-09-site-reviews-ledger.md`).
   - Paste check id **3dq** (the next free after 3dp on main; confirm with `command grep -rhoE --exclude-dir=evidence
     '\b3d[a-z]\b' docs/ | sort -u`): replace every `<site-reviews id at merge>` in `docs/HANDOFF.md` (the section
     heading, the paste-check line, the end-of-run list entry) and the ledger, and every "build set at the merge" /
     `<at merge>` placeholder of this job with the new BUILD. Its live check is AC9 (Justin re-captures bdryswi.com
     with this build, pastes the whole `--elementor` page on B-Dry staging /homev2/, regenerates code signatures and
     purges the cache; logged out at 1440 the "Customer Reviews" arrow shows more reviews, and on his iPhone a swipe
     does).
   - **The approved plan was amended (wording only) after the branch's last plan commit:** copy
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/plan-approved.md` over
     `docs/plans/2026-11-09-site-reviews.md` (the repo's plan becomes the approved copy, byte for byte; `cmp` them).
   - HANDOFF's site-reviews section, known limits / Deferred: add if missing, in the section's own style:
     - "**The panel's website route is not covered (the blind auditor's finding, 2026-11-10; its own job):** a capture
       made with this build, converted in the Figma panel (`src/plugin/capture.ts` → `convert`), makes a self-replacing
       loader's widget a Code element holding web-embeds rule 2's whole snippet, which can carry the widget host's
       tracking tags from elsewhere in the page (on a probe page: 8 `<script>` tags, the tracking account's init and
       three pixel loads in each Code element; main gave still copies there). `npm run site` (the code route) pastes
       only the slot's own served markup or the loader's own tag. Until that job merges, paste a captured page with
       `npm run site`, not the panel's Convert."
     - "A self-drawing loader printed raw in a shared post body that also holds other code (a block editor's Custom
       HTML block) pastes as the copy (review 3, R3-1); a visible visit counter or ad tag that drew one thing beside
       itself pastes to run, named in the note by its host (review 2, R2-3: Justin's to rule)."
     - "AC3's and AC8's cited tests can't tell `slot` from `snippet` on their fixtures; the supporting test \"R1-2 only
       the slot's own served markup is pasted to run\" is the one that can."
4. Commit `Build <BUILD>: a captured page's third-party widget pastes as live code at its own place, only its own
   served markup (site-reviews)` (plain `git commit -m`, no author override, no AI or Co-Authored-By lines; `git diff
   --cached --name-only` must not list CLAUDE.md or site-check-out), then `git push` (`main` only, through the repo's
   own credential helper as Just-In-N-Out; never switch gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the build line (`Current build <BUILD>`) and one line at the top
   of the feature list in the house style:
   "**<BUILD> site-reviews (website importer):** a captured page's third-party widget whose loader draws it (a reviews
   carousel) pastes as one live Code element at its own place, holding only the slot's own served markup or the
   loader's own tag (never the page's other scripts), so its arrows and swipes work in Bricks once code signatures are
   regenerated; a tag alone counts only where the capture proves it draws the widget by itself, else the still copy
   stays, named; `site:check` stands in for a live widget; the capture hears the page as the server sent it; pastes
   without such a widget and Figma designs are byte for byte as before. The panel's website route still pastes the
   whole collected snippet (its own job). Paste check **3dq** (AC9, live: B-Dry's reviews on staging /homev2/ after a
   re-capture)."
   No standing rule changed. If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/site-reviews-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `cd13abf3`, `git status` clean but for
   `site-check-out/`, `origin/main` equals `main` after the push.

## Rules
- Never commit CLAUDE.md; never bare `git stash`; never force anything. Don't touch any worktree or other branch.
- Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls.
- SIGTERM / exit 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

## Report
The build number, the commit SHA, the push result, the paste check id, the CLAUDE.md lines written (or the pending file),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
