# Brief: FINISHER for figma-to-bricks feature "frame-text-links"

- Worktree `~/Documents/FigmaToBricksV2/.claude/worktrees/frame-text-links`, branch `worktree-frame-text-links`, tip `d209111`, based on `9923fe1` (build .2). Main is now `f3d6ed8` (build .4) or newer (other finishers may merge first: check). Plan `~/.hermes/plans/figma-to-bricks/frame-text-links.md` (F1A F2A F3A).
- Reviewer verdict: approve, 5 low findings. Findings verbatim: `~/.hermes/plans/figma-to-bricks/briefs/frame-text-links-review-findings.json` (also the transcript `~/.hermes/cache/delegation/live/deleg_262db8d8/task-0.log`). Probes in `~/.hermes/cache/scratch/ftl-review/`.
  - F1 relinkText `$` in replacement string (use a function replacement).
  - F2 part-of-frame note keeps the guessed address after the site check changed the link.
  - F3 three guards untested (page-addresses `checked`, text-links `attr(to)`, text.ts unnamed-frame guard).
  - F4 behaviour change: a card whose words link to a frame no longer becomes a whole-card link; a pill whose label words carry the link is no longer a Bricks Button. Record it in HANDOFF and CLAUDE.md as a behaviour change (it matches typed web-address links). Don't reverse it; name it in the report as one for Justin to confirm.
  - F5 CLAUDE.md line ~80 ("text links to frames later") also needs the edit.
- Load `skill_view('figma-to-bricks')` (FINISHER role), `skill_view('receiving-code-review')`, `skill_view('git-commit-rules')`, `skill_view('test-driven-development')`. Say you loaded them. Verify each finding, fix the valid ones test first, push back on the rest with evidence.
- Then Step 3 item 7 and Step 4: rebase onto main (only docs/HANDOFF.md conflicts: keep both sections; paste check 3ag, renumber if taken), gates (`npm run check`, `npm run test:browser` — 3 known stale panel failures — `npm run corpus`), merge lock, ff-only merge, BUILD bump, `npm run build`, commit `Build <BUILD>: frame text links`, push main.
- **CLAUDE.md:** Justin gave standing permission (2026-10-21) to write the main CLAUDE.md. Update "Start here" (build line + an entry) and "Where things stand", plus F4 and F5. A Hermes approval prompt may appear; if a write is denied or times out, write the edits to `~/.hermes/plans/figma-to-bricks/frame-text-links-claude-md-pending.md` and carry on. Update `references/rules-summary.md` only if a rule changed.
- Before removing the copy: its untracked `.superpowers/` blocks `git worktree remove`; move it to `~/.hermes/backups/figma-worktree-leftovers/frame-text-links-<time>/`, then remove the copy and branch (`git branch -d`, or `-D` only after the ancestor check).
- Mark in `~/.hermes/plans/figma-to-bricks/found-else.md` any item this closes (the planner's "text-part links never checked against the site", if listed there) as `~~item~~ ✅ fixed in build <BUILD> (frame-text-links)`.
- Never write to the live site. Other bugs: `found_else`.
- Return status merged with the new BUILD, or stopped with the reason. Plain words for WhatsApp.
