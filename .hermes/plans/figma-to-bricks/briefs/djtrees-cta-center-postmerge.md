# Role: POST-MERGE FINISHER — djtrees-cta-center (DJ Trees designer note 3)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-postmerge-common.md` first and follow it.

**Load: the computer crashed twice under load. One Chrome at a time; nothing in parallel.**

- Job: djtrees-cta-center; plan `docs/plans/2026-11-02-djtrees-cta-center.md`; ledger
  `.superpowers/sdd/2026-11-02-djtrees-cta-center/progress.md` → `docs/plans/2026-11-02-djtrees-cta-center-ledger.md`.
- Expected merged main head: `1a6437862fb207bfd78310e6bc75d2024c9f4367` (root fast-forwarded main from `1424081`).
  Root holds the merge lock as `djtrees-cta-center`.
- `ac-check.sh`: READY FOR THE USER (verifier + blind auditor on `1a64378`, base `1424081`); review-1 clean on the
  pre-rebase head; AC11 live (paste check **3cl**). The HANDOFF heading says "build set at the merge": put the new
  BUILD there. Add the follow-ups in `~/.hermes/plans/figma-to-bricks/evidence/djtrees-cta-center/follow-ups.md` to the
  section's Deferred list in one or two lines each if they aren't there.
- **Extra gate (the verification skipped it for load):** after `npm run build`, run the whole browser suite once on main
  (`npm run test:browser` with the Chrome wrapper from djtrees-common.md, nothing else running in it) and compare it by
  test name with the builder's full-suite run in `~/.hermes/plans/figma-to-bricks/evidence/djtrees-cta-center/builder/`
  (the same 10 pre-existing machine failures are expected: fonts, nudged rows, breadcrumbs, pills). Report any new
  failure before committing and stop if there is one.
- Commit message: `Build <BUILD>: DJ Trees phone buttons centred (djtrees-cta-center)`.
- CLAUDE.md lines:
  - Status, at the top of the feature list: `- **<BUILD> djtrees-cta-center:** on phones a stretched call-to-action pill
    centres its words and icon together; a pill's own hover layer never wraps it. Paste check **3cl**.`
  - Under "Decisions the user made" → the phone rules, after "Every call-to-action button is full width on phones…":
    `- **Stretched buttons centre their content** (DJ Trees designer note 3, 2026-11-02; the planner's ⭐ answers under
    Justin's "whatever the planner agent recommends", not yet confirmed): from 767 down a call-to-action pill Figma
    draws with its content in the middle centres its words and icon together (rule cta.center), long words wrapping onto
    centred lines; buttons drawn off-centre keep their drawing; tablets and desktops unchanged.`
