---
name: notes-only-rebase-rule
description: Justin's rule (2026-11-11) — a rebase whose only conflict is docs/HANDOFF.md (both sides word for word, code identical) needs a short review + a re-run of every AC test, not a new verifier and auditor
metadata:
  type: feedback
---

When a finished FigmaToBricksV2 job is moved onto a newer main and the **only** conflict is in the notes file
(`docs/HANDOFF.md`, or the ledger), with both sides kept word for word and the code byte-identical to the accepted head's
diff, it needs only: a short delta review proving code identity and whole notes (MOVE ON on the new head), plus a re-run of
every agent-run AC's cited test on the new head (a receipt). **No new verifier or blind auditor.** `ac-check.sh
--rebase-receipt` still prints `REBASE NOT ACCEPTED` for such a move (patch-id changes with HANDOFF context lines); the
session records the review, the receipt and this rule in the job's follow-ups and merges.

**Why:** Justin chose it in a question (2026-11-11, site-scroll-lock): nearly every merge now hits a HANDOFF-only conflict
(every job adds its section at the top), and a fresh verifier + auditor cost 1–2 hours each time.

**Extended (Justin, 2026-11-11, site-menu-motion):** the same short path (a short review of the change + an AC test re-run) also covers a **test-only pin update** a merged feature forces after a rebase (e.g. a byte-for-byte pin compared without site-scroll-lock's lock class), when no source changes.

**Extended again (Justin, 2026-11-14, importer-app, "Review + re-run (Recommended)"):** also covers a test-only change to an AC's own test that a merged job forces (the test had faked that job's output by hand), when no source changes: a delta review checks the test keeps the plan's meaning and still fails on app mutants, plus the full AC re-run.

**How to apply:** any conflict or change in a source file, or a test change beyond such a pin or forced AC-test update, still takes the full path (review → verifier → auditor →
ac-check). Related: [[review-round-cap]], [[run-without-stopping]].

- 2026-11-16: jobs stacked on an unmerged head that later gets a source fix (native-widgets/page-faq-slide on look-grouping before its G3 fix) fail ac-check's rebase-receipt check after the merge even when their own commits are unchanged: budget one delta review (one reviewer can cover both stacked jobs, a review.json each) plus receipts, no new verifier/auditor.

**Code-identity proof detail (logo-media rebase, 2026-11-16):** compare `git diff <oldbase> <oldhead>` and `git diff <newbase> <newhead>` (HANDOFF left out) with `^index ` and `^@@ ` lines removed, plus each touched file's blob: plain cmp fails whenever the other job's lines sit above an unchanged hunk (only the blob hashes and hunk line numbers move); keep the headers-only diff as evidence.
