---
name: commands-for-justin-to-run
description: "When handing Justin commands to run himself, name the exact window and give one line"
metadata:
  node_type: memory
  type: feedback
  originSessionId: e5a1527c-585d-48af-b8f6-3d135a64017d
  modified: 2026-11-03T00:50:12.113Z
---

When Justin has to run a command himself, say which window it goes in (Claude prompt with `!`, Ubuntu terminal, or Windows PowerShell) and give the version for that window, as a single line joined with `&&` when it uses `sudo`.

**Why:** on 2026-11-02 he pasted a `! systemctl …` line into PowerShell (it only works in the Claude prompt), and a three-line `sudo` block pasted at once fed the later lines into the password prompt, so the install failed until it was one line. On 2026-11-13 a five-line DiskPart block pasted at once was glued into one line ("arguments not valid").

**How to apply:** for Windows-side steps, give PowerShell syntax (`wsl …` for Linux commands); for `sudo`, one `&&` line in the Ubuntu terminal. For interactive prompts that can't take `&&` (DiskPart, password prompts), give each command in its own code block and say "one at a time". Related: [[desktop-freezes-under-agent-load]].
