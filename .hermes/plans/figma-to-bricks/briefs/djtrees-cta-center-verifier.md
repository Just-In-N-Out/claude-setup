# Role: VERIFIER — djtrees-cta-center (rebased head)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-verifier-common.md` first and follow it, with these
differences: there was no fix (review-1 was clean); instead the job was rebased onto main with two conflicts, and you
also judge those resolutions (report-only: a wrong resolution is a finding with file:line and scenario).

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-cta-center` (write `E/verifier/`; the reviewer's
  receipts from the pre-rebase head are in `E/verifier-review1-af33737/`).
- Approved plan: `E/plan-approved.md` (AC1–AC10 by test/receipt; AC11 live, 3cl).
- Rebaser's worktree (the job's head now; for `ac-check --repo`): `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a0d6d3585363578c4`,
  branch `worktree-agent-a0d6d3585363578c4`.
- **head** `1a6437862fb207bfd78310e6bc75d2024c9f4367`; reviewed pre-rebase head `af33737`; **base for AC base runs**
  `git merge-base HEAD main` (= `1424081`, main with djtrees-phone-headline). The plan's tests must fail on that base.
- Conflicts (`E/rebase/conflicts.md`): `src/core/adapt/rules/index.ts` `RULES` line (kept `typeLeading` after
  `typeRamp` and `ctaCenter` after `ctaFullWidth`); `docs/HANDOFF.md` (both sections and both check-list entries kept).
  Check `git range-diff 1aef12f..af33737 1424081..1a64378` shows no change to any line the job adds or removes, and that
  `type.leading` and `cta.center` never write the same node/tier/property (0 collisions on the six real files, with
  and without the header/footer ticks).
