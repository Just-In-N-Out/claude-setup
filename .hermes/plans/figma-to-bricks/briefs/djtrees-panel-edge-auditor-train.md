# Role: AC AUDITOR (blind) — djtrees-panel-edge (merge-train car 6)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-auditor-common.md` first and follow it.

**MACHINE RULE (the PC froze 3 times under overlapping Chrome runs):** follow djtrees-common's "One Chrome-driven run"
rule exactly, including the shared `flock ~/.cache/f2b-chrome.lock` and the node-named lock process.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-panel-edge` (you write only `E/auditor/`).
- Approved plan: `E/plan-approved.md`. Inject the DJ fonts for any real-file measurement (djtrees-common "Fonts").
- **head** `f425e79c52eef094b94033ad96fbbae0705d8a50`, **base** `5b312ae24ebe2ad7138d604bc82ca17a396e7032` (the commit
  this job sits on in the merge train). Use your own worktree, detached at the head, as `ac-check --repo`.
