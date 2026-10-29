---
name: review-loop-until-clean
description: "Justin wants review→fix to loop until a fresh review finds no high-priority (P0/P1) bugs AND every AC passes, not stop after two reviews"
metadata:
  node_type: memory
  type: feedback
  originSessionId: f6b994e6-c6fe-49bc-9b5d-e4bfdad8588b
  modified: 2026-10-29T00:19:11.575Z
---

Justin wants the pipeline's review→fix to loop until a fresh reviewer finds no bugs and every AC is accepted. The fixed count of two reviews is not enough.

**Why:** on 2026-10-28, in story harness-guards, after the two reviews, fix rounds 2–4 shipped code nobody reviewed. Fixer 3 found two new bugs by luck. Justin said: "I want to keep it looping until there are no bug errors found and all acceptance criteria are met."

**How to apply** (until a pipeline story writes this into CLAUDE.md, feature-dispatch and review-fix-cadence):
- After every fix round, dispatch a fresh reviewer on every commit since the last clean review.
- "Clean" means no **high-priority** findings, P0 or P1: a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. Justin added: "I just need it to find bug errors that are high priority."
- A review with only P2/P3 findings counts as clean, and those go on the story's follow-up list. When a round already has P0/P1 findings, its fixer also fixes that review's lower ones.
- No round cap. Ask Justin only when the same finding or AC repeats with no new fact, or a round finds as many serious issues as the one before.
- Verifier → auditor → `ac-check.sh` runs only after a clean review. Any fix after that gets a fresh review again before re-verifying.
