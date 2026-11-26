# Role: reviewer round 4, rebase delta (Opus 5.5, high): heading-text-link (report only)
Read and follow `/home/justin/.hermes/plans/figma-to-bricks/briefs/_reviewer-common-2026-11-15.md` (ignore its deadline line) and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`. Read the memory rule `/home/justin/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/notes-only-rebase-rule.md` (the code-identity proof detail). TMPDIR ~/.cache/htlr4.

## What to review
The accepted head `b4189f6c25e44b79ae107ed185b1d285e7c32a45` (on base 83a05a2b; ac-check READY FOR THE USER) was rebased onto local main `8d681407` (trustindex-reviews, Build 2026-11-26.1) as `803129ee141b3dc9900cc0e7de8c9ebb925d53e7` (branch `heading-text-link-rebased`). The finisher reports one conflict, only in `docs/HANDOFF.md` (both sections kept, newest first; check list 3fy, 3fx, 3fw), and `src/core/site/convert.ts` merged with no conflict next to trustindex-reviews' code. In your worktree: `git checkout --detach 803129ee141b3dc9900cc0e7de8c9ebb925d53e7`.

## Do
1. Prove code identity: `git diff 83a05a2b b4189f6c` against `git diff 8d681407 803129ee` with HANDOFF left out and `^index `/`^@@ ` lines removed, plus each touched file's blob where unchanged; for `convert.ts` read the merged file: both jobs' steps run and neither changes the other's output (rule H's heading blocks and rule I's install code on B-Dry's footer and header).
2. HANDOFF whole: both sections word for word, no line lost from either side.
3. Read the rebase receipt `/home/justin/.hermes/plans/figma-to-bricks/evidence/heading-text-link/rebase/receipt-803129e.log` and re-run one AC test plus `test/unit/site-install-code.test.ts` yourself on the head.
4. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/heading-text-link/review-4/review.json` (review of `b4189f6c..803129ee` as a rebase) and self-check with `review-check.sh --repo <your worktree> --base 8d681407 /home/justin/.hermes/plans/figma-to-bricks/evidence/heading-text-link`; quote its last line.
