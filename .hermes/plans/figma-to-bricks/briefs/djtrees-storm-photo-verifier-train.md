# Role: VERIFIER — djtrees-storm-photo (merge-train car 2, rebased head)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-verifier-common.md` first and follow it, with these
differences: the review-1 fix was already verified on the old head (`E/verifier-fix1-e16982d/`, READY); the job was
then rebased onto merge-train car 1 (djtrees-cta-center) with two conflicts. You prove every AC again on the rebased
head and judge the two resolutions (report-only).

**Load: the computer crashed twice under load. Run one Chrome at a time, no parallel suites, `npm run check` once.**

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-storm-photo` (write `E/verifier/`, fresh).
- Approved plan: `E/plan-approved.md` (AC1–AC11 by test/receipt; AC12 live, 3cq). AC9's browser test needs
  `F2B_SIDE_PHOTO_FILE` set to the DJ Trees debug file.
- Rebaser's worktree (the job's head; for `ac-check --repo`): `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-ac53eb23be45d2025`.
- **head** `b0d8f65fe4d8bb0fc00f940445d1eac4cb92d697`; **base for AC base runs and comparisons** = train car 1
  `1a6437862fb207bfd78310e6bc75d2024c9f4367` (djtrees-cta-center on main `1424081`), which is `--base` for ac-check.
  AC10's "only the storm section and its Container differ" is judged against that base.
- Conflicts (`E/rebase/conflicts.md`): `rules/index.ts` `RULES` line (`photoStack` after `cropSubject`, keeping car 1's
  `typeLeading` and `ctaCenter`), HANDOFF (three sections kept). Check `git range-diff 1aef12f..e16982d 1a64378..b0d8f65`
  changes no line the job adds or removes, and 0 rule collisions on the six real files, unticked and ticked (ticks as a
  JSON string: `s.site = JSON.stringify({header: true, footer: true})` or `replay --site`).
