# element-link — Reviewer round 3 (delta, after a second rebase with conflicts)

**Role:** fresh delta reviewer. You never saw the build. **Report only:** change no source, commit nothing; write only `~/.hermes/plans/figma-to-bricks/evidence/element-link/review-3/review.json`.

**Copy (read-only):** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a7f58956799bac1e2`, HEAD `27e69d18f53ae6b90e46f5700586b2462efa4788`.

**History:** round 1 (full, 31321bb4→b21acaac) clean; round 2 (delta, b21acaac→ea333d5f, after a conflict-free rebase onto main fb143824 plus a fix to main's footer test) clean (`review-2/review.json`). Then the blind auditor accepted AC1–AC8 and rejected AC9 only because the ledger didn't list `recognition-footer-safety`. Since then local `main` gained cta-names (Build 2026-11-04.5, 10a5dc2c: CTA names in `settings.link.ariaLabel` / an `aria-label` attribute), and the finisher rebased onto it **with conflicts**, resolved as: `emit/elements.ts` link object keeps `elementLink(ir)` + cta-names' `...ctaLinkName(ir)` spread; HANDOFF keeps both sections and both end-of-run items; `reference/bricks/README.md` keeps both bullets. New commits: 6aff8819 (ledger line for AC9), 906e50fc (test "a call to action whose words are one link: one Link to, one name"), 27e69d18 (ledger rebase note).

**Scope:** `git range-diff 31321bb4..ea333d5f 10a5dc2c..<the rebased commit of ea333d5f, 3eb1e5b3>` (did the conflict resolution change any patch? judge each changed hunk), plus `git diff 3eb1e5b3..27e69d18`, plus how element-link and cta-names interact (a CTA or label wholly one link: exactly one link, one name, no nested link; `relink` in `ui/site-pages.ts` moving/removing a Link to that carries `ariaLabel`). Probe real files (corpus copies, `figma-to-bricks-debug-page-1.json`, `git show 2199895:figma-to-bricks-debug-page-1.json`) on head vs main 10a5dc2c. Anything else P3. `round` 3, `scope` "delta", `from` ea333d5f9db0582e2010d826f0e3330fb13e9d06, `head` 27e69d18f53ae6b90e46f5700586b2462efa4788.

**Skills:** `requesting-code-review`, `code-review-practice`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`. Severity: P0–P2 only with a concrete 5+ word real-use scenario (a real design or normal use); edge cases P3. Run probes in a scratch copy (`git archive` + linked `node_modules`), never writing into the copy. Corpus/Chrome: `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`.

Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <copy> --base 10a5dc2c ~/.hermes/plans/figma-to-bricks/evidence/element-link` (exit 2 = fix your file).

**Memory rule:** big runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first.

**Return:** `verdict`, findings, `ac_status` (your read of whether the ACs still hold on the new head), `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
