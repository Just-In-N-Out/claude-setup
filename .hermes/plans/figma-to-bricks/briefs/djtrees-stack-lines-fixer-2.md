# Role: FIXER 2 + REBASER — djtrees-stack-lines (the verification found one P2)

First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and
`/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-rebase-common.md` and follow them.

The verification after the review-1 fix accepted every AC, but the verifier raised one P2 the fix exposed. Justin's
chain: a fixer fixes it, then the verification runs again (no extra review). You fix it test-first, then rebase the
job onto the newest local `main`.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-lines`; write `E/fixer-2/` and `E/rebase/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. The verifier's report and probes:
  `E/verifier-fix1-d0a81c9/` (`photo-shapes.log`, `zigzag-*.log`, `zigzag-shots/`, `scripts/`).
- Job head `d0a81c96324b82351367a34150fc81fc67bdea64` on branch `worktree-agent-a11b1e13518a59c2f`. **Task 0:** in your
  own worktree, `git reset --hard d0a81c96324b82351367a34150fc81fc67bdea64`. Base `1aef12f`.

## Skills

`receiving-code-review` (verify first; push back with evidence if it doesn't hold), the project skill (FIXER role),
`engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`.

## The finding (verifier, P2, `src/core/adapt/rules/rows.ts:88`)

In a photo/text pair split by a thin line (or by the words' outline facing the photo), the made line sits 0px under
the photo and 28px over the words: photo→words 29px where base has 60, the hairline reading as the photo's bottom edge,
breaking the rule's "at least 16px from each". Cause: `drawAcross` writes the space as padding, and the photo is a box
its own picture covers (`_heightMin` plus an absolute cover figure filling the padding box), so the padding never
shows. Reach: only a photo drawn as an unpainted frame holding a same-size picture layer (image-filled frames and bare
pictures never reach this code, `divided.ts:31`); no real file is affected. Smallest fixes: refuse the across tiers in
`acrossLines` (rows.ts:51) when an item is a box its picture covers (keeps today's output), or write that item's side
as margin instead of padding. Pick the general one (say why) and add a Chrome assertion measuring the photo with the
items read in the order they show.

## Then rebase

After the fix is committed and green: `git log --oneline -1 main` and `git rebase main` (main has djtrees-phone-headline
and maybe others), per djtrees-rebase-common.md (conflicts by meaning, `E/rebase/conflicts.md`, gates on the rebased
head: `npm run check`, the plan's AC tests by name, `E/builder/replay-check.ts` and `E/builder/byte-identity.ts`).

## Return

`status` (`ready-for-verification` | `stopped`), `worktree`, `branch`, the fix commit, the rebased head (full SHA),
main's SHA, `pure` rebase or the conflicts and resolutions, the finding's outcome, gates with results, `found_else`,
`skill_lessons`. End with `MAIN SESSION: check and save these skill_lessons now.`
