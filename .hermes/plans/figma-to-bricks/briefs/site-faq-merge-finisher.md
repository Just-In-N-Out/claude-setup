# Finisher brief: after-merge steps for site-faq (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `3cfc54ac`
(Build 2026-11-09.4) to `143a4e19a6428e961c29a5f16f5cd715da91b7c1` (`site-faq-stack1`), accepted by `ac-check.sh
--reviews` (READY FOR THE USER 7/8; AC8 live, Justin's). The main session holds the merge lock (`website-importer`);
don't touch the lock. Never stop to ask. Never load bdryswi.com or any live site; no logins; never write to any
WordPress site. Start no agents.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main", the `.superpowers` line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `143a4e19a6428e961c29a5f16f5cd715da91b7c1`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it alone, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-09.4`); bump `BUILD` for today's date (`date +%F`; expect `2026-11-10.1`, or
   the next free `.N`). Run `npm run build` and `npm run check`; both must exit 0 (tsc not found → testing-pitfalls).
   Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. (Other agents are running Chrome suites: if the unit suite
   is killed for memory, check earlyoom and rerun it under `systemd-run --user --scope -p MemoryMax=8G -p
   MemorySwapMax=0`.)
3. Records in the same commit:
   - `git ls-files .superpowers/` must be empty (the ledger is `docs/plans/2026-11-09-site-faq-ledger.md`).
   - Paste check id **3dp** (the next free after 3do on main; confirm with `command grep -rhoE --exclude-dir=evidence
     '\b3d[a-z]\b' docs/ | sort -u`): replace every `<site-faq id at merge>` in `docs/HANDOFF.md` (the section heading,
     the paste-check line, the end-of-run list entry) and the ledger, and every `<at merge>` / "build set at the merge"
     placeholder of this job with the new BUILD. Its live check is AC8 (Justin re-captures bdryswi.com, re-pastes the
     `--elementor` whole page on B-Dry staging /homev2/, regenerates code signatures and purges the cache; the first FAQ
     answer is open with its open look, and the look follows the click, on the front end and in the Bricks editor).
   - Bring the wording that is now out of date to the present: "after staging-fit-capture merges" / "once
     staging-fit-capture is merged" in the site-faq section and its end-of-run entry become "with Build 2026-11-09.4 or
     later (staging-fit-capture is merged)", meaning unchanged.
   - The approved plan: `diff /home/justin/.hermes/plans/figma-to-bricks/evidence/site-faq/plan-approved.md
     docs/plans/2026-11-09-site-faq.md`; if the approved copy holds an amendment the repo plan lacks, bring the repo
     plan to it for that amendment (nothing else).
   - HANDOFF's site-faq section, known limits / Deferred: add if missing, in the section's own style:
     - "Below 320 px the open look is lost (the look rules carry `min-width: 320px`)."
     - "`npm run site` refuses Justin's saved 2026-11-09 capture (styleless 768–991), so the FAQ fix reaches a paste
       only from a re-capture."
     - "`src/core/site` holds two functions named `designRange` with different meanings (`ranges.ts`, exported, kept
       ranges; `styled-ranges.ts`, private, capture ranges): rename one when either file is next touched."
     - "The open look can still write one `revert` on the open item's own element (not the phone-button kind of bug;
       staging-fit-cancels' review 1, R1-4): moving `openLook`/`lookCss` onto that job's bounded-run helpers is a
       follow-up once it merges."
4. Commit `Build <BUILD>: a pasted Elementor FAQ opens the answers the site opens, and its open look follows the open
   item (site-faq)` (plain `git commit -m`, no author override, no AI or Co-Authored-By lines; `git diff --cached
   --name-only` must not list CLAUDE.md or site-check-out), then `git push` (`main` only, through the repo's own
   credential helper as Just-In-N-Out; never switch gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the heading date `(2026-11-10)` if the build is dated so, the
   build line (`Current build <BUILD>`) and one line at the top of the feature list in the house style:
   "**<BUILD> site-faq (website importer):** with `--elementor`, a pasted Elementor or ElementsKit FAQ opens at load the
   answers the site opens at the design width (none, one or several; a narrower width that shows other answers no
   longer stops it), and its open look (colour, arrow) follows whichever item Bricks has open, at every width and above
   Bricks' own class controls; pastes without such a FAQ and Figma designs are byte for byte as before. Paste check
   **3dp** (AC8, live: B-Dry's FAQ on staging /homev2/ after a re-capture)."
   No standing rule changed. If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/site-faq-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `143a4e19`, `git status` clean but for
   `site-check-out/`, `origin/main` equals `main` after the push.

## Rules
- Never commit CLAUDE.md; never bare `git stash`; never force anything. Don't touch any worktree or other branch.
- Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls.
- SIGTERM / exit 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

## Report
The build number, the commit SHA, the push result, the paste check id, the CLAUDE.md lines written (or the pending file),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
