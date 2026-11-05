# icon-buttons — Finisher, step 1 again (rebase onto main after the importer's Build .7)

**Role:** finisher, step 1. Skills: `git-commit-rules`, `engineering-best-practices`.

**Copy:** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a3a2e06255dbe9262`, branch `worktree-agent-a3a2e06255dbe9262`, HEAD `71fbfaad71266c33cb4f0d1694d4eb32bc773a7b` (accepted by ac-check on base 27e69d18: READY FOR THE USER, AC8 live). Never edit the main folder, never push, never bump BUILD, never bare `git stash`, never stage CLAUDE.md; plain `git commit -m`, no author override, no Co-Authored-By.

**Why:** local `main` is now `93640217` (Build 2026-11-04.7, the website importer's web-code-proof: new `src/core/site/`, `src/web/read/code*.ts`, `tools/site*.ts`, opt-in `bricksCss`/`themeCss`/`head` options in `test/browser/render.ts`, `reference/bricks/frontend-2.3.9/`), on top of `63371d4c` (Build .6, element-link's build commit). 

**Steps:**
1. `git rebase main` (local, no fetch). Ideally conflict-free; if there are conflicts, keep both sides' meaning, record each, and say so clearly (then a delta review is needed).
2. `npm run check` and `npm run corpus` on the rebased head vs `main` (corpus per `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`; scratch trees with `git -C <copy> archive <sha> | tar -x -C <fresh folder e.g. ~/.cache/ibf2/>`; compare with `grep -a`). The corpus must differ from main only by icon-buttons' intended Div→Button changes. Any new failure vs main: stop and report.
3. Stop and report.

**Memory rule:** big runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first.

**Return:** new HEAD SHA, whether the rebase was conflict-free (else conflicts + resolutions), check/corpus vs main, `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
