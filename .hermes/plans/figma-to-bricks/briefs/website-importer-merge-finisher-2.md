# Finisher brief: after-merge steps for the website importer's embeds (J5)

**Role:** after-merge finisher (fresh Opus 5.5, xhigh), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `88a6aa49`
(Build 2026-11-03.1, DJ Trees phone menu) to `a8b83660a2431958d1b20b2e0a2539e3481bc29a` (`embeds-final-2`): web-embeds,
accepted by `ac-check.sh` (READY FOR THE USER 11/13; AC12 and AC13 live). The main session holds the shared merge lock
(`website-importer`); don't touch the lock. Never stop to ask.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Merging" steps 4–6) and the repo `CLAUDE.md` "Finish" step 3.

## Steps

1. Confirm `git rev-parse HEAD` = `a8b83660a2431958d1b20b2e0a2539e3481bc29a`, branch `main`, clean tree (`git status --porcelain`
   empty apart from untracked/excluded CLAUDE.md). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-03.1`); bump `BUILD` to the next number for today (`2026-11-03.2`, or `.N+1` if
   another build moved it). Run `npm run build` (Figma loads `dist/`) and `npm run check`; both must exit 0. (If `npm run
   typecheck` exits 127 "tsc: not found", that's a missing `node_modules/.bin`: see `references/testing-pitfalls.md`.)
3. Paste check: embeds' HANDOFF section and the end-of-run check list already name **3cw** (free on main). Confirm with
   `command grep -rn --exclude-dir=evidence 3cw docs/` that only embeds uses it on main; don't renumber.
4. Commit `Build <BUILD>: website importer embeds (widgets, maps, floating extras)` (plain `git commit -m`, no author
   override, no AI or Co-Authored-By lines; `git diff --cached --name-only` must not list CLAUDE.md), then `git push`
   (`main` only, through the repo's own credential helper as Just-In-N-Out; never switch gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the build line (`Current build <BUILD>`), and one line for the
   feature in the house style, under the 2026-11-02.5 importer lines:
   "**<BUILD> web-embeds (website importer J5):** a captured page's own widgets (another company's script in a box), maps
   and floating extras (a call button, a chat bubble) come across: widgets as Code elements with only the script that made
   them, maps as live Google maps of the same address, floating extras fixed at the end of the footer part. Paste check
   **3cw** (AC12, live; bdryswi.com's AC13 once its bot check lets the capture in). Amendment 1 (AC2: only JavaScript
   counts, an inline script only when it loads or calls the widget's host) is the main session's ruling, not yet confirmed."
   Also add the phone menu's line if `Status` lacks one for Build 2026-11-03.1 (read HANDOFF's phone-menu heading for its
   paste check; one line, same style). If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/website-importer-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `a8b83660`, `git status` clean, `origin/main` equals
   `main` after the push.

## Rules

- Never commit CLAUDE.md; never bare `git stash`; never force anything. Don't touch any worktree or other branch.
- Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. Write multi-step scripts with Write and run `bash <file>`;
  git commands as separate plain calls; no redirects or the bare word `source` in a command.
- SIGTERM / exit 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

## Report

The build number, the commit SHA, the push result, the paste check, the CLAUDE.md lines written (or the pending file),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
