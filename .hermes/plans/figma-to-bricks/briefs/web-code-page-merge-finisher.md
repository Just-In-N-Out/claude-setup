# Finisher brief: after-merge steps for web-code-page (website importer)

**Role:** after-merge finisher (fresh Opus 5.5, xhigh), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `ea504778`
(Build 2026-11-04.8) to `4ba9a1782e0d36f1efd6e2322dd23df1a90274bd` (`web-code-page-build`), accepted by `ac-check.sh`
(READY FOR THE USER 18/20; AC12 and AC19 live, Justin's). The main session holds the merge lock (`website-importer`);
don't touch the lock. Never stop to ask. Never load bdryswi.com; no logins; never write to any WordPress site.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Merging" steps, the `.superpowers` line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `4ba9a1782e0d36f1efd6e2322dd23df1a90274bd`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it alone, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-04.8`); bump `BUILD` for today's date (`date +%F`, expect `2026-11-07.1`,
   or `.N+1` if a build already used today). Run `npm run build` and `npm run check`; both must exit 0 (tsc not found →
   `references/testing-pitfalls.md`). Node `/home/justin/.local/node-v22.23.3/bin` first on PATH.
3. Records in the same commit:
   - Move the ledger `.superpowers/sdd/2026-11-04-web-code-page/progress.md` to
     `docs/plans/2026-11-04-web-code-page-ledger.md`; `git ls-files .superpowers/` must be empty.
   - Paste check id: web-code-page's HANDOFF section and end-of-run entry may say "id given at the merge". Give it the
     next free id after every id used on main and on local branches (`command grep -rhoE --exclude-dir=evidence
     '\b3[c-z][a-z]\b' docs/` on main, and `git grep -hoE '\b3d[a-z]\b' worktree-agent-a93c32bbf9bbc5ed4 -- docs/`, the
     unmerged elementor-map branch); put it in the heading, the end-of-run entry (top of "End-of-run check list") and the
     ledger. Replace any "build set at the merge" placeholders with the new BUILD.
   - In HANDOFF's web-code-page section, add one known-limit line if it isn't there: "A site's CSS animations paste
     without their `@keyframes` (B-Dry's shimmer header and Our Services band show navy where the site shows teal;
     fadeIn-style entrances don't play); a follow-up job, offered to Justin."
4. Commit `Build <BUILD>: the website importer pastes a captured site's whole page by its own code (web-code-page)`
   (plain `git commit -m`, no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` must not list
   CLAUDE.md or site-check-out), then `git push` (`main` only, through the repo's credential helper as Just-In-N-Out;
   never switch gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the build line (`Current build <BUILD>`, date in the heading) and
   one line at the top of the feature list in the house style:
   "**<BUILD> web-code-page (website importer):** the code method pastes a captured page whole: header, page and footer
   by the site's own elements, classes and CSS, within 2 px at every width (B-Dry 1.09 px at 53 widths), alt text and
   page-builder markers kept, bold and italic as on the site; every class starts with the page's name (`home__…`) but
   `site-reset-<4>`, `site-fonts`, `site-text`, `site-flat` (Justin, 2026-11-07, "Prefix every name"); a site's CSS
   animations stay still (no `@keyframes`). Paste check **<id>** (AC12, AC19, live)."
   Add under "Decisions the user made", beside "The website importer copies the site's own code": "**Code-method class
   names start with the page's name** (Justin, 2026-11-07, \"Never use bare names\", then \"Prefix every name\"):
   `<page>__<name>`, only `site-reset-<4>`, `site-fonts`, `site-text`, `site-flat` keep theirs; a static slider keeps all
   its slides (\"Keep all its slides\")." If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/web-code-page-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `4ba9a178`, `git status` clean but for
   `site-check-out/`, `origin/main` equals `main` after the push.

## Rules
- Never commit CLAUDE.md; never bare `git stash`; never force anything. Don't touch any worktree or other branch.
- Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls.
- SIGTERM / exit 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

## Report
The build number, the commit SHA, the push result, the paste check id, the CLAUDE.md lines written (or the pending file),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
