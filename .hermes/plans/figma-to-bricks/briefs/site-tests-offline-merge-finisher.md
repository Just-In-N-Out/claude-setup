# Finisher brief: after-merge steps for site-tests-offline (test runs never reach the internet; test-only)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a worktree).
The session just fast-forwarded local `main` from `e2fc35aa` (Build 2026-11-15.1) to `39a1e20dd77f4e0c7d3bdea28d9e64fe208b466c`
(`site-tests-offline-fix3`), accepted on that head: `ac-check.sh` ALL ACCEPTED 4/4, review 4 clean, verifier 3 and the blind auditor clean.
The session holds the merge lock (owner `website-importer`); don't touch it. Never stop to ask. Never load any live site; no logins; never
write to any WordPress site; touch nothing under `~/Downloads`. Start no agents. Touch no other agent's processes, worktrees or branches.
Work quickly (15–20 minutes). Files only with Write/Edit (no heredocs, no `sed -i`).

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge
into main") and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `39a1e20dd77f4e0c7d3bdea28d9e64fe208b466c`, branch `main`, clean but for untracked `site-check-out/`.
2. **No BUILD bump:** the job changes nothing under `src/`, `tools/`, `manifest.json` or `build.mjs` (`git diff --name-only e2fc35aa HEAD --
   src tools manifest.json build.mjs` must be empty; if it isn't, stop and report). `npm run check` exits 0, run as `systemd-run --user
   --scope -p MemoryMax=8G -p MemorySwapMax=0 --working-directory=<repo> /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; npm run check'`.
3. Records in one commit (docs only; `git show --stat HEAD` lists each):
   - Ledger: `git mv` `.superpowers/sdd/<the site-tests-offline folder>/progress.md` (`ls .superpowers/sdd/ | grep -i offline`) to
     `docs/plans/<that folder's name>-ledger.md` (move any other file in that folder beside it the same way), add a closing "Merged
     (2026-11-15)" line (no build: test-only; no paste check: no live AC).
   - HANDOFF site-tests-offline "Deferred / known limits", one line each if missing, from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-tests-offline/follow-ups.md` (reviews 1–3's P3s; verifier 3's: three files the
     guard doesn't count still launch a plain Chrome (site-tiers-fixture, site-tiers-split, render-site-flip-face); the auditor's: tally.ts
     misses tests that import touched helpers, the sink's "?" under load, importer tests need a short TMPDIR).
   - `cmp` the plan copy under `docs/plans/` (`ls docs/plans | grep tests-offline`) with
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-tests-offline/plan-approved.md`; copy over if they differ.
4. Commit `site-tests-offline merged: test runs never reach the internet (every test Chrome and Node fetch loopback-only, guarded); ledger and
   follow-ups` (plain `git commit`; no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md or
   site-check-out); then `git push` (`main` only, as Just-In-N-Out through the repo's own helper).
5. Update the repo `CLAUDE.md` (not in git): in **Status**, one compact line at the top of the feature list, like its neighbours: "**site-tests-offline
   (tests only, no build):** every test Chrome launches through `launchOffline` (a host rule mapping every non-loopback name to nothing) and
   every Node fetch through `offlineFetch`, so test runs never reach the internet; `test/unit/site-tests-offline.test.ts` refuses a drawing
   file that names a plain launcher; `site:live`'s own Chrome is the named exception." In "Working in this repo", add one standing rule: "**Test
   runs never reach the internet** (site-tests-offline): a test that draws a site capture or paste launches Chrome through
   `test/web/lib/offline-chrome.ts` `launchOffline` and fetches through `offlineFetch`; the guard test fails on a plain `launchChrome` in a
   drawing file." If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/site-tests-offline-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the records commit on top of `39a1e20d`, `git status` clean but for `site-check-out/`, `git log -1
   --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Commit SHA; push result; files changed; CLAUDE.md written or pending; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal;
never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
