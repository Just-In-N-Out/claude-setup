# Finisher brief: after-merge steps for capture-refused-styles (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `e16d3d1e`
(Build 2026-11-11.2) to `ebd4dfc8ed78e511b3671985eb2bb3d7f165013e` (`capture-refused-styles-stack2`), accepted by
`ac-check.sh --reviews` (READY FOR THE USER 9/10; AC9 live, Justin's). The main session holds the merge lock
(`website-importer`); don't touch the lock. Never stop to ask. Never load bdryswi.com, B-Dry staging or any live site;
no logins; never write to any WordPress site; never run `site:upload` or `site:import` against anything. Start no
agents. Other agents and Justin run tests and Chrome on this machine: touch none of their processes, worktrees or
branches. **Justin is waiting on this merge to scan his client's site: work quickly** (about 10 minutes).

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main", the `.superpowers` line, the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `ebd4dfc8ed78e511b3671985eb2bb3d7f165013e`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it alone, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-11.2`); bump `BUILD` for today (`date +%F`; expect `2026-11-11.3`, or the
   next free `.N`). Run `npm run build` and `npm run check`; both must exit 0. Node
   `/home/justin/.local/node-v22.23.3/bin` first on PATH (if the unit suite is killed for memory, check earlyoom and
   rerun under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`).
3. Records in the same commit (docs only besides `build.ts`):
   - `git ls-files .superpowers/` must be empty.
   - **Paste check id:** the next free after 3dx (expect **3dy**; confirm free on main's HANDOFF with `command grep
     -rhoE --exclude-dir=evidence '\b3d[a-z]\b' docs/ | sort -u` and unclaimed on every local branch's HANDOFF and in
     `~/.hermes/plans/figma-to-bricks/`). Replace every `<capture-refused-styles id at merge>` and every "build set at
     the merge" / `<at merge>` placeholder of this job in `docs/HANDOFF.md` and the ledger with the id and the new
     BUILD. Its live check is AC9 (Justin's own `npm run capture` / `site:import` of bdryswi.com ends with a clean
     capture, or the plain refusal line and its log).
   - Copy `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/plan-approved.md` over
     `docs/plans/2026-11-10-capture-refused-styles.md` (`cmp` them).
   - HANDOFF's capture-refused-styles section, "Known limits" / "Deferred", add if missing (the section's own style):
     - "**Missing pictures after a renewal in the hidden window (blind auditor A1, P2, deferred by Justin: 'merge now
       will fix later'):** when a site's check passes itself (no 'I am human' press) and its pass runs out at the scan's
       end, the renewed downloads go out through the browser tab marked as `HeadlessChrome`, while every other request
       carries the capture's own agent; a site that ties its pass to the browser's name, or blocks headless agents,
       refuses them, so the scan ends `Pictures n/N` with pictures missing (exit 0; `capture:check` names them). A scan
       where a person presses 'I am human' in the visible window is not affected. A pass shorter than about 4 s ends
       the same way; after the 3-renewal cap a still-refused picture is kept as a note."
     - "A 429's `Retry-After` isn't read: on a host that rate-limits picture downloads each round waits the full 30 s
       (every picture still comes)."
4. Commit `Build <BUILD>: a scan survives a site whose check comes back partway (the range and the pictures are read
   again asking the site), a site that keeps refusing stops with a plain line and a log, and a page refused from the
   first load is never saved without its styles (capture-refused-styles)` (plain `git commit -m` or `-F <file>`; no
   author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md or site-check-out),
   then `git push` (`main` only, through the repo's own credential helper as Just-In-N-Out; never switch gh accounts or
   change the remote).
5. Update the repo `CLAUDE.md` (not in git) **Status:** the build line and one line at the top of the feature list in
   the house style, checked against HANDOFF's section and the code (`src/web/renew.ts`, `src/web/styled.ts`,
   `tools/lib/capture-refused.ts`): "**<BUILD> capture-refused-styles (website importer):** a scan of a site whose
   check comes back partway (bdryswi.com on WordPress.com) reads the range again asking the site for its page (the
   person may press 'I am human' once more), renews the pass for the pictures and font files at the scan's end (at
   most 3 renewal page loads, each tab closed once its page loads), stops a site that keeps refusing with one line
   naming who refused what and what to type plus a `.f2b-refused.json` log (no cookies), and never saves a page whose
   own stylesheets were all refused from the first load; the command's stop lines say what to type; sites that refuse
   nothing scan byte for byte as before and no slower. Q1–Q6 not yet confirmed. Known limit: after a renewal in the
   hidden window the downloads are marked HeadlessChrome (a site tying its pass to the browser name can leave
   pictures missing; Justin: fix later). Paste check **<id>** (AC9, live: Justin's own scan of bdryswi.com)."
   If writing CLAUDE.md is refused, leave the lines in `~/.hermes/plans/figma-to-bricks/capture-refused-styles-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `ebd4dfc8`, `git status` clean but for
   `site-check-out/`, `origin/main` equals `main` after the push.

## Rules
Never commit CLAUDE.md; never bare `git stash`; never force anything. Change no source or test file (only
`src/shared/build.ts` and docs). Multi-step scripts written with Write and run with `bash <file>`; git commands as
separate plain calls. SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso |
grep -E 'sending SIG[A-Z]* to process'`).

## Report
The build number, the commit SHA, the push result, the paste check id, the CLAUDE.md lines written (or the pending
file), then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check
and save these skill_lessons now.`
