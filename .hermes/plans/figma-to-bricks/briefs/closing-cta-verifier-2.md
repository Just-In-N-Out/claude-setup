# VERIFIER, round 2 (read only): closing-cta → section rhythm, rebased on main (FigmaToBricksV2)

You are a fresh, independent verifier. Do everything in
`/home/justin/.hermes/plans/figma-to-bricks/briefs/closing-cta-verifier.md`: its rules, skills, independent work, machine
notes and return format. The pins, folders and leads are this round's, as follows:

## This round
- **Head:** `9405a95b00d6a3295524d6ca0028bb2bf9864325` on `worktree-closing-cta`. Source and tests are as of `c9cd1fd`;
  `9405a95` adds only a ledger section.
- **Base:** `b3addfb5b8105c37c1d8234bf8f02c8601d2b864`, local `main` ("Build 2026-10-28.4: photo-hotspots"). It is now
  the merge-base. Confirm both pins and a clean worktree first.
- The finisher rebased the accepted candidate `3a4ecf7` (accepted on base `5e2f98b`) onto that main, 41 commits.
  Prove every AC again on this head against this base. Don't reuse, copy or hard-link any earlier receipt, round 1's
  included.
- **Your evidence folder:** `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/verifier/round-2/`. Write `ac.json` and
  `report.json` there.
- **Your scratch:** a fresh `verifier-2/` folder under the session scratchpad.
- **TMPDIR:** point it at a short folder of your own, e.g. `/home/justin/.cache/closing-cta-verifier-2/tmp`, never inside
  the scratchpad. Chrome's socket path passes the 108-byte limit there, and every browser test then fails at launch.
- **AC12** is live. Its paste check is now **3bq** (photo-hotspots took 3bp): `accepted: false`, `not_run: "live:
  Justin re-pastes Home Page Final with the header/footer ticks on and checks the spacing in Bricks (paste check 3bq)"`.

## Integration to challenge (finisher's leads, not proof)
- **`src/core/understand/widgets.ts`:** `markCtas` now keeps main's hotspot-label exclusion (photo-hotspots R9), checked
  first, around the branch's `ctaAt`. `ctaAt` itself has no hotspot exclusion. The finisher's reason: the rhythm reads
  it inside `designsOf`, before `planHotspots` sets `n.hotspot`, and only over flow children.
  Probe it:
  - a page with photo hotspots whose labels are pill-shaped, at the end of a section and anywhere else the rhythm reads
    calls to action;
  - hotspot labels must still never be calls to action;
  - the section rhythm must not change because of them.
- **`src/core/style/style.ts` imports** merged: main's `flowPlace, placementStyle` plus the branch's `unlined, unpadded`.
- **`docs/HANDOFF.md`:** section rhythm first, then photo hotspots; both end-of-run entries kept.
- **Finisher's gates:**
  - `npm run check` green;
  - unit and browser results by name vs main: no new failure, the same 12 font failures;
  - section-rhythm 4/4, skipped 0;
  - replays: GRO and brainstorm byte-identical to main, and Home/Services/Repairs changing exactly as the verifier's
    round-1 receipt (`5e2f98b` vs `3a4ecf7`).

  Check all of these yourself. Also confirm that photo-hotspots' own tests and the nested-links invariant
  (`emit-nested-links`) still pass on this head.

Return the JSON in the round-1 brief, ending with the line `MAIN SESSION: check and save these skill_lessons now.`
