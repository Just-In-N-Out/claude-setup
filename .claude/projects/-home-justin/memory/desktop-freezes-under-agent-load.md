---
name: desktop-freezes-under-agent-load
description: Windows desktop (WSL) froze 3x on 2026-11-02 while 12-20 agents ran headless Chrome; how it was diagnosed
metadata:
  node_type: memory
  type: project
  originSessionId: e5a1527c-585d-48af-b8f6-3d135a64017d
  modified: 2026-11-02T21:59:33.343Z
---

On 2026-11-02 the Windows desktop (32 GB RAM, `.wslconfig` memory=26GB swap=8GB) froze three times (13:43, 14:44, 15:08) while two FigmaToBricksV2 sessions ran 12-20 Opus agents at once, each launching headless Chrome via per-agent `chrome.sh` wrappers (~1,900 Chrome launches in one boot). No blue screen (Kernel-Power 41, BugcheckCode=0, power button pressed), no Linux OOM kill; the last journal lines of each boot were "Under memory pressure" plus Chrome launches. Two more froze at 15:31 and 16:17 with only 8-14 agents and no Linux memory-pressure lines, so the cause is unproven: either Windows starving (WSL's page cache isn't pressure inside Linux but is real RAM on Windows) or hardware/driver instability under load. Suspects: MSI Center + SignalRGB (their services crashed or delayed shutdown that day), XMP. 7 hard freezes since 2026-10-26. Host: i9-12900KF, 2x16GB in 2 of 4 slots (max 64GB). ExpressVPN services crash-loop ~10/min all day (event-log noise).

**Why:** the user reports these as "Claude keeps crashing when running agents"; it is the whole PC freezing, not Claude Code.

**Cause found 16:53 (crashlogs):** one `node` process went 0→17 GB in 12 s, 3 s after a builder ran `mutate.ts` (mutation testing, no memory cap); Linux used all of its 20 GB plus 7.7 of 8 GB swap and locked up, while Windows kept 5 GB free and stayed up. Mutation runs also preceded the 15:31 and 16:17 freezes. More RAM won't fix a runaway like this; the fix is a killer for runaway memory (earlyoom, offered) plus per-mutant `systemd-run` caps (skill lesson saved).

2026-11-02 changes: `.wslconfig` memory 26GB→20GB (backup `.wslconfig.bak-2026-11-02`); 5-second memory loggers write `~/crashlog/linux-<date>.log` (`~/.local/bin/crash-logger.sh`, user service `crash-logger`) and `C:\Users\Admin\crashlog\windows-<date>.log` (`log-memory.ps1`, scheduled task `CrashMemoryLogger`). Auto-start was left for Justin to switch on (the auto-mode classifier blocks Claude from adding persistence).

**How to apply:** after the next freeze, read the last lines of both crashlogs first: Windows `free` near 0 or high `pages/s` means memory (RAM upgrade worth it); normal numbers point to hardware/drivers. Otherwise, for a crash report on the desktop, check `uptime`, `journalctl --list-boots` and the tail of each boot, then Windows events 41/6008/1074 via `powershell.exe Get-WinEvent` (run from `/mnt/c`). Fixes offered: a lower WSL memory cap, a cap on agents running at once.
