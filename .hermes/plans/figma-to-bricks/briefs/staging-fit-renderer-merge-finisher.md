# Finisher brief: after-merge steps for staging-fit-renderer (website importer checks)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `2879e496`
(Build 2026-11-10.3) to `8a8ec104bdad91635bfbb0732a0ebc1a0673d9b5` (`staging-fit-renderer-stack4`), accepted by
`ac-check.sh --reviews` (READY FOR THE USER 4/5; AC5 live, Justin's). The main session holds the merge lock
(`website-importer`); don't touch the lock. Never stop to ask. Never load bdryswi.com, B-Dry staging or any live site
(don't run `site:live` against a real address); no logins; never write to any WordPress site. Start no agents.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main", the `.superpowers` line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `8a8ec104bdad91635bfbb0732a0ebc1a0673d9b5`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it alone, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-10.3`); bump `BUILD` for today's date (`date +%F`; expect `2026-11-10.4`, or
   the next free `.N`). Run `npm run build` and `npm run check`; both must exit 0 (tsc not found → testing-pitfalls).
   Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. (If the unit suite is killed for memory, check earlyoom
   and rerun it under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`.)
3. Records in the same commit (docs only besides `build.ts`):
   - `git ls-files .superpowers/` must be empty (the ledger is `docs/plans/2026-11-09-staging-fit-renderer-ledger.md`).
   - Paste check id **3ds** (the next free after 3dr on main; confirm with `command grep -rhoE --exclude-dir=evidence
     '\b3d[a-z]\b' docs/ | sort -u`): replace every `<staging-fit-renderer id at merge>` in `docs/HANDOFF.md` (the
     section heading at the top, the paste-check line, the end-of-run list entry) and in the ledger's own placeholders
     for this job, and every `<set at the merge>` / `<at merge>` / "build set at the merge" placeholder of this job with
     the new BUILD (leave the ledger's quoted history of other jobs' placeholders as history). Its live check is AC5
     (Justin, after his re-paste of B-Dry's whole `--elementor` home on staging /homev2/: he runs `site:live` on the
     logged-out staging page against his capture, as the section's own numbered steps say).
   - **The approved plan was amended after the branch's plan commit:** copy
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/plan-approved.md` over
     `docs/plans/2026-11-09-staging-fit-renderer.md` (the repo's plan becomes the approved copy, byte for byte; `cmp`
     them).
   - HANDOFF's staging-fit-renderer section, Known limits / Deferred: add each of these if the section doesn't already
     say it, in the section's own style (read the section first; reword nothing that is already there):
     - "When `site:live` itself is killed outright (`kill -9`, an out-of-memory killer such as this desktop's earlyoom),
       its Chrome is left running in its own process group with nothing holding it to reads: the blind auditor saw 230
       non-read requests reach its stand-in and 16 Chrome processes left. Every other ending (OK, a stop, an error,
       Ctrl+C, Ctrl+\, SIGTERM, SIGHUP, a cut pipe) lets only reads through and leaves no Chrome. After such a kill,
       end the leftover Chrome by its profile path. A follow-up: a watcher that outlives the tool."
     - "The 'drew nothing' line for a live widget advises regenerating code signatures and purging the cache; when the
       widget's own host is down or refuses the staging address that advice doesn't apply (review 6, R6-1)."
     - "`renderer.parts[].worst` is null for a missing element while the top-level fields say 'missing' (R5-4); no
       fixture puts a live widget's slot beside siblings in a row (mutant M13, a test gap; R5-3)."
     - "Other jobs' page helpers (`test/web/lib/motion-check.ts`, `svg-paint.ts`, `interactions.ts`) still find
       elements by `#brxe-<id>` alone: inside a looping or re-mounted slider they need the shared locator's rule (the id,
       else the `brxe-<id>` class, never a `.splide__slide--clone`)."
4. Commit `Build <BUILD>: the website checks see what real Bricks shows: the renderer prints class CSS as Bricks does,
   site:check --whole, and site:live reads a published page (staging-fit-renderer)` (plain `git commit -m`, or `-F
   <file>`; no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` must not list CLAUDE.md
   or site-check-out), then `git push` (`main` only, through the repo's own credential helper as Just-In-N-Out; never
   switch gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git):
   - **Status**: the build line (`Current build <BUILD>`) and one line at the top of the feature list in the house
     style. A draft; **check every detail of it against HANDOFF's section and `package.json` / `tools/site-live.ts`
     (the command's real arguments and flags) and correct what differs**:
     "**<BUILD> staging-fit-renderer (website importer checks):** the test renderer prints a class's control CSS with
     the element's `brxe` class and Bricks 2.4.2's front-end CSS, as Bricks prints the page (`--bricks 2.3.9` for the
     older); `site:check -- --whole` draws header, page and footer together and stands in other hosts' pictures from
     the capture; new `npm run site:live` reads a published Bricks page (reads only: everything but GET/HEAD/OPTIONS is
     refused and its Chrome is ended by kill), maps it to the paste and measures it against the capture and the
     renderer's drawing, naming an element the page holds in another's place; pastes and Figma designs are byte for
     byte as before. Paste check **3ds** (AC5, live: `site:live` on B-Dry staging /homev2/ after the re-paste)."
   - One standing rule under "Working in this repo", after the line "**The importer never hides that its Chrome is
     automated**…": "**`npm run site:live` only reads a published page** (staging-fit-renderer): its Chrome refuses
     every request but GET/HEAD/OPTIONS, with Chrome's own report uploads off, and is ended by killing its process
     group, never asked to close (a closing page sends its goodbye POSTs); it stops at a login page and never signs in.
     A tool that loads a user's site keeps to this (`tools/lib/read-only.ts`)." (Correct the file name if the guard
     lives elsewhere.)
   If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/staging-fit-renderer-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `8a8ec104`, `git status` clean but for
   `site-check-out/`, `origin/main` equals `main` after the push.

## Rules
- Never commit CLAUDE.md; never bare `git stash`; never force anything. Don't touch any worktree or other branch. Change
  no source or test file (only `src/shared/build.ts` and docs).
- Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls.
- SIGTERM / exit 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

## Report
The build number, the commit SHA, the push result, the paste check id, the CLAUDE.md lines written (or the pending file),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
