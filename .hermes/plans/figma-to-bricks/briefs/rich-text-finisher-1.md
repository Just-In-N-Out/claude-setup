# rich-text — Finisher, step 1 (rebase onto icon-buttons' head on Build .7)

**Role:** finisher, step 1. Skills: `git-commit-rules`, `engineering-best-practices`, `test-driven-development`.

**Copy:** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a4bddf14ed2da3ed7`, branch `worktree-agent-a4bddf14ed2da3ed7`, HEAD `b42ae24ded781d4b68b6c5903ec47718e2e840f9` (base 27e69d18; reviews clean through round 3; blind auditor accepted 9/10, verifier still running on b42ae24d — don't touch its folders). Never edit the main folder, never push, never bump BUILD, never bare `git stash`, never stage CLAUDE.md; plain `git commit -m`, no author override, no Co-Authored-By.

**Rebase target:** `244c522c465dd6db49036cd70f242495fce16c38` = branch `worktree-agent-a3a2e06255dbe9262` (icon-buttons: icon pills become Bricks Buttons with CSS-drawn icons; it's in its final checks and merges next as Build .8). It sits on local `main` `93640217` (Build 2026-11-04.7: the website importer's web-code-proof, which added opt-in `bricksCss`/`themeCss`/`head` options to `test/browser/render.ts`, defaults unchanged), which sits on Build .6 (element-link) and .5 (cta-names).

**Steps:**
1. Move the ledger `.superpowers/sdd/2026-11-04-rich-text/progress.md` to `docs/plans/2026-11-04-rich-text-ledger.md`; commit.
2. `git rebase 244c522c465dd6db49036cd70f242495fce16c38` (no fetch). Expected conflicts: `test/browser/render.ts` (keep web-code-proof's opt-in options AND rich-text's Rich Text rendering: `div.brxe-text > p`, the `editor-content.ts` parse_editor_content stand-in, Bricks' p margins), `emit/elements.ts`, `understand/node.ts`/`widgets.ts`, HANDOFF (keep every section and end-of-run entry), tests. **Check the features together:** an icon Button's words — a Button prints its label in `settings.text` (not a Rich Text): confirm rich-text's rule leaves Buttons alone and icon-buttons' Button conversion still sees the label it needs; a CTA link text (a Block holding Rich Text) next to icon Buttons; the R1-1 hide test, R2-1 tap tests and AC2 Button geometry still pass; the cta-names golden compared through `asRichText`. Add a test for any reachable, untested combination (test-first). Record every conflict and resolution.
3. `npm run check` (green), the rich-text + icon-buttons + list browser tests, and `npm run corpus` vs `244c522c` (corpus per `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`; scratch trees `git -C <copy> archive <sha> | tar -x -C <fresh folder e.g. ~/.cache/rtf1/>`; `grep -a`). Also replay the five real files (corpus copies, `figma-to-bricks-debug-page-1.json`, Services from `git show 2199895:figma-to-bricks-debug-page-1.json`) with 244c522c and the rebased head and compare every text box at 390/768/1440: nothing but rich-text's intended changes. Any new failure: stop and report.
4. Stop and report.

**Memory rule:** big runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first.

**Return:** new HEAD SHA, conflicts + resolutions, combination checks/tests, gates vs 244c522c, `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
