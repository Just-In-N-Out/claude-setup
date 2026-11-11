# Finisher brief: after-merge steps for site-one-command (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `11e885fd`
(Build 2026-11-10.8) to `8c872ad2163382848a53170eef5d4bd7152779fb` (`site-one-command-fix1`), accepted by
`ac-check.sh --reviews` (READY FOR THE USER 12/14; AC13 and AC14 live, Justin's). The main session holds the merge
lock (`website-importer`); don't touch the lock. Never stop to ask. Never load bdryswi.com, B-Dry staging or any live
site; no logins; never write to any WordPress site; never run `npm run site:upload` or `npm run site:import` against
anything. Start no agents. Several other agents are running tests and Chrome on this machine: touch none of their
processes, worktrees or branches.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main", the `.superpowers` line, the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `8c872ad2163382848a53170eef5d4bd7152779fb`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it alone, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-10.8`); the date has rolled over (`date +%F` → `2026-11-11`), so `BUILD`
   becomes `2026-11-11.1` (or the next free `.N` if another session bumped it). Run `npm run build` and `npm run
   check`; both must exit 0 (tsc not found → testing-pitfalls). Node `/home/justin/.local/node-v22.23.3/bin` first on
   PATH. (If the unit suite is killed for memory, check earlyoom and rerun it under `systemd-run --user --scope -p
   MemoryMax=8G -p MemorySwapMax=0`.) This job leaves `dist/` byte-identical apart from the build number.
3. Records in the same commit (docs only besides `build.ts`):
   - `git ls-files .superpowers/` must be empty (the ledger is `docs/plans/2026-11-10-site-one-command-ledger.md`).
   - **Paste check id:** the next free after 3dv. Confirm it is free on main's HANDOFF (`command grep -rhoE
     --exclude-dir=evidence '\b3d[a-z]\b' docs/ | sort -u`) and unclaimed on every local branch's HANDOFF and in the
     plans under `~/.hermes/plans/figma-to-bricks/` (unmerged jobs write `<… id at merge>` placeholders; expect
     **3dw**). Replace every `<site-one-command id at merge>` in `docs/HANDOFF.md` and the ledger, and every "build
     set at the merge" / `<at merge>` placeholder of this job with the new BUILD (leave quoted history as history). Its
     live checks are AC13 and AC14 (Justin's own `npm run site:import` run against B-Dry staging and his paste: the
     plan's "Justin's check" steps, which HANDOFF's section must hold).
   - **The approved plan was amended (A1–A11) after the branch's plan copy?** Copy
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-one-command/plan-approved.md` over
     `docs/plans/2026-11-10-site-one-command.md` and `cmp` them (they should already be equal).
   - HANDOFF's site-one-command section, "Known limits" / "Deferred" / "Not yet confirmed": add each of these if the
     section doesn't already say it, in the section's own style (read the section first):
     - "Not yet confirmed by Justin: Q1 A (the password asked once, at the start, kept in the tool's memory through the
       scan), Q2 A (`--dry-run` asks no password and sends nothing), Q3 A (no flag to reuse a scan: every ending that
       didn't upload everything prints the `site:upload` line that finishes from it), Q4 A (files go to
       `~/Downloads/<page name>/`). Q5 is Justin's own answer ('Only real failures')."
     - "The typed-ahead drop protects a terminal only: on a pipe a `yes` written during the scan is taken (only this
       computer's own address is allowed on a pipe, so only a local WordPress run is exposed) (verifier)."
     - "`site:upload`'s own yes question still takes typed-ahead input (unchanged by this job; a follow-up)."
     - "With `--no-shots`, the 'no file' warning counts layer-picture fills only shots would fill and blames the old
       site for them (review 2, R2-1); warnings print before `site:upload`'s own refusal line (R2-3); Ctrl+C inside the
       owned question's 150 ms settle exits 130 without the 'Stopped during the scan' line (R2-4); Ctrl+C during the
       scan leaves Chrome's profile folder in TMPDIR (no secret in it)."
     - "Test gaps: AC2's request-path assertion would print a matched password form if it ever failed (the rest of
       R1-9); AC4's test never seeds a record of the same site (the auditor's probe covers it); AC11's 'stopped'
       scenario can differ under heavy load (which pictures went up before the stop); the pty subtests need a TMPDIR
       of about 24 characters or Chrome's socket path is too long."
     - "**For the next job that touches the capture's launch (site-menu, unmerged):** `tools/lib/capture-run.ts` is
       new in this build, so a rebase onto it shows no git conflict there: `capture-run.ts` must then call
       `launchCaptureChrome({ path: chrome.path, args: chrome.args, visible })` by hand (both commands lose the socket
       gate otherwise), and `test/unit/capture-chrome.test.ts`'s case pins it (the joined shape is in site-menu's
       approved plan)."
4. Commit `Build <BUILD>: one command, npm run site:import, asks for WordPress first, then scans, uploads the pictures
   and writes the pastes (site-one-command)` (plain `git commit -m`, or `-F <file>`; no author override, no AI or
   Co-Authored-By lines; `git diff --cached --name-only` must not list CLAUDE.md or site-check-out), then `git push`
   (`main` only, through the repo's own credential helper as Just-In-N-Out; never switch gh accounts or change the
   remote).
5. Update the repo `CLAUDE.md` (not in git):
   - **Status:** the build line (`Current build <BUILD>`; the date in the Status heading becomes 2026-11-11) and one
     line at the top of the feature list in the house style. A draft; **check every detail against HANDOFF's section
     and the code (`tools/site-import.ts`, `tools/lib/site-import/*`, `tools/lib/site-upload/ask.ts`) and correct what
     differs**: "**<BUILD> site-one-command (website importer):** `npm run site:import -- <old page> <https://your-site>
     [--elementor] [--user …] [--dry-run] [--no-shots] [--out …]` asks for the WordPress site, user name and
     Application Password first and tests the login (a wrong one stops in seconds, before any scan), scans the page
     (the person check in the visible window if the site asks), stops only for a real failure (a failed scan, a page
     that isn't the site's, a range read without the site's styles, `site:upload`'s own refusals) and prints every
     smaller problem as a warning (Justin's 'Only real failures'), lists the pictures with their alt texts, uploads
     with `site:upload`'s uploader only after a `yes` typed after the question shows (anything typed before it,
     with or without Enter, is dropped), and writes the pastes with numbered next steps; `capture`, `capture:check`,
     `site`, `site:upload` and the Figma plugin are byte for byte as before. Q1–Q4 not yet confirmed. Paste check
     **<id>** (AC13, AC14, live: his own run against B-Dry staging, then the paste)."
   - **The standing rule:** replace the bullet "**One tool writes to WordPress: `npm run site:upload`** … never writes
     to a site." with exactly the fenced text in the approved plan's "Standing-rule change" section (byte for byte).
   - **The decision bullet** "A scanned page's pictures go to WordPress from the command line": replace "its own command
     `site:upload` (Q1 A)" with the plan's replacement text from the same section (drop the plan's `[amended A7]`
     tag; keep the words).
   - The ledger's "For the merge finisher: CLAUDE.md lines" section (`docs/plans/2026-11-10-site-one-command-ledger.md`
     line 248 on): read it; where it differs from the above, follow the approved plan and say what differed.
   If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/site-one-command-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `8c872ad2`, `git status` clean but for
   `site-check-out/`, `origin/main` equals `main` after the push.

## Rules
- Never commit CLAUDE.md; never bare `git stash`; never force anything. Don't touch any worktree or other branch.
  Change no source or test file (only `src/shared/build.ts` and docs).
- Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls.
- SIGTERM / exit 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

## Report
The build number, the commit SHA, the push result, the paste check id, the CLAUDE.md lines written (or the pending
file), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or
memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
