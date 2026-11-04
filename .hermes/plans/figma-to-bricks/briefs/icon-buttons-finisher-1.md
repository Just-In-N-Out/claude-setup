# icon-buttons — Finisher, step 1 (rebase onto element-link's accepted head)

**Role:** finisher, step 1. Skills: `git-commit-rules`, `engineering-best-practices`, `test-driven-development`.

**Copy:** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a3a2e06255dbe9262`, branch `worktree-agent-a3a2e06255dbe9262`, HEAD `45d3e8c1a9242408a6e7b667864020e67d5b07b1` (base 31321bb4; reviews 1–3 done, round 3 MOVE ON). Never edit the main folder, never push, never bump BUILD, never bare `git stash`, never stage CLAUDE.md; plain `git commit -m`, no author override, no Co-Authored-By.

**Rebase target:** `27e69d18f53ae6b90e46f5700586b2462efa4788` = branch `worktree-agent-a7f58956799bac1e2` (element-link, fully reviewed and accepted by its blind auditor, about to fast-forward into `main`). It sits on local `main` `10a5dc2c` (Build 2026-11-04.5, cta-names). So rebasing onto it brings in fix structure-recognition (fb143824), cta-names and element-link at once.

**Steps:**
1. Move the ledger `.superpowers/sdd/2026-11-04-icon-buttons/progress.md` to `docs/plans/2026-11-04-icon-buttons-ledger.md`; commit.
2. `git rebase 27e69d18f53ae6b90e46f5700586b2462efa4788` (no fetch). Expected conflicts: `understand/node.ts`, `understand/widgets.ts`, `emit/elements.ts`, `emit/settings.ts`, HANDOFF, `reference/bricks/README.md`, tests. **Reconcile your local stand-in** (`widgets.ts labelLink` + link wiring in `node.ts`, built because element-link wasn't merged) with element-link's `elementLink(ir)` / `ir.textLink` / `understand/text-link.ts`: use element-link's code, drop the duplicate, keep AC5's behaviour (a label wholly a designer's link makes a linked Button). Keep cta-names' `...ctaLinkName(ir)` / `ctaAttributes` on Buttons (an icon Button that is a CTA must carry exactly one name). HANDOFF: keep every section and end-of-run item. Record each conflict and its resolution.
3. Check the features together: an icon Button that is a CTA → one link (if any) with `ariaLabel`, or one `aria-label` attribute; a whole-text link inside a Button → the Button owns the link, the text has no Link to; no nested links; the R1-1 hide test and R2-1 tap tests still pass. Add a test for any reachable, untested combination (test-first).
4. `npm run check` (all green) and `npm run corpus` on the rebased head vs `27e69d18` (corpus per `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`; extract scratch trees into a fresh folder like `~/.cache/ibf1/`; compare logs with `grep -a`). Corpus must equal the icon-buttons builder's intended changes (Divs → Buttons) and nothing else. Any new failure: stop and report, don't patch around it.
5. Stop and report.

**Memory rule:** big runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first.

**Return:** new HEAD SHA, conflicts + resolutions, the combination checks/tests, check/corpus vs 27e69d18, `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
