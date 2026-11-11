---
name: desktop-stuck-mouse-under-load
description: "On the Windows desktop under heavy agent load, the mouse stops clicking outside the terminal; Ctrl+Alt+Del then Esc fixed it (2026-11-10)"
metadata:
  node_type: memory
  type: reference
  originSessionId: 814c0aaa-3738-42a4-b985-4693fd9cb94c
  modified: 2026-11-11T02:29:46.136Z
---

On 2026-11-10 the Windows desktop's mouse stopped working: clicks in the terminal only highlighted text, and clicks outside the terminal (the tab bar, other windows) did nothing. Keyboard tab switching (Ctrl+Tab, Ctrl+Shift+Tab, Ctrl+Alt+<n>) still worked. At that moment the Windows log (`/mnt/c/Users/Admin/crashlog/windows-<date>.log`) showed CPU at 91–97%, 2.8 GB free and `wsl_vm` at 19.5 of its 20 GB cap. The Linux load was 63 on 24 cores, mostly other sessions' headless Chrome tests.

**Fix that worked:** Ctrl+Alt+Del, then Esc. This closes nothing (just avoid Sign out and the power menu on that screen). If it doesn't work, restart Windows Explorer from Task Manager.

**How to apply:** when Justin reports the mouse or terminal "glitched" on the desktop, read the last lines of the Windows crashlog and `uptime` first, then suggest the steps above. Related: [[docker-desktop-crash-wsl]], the "Windows Desktop: Runaway Memory" section of `~/.claude/CLAUDE.md`.
