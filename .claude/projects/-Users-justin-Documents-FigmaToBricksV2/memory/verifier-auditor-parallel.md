---
name: verifier-auditor-parallel
description: "FigmaToBricksV2 since 2026-11-14 night: start the blind AC auditor at the same time as the verifier, not after it"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 67456e97-9f8e-4083-928f-7bcdbe7e3240
  modified: 2026-11-15T03:23:45.765Z
---

Start the blind AC auditor in parallel with the verifier on the same head (both after `MOVE ON`), not after the verifier comes back clean. If the verifier finds a problem, the auditor's run is thrown away and both run again after the fix.

**Why:** Justin, 2026-11-14 ~22:30, after "28 hours and only 3 merges": chose "Checks side by side" out of three speed-ups. He did NOT pick "one merge queue" or "auditor runs only touched tests" (he still wants both full runs; see [[finish-before-starting]]). Each check takes 1.5–2 h; running them one after the other cost 3–4 h per job per round.

**How to apply:** on `MOVE ON`, dispatch the verifier and the blind auditor in the same message, each in its own folder and worktree; the auditor brief says a verifier works on the same head at the same time and never to read its folder. Run `ac-check.sh` once both return. This overrides the global CLAUDE.md order ("Clean → a fresh AC auditor") for this project only.
