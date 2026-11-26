# Role: reviewer round 2, delta (Opus 5.5, high): heading-text-link (Mini pipeline; report only)
Read and follow `/home/justin/.hermes/plans/figma-to-bricks/briefs/_reviewer-common-2026-11-15.md` (ignore its deadline line) and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`. You never saw the build or the fix. TMPDIR ~/.cache/htlr2.

## What to review
Repo FigmaToBricksV2. In your own worktree: `git checkout --detach 7ccaa5eac9524ed3355f717fc23c067c8e73af89` (branch `heading-text-link-fixer-1`). Review only the fix commit(s) since the last review, `git diff af434fa4..7ccaa5ea`, and what they touch. Story base: 83a05a2b. Round-1 findings: `/home/justin/.hermes/plans/figma-to-bricks/evidence/heading-text-link/review-1/review.json`. Approved plan (read-only, AC7 amended with Justin's go): `/home/justin/.hermes/plans/figma-to-bricks/evidence/heading-text-link/plan-approved.md`. Don't read the fixer's report or folder as proof.

## Do
1. Is R1-1 fixed for real (a Figma heading that is all one link holding a coloured `<span>` run draws as with the rule off, every width, both Bricks versions), and is the fix right by the repo rules (the plugin's Text link gets `_cssCustom: "#brxe-<linkId> span{display:inline}"`: never `display` on an element's own box, an id only inside its own element, CLAUDE.md "An element's own custom CSS never writes display" and "Bricks gives pasted elements new ids")? Would a Bricks pro find it logical? Does it reach other inline tags Bricks' Text link CSS changes?
2. Check the AC7 `sameNotes` tightening (numbers blanked; Block/Heading/Text link kinds left out of the Structure list) and the four renamed tests (names equal the plan's exactly).
3. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/heading-text-link/review-2/review.json` and self-check with `review-check.sh --repo <your worktree> --base 83a05a2b /home/justin/.hermes/plans/figma-to-bricks/evidence/heading-text-link`; quote its last line.
