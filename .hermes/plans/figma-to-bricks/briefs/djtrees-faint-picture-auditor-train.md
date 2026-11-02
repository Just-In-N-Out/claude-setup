# Role: AC AUDITOR (blind) — djtrees-faint-picture (merge-train car 5)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-auditor-common.md` first and follow it.

**MACHINE RULE (the PC froze 3 times under overlapping Chrome runs):** before every browser test or Chrome probe wait
until no `node --test.*test/(browser|web)` and no `chrome-linux64/chrome.*--headless` process runs (check from a script
file). One Chrome job at a time.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-faint-picture` (you write only `E/auditor/`).
- Approved plan: `E/plan-approved.md`.
- **head** `5b312ae24ebe2ad7138d604bc82ca17a396e7032`, **base** `ea1a46ed4d870079dfbb870a5c19b78bfcc37236` (the commit
  this job sits on in the merge train). Use your own worktree, detached at the head, as `ac-check --repo`.
