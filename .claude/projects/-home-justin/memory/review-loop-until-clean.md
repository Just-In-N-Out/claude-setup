---
name: review-loop-until-clean
description: "Justin wants review→fix to loop until a fresh review finds no P0–P2 bug (realistic edge cases included) AND every AC passes, with brakes so it ends"
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
- **"Clean"** means no P0, P1 or P2 finding: no bug a real person or agent could plausibly hit. That includes realistic edge cases (inputs, configs, git operations, both machines: macOS and WSL), anything that breaks an AC, and anything in the UI.
- **P3** goes on the story's follow-up list: cosmetic, docs, a hole only a deliberate evasion would hit, or a setup none of Justin's machines has.
- **Brakes, so the loop always ends:**
  - (a) every finding must name a concrete real-use scenario, and with no scenario it is P3;
  - (b) review 3 onward covers only the fix commits since the last review and what they touch;
  - (c) if a round finds no fewer P0–P2 findings than the round before, stop and ask Justin;
  - (d) the same finding twice with no new fact → ask Justin.
  There's no fixed round cap.
- Justin, 2026-10-28: first "only high-priority bugs", then switched to this. His words: "help out a ton, but isn't going to be infinite."
- Verifier → auditor → `ac-check.sh` runs only after a clean review. Any fix after that gets a fresh review again before re-verifying.
