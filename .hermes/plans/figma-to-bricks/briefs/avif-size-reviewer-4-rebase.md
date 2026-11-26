# Role: reviewer round 4, rebase delta (Opus 5.5, high): avif-size (report only)
Read and follow `/home/justin/.hermes/plans/figma-to-bricks/briefs/_reviewer-common-2026-11-15.md` (ignore its deadline line) and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`. Read the memory rule `/home/justin/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/notes-only-rebase-rule.md` (the code-identity proof detail). TMPDIR ~/.cache/asr4.

## What to review
The accepted head `6682cc6568f882383b9b11e5698d8eb4f58f2600` (on base 83a05a2b; ac-check READY FOR THE USER) was rebased onto local main `20cc5ca4` (Build 2026-11-26.2: trustindex-reviews and heading-text-link) as `113aa9df99d2edeed558a57ce629b856a6520e21` (branch `avif-size-rebased`). The finisher reports one conflict, only in `docs/HANDOFF.md` (both sides kept, avif-size's section on top; check list 3fz, 3fy, 3fx, 3fw); no other file is touched by both. In your worktree: `git checkout --detach 113aa9df99d2edeed558a57ce629b856a6520e21`.

## Do
1. Prove code identity: `git diff 83a05a2b 6682cc65` against `git diff 20cc5ca4 113aa9df` with HANDOFF left out and `^index `/`^@@ ` lines removed, plus each touched file's blob where unchanged.
2. HANDOFF whole: both sections word for word, no line lost from either side.
3. Read the rebase receipt `/home/justin/.hermes/plans/figma-to-bricks/evidence/avif-size/rebase/receipt-803129e.log` and re-run AC4 and AC9 yourself on the head (offline, a test HOME with `.cache/chrome-for-testing`, `.cache/chrome-libs`, `.cache/figma-to-bricks` linked in; `site-upload-icons` fails offline on main too: not this job).
4. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/avif-size/review-4/review.json` (review of `6682cc65..113aa9df` as a rebase) and self-check with `review-check.sh --repo <your worktree> --base 20cc5ca4 /home/justin/.hermes/plans/figma-to-bricks/evidence/avif-size`; quote its last line.
