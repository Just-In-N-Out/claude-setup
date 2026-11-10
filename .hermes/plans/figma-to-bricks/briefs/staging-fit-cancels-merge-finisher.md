# Finisher brief: after-merge steps for staging-fit-cancels (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `f40ce6ce`
(Build 2026-11-10.5) to `4a352ffd1dd34210512abfc9abe3e23df3858c2f` (`staging-fit-cancels-stack10`), accepted by
`ac-check.sh --reviews` (ALL ACCEPTED 3/3; the plan has no live AC). The main session holds the merge lock
(`website-importer`); don't touch the lock. Never stop to ask. Never load bdryswi.com, B-Dry staging or any live site;
no logins; never write to any WordPress site; never run `npm run site:upload` against anything. Start no agents.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main", the `.superpowers` line, the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `4a352ffd1dd34210512abfc9abe3e23df3858c2f`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it alone, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-10.5`); bump `BUILD` for today's date (`date +%F`; expect `2026-11-10.6`, or
   the next free `.N`; if the date has rolled over, `<today>.1`). Run `npm run build` and `npm run check`; both must
   exit 0 (tsc not found → testing-pitfalls). Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. (If the unit
   suite is killed for memory, check earlyoom and rerun it under `systemd-run --user --scope -p MemoryMax=8G -p
   MemorySwapMax=0`.)
3. Records in the same commit (docs only besides `build.ts`):
   - `git ls-files .superpowers/` must be empty (the ledger is `docs/plans/2026-11-09-staging-fit-cancels-ledger.md`).
   - **Paste check id:** the next free after 3dt. Confirm it is free on main's HANDOFF (`command grep -rhoE
     --exclude-dir=evidence '\b3d[a-z]\b' docs/ | sort -u`) and unclaimed on every local branch's HANDOFF and in the
     plans under `~/.hermes/plans/figma-to-bricks/` (other unmerged jobs write `<… id at merge>` placeholders, so
     expect **3du**). Replace every `<staging-fit-cancels id at merge>` in `docs/HANDOFF.md` (the section heading, the
     paste-check line, the end-of-run list entry) and the ledger's own placeholders for this job, and every "build set
     at the merge" / `<at merge>` placeholder of this job with the new BUILD (leave quoted history as history). Its
     check is Justin's (the plan has no live AC): he converts his new B-Dry capture and looks at the hero buttons on
     phones, as the section's own steps say.
   - **The approved plan was amended (wording only) after the branch's plan commit:** copy
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels/plan-approved.md` over
     `docs/plans/2026-11-09-staging-fit-cancels.md` (byte for byte; `cmp` them).
   - **Stale words to correct** (the job's HANDOFF section, its "Proof" paragraph near the top, and anywhere else the
     section says it): "on main the paste's link at 600 is `rgb(0, 0, 238)`, underlined, no background" was true for
     the old test renderer. Since Build 2026-11-10.4 the renderer prints a class's controls as
     `.cls.brxe-<element>`, as real Bricks does: on main before this job the link at 600 kept its background and
     colour and lost its corner radius (0 against 6 px) and gained an underline. Say both, plainly (what staging
     showed and the old renderer drew; what main drew since Build 2026-11-10.4), and keep the head's result as it is.
   - **The ledger's stack-10 entry** says the site-media-upload story pin's golden for `saved.elementor-stretch` "is a
     fixer's to make again". Correct that line: the pin (`F2B_STORY_PINS=1`) is site-media-upload's story-time
     receipt, kept out of the default suite; this job moves it by design (the three boxes where main wrote `flex-*:
     revert`); it is **not** regenerated (review 3, R3-1).
   - HANDOFF's section, "Known limits" / "Deferred": add each of these if the section doesn't already say it, in the
     section's own style (read the section first; reword nothing else):
     - "The inline-link limit (job control-weight, built, waiting to merge) is not specific to 768–991: it shows
       wherever a wrapper's words hold the link at some range and not at others (the blind auditor's pages: 600–899;
       479 and below, which is phones): the link paints `inline-block` where the site's is `inline`, on main and on
       this build alike."
     - "The sub-pixel gap between neighbouring runs also reaches a live widget's inner box: at a CSS width such as
       767.5 (a zoomed browser) it gets no max-width but keeps the desktop margin (R2-1)."
     - "The accordion exception's `.acc > .brx-open .cls { prop: revert }` (0,3,0) also beats the same element's own
       hover rule (0,2,0): where a property moved onto the open item also changes on hover, the open item loses its
       hover look; site-faq's design, on main before this job too (R2-2, predicted from source)."
     - "Test gaps: the rewritten live-widget R1-4 assertion doesn't check that max-width is absent from the box's
       base rule (R2-3); the `todo` test for the inline-link limit reads what the first test fills, so on a tree
       where the first test fails it passes without proving anything (R2-4)."
     - "`corpus/web` isn't in the repo: AC2's 'corpus captures' are covered by fixture captures and B-Dry's saved
       stand-ins, named-only."
4. Commit `Build <BUILD>: a website paste's per-width rules never cancel another rule: a value a width range drops is
   written as bounded runs, never as revert (staging-fit-cancels)` (plain `git commit -m`, or `-F <file>`; no author
   override, no AI or Co-Authored-By lines; `git diff --cached --name-only` must not list CLAUDE.md or
   site-check-out), then `git push` (`main` only, through the repo's own credential helper as Just-In-N-Out; never
   switch gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git):
   - **Status:** the build line (`Current build <BUILD>`) and one line at the top of the feature list in the house
     style. A draft; **check every detail against HANDOFF's section and the code (`src/core/site/blocks.ts`:
     `runsOf`, `boundsOf`, `mediaOf`; `test/fixtures/site-drops.ts` `excepted`) and correct what differs**:
     "**<BUILD> staging-fit-cancels (website importer):** a website paste no longer cancels a declaration at a width
     range with `revert` (it rolled back the whole author origin, so a wrapper's rule at a narrower range turned a
     painted button into a plain underlined link with square corners): a value a range drops is written as bounded
     media runs; classes change only where main wrote such a `revert` (B-Dry's home: 0 left, 18 before); two uses
     stay, named: an Elementor accordion's open look and a slider's `<button>` arrows and dots; the live widget's
     inner box prints as a bounded block too; other pastes and Figma designs are byte for byte as before. Q1 A (only
     classes where a range drops a value change) and Q2 A not yet confirmed. Known limit: a link its wrapper reads
     as an inline word at some widths paints `inline-block` there (control-weight). Paste check **<id>** (B-Dry's
     hero buttons on phones, after a re-capture)."
   - **One standing rule under "Working in this repo"**, after the line "**Bricks wraps every Section, Container and
     Block from 767px down**…" (or beside the other code-route lines if you find a better home; say where): "**A
     website paste never cancels a declaration at a width range with `revert`** (staging-fit-cancels): `revert` rolls
     back the whole author origin, so it also beats the element's own class and controls. A value a range drops is
     written as bounded runs (`src/core/site/blocks.ts`); the only `revert`s left are the site-reset class's own, an
     accordion's open look and a slider's button parts (`test/fixtures/site-drops.ts` `excepted`;
     `test/unit/site-no-revert.test.ts` fails on any other). A job that changes what a site paste writes on purpose
     makes `test/fixtures/site-no-revert-main.json` again on its own tree (`node tools/site-no-revert-golden.ts .`)."
   If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/staging-fit-cancels-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `4a352ffd`, `git status` clean but for
   `site-check-out/`, `origin/main` equals `main` after the push.

## Rules
- Never commit CLAUDE.md; never bare `git stash`; never force anything. Don't touch any worktree or other branch. Change
  no source or test file (only `src/shared/build.ts` and docs; the stale comment in
  `test/web/site-range-cancels.test.ts`'s header is a test file: leave it, and say so).
- Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls.
- SIGTERM / exit 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

## Report
The build number, the commit SHA, the push result, the paste check id, the CLAUDE.md lines written (or the pending
file), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or
memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
