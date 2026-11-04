# element-link — Finisher, step 1 again (rebase onto cta-names + the AC9 ledger line)

**Role:** finisher, step 1 (CLAUDE.md "Finish"). Skills: `git-commit-rules`, `engineering-best-practices`.

**Copy:** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a7f58956799bac1e2`, branch `worktree-agent-a7f58956799bac1e2`, HEAD `ea333d5f9db0582e2010d826f0e3330fb13e9d06`. Never edit the main folder, never push, never bump BUILD, never bare `git stash`, never stage CLAUDE.md; plain `git commit -m`, no author override, no Co-Authored-By.

**Why:** local `main` moved: cta-names (CTA aria names: `settings.link.ariaLabel` on linked CTAs, an `aria-label` `_attributes` entry on unlinked ones; routing tests compare links through `test/fixtures/link-route.ts` `route()`) is merged, and a Build commit may land on top while you work. Also the blind auditor marked AC9 NOT ACCEPTED only because the ledger `docs/plans/2026-11-04-element-link-ledger.md` doesn't list the updated test `test/unit/recognition-footer-safety.test.ts` ("contact values retain contact links…": a value that is the whole text now carries its tel:/mailto: link in its element's Link to, no `<a>` in the words).

**Steps:**
1. Add that ledger line; commit ("element-link: ledger lists recognition-footer-safety").
2. `git rebase main` (local, no fetch). On conflicts keep both sides' meaning: e.g. element-link's whole-text Link to and cta-names' `ariaLabel` on CTA links can both apply (a CTA wholly one link keeps its name in `link.ariaLabel`); tests comparing links should use `route()` where cta-names introduced it. Record every conflict and its resolution.
3. Check the two features together: a whole-text link that is also a CTA (a call-number pill? a "Call 800…" text?) — does it get exactly one name and the Link to? Add a test if the combination is reachable and untested.
4. `npm run check` and `npm run corpus` on the rebased head vs `main` (corpus per `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`; the scratch helper `/home/justin/.cache/el-fin/run.sh <tree> <log> corpus` exists; compare with `grep -a`). Any new failure vs main is a stop: report it, don't patch around it.
5. Stop and report.

**Memory rule:** big runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first.

**Return:** new HEAD SHA, conflicts + resolutions, the combination check, check/corpus vs main, `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
