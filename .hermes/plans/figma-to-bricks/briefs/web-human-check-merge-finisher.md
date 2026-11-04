# Finisher brief: after-merge steps for web-human-check (website importer)

**Role:** after-merge finisher (fresh Opus 5.5, xhigh), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `70be9c09`
(Build 2026-11-03.2) to `9bb30d436b5511d61c7db0d1a029877a8077a9a3` (`web-human-check-build`), accepted by `ac-check.sh
--reviews` (READY FOR THE USER 7/8; AC8 live, Justin's). The main session holds the shared merge lock
(`website-importer`); don't touch the lock. Never stop to ask.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Merging" steps 4–6, the paste-id and `.superpowers` lines) and the repo `CLAUDE.md` "Finish" step 3.

## Steps

1. Confirm `git rev-parse HEAD` = `9bb30d436b5511d61c7db0d1a029877a8077a9a3`, branch `main`, clean tree (`git status
   --porcelain` empty apart from untracked/excluded CLAUDE.md). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-03.2`); bump `BUILD` to the next number for today's date (`date +%F` is
   2026-11-04, so `2026-11-04.1`, or `.N+1` if another build already used today). Run `npm run build` (Figma loads
   `dist/`) and `npm run check`; both must exit 0 (if `npm run typecheck` exits 127 "tsc: not found", see
   `references/testing-pitfalls.md`).
3. Records in the same commit:
   - Move the ledger `.superpowers/sdd/2026-11-03-web-human-check/progress.md` to
     `docs/plans/2026-11-03-web-human-check-ledger.md`; `git ls-files .superpowers/` must be empty.
   - Paste check: web-human-check's HANDOFF section and end-of-run entry say "id given at the merge". Give it the next
     free id after every id used on main and on every local branch (`command grep -rhoE --exclude-dir=evidence '\b3[a-z]{2}\b'
     docs/` on main, and `git grep` on `worktree-dark-structure-recognition`, which still claims 3cw unmerged); put it
     in the heading, the entry (top of "End-of-run check list") and the ledger. Replace "build set at the merge"
     placeholders with the new BUILD.
4. Commit `Build <BUILD>: website importer passes a site's "I am human" check in a visible Chrome (web-human-check)`
   (plain `git commit -m`, no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` must not
   list CLAUDE.md), then `git push` (`main` only, through the repo's own credential helper as Just-In-N-Out; never switch
   gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the build line (`Current build <BUILD>`) and one line at the top
   of the feature list in the house style:
   "**<BUILD> web-human-check (website importer):** when a site answers the capture with an \"I am human\" check, the
   helper opens a visible Chrome window; Justin presses the button there and the capture carries on in that window
   (every width, every page with `--all`), then closes it. Nothing hides that the browser is automated. Paste check
   **<id>** (AC8, live: bdryswi.com)."
   Add under "Working in this repo" one standing rule: "**The importer never hides that its Chrome is automated** (no
   `AutomationControlled` flag, no `navigator.webdriver` patch, no new user agent, no stealth script, nothing that clicks
   or types into a site's check): a person passes a person check in the visible window (web-human-check)." If writing
   CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/web-human-check-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `9bb30d43`, `git status` clean, `origin/main`
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
