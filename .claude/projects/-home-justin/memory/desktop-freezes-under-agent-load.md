---
name: desktop-freezes-under-agent-load
description: Windows desktop (WSL) froze 3x on 2026-11-02 while 12-20 agents ran headless Chrome; how it was diagnosed
metadata:
  node_type: memory
  type: project
  originSessionId: e5a1527c-585d-48af-b8f6-3d135a64017d
  modified: 2026-11-02T21:26:04.834Z
---

On 2026-11-02 the Windows desktop (32 GB RAM, `.wslconfig` memory=26GB swap=8GB) froze three times (13:43, 14:44, 15:08) while two FigmaToBricksV2 sessions ran 12-20 Opus agents at once, each launching headless Chrome via per-agent `chrome.sh` wrappers (~1,900 Chrome launches in one boot). No blue screen (Kernel-Power 41, BugcheckCode=0, power button pressed), no Linux OOM kill; the last journal lines of each boot were "Under memory pressure" plus Chrome launches. Two more froze at 15:31 and 16:17 with only 8-14 agents and no Linux memory-pressure lines, so the cause is unproven: either Windows starving (WSL's page cache isn't pressure inside Linux but is real RAM on Windows) or hardware/driver instability under load. Suspects: MSI Center + SignalRGB (their services crashed or delayed shutdown that day), XMP. 7 hard freezes since 2026-10-26. Host: i9-12900KF, 2x16GB in 2 of 4 slots (max 64GB). ExpressVPN services crash-loop ~10/min all day (event-log noise).

**Why:** the user reports these as "Claude keeps crashing when running agents"; it is the whole PC freezing, not Claude Code.

**How to apply:** for a crash report on the desktop, check `uptime`, `journalctl --list-boots` and the tail of each boot, then Windows events 41/6008/1074 via `powershell.exe Get-WinEvent` (run from `/mnt/c`). Fixes offered: a lower WSL memory cap, a cap on agents running at once.
