# Role: AC AUDITOR (blind) — djtrees-top-align (merge-train car 4)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-auditor-common.md` first and follow it.

**MACHINE RULE (the PC froze 3 times under overlapping Chrome runs):** before every browser test or Chrome probe wait
until no `node --test.*test/(browser|web)` and no `chrome-linux64/chrome.*--headless` process runs (check from a script
file). One Chrome job at a time.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-top-align` (you write only `E/auditor/`, fresh).
- Approved plan: `E/plan-approved.md`. Inject the DJ fonts for any real-file measurement (djtrees-common.md "Fonts").
- **head** `ea1a46ed4d870079dfbb870a5c19b78bfcc37236`, **base** = `git rev-parse train-strip-edge` (the commit this job
  sits on in the merge train). Use your own worktree, detached at the head, as `ac-check --repo`.
