# Role: PRE-MERGE REBASER — djtrees-storm-photo (merge train car 2)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-rebase-common.md` first and follow it.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-storm-photo` (write only `E/rebase/`)
- Job head (fixed, verified READY on its old base): `e16982d4e2d947e093876a0456cc08601876d501` on branch
  `worktree-agent-a5b96bb4405e7c349`.
- **Target:** `1a6437862fb207bfd78310e6bc75d2024c9f4367` (djtrees-cta-center rebased onto main `1424081`, which has
  djtrees-phone-headline: `typeLeading` in `RULES` and changes to `src/core/adapt/facts.ts`; cta-center adds
  `ctaCenter` to `RULES` and changes `rules/cta.ts`). This job adds `photoStack` after `cropSubject` in `RULES` and
  `STACK_PHOTO` to `facts.ts`: expect conflicts in `rules/index.ts`, `facts.ts` and HANDOFF.
- Plan: `E/plan-approved.md` (AC tests AC1–AC11; AC9 needs `F2B_SIDE_PHOTO_FILE` set to the DJ Trees file). Gates
  compare with the target.
