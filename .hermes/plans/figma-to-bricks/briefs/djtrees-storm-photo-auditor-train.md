# Role: AC AUDITOR (blind) — djtrees-storm-photo (merge-train car 2)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-auditor-common.md` first and follow it.

**Load: the computer crashed twice under load. Run one Chrome at a time, no parallel suites.**

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-storm-photo` (you write only `E/auditor/`, fresh;
  older audit folders are not yours to read).
- Approved plan: `E/plan-approved.md`. AC9's browser test needs `F2B_SIDE_PHOTO_FILE` set to the DJ Trees debug file.
- The job's worktree (for `ac-check --repo`, read only): `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-ac53eb23be45d2025`
- **head** `b0d8f65fe4d8bb0fc00f940445d1eac4cb92d697`; **base** = `1a6437862fb207bfd78310e6bc75d2024c9f4367` (the
  commit this job sits on in the merge train; use it as `--base`, and judge "only X differs" ACs against it).
