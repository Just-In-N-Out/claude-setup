# Role: POST-MERGE FINISHER — djtrees-phone-headline (DJ Trees designer note 11)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-postmerge-common.md` first and follow it.

- Job: djtrees-phone-headline; plan `docs/plans/2026-11-02-djtrees-phone-headline.md`; ledger
  `.superpowers/sdd/2026-11-02-djtrees-phone-headline/progress.md` → `docs/plans/2026-11-02-djtrees-phone-headline-ledger.md`.
- Expected merged main head: `4a403053108b1783c797366e20a948ad2276d81d` (root fast-forwarded main from `1aef12f`).
  Root holds the merge lock as `djtrees-phone-headline`.
- `ac-check.sh` said READY FOR THE USER: AC1–AC7 accepted by verifier and blind auditor on `4a40305`, review-1 clean;
  AC8 live (paste check **3ct**) owed to Justin. Follow-ups (P3) are in
  `~/.hermes/plans/figma-to-bricks/evidence/djtrees-phone-headline/follow-ups.md`: add them to the job's HANDOFF
  section under "Deferred" in one or two lines if they aren't there.
- Commit message: `Build <BUILD>: DJ Trees phone headings (djtrees-phone-headline)`.
- CLAUDE.md lines (from the builder's ledger, Task 7):
  - Status, at the top of the feature list: `- **<BUILD> djtrees-phone-headline:** big headings of two or more words
    are at most 72px upright and 93px sideways on phones; a tight one opens to line height 1 where its words wrap into
    more lines than drawn. Paste check **3ct**.`
  - Under "Decisions the user made" → Layout/phone rules: `- **Big multi-word headings on phones** (DJ Trees designer
    note 11, 2026-11-02; the planner's ⭐ answers under Justin's "whatever the planner agent recommends", not yet
    confirmed): a text of two or more words is at most 72px upright and 93px sideways (21% of the narrowest column; one
    word keeps its step); one drawn at 28px+ tighter than line height 1 gets line height 1 from the widest tier where
    its words wrap into more lines than Figma drew (facts.ts displayCap/wrapsMore, rule type.leading).`
