# Finisher brief: after-merge steps for web-code-proof (website importer)

**Role:** after-merge finisher (fresh Opus 5.5, xhigh), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `63371d4c`
(Build 2026-11-04.6) to `9ba1fe728d6cb21364bfe1400f4a52f4f045b08d` (`web-code-proof-fix-1`), accepted by `ac-check.sh`
(READY FOR THE USER 9/10; AC9 live, Justin's). The main session holds the shared merge lock
(`website-importer`); don't touch the lock. Never stop to ask.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Merging" steps 4–6, the paste-id and `.superpowers` lines) and the repo `CLAUDE.md` "Finish" step 3.

## Steps

1. Confirm `git rev-parse HEAD` = `9ba1fe728d6cb21364bfe1400f4a52f4f045b08d`, branch `main`, clean tree (`git status
   --porcelain` empty apart from untracked/excluded CLAUDE.md). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-04.6`); bump `BUILD` to the next number for today's date (`date +%F`;
   expect `2026-11-04.7`, or `.N+1` if another build already used today). Run `npm run build` (Figma loads
   `dist/`) and `npm run check`; both must exit 0 (if `npm run typecheck` exits 127 "tsc: not found", see
   `references/testing-pitfalls.md`).
3. Records in the same commit:
   - Move the ledger `.superpowers/sdd/2026-11-04-web-code-proof/progress.md` to
     `docs/plans/2026-11-04-web-code-proof-ledger.md`; `git ls-files .superpowers/` must be empty.
   - Paste check: web-code-proof's HANDOFF section and end-of-run entry say "id given at the merge". Give it the next
     free id after every id used on main and on every local branch (`command grep -rhoE --exclude-dir=evidence '\b3[c-z][a-z]\b'
     docs/` on main, and `git grep` on `worktree-dark-structure-recognition`, which still claims 3cw unmerged; 3dc is reserved for this job (the other session took 3de, 3df and reserves 3dg, 3dh): use 3dc); put it
     in the heading, the entry (top of "End-of-run check list") and the ledger. Replace "build set at the merge"
     placeholders with the new BUILD.
4. Commit `Build <BUILD>: the website importer's new code method, proved on one section (web-code-proof)`
   (plain `git commit -m`, no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` must not
   list CLAUDE.md), then `git push` (`main` only, through the repo's own credential helper as Just-In-N-Out; never switch
   gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the build line (`Current build <BUILD>`) and one line at the top
   of the feature list in the house style:
   "**<BUILD> web-code-proof (website importer, new method):** the importer's new route copies a site's own HTML and CSS
   (its elements, classes and per-width rules) into Bricks: `npm run capture` records the code, `npm run site` writes one
   section's paste, `npm run site:check` measures it against the capture (2 px at every width). Proved 0 px on the saved
   bdryswi.com section at 53 widths; the panel still uses the old route. Paste check **3dc** (AC9, live)."
   Add under "Decisions the user made": "**The website importer copies the site's own code** (Justin, 2026-11-04: \"I want a
   method that can help us get one to one, not relying on photos or images but actual code\"; method review
   `~/.hermes/plans/figma-to-bricks/evidence/method-review/report.md`): a site's elements, classes and CSS rules go into
   Bricks as they are; the measured-box route through the Figma converter is retired for websites once the whole page
   passes." If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/web-code-proof-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `9ba1fe72`, `git status` clean, `origin/main`
   equals `main` after the push.

## Rules

- Never commit CLAUDE.md; never bare `git stash`; never force anything. Don't touch any worktree or other branch.
- Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. Write multi-step scripts with Write and run `bash <file>`;
  git commands as separate plain calls; no redirects or the bare word `source` in a command.
- SIGTERM / exit 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

## Report

The build number, the commit SHA, the push result, the paste check id, the CLAUDE.md lines written (or the pending
file), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or
memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
