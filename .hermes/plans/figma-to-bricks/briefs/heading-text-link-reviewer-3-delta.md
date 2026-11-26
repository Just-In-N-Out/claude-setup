# Role: reviewer round 3, delta (Opus 5.5, high): heading-text-link (Mini pipeline; report only)
Read and follow `/home/justin/.hermes/plans/figma-to-bricks/briefs/_reviewer-common-2026-11-15.md` (ignore its deadline line) and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`. You never saw the build or the fix. TMPDIR ~/.cache/htlr3.

## What to review
Repo FigmaToBricksV2. In your own worktree: `git checkout --detach b4189f6c25e44b79ae107ed185b1d285e7c32a45` (branch `heading-text-link-fixer-2`). Review only the fix commit(s) since the last review, `git diff 7ccaa5ea..b4189f6c`, and what they touch. Story base: 83a05a2b. Earlier findings: `review-1/review.json` and `review-2/review.json` in `/home/justin/.hermes/plans/figma-to-bricks/evidence/heading-text-link/` (R2-1: the round-1 span reset out-weighed the plugin's phone-number class; Justin chose "Fix it now"). Approved plan (read-only, AC7 amended with Justin's go): `/home/justin/.hermes/plans/figma-to-bricks/evidence/heading-text-link/plan-approved.md`. Don't read the fixer's report or folder as proof.

## Do
1. Is R2-1 fixed for real: the reset is now `#brxe-<linkId> span:not([class]){display:inline}`. Probe every span kind the plugin writes into a heading's words (coloured run, phone number, marker spans, mark picture, any other classed span) inside a whole-linked heading, on vs off, many widths (340–1440), both Bricks versions where offline allows. Does a classed span Bricks' `inline-flex` still breaks remain (a span with a class but no display rule of its own)? R1-1 (coloured run) must stay 0 px.
2. Check the AC6 runs scene additions (phone-number heading, widths 480 and 360, span class/display compared).
3. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/heading-text-link/review-3/review.json` and self-check with `review-check.sh --repo <your worktree> --base 83a05a2b /home/justin/.hermes/plans/figma-to-bricks/evidence/heading-text-link`; quote its last line.
