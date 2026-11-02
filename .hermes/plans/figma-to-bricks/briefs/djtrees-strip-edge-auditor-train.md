# Role: AC AUDITOR (blind) — djtrees-strip-edge (merge-train car 3)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-auditor-common.md` first and follow it.

**MACHINE RULE (the PC froze 3 times under overlapping Chrome runs):** before every browser test or Chrome probe,
wait until no `node --test.*test/(browser|web)` and no `chrome-linux64/chrome.*--headless` process runs (check from a
script file). One Chrome job at a time.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-strip-edge` (you write only `E/auditor/`).
- Approved plan: `E/plan-approved.md`.
- **head** = `git rev-parse train-strip-edge` (`779c830c…`), **base** `9a2a9667d1100cf5e8b4e66a380be661841114f5`. Use
  your own worktree, detached at the head, as `ac-check --repo`.
