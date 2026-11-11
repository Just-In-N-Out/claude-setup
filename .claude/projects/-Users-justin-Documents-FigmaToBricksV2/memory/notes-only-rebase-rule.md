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

**How to apply:** any conflict in a source or test file still takes the full path (review → verifier → auditor →
ac-check). Related: [[review-round-cap]], [[run-without-stopping]].
