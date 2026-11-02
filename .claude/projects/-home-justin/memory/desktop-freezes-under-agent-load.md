---
name: desktop-freezes-under-agent-load
description: Windows desktop (WSL) froze 3x on 2026-11-02 while 12-20 agents ran headless Chrome; how it was diagnosed
metadata:
  node_type: memory
  type: project
  originSessionId: e5a1527c-585d-48af-b8f6-3d135a64017d
  modified: 2026-11-02T20:22:07.352Z
---

On 2026-11-02 the Windows desktop (32 GB RAM, `.wslconfig` memory=26GB swap=8GB) froze three times (13:43, 14:44, 15:08) while two FigmaToBricksV2 sessions ran 12-20 Opus agents at once, each launching headless Chrome via per-agent `chrome.sh` wrappers (~1,900 Chrome launches in one boot). No blue screen (Kernel-Power 41, BugcheckCode=0, power button pressed), no Linux OOM kill; the last journal lines of each boot were "Under memory pressure" plus Chrome launches. Likely cause: WSL may take 26 of 32 GB, so Windows starves and freezes before Linux kills anything. ExpressVPN services were also crash-looping ~10/min all day (unrelated noise in the event log).

**Why:** the user reports these as "Claude keeps crashing when running agents"; it is the whole PC freezing, not Claude Code.

**How to apply:** for a crash report on the desktop, check `uptime`, `journalctl --list-boots` and the tail of each boot, then Windows events 41/6008/1074 via `powershell.exe Get-WinEvent` (run from `/mnt/c`). Fixes offered: a lower WSL memory cap, a cap on agents running at once.
