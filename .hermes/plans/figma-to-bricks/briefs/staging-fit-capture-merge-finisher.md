# Finisher brief: after-merge steps for staging-fit-capture (website importer)

**Role:** after-merge finisher (fresh Fable 5.2, high), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `fd1986dc`
(Build 2026-11-09.3) to `7f44f989ae5780289a7f3df99aa87bf8d3825833` (`staging-fit-capture-fix1`), accepted by `ac-check.sh
--reviews` (READY FOR THE USER 5/6; AC6 live, Justin's). The main session holds the merge lock (`website-importer`);
don't touch the lock. Never stop to ask. Never load bdryswi.com or any live site; no logins; never write to any
WordPress site. Start no agents.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Merging" steps, the `.superpowers` line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `7f44f989ae5780289a7f3df99aa87bf8d3825833`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it alone, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-09.3`); bump `BUILD` for today's date (`date +%F`; expect `2026-11-09.4`, or
   the next free `.N`, or `<tomorrow>.1` if the date has turned). Run `npm run build` and `npm run check`; both must exit
   0 (tsc not found → testing-pitfalls). Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. (Unit tests listed at
   Mac corpus paths skip on this desktop: fine. Other agents are running Chrome suites: if the unit suite is killed for
   memory, check earlyoom and rerun it under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`.)
3. Records in the same commit:
   - `git ls-files .superpowers/` must be empty (the ledger is already `docs/plans/2026-11-09-staging-fit-capture-ledger.md`).
   - Paste check id **3do** (the next free after 3dn on main and on every local job branch, checked by the session;
     confirm with `command grep -rhoE --exclude-dir=evidence '\b3d[a-z]\b' docs/ | sort -u`): replace every
     `<staging-fit-capture id at merge>` in `docs/HANDOFF.md` (the heading, the paste-check line, the end-of-run list
     entry) and the ledger, and every `<at merge>` / "build set at the merge" placeholder of this job with the new BUILD.
     Its live check is AC6 (Justin re-captures bdryswi.com with this build; the new capture has no flagged range; he
     re-pastes its `--elementor` whole paste on staging and the tablet widths are read).
   - The approved plan: `diff /home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-capture/plan-approved.md
     docs/plans/2026-11-09-staging-fit-capture.md`; if the approved copy holds an amendment the repo plan lacks, bring the
     repo plan to it for that amendment (nothing else).
   - HANDOFF's staging-fit-capture section, known limits / Deferred: add if missing, in the section's own style:
     - "Under a host that limits by request rate (503 once more than a couple of stylesheet requests arrive within
       seconds, unlike a stylesheet failing for a whole page load), a capture can still finish unflagged with right
       boxes but some ranges' code read as longhands; its paste was up to 35 px off at phone widths in a probe. `npm run
       site:check -- <capture> --all --elementor` on the new capture shows it (0 px on a clean capture): run it after
       every capture. A suspicion until a real capture shows it (blind auditor, `evidence/staging-fit-capture/auditor/
       probe-rate*.txt`)."
     - "A capture made before this build (no `web.code.sheets`) is judged from its declarations alone: a styleless
       design-width range or only-narrowest styleless ranges are not seen. New captures can't be saved that way."
4. Commit `Build <BUILD>: a capture never keeps a width range read without the site's styles, and a scan that has one is
   refused with a plain line (staging-fit-capture)` (plain `git commit -m`, no author override, no AI or Co-Authored-By
   lines; `git diff --cached --name-only` must not list CLAUDE.md or site-check-out), then `git push` (`main` only,
   through the repo's credential helper as Just-In-N-Out; never switch gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the build line (`Current build <BUILD>`; the heading date stays
   today's) and one line at the top of the feature list in the house style:
   "**<BUILD> staging-fit-capture (website importer):** a capture reads a width range again when it loaded without the
   site's stylesheets, and stops with one plain line (widths and stylesheet named, no file written) when they never
   arrive; `npm run site`, `site:check`, `capture:check` and the panel refuse a capture holding such a range (Justin's
   2026-11-09 bdryswi.com capture: 768–991) with "capture the page again"; clean captures and Figma designs convert byte
   for byte as before. Paste check **3do** (AC6, live: re-capture bdryswi.com, re-paste on staging, tablets)."
   No standing rule changed. If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/staging-fit-capture-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `7f44f989`, `git status` clean but for
   `site-check-out/`, `origin/main` equals `main` after the push.

## Rules
- Never commit CLAUDE.md; never bare `git stash`; never force anything. Don't touch any worktree or other branch.
- Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls.
- SIGTERM / exit 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

## Report
The build number, the commit SHA, the push result, the paste check id, the CLAUDE.md lines written (or the pending file),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
