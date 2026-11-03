# Finisher brief: after-merge steps for the website importer (wave 1 + panel + address box + tiers)

**Role:** after-merge finisher (fresh Opus 5.5, xhigh), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` to
`2fd7a95ef4b7c7bacacddef6bf749a65fb032e25` (`tiers-merge`): wave 1 (web-capture J1 + web-compare J0), web-panel (J4),
web-address (the panel's address box and local helper) and web-tiers (J2), all accepted by `ac-check.sh` (READY FOR THE
USER). The main session holds the shared merge lock (`website-importer`); don't touch the lock. Never stop to ask.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Merging" steps 4–6) and the repo `CLAUDE.md` "Finish" step 3.

## Steps

1. Confirm `git rev-parse HEAD` = `2fd7a95ef4b7c7bacacddef6bf749a65fb032e25`, branch `main`, clean tree (`git status --porcelain`
   empty apart from untracked/excluded CLAUDE.md). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-02.4`); bump `BUILD` to the next number for today (`2026-11-02.5`, or `.N+1` if
   another build moved it). Run `npm run build` (Figma loads `dist/`) and `npm run check`; both must exit 0.
3. Paste checks: each job's HANDOFF section names its live check; give each one that says "id given at the merge" the next
   free id(s) in HANDOFF's "End-of-run check list" (read the list and every HANDOFF heading first; `3cw` is reserved for
   web-embeds, still to merge). Update the HANDOFF headings with the ids.
4. Commit `Build <BUILD>: website importer (capture, compare, panel, address box, tiers)` (plain `git commit -m`, no author
   override, no AI lines; `git diff --cached --name-only` must not list CLAUDE.md), then `git push` (`main` only, through
   the repo's own credential helper as Just-In-N-Out; never switch gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the build line, and one line per feature with its paste check
   (keep the house style: plain words, what Justin can now do). Add under "Working in this repo" or "Decisions" only:
   - the importer's standing rule from the web-address plan: "The panel reaches the importer helper only at
     `http://127.0.0.1:47811` with its pairing code; Figma desktop runs with Chrome's LocalNetworkAccessChecks off (Figma in a
     browser can't reach it). The helper binds 127.0.0.1 only and never writes to a site.";
   - Justin's rulings of 2026-11-02 on the capture plan (AC4: a part's own fixed content stays in its part; AC14/AC15:
     bdryswi.com's pages are a live check owed to him).
   If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/website-importer-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `2fd7a95`, `git status` clean, `origin/main` equals
   `main` after the push.

## Rules

- Never commit CLAUDE.md; never bare `git stash`; never force anything. Don't touch any worktree or other branch.
- Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. Write multi-step scripts with Write and run `bash <file>`;
  git commands as separate plain calls; no redirects or the bare word `source` in a command.
- SIGTERM / exit 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

## Report

The build number, the commit SHA, the push result, the paste check ids given, the CLAUDE.md lines written (or the pending
file), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or
memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
