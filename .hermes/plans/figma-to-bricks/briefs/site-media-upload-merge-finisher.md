# Finisher brief: after-merge steps for site-media-upload (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `7eeca437`
(Build 2026-11-10.4) to `c1b52ce2751fe18229d5ac7484e69ec9efff3114` (`site-media-upload-stack8`), accepted by
`ac-check.sh --reviews` (READY FOR THE USER 14/16; AC15 and AC16 live, Justin's). The main session holds the merge lock
(`website-importer`); don't touch the lock. Never stop to ask. Start no agents.

**The one rule above all others:** this job's tool (`npm run site:upload`) writes to WordPress. **You never run it
against anything** (not even a dry run against a real address); you use no login, password or key and never look for
one; you load no live site. `npm run build` and `npm run check` are all you run (the unit tests start only their own
127.0.0.1 stand-in).

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main", the `.superpowers` line, the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `c1b52ce2751fe18229d5ac7484e69ec9efff3114`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it alone, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-10.4`); bump `BUILD` for today's date (`date +%F`; expect `2026-11-10.5`, or
   the next free `.N`; if the date has rolled over, `<today>.1`). Run `npm run build` and `npm run check`; both must
   exit 0 (tsc not found → testing-pitfalls). Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. (If the unit
   suite is killed for memory, check earlyoom and rerun it under `systemd-run --user --scope -p MemoryMax=8G -p
   MemorySwapMax=0`.)
3. Records in the same commit (docs only besides `build.ts`):
   - `git ls-files .superpowers/` must be empty (the ledger is `docs/plans/2026-11-10-site-media-upload-ledger.md`).
   - **Paste check id:** the next free after 3ds. Confirm it is free on main's HANDOFF (`command grep -rhoE
     --exclude-dir=evidence '\b3d[a-z]\b' docs/ | sort -u`) **and** unclaimed on every local branch's HANDOFF and in
     the plans under `~/.hermes/plans/figma-to-bricks/` (other unmerged jobs write `<… id at merge>` placeholders, so
     expect **3dt**). Replace every `<site-media-upload id at merge>` in `docs/HANDOFF.md` (the section heading, the
     paste-check line, the end-of-run list entry) and in the ledger's own placeholders for this job, and every "build
     set at the merge" / `<at merge>` placeholder of this job with the new BUILD (leave the ledger's quoted history of
     other jobs' placeholders as history). Its live checks are AC15 and AC16 (Justin: a fresh capture of bdryswi.com,
     `capture:check`, the dry run, the upload to staging, the second run uploading nothing, then the paste showing his
     library's pictures and the old site's alt text; HANDOFF's numbered steps).
   - **The approved plan was amended (wording only, A1–A7) after the branch's plan commit:** copy
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload/plan-approved.md` over
     `docs/plans/2026-11-10-site-media-upload.md` (the repo's plan becomes the approved copy, byte for byte; `cmp`
     them).
   - HANDOFF's site-media-upload section, "Known limits" / "Deferred" / "Not yet confirmed": add each of these if the
     section doesn't already say it, in the section's own style (read the section first; reword nothing already there):
     - "Not yet confirmed by Justin: the ⭐ answers Q1–Q11, and Q12 (when the site refuses a picture type — in practice
       AVIF on WordPress before 6.5, or a plugin turning it off — the run stops there and every re-run stops at the
       same picture until the site allows the type, as built; or skip that picture, name it and send the rest)."
     - "Once any request is answered with a redirect, the tool's note about it stays set for the run and can replace an
       unrelated picture's 'Couldn't reach the site' reason (words only; review 2, R2-1)."
     - "The re-run's file reads have a time limit only until the headers arrive; a file that then arrives very slowly
       holds the re-run before the `yes` until Ctrl+C (reads only, the typed site, no login; R2-2)."
     - "The scrubber's `Basic <word>` pattern also hides an ordinary word after 'Basic' (a site titled 'Basic Fitness
       Club' prints as 'Basic [hidden] Club'), and the yes prompt, which holds the site's name, is not passed through
       it (R2-3)."
     - "The checks' picture stand-ins (`drawPictures`) list a library picture as 'not drawn'; no command reaches it,
       because `site:check` and `site:live` take no `--media` (stack 8)."
     - "A picture whose only file is an SVG the site refuses shows WordPress's own words in the summary, not the hint
       to allow SVG uploads and use `--svg` (fixer 1)."
     - "Test gaps (the behaviour holds; supporting tests and both independent checks' own harnesses cover them): AC10's
       cited test can't fail when the origin check or the guard's own 3xx refusal is removed; AC8's and AC11's cited
       tests never exercise the scrubber or the byte comparison before a library item is taken (blind auditor M02,
       M04, M10, M11, M12)."
     - "For the next job that moves onto this one: site-native-structure's fold writes a linked picture's Image itself
       (`elementor-fold.ts`), bypassing `imageSettings` and the picture list: once stacked, a linked logo would keep
       its old address unless the fold goes through the media map (review 1, R1-6)."
4. Commit `Build <BUILD>: npm run site:upload sends a scanned page's own pictures to the WordPress media library and
   writes pastes showing them (site-media-upload)` (plain `git commit -m`, or `-F <file>`; no author override, no AI or
   Co-Authored-By lines; `git diff --cached --name-only` must not list CLAUDE.md or site-check-out), then `git push`
   (`main` only, through the repo's own credential helper as Just-In-N-Out; never switch gh accounts or change the
   remote).
5. Update the repo `CLAUDE.md` (not in git), copying the three texts the ledger holds for you
   (`docs/plans/2026-11-10-site-media-upload-ledger.md`, "CLAUDE.md lines for the merge finisher to write"), with the
   new BUILD and the paste-check id filled in:
   - **Status:** the build line (`Current build <BUILD>`) and the feature line at the top of the feature list. Check
     its details against `package.json` and `tools/site-upload.ts` (the command's real arguments and flags) and add,
     in the house style, what the fix round added: a stop (Ctrl+C) loses no upload and a re-run uploads no file
     twice; every printed line is scrubbed of anything password-shaped.
   - **Under "Working in this repo", right after "`npm run site:live` only reads a published page"** (itself after
     "The importer never hides that its Chrome is automated"): the standing-rule bullet "**One tool writes to
     WordPress: `npm run site:upload`** …" **word for word as the ledger has it** (it is the rule-change paragraph
     Justin's plan carries: only adds media, only on the typed site, after reading that site and a typed `yes`, the
     password at a hidden prompt; only Justin runs it; agents never run it against his site or any live site, never
     ask for or hold his password, and test it only against `test/fixtures/wp-standin.ts`; every other tool stays
     read-only). Don't soften or shorten it.
   - **Under "Decisions the user made":** the bullet "**A scanned page's pictures go to WordPress from the command
     line** …" as the ledger has it, with "Q12 open" added to its "not yet confirmed" words.
   If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/site-media-upload-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `c1b52ce2`, `git status` clean but for
   `site-check-out/`, `origin/main` equals `main` after the push.

## Rules
- Never commit CLAUDE.md; never bare `git stash`; never force anything. Don't touch any worktree or other branch. Change
  no source or test file (only `src/shared/build.ts` and docs).
- Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls.
- SIGTERM / exit 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

## Report
The build number, the commit SHA, the push result, the paste check id, the CLAUDE.md lines written (or the pending
file), a line confirming you ran no upload and used no login, then `skill_lessons[{skill, lesson, evidence, enforce}]`
(reusable only; empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these
skill_lessons now.`
