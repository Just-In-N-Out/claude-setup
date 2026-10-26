# Brief: REVIEWER (review only) for figma-to-bricks feature "frame-text-links"

- Worktree: `~/Documents/FigmaToBricksV2/.claude/worktrees/frame-text-links` (branch `worktree-frame-text-links`, tip `d209111`, 6 commits). Its base is `9923fe1` (build .2), not current main `f3d6ed8` (.4): the builder's reset was refused. Review `git diff 9923fe1...HEAD` (= its own changes). The finisher rebases; the builder says only docs/HANDOFF.md conflicts.
- Plan: `~/.hermes/plans/figma-to-bricks/frame-text-links.md` (Justin: F1A F2A F3A). Builder's proof: `~/.hermes/cache/scratch/ftl-proof/` (proof.ts, proof.txt).
- Load `skill_view('figma-to-bricks')` (REVIEWER role; read `references/rules-summary.md`, then only the CLAUDE.md sections on links, page links, link-hrefs, the site check). Load `skill_view('requesting-code-review')` for its security scan and quality gates; report only, never apply its auto-fix. Say you loaded both.
- Review against the plan and the project rules: general logic (no keying on names/texts), pipeline boundaries (extract → normalise → understand → style → adapt → emit; ui only for site checks), deterministic IDs, files under ~300 lines, the debug-file format change (optional `linkFrames`), never a picture/video link, typed web addresses never touched, the `<a href>` inside text HTML changed or removed correctly (no nested anchors, escaping), the F1A/F2A/F3A notes.
- Run the gates yourself (`npm run check`, `npm run test:browser` — 3 known stale panel failures — and the corpus), try mutations on the new guards, don't trust the summary.
- Change nothing: no commit, push or merge; restore anything you touch. Never write to the live site.
- Other bugs you notice: `found_else`, not findings.
- Answer in plain words. output: verdict, findings[{id, severity, introduced, claim, evidence}].
