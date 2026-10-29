# BLIND AC AUDITOR, round 2 (read only): closing-cta → section rhythm, rebased on main (FigmaToBricksV2)

You are a fresh blind auditor. Do everything in
`/home/justin/.hermes/plans/figma-to-bricks/briefs/closing-cta-auditor.md`: its blindness rules, inputs, skills, work,
machine notes and report format. The pins and folders are this round's, as follows:

- **Head:** `9405a95b00d6a3295524d6ca0028bb2bf9864325` on `worktree-closing-cta`.
- **Base:** `b3addfb5b8105c37c1d8234bf8f02c8601d2b864`, local `main` and the merge-base.
- Confirm both pins and a clean worktree first. The branch was rebased onto that main, which holds another feature
  (photo hotspots); prove every AC on this head against this base.
- **Your evidence folder:** `/home/justin/.hermes/plans/figma-to-bricks/evidence/closing-cta/auditor/round-2/`. Write
  `ac.json` and `report.json` there.
- **Never open** any other folder under `evidence/closing-cta/`, round 1's auditor folder included, or any other role's
  brief. Every receipt is your own.
- **Your scratch:** a fresh `auditor-2/` folder under the session scratchpad.
- **TMPDIR:** point it at a short folder of your own, e.g. `/home/justin/.cache/closing-cta-auditor-2/tmp`, never inside
  the scratchpad. Chrome's socket path passes the 108-byte limit there, and every browser test then fails at launch.
- **AC12** is live. Its paste check is now numbered **3bq** (another feature took 3bp): `accepted: false`, `not_run:
  "live: Justin re-pastes Home Page Final with the header/footer ticks on and checks the spacing in Bricks (paste check
  3bq)"`.
- Also check that this head keeps main's own behaviour where the plan doesn't change it. Labels placed on photos (photo
  hotspots) must never become calls to action or change a section's spacing.

Return the report in the round-1 brief's format, ending with the line `MAIN SESSION: check and save these skill_lessons
now.`
