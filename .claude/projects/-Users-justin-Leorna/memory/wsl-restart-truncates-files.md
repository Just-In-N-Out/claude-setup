---
name: wsl-restart-truncates-files
description: A WSL restart on the desktop leaves files written just before it at 0 bytes; check receipts and scratch inputs before reusing them after an interrupted run
metadata:
  node_type: memory
  type: reference
  originSessionId: e3537075-7b25-4c2b-a45d-3e318d6f86d8
  modified: 2026-11-09T23:40:39.227Z
---

On the Windows desktop, a WSL restart (seen 2026-11-09 at about 18:32, not an earlyoom kill, with memory fine) left files written in the minutes before it at **0 bytes**. That hit evidence logs and also the inputs agents had copied: overlay JSON, copied Go source, a scratch `sync.js`. Logs finished a few minutes earlier were intact.

**Why it matters:** an empty copied source file gives a false RED or a build failure, not a real result. An empty receipt looks like a run that never finished.

**How to apply:** after an interrupted run, or when you resume a stopped agent, check every file from the last minutes for size 0 or a missing `EXIT=` line before reusing it. Rerun only those files. Tell resumed agents to do the same (86bctmuwy fixer 3 did, and kept its intact `EXIT=0` logs). Running `sync` after writing receipts lowers the risk.

Related: [[resuming-stopped-sessions]], [[docker-desktop-crash-wsl]]
