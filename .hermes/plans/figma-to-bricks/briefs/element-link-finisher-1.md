# element-link — Finisher, step 1 (in the copy)

**Role:** finisher, step 1 only (CLAUDE.md "Finish", step 1). `ac-check.sh` said READY FOR THE USER on head `b21acaac02c3f682ac2e7febc0147a752d5ba121` (AC10 live, owed to Justin).

**Work only in the copy:** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a7f58956799bac1e2` (branch `worktree-agent-a7f58956799bac1e2`). Use `git -C <copy> …` or `cd` into it. Never edit the main folder, never push, never bump BUILD, never bare `git stash`, never stage CLAUDE.md (check `git diff --cached --name-only`). Plain `git commit -m`, no author override, no Co-Authored-By.

**Skills:** `git-commit-rules`, `engineering-best-practices`.

**Steps:**
1. Move the ledger `.superpowers/sdd/2026-11-04-element-link/progress.md` to `docs/plans/2026-11-04-element-link-ledger.md`; commit everything.
2. `git rebase main` (local `main`, now at `fb143824` "Build 2026-11-04.4: general structure recognition"; do not fetch). On a conflict keep both sides' meaning; HANDOFF sections usually both stay. Record every conflict and how you resolved it.
3. On the rebased branch run `npm run check` and `npm run corpus` (corpus on this desktop: `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`, run in a scratch copy if paths need re-pointing; compare with `main`'s corpus numbers the same way). Two features that pass alone can break together: any new failure vs `main` is a stop.
4. Stop and report.

**Memory rule:** big runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first.

**Return:** new HEAD SHA, whether the rebase had conflicts (files + resolution), check/corpus results vs main, and `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
