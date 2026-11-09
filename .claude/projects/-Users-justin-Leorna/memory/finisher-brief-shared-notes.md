---
name: finisher-brief-shared-notes
description: In Leorna finisher briefs, say the "never edit skills or memory" rule covers skill lessons only; the dated story-status line in leorna-workflow.md is allowed
metadata:
  type: feedback
---

When writing a Leorna finisher brief, state that the `skill_lessons` rule ("never edit skills or memory yourself") covers skills and lessons only, and that the finisher may add a dated story-status line to the shared `leorna-workflow.md` notes (the `leorna` skill keeps story state there).

**Why:** 86bccndx6 finisher 2 (2026-11-08) got both "update the Leorna shared notes" and "never edit skills or memory" and had to choose; it wrote the line and flagged it.

**How to apply:** put one sentence in every finisher brief's Report section; the status line is fine to keep.

Also: a publish brief must apply the `leorna` rule that the ClickUp evidence is posted only once the PR is merged (step 7.9, `clickup-evidence.md`, Justin 2026-11-08). When Justin says "push, PR and post" together, brief the finisher to push and open the PR and to hold the post; the main session posts after the merge and main's push CI. (86bccndx6 PR finisher, 2026-11-08: my brief said post now; the finisher rightly held it.)

**"Make a PR" means a complete PR (Justin, 2026-11-08):** "when creating a pr you make sure it works and everything is good". The `leorna` step 7.8 PR-number record (the PR in `delivery/stories.json`, the "in review" wording) is part of making the PR: brief the finisher to open the PR, make that commit, have it reviewed, push it, and wait for CI on that head, all before reporting the PR as ready. Never offer it as an optional follow-up. (86bccndx6: I offered it after #115 opened; Justin merged first, and the record commit was dropped.)
