---
name: git-and-parallel-agents
description: "v2 is in git + private GitHub (Just-In-N-Out, not Justin-Leorna) since 2026-10-19; one agent per feature via claude -w"
metadata:
  node_type: memory
  type: project
  originSessionId: 97ce3cf8-b36d-46da-a6b6-643b41ec8abd
  modified: 2026-10-26T19:22:42.127Z
---

On 2026-10-19 the user asked to "push it to github on private just-in-n-out not justin leorna" and to run several
agents on several features at once. The repo is `github.com/Just-In-N-Out/FigmaToBricksV2` (private), branch `main`.
The full working rules are in CLAUDE.md "Working in this repo"; what was non-obvious when setting it up:

- The Mac's active `gh` account is Justin-Leorna (other projects), and its default SSH key is accepted by neither
  account. Pushes work through a repo-local credential helper that asks `gh auth token --user Just-In-N-Out`. Don't
  switch the gh account or change the remote. On the Windows desktop (WSL) origin is SSH with no repo helper; check
  `ssh -o BatchMode=yes -T git@github.com` greets Just-In-N-Out before pushing (worked 2026-10-26, faq-answer-space).
- Claude Code (2.1.304) does NOT load the main folder's CLAUDE.md inside a `claude -w` copy
  (`.claude/worktrees/<name>`), even though the copy sits under it; tested with a print-mode session. CLAUDE.md is kept
  out of git (global rule), so `.worktreeinclude` copies it in, with `node_modules/` and `corpus/out/v1/`.
- Browser tests are parallel-safe: Chrome gets port 0 and a fresh profile per run.
- The user tells sessions apart by the Claude Code status line (global `~/.claude/settings.json`, set up 2026-10-19):
  `🌿 <copy name>` inside a `claude -w` copy, `🌿 <branch>` elsewhere. So name each copy after its feature. They asked
  how merging works: Claude merges a finished feature into `main` itself, no approval needed.
- **The route that works (2026-10-19, hyperlink):** follow the global CLAUDE.md "Worktrees from `claude -w`":
  rebase in the copy, then call ExitWorktree with action "keep" (standing permission). The session is then in the main
  folder, where `git merge --ff-only worktree-<name>`, `npm run check` and the main CLAUDE.md edits all work. No user
  commands needed; the older notes below are what happened before this was known.
- A `claude -w` session is isolated (seen 2026-10-19, hyperlink copy): the harness refuses any git command aimed
  at the main folder (`git -C /Users/justin/Documents/FigmaToBricksV2 …`, or any shell line it can't prove stays in
  the copy, even read-only ones). So the finish steps 3–5 (ff-merge, BUILD bump, build, push, CLAUDE.md) run from a
  session opened in the main folder, or the user types them with `!`. Keep shell commands simple (no `&&` chains with
  `cd`, heredocs, `$(…)`, loops, `source`/`.` of an env file, or a `$VAR` as a path or command) inside a copy: env
  vars inline with literal paths, multi-step logic in a script written with the Write tool (refused ~7 times in the
  faq-answer-space session, 2026-10-26, orchestrator and builder alike, for non-git commands too).
- The user's OK doesn't lift the block (fixvideo, 2026-10-19: "just merge it i gave you persmission"), and no
  setting does (Claude Code docs, worktrees page). Edits to main-folder files are refused too. The user disliked typing
  the commands themselves ("i want it so that if i did it on my local like it just merged into my local main"), so
  the route is now (global CLAUDE.md "Worktrees from `claude -w`", project CLAUDE.md "Finish" steps):
  1. In the copy: commit, `git rebase main`, re-run the checks.
  2. Leave the copy with the ExitWorktree tool, action "keep" (standing permission). The session moves to the main
     folder (worked in the marquee and Media sessions, 2026-10-19); fallback EnterWorktree with the main folder's path.
  3. From the main folder: `git merge --ff-only`, bump BUILD, build, commit, push `main`, update CLAUDE.md.
  4. The feature branch stays on the Mac (not pushed).

  Hand the user a `!` command only if both ways out of the copy fail.

**Why:** the user wants features built in parallel without agents overwriting each other's work.
**How to apply:** feature work happens in `claude -w` copies, merged one at a time into `main` (rebase, re-check,
`merge --ff-only`, bump BUILD on main, build, push). Related: [[user-workflow]], [[run-without-stopping]].

**Merging into main alongside other chats (2026-11-04):** take `~/.hermes/scripts/merge_lock.sh acquire <repo folder path> <owner>` (a path such as `~/Documents/FigmaToBricksV2`; a bare name exits 64) before a `--ff-only` merge and the BUILD commit/push, release after; the website-importer session uses owner `website-importer`. Before merging, `ListAgents` and message any peer session in this repo; agree paste-check ids with it (each session takes its own range).
A "nothing else changed" golden pinned from the shared base breaks when a later job rebases onto it and rightly changes that page: regenerate it from the later job's own pre-rebase head (extracted tree), never from the rebased head (icon-buttons over cta-names, 2026-11-04).

**An agent started with `isolation: "worktree"` can't run git in another worktree (2026-11-08, site-motion fixer 2):** Claude Code refuses `cd`/`git -C` into the builder's copy. Either dispatch a fixer that works in the builder's worktree without `isolation`, or tell it to `git reset --hard <head>` in its own copy and report its branch; the next role then starts from that branch's head. Its guard also refuses compound commands it can't parse (two `bash <file>` in one call, `; cat …` after one, `$(git …)` in a pipeline, a loop variable in `node -e`, a `grep … | sort | uniq` pipe on a file outside the worktree — read it with a node script given its absolute path): one `bash <file>` per call, scripts written with Write, paths spelled out, wait loops printing a fixed amount (site-motion fixer 2, phone-fit verifier 2).

**Briefs for isolated agents (2026-11-11):** never write `git -C <main folder> …` in a brief, even read-only (refused: "redirects git
to the shared checkout"); plain `git rev-parse main` / `git show main:<path>` from the agent's own worktree work (refs are shared).
