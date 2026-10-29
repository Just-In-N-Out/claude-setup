---
name: review-prompt-for-agent
description: "After building a story (and after each round of fixes), always give Justin a paste-ready prompt for a fresh agent to independently double-check the work"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2fe303d7-90b7-4c97-a578-b1d2535f94fa
  modified: 2026-10-29T18:00:00.000Z
---

After I finish building a user story, and again after each round of review fixes, always give Justin a paste-ready prompt he can hand to a fresh agent to double-check the work. Don't wait to be asked.

**Why:** Justin asked on 2026-09-27: "always make a prompt that I will give to an agent to double check the work". He runs this loop on every story: two review rounds on 86bbu3xr4 found a real blocker (a double-click provisioned 10 databases) and a pool-stall risk that my own checks missed.

**How to apply:** The prompt must be self-contained, because the reviewer starts with no context:
- say "don't trust anyone's summary or the shared memory; check it yourself", and "review only: no commit, push, PR or ClickUp changes; restore anything you change; leave `deploy/local/` alone";
- the repo, branch, commit range and whether it's pushed (if it's local only, the agent must run on this Mac); how to get the code: a detached worktree at the head SHA, or `gh pr checkout <n>` in the reviewer's own clone, never a checkout in `~/Leorna/<repo>`, whose branch sibling sessions share (901y post prep);
- the full card text: acceptance criteria, Verify, DoD, card notes, plus decisions Justin already made ("check they're implemented, don't re-argue them");
- for a re-review, list the previous findings and the claimed fix for each;
- exact commands to run (Docker/test DB, `LEORNA_TEST_DATABASE_URL`, `-v` to confirm nothing skipped, `make check`, module-add, story tests);
- specific mutations to try, noting that each break must still compile, and any known trap (e.g. fake-granting a lock still holds a pooled connection);
- security, tenant isolation, docs claims true as written, stories.json PR numbers real, commit authorship/no AI lines, merge risk with main;
- report format: one-line verdict, per-AC/DoD table with evidence, real command output, mutation results, issues labelled introduced/pre-existing with severity.

**Status 2026-10-22 (Hermes):** dispatched stories now get two automatic reviewers (Opus 5.5 xhigh + Sol 6.1 xhigh, full review each). Justin chose to **keep this prompt as a third check** he runs himself, so still hand it over every time.

When he brings the report back, verify each finding in code before acting (receiving-code-review skill), fix the valid ones test-first, and explain any pushback. Related: [[stop-and-show-diff]], [[story-done-team-message]], [[leorna-workflow]].
